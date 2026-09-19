---
id: LESSON-0020
date: 2026-09-18
trigger: user-correction
phases: [02.5, 04, 05]
keywords: [disk, ENOSPC, scratchpad, /private/tmp, draft, crash-durable, disk_guard, monitor, floor, TaskStop, stop-rule, time-box, interruption, login, outage]
related-rules: [standards/operations/SCHEDULED_WORK.md, standards/process/LEARNING.md, agents/pass-runner.md]
status: active
---

**Provenance.** Owner's instruction resuming `/solve` Phase 02.5 on Sofaoke `song-processing`, written 2026-09-18 UTC (2026-09-19 in the owner's time zone). The facts below are quoted from the dead run's transcripts, kept in that project at `cdocs/.pipeline-solve/pass2/crash-2026-09-18/`.

## What went wrong

A pass was killed when the data volume filled. The orchestrator read `free=6.75 GiB` at 02:11:56Z. Its disk monitor, polling every 45 s with a near-floor threshold of 6.2 GiB against a 6.0 GiB hard floor, first spoke at 02:18:47Z with `DISK-NEARFLOOR free=2.71 GiB`, already below the floor. Its next actions were diagnostic (`du`, then a `find` over the home directory) while three agents kept running, two of them writing files. At 02:19:10Z an agent's edit failed with `ENOSPC`, and at 02:19:18Z that agent's `disk_guard.py` read `0.15 GiB free`. The session died. One agent's 638-line registration amendment draft, never sealed or committed, lived only in the session's `/private/tmp/.../scratchpad/amendA.md` and was lost with it; the transcript kept only its first 6,000 characters. The drain was external, but the loss of the draft was not.

**Addendum, same run, later the same day.** The resumed run met two more external interruptions. A second external drain took free space from 185.13 GiB (15:59:49Z) to 145.04 GiB (16:17:11Z), up to 17.22 GiB in one 60 s interval; with 185 GiB free it was harmless, but on the earlier 6.75 GiB margin a drain of that size ends a run within one poll. Then an expired login killed every agent at 17:23Z to 17:29Z for about 32 minutes. Two registrations carried wall-clock time-boxes that said nothing about an outage, so each interruption needed a mid-run amendment to say whether the dead time counted (D2 3B and 3C, D5 C), and an amendment written after some results exist is exactly where HARKing hides, even when it is ruled outcome-blind.

## Why it happened (root cause)

Three gaps, each of which fails silently until the disk fills:

1. **Drafts were treated as ephemeral.** The session scratchpad is the convenient place to draft, and it is session-scoped. Nothing required a registration draft or a partial result to be written where a crash leaves it.
2. **The alert had no headroom.** The gap between the alert threshold and the floor (0.2 GiB) was smaller than the drain one polling interval can contain, so the first alert arrived after the floor was crossed.
3. **The alert had no stop rule.** Its response was to find the consumer, not to contain the damage. Writers kept writing while the orchestrator investigated.
4. **Registered clocks did not say how an interruption counts.** A time-box written as plain wall-clock turns every external outage into a question that must be answered after the run has started, when results may already exist.

## How to prevent it (the rule)

**Write every draft and partial result under the repository's `cdocs/` tree from its first byte, never only in a session scratchpad; set a disk alert's headroom above the floor to at least the largest drain seen in one polling interval plus the reaction time; on a floor alert stop every writing agent first, then investigate; and every registered clock states in advance that time the run's processes were dead for an external reason, measured from the run's own records, is excluded.**

## Verification

- Every brief that asks for a registration, amendment or partial result names a `cdocs/` path for the draft. A draft path under `/private/tmp` in a brief is a finding.
- The disk monitor has a self-test that feeds it a fake `df` below the floor and asserts it emits its stop event (done for `cdocs/.pipeline-solve/tools/disk_monitor.sh` in that project on 2026-09-18: 5.00 GiB produced `DISK-FLOOR-STOP`, 15.00 GiB produced `DISK-LOW20`, 100 GiB produced nothing).
- After a floor-stop event, the orchestrator's next tool call is a stop of every writing agent, not a diagnostic command.
- Every pre-registration with a time-box names how an external interruption is counted before the run starts; a mid-run amendment about a clock is a finding.
