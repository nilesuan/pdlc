---
id: LESSON-0007
date: 2026-08-21
trigger: audit-finding
phases: [04, 05]
keywords: [css, selector, stylesheet, scope, styling, jsdom, visual-regression, screenshot, appearance, narrowing, mutation-testing, deploy-watcher, gh-run-list]
related-rules: [standards/testing/TEST_STRATEGY.md, standards/frameworks/COMPOSITION_VERIFICATION.md, standards/development/CODE_REVIEW.md]
status: active
---

## What went wrong

Three CSS scope defects shipped from a single stylesheet pass, two of them to production, against a suite of 564 passing tests. An `input { ... }` rule written for text fields also matched radio inputs and rendered them as 44px empty circles. A `main fieldset label` rule written for one choice component also matched diagram-capture markers, drawing boxes inside boxes. A `main section > p + p` / `p:last-child` pair written for a readers card also matched a marked practice card, demoting its feedback text to a muted footnote. Every defect was obvious in a screenshot and invisible to the suite.

## Why it happened (root cause)

Every existing check was behavioural, and the test environment never applied real CSS to real markup: jsdom does not load the stylesheet, and the deployed-edge spec could not reach a graded attempt. Appearance failures were therefore structurally undetectable rather than merely untested - no amount of additional behavioural tests in that harness could have caught them. Compounding it, a selector was validated only on the screen it was written for, so the blast radius of a broad selector was never observed. The mistake in all three cases was a single one: a selector broader than the component it was authored for.

## How to prevent it (the rule)

Verify a style change on every screen the selector REACHES, not only the one it was written for; after narrowing a selector, re-probe the cases it was meant to KEEP; and where a state is unreachable in the local harness, stub it into reachability rather than styling it blind. A selector's blast radius must be observed, never inferred.

## Verification

- A stylesheet change whose review covers only the originating screen is a finding; the reached-screen list must be enumerated and checked.
- A narrowing commit with no evidence that the retained cases still match is a finding.
- Regression check: introduce a deliberately broad selector and confirm the review or CI step names the additional components it reaches, rather than passing silently.
- The finding category that should drop to zero is "appearance defect shipped with a green suite".

## Related observations from the same pass

Two adjacent failure modes surfaced alongside the main one and are recorded here rather than as separate lessons, since neither has recurred:

- **A new test is not evidence until a mutation kills it.** Mutation testing killed two newly written tests in this pass; both had been passing for the wrong reason, and one omitted the prop that made the gate testable at all - a hazard the file's own comment had already documented.
- **Filter deploy watchers by workflow name and sha, never by recency.** A watcher matching on `gh run list --branch main --limit 1` selected the CI run instead of the deploy and reported success while the deploy was still running, so the verification that followed was meaningless.
