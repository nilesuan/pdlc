---
id: LESSON-0061-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [absence-claim, no-test-covers, test-inventory, test-count, mutation, surviving-mutant, exit-code, precedence, universal-quantifier, LESSON-0008, LESSON-0026]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, standards/testing/TEST_STRATEGY.md]
status: candidate
source-run: cdocs/review-prbot-pr42-r3/lesson-candidate-1.md
---

## What went wrong

A test-coverage finding (PR #42 r3, QA-COV-05) claimed that no test in `tests/test_pipeline_e2e.py` or `tests/review/test_verdict.py` exercised a combined scenario: a chunk every agent failed on, together with a blocker found in a different, fully reviewed chunk. Its grounding said it had checked "all 13 tests in test_verdict.py". At head 911647e that file defines 28 test functions, and `tests/review/test_verdict.py:416-428` (`test_a_blocker_from_another_chunk_still_requests_changes`) builds exactly that outcome shape (both agents succeed on chunk 1, both fail on chunk 2, a critical/95 blocker) and asserts `REQUEST_CHANGES`. The real gap was narrower: nothing pins the exit-code precedence in `src/prbot/cli.py:809-820` (exit 1 before exit 3). A mutant that turns line 811 into `elif verdict == ReviewVerdict.REQUEST_CHANGES and not unreviewed:` survives the full suite (1136 passed, 9 skipped).

## Why it happened (root cause)

The claim was about behavior ("no test exercises scenario S"), but its evidence was an inventory of test names, and the inventory undercounted the file. A name list cannot show which outcome shapes a test builds, and nothing cross-checked the count against the file. The claim was then scoped to two files, including the one layer (the verdict unit) where the scenario was in fact tested.

## How to prevent it (the rule)

Ground every "no test covers X" claim with a mutant that breaks exactly X and a full-suite run showing the mutant survives. Name the mutant and the pass count in the evidence, and scope the claim to the layer the mutant changes.

## Verification

The cross-verifier re-runs the named mutant. The category "absence claim contradicted by an existing test" should fall to zero, and a behavioral absence claim whose only evidence is a name grep or a test count is returned to its author before scoring.
