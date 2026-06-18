#!/usr/bin/env bash
# PreToolUse Bash guard - hard-enforces the CLAUDE.md §4 non-negotiables.
#
# Reads the PreToolUse JSON on stdin, inspects tool_input.command, and exits 2
# (blocks the call and shows the reason to Claude) on any forbidden pattern.
# Guards three rules that were previously prose-only:
#   - terraform/tofu apply|destroy with --auto-approve  (never auto-approve locally)
#   - --no-verify as a real flag                         (never bypass hooks)
#   - git force-push to a shared branch (main/master/develop) (needs approval)
#
# The command is tokenized with shlex (proper shell parsing) so a flag is told
# apart from the same text inside a quoted argument - e.g. a commit MESSAGE that
# mentions "--no-verify" is NOT blocked, only an actual --no-verify flag is.
# Fails OPEN (exit 0) on parse error / empty command, so it cannot wedge work.
# Force-push to feature branches is intentionally allowed.

exec python3 -c '
import sys, json, shlex

try:
    cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
except Exception:
    sys.exit(0)
if not cmd or not cmd.strip():
    sys.exit(0)
try:
    toks = shlex.split(cmd)
except ValueError:
    sys.exit(0)
low = [t.lower() for t in toks]

def block(m):
    sys.stderr.write("BLOCKED by CLAUDE.md §4 guard: " + m + "\n")
    sys.exit(2)

if (any(t in ("terraform", "tofu", "opentofu") for t in low)
        and any(t in ("apply", "destroy") for t in low)
        and any(t in ("-auto-approve", "--auto-approve") for t in low)):
    block("terraform/tofu auto-approve is forbidden from a local machine. Review the plan and apply interactively.")

if "--no-verify" in low:
    block("--no-verify bypasses hooks. Fix the underlying hook failure instead of skipping it.")

shared = ("main", "master", "develop")
def is_shared(t):
    return t in shared or any(t.endswith("/" + b) or t.endswith(":" + b) for b in shared)

if ("git" in low and "push" in low
        and any(t in ("--force", "-f", "--force-with-lease") for t in low)
        and any(is_shared(t) for t in low)):
    block("force-push to a shared branch (main/master/develop) needs explicit user approval.")

sys.exit(0)
'
