---
id: LESSON-0036
date: 2026-09-19
trigger: xv-rejected
phases: [02.5, 03, 04]
keywords: [cross-verifier, vote, docs author, brief, sequencing, unverified finding, propagation, records, pass-runner]
related-rules: [agents/pass-runner.md, standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md]
status: active
---

**Provenance.** Sofaoke, third /solve run, passes 1 and 2, 2026-09-19. The orchestrator started a docs author on D2's acceptance records at 12:49Z and told it to reflect an audit's findings. The cross-verifier's votes on those findings were still running; they arrived at 13:14Z, after the docs author had committed. One vote downgraded finding QA-AUTO-12 because its claim that neither pitch model was pinned was false for SwiftF0 (pinned in eval/model-pins.md). The docs author had already carried "neither model is pinned" into two tracked records, and the pass-2 cross-verifier rejected that claim there (D2REC-24). A follow-up commit had to correct it.

## What went wrong

A finding's claim reached tracked records before the cross-verifier had voted on it. The vote then corrected the finding, but the correction had nowhere to go: the records already said the wrong thing.

## Why it happened (root cause)

To save time, the orchestrator ran the docs step in parallel with the cross-verification of the findings the docs step consumed. The pipeline's order (findings, then votes, then action) was kept for scoring but not for the work that acted on the findings.

## How to prevent it (the rule)

**Never hand a finding to an author who will write it into a tracked file until the cross-verifier's vote on that finding is in; brief the author with the votes, and tell it to carry each claim as the vote adjusted it. If time presses, start the author on the parts that consume no finding, and add the findings once voted.**

## Verification

- Every docs or fix brief that cites a findings file also cites its votes file, and the votes file's modification time precedes the brief's.
- The category that should fall to zero: a tracked-record claim rejected by a cross-verifier because it repeated a finding the cross-verifier had already downgraded.
