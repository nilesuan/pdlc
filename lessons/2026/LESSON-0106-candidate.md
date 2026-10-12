---
id: LESSON-0106
date: 2026-10-03
trigger: xv-rejected
phases: [02.5, 03, 08]
keywords: [paraphrase, drift, slightly differently, faithful, restates, duplicate wording, two sources]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A gap-audit finding (QA-04, Sofaoke repo) claimed one document "paraphrases" another's rule "slightly differently" and filed it as a staleness/drift gap, at low confidence and with its own recommendation already noting it was "not worth a standalone edit." The cross-verifier read both cited passages side by side and found they state the identical rule (the same trigger, the same interim behavior, the same end condition); the shorter document simply omits a justifying clause the longer one states a few lines earlier, which is compression, not drift. The finding's own hedge ("not worth a standalone edit") was itself the signal that the gap was not load-bearing, and it was filed anyway.

## Why it happened (root cause)

"Worded differently" was treated as evidence of inconsistency by default, rather than as a surface-level observation that still requires checking whether the two wordings assert the same thing. Two independently-written sentences describing one rule will almost never be byte-identical; the question that actually matters - do they commit to different outcomes - was not asked before filing. A low-confidence finding that the filer already flagged as marginal is a signal to drop it, downgrade it to an info note, or not file it, not to pass it through at the original severity and let a later stage absorb the cost of re-deciding it.

## How to prevent it (the rule)

Before filing a "paraphrases it differently" or "worded differently" finding, state in one sentence what outcome each version commits to, not just that the wording differs - file it only if those outcomes diverge. A finding whose own confidence is already at or near the severity-gated floor, with a self-noted "not worth fixing," should be dropped before it reaches the cross-verifier rather than passed through at face value.

## Verification

- A finding whose evidence section quotes two passages but never states what outcome each one commits to should be sent back before it reaches the cross-verifier.
- The category that should fall toward zero: an `xv_rejected` vote whose reason is "the two cited passages assert the same rule."
