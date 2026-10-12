---
id: LESSON-0083
date: 2026-09-28
trigger: xv-rejected
phases: [02, 05]
keywords: [error-bound, approximation, latency, look-ahead, algorithmic-delay, chunking, measurement-validity, on-phone-test, OP-2]
related-rules: [agents/cross-verifier.md, standards/EVIDENCE.md]
status: candidate
---

# An approximation's error bound was stated without deriving it from the code that decides which frames it covers

## What went wrong

A browser test page measured a registered per-frame delay ("for each frame, the time from its center sample reaching
the page's audio graph to its final pitch being available") by timing each 200 ms chunk against that chunk's own
center. The disclosure said this could misstate a frame's delay "by up to roughly half a chunk width (100 ms) in either
direction." But the frames returned after a chunk are the ones that chunk made final, not the ones whose center it
held. For a detector that finalizes a frame only after 176 ms of later audio, every frame is charged a delay 76 to
276 ms shorter than its true delay. The page's own output showed the problem: that detector's reported p95 delay,
122 to 125 ms, was below its registered 176 ms algorithmic delay, which is a lower bound on every frame's true delay.

## Why it happened (root cause)

The bound came from the geometry of one chunk: a frame sits within half a chunk of the chunk's center. It ignored the
emission rule in the worker, where each candidate's look-ahead decides which frames a chunk makes final. No check
compared the measured figure with a floor the registration had already stated, the candidate's own algorithmic delay.

## How to prevent it (the rule)

Derive a measurement approximation's error bound from the code path that decides which samples each measurement
covers, per candidate, and check every measured latency against the known physical or algorithmic floor before
reporting it; a figure below its floor means the measurement is not the registered quantity.

## Verification

For any latency result, the cross-verifier compares the reported percentile with each candidate's registered
algorithmic delay and treats a result below that floor as proof the metric is wrong, whatever error bound is
disclosed beside it.
