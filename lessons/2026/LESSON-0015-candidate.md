---
id: LESSON-0015
date: 2026-09-18
trigger: xv-rejected
phases: [02.5, 05]
keywords: [control, determinism, guardrail, negative-result, harness-verdict, reported-as-proven, repeat-run, flake, spike, made-to-speak]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
---

# When a control speaks, transcribe what it said - especially when it says no

**Provenance.** `/solve` Phase 02.5 Pass 2, slug `song-processing`, 2026-09-18.
A registered determinism guardrail ran, recorded a mismatch, and was written up as
having passed.

## What went wrong

A spike registered "determinism over 5 repeated pairs" as a guardrail. The harness
ran it and wrote its own verdict per pair as `[run_a, run_b, equal?]`. For the
headline arm, four pairs read `true` and the first read:

```
"iAP9AF6DCu4|W0zfldDxdn8": [0.89, 0.88, false]
```

The record's Controls section then stated the arm "reproduced 0.8800 / 0.0000 /
0.0000 / 0.0000 / 0.0000 **exactly**", and its guardrail table recorded that arm's
determinism as "identical". The one pair that carried a real similarity - the real
second upload, the stratum the whole decision is about - was the one that did not
reproduce, and the `false` the harness wrote was inverted in the write-up.

The other arm's five pairs genuinely did reproduce, and were reported correctly.
The divergence was small (0.01) and the arm failed its calibration gate on separate
grounds, so no decision turned on it - which is precisely why nothing else caught it.

## Why it happened (root cause)

A control that has been built, wired and run feels finished. The effort is in making
it speak (LESSON-0005); once it speaks, the write-up step is treated as clerical and
gets done from the shape of the expected result rather than from the artifact.

Four `true`s and one `false` compounds this: the modal value reads as the answer, and
a per-pair boolean has no aggregate line that would have said "4 of 5". A control
that emits a *list* of verdicts rather than a single pass/fail invites the writer to
summarise, and summarising a mixed result is exactly where the sign gets lost.

The direction of the error is the tell. A control's negative verdict is the only
output it exists to produce; transcribing it as a positive converts the one
mechanism that could have flagged a problem into evidence that there is none.

## How to prevent it (the rule)

When a control or guardrail emits its own verdict field, quote that field in the
record rather than describing the outcome in your own words, and report a mixed
result as a count ("4 of 5 pairs reproduced; the real-upload pair returned 0.89
against 0.88") - never collapse it to "proven", "identical" or "exactly".

## Verification

- For any finding or record claiming a control passed, the cross-verifier opens the
  control's own output file and reads its verdict field, not the surrounding prose.
- Any control emitting per-item verdicts also emits an aggregate count of passes
  over items, so a mixed result cannot be summarised into a clean one.
- The finding category that should drop to zero: "control's recorded verdict
  contradicts the record's description of it."
