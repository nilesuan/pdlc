---
id: LESSON-0040
date: 2026-09-20
trigger: agent-corrected-orchestrator
phases: [02.5]
keywords: [registered quantity, pre-registration, tolerance band, definition, from memory, brief, sealed text, derived, infer]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md, standards/process/LEARNING.md]
status: candidate
---

**Provenance.** Sofaoke, third /solve run, D3's real-song line-timing check, 2026-09-20. The
orchestrator observed, correctly, that `s*` was identical across both runs on every decided
song except one, which moved 0.01 s. It then told the executor, and the user, that "the
run-to-run term in the tolerance band is nil and the band collapses to its 0.01 floor". The
executor checked the sealed text and corrected it: the band is
`max(2 x the difference between the two runs' shares, 0.01)` per class - built from the
per-class shares, not from `s*`. The record says so twice, at
`solutions/song-processing/spikes/lyric-alignment.md` lines 406 and 736.

## What went wrong

A registered quantity's definition was asserted from memory, in a brief that shaped what a
sub-agent would write into a tracked record. The measurement quoted was right; the inference
drawn from it was about a different quantity than the one named. A stable `s*` shows the
reference is stable; the two runs still separate the stem afresh, so the aligner's word
starts - and the shares built from them - can still differ. B4 reports the `s*` change
*beside* the band precisely so the two are not read into each other.

## Why it happened (root cause)

The orchestrator had carried "tolerance band max(2 x run difference, 0.01)" in working
memory across many turns. The elided noun - difference *of what* - was filled in with the
number most recently in hand, which was `s*`. Nothing forced a re-read of the sealed
definition before the claim was stated, because the claim felt like recall rather than a
new assertion.

## How to prevent it

Before telling a sub-agent, or the user, what a registered quantity means, re-read its
definition in the sealed text. Memory of a registered rule is not the rule, and an elided
noun is the tell: if the remembered form is "the difference", "the rate", "the share" with
no object attached, the object is exactly what has been lost. This binds hardest on a brief,
because a sub-agent will act on it and write it down.
