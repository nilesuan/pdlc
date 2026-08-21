#!/usr/bin/env bash
# PostToolUse early-warning gate.
#
# Runs the pre-output gate (verify-artifact.sh) on authored Markdown the moment it is
# written, and feeds any broken-relative-link finding straight back to Claude. This is
# the layer-6 gate from standards/ANTI_HALLUCINATION.md, mechanized at the tool boundary
# instead of left to the pass-runner to remember.
#
# Wiring (settings.json): a PostToolUse hook with matcher "Write|Edit".
# Input: the PostToolUse JSON on stdin (tool_input.file_path holds the absolute path).
# Output: on a broken link, exit 0 with {"decision":"block","reason":...} which surfaces
# the finding to Claude. PostToolUse cannot undo the write; this is feedback, not a veto.
#
# Fails OPEN (exit 0, no-op) on any error: the pass-runner pre-output gate remains the
# authoritative check, so a hiccup here must never wedge normal editing.

payload="$(cat)"

file="$(printf '%s' "$payload" | python3 -c 'import sys, json
try:
    print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))
except Exception:
    pass' 2>/dev/null)"

# Only gate Markdown artifacts.
case "$file" in
  *.md) : ;;
  *) exit 0 ;;
esac
[ -f "$file" ] || exit 0

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -x "$dir/verify-artifact.sh" ] || [ -f "$dir/verify-artifact.sh" ] || exit 0

result="$(bash "$dir/verify-artifact.sh" "$file" 2>/dev/null | grep '^RESULT' || true)"
broken="$(printf '%s' "$result" | sed -n 's/.*broken=\([0-9][0-9]*\).*/\1/p')"

if [ -n "$broken" ] && [ "$broken" -gt 0 ] 2>/dev/null; then
  python3 -c 'import json, sys
print(json.dumps({
    "decision": "block",
    "reason": "Pre-output gate: " + sys.argv[1] + " has " + sys.argv[2]
              + " broken relative link(s); fix before relying on this artifact. " + sys.argv[3]
}))' "$file" "$broken" "$result"
fi

exit 0
