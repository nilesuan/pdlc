---
id: LESSON-0065-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [paraphrase, reconciliation, provenance, characterization, overstate, adjacent-sentence, forward-looking]
related-rules: [lessons/2026/LESSON-0002-verbatim-quote-integrity.md, lessons/2026/LESSON-0038-explain-from-the-rawest-record.md, standards/EVIDENCE.md]
status: candidate
source-run: cdocs/review-prbot-pr43-r2 (re-review of nilesuan/prbot PR #43, pass 1)
---

## What went wrong

Four findings in the same pass were each downgraded (not rejected -- the substance held) because the finding characterized a relationship between two pieces of evidence, or the scope of a provenance claim, more precisely or more certainly than what was actually read:

1. A closure claim quoted a function signature as verbatim code; the real signature had the same behavior but different formatting (type annotations spread across lines) -- a paraphrase presented inside a code excerpt field.
2. A closure claim said a CHANGELOG entry "explicitly reconciles" two figures "in the same sentence"; the two sentences were adjacent and linked only by the shared word "distinct," not a stated reconciliation.
3. A finding labeled a test gap "pre-existing" for an entire config field; only the field's error-handling sub-branch predated this PR, and the field itself was added by one of this PR's own commits.
4. A finding said bumping a container tag "would activate" a newly-added setting; the setting is in fact absent from every release checked, including the one named as sufficient, because the finding assumed a later version number implied the fix had shipped without checking that version's own code.

## Why it happened (root cause)

Each of these is a claim about a *relationship* (this quote equals that code; this sentence resolves that other sentence; this predates that; this future state contains that change) rather than a claim about a single directly-read fact. Evidence rules require the read fact itself to be verbatim and cited, but nothing currently requires the *relationship* asserted between two facts to be re-derived from both sides rather than asserted from having read one side and inferring the other.

## How to prevent it (the rule)

When a finding asserts a relationship between two artifacts (this fixes that, this predates that, this equals that, this version contains that), read both sides named in the relationship, not one side plus an inference about the other -- and state the relationship in words no stronger than what both reads jointly support (an adjacency is not a reconciliation; a version bump is not a guarantee a specific commit is included).

## Verification

- A cross-verifier re-read of both sides of an asserted relationship (not just the side with the citation) is a finding whenever the relationship claimed is stronger than what both sides support.
- The category that should fall to zero: a DOWNGRADED vote whose reason names an overstated relationship between two pieces of evidence, where each piece read alone was accurate.

## Provenance

`cdocs/review-prbot-pr43-r2/` (re-review of nilesuan/prbot PR #43, pass 1, 2026-09-25). Cross-verifier votes: CR-DUP-01-CLOSURE, CR-COMMIT-01, QA-COV-07, PLAT-DEPLOY-01 (all DOWNGRADED) in the cross-verifier's consolidated vote list for this pass. Full detail in `cdocs/review-prbot-pr43-r2/review-20260925T013912Z.md`.
