---
id: LESSON-0094-candidate
date: 2026-09-30
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [verify-artifact.sh, unverified-ratio, sed, greedy-match, substring-collision, RESULT-line, field-extraction, verified, unverified, pass-runner-tooling]
related-rules: [standards/ANTI_HALLUCINATION.md, scripts/verify-artifact.sh, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A hand-written shell aggregation of `verify-artifact.sh`'s `RESULT` line extracted the `verified=N` field with a
greedy `sed` pattern (`.*verified=\([0-9]*\)`). Because the `RESULT` line also contains `unverified=M`, and the
string `unverified=M` itself ends in the substring `verified=M`, the greedy match always landed on that embedded
occurrence instead of the standalone `verified=N` field earlier in the line. The bug silently made the extracted
`verified` count equal the `unverified` count for every file checked, undercounting the true denominator in the
unverified-ratio calculation and producing a false `major` pre-output-gate finding (unverified-ratio > 0.3 on 5
files) that a cross-verifier re-run correctly rejected: re-running `verify-artifact.sh` on the same five files with
a word-boundary-safe extraction gave ratios of 0.20-0.25, all under the 0.3 threshold, and zero files across the
395-file corpus actually exceeded it.

## Why it happened (root cause)

The aggregation script was hand-rolled for a one-off pass-runner check rather than reusing a tested parser, and its
field-extraction pattern was written without checking for a name that is a literal suffix-superstring collision
with another field on the same line (`unverified` contains `verified`). Nothing in the pass-loop or the pre-output-
gate protocol requires a positive-control self-check on a hand-written aggregation script - run it against one
line containing both colliding fields with known, different values, and confirm it extracts them correctly -
before its output is trusted and turned into a finding. The dash-scanner script written in the same session
(`check_dashes.py`) already had exactly this kind of positive-control check and would have caught the analogous
class of bug immediately; the ad hoc bash aggregation did not.

## How to prevent it (the rule)

When extracting a named field from a delimited `key=value` line by pattern match, anchor the pattern to a preceding
delimiter (start-of-string or a separator character, e.g. `(^| )verified=[0-9]+`) rather than a bare greedy
`.*<name>=`, whenever another field's name on the same line is a suffix-superstring of the target field's name
(`unverified` contains `verified` - the same risk applies to any future field pair with this shape). Before trusting
any hand-rolled aggregator's output as evidence for a finding, run it once against a single known multi-field line
by hand and confirm each field extracts its own correct value, not another field's.

## Verification

A hand-rolled aggregation of `verify-artifact.sh`'s `RESULT` line, run against a file whose `RESULT` line contains
both `verified=` and `unverified=` with different nonzero values, reports the correct value for each (not the same
value for both). The next pass-runner run that hand-aggregates `verify-artifact.sh` output across many files should
show `verified != unverified` whenever the underlying files' true counts differ, and should include a positive-
control line (as `check_dashes.py` already does) confirming the extractor works before its aggregate is trusted.

## Provenance (this run)

Detected during `/split v1`'s pass-runner run (worktree `split-v1`, 2026-09-30): the pass-runner's own bash
aggregation over `scripts/verify-artifact.sh` produced finding `PRE-OUT-UNVER-01` (major, confidence claimed ~80),
which the cross-verifier voted REJECTED after re-running the script directly and reproducing ratios of 0.20-0.25 on
the same five files. The pass-runner re-ran its own check with a corrected, word-boundary-anchored extraction
(`grep -oE '(^| )verified=[0-9]+'` in place of the greedy `sed` pattern) and confirmed zero files in the 395-file
corpus exceed the 0.3 threshold; `PRE-OUT-UNVER-01` was withdrawn. This file is a candidate stub written under
`cdocs/` because the run's write scope was restricted to `planning/v1/stories/` and `cdocs/` only - promote it to
`lessons/2026/LESSON-0094-candidate.md` (the next free number as of this run) for the standard review-and-promote
step.
