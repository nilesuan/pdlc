---
id: LESSON-0056-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [excerpt, truncate, ellipsis, cut, verbatim, byte-identical, reflow]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

## What went wrong

In the prbot PR #45 review (head 73f1571), three findings from two different agents — QA-EVAL-02, SEC-SUPPRESS-02, SEC-VERIFY-02 — each cited a real location with a real underlying defect, but each `excerpt` field cut the source with `...` or dropped a line (a trailing comment, a clause, a function's other arguments) rather than quoting the cited range verbatim end to end. The cross-verifier confirmed the claim's substance in all three but downgraded each -20 to -28 points for the incomplete excerpt, and the resulting adjusted_confidence fell below the finding's own severity's submission floor in all three cases (a major needs 70; two landed at 65, one factual chain at 58).

## Why it happened (root cause)

Nothing between drafting a finding and submitting it checks that `excerpt` is a contiguous, complete copy of the cited line range. An agent under time pressure (all three sub-agents worked a ~20-minute budget across a 26-finding, 15-file diff) will paraphrase-by-omission — keeping the load-bearing words and eliding the rest with `...` — which reads as faithful to the author but is not verbatim to a verifier who diffs it against the file. This is a milder variant of the fabricated-quote failure EVIDENCE.md trigger 7 already names; the trigger catches an excerpt that doesn't match at all, not one that matches everywhere it's present but is missing lines.

## How to prevent it (the rule)

When writing a code-finding's `excerpt`, copy the cited line range as a single contiguous block with no elisions; if only part of a range is relevant, narrow `location` to that exact sub-range rather than truncating the excerpt of a wider one.

## Verification

A pass-runner pre-check that flags any `excerpt` containing a bare `...` or `(...)` token, or whose line count is shorter than its `location` range implies, catches this before cross-verification. The category to watch is a cross-verifier DOWNGRADE whose notes cite a cut, reflowed, or shortened excerpt where the claim's substance is otherwise upheld — it should fall to zero once the check is in place.
