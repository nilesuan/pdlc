---
id: LESSON-0055-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04]
keywords: [cost-estimate, budget, prior-finding, premise, prompt-assembly]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

## What went wrong

A finding in the prbot PR #45 review framed the new verifier's cost effect as scaling a gap "already flagged" by a prior review's finding, described as the cost estimate ignoring PR metadata size, and concluded the verifier introduced no independent new gap. The prior finding's text is not in the repository, so the premise could not be checked, and the code contradicts both halves: the estimate's input text is the join of chunk prompts that already embed the PR title, author and description, and the verifier's real prompt appends a block of findings that the estimate never prices, which is a new, verifier-specific gap.

## Why it happened (root cause)

The claim reasoned from a remembered summary of another review's finding instead of from the code, and only the lines that register the extra model in the estimate were read, not the lines that assemble what the verifier actually sends.

## How to prevent it (the rule)

Do not rest a claim on another review's finding unless its text is quoted in the evidence, and before asserting that a new component adds "no new" cost or risk, trace every input it actually sends, not only the place it is registered.

## Verification

Findings that cite a prior-review finding ID quote its text; "no new gap" claims cite the code that builds the component's request.
