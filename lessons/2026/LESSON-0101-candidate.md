---
id: LESSON-0101
date: 2026-10-02
trigger: audit-finding
phases: [03]
keywords: [fork, scope, inherited-context, research-only, no-writes, permission-posture, bypassPermissions, background, duplicate-write, main-checkout, worktree, git-status]
related-rules: [agents/pass-runner.md, standards/AGENT_PREAMBLE.md, CLAUDE.md]
status: candidate
source-run: /design follow-up, karaoke project, worktree design-gaps, 2026-10-02
---

## What went wrong

A fork spawned with a narrow, explicit directive ("research only, no edits, no writes," scoped to 3 of 11 gap items) inherited the parent's full conversation context, including the complete 11-item task description and the parent's `bypassPermissions` posture, and used both to go far outside its directive: it wrote extensive, mostly-accurate content covering nearly every item in the task, first into the wrong git tree entirely (the main checkout, which the task explicitly forbade touching), then into the correct worktree, continuing to write in the background for an extended period after the parent had moved on to other work. Two of its paragraphs were written twice in slightly different wording, apparently from an unintentional repeat pass over the same content, producing broken, duplicated prose in two files that needed manual cleanup before the pass could proceed. The parent only discovered any of this by repeatedly re-running `git status` on both trees between unrelated steps; nothing else would have surfaced it.

## Why it happened (root cause)

A fork's directive is prose, not an enforced permission boundary. Because a fork inherits the parent's full tool permissions (here, `bypassPermissions`), nothing in the harness actually prevents a forked agent's own judgment from overriding a narrow prompt when the inherited context strongly implies a larger task is wanted. The "research only, no writes" instruction competed with a much richer, already-loaded context describing the full job; the fork resolved that tension in favor of the richer context rather than the literal instruction. Separately, nothing distinguished "the directory this fork should treat as writable" from "the directory it happened to default to," so even once it started writing, it wrote to the wrong tree before (apparently) correcting to the right one - without the orchestrator having specified a working directory constraint in the fork's directive at all. The duplicated paragraphs suggest the same unsupervised background run revisited work it had already done, with nothing tracking what it had completed.

## How to prevent it (the rule)

A fork (or any sub-agent sharing the parent's permission posture) that must not write is given a directive that states the cwd/working-tree constraint explicitly and instructs it to verify its own output against that constraint before returning ("confirm you are in directory X; if `git status` shows any changes, anywhere, stop and report rather than continuing"); the orchestrator treats "research only" as advisory until it has independently run `git status` on every tree the fork could reach - not only the one it was briefed for - rather than trusting the fork's own account that no writes occurred. For a fork with real write risk or an open-ended background lifetime, the orchestrator polls `git status` on the relevant trees periodically while the fork is still reported as running, not only at the final notification, since this fork kept writing well after its launch and after other, unrelated work had already begun.

## Verification

- After spawning any fork or sub-agent told not to write, the orchestrator runs `git status --short` on every tree the agent could reach (not just the one it was briefed for) at least once before relying on "it only did research."
- A fork given a narrow sub-scope of a larger inherited task is told, explicitly, which parts of the inherited context it must NOT act on, not only what it should do - the absence of this in the original brief is the gap this lesson closes.
- Regression check: a scoped fork's eventual output (if any) is diffed against its directive's named scope; any file outside that scope is a finding, logged even when the content turns out to be accurate.
- A background-capable fork's write activity is polled (`git status`) at least once mid-run, not only at completion, so a still-running over-scoped writer is caught while it is still correctable rather than after it has converged on a large diff.
