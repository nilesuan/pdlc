#!/usr/bin/env bash
# audit-log.sh — Append a structured audit record for each tool call.
#
# Wired as a PostToolUse hook in settings.json. Reads the JSON payload Claude
# Code provides on stdin and appends a one-line JSON record to:
#
#   ${PDLC_AUDIT_LOG:-$HOME/.pdlc/audit.log}
#
# Record fields:
#   ts          ISO-8601 timestamp
#   session_id  Claude Code session ID (from CLAUDE_SESSION_ID, if set)
#   tool        Tool name
#   ok          0 / 1 — success
#   summary     One-line summary if available (e.g., file path, command name)
#
# This script is intentionally minimal and safe: failures are swallowed so a
# broken hook never blocks the user. For a richer audit pipeline, ship the
# log file to a SIEM via Filebeat / Vector / similar.

set -uo pipefail

LOG_FILE="${PDLC_AUDIT_LOG:-$HOME/.pdlc/audit.log}"
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true

ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
session_id="${CLAUDE_SESSION_ID:-unknown}"

# Read the hook payload from stdin; fall back to an empty object if absent.
payload=$(cat 2>/dev/null || echo '{}')

# Best-effort parse with jq if available; otherwise emit a minimal record.
if command -v jq >/dev/null 2>&1; then
  tool=$(printf '%s' "$payload" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")
  ok=$(printf '%s' "$payload" | jq -r 'if (.tool_response.error // false) then 0 else 1 end' 2>/dev/null || echo 1)
  summary=$(printf '%s' "$payload" | jq -r '
    .tool_input.file_path
    // .tool_input.command
    // .tool_input.url
    // .tool_input.path
    // ""
  ' 2>/dev/null || echo "")
else
  tool="unknown"
  ok=1
  summary=""
fi

# Emit a single JSON line; swallow failure so a broken log never blocks.
{
  printf '{"ts":"%s","session_id":"%s","tool":"%s","ok":%s,"summary":"%s"}\n' \
    "$ts" "$session_id" "$tool" "$ok" "${summary//\"/\\\"}"
} >>"$LOG_FILE" 2>/dev/null || true

exit 0
