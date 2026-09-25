---
id: LESSON-0017
date: 2026-09-18
trigger: xv-rejected
phases: [02.5, 03]
keywords: [partial-refresh, stale-state-line, document-refresh, self-contradiction, corpus-manifest, model-pins, superseded-value, one-section-updated]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

# Refresh the whole document, or the half you left behind will contradict the half you fixed

**Provenance.** `/solve` Phase 02.5 Pass 3, slug `song-processing`, 2026-09-18.
Two committed artifacts were updated with new results in one section while a
different section of the same file kept asserting the pre-run state.

## What went wrong

Two REJECTED findings, one failure mode.

**`eval/duet-part-splitting/corpus.md`.** The "Held-out slice" section was
refreshed with the measured 2026-09-18 result (the 8/8 ChoralSynth split, A1
calibration 0.3377 against held-out 0.3384). Seventy-nine lines above it, the
document's lead sentence still read:

> **State: no candidate has ever run.** ... No D4 command has been issued and none of its 180-minute time-box was used.

Three arms and two controls had run, against a pre-registration sealed at
2026-09-17T15:50:44Z with its first command 3 min 43 s later. The same file also
still named `PANA` graded against uncollected owner line labels as "the
registered primary metric" (the binding re-registration uses `PAA`, label-free),
still headed its strata table "Registered 2026-09-14, never run", still said
"None of these is sealed; none carries a threshold" of the two corpora that went
on to carry the metric, and still gave the solo-negative count as **5** with a
**45%** honest bound where the registered and promoted values are **4** and
**52.7%** - the latter pinned in `spike_metrics/duet.py` and asserted in
`test_duet.py`.

**`eval/model-pins.md`.** The Sortformer row was correctly corrected from
"not fetched" to fetched, with a SHA-256 that re-derives exactly against the
on-disk blob, and a note 8 lines below explained the correction. Forty-six lines
further down, an untouched paragraph still read:

> Three rows currently have no manifest entry because nothing has been fetched: pyannote, Sortformer, and every D14 row.

Both halves of that sentence were now wrong: Sortformer *had* been fetched, and
the count was not three - seven pinned rows carrying real hashes were absent
from the scratch manifest (WeSpeaker, Sortformer, and five GAME ONNX files).

In both cases the *new* content was accurate and independently verified. The
defect was entirely in what was left standing beside it.

## Why it happened

A correction is naturally scoped to the thing being corrected: the row, the
table, the section that now has a number in it. The claims that *depend* on the
old state live elsewhere in the file - in a lead paragraph, a downstream
obligation, a section heading - and they do not announce themselves when the
edit is made. A find-and-replace on the changed value does not find them,
because they restate the old state in different words ("nothing has been
fetched", "never run", "has no reference") rather than repeating the value.

Both files also had the property that makes this expensive: a structural gate
checks they *exist* (`check_pin_gate.py --structure` verifies every component
has a `corpus.md` and a `thresholds.md`) but nothing checks they are *true*. A
green gate beside a stale document is the "passing check proves only what it
checks" failure.

## What to do instead

When a measurement lands and a committed document is updated to carry it:

1. **Re-read the whole file after the edit, not the hunk.** Specifically the
   lead/State paragraph, every section heading containing a state word ("never
   run", "pending", "not started", "blocked"), and any paragraph stating an
   obligation or a count that the new fact changes.
2. **Grep the file for the state words, not the changed number.** `never run`,
   `not fetched`, `no candidate has`, `pending`, `has not started`, `will be`.
   The stale claim almost never contains the value you just edited.
3. **Check counts you did not personally recount.** "Three rows" was inherited
   from a prior pass and had silently become seven.
4. **When a superseded registration and a live one coexist in one document,
   label every number with which round it belongs to.** The 5/45% figure was
   genuinely correct - for the superseded 2026-09-14 registration - and became a
   defect only by sitting unlabelled in a file dated 2026-09-18.
5. **Treat a document whose existence is gated but whose content is not as
   needing a human read**, and say so where the gate is described, so nobody
   reads green as "this file is current".

## Scope

Applies to any artifact updated in place across passes while an earlier pass's
state is still described in it - corpus manifests, model-pin registers, decision
registers, plans, and ADRs edited while `Proposed`. It does not apply to spike
records' deliberately preserved void-round sections, which are explicitly
labelled as the record of a superseded round and are correct as they stand.
