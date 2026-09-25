---
id: LESSON-0051-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04, 06]
keywords: [design-claim, categorization, taxonomy, toggle, ops-toggle, feature-flag, carve-out, ellipsis, splice, exemption]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, standards/frameworks/FEATURE_FLAGS.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md]
status: candidate
note: |
  Originally written by the cross-verifier directly to lessons/2026/LESSON-0049-candidate.md
  during the /review pass-runner run for prbot PR #44. Relocated here per this run's explicit
  constraint (see lesson-candidate-1.md's note for the full explanation). The id above is
  provisional; the caller should assign the real next global LESSON-NNNN slot when merging.
---

## What went wrong

A design-claim in a `/review` pass (prbot PR #44) concluded that a new opt-in setting was an "Ops toggle", and so did not need a flag cleanup ticket and deadline. Three parts of that did not hold:

- **The category did not fit.** The source defines an Ops toggle as a "Kill switch / circuit breaker". The facts the finding itself cited, a default held off "on measurement" until there is more evidence, match the source's Experiment toggle instead ("data drives decision").
- **The `why` supported a different point.** It showed the repository has no flag registry, not that the setting belongs in the category the conclusion needed.
- **The quote was spliced.** The cited excerpt joined the carve-out paragraph's opening, "(these are not features, so the mandate does not apply): ...", to a later sentence of the same paragraph, "Ops and permissioning toggles default to their safe state ... rather than literally off", and cut the actual carve-out list in between. As quoted, it gives ops toggles an exemption from the mandate. In the source, that sentence only changes their default state.

## Why it happened (root cause)

The verbatim check runs on each fragment separately. An ellipsis that removes the list an opening clause introduces therefore passes, even though it changes what the quote says. Separately, placing the setting in one of the source's categories looked like a citation ("the source's Ops toggle") when it was the author's own inference. Nothing required the author to quote the category's defining criteria and show a fact meeting each one.

## How to prevent it (the rule)

When a design-claim's conclusion depends on putting its subject in a category the source defines, quote that category's defining criteria and cite a fact for each one. Never cut the text that a quoted opening clause or colon introduces, and check that any excerpt joined by an ellipsis still means the same thing once the removed text is put back.

## Verification

- The cross-verifier puts back the removed text of every excerpt joined by an ellipsis and rejects the finding when the meaning changes.
- A design-claim that places its subject in a category without quoting and matching that category's definition is treated as synthesis at 60-74 confidence, not as a sourced claim.
