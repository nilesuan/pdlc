---
id: LESSON-0074
date: 2026-09-28
trigger: xv-rejected
phases: [03]
keywords: [verbatim-quote, cited_excerpt, design-claim, working-tree, parallel-authors, same-pass-edit, stale-quote, threat-model, ADR]
related-rules: [agents/cross-verifier.md, standards/EVIDENCE.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
---

# A quote from a record still being written is re-read before the finding is returned

## What went wrong

A design-claim finding (Sofaoke `/design` pass 1, SEC-AUTHZ-01) cited ADR-0008 with the excerpt "The GPU worker
and the home fetcher reach the app through the job queue and the app's internal API, never the table". At
verification the ADR, an uncommitted working-tree file, read "reach the app through the job queues and the app's
internal routes, never the table" (lines 79-80). "job queue" and "internal API" are not in the source. The same
wording sits in the threat model's assumption A8 as a quotation of ADR-0008. The claim the quote carried, that the
worker and fetcher report through the same public REST API as browsers, had also been overtaken: ADR-0013 section 3
and the API contract's Internal section put them on a separate function that accepts only their IAM signatures,
and the public function answers those paths 403.

## Why it happened (root cause)

Three agents wrote interlocking records in parallel in one pass. The quote was taken from a record another agent
was still revising, or was paraphrased, and nothing re-read the cited text against its final state before the
finding was returned. The finding's own record listed ADR-0013 and the API contract as "not yet readable" when it
was drafted, so the conclusion rested on a partial set of records.

## How to prevent it (the rule)

Before returning a finding whose evidence is a file written or edited in the same pass, re-read the cited lines
and paste the excerpt from that re-read; if the text changed, re-derive the claim from the current file or drop the
finding.

## Verification

A literal, whitespace-normalized search of every `cited_excerpt` against the working tree at return time finds each
one; the cross-verifier's "excerpt not in source" rejections on same-pass files drop to zero.
