---
id: LESSON-0008
date: 2026-09-08
trigger: audit-finding
phases: [02.5, 03, 04, 05]
keywords: [omission, unowned, no-decision-owns, grep, vocabulary, absence, zero-matches, sole-instance, register, coverage, universal-quantifier]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: active
---

**Provenance.** Raised from a `/solve` Phase 02.5 Pass 1 run on `pdf-extraction-financial-docs`, 2026-09-08. At capture time none of the three mandated triggers fired - 0 `REJECTED`, 0 broken links, 0 auto-rejected - and the stub was written off-spec because the cross-verifier named this "the one systematic weakness in this set" and it accounted for all three `DOWNGRADED` votes in the pass. That capture is now within spec: `xv_downgraded >= 2` sharing a common root cause was added as a fourth trigger in [`../../agents/pass-runner.md`](../../agents/pass-runner.md) §"Lesson capture" precisely because this lesson had to be captured without one.

## What went wrong

Three findings in one pass asserted an **omission** - "no decision owns X", "nothing requires Y", "this is the sole instance of Z" - and established it by grepping for the *vocabulary* of the thing rather than for the *thing*. Each grep was correctly run and correctly reported, and each conclusion was still wrong or overstated.

- A finding claimed no access record was required anywhere, having grepped `audit trail|audit log|access log|access record|who accessed|non-repudiation` for zero matches. The file it grepped did require a recorded receiver per document, labeller ids, a held-out burn record, and an approver on every removal tombstone. Those are access records written in other words.
- A finding claimed a phrase was the sole instance of regime vocabulary across the artifacts. It was the sole instance across the three files the filer scoped, but a fourth artifact in the same directory used the identical phrase.
- A finding reported "two hits (lines 529, 567)" for a six-term pattern; line 567 matched none of the six terms. The substance survived on other evidence, but the corroborating grep result was misreported.

## Why it happened (root cause)

A presence claim and an absence claim have different verification costs, and the tooling makes the absence claim feel cheaper than it is. `grep -c` returning `0` produces a crisp, quotable, apparently-objective artifact, and it is trivially reproducible - which is exactly what makes it persuasive to a verifier. But a zero-match result is evidence about a *string set*, not about a *concept*. The gap between them is the filer's own vocabulary, which is drawn from the domain the filer is expert in, and is therefore systematically likely to miss the same concept expressed in the authoring domain's words.

Two further amplifiers: the search scope is chosen by the filer and rarely restated in the claim, so a scope-limited result gets written with a universal quantifier ("anywhere", "sole instance", "no entry"); and nothing in the evidence schemas requires an absence claim to declare the search that grounds it, so the grep lives in prose where it is not checked as evidence.

## How to prevent it (the rule)

An omission or absence claim MUST state the exact search that grounds it - pattern, file set, and result - and MUST additionally record one search for the **concept expressed in the authoring artifact's own vocabulary**, not only the reviewer's; and its quantifier ("anywhere", "no entry", "sole instance") must not exceed the file set actually searched.

Practically, before filing "nothing owns X": read what the artifact *does* say about the neighbourhood of X and name it, so the claim becomes "X is covered only partially, by A and B, and the following limb is unowned" wherever that is the true shape. A partial-coverage finding at the right severity is worth more than a total-absence finding that a verifier has to downgrade.

## Verification

- For any finding whose `claim` contains an absence or uniqueness term (`no `, `none`, `nothing`, `never`, `absent`, `sole`, `only instance`, `unowned`, `zero`), the pass-runner can assert the `evidence` block carries an explicit search record with pattern, scope, and result, and that the scope named covers every artifact the quantifier ranges over.
- The finding category that should drop to zero is "absence asserted from a vocabulary grep, concept present under other words".
- Expected signal that it is working: `DOWNGRADED` votes citing scope overstatement on omission findings fall, while the count of correctly-scoped partial-coverage findings rises.
