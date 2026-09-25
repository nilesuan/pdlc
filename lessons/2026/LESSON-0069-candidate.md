---
id: LESSON-0069-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [excerpt, condensed-quote, ellipsis, dropped-lines, gap-marker, quote-fidelity]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
source-run: cdocs/review-prbot-pr42-c (findings SEC-DESIGN-04 closure, SEC-DESIGN-07, SEC-DESIGN-08 - three DOWNGRADED for the same reason in one pass)
---

## What went wrong

Three findings from the same specialist, in the same pass, each cited a multi-line code excerpt that silently omitted lines from the middle of the cited range: blank lines and two `logger.info` calls dropped from a ~25-line function excerpt; a `logger.info` call dropped from a 5-line block; and a 9-line `replace(...)` call collapsed to one line with a bare `...`. In every case the substance of the claim was correct and the cross-verifier reproduced the same conclusion independently - but the excerpt, as filed, was not what LESSON-0002 requires (byte-identical, modulo whitespace, to the cited location), so each was downgraded on fidelity grounds alone.

## Why it happened (root cause)

LESSON-0002 (verbatim-quote integrity) was active in this pass's brief and was followed in the sense that no fragment was fabricated - every character present in each excerpt was real. But the rule was read as "don't invent text" rather than "don't silently remove text," and condensing a longer function or call down to its load-bearing lines, without an ellipsis or a gap marker showing where lines were cut, reads identically to a verbatim quote to anyone who has not independently opened the file. Nothing in the evidence schema or the auto-rejection triggers distinguishes "shortened without marking it" from "quoted in full."

## How to prevent it (the rule)

When an excerpt covers a cited line range but omits any line inside it, mark the omission explicitly (a `...` on its own line, or an inline note of the line numbers skipped) rather than presenting a shortened block as if it were contiguous - the same discipline LESSON-0002 already requires end-to-end for a quote spanning two sources, applied here to a quote spanning a gap within one source.

## Verification

The category that should fall to zero: a cross-verifier DOWNGRADED vote whose reasoning is "the excerpt silently drops lines / condenses a call with an ellipsis" where the same defect was independently reproduced as substantively correct.
