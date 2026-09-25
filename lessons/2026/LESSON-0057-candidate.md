---
id: LESSON-0057-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [overstate, inference, silence, absence-of-evidence, claim-scope, satisfied, well-above]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0021-lint-absence-claims-before-verification.md]
status: active
---

## What went wrong

In the same PR #45 review, three further findings — QA-FLAG-01 ("clause satisfied"), QA-COV-05 ("well above QUALITY.md floors"), SEC-INJECT-02 ("only promoted", "never exercised") — each had a verbatim, correctly-located excerpt, but the claim's summary judgment reached past what the excerpt directly showed. QA-FLAG-01 called a feature-flag clause satisfied when the flag's default is on, so no default-off path exists to test (only the explicitly-disabled path is tested). QA-COV-05 called coverage "well above floors" from an aggregate figure without checking the standard's own per-path floor, which a subdirectory misses. SEC-INJECT-02 inferred "the demotion path was never exercised" from a research note's silence about demotions, not from a statement that it wasn't exercised. The cross-verifier downgraded all three: the cited text was real, but the sentence built on top of it claimed more than the citation supports.

## Why it happened (root cause)

A finding's `why` field is supposed to connect excerpt to claim, but nothing distinguishes a direct restatement of the excerpt from a summary judgment that quietly widens its scope ("tested" becoming "the mandate is satisfied"; "no mention of X" becoming "X never happens"). The evidence schema requires the excerpt to be verbatim; it does not require the claim's own scope to be no wider than what the excerpt states, so a plausible-sounding conclusion one inferential step beyond the source passes every structural check.

## How to prevent it (the rule)

When a finding's claim uses a totalizing or evaluative word ("satisfied", "well above", "never", "only") about something the standard defines with more than one clause or axis, name each clause or axis the excerpt actually covers and flag the ones it does not, rather than asserting the summary judgment as if the excerpt covered all of them.

## Verification

The category to watch is a cross-verifier DOWNGRADE whose notes read as "the cited text is real but overstates" rather than "the excerpt is wrong" — distinct from LESSON-0021's absence-claim-with-no-search pattern, since all three findings here did carry a real, correctly-cited search or read. It should fall relative to CONFIRMED votes once findings state which sub-claims their evidence covers.
