---
id: LESSON-0019
date: 2026-09-18
trigger: xv-downgraded
phases: [02.5, 03, 04, 05]
keywords: [absence, grep, search-record, pattern-mismatch, qualifier-drift, summary, scope, recurrence, LESSON-0008]
related-rules: [lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 1 (continuation run), Sofaoke `song-processing`, 2026-09-18. `DOWNGRADED` on `D2-REF-01` and `PR-SEG-01` for the same root cause. **A recurrence of LESSON-0008, which was active and loaded into every brief of that pass, including the orchestrator's own context.** `PR-SEG-01` was filed by the orchestrator.

## What went wrong

Two absence claims carried search records, as LESSON-0008 requires, and were still wrong in ways its rule does not name:

- **Recorded pattern differs from the pattern that produced the result.** A grep was run with one pattern (including a term that happened to match two unrelated lines), then transcribed into the finding without that term, while the finding still reported the two lines as the result. The recorded pattern returns nothing. The finding also called an untracked file part of "the tracked tree".
- **The summary drops the scope of a correctly scoped claim.** A research note stated its absence claim precisely: freely licensed, not pYIN, not CREPE, continuous pitch, within the listed searches. The finding and a correction written from it summarised this as "no published non-pYIN note-level reference was found", which the note's own table contradicts: it lists a published non-pYIN note-level reference, excluded on the other criteria.

## Why it happened (root cause)

LESSON-0008 makes the search record mandatory but treats writing it down as the end of the obligation. In both cases the record existed and was not re-checked against the claim: the pattern was retyped from memory rather than pasted from the command that ran, and the claim was re-worded more briefly than its evidence, and brevity dropped the qualifiers that made it true.

## How to prevent it (the rule)

**Paste the search, do not retype it, and never state an absence more briefly than its evidence.** The search record in an absence claim is the literal command copied from the shell, with its literal output. A summary of a scoped absence claim keeps every qualifier the scope depends on, or cites the scoped sentence instead of restating it. "Tracked" means `git ls-files` returns it.

## Verification

- The cross-verifier re-runs every recorded search exactly as written and compares its output with the reported result. A mismatch is a downgrade even when the substance survives on other evidence.
- For a summary of an absence claim, the cross-verifier checks every qualifier in the source sentence is present in the summary.
- If LESSON-0008 keeps recurring with this lesson active, the fix is mechanical, not another lesson: require absence evidence as a command-and-output block the pass-runner can re-execute.
