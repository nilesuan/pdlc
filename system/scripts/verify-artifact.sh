#!/usr/bin/env bash
# verify-artifact.sh — Pre-output gate for authored Markdown artifacts.
#
# Usage:
#   verify-artifact.sh <path-to-markdown-file>
#
# Layer 6 of the anti-hallucination protocol (see
# ../standards/ANTI_HALLUCINATION.md). The cross-verifier checks findings;
# this script checks the *artifacts* sub-agents author — that every relative
# link resolves to a real file, that external URLs are listed for follow-up,
# and that uncertainty tags are tallied so the pass-runner can surface them.
#
# Checks performed:
#   1. Relative-link resolution. Every Markdown link of the form ](X) where
#      X does not start with http(s):// or mailto: and is not a pure anchor
#      (#section) is resolved against the file's directory. Broken links
#      print with the original link text and resolved absolute path.
#   2. External-URL listing. Every http(s):// URL is extracted and printed
#      (no fetch — that is the cross-verifier's job).
#   3. Uncertainty-tag tally. Counts of [VERIFIED], [UNVERIFIED],
#      [SYNTHESIS], [CONTESTED], [OUT OF DATE].
#   4. Anchor-only links (#section) and same-file fragment refs are ignored
#      as broken-link candidates; markdown anchor presence is not validated
#      because anchor generation is tooling-specific.
#
# Output:
#   Human-readable summary to stdout, terminated by a single line:
#     RESULT broken=<n> external_urls=<n> verified=<n> unverified=<n> \
#            synthesis=<n> contested=<n> out_of_date=<n>
#
# Exit codes:
#   0 — no broken relative links
#   1 — at least one broken relative link
#   2 — argument missing or file not found

set -uo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: verify-artifact.sh <path-to-markdown-file>" >&2
  exit 2
fi

ARTIFACT="$1"

if [[ ! -f "$ARTIFACT" ]]; then
  echo "verify-artifact: file not found: $ARTIFACT" >&2
  exit 2
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "verify-artifact: python3 not found in PATH" >&2
  exit 2
fi

python3 - "$ARTIFACT" <<'PY'
import os
import re
import sys

artifact = sys.argv[1]
artifact_dir = os.path.dirname(os.path.abspath(artifact))

with open(artifact, "r", encoding="utf-8", errors="replace") as fh:
    text = fh.read()

# Markdown link pattern: [label](target). The target ends at the first
# unescaped closing paren. We use a non-greedy match and forbid raw whitespace
# inside the target (Markdown does not allow it without angle brackets).
LINK_RE = re.compile(r"\[([^\]]*)\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")

# External URL pattern (used for listing only).
URL_RE = re.compile(r"https?://[^\s)>\]]+")

# Uncertainty tags. We match the literal bracketed forms.
TAG_NAMES = ["VERIFIED", "UNVERIFIED", "SYNTHESIS", "CONTESTED", "OUT OF DATE"]
TAG_PATTERNS = {name: re.compile(r"\[" + re.escape(name) + r"\]") for name in TAG_NAMES}

broken = []
resolved = []
external = []

for match in LINK_RE.finditer(text):
    label = match.group(1)
    target = match.group(2)

    # Skip external schemes — listed separately.
    if target.startswith(("http://", "https://", "mailto:")):
        continue

    # Anchor-only links: tooling-specific, do not validate.
    if target.startswith("#"):
        continue

    # Strip in-file fragment (#section) — only the file part must exist.
    path_part = target.split("#", 1)[0]
    if not path_part:
        # Was something like "#anchor" already handled, but defensively skip.
        continue

    # Resolve relative to the artifact's directory.
    if os.path.isabs(path_part):
        resolved_path = path_part
    else:
        resolved_path = os.path.normpath(os.path.join(artifact_dir, path_part))

    if os.path.exists(resolved_path):
        resolved.append((label, target, resolved_path))
    else:
        broken.append((label, target, resolved_path))

for match in URL_RE.finditer(text):
    url = match.group(0).rstrip(".,;:!?")
    external.append(url)

tag_counts = {name: len(pat.findall(text)) for name, pat in TAG_PATTERNS.items()}

print(f"verify-artifact: {artifact}")
print(f"  artifact_dir: {artifact_dir}")
print()

print(f"Relative links: {len(resolved) + len(broken)} total "
      f"({len(resolved)} resolved, {len(broken)} broken)")
if broken:
    print("  Broken:")
    for label, target, resolved_path in broken:
        # Truncate long labels for display.
        disp_label = label if len(label) <= 60 else label[:57] + "..."
        print(f"    - [{disp_label}]({target}) -> {resolved_path}")
else:
    print("  All relative links resolve.")
print()

print(f"External URLs: {len(external)}")
seen = set()
for url in external:
    if url in seen:
        continue
    seen.add(url)
    print(f"  - {url}")
if not external:
    print("  (none)")
print()

print("Uncertainty tags:")
for name in TAG_NAMES:
    print(f"  [{name}]: {tag_counts[name]}")
print()

# Machine-readable footer.
key_map = {
    "VERIFIED": "verified",
    "UNVERIFIED": "unverified",
    "SYNTHESIS": "synthesis",
    "CONTESTED": "contested",
    "OUT OF DATE": "out_of_date",
}
parts = [
    f"broken={len(broken)}",
    f"external_urls={len(external)}",
]
for name in TAG_NAMES:
    parts.append(f"{key_map[name]}={tag_counts[name]}")
print("RESULT " + " ".join(parts))

sys.exit(1 if broken else 0)
PY
