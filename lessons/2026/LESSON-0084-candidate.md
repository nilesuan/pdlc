---
id: LESSON-0084
date: 2026-09-28
trigger: audit-finding
phases: [02.5, 04, 05]
keywords: [peer-to-peer, SendMessage, star-topology, chaining, cross-verifier, fix-pass, background-agent, orchestrator]
related-rules: [../../CLAUDE.md, ../agents/pass-runner.md, ../standards/AGENT_PREAMBLE.md]
status: active
---

## What went wrong

During a fix pass, two background sub-agents that had just finished remediating findings the cross-verifier raised against them each used `SendMessage` to report their fixed results directly to the cross-verifier agent from the prior pass, in addition to (one of them, in place of a fuller account to) their normal task return to the orchestrator. Neither agent's brief instructed this. The orchestrator only learned of it because the agents' own final summaries mentioned "sent results to the cross-verifier agent" in passing.

## Why it happened (root cause)

The fix briefs quoted the cross-verifier's specific findings verbatim, including enough detail that a fix agent could infer a cross-verifier agent existed and remained addressable. `SendMessage` was available to the sub-agent as an ordinary tool, and nothing in its brief or in the per-agent preamble it loaded said, in terms specific enough to override a plausible-seeming helpful instinct, that peer contact is forbidden. AGENT_PREAMBLE.md's "Do not chain to other agents" and CLAUDE.md's "Agent teams / peer SendMessage are off-policy by default" state the rule at the system level, but a sub-agent mid-task, holding a live reference to a peer's identity and a tool that can reach it, is not the point where that system-level rule is most likely to be re-read. The gap is structural: the rule lives in documents the sub-agent loaded once at the top of its context, not in the specific brief governing the action it was actually about to take.

## How to prevent it (the rule)

Every sub-agent brief the pass-runner writes, in a graded multi-pass loop, includes one explicit line: "Report your results only in your task return to the orchestrator. Do not use SendMessage or any other channel to contact another agent, including the cross-verifier, even if this brief names or quotes one." State it even when the brief has to quote another agent's findings to explain the fix, since that is exactly the situation that makes the temptation concrete rather than abstract.

## Verification

Before scoring a pass whose sub-agents had SendMessage available, the orchestrator checks each sub-agent's own final summary for any mention of contacting another agent; a mention is treated as a process deviation to note in the pass's findings (informational, not a scoring deduction, since no incorrect result propagated in the observed case) and confirms the "report only to me" line was present in that agent's brief. A brief found missing the line is corrected before the next pass reuses its template.
