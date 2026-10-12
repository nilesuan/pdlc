---
id: LESSON-0081
date: 2026-09-28
trigger: audit-finding
phases: [03]
keywords: [severity-gated-minimum, confidence-floor, downgraded, auto-rejected, post-adjustment, trigger-9, double-count]
related-rules: [standards/EVIDENCE.md, standards/QUALITY.md, agents/cross-verifier.md, agents/pass-runner.md]
status: candidate
---

# A DOWNGRADED finding's adjusted confidence can itself fail the severity floor, and the spec does not say what happens then

## What went wrong

A cross-verifier pass DOWNGRADED a `minor` finding (original confidence 72) to `adjusted_confidence: 52` for
excerpt drift, per its own protocol's `-20` delta. Minor's severity-gated minimum confidence is 60 (EVIDENCE.md,
QUALITY.md). The adjusted value is below that floor, but neither `EVIDENCE.md`'s auto-rejection triggers nor
`pass-runner.md`'s pass-loop (steps 2c through 2e) states what to do when a *post-adjustment* value breaches the
floor that was only ever specified as a pre-cross-verification, structural check ("Validate findings against
EVIDENCE.md auto-rules" happens in step 2c, before cross-verification in step 2d). The orchestrator had to decide,
without a written rule, whether to score the finding as an ordinary DOWNGRADE (kept, re-scored at 52) or apply
trigger 9 a second time, after adjustment, and treat it as auto-rejected instead (dropped, flat -5, not also -2 for
xv_downgraded). It chose the latter, reasoning from the rule's stated purpose rather than its literal placement in
the pass-loop's step order.

## Why it happened (root cause)

The severity-gated-minimum-confidence rule was written with only one moment of application in mind: a filer's raw
finding, checked once before it reaches the cross-verifier. The cross-verifier's own protocol can independently
push a confidence value below that floor as a side effect of a legitimate evidence-quality penalty (the `-20` /
`-25` / `-30` deltas in `agents/cross-verifier.md`), and nothing in the written pass-loop anticipates that the
floor might need re-checking after the value it gates has changed. This is a gap in written procedure, not a
mistake by any agent in the pass: the cross-verifier's vote was itself correct and well-reasoned, and the
finding's substance held up on independent re-derivation.

## How to prevent it (the rule)

After applying cross-verifier adjustments (pass-loop step 2e), re-run the severity-gated-minimum-confidence check
(EVIDENCE.md trigger 9) against each finding's *final* `adjusted_confidence` / `adjusted_severity` pair, not only
against the pre-cross-verification values. A finding that fails this second check is treated as `auto_rejected`
(dropped from the scored set, flat `-5`), not as a scored `DOWNGRADE` (`-2` plus its weighted deduction) — count it
under `auto_rejected` only, never both, to avoid double-penalizing the same finding under two buckets.

## Verification

The next pass-runner run that produces a DOWNGRADED finding whose adjusted confidence sits below its (possibly also
adjusted) severity's floor applies this rule and states so explicitly in the score breakdown, the way this pass's
`.pipeline.json` recorded an `auto_rejected_note` naming the finding and the reasoning. `standards/EVIDENCE.md` or
`agents/pass-runner.md` should eventually state this rule directly, at which point this lesson retires per
`standards/process/LEARNING.md`'s structural-change criterion.
