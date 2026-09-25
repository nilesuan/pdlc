#!/usr/bin/env bash
# Negative + positive tests for verify-artifact.sh's relative-link gate.
#
# Why this exists: LESSON-0005 — "a control that can fail silently MUST have a
# test that makes it speak." The link gate fails open in both directions. If the
# code-fence masking added on 2026-09-18 over-reached, every broken link in the
# repo would silently report broken=0 and the gate would be inert. Case 1 and
# case 5 are the tests that make it speak.
set -u

GATE="$(dirname "$0")/verify-artifact.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0
fail=0

check() { # name expected_broken file
  local name="$1" want="$2" file="$3" got
  got=$(bash "$GATE" "$file" 2>/dev/null | sed -n 's/^RESULT broken=\([0-9]*\).*/\1/p')
  if [ "$got" = "$want" ]; then
    printf 'ok   %-52s broken=%s\n' "$name" "$got"; pass=$((pass + 1))
  else
    printf 'FAIL %-52s broken=%s want=%s\n' "$name" "$got" "$want"; fail=$((fail + 1))
  fi
}

# 1. THE TEST THAT MAKES IT SPEAK: a real broken link in ordinary prose.
printf '# t\n\nSee [the plan](no-such-file.md).\n' > "$TMP/a.md"
check "broken link in prose is reported" 1 "$TMP/a.md"

# 2. Link syntax inside a fenced block is literal text, not our link.
printf '# t\n\n```\n* Released under the [MIT license](LICENSE.txt).\n```\n' > "$TMP/b.md"
check "fenced quote does not count as a link" 0 "$TMP/b.md"

# 3. Same for a tilde fence and a language-tagged fence.
printf '# t\n\n~~~text\n[x](nope.md)\n~~~\n\n```md\n[y](nope.md)\n```\n' > "$TMP/c.md"
check "tilde and tagged fences are masked" 0 "$TMP/c.md"

# 4. Inline code span.
printf '# t\n\nWrite `[label](target.md)` to link.\n' > "$TMP/d.md"
check "inline code span is masked" 0 "$TMP/d.md"

# 5. THE SECOND TEST THAT MAKES IT SPEAK: masking must not swallow prose that
#    follows a fence, or the gate goes inert for the rest of the file.
printf '# t\n\n```\n[a](in-fence.md)\n```\n\nSee [b](also-missing.md).\n' > "$TMP/e.md"
check "broken link AFTER a fence is still reported" 1 "$TMP/e.md"

# 6. A link that resolves is not reported.
: > "$TMP/real.md"
printf '# t\n\nSee [real](real.md).\n' > "$TMP/f.md"
check "resolvable relative link passes" 0 "$TMP/f.md"

# 7. An unterminated fence must not blank the rest of the file silently AND
#    must not resurrect the masked content as links.
printf '# t\n\n```\n[a](in-fence.md)\n' > "$TMP/g.md"
check "unterminated fence masks to EOF" 0 "$TMP/g.md"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
