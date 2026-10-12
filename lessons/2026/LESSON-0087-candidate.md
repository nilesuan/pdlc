---
id: LESSON-0087
date: 2026-09-28
trigger: self-detected
phases: [02.5, 04, 05]
keywords: [self-test, verify, re-verify, printed-output, PASS, behaviour, surface-signal, code-line, subtraction, scheduling, regression]
related-rules: [../../CLAUDE.md, ../standards/ANTI_HALLUCINATION.md, ../agents/pass-runner.md]
status: active
---

## What went wrong

While synthesizing a fix round into a final operator-facing document, the authoring agent re-checked two upstream claims and reported both as `[VERIFIED]`. Both were wrong in substance. In the first, it confirmed a self-test's `PASS` output printed as expected, without checking that the self-test actually exercised the specific registered requirement (a frequency-resolution spec) the fix was supposed to meet — the tool printed success while testing something narrower than what success was supposed to mean. In the second, it read the one line of source that subtracted a calibration offset from a scheduled time, concluded the offset was applied, and did not read the surrounding scheduling code that deferred the callback until after the window for "start earlier" had already closed — so a positive offset was silently a no-op despite the subtraction line being present and correct-looking in isolation.

## Why it happened (root cause)

"Re-run the self-test and confirm it still passes" and "read the code that applies the value" both feel like verification, and both are cheaper than re-deriving the underlying behaviour from first principles. But a self-test's printed `PASS` only proves the assertions the test author chose to write, not the requirement the reader assumes it covers, and a single line of source can be locally correct while a caller elsewhere in the control flow never lets it execute with the value the reader expects. Neither gap is visible from the printed output or the one line alone — both are visible only from tracing the actual data or control flow the claim depends on. The structural gap is that "verified" was recorded at the resolution of an artifact (a test's exit status, a line of code) rather than at the resolution of the claim being made (a specific numeric spec is met; a specific input produces a specific scheduled effect).

## How to prevent it (the rule)

Before marking a claim `[VERIFIED]` that a self-test proves a specific requirement, or that a piece of code produces a specific effect, name the requirement or effect in one sentence and trace it to the exact assertion or the exact runtime path that establishes it — not the test's overall exit code, and not an isolated line read without its caller. If that trace cannot be done cheaply, downgrade the claim to `[UNVERIFIED]` or re-run a targeted check that isolates the specific thing being claimed, rather than accepting a passing neighbor as proof.

## Verification

A pass-runner brief asking an agent to confirm or re-verify a prior claim states this rule explicitly when the claim is about a self-test's coverage or about a specific runtime effect of a code path, not just its presence. The two failure instances that prompted this lesson were themselves caught by the same agent immediately re-deriving the claims from the real system in the next round — that re-derivation, not a lighter check, is the standard this lesson asks be applied the first time.
