---
id: LESSON-0054-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [test-coverage, absence-claim, grep-scope, e2e, rendered-output]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

## What went wrong

A finding in the prbot PR #45 review claimed that "no test exercises" a combination (a hidden low-confidence finding together with a non-empty verification line in the comment footer) on the strength of a grep over one file, `tests/review/test_formatter.py`. An end-to-end test in another file, `tests/test_pipeline_e2e.py` (the refuted-finding demotion test), drives exactly that combination through the pipeline. The same finding said the change "silently suppresses" the low-confidence disclosure. That is true of the helper function in isolation, but in the posted comment the count is always carried by the reconciliation line, which the pipeline renders whenever a hidden finding exists.

## Why it happened (root cause)

The search scope (one file) was narrower than the claim's scope (all tests), and the behavior was analyzed at the function boundary without tracing how the caller builds that function's inputs in a real run. Both gaps turn a true local observation into a false global claim.

## How to prevent it (the rule)

State the exact search scope for any absence claim and search the whole `tests/` tree before writing "no test"; check any claim about user-visible output against the output of a real pipeline run, not only the helper that produces part of it.

## Verification

Absence claims in findings name the command and the directory searched; cross-verifier rejections for "contradicted by a test elsewhere" or "no information lost in rendered output" should fall to zero.
