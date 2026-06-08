#!/usr/bin/env bash
# context-monitor.sh — Warn when an active pass-loop run is approaching context limits.
#
# Wired as a SessionStart / UserPromptSubmit hook in settings.json.
# Reads .pipeline.json from the current working directory if present and emits
# a context-budget warning to stderr (which Claude Code surfaces in-conversation).
#
# Exit codes:
#   0 — informational only, no warning
#   0 — warning emitted (Claude reads it but does not block)
#   1 — error reading state (still does not block)
#
# This script is intentionally read-only and side-effect-free.

set -uo pipefail

PIPELINE_FILE="${CLAUDE_PROJECT_DIR:-$PWD}/.pipeline.json"
SOFT_LIMIT_TOKENS=${PDLC_CONTEXT_SOFT_LIMIT:-120000}
HARD_LIMIT_TOKENS=${PDLC_CONTEXT_HARD_LIMIT:-180000}

if [[ ! -f "$PIPELINE_FILE" ]]; then
  exit 0
fi

# A naive token estimate: bytes / 4. Replace with a real tokenizer if needed.
size_bytes=$(wc -c <"$PIPELINE_FILE" 2>/dev/null || echo 0)
est_tokens=$(( size_bytes / 4 ))

if (( est_tokens >= HARD_LIMIT_TOKENS )); then
  cat >&2 <<EOF
[context-monitor] .pipeline.json estimate ~${est_tokens} tokens — at hard limit (${HARD_LIMIT_TOKENS}).
The pass-runner should checkpoint and start a fresh pipeline.
EOF
elif (( est_tokens >= SOFT_LIMIT_TOKENS )); then
  cat >&2 <<EOF
[context-monitor] .pipeline.json estimate ~${est_tokens} tokens — soft limit (${SOFT_LIMIT_TOKENS}).
Consider summarising prior passes before the next sub-agent spawn.
EOF
fi

exit 0
