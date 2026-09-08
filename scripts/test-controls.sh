#!/usr/bin/env bash
# test-controls.sh — negative tests for every control this system defines.
#
# Required by lessons/2026/LESSON-0005-silent-control-needs-a-negative-test.md:
# "A control that can fail silently MUST have a test that makes it speak."
#
# Each control is fed input it is supposed to reject, and the rejection is
# asserted. Existence of a file is not evidence that it works; prose describing
# a guard is not evidence that the guard fires.
#
# Usage: bash scripts/test-controls.sh    (exit 0 = every control speaks)

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
PASS=0; FAIL=0
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

ok(){ PASS=$((PASS+1)); printf '  ok   %s\n' "$1"; }
no(){ FAIL=$((FAIL+1)); printf '  FAIL %s\n     expected: %s\n     actual:   %s\n' "$1" "$2" "$3"; }
eq(){ if [ "$2" = "$3" ]; then ok "$1"; else no "$1" "$2" "$3"; fi; }
section(){ printf '\n== %s ==\n' "$1"; }

# ---------------------------------------------------------------------------
section "guard-dangerous-bash.sh rejects the CLAUDE.md section 4 non-negotiables"
g(){ printf '{"tool_name":"Bash","tool_input":{"command":%s}}' "$1" \
     | bash scripts/guard-dangerous-bash.sh >/dev/null 2>&1; echo $?; }
eq "blocks terraform -auto-approve"      2 "$(g '"terraform apply -auto-approve"')"
eq "blocks tofu --auto-approve"          2 "$(g '"tofu apply --auto-approve"')"
eq "blocks git commit --no-verify"       2 "$(g '"git commit --no-verify -m x"')"
eq "blocks force-push to main"           2 "$(g '"git push --force origin main"')"
eq "blocks force-push -f to develop"     2 "$(g '"git push -f origin develop"')"
eq "allows benign git status"            0 "$(g '"git status"')"
# The shlex-tokenisation property documented at guard-dangerous-bash.sh line 13:
# a command that merely MENTIONS the flag inside a quoted string is not blocked;
# a bare --no-verify token in argv is a real flag and is blocked.
eq "allows a quoted mention of --no-verify" 0 "$(g '"echo \"never use --no-verify\""')"
eq "blocks a bare --no-verify token"        2 "$(g '"echo the flag --no-verify is banned"')"

# ---------------------------------------------------------------------------
section "verify-artifact.sh blocks on broken links (layer-6 gate)"
printf '# t\n\n[dead](./nope-does-not-exist.md)\n' > "$TMP/broken.md"
printf '# t\n\nno links here\n'                    > "$TMP/clean.md"
printf '# t\n\n[UNVERIFIED - a] [UNVERIFIED: b] [UNVERIFIED]\n' > "$TMP/tags.md"

bash scripts/verify-artifact.sh "$TMP/broken.md" >/dev/null 2>&1
eq "exits nonzero on a broken relative link" 1 "$?"
bash scripts/verify-artifact.sh "$TMP/clean.md" >/dev/null 2>&1
eq "exits zero on a clean artifact"          0 "$?"
# LESSON-0005 defect 2: the tally must count qualified forms, not the bare token only.
tag_count=$(bash scripts/verify-artifact.sh "$TMP/tags.md" 2>/dev/null | grep -o 'unverified=[0-9]*')
eq "counts qualified [UNVERIFIED - reason] forms" "unverified=3" "$tag_count"

# ---------------------------------------------------------------------------
section "verify-artifact-hook.sh speaks on bad input and fails open otherwise"
mkjson(){ printf '{"tool_name":"Write","tool_input":{"file_path":"%s"}}' "$1"; }

mkjson "/tmp/x.txt" > "$TMP/in1.json"
out=$(bash scripts/verify-artifact-hook.sh < "$TMP/in1.json" 2>/dev/null)
eq "silent on a non-markdown write" "" "$out"

