---
id: LESSON-0085
date: 2026-09-28
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [self-test, detector, calibration, circular, multitaper, resolution, planted-signal, registration, spike]
related-rules: [../standards/ANTI_HALLUCINATION.md, ../agents/cross-verifier.md, ../CLAUDE.md]
status: active
---

## What went wrong

A detector fix was reported as passing its registered self-test "at the literal registered threshold, no relaxation", and the self-test output reproduced exactly (8/8, 8/8, 0/8). But the self-test set its planted tone's "10 dB above baseline" by measuring a probe tone through the detector's own estimator. The fix had replaced a single-window spectrum with a 16-taper multitaper spectrum whose measured -3 dB width is 33 Hz, against the registered "2 Hz resolution or finer", so the planted tone moved with the estimator: in a genuine 2 Hz spectrum it sat about 21 dB above baseline. Tones set 10, 15, 18 and 20 dB above baseline in a 2 Hz spectrum were flagged 0 of 8 times, and a 0.1 s burst was flagged although the rule asks for 1 s or more. The code comment said the multitaper method works "without changing the frequency resolution", which measurement showed was false.

## Why it happened (root cause)

The self-test had no reference that the detector could not change. The planted signal's level was defined through the code under test, so any change to that code's units passed unnoticed. The re-tests, including the independent one, re-ran that same harness. A reproduced self-test result was then read as proof that the registered rule was met, when it only proved that the detector agreed with itself.

## How to prevent it (the rule)

Set a planted test signal's level with an estimator that is independent of the detector and fixed by the registration's own definition, such as a single-window spectrum at the registered resolution. When a detector's estimator changes, also measure its spectral window, or other resolution, against the registered figure before accepting the fix.

## Verification

For any detector fix, the cross-verifier re-plants the signal at the registered level as measured in the registered reference spectrum, not the detector's own, and reports the flag rate beside the self-test's. A detector whose flag rate differs between the two is not accepted as fixed.
