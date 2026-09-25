---
id: LESSON-0064-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 05]
keywords: [absence, grep, case-sensitive, call-arity, section-boundary, search-scope]
related-rules: [lessons/2026/LESSON-0021-lint-absence-claims-before-verification.md, standards/EVIDENCE.md]
status: candidate
source-run: cdocs/review-prbot-pr43-r2 (re-review of nilesuan/prbot PR #43, pass 1)
---

## What went wrong

Two findings in the same pass asserted an absence, each with a pasted search attached (satisfying LESSON-0021's lint as currently implemented), and each search's own scope or pattern did not cover the claim it was offered to support:

1. A finding closing a documentation defect searched for a lowercase word (`grep -n "temperature" README.md`) against a heading that used the capitalized form ("Temperature is sent only when..."), and separately misstated the boundary of the section it read (cited lines 114-122 for a list that runs 114-125, missing the line that mattered). The underlying conclusion (the defect is fixed) was still correct, but by coincidence, not because the search found it.
2. A finding claiming no test exercises two check-id prefix families searched one file with a regex anchored to a two-argument call shape (`_parse_findings\(response, "[a-z]+"\)`), when the file also contains three-argument calls. One of the two prefix families the claim covered was in fact tested via the call shape the pattern could not match.

## Why it happened (root cause)

LESSON-0021's lint (in the project that originated it) checks that a search was pasted, not that the search's scope, case-sensitivity, or pattern arity actually covers the claim's quantifier. Both failures here have a pasted, real, honestly-reported search -- the lint as documented would pass both. The gap is one level down from where LESSON-0021 currently stops: a present search is necessary but not sufficient evidence for an absence claim.

## How to prevent it (the rule)

Before filing an absence claim, restate the search's coverage in the claim's own vocabulary and case, against the claim's own boundary (every file/section the claim quantifies over, every argument shape a call to the target function can take) -- not a search that merely returns zero matches for a plausible-looking pattern in one location.

## Verification

- A cross-verifier re-run of the same search with case-insensitivity and/or a widened call-shape/section boundary is a finding whenever it returns a nonzero result the original search missed.
- The category that should fall to zero: a REJECTED vote whose reason is "the search's own scope did not cover the claim," on a finding that had a pasted search attached.

## Provenance

`cdocs/review-prbot-pr43-r2/` (re-review of nilesuan/prbot PR #43, pass 1, 2026-09-25). Cross-verifier votes: CR-COMMENT-02-CLOSURE (REJECTED, case-sensitive grep + wrong section boundary) and QA-COV-09 (REJECTED, call-arity blind spot) in the cross-verifier's consolidated vote list for this pass. Full detail in `cdocs/review-prbot-pr43-r2/review-20260925T013912Z.md`.
