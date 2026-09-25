---
id: LESSON-0012
date: 2026-09-18
trigger: preoutput-gate-flag
phases: [02.5, 01, 03]
keywords: [verbatim-quote, markdown-link, relative-link, pre-output-gate, verify-artifact, broken-links, fenced-code-block, quote-integrity, false-positive]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md, standards/AGENT_PREAMBLE.md]
status: candidate
---

# A verbatim quote containing markdown link syntax trips the relative-link gate, and fencing it does not help

**Provenance.** `/solve` Phase 02.5 Pass 1, slug `song-processing`, 2026-09-18, while authoring
`cdocs/solve-song-processing/run2/licence-and-supplychain-ruling.md`. Caught pre-output and fixed
before the artifact was reported, but `scripts/verify-artifact.sh` returned `broken=1`, which is
trigger 2 in `AGENT_PREAMBLE.md` §"Learn from mistakes".

## What went wrong

The artifact quoted a licence block verbatim from a GitHub README, per LESSON-0002's rule that a
quote must be byte-identical to its cited source. One quoted line was:

```
* The code in this repository is released under the [MIT license](LICENSE.txt).
```

`scripts/verify-artifact.sh` parsed the `[MIT license](LICENSE.txt)` inside the quote as a link
belonging to *my* document, resolved it against the artifact's own directory, found no
`LICENSE.txt` there, and reported `broken=1`. The link was never mine; it was part of the source
text I was obliged to reproduce exactly.

The obvious repair, moving the quote into a fenced code block, **did not work**: the gate extracts
link syntax from inside fenced blocks too. A second gate run still returned `broken=1`.

## Why it happened (root cause)

Two correct rules collide, and nothing in either one anticipates the other:

- LESSON-0002 requires quoted text to be byte-identical, which means reproducing whatever markup
  the source happens to contain.
- The pre-output gate treats every `[text](path)` in the file as an authored link, because it has
  no way to distinguish a link the author wrote from a link the author quoted.

The collision is invisible until the gate runs, and the intuitive fix (fencing) fails silently in
the sense that it looks like it should work. An agent that fences, does not re-run the gate, and
reports completion ships a `broken=1` artifact while believing it fixed the problem.

This is not a gate defect to go patch. Per `CLAUDE.md` §6, the checker is not the thing under
test here, and rewriting it to track fenced regions and quote provenance would cost more than the
failure does.

## How to prevent it (the rule)

When a verbatim quote contains markdown link syntax with a **relative** target, quote the
contiguous portion of the source that carries the claim and does not contain that link, and
describe the excluded line in your own prose with the same citation. Never silently alter the
link inside a quote to make a checker pass, and never present a spliced quote as contiguous.

Concretely:

- Prefer trimming to a **contiguous** sub-block. LESSON-0002 forbids splicing two fragments into
  one quoted string; it does not forbid quoting fewer complete lines.
- Say in the artifact which line you left out and why, so a reader can see the quote is a subset
  by choice rather than by accident.
- Reference-style links (`[text][ref]`) and absolute URLs do **not** trigger this. Only inline
  relative targets do.
- **Always re-run `scripts/verify-artifact.sh` after the repair.** Fencing looks like a fix and
  is not one.

## Verification

- `scripts/verify-artifact.sh <artifact>` returns `broken=0` on the final file, run after the last
  edit rather than after the first attempted repair.
- The failure category that should drop to zero is "artifact reported complete with `broken=1`
  caused by a link the author quoted rather than wrote".
- Counter-signal to watch: a quote silently edited to remove or absolutise a link, which would
  trade a gate failure for a LESSON-0002 fabricated-quote failure. That is strictly worse.
