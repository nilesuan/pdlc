---
id: LESSON-0001
date: 2026-06-18
trigger: user-correction
phases: [04, 05]
keywords: [worktree, subagent, background, fan-out, isolation, permission]
related-rules: [agents/pass-runner.md, standards/AGENT_PREAMBLE.md, standards/operations/SCHEDULED_WORK.md, standards/platform/AUTO_MERGE.md]
status: active
---

## What went wrong

A sub-agent spawned to produce a written artifact lacked write permission - or ran in a permission posture that prompts for `Write`/`Edit` approval. In a background / non-interactive run the approval prompt had no one to answer, so the write blocked, the sub-agent produced no output and never returned. The orchestrator waited on the missing output with no deadline, so a blocked sub-agent was indistinguishable from a slow one. The run hung for about three hours instead of failing fast.

## Why it happened (root cause)

Two independent gaps compounded:

1. **Trigger (write posture).** Writing sub-agents were not guaranteed a non-blocking write posture. A `Write`/`Edit` could surface an unanswerable permission prompt and block indefinitely. A permission prompt is not a terminal error, so the usual "agent died -> returns null" recovery never fires; the call simply never returns.
2. **Blast radius (the wait).** The orchestrator's wait on sub-agent output had no deadline and no liveness probe. "Returned nothing" was treated as "still working" rather than "failed," so the run waited forever rather than detecting the missing output in minutes.

The bounded-wait + liveness discipline added in `standards/operations/SCHEDULED_WORK.md` addresses gap 2 (the effect) but not gap 1 (the cause). Both must be closed.

## How to prevent it (the rule)

Spawn every artifact- or code-writing sub-agent in a non-blocking write posture - `mode: "acceptEdits"` (or pre-granted `Write` + `Edit` for its scope; `bypassPermissions` for worktree-isolated agents) - so a write can never block on a prompt nobody can answer; AND bound every wait on sub-agent output with a deadline + liveness probe, treating empty / no-output past the deadline as failure (stop and report), never as continue-waiting.

## Verification

- A fan-out that spawns a writing sub-agent in a prompting permission mode is a finding.
- A wait on sub-agent output with no deadline and no liveness probe is a finding.
- Regression check: inject a sub-agent that cannot write; confirm the run fails within the deadline (minutes) with a named failure, not an open-ended hang.
