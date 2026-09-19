---
id: LESSON-0035
date: 2026-09-19
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [audit, other tool, session log, transcript, codex, provenance, ordering, absence, cannot be confirmed, evidence search]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md]
status: active
---

**Provenance.** Sofaoke, third /solve run, pass 1, 2026-09-19. An auditor reviewed an automated acceptance check that another tool (Codex, in the ChatGPT app) had run in the same repository. Finding QA-AUTO-04 said that the tool's claim to have published its ratings before opening a sealed key "is the tool's own statement, written as constants rather than checked, and no file record can confirm it". The cross-verifier rejected it: the other tool's own session log on the same machine records the ratings being written before the key was read, and the auditor had not searched it.

## What went wrong

The finding asserted that no record could confirm an ordering. The auditor searched the evidence directory the tool left in the repository and the file timestamps, but not the tool's own session transcript, which sat outside the repository and held exactly the ordering in question. The claim's quantifier ("no file record") was wider than the set of files searched.

## Why it happened (root cause)

The audit treated the repository and its scratch directory as the whole evidence set. When another tool did the work, that tool's logs and transcripts are part of the evidence, and they live wherever that tool keeps them, not where its outputs landed.

## How to prevent it (the rule)

**When auditing work another tool or agent did, find and search that tool's own session log or transcript before stating that something cannot be confirmed, and state the searched set in the finding. Scope the quantifier to it: "the evidence directory and file times do not show X" is a finding; "no record can confirm X" needs the tool's logs searched too.** This is LESSON-0008's rule applied to evidence that lives outside the repository.

## Verification

- Every audit finding of the form "cannot be confirmed" or "no record shows" about another tool's work names the tool's log or transcript location it searched, or scopes its quantifier to what it did search.
- The category that should fall to zero: an absence finding about another tool's work rejected because that tool's own log held the evidence.
