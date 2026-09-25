---
id: LESSON-0068-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [deduplication, monotonicity, merge-order, dedup-pass, score-invariant, bridging]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
source-run: cdocs/review-prbot-pr42-c (finding QA-SCORE-01, rejected by the cross-verifier)
---

## What went wrong

A finding claimed a safety invariant held ("deduplication cannot reduce an already-counted deduction when more agent data arrives") based on one experiment: constructing a single new finding designed to bridge two pre-existing findings via two different match criteria in a single deduplication pass, observing the total deduction was unchanged, and generalizing "no path exists" from that one negative result. The cross-verifier reproduced a real counter-example the experiment's shape could not have found: two separate findings independently matching the same accumulating entry via the *same* criterion, in two sequential one-to-one merges (not one bridging step), plus a second mechanism (the real pipeline deduplicates twice, once in the caller and again inside the scoring function, so a merge invisible in a single call can surface on the second pass). The claim was rejected; a related but narrower claim about the same mechanism (filed independently, from the other specialist covering the same question) was confirmed and reproduced the score change directly.

## Why it happened (root cause)

An absence/invariant claim ("no path lowers the deduction") was tested against one hand-picked scenario rather than against the actual call structure the claim was about. The evidence schema requires a real location and excerpt, both of which were present and accurate - but nothing required the reproduction to exercise the code the way the real pipeline actually calls it (dedup order matching outcome order, and dedup running twice). A negative result from a narrow experiment was reported with the same confidence as if the search space had been exhausted.

## How to prevent it (the rule)

When a finding claims an invariant holds "cannot happen" / "no path exists" for a specific mechanism, the reproduction must exercise the mechanism through the real call path used by the pipeline (not a standalone call to one function in isolation), and must vary at least the ordering of inputs, not just their content - an invariant claim tested under one fixed ordering is a claim about that ordering, not about the mechanism.

## Verification

The category that should fall to zero: a cross-verifier REJECTED vote whose reasoning cites "the real pipeline does X twice" or "order matters and was not varied" as the reason the claim's own reproduction missed the counter-example.
