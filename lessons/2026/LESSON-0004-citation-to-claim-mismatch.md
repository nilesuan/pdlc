---
id: LESSON-0004
date: 2026-08-16
trigger: xv-rejected
phases: [02, 03]
keywords: [design-claim, cited_excerpt, cross-reference, tracked-not-resolved, split, evidence-source]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: active
---

## What went wrong

A `design-claim` finding asserted that an ambiguity had been **documented as a tracked cross-reference in three
planning files** (two story `Scope` sections and an epic rollup). Its `source` and `cited_excerpt`, however, pointed
at the *upstream specification row that describes the ambiguity itself* - a data-dictionary line in
`docs/spec/5-data-model-lifecycle.md`. The quote was byte-accurate and the line number exact. The three planning
files did in fact carry the tracked note, verbatim and correctly scoped. But the cited source could not demonstrate
the claim: reading the spec row tells a reader nothing about whether any planning file was edited. The failure mode
is a **citation-to-claim mismatch** - evidence for proposition A attached to a finding asserting proposition B -
distinct from a fabricated quote, and invisible to a fidelity-only check because every character of the excerpt
verifies.

## Why it happened (root cause)

When a finding reports that *a previous finding has been remediated*, two different propositions are in play: the
original defect (sourced upstream) and the remediation (sourced in the files that changed). The evidence schemas in
[`../../standards/EVIDENCE.md`](../../standards/EVIDENCE.md) require the excerpt to be verbatim and the source to be
real, but nothing in the schema forces the source to be the artifact whose *state changed*. A resolution finding
inherits the original finding's citation by default, because that citation is already at hand and still verifies
cleanly. No structural gate catches the substitution: auto-rejection triggers 5, 6 and 7 all pass, and only a
verifier who asks "could a reader confirm *this specific sentence* by opening *this specific source*?" detects it.

## How to prevent it (the rule)

A finding that asserts a change, fix, or resolution MUST cite the artifact that changed - the edited file and the
line range of the new text - never the upstream source that motivated the change; cite the motivating source only in
addition, never instead.

## Verification

The next pass-runner can check this mechanically before the cross-verifier runs: for any finding whose `claim`
contains a resolution verb (`now`, `resolved`, `added`, `documented`, `no longer`, `is fixed`), assert that at least
one `location` / `source` path appears in the pass's set of modified files (`git status --short`). A finding claiming
a planning-tree edit while citing only `docs/spec/**` fails the check. The finding category that should drop to zero
is "resolution asserted, upstream-only citation".
