---
id: LESSON-0044
status: candidate
trigger: xv-rejected
date: 2026-09-20
finding: REC-D3-09
scope: absence claims in audit findings
---

# An absence claim needs a negative control, not just a positive one

## What went wrong

Finding REC-D3-09 claimed that two registered limits - A7.4 ("the check is blind to a
constant bias under 1.0 s") and A7.8 ("this is a line-level check ... it says nothing about
words inside a line or about the [-0.30, +0.20] s window") - "appear in none of the five
records".

Its `checked` field reported the mechanism: a grep over all five records for
`constant bias|blind to|words inside a line|line-level|line level|within a line`, whose
"only hit is an unrelated JamendoLyrics row in the register", with a positive control that
fired on a doctored copy.

Re-running that exact pattern over the same five files returns ten hits, not one. A7.4's
sentence is present verbatim at `solutions/song-processing/spikes/lyric-alignment.md`
lines 414, 743 and 841, and again at 1484-1485 in a sealed amendment that names A7.4 by
number. A7.8's sentence is present at lines 392, 442 and 854-856. The cited excerpts exist
and the line pointers are sound; the synthesis built on them contradicts the source.

## The failure mode

A positive control proves the *pattern* can fire. It does not prove the *corpus* the grep
reached is the corpus the claim is about. Here the control was a doctored copy of one
record (the run record); the claim ranged over five. The control fired on the copy, the
real search returned a near-zero on the five, and nothing connected the two. The reported
zero was a false zero of scope, not of syntax.

A second, independent signal was available and unused: the claim's own wording named the
limits by number, and A7 itself - the block being cited - contains both sentences. An
absence claim that is falsified by the very block it cites should not survive its author's
own read.

## What to do instead

- For an absence claim, run the negative control too: take a source that is *known to
  contain* the thing, in the real corpus, and confirm the search finds it there. If no such
  source exists, say so.
- State the corpus and the hit count, not "the only hit is X". Print the count from the
  same invocation that produced the claim.
- Before reporting "X appears nowhere", read the clause X is quoted from. If X is a
  numbered item in a cited block, X appears at least there.
- Narrow the claim to the mechanism actually tested. "A7.4 and A7.8 do not travel into any
  post-run report region" is true, checkable, and is the defect worth fixing; "they appear
  in none of the five records" is neither.

## Where this bites next

Any finding of the shape "nothing here says X", "the only trace is Y", or "it is cited to
the wrong clause". These are absence claims wearing a positive face, and each one needs its
reach verified before its zero is reported.
