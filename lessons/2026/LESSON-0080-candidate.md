---
id: LESSON-0080
date: 2026-09-28
trigger: xv-rejected
phases: [03]
keywords: [unspecified-field, field-semantics, schema-field, isOwner, sign-in-kind, unstated-premise, design-claim]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, standards/ANTI_HALLUCINATION.md]
status: candidate
---

# A field's value is asserted only from the line that defines how it is computed

## What went wrong

A design claim held that the API contract's `Me.isOwner` "reads true on the owner's TV even though no TV sign-in
may use the owner's surface", and recommended answering `false` to a TV sign-in. The cited excerpt, the `Me` schema
at `docs/api/sofaoke-v1-api.md:281-286`, was verbatim. It declares `isOwner: { type: boolean }` and nothing more.
A search of `docs/` for `isOwner` finds four lines: the schema's two, and two in `presenters.md` saying it shows the
review link. None says how the value is computed or whether the sign-in kind enters it. The contract's own
Authorization table defines "The owner" as "a personal sign-in whose Google account is on the owner list in server
configuration, that passed through Google in the last 60 minutes", a property of a sign-in, under which a TV
sign-in is never the owner. The claim's why line, "The flag describes the user", was the premise the asserted value
rested on, and no record states it.

## Why it happened (root cause)

The design-claim schema checks that the cited excerpt exists and that the synthesis is separated from it. It does
not ask the synthesis to cite the line that defines a computed value before stating that value. A schema that
declares a field's type reads like a specification of its value, so an implementation guess ("the flag describes
the user") passed as evidence. The real finding, that the field's value for a TV sign-in is unspecified, was
supportable. The claim stated a value instead of the gap.

## How to prevent it (the rule)

Before claiming what a field or function returns ("reads true", "returns X", "is set to Y"), cite the line that
defines how it is computed; if a search of the records for its name finds no definition, state the finding as
"unspecified" (the gap), never as a value.

## Verification

Cross-verifier rejections of the form "value asserted for a field no record defines" stop recurring. A check the
next pass can run: for each finding that states a field's or function's value, grep the records for the name and
confirm that one hit defines the computation; a finding with no defining hit is reworded as unspecified before it
is scored.
