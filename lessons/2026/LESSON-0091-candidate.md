---
id: LESSON-0091
date: 2026-09-29
trigger: xv-rejected
phases: [03]
keywords: [sweep, supersession, supersedes, clause by clause, hit count, vocabulary, reproducible, completeness, grep, comm, LESSON-0021, LESSON-0039]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, standards/docs/ADR.md, lessons/2026/LESSON-0021-lint-absence-claims-before-verification.md, lessons/2026/LESSON-0039-status-change-sweeps-the-whole-record.md]
status: active
---

**Provenance.** Sofaoke, `/design` revision for the owner's rulings of 2026-09-29. A new ADR superseded two sections of an Accepted one and listed, clause by clause, what else it replaced. The finding that reported the LESSON-0039 sweep of the older record said "80 hits on 64 lines outside the status line, 0 contradictions". The cross-verifier could not reproduce the count across 18 vocabularies and found two lines with the old wording that the list did not name, so it rejected the finding. The next pass reran the sweep with five stated vocabularies: 17 clauses on 28 lines had not been named, the two found among them.

## What went wrong

A completeness claim from a sweep ("0 contradictions") was reported as a count with no command, no vocabulary and no record of how each hit was judged. It could not be reproduced, and it was wrong: the sweep had used one vocabulary, and lifecycle words it did not contain ("replacement instances", "standing volume", a pointer such as "(section 4)") never reached the reader.

## Why it happened (root cause)

LESSON-0039 says to grep the old state's vocabulary and report the hit count, and LESSON-0021 says an absence claim needs a pasted search. Neither says the vocabulary itself must be stated, varied, and checked against a per-line verdict. A single hand-picked word list finds what its author already had in mind, and a bare count looks like evidence while proving nothing about the words left out. A tooling trap sits in the same place. `comm` on numerically sorted line numbers gives wrong set differences with no error. It needs lexical order, so the set arithmetic behind a sweep's counts can be silently wrong too.

## How to prevent it (the rule)

**Report every sweep as a reproducible record: paste each exact command with its regex and flags, the lines or sections excluded, its line and hit counts, and a count of the verdict on each hit line (unrelated, still true, already named, gap). Build at least two differently made vocabularies (the old state's words, and its figures or cross-references), and do set arithmetic on line numbers with awk, never with `comm` on numerically sorted input.**

## Verification

- A sweep finding carries its commands and a per-verdict count whose total equals the union of the vocabularies' hit lines; the cross-verifier reruns the commands and gets the same numbers.
- The category that should fall: supersession lists, or status lines saying "the rest stands", that a later pass finds incomplete.
