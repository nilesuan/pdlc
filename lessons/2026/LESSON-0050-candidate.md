---
id: LESSON-0050-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [excerpt, location, line-range, mislocated-excerpt, ellipsis-fragment, code-finding, test-file, byte-identical]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
note: |
  Originally written by the cross-verifier directly to lessons/2026/LESSON-0048-candidate.md
  during the /review pass-runner run for prbot PR #44. Relocated here per this run's explicit
  constraint ("do not write to lessons/2026/ - two other pass-runners for PR #43 and PR #45
  run concurrently; write lesson candidates to this run's output dir, the caller merges
  afterwards"), which was not passed through to the cross-verifier's brief - an omission in
  this run's briefing, not the cross-verifier's error. The id above is provisional; the
  caller should assign the real next global LESSON-NNNN slot when merging candidates from
  all three concurrent runs, since another run's cross-verifier may independently have
  picked the same number 0048 for an unrelated candidate.
---

## What went wrong

Two info findings in a `/review` pass (prbot PR #44) quoted test code verbatim but cited line ranges that held different code. In the first, the cited range `tests/test_pipeline_e2e.py:1236-1245` held the body of the neighbouring test (`test_a_read_is_answered_from_the_head_revision`), while the quoted test (`test_zero_turns_is_a_single_call_per_agent`) sits at 1280-1288. In the second, the cited range `1247-1268` began nine lines inside that same neighbouring test, and the excerpt's load-bearing assertions, after its `...`, sit at 1276-1277, outside the range. Every quoted line existed somewhere in the file. None of the load-bearing lines existed at the cited location. Both findings were true in substance: a mutation run confirmed one, and the other test is cited at its correct lines by another finding in the same pass. A reader opening the cited lines would still have found different code.

## Why it happened (root cause)

The excerpt and the location came from separate reads. The text was copied from the test body, and the line numbers were supplied on their own, apparently from a neighbouring test's position, without being re-derived from the text. Nothing ties a location to its excerpt. The check an author naturally runs is "does this text exist in the file", which passes. The check that fails is "is this text at these lines", and nobody runs it. An ellipsis hides the gap further, because the fragment after `...` is never compared against the range at all.

## How to prevent it (the rule)

Derive a code-finding's location from the excerpt itself: search the file for the excerpt's first and last lines and use those line numbers. Then print the cited range and confirm that every fragment, on both sides of any ellipsis, appears inside it before filing.

## Verification

- The cross-verifier prints each cited range and checks that every excerpt fragment appears inside it. The category "verbatim excerpt, wrong line range" should fall to zero.
- This is the same failure family as LESSON-0002's "wrong-source attribution", at line granularity instead of URL granularity.
