---
id: LESSON-0049-candidate
date: 2026-09-24
trigger: xv-rejected
phases: [04, 05]
keywords: [call-path, caller, load-bearing, unreachable-function, wrong-function, magnitude-reuse, ratio-reuse, cross-context]
related-rules: [standards/EVIDENCE.md, lessons/2026/LESSON-0023-observation-and-cause-are-separate-claims.md, lessons/2026/LESSON-0038-explain-from-the-rawest-record.md]
status: candidate
source-run: review-prbot-pr43 (PR #43, nilesuan/prbot)
---

## What went wrong

A finding (QA-COV-06) described a real behavior — chunk-boundary sizing omits PR title/body length from its estimate, and that omission's undercount roughly doubles under a PR's new, denser token-estimate constants — and named a specific function (`_file_tokens` in `chunking.py`) as the site where that behavior lives. The function and file were real and genuinely untouched by the PR being reviewed. But `_file_tokens` is not actually on the pipeline's call path for chunk-boundary decisions; the function that is actually called (`rendered_file_tokens`, via `chunk_for_prompt`) was never checked. The "roughly double" magnitude was also not derived for this specific omission — it was carried over from a different measurement (the overall character-to-token ratio shift measured elsewhere in the same PR) and asserted to apply here without re-deriving it for this case.

## Why it happened (root cause)

The filer confirmed the file was real, untouched, and topically on-point (it does compute per-file token costs, just not the ones that gate chunk boundaries), which made the citation feel grounded. But "the file is real and relevant" was substituted for "this specific function is the one actually called from the code path the claim is about." Separately, a ratio measured for one quantity (the general char-to-token estimate) was reused as the magnitude of a different, related-sounding effect (a specific omission's undercount) without checking that the derivation transfers — the two are not obviously the same number just because they move in the same direction.

## How to prevent it (the rule)

Before citing a function as "where behavior X lives" or "what computes value Y," trace the actual call path from the pipeline's entry point (grep for callers, follow one level up) to confirm the cited function is reachable and load-bearing for the specific claim — not merely present in the right file. Before restating a measured ratio or magnitude from one context as the size of a different effect, re-derive it for that specific case rather than inferring that it carries over.

## Verification

- The cross-verifier rejects a finding that cites a function with no confirmed caller on the path relevant to the claim.
- The cross-verifier rejects a finding that restates a ratio/magnitude measured in one context as the size of a different effect without re-deriving it.
- Category that should fall to zero: an `xv-rejected` vote whose reason names an uncalled function or an unre-derived magnitude.
