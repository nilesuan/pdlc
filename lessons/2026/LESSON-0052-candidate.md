---
id: LESSON-0052-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [code-finding, line-range, excerpt, location, docstring]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

## What went wrong

A code-finding in the prbot PR #45 review (head 73f1571) cited `src/prbot/review/verifier.py:14-18` for three sentences from the module docstring. The quoted text is real, but it sits at lines 11-13. Lines 14-18 hold the docstring's last sentence, the closing quotes, a blank line and `from __future__ import annotations`. The excerpt was genuine and the location was wrong, so the evidence failed the location-to-excerpt match and the finding was rejected even though its substance was true.

## Why it happened (root cause)

The line numbers were recorded without re-reading the cited range at the moment of citation, most likely counted from a nearby anchor in a long docstring where every line looks alike. Nothing between writing a finding and handing it to the cross-verifier checks that the excerpt's first line actually appears at the cited start line.

## How to prevent it (the rule)

Before emitting a code-finding, re-read exactly the cited range with line numbers (Read with offset and limit, or `sed -n 'A,Bp'`) and confirm the excerpt's first line is at A and its last line is at B.

## Verification

A pass-runner pre-check that greps each code-finding excerpt's first non-blank line at the cited start line (plus or minus zero) flags the mismatch before cross-verification; cross-verifier rejections with the reason "excerpt not at cited lines" should fall to zero.
