---
id: LESSON-0025
date: 2026-09-19
trigger: self-detected
phases: [02.5, 04, 05]
keywords: [lock, coordination, parallel-agents, background-wait, until-loop, gate, timing, contention]
related-rules: [standards/operations/SCHEDULED_WORK.md, agents/pass-runner.md]
status: active
---

**Provenance.** D5 round 4 of `/solve`, Pass 4, Sofaoke `song-processing`, 2026-09-19. Recorded in that
project's `cdocs/solve-song-processing/run4/d5/runlog.jsonl` (event `incident`, 01:52:51Z) and finding
D5R4-LOCK-01 in `cdocs/.pipeline-solve/pass4/d5r4-findings.yaml`. There was no effect: the timed work the new
lock protected had ended 55 s before.

## What went wrong

A background until-loop waited for three lock files by name, then ran a test suite. While it waited, the
orchestrator added a fourth lock, `chain-retiming-running.lock`, and said so in the gate text. The loop did not
know that name, saw none of its three locks, and ran the suite at 01:51:32Z while the new lock existed. The
harness's own lock helper had the same fixed list.

## Why it happened (root cause)

The lock protocol lets the coordinator add a lock mid-run, but each waiter was written against the lock names
known when it was written, so a new lock was invisible to every wait already running.

## How to prevent it (the rule)

**A wait on shared locks counts every lock file in the lock directory, not a list of names, and treats a lock
it does not know as barring everything.** Only a lock whose narrower meaning is documented is let through for
the work it does not bar.

## Verification

- A harness or loop that tests for named lock files rather than listing the lock directory is a finding.
- A unit test creates an unknown `*.lock` and asserts every kind of wait sees it.
- The category that should fall to zero: heavy work that starts while a lock exists that the waiter did not know.
