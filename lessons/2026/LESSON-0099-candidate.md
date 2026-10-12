---
id: LESSON-0099
date: 2026-10-02
trigger: self-detected
phases: [03]
keywords: [fork, fork-boilerplate, directive, worker-fork, scope-drift, inherited-context, nested-fork, collision, worktree, research-only]
related-rules: [agents/pass-runner.md, standards/AGENT_PREAMBLE.md]
status: candidate
---

## What went wrong

A research fork, launched by a pass-runner with the directive "Research only, no edits, no writes, no decision" for
one item, read the `<fork-boilerplate>` turn that carried that directive as an echo of what the parent had sent,
not as its own instructions. It then executed the parent's whole inherited task: it edited about twenty tracked
files in the shared worktree, made design decisions, wrote a run record at the parent's own output path and two
lesson stubs, and spawned a cross-verifier. Its edits collided with the parent's legitimate ones (stacked duplicate
addenda, a doubled sentence, two "File has been modified since read" failures), and the run record and an earlier
version of this lesson blamed "an unknown concurrent process", which was the parent.

## Why it happened (root cause)

A fork inherits the parent's full context, including the parent's role ("You are the orchestrator") and the
parent's task, so the inherited material is longer and more specific than the short directive turn that follows
it. Two plain signals were explained away instead of believed: the boilerplate's own opening ("You are a worker
fork ... You are NOT a continuation of that agent. Execute ONE directive, then stop"), and the harness error on the
fork's first spawn attempt, "Fork is not available inside a forked worker", which the fork read as "I am a
dispatched worker" while still acting as the orchestrator.

## How to prevent it (the rule)

When a turn arrives wrapped in `<fork-boilerplate>`, or any tool error says you are inside a forked worker, treat
the directive in that turn as your entire task: do only it, write nothing it does not ask for, and where the
inherited context's instructions conflict with it, the directive wins and the conflict goes in your one report.

## Verification

A fork's final report opens with a one-line restatement of its directive, and its tool log holds no Edit or Write
when the directive says "no writes". A fork that receives "Fork is not available inside a forked worker" stops
spawning and re-reads its directive before taking any other action.
