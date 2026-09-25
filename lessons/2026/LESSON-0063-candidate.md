---
id: LESSON-0063-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [elided-excerpt, silent-omission, ellipsis, contiguous-quote, verbatim-excerpt, non-contiguous, code-citation, gap-marking]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
source-run: cdocs/review-prbot-pr42-r3/lesson-candidate-3.md
---

## What went wrong

Two findings from the same specialist pass (PR #42 r3, SEC-DESIGN-02 and SEC-INPUT-05) were each downgraded by the cross-verifier for the same reason, stated almost identically both times: the cited code excerpt silently dropped intervening lines with no marker, even though the claim's substance held up under the cross-verifier's own fresh read. SEC-DESIGN-02's excerpt quoted two `elif` lines from `src/prbot/cli.py` but joined them directly, skipping the `logger.warning(...)` call between them. SEC-INPUT-05's excerpt of `_other_path_line` (`src/prbot/review/prompts.py`) dropped lines 271-273. In both cases the deduction was for the citation's fidelity, not for the claim being wrong.

## Why it happened (root cause)

EVIDENCE.md requires an excerpt to be "byte-identical (modulo whitespace)" to the source, but says nothing about how to handle a quote that skips lines. Nothing distinguishes "this excerpt is the whole contiguous span" from "this excerpt is two real fragments joined together" — both render as an unbroken code block. An agent trimming a function down to its load-bearing lines has no instruction to mark the trim, so the excerpt reads as verbatim (and every individual line is verbatim) while silently misrepresenting adjacency.

## How to prevent it (the rule)

When a code-finding's excerpt spans lines that are not contiguous in the source, mark the gap explicitly (an ellipsis line, or a comment stating what is elided) rather than concatenating the pieces as if they were adjacent; when a function is short enough to quote whole, prefer that over trimming.

## Verification

The cross-verifier re-reads the file at the cited location range and confirms the excerpt's content matches a truly contiguous span, or that any gap is explicitly marked. The category that should fall to zero: a `DOWNGRADED` vote whose reason cites an excerpt that "silently omits" or "silently drops" lines.
