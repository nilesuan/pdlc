---
id: LESSON-0021
date: 2026-09-18
trigger: xv-downgraded
phases: [02.5, 03, 04, 05]
keywords: [absence, only, none, never, nothing, grep, search-record, recurrence, lint, LESSON-0008, LESSON-0019]
related-rules: [lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md, lessons/2026/LESSON-0019-candidate.md, standards/EVIDENCE.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 2 (resumed), Sofaoke `song-processing`, 2026-09-18. Votes in `cdocs/.pipeline-solve/pass2/xv-A.yaml` (SEC-DESIGN-01), `xv-B.yaml` (D5-OWNER-01, D5-HARV-01, ARCH-D5A-04, ARCH-D5A-08, ARCH-D5A-11) and `xv-C.yaml` (ARCH-D5R-07, ARCH-D5R-08), all `DOWNGRADED`. **The third pass in a row in which LESSON-0008's failure recurred with LESSON-0008 and LESSON-0019 loaded in every brief.**

## What went wrong

Eight findings from five different agents stated an absence or a uniqueness ("the harness's only two lyric writers", "the owner has not ruled on", "round 3 stored and read only allowlisted fields", "its only additions are two", a check said to rule something out that it could not detect) with no pasted search behind it, or with a search whose scope or pattern could not see the thing ruled out. In most cases the substance survived on the verifier's own search, so the cost was confidence, not truth, but each needed a verifier to do the filer's search.

## Why it happened (root cause)

A rule restated in every brief is still prose the filer must remember at the moment of writing, and an absence claim reads as finished without its search. LESSON-0019 predicted this: "If LESSON-0008 keeps recurring with this lesson active, the fix is mechanical, not another lesson."

## How to prevent it (the rule)

**Lint every findings file before cross-verification, and send back to its filer any finding whose claim asserts an absence or uniqueness while its evidence carries no pasted command with its output.**

**Recurrence, pass 3 of the same run (2026-09-19 UTC).** With the lint running before verification, downgrades on the pass fell from 17 of 69 findings to 4 of 59. Two of the four were still absence claims (PROMO-LABEL-02 and PROMO-GAP-D2 in that project's `cdocs/.pipeline-solve/pass3/xv-A.yaml`): each carried a pasted search, so the lint passed it, but the search's scope or vocabulary did not cover the claim's quantifier. The lint proves a search was pasted, not that it covers the claim. Its next step is to compare the paths a search ranges over with the paths the claim names, and to require one search in the authoring artifact's own words (LESSON-0008's second half).

**Pass 5, same run.** Four of pass 5's six downgrades were searches described in prose ("a grep over ... found") or summarised rather than pasted, which the lint's first version passed because it matched the word `grep`. From 2026-09-19 about 03:55Z the lint counts only a pasted shell prompt line (`$ command`) or a command's literal output (`printed:`, `Ran N tests`), and its self-test holds a described-search finding it must flag.

**Pass 5, half B, same run.** Four of half B's six downgrades (CONS5-D7-01, CONS5-YT-01, CONS5-SEQ-01, CONS5-RUNS-01 in that project's `cdocs/.pipeline-solve/pass5/xv-B.yaml`) were absence claims again: two in phrasing the pattern does not list ("does not say", "does not list"), two carrying a pasted word search whose vocabulary did not cover the claim. Every one kept its substance and lost 20 points of confidence. The lint was not widened a third time: the cross-verifier catches this class at that cost, and CLAUDE.md section 6 says to stop when consecutive passes fix the checker rather than the subject. The remaining control is the filer's: state what the search covers, in the claim's own words, beside the claim.

**Pass 5, whole pass, same run.** 23 of 112 findings were downgraded and 1 rejected. 13 of the 23 were quantified or absence claims ("all", "none", "every", "the one", "no file") whose evidence covered less than the claim, one of them (QA-D2R5X-07) resting on a search that could not have found what it ruled out; 3 cited a check with no saved script or stored record (D5R4X-HARN-01, D2R5X-CAL-01, E2E5-DITHER-01; the first is also in the 13). Counted by the orchestrator from the vote reasons in that project's `cdocs/.pipeline-solve/pass5/xv-A.yaml` to `xv-E.yaml`. Same root cause as above; no new stub, and the lint stays as it is.

## Verification

- The mechanical check exists in that project: `cdocs/.pipeline-solve/tools/lint_findings.py` (ABSENCE and TRACKED checks), with a `--self-test` that feeds it findings it must flag and findings it must pass (OK at 2026-09-18, 20:30Z to 20:40Z). Run retrospectively on pass 2 it flagged 9 findings. From pass 3 on it runs before every cross-verifier.
- The category that should fall to zero is a `DOWNGRADED` vote citing LESSON-0008 or LESSON-0019. If it does not, the lint's pattern list is too narrow: widen it from the downgraded claims' own words.
