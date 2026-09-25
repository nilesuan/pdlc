---
id: LESSON-0016
date: 2026-09-18
trigger: xv-rejected
phases: [02.5, 03]
keywords: [universal-quantifier, no-X-can, absence-claim, adjacent-table-contradicts, own-data, label-quality, deflection, scope, cross-arm]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

# Check a "none of them can" claim against the arms you already measured

**Provenance.** `/solve` Phase 02.5 Pass 2, slug `song-processing`, 2026-09-18.
A record explained away three anomalous positives with a universal claim its own
adjacent table disproved.

## What went wrong

Three labelled same-recording pairs scored exactly 0.000 on both arms of one tool,
dragging that tool's operating point to zero. The record offered a label-quality
reading: "a 'same recording' label that **no fingerprinter can see** is more likely
a different master than a detector failure."

Five arms were measured on those same three pairs. A different arm scored them
0.5695, 0.8259 and 0.8047 - two of the three comfortably matched - and a fifth arm
returned small non-zero scores on two of them. The 0.5695 was, in the same results
table, that arm's own operating point, because these three pairs were its minimum
too. So the quantifier "no fingerprinter" was contradicted by a number printed
eleven lines above it.

The record reached the right conclusion by another route later on - "this tool's
failure is recall, not precision" - which is the reading the cross-arm evidence
actually supports, and which contradicts the label-quality sentence it had already
written.

## Why it happened (root cause)

This is LESSON-0008's failure mode moved from search to measurement. There, an
absence was asserted from a vocabulary grep; here, an absence is asserted from a
single arm's behaviour, with the quantifier silently widened from "this tool" to
"any tool". The widening is not carelessness about scope so much as a change of
subject: the sentence starts as an observation about a measurement and ends as a
claim about the world.

The deflection direction is what makes it costly. Attributing an anomaly to the
*reference* rather than the *system under test* closes the question - a bad label
needs no further work, whereas a recall failure is a finding about the candidate.
A record is at its least sceptical exactly when it has found a reason not to
investigate further, and a multi-arm bake-off is the one setting where the
disconfirming evidence is already sitting in the results table.

## How to prevent it (the rule)

Before writing that no tool, no method or no candidate can do something, evaluate
the claim against every arm already measured on that input and quote the best arm's
number; if any arm succeeds, the claim is about the failing arm and must name it.

## Verification

- For any claim in a bake-off record using `no `, `none`, `every`, `cannot` or `any`
  over the candidate set, the cross-verifier re-reads the per-arm results for the
  exact inputs named and confirms no arm contradicts it.
- A record that attributes an anomaly to reference or label quality must state what
  the other arms scored on the same items, so the alternative reading is visible.
- The finding category that should drop to zero: "universal claim over candidates
  contradicted by the record's own per-arm table."
