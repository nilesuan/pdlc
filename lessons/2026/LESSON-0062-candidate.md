---
id: LESSON-0062-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [provenance, attribution, diff-hunk, rewrap, newly-written, git-log-S, docs-drift, verdict-table, converse, conditional-row, CHANGELOG, README]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
source-run: cdocs/review-prbot-pr42-r3/lesson-candidate-2.md
---

## What went wrong

A documentation-drift finding (PR #42 r3, SEC-DESIGN-07) said commit 911647e wrote new prose promising that "A blocker found in another chunk still requests changes", and that a run with one agent failing on every chunk and a blocker in another chunk broke that promise by exiting 3 with a COMMENT. The run behavior was right: `src/prbot/review/verdict.py:107-112` returns COMMENT before any blocker check, and a probe exited 3. The attribution and the reading of the docs were not. In 911647e's diff that CHANGELOG sentence appears in both the removed and the added lines. It was re-wrapped, not written, and `git log -S` places its origin in 70601ff. The new README row ("A pass no agent completed, and no blocker elsewhere | ... | 3") says nothing about the blocker case. The same table's row "An agent failed on every pass | COMMENT (never approve/reject with incomplete data) | 0" (README.md:375) explicitly covers the scenario. What the run actually contradicts is the exit code 0 in README rows 370 and 375, and the finding did not identify that.

## Why it happened (root cause)

Provenance was taken from the post-image of a diff hunk without comparing it to the pre-image. The documentation "guarantee" came from the converse of a conditional table row, which is not a valid inference, rather than from reading every row whose condition matches the scenario. Neither step leaves a visible trace unless a reviewer re-derives it.

## How to prevent it (the rule)

Before attributing quoted text to a commit, run `git log -S '<text>'` or compare the hunk's removed and added lines, and say "re-wrapped" rather than "added" when the text appears on both sides. Before claiming that a doc contradicts the code for a scenario, list every doc row or sentence whose condition matches that scenario, and compare each stated outcome with the observed one.

## Verification

The cross-verifier runs `git log -S` on every "added by <sha>" quote. A doc-contradiction finding must list all matching rows, each with its stated outcome next to the observed one. The category "text attributed to the wrong commit" should fall to zero.
