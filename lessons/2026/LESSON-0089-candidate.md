---
id: LESSON-0089
date: 2026-09-29
trigger: xv-rejected
phases: [03]
keywords: [cited excerpt, mis-citation, design-claim, adr, alternatives, neighboring decision, excerpt-claim mismatch, verbatim]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: active
---

## What went wrong

Sofaoke, `/design` revision for the owner's rulings of 2026-09-29, pass 1. A design-claim finding said the author had added a "TVs signed in as you" account-page list with per-TV sign-out, because without it the only remedy for a phished or mistaken TV pairing was deleting the account. Its `cited_excerpt`, "A second, 128-bit token in the TV's QR code beside the typed code. Not chosen.", is verbatim in the named ADR (ADR-0018, line 147), but it belongs to a different decision: a rejected alternative about what the QR code carries. It says nothing about the account-page list or its rationale. The claim itself was true, and the sentence that demonstrates it is in the same file (line 83: "It answers a TV paired by mistake, left signed in at a friend's, or paired for a phisher, where the only remedy was deleting the account."), but the evidence as filed did not support the claim.

## Why it happened (root cause)

When several findings are filed from one long source, an excerpt can land on the wrong finding. A verbatim-match check passes because the text is real, so the mismatch is invisible to any check that asks only "is this quote in the file?". It surfaces only when the excerpt is read against the claim it is meant to demonstrate.

## How to prevent it (the rule)

Before filing a finding, re-read its `cited_excerpt` or `excerpt` next to its `claim` and confirm the excerpt names the same feature, decision or behavior the claim is about; a verbatim excerpt about a neighboring decision is a mis-citation, not evidence.

## Verification

The cross-verifier's connection check (the excerpt demonstrates the claim, not only exists in the source) rejects excerpt-claim mismatches; the count of findings rejected for a real-but-unrelated excerpt should fall to zero.
