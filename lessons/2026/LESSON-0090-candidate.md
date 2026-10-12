---
id: LESSON-0090
date: 2026-09-29
trigger: auto-rejected
phases: [03]
keywords: [confidence floor, severity-gated minimum, calibration, cross-verifier, downgrade, auto-reject, post-adjustment, trigger 9, double-count]
related-rules: [standards/EVIDENCE.md, standards/QUALITY.md, standards/process/CALIBRATION.md, agents/pass-runner.md]
status: active
---

## What went wrong

Sofaoke, `/design` revision for the owner's rulings of 2026-09-29, pass 1. A `minor`-severity finding (`ARCH-DM-02`) was filed at `confidence: 65`, which clears the minor floor of 60 and passes EVIDENCE.md's trigger-9 check before cross-verification. The cross-verifier then voted it `DOWNGRADED`, with `adjusted_confidence: 40`, below the same floor, and said so in its own notes ("40 is under minor's floor of 60, so the pass-runner will auto-reject it"). The pass-loop as written checks trigger 9 once, at step 2c, before the cross-verifier runs (step 2d); nothing in `pass-runner.md` or `EVIDENCE.md` says whether a post-adjustment confidence that falls below the floor is checked again, and whether such a finding should be counted as `xv_downgraded` (its actual vote), `auto_rejected` (the reason it no longer survives), or both. The orchestrator resolved it by judgment: treat it as `auto_rejected` only, excluded from per-finding deductions, and not also counted toward `xv_downgraded`, to avoid penalizing one finding's one problem under two KPI buckets.

## Why it happened (root cause)

The severity-gated minimum confidence table is written as a single-pass gate applied to a finding's own self-reported confidence. It does not say what happens when the confidence value changes later in the same pass, because the cross-verifier's adjustment step was designed to correct evidence quality, not to interact with the auto-rejection floor. The two mechanisms were specified independently and never explicitly composed.

## How to prevent it (the rule)

After applying the cross-verifier's `adjusted_confidence` (pass-loop step 2e) and before per-prefix calibration (step 2e.5), re-run EVIDENCE.md's severity-gated minimum-confidence check against the adjusted value. A finding that now falls below its severity's floor is reclassified `auto_rejected` (not scored, not also counted `xv_downgraded`) and excluded from per-finding deductions; its vote is still recorded as `DOWNGRADED` in `history.jsonl` for calibration purposes, but its scoring-KPI bucket is `auto_rejected`.

## Verification

The pass-runner's score-breakdown output states, for any finding whose vote was `DOWNGRADED` and whose adjusted confidence fell below its severity's floor, which single KPI bucket absorbed it, and confirms it was not double-counted against both `auto_rejected` and `xv_downgraded` in the same pass's deduction total.
