---
id: LESSON-0093-candidate
date: 2026-09-29
trigger: audit-finding
phases: [03]
keywords: [decision-stub, citation, pointer, sweep, deferred, cross-reference, subject-name, scope-removal, renumbering]
related-rules: [standards/docs/ADR.md, standards/process/LEARNING.md, agents/pass-runner.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md]
status: candidate
source-run: karaoke design/spot-and-signin, design-drop-apple-2026-09-29
---

## What went wrong

A `/design` revision collapsed one item of a numbered decision record into a pointer stub: the item's subject (Sign in with Apple) was dropped from scope, and the item's number was kept, unrenumbered, as a one-line pointer to a deferred section. Five parallel writer agents correctly removed the dropped subject's own clauses from every sentence across 21 files that had described it. In six of those files, 20 citations of the stub's item number survived, still attached to sentences that no longer needed it, each citing a list or range ("Decisions 8 and 9", "Decisions 2, 4, 5 and 6", "Decisions 1 to 6") rather than the bare number alone. A sweep for the dropped subject's own name found none of them, because a citation like "(ADR-0018, Decisions 8 and 9)" contains no trace of what Decision 9 was about.

## Why it happened (root cause)

The two edits that needed to travel together, removing the clause a citation supports and removing that citation's number from its list, sit in different places in the sentence. A writer scanning for the dropped subject's own vocabulary sees and fixes the first without necessarily re-parsing the numbers in the citation that follows. This is the same shape as LESSON-0008: a presence check for the subject cannot find an identifier that never carried the subject's name. A parenthetical citation range is a second vocabulary the completeness sweep specified for this pass never covered.

## How to prevent it (the rule)

When a numbered item in a decision record is collapsed to a pointer stub rather than deleted and renumbered, run a second sweep for the item's own number as it appears in citations, accounting for list form ("N and M"), range form ("N to M"), and citations wrapped across a line break, across every file that could cite it. Confirm every surviving citation of that number still supports a sentence about the stub's subject. A sweep for the subject's name is necessary but not sufficient; the stub's number is a second, independent identifier that must be swept for on its own.

## Verification

The rule held on this same pass: a follow-up scan built exactly this way (expanding list and range forms and line-wrapped citations) found the 20 stale citations that a subject-name-only sweep had missed, and confirmed zero remained after the fix. Going forward, any pass-runner brief that instructs an agent to collapse a numbered item to a stub should also instruct a citation-number sweep, not only a subject-name sweep, before the pass is scored.
