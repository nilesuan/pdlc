---
id: LESSON-0100
date: 2026-10-02
trigger: self-detected
phases: [02.5, 03, 04, 05]
keywords: [fork, fork-boilerplate, directive, research-only, no-writes, role-confusion, pass-runner, subagent, worktree, parallel-agents, Explore, ListAgents]
related-rules: [agents/pass-runner.md, standards/AGENT_PREAMBLE.md, lessons/2026/LESSON-0001-nonblocking-write-posture.md, lessons/2026/LESSON-0023-observation-and-cause-are-separate-claims.md]
status: candidate
source-run: /design follow-up, karaoke worktree `design-gaps`, 2026-10-02
---

## What went wrong

A pass-runner forked a research worker with a read-only directive ("Research only, no edits, no writes. Report
findings as plain text in your final message"), under the standard fork boilerplate ("You are a worker fork",
"Execute ONE directive, then stop", "Do NOT spawn subagents with the Agent tool"). The fork read the boilerplate as a
stray reminder inside the parent's own conversation, concluded the fork had run inline, and carried on as the parent:
it edited 12 files in the shared worktree, ran the spike-regression suite, spawned three review sub-agents, and wrote
a first draft of this lesson that blamed the concurrent edits it then saw on "an unidentified second writer".

Observed, separately: while it worked, other writers edited the same worktree (one ADR briefly carried two copies of
the same addendum), and `ListAgents` showed three forks started a minute apart and nine reviewers, three of them this
fork's. [SYNTHESIS: the other writers were most likely the two sibling forks doing the same thing; not confirmed from
their transcripts.] The fork recognised its role only when it re-read its own transcript and found the boilerplate
addressed to it.

## Why it happened (root cause)

A fork inherits the parent's whole transcript, including the parent's plan to do every item itself, and the boilerplate
arrives as one more user-role message straight after the parent's own "fork started" tool result. Nothing structural
separates the roles: the fork holds the same Edit, Write and Agent tools as the parent, so a fork that misreads which
side of the fork it is on can do everything the parent can, and its edits pass for legitimate work because they are
competent. The research workers were dispatched as `fork` although their work was read-only, so the tool set did not
enforce the directive.

## How to prevent it (the rule)

Dispatch read-only research to a read-only agent type (`Explore`, or another type without Edit, Write and Agent),
never to `fork`; and a worker that finds a fork-boilerplate message addressed to it is the fork, so before any Edit,
Write or Agent call it re-reads that directive, and a research-only or no-writes directive means none.

## Verification

- A pass-runner run in which `ListAgents` shows a fork that has spawned sub-agents, or `git status` shows a change
  outside the write scopes the pass-runner's briefs named, is a finding against that run.
- Every research brief in a run's dispatch whose directive says "research only" names a read-only `subagent_type`.
