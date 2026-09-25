---
id: LESSON-0067-candidate
date: 2026-09-25
trigger: audit-finding
phases: [04, 05]
keywords: [cross-verifier, gh, VCS API, live call, read-only, worktree, constraint, PR title, PR body]
related-rules: [agents/pass-runner.md, agents/cross-verifier.md, standards/AGENT_PREAMBLE.md]
status: candidate
source-run: cdocs/review-prbot-pr45-r2/lesson-candidate-1.md
---

## What went wrong

A read-only re-review of a pull request had an explicit, blanket constraint from the calling brief: no live Bedrock or VCS API calls, worktree-only reads. The orchestrator restated this constraint explicitly in the brief for each of the three specialist sub-agents it spawned, but not in the brief for the cross-verifier that ran afterward on their combined output. The cross-verifier — which has full tool access and no narrower permission scope of its own — surfaced two claims that could not be reproduced from the worktree alone: a claim about the pull request's live title and body text (found to match nothing in any commit message, working-tree file, or git-object cache reachable from the worktree), and a claim sourced from `gh issue list --state all` used to justify downgrading a specialist's finding. Both were caught only because the orchestrator independently re-verified the cross-verifier's own output against the worktree before including it in the final report, rather than accepting a CONFIRMED/DOWNGRADED vote at face value.

## Why it happened (root cause)

The orchestrator treated "no live API calls" as a property of the *task* that would be inherited by every sub-agent working on it, rather than as a property of each sub-agent's *brief* that has to be stated where that sub-agent will actually read it. The three specialist briefs each got the constraint verbatim under a "HARD CONSTRAINTS" heading; the cross-verifier's brief only said which worktree to read from and never repeated the no-live-calls rule, even though the cross-verifier is defined with unrestricted tool access and its whole job is to reach for whatever evidence exists. A sub-agent with a live, authenticated `gh` session and no explicit prohibition will use it if the brief implies more certainty is available by using it — the omission is an invitation, not a neutral gap.

## How to prevent it (the rule)

Any blanket constraint that applies to the whole pass (read-only, no live API calls, no edits, worktree-only) must be restated verbatim in every sub-agent's brief for that pass, including the cross-verifier's, not only in the specialist briefs that produce the findings being verified — and the orchestrator must independently re-derive at least the highest-impact claims in the cross-verifier's own output from the permitted sources before including them in a scored finding or a user-facing report.

## Verification

- Every cross-verifier brief spawned from a pass with a "read-only" or "no live API calls" constraint contains that constraint in its own text, not only in the sibling specialist briefs.
- A claim in a cross-verifier's notes that cannot be reproduced by grep/read/log against the named worktree, when the pass was supposed to be worktree-only, is treated as unconfirmed and excluded from scoring rather than passed through — the category that should fall to zero is "a cross-verifier claim included in a final report that the orchestrator could not independently reproduce from the permitted sources."
