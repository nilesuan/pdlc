---
id: LESSON-0095-candidate
date: 2026-09-30
trigger: audit-finding
phases: [03, 04]
keywords: [ADR, stated-property, IAM-grant, mechanism-vs-property, boundary, read-path, cross-verifier, design-claim]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A story's design claimed a proposed read path "changes no accepted boundary" against an architecture decision
record (ADR-0014) that constrains a component. The claim was checked against the ADR's IAM-grant sentence (which
component has which bucket permission) and found consistent - no grant existed that the new path required, so
nothing looked like it needed to change. The ADR also states the boundary as an architectural property in a
separate sentence ("the internet-facing function... can neither read, write nor delete an object"), independent of
any specific IAM statement. The proposed path had the function sign a URL for itself and read an object - which
violates the stated property even though it required no NEW IAM grant to attempt (the read happened through a
signed URL, not a direct S3 permission, so an IAM-grant-only check found nothing to flag). A cross-verifier re-read
of the same ADR section caught the property-level violation the mechanism-level check had missed.

## Why it happened (root cause)

An ADR's constraints are not always expressed as a single, mechanically-checkable rule (an IAM policy, a schema
field, a named limit). Some are stated as an architectural property in prose ("touches no object") that a proposed
design can violate through a *different* mechanism than the one the property's neighboring text happens to
describe (here: a signed URL, not a direct grant). Checking only the mechanism the ADR happens to illustrate, rather
than the property it is illustrating, misses any other route to the same violation.

## How to prevent it (the rule)

When a design claim asserts compliance with an ADR or other constraint-bearing record, check the claim against the
record's *stated property* (the general rule, usually in a topic sentence or an explicit "can neither X, Y nor Z"
clause), not only against the specific mechanism or grant the record uses to illustrate or enforce it in its
worked example. If the ADR states a property and a separate enforcement mechanism, verify both: that the mechanism
is respected, AND that no other path in the proposed design reaches the same forbidden outcome by a different
mechanism.

## Verification

A design-claim finding that cites an ADR's boundary and votes CONFIRMED (or is written into a story as satisfied)
should quote the ADR's *stated property* sentence, not only a grant or permission sentence, whenever the record
contains one. The cross-verifier's standard protocol (re-reading the cited source in full, not only the excerpted
sentence) already catches this class of miss when it runs - the gap this lesson closes is at the authoring step,
before cross-verification, so the first-pass claim is more often right and needs one fewer correction cycle.

## Provenance (this run)

Caught during `/split v1`'s pass-runner run (worktree `split-v1`, 2026-09-30), story-007-007 (Sofaoke's scoring
route). Pass 1's design claimed a CloudFront-signed read of `play.json` "changes no accepted boundary" against
ADR-0014 section 3. The cross-verifier, asked to verify a related finding (SPLIT-007-01), re-read ADR-0014 section 3
in full and found the stated property ("the internet-facing function... can neither read, write nor delete an
object") that the pass-1 claim had not checked against - only the section's IAM-grant sentence had been checked.
The responsible agent re-read the ADR, confirmed the miss in its own words ("I had read only the IAM-grant
sentence, which was a misreading"), and redesigned the read path to use a DynamoDB table item instead, with a
negative test asserting the scoring use cases hold no `UrlSigner`, S3 or CloudFront client. This file is a
candidate stub written under `cdocs/` because the run's write scope was restricted to `planning/v1/stories/` and
`cdocs/` only - promote it to `lessons/2026/LESSON-0095-candidate.md` (the next free number as of this run) for the
standard review-and-promote step.
