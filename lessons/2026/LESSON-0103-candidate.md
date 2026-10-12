---
id: LESSON-0103
date: 2026-10-03
trigger: xv-rejected
phases: [03, 04]
keywords: [alert-number, cites-by-that-number, attribution, rule-origin, misparse, numbering-authority, cross-reference, parenthetical-citation]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A gap-audit finding (ARCH-05, Sofaoke repo) claimed `design-doc-sofaoke-v1.md` misattributed an alert's number: the design doc's sentence "...is alert A14 in [review and monitoring], section 2, and the records cite it by that number (ADR-0018, Decision 7 and Consequences)" was read as asserting that ADR-0018 itself uses the token "A14". A literal search, `grep -c "A14" docs/adr/0018-provider-sign-in-and-tv-pairing.md`, returned 0, which the finding took as confirmation. The cross-verifier rejected it: the sentence names "the records" (plural, general - review-and-monitoring.md, which does number it A14) as the thing cited "by that number", and cites ADR-0018 only as the *rule's* origin (Decision 7 and Consequences state the alert's trigger, not its number). The same sentence shape, numbering attributed to one record while a second is cited as the rule's source, was found doing the identical job correctly elsewhere in the same codebase (`controllers.md` lines 531-534), which is what let the cross-verifier recognize it as an established convention rather than a second instance of the same bug.

## Why it happened (root cause)

A sentence of the form "X is number N in record R2 ... and cite it by that number (R1, Decision D)" has two distinct propositions in one clause: *where the number lives* (R2) and *where the underlying rule comes from* (R1). A fast reading collapses them, especially when R1 is named closer to the number word in surface order. The finding's own verification step, grepping R1 for the number, was well-formed and honestly reported (a real LESSON-0008-style pasted search with a real zero result) - the error was upstream of the grep, in deciding what claim the grep was evidence *for*. A zero-match grep against the wrong record proves the sentence is not asserting what it was read as asserting; it does not by itself prove the sentence is wrong.

## How to prevent it (the rule)

Before filing a misattribution finding of the shape "record A never uses the term/number record B's citation implies", parse the citing sentence for how many records it names and what role each plays (numbering authority vs. rule origin vs. motivating decision) before grepping any of them. If two records are named in one clause, grep *each* for the specific thing the sentence actually claims it holds, not for the one word that is easiest to search. When the grep comes back empty, check one more real instance of the same phrasing elsewhere in the corpus before concluding the author made an error, particularly in a codebase (like this one) that has a history of cross-record citation shorthand.

## Verification

- A finding whose evidence is a single grep against one of two or more records named in the cited sentence, with no quote of the sentence's own subject/attribution structure, is a finding to send back before it reaches the cross-verifier.
- The category that should fall to zero: an `xv_rejected` vote whose reason is "the cited sentence attributes the claim to a different record than the one the finding grepped."
