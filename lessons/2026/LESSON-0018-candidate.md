---
id: LESSON-0018
date: 2026-09-18
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [run-record, measurements.json, prose-drift, docstring, composite, snapshot, measured, write-up, rungs_used, time-bound]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, lessons/2026/LESSON-0011-candidate.md, lessons/2026/LESSON-0013-candidate.md]
status: candidate
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 1 (continuation run), Sofaoke `song-processing`, 2026-09-18. `REJECTED` on `E2E-D12-01`, and `DOWNGRADED` on `E2E-BUDGET-01` and `E2E-DISK-01` for the same root cause. Votes in `cdocs/.pipeline-solve/pass1/xv-A.yaml` of that project.

## What went wrong

An end-to-end proof wrote a correct machine record (`measurements.json`) and then three findings described that record wrongly:

- A finding said a lyric search needed a parenthetical-stripping rung because the lyrics site "does not index" the plain title. The run's own record said `rungs_used: 1`, and a fresh fetch found the plain title. The claim came from a code docstring that stated the expectation the ladder was written for.
- A finding called a range "measured" whose upper end was a composite, one song's stages plus another song's download. The source labelled it a composite; the finding dropped the label.
- A finding asserted a disk state in the present tense ("now refuses every fetch") that later work in the same pass had already superseded.

## Why it happened (root cause)

The write-up was composed from the author's understanding of the run - what the code was designed to handle, what the numbers roughly were, what the state was when last looked at - rather than read back from the run's record. Code comments and design intent read like facts about the run, and a composite or a snapshot reads like a measurement once its label is dropped. LESSON-0011 covers the time-bound case; the docstring-as-result case is new.

## How to prevent it (the rule)

**A claim about what a run did is quoted from the run's own record, never recalled.** Before any finding or write-up states an outcome of a run (which branch a code path took, how many retries, a measured range, a current state), open the record the run wrote and cite the field that shows it. A docstring, a comment or a design note states intent and is never evidence of behaviour. A derived figure keeps its derivation in the sentence ("composite: A's stages plus B's download"). A state observed at a time carries that time.

**Recurrence, same project, 2026-09-19 UTC (orchestrator's own error, corrected by the agent it questioned).** Reading D5 round 4's run log, the orchestrator summed each `download` record's `bytes` field to 4.03 GiB and flagged the downloads as video. The field is the audio directory's running total (`eval/recording-matching/r4/harvest4.py` `audio_bytes()`), not the file's size; the files were 3.7 MB and 6.5 MB of AAC audio. The record was quoted, but the field's meaning was assumed from its name. Extension of the rule: before aggregating a field from a run's record, read the code that writes it.

## Verification

- For every finding citing a run, the cross-verifier opens the run record and checks the claimed outcome against the field, not against the prose.
- The finding category that should drop to zero is "outcome asserted in prose, contradicted by the run's own record".
