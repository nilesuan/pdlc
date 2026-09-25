---
id: LESSON-0048-candidate
date: 2026-09-24
trigger: xv-rejected
phases: [04, 05]
keywords: [discrepancy, contradiction, two-numbers, unread-source, resolving-source, deduplication, unique-count]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, lessons/2026/LESSON-0038-explain-from-the-rawest-record.md]
status: candidate
source-run: review-prbot-pr43 (PR #43, nilesuan/prbot)
---

## What went wrong

A finding (CR-COMMIT-01) asserted an unresolved contradiction between two numbers in a PR description ("129 production calls" measured vs. "126 measured pairs committed" to a fixture), citing four other committed sources that all agreed on "129" as corroboration that "126" was the odd one out. The filer explicitly noted it had not opened the one source that would settle the question — the fixture file itself — and filed the finding anyway at normal (not reduced) confidence, framed as an actionable discrepancy needing correction. The cross-verifier opened the fixture and found its own `description` field stated the resolution directly: 129 calls were measured, duplicates were collapsed, leaving 126 unique pairs. Both numbers were correct under different definitions; there was no contradiction.

## Why it happened (root cause)

Corroboration from multiple *other* sources agreeing with each other was treated as evidence that the outlying number was wrong, without checking whether the two counts could both be true simultaneously under different definitions (total measurements vs. unique pairs after deduplication). The filer's own lane discipline — not duplicating a parallel reviewer's assigned file — was correct in isolation, but nothing in that discipline distinguished "defer this claim to the reviewer who will open that file" from "file it now at full confidence and let a contradiction stand unresolved." Four sources agreeing with each other is evidence about what those four sources say, not evidence about whether a fifth, different-looking number is an error.

## How to prevent it (the rule)

Before filing a finding that characterizes two numbers, two dates, or two other values as contradictory, either open the source that would resolve the apparent conflict, or — if that source is explicitly out of the filer's lane and assigned to a parallel reviewer — file the claim at reduced confidence with an explicit note that resolution is pending that reviewer's read, rather than at normal confidence as an actionable discrepancy. A claim of "these two things conflict" carries the same evidentiary burden as any other claim: it needs the source that would settle it, not just agreement among sources that don't.

## Verification

- The cross-verifier rejects a "contradiction" or "discrepancy" finding whose own evidence states that a source which could resolve it was not read.
- Category that should fall to zero: an `xv-rejected` vote whose reason is "the source it didn't open explains the discrepancy."
