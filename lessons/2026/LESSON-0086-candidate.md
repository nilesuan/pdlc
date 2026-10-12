---
id: LESSON-0086
date: 2026-09-28
trigger: xv-rejected
phases: [04, 05]
keywords: [playwright, self-test, assertion, calibration, side-effect, clamp, verified-tag, spike]
related-rules: [../standards/ANTI_HALLUCINATION.md, ../agents/cross-verifier.md, ../CLAUDE.md]
status: active
---

## What went wrong

A browser wiring test reported "click train actually applied the 12 ms calibration shift" and passed, and a run sheet repeated the claim as verified. The assertion only read back the number the page had stored from its input field. The code that uses the number clamps any positive shift to zero, because the click train is scheduled at the nominal start and cannot be moved earlier. So the test's own +12 ms and +7 ms entries changed nothing, and measured in a real browser, the first click was scheduled 0.0 ms after the call. The same page shows its "calibration shift applied" line for only as many milliseconds as the shift, not the 3 s the run sheet told the operator to check.

## Why it happened (root cause)

The assertion checked a variable written next to the effect, not the effect itself: here, the audio node's scheduled start time. A variable set before a clamp or guard runs agrees with the input by construction, so the test could not fail for the reason it names. The run sheet's "verified by reading the code" step also read the subtraction, but not the clamp two calls further on.

## How to prevent it (the rule)

Assert on the observable effect, such as the scheduled time, emitted value or network message, never on a variable the code under test sets from its own input. Exercise both signs, or both sides of any guard, whenever the value can be clamped.

## Verification

For any test whose name says an input was "applied", the cross-verifier checks that the assertion reads a value downstream of every clamp, guard or early return in the path. A test that reads only its own stored input is reported as vacuous.
