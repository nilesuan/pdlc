---
id: LESSON-0023
date: 2026-09-18
trigger: xv-downgraded
phases: [02.5, 03, 05]
keywords: [because, which-is-why, cause, explanation, inference, synthesis, causal-clause, not-visible-at-cited-lines]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 2 (resumed), Sofaoke `song-processing`, 2026-09-18. `DOWNGRADED` on D2-COV-01, QA-D2R-04 and QA-D2R-05 (`xv-A.yaml`) and ARCH-D5A-03 (`xv-B.yaml`), each for the same root cause.

## What went wrong

Four findings reported a verified observation and then explained it: "which is why they pass pitch accuracy and fail coverage", "the synthetic voice manufactured every candidate's failure", "the disagreement they plausibly caused is recorded as the tool's own variation", "a label the owner's own ruling contradicts". The observation was real each time. The explanation was a second claim, not visible at the cited lines, and in two cases other evidence in the same record pointed to a different cause. One finding even labelled its cause "[inference]", and the label did not make it evidence.

## Why it happened (root cause)

An explanation makes a finding feel complete and actionable, and it rides on the confidence of the observation it is attached to. Nothing in the evidence schema separates the observed part of a claim from its causal part.

## How to prevent it (the rule)

**State the observation as the claim and put any cause in its own sentence with its own evidence; if the cause is not shown at a cited location, file it as a separate info-severity question rather than as part of the finding.**

## Verification

- For each finding whose claim contains "because", "which is why", "caused", "manufactured" or "so that", the cross-verifier checks the causal clause against its own cited evidence, separately from the observation.
- The category that should fall to zero is a `DOWNGRADED` vote whose reason is "the causal step is not visible at the cited lines".
