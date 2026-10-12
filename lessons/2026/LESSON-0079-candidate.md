---
id: LESSON-0079
date: 2026-09-28
trigger: xv-rejected
phases: [03]
keywords: [aws-docs, stale-doc-note, vendor-limitation, conditional-writes, If-None-Match, CopyObject, UploadPartCopy, whats-new, api-reference, contradicting-pages, VERIFIED-tag]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
---

# A vendor limitation is checked against the API reference and later launch notes, not only the page quoted

## What went wrong

A design claim held that, under an S3 bucket policy enforcing `If-None-Match`, a `CopyObject` into an add-only
prefix cannot succeed, so files must be promoted with a one-part `UploadPartCopy` multipart upload completed with
`If-None-Match`. The quote behind it was verbatim on AWS's "Enforce conditional writes" page: "CopyObject requests
made with those HTTP headers fail with a 501 Not Implemented response". The record tagged it [VERIFIED]. AWS's
other sources, fetched the same day, say the opposite. The conditional-writes page lists `CopyObject` among the APIs
that take `If-None-Match` and gives a `copy-object ... --if-none-match "*"` example. The `CopyObject` API reference
documents `If-None-Match`: "Copies the object only if the object key name at the destination does not already exist
in the bucket specified". And AWS's What's New post of 2025-10-29 says "you can use the s3:if-match and
s3:if-none-match condition keys in your S3 bucket policies to enforce conditional copy operations". The quoted note
is older than that launch and was never updated. The claim's summary also listed `UploadPart` as a call that carries
`If-None-Match`, but the same enforce page says `UploadPart` does not accept conditional headers. The call that
carries the condition is `CompleteMultipartUpload`.

## Why it happened (root cause)

Verification stopped once the quote was found on the page. A verbatim match shows that the page says something. It
does not show that the vendor still says it. Vendor docs are edited one feature at a time, so a note on one page can
go stale when a later launch changes the behavior it describes. The evidence schema does not ask for a second vendor
source when a design decision depends on a behavioral limitation. A [VERIFIED] tag resting on one page therefore
carried a stale limitation into a design choice, a rejected alternative and a post-apply test plan.

## How to prevent it (the rule)

Before tagging a vendor limitation [VERIFIED] when a design choice depends on it ("X fails", "X is not supported",
"use Y instead"), also read that API's reference page and search the vendor's What's New for the API. If any source
disagrees, tag the claim [CONTESTED], cite both, and settle it by making the call.

## Verification

Cross-verifier votes of the form "quote verbatim, but contradicted by the vendor's API reference or a later launch"
should stop recurring. A check the next pass can run: for each [VERIFIED] vendor quote containing "fail", "not
supported", "can't" or "must", the record also cites the API's reference page or a What's New search for that API.