mkjson "$TMP/broken.md" > "$TMP/in2.json"
decision=$(bash scripts/verify-artifact-hook.sh < "$TMP/in2.json" 2>/dev/null \
           | python3 -c 'import sys,json
raw = sys.stdin.read().strip()
print(json.loads(raw).get("decision","") if raw else "")' 2>/dev/null)
eq "emits decision:block on a broken-link markdown write" "block" "$decision"

mkjson "/tmp/definitely-absent-xyz.md" > "$TMP/in3.json"
out=$(bash scripts/verify-artifact-hook.sh < "$TMP/in3.json" 2>/dev/null)
eq "fails open on a nonexistent path" "" "$out"

printf 'not json at all' > "$TMP/in4.json"
out=$(bash scripts/verify-artifact-hook.sh < "$TMP/in4.json" 2>/dev/null)
eq "fails open on garbage stdin" "" "$out"

# ---------------------------------------------------------------------------
section "audit-log.sh records a correlatable session id (LESSON-0005 defect 3)"
printf '{"tool_name":"Bash","tool_input":{"command":"ls"}}' > "$TMP/in5.json"
PDLC_AUDIT_LOG="$TMP/audit.log" bash scripts/audit-log.sh < "$TMP/in5.json" >/dev/null 2>&1
eq "writes a record" "1" "$([ -s "$TMP/audit.log" ] && echo 1 || echo 0)"
tool=$(python3 -c 'import json,sys
print(json.loads(open(sys.argv[1]).readline()).get("tool",""))' "$TMP/audit.log" 2>/dev/null)
eq "record is valid JSON naming the tool" "Bash" "$tool"

# ---------------------------------------------------------------------------
section "shipped config is validated by a parser, not by review"
for f in settings.example.json \
         standards/frameworks/trigger-index.json \
         commands/split/assets/execution-plan.schema.json; do
  python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$f" >/dev/null 2>&1
  eq "$f parses" 0 "$?"
done

# ---------------------------------------------------------------------------
section "identifiers shared between a script and a document agree"
# LESSON-0005 defect 4: script and docs must name the same .pipeline.json path.
if grep -q 'cdocs/.pipeline.json' scripts/context-monitor.sh \
   && grep -q 'cdocs/.pipeline.json' agents/pass-runner.md; then p=1; else p=0; fi
eq "context-monitor.sh uses the documented cdocs/.pipeline.json path" "1" "$p"

missing_env=$(python3 <<'PYENV'
import io, json, re, subprocess
declared = set(json.load(io.open("settings.example.json"))["env"])
refs = set()
for f in subprocess.check_output(["git", "ls-files", "*.sh", "*.md"], text=True).split():
    if f.startswith("research/"):
        continue
    refs |= set(re.findall(r"\bPDLC_[A-Z0-9_]+\b",
                           io.open(f, encoding="utf-8", errors="ignore").read()))
print(",".join(sorted(refs - declared)))
PYENV
)
eq "every PDLC_* tunable is declared in settings.example.json" "" "$missing_env"

bad_specs=$(python3 <<'PYSPEC'
import json, os
d = json.load(open("standards/frameworks/trigger-index.json"))
print(sum(0 if os.path.exists(t["spec"]) else 1 for t in d["triggers"]))
PYSPEC
)
eq "every trigger-index.json spec file exists" "0" "$bad_specs"

# ---------------------------------------------------------------------------
section "the lesson loader can resolve every indexed lesson"
unresolved=$(python3 <<'PYL1'
import re, io, glob, os
idx = io.open("lessons/INDEX.md", encoding="utf-8").read()
active = re.findall(r"^\| (LESSON-\d+) \|.*\| active \|", idx, re.M)
have = set()
for f in glob.glob("lessons/**/LESSON-*.md", recursive=True):
    have.add(re.match(r"(LESSON-\d+)", os.path.basename(f)).group(1))
print(len([l for l in active if l not in have]))
PYL1
)
eq "every INDEX.md active row resolves to a file on disk" "0" "$unresolved"

unindexed=$(python3 <<'PYL2'
import re, io, glob, os
idx = io.open("lessons/INDEX.md", encoding="utf-8").read()
missing = 0
for f in glob.glob("lessons/**/LESSON-*.md", recursive=True):
    if "candidate" in f:
        continue
    if re.match(r"(LESSON-\d+)", os.path.basename(f)).group(1) not in idx:
        missing += 1
print(missing)
PYL2
)
eq "no promoted lesson is missing from the index" "0" "$unindexed"

# ---------------------------------------------------------------------------
printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
