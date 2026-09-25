---
id: LESSON-0070-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [unicode-escape, literal-character, raw-string, excerpt-rendering, code-point, non-printing-character]
related-rules: [standards/EVIDENCE.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
source-run: cdocs/review-prbot-pr42-c (both SEC-INPUT-05 closures, filed independently by two different specialists, both DOWNGRADED for the same reason)
---

## What went wrong

Two closures, filed independently by two different specialists checking the same finding from different angles (the character-class change and the new test), both cited source lines containing the escape sequences ` ` and ` ` (LINE SEPARATOR and PARAGRAPH SEPARATOR). Both excerpts rendered those escapes as the literal, invisible Unicode characters they represent rather than preserving the escape notation actually present in the source file. The cross-verifier confirmed both closures were substantively correct (it independently ran the real function over the full Unicode range) but downgraded both purely because the quoted text did not match the source's literal bytes.

## Why it happened (root cause)

Copying a line containing a `\uXXXX` escape sequence out of a source file and into a quoted excerpt is a place where a text-processing step (a terminal render, a markdown renderer, or the act of composing the quote) can silently interpret the escape rather than preserve it character-for-character. Because the underlying claim about what the code does was correct either way, nothing in the normal review of the finding's substance would catch that the excerpt itself had drifted from the source's literal text - only a byte-level comparison against the actual file would.

## How to prevent it (the rule)

When an excerpt's cited source line contains a backslash-escape sequence for a non-printing or non-ASCII character (`\n`, `\t`, `\xNN`, `\uXXXX`), quote it exactly as the escape sequence appears in the source text, not as the character it would evaluate to - if there is any doubt which form the source uses, read the raw bytes (e.g. `od -c` or an editor with escape sequences visible) rather than trusting how the string renders.

## Verification

The category that should fall to zero: a cross-verifier DOWNGRADED vote whose reasoning is "the excerpt shows a literal character where the source has an escape sequence" (or the reverse) where the underlying claim was independently confirmed correct.
