---
id: LESSON-0075
date: 2026-09-28
trigger: xv-rejected
phases: [03]
keywords: [absence-claim, negative-claim, no-limit-anywhere, working-tree, parallel-authors, same-pass-edit, stale-observation, resolved-in-pass]
related-rules: [agents/cross-verifier.md, standards/EVIDENCE.md, lessons/2026/LESSON-0011-candidate.md]
status: candidate
---

# An absence claim is re-checked after the parallel authors finish

## What went wrong

A major finding (Sofaoke `/design` pass 1, SEC-DESIGN-01) said any Google account could trigger paid GPU processing
"with no limit anywhere in the design", citing UC-09 in `docs/use-cases.md`. At verification, UC-09 step 3 itself
ends a request as couldn't-process when "the requester has used up their daily limit of audio, the day's global cap
is used up, or the worker's monthly brake is on"; ADR-0013 section 8 sets a 240-minute daily cap and a 100-hour
monthly brake, citing the threat model's TM-API-07; and the API contract sets 60 minutes a day per account. The
finding's own recommendation had been carried out in the same pass, so its claim was false when it reached
verification.

## Why it happened (root cause)

The absence was observed before the other agents in the pass wrote their records, and the finding was returned
without re-running the search against the final working tree. An absence claim has no excerpt that can go missing,
so checking that the cited lines still exist does not catch that the claim has become false.

## How to prevent it (the rule)

Re-run the search behind every "no X anywhere" claim after all agents in the pass have returned, and state the
claim with its search and time; if the search now finds X, report the finding as resolved, not open.

## Verification

Each absence-claim finding carries the search it rests on and when it ran; the cross-verifier re-runs that search
and gets the same result.
