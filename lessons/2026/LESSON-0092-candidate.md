---
id: LESSON-0092
date: 2026-09-29
trigger: xv-rejected
phases: [03]
keywords: [sibling page, wrong page, correct quote, mis-attribution, citation, verbatim, index page, documentation JSON, near-duplicate source]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: active
---

## What went wrong

Sofaoke, `/design` revision for the owner's rulings of 2026-09-29. A cross-verifier spot check found a quote in an ADR that was byte-for-byte verbatim, and about the right subject, but attributed to the wrong one of two sibling documentation index pages (Apple publishes a "Sign in with Apple" index and a separate "Sign in with Apple REST API" index; the sentence lived on the second, the citation named the first). The pages share most of their content, name and purpose, so the mistake was easy to make and easy to miss on a re-read: the quote itself was never in question.

## Why it happened (root cause)

LESSON-0002 covers a quote that does not exist verbatim on its cited source - fabricated, spliced, or reconstructed from memory. This failure is the opposite shape: a real, correctly-transcribed quote, sourced from the right family of pages but the wrong specific one. A citation check that only asks "is this exact text on some page I can find" (or that reuses a URL fetched earlier in the same session for a different, similarly-named page) will not catch it, because the text really is out there, just one click over. Sibling pages under a shared product name are the highest-risk case, since a title match feels like a source match.

## How to prevent it (the rule)

When a source's name shares a title, product, or "index" naming pattern with another page in the same documentation family, fetch and quote from the exact URL the excerpt is being read from at the moment of citing - never from a URL fetched earlier for a same-named sibling - and record that literal URL beside the excerpt, not a description like "the X index" that could resolve to more than one page.

## Verification

The cross-verifier fetches the literal cited URL (not a same-named page it locates independently) and confirms the excerpt appears there; a quote found on a sibling page under the same product name, rather than the cited URL, is a finding, filed as a mis-citation rather than a fabrication.
