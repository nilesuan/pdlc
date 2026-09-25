---
id: LESSON-0059-candidate
date: 2026-09-25
trigger: audit-finding
phases: [04, 05]
keywords: [orphan-finding, score-table, narrative, xv_downgraded-list, review-artifact, no-claim-text, closure-verification]
related-rules: [standards/EVIDENCE.md, standards/QUALITY.md, agents/pass-runner.md]
status: candidate
source-run: cdocs/review-prbot-pr42-r2/lesson-candidate-1.md
---

## What went wrong

A review artifact (`/Users/nile/.claude/cdocs/review-prbot-pr42/review-2026-09-24T014439Z.md`) carried a finding — `Q-ARCH-01`, nit severity — through its score table and its `xv_downgraded` list, with a real confidence trajectory (78 -> 58) and a real deduction (0.44) counted into the final score. The document has no claim, evidence, or recommendation text for that finding anywhere in its 142 lines. Two independent readers in a later pass (a code-reviewer sub-agent and the cross-verifier), tasked with verifying whether `Q-ARCH-01` was now closed, each ran their own `grep` for the string and independently confirmed the same three hits: the score-table row and two summary-list mentions, nothing else. The finding was scored as if it had a body. It never did.

## Why it happened (root cause)

The scoring formula and the narrative write-up are two different steps drawing from what should be the same set of findings, and nothing forces them to agree in row count. A finding can survive cross-verification (get a confidence adjustment, get counted in a deduction) without ever being transcribed into the "Findings, in full" section a human reads — the two artifacts (the score table and the narrative body) are assembled separately, and the assembly step that writes the narrative apparently dropped one row without the scoring step noticing the loss. Nothing checked that every row scored also has a body, or that every body written also has a score row.

## How to prevent it (the rule)

Before a review artifact is finalized, mechanically check that every finding ID appearing in the score table (or the `xv_downgraded`/`xv_rejected` summary lists) also has a corresponding claim/evidence/recommendation block in the narrative body, and vice versa — a row on one side with no match on the other is a blocker on the artifact, not a nit on its subject.

## Verification

- A pass-runner can check this with a simple ID-set comparison: extract every `<PREFIX>-<NN>` token from the score-table/summary-list sections and every `<PREFIX>-<NN>` heading in the narrative sections, and diff the two sets before writing `RESULT` in the final artifact.
- The category that should fall to zero: a later pass reporting a previous finding as `UNVERIFIABLE` for lack of narrative text in the artifact that scored it.
