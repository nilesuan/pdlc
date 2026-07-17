---
id: LESSON-0002
date: 2026-06-12
trigger: xv-rejected
phases: [01]
keywords: [verbatim-quote, fabricated-quote, spliced-quote, paraphrase-as-verbatim, interpolated-parenthetical, miscited-source, one-quote-one-source, byte-identical, SOURCES-array, corroboration, cross-verifier]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

# Verbatim-quote integrity: a quote must appear verbatim on its single cited source

Consolidated from 12 `xv-rejected` incidents in a property-research run on 2026-06-12. All twelve were the same failure class in different disguises; this lesson is the single rule that covers them.

## What went wrong

Across twelve findings, a string presented as a verbatim quote did not appear verbatim on the single source it was cited to. The forms observed:

- **Fabricated wholesale.** The quoted phrase was invented; a literal search of the cited page did not find it, and figures were derived from the non-existent quote.
- **Wrong-source attribution.** The quote was real but bound to a landing-page or news URL that does not contain it; the text lived in a different document (a council business paper, a planning proposal, a primary planning instrument).
- **Cross-source splice / conflation.** Two individually-verbatim clauses from two different URLs were merged into one quoted string (including across an ellipsis), so the cited link confirmed only part of it.
- **Partial-quote splice.** A real opening clause carried a fabricated tail (an invented distance), so a prefix check passed while the full string failed.
- **Paraphrase-as-verbatim.** A quote was reconstructed from memory or gist and placed inside quotation marks, with factual drift in the specifics.
- **Interpolated gloss.** An author's synthesis (a correct but non-source parenthetical) was inserted inside the quote field.
- **Over-claimed corroboration and scope.** Prose claimed more corroborating sources than the SOURCES array carried, or the answer added a parenthetical absent from every cited quote, even though the individual quotes matched.

## Why it happened (root cause)

The `quote`/`fact` field was treated as a place for the agent's best recollection or synthesis of a source, rather than strictly for text that a full-text search of the live source matches exactly. Because a fragment or the leading clause was often genuinely present, a verifier that string-matched only part of the quote would pass it, letting a verbatim first half lend borrowed credibility to a fabricated or cross-sourced remainder. Dynamic aggregator pages (transit and routing sites) compounded this: route-specific numbers render differently between fetches, so a stale cached copy appeared to confirm a quote the live page no longer contained. No check enforced one-quote-one-source, end-to-end matching, or that corroboration count and answer scope stayed inside the cited evidence.

## How to prevent it (the rule)

A string in a `quote`/`fact` field must be byte-identical (modulo whitespace) to text found by literal search in a freshly fetched copy of the single URL it cites; if the exact string is absent, do not quote it and do not report figures derived from it. Specifically:

- **One quote, one source.** If a claim spans two pages, file one evidence entry per URL; never merge clauses into a single quoted string, and verify each fragment on both sides of an ellipsis independently against its own URL.
- **Match end to end,** not just the opening clause.
- **Never reconstruct a quote from memory.** If only the gist or magnitudes are confirmable, present them as the agent's own summary with a citation, never inside quotation marks attributed to the source.
- **Keep glosses out of the quote field.** Clarifying detail goes in the `why`/synthesis field, not inside the quoted string.
- **High-fabrication-risk figures are the agent's own measurement.** Distances, travel times, and planning-control figures (storey or metre heights, FSR) are cited from a routing tool or the primary instrument (Trip Planner, LEP amendment, planning proposal, TOD SEPP schedule), not laundered as a quote from a news summary or marketing page.
- **Corroboration and scope stay inside the evidence.** Every "confirmed across N sources" claim must have each source present with its own verbatim quote in the SOURCES array, and the answer must not assert scope beyond the cited quotes.

## Verification

For every finding carrying a `quote`/`fact`, the cross-verifier fetches the single cited URL and confirms the full string is present by literal search. A quote whose exact string (end to end, every ellipsis fragment) is absent from its cited page is a finding. Calibration: REJECT when the fabricated or mislocated string is load-bearing; DOWNGRADE (not REJECT) only when the substance is independently verbatim-sourced elsewhere in the same finding and the fabricated string is non-load-bearing. A prose corroboration claim without a matching SOURCES entry-plus-quote, or an answer parenthetical absent from every cited quote, is a finding on the same basis.
