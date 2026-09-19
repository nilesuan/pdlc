---
id: LESSON-0039
date: 2026-09-19
trigger: xv-rejected
phases: [02.5, 03]
keywords: [adr, status change, accepted, frozen record, stale clause, deciders, self-contradiction, sweep, docs author, freeze]
related-rules: [standards/docs/ADR.md, standards/ANTI_HALLUCINATION.md, CLAUDE.md]
status: active
---

**Provenance.** Sofaoke, third `/solve` run, 2026-09-19. The owner accepted D5's matcher at 21:53:23Z, and the docs author moved ADR-0004 from Proposed to Accepted in commit `d7fb067`. The same edit rewrote the opening of the Deciders line to record the acceptance and left that line's closing clause as it had stood while the record was Proposed: the owner "holds round 5's rule-6 question, not yet answered". The cross-verifier rejected that claim (ACC-20, major, 90) because the line contradicted itself and because `ADR.md` hard rule 2 freezes an Accepted record, so the contradiction sat in a record that is not meant to be edited again. A dated correction line and a minimal edit fixed it.

## What went wrong

A status change was applied where the new fact belonged, and not swept through the rest of the same record. The author edited the clauses it was thinking about (Status, Decision, Evidence, Alternatives, the first half of Deciders) and missed a trailing clause of a long line it had itself rewritten minutes earlier.

## Why it happened (root cause)

The stale text was inside a line the author had already edited, so the diff looked handled: the eye checks whether a line was touched, not whether every clause of it is still true. A long, multi-clause header line hides that. Worse, the edit was the record's last one by design, because acceptance freezes the body, so nothing later would have caught it in the ordinary way.

## How to prevent it (the rule)

**When a record's status changes, search the whole record for the words of the old status before committing, not only the sections that carry the new one.** Grep the old state's vocabulary ("pending", "not yet answered", "open", "Proposed", "waits on") across the file, read every hit, and fix or justify each. On a record that freezes at this edit (an ADR moving to Accepted), do that sweep as the last step before the commit, because there is no next edit.

## Verification

- Before any commit that changes a record's status, the author runs a grep for the previous status's vocabulary over that file and reports the hit count in its result file; a non-zero count is explained line by line.
- The category that should fall to zero: an Accepted or otherwise frozen record that contradicts itself between two clauses of the same line or section.
