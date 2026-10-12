---
id: LESSON-0088
date: 2026-09-29
trigger: xv-rejected
phases: [03]
keywords: [sweep, grep, hit count, completeness claim, status change, superseded, LESSON-0039, reproducible, pattern, adr]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md, lessons/2026/LESSON-0039-status-change-sweeps-the-whole-record.md]
status: active
---

## What went wrong

Sofaoke, `/design` revision for the owner's rulings of 2026-09-29, pass 1. A finding reported a LESSON-0039 sweep of a superseded ADR as "80 hits on 64 lines outside the status line, 0 contradictions", filed as a code-finding whose location was the record's status line (line 3) and whose excerpt was empty. The status line shows none of the sweep. The finding gave no grep pattern, flags or hit list, so the count could not be re-run: 18 plausible vocabularies for the old state (stop/start, Spot, on demand, the superseded prices and the hour-based brake), each run with and without `-i`, gave counts between 45 and 228 hits, the nearest being 86 hits on 64 lines and 85 on 63, never 80 on 64. The "0 contradictions" half was not demonstrable either: two lines outside the superseded sections still use the old lifecycle's wording ("while the worker is stopped", "only while the production worker is stopped") and are named neither in the new record's clause-by-clause table nor in the status line. In the same pass, a sibling sweep claim ("mentions Google or the device flow 109 times across 50 lines") reproduced exactly, because its claim stated the vocabulary.

## Why it happened (root cause)

LESSON-0039's verification step asks the author to report "the hit count", not the pattern that produced it. A count without its pattern cannot be falsified, so it reads as evidence while carrying none, and the cited location (the status line the sweep was run to protect) is the one place the sweep's results are guaranteed not to appear.

## How to prevent it (the rule)

When reporting a status-change sweep, state the exact grep command (pattern, flags, file, and whether the status line is excluded) and the hit and line counts it printed, and list any hit kept unchanged with its line number, so the verifier can re-run the command and get the same numbers.

## Verification

The cross-verifier re-runs the stated command for every sweep claim; a count that does not reproduce exactly, or a sweep claim with no command, is rejected. The category "sweep count not reproducible" should fall to zero once briefs carry this rule.
