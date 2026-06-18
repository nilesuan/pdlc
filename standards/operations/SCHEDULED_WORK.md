# SCHEDULED_WORK.md - When to use /schedule, /loop, ScheduleWakeup, and background agents

**Authoritative source:** [`../../handbook/07-run.md`](../../handbook/07-run.md) §"Automate toil out"; [`../../research/07-operations/sre.md`](../../research/07-operations/sre.md) §"Toil" (Google SRE *Eliminating Toil*).

## What this standard governs

Recurring, long-running, and time-driven work has several execution mechanisms now: `/schedule` cloud routines (cron), `/loop` (in-session interval), `ScheduleWakeup` (in-session self-paced/bounded wait), and background agents (`Agent` background mode / `TaskCreate` / `Monitor`). This standard says which mechanism fits which work, and the discipline every mechanism must follow.

The decision filter is the **toil test**. The *Eliminating Toil* chapter gives an enumerable definition: toil is work that is **manual, repetitive, automatable, tactical, devoid of enduring value, and scales linearly with the service** ([`../../research/07-operations/sre.md`](../../research/07-operations/sre.md) §"Toil"). Google's target is keeping toil below 50% of an SRE's time. Work that matches the toil test is a candidate to automate onto a schedule or a loop rather than re-doing it by hand each session. The handbook frames automation as "the principal way to reduce repetitive operational work" ([`../../handbook/07-run.md`](../../handbook/07-run.md) §"Automate toil out").

## Mechanism decision table

| Work shape | Mechanism | Why |
|---|---|---|
| Recurring work that must run with **no session open** (nightly/weekly/quarterly audits, dependency + CVE sweeps, calibration recompute, candidate-lesson digest) | `/schedule` cloud routine (`CronCreate`) | Runs on a cron in the cloud, independent of any session. |
| One-time work at a **future** time | `/schedule` one-shot | Same cron substrate, single fire. |
| Recurring **in-session** check (poll a sub-agent's output files, watch a deploy/CI/SLO signal while you work) | `/loop` (fixed interval) | Lightweight; re-runs the prompt each interval until the session ends. |
| Bounded **condition-wait** or self-paced poll within a session (wait on an auto-merge gate, wait for a background fan-out to land) | `ScheduleWakeup` | Self-paces wake-ups with a deadline; no foreground `sleep`. |
| A **single long-running task** that should detach and re-invoke on completion | Background agent (`Agent` background / `TaskCreate` + `Monitor`) | Detached execution with a completion signal, still scored. |
| Deterministic **multi-agent fan-out** (review dimensions, migration sites) | `Workflow` primitive, **inside** the pass-runner | Schema-validated fan-out + retry + resume; see [`../../agents/pass-runner.md`](../../agents/pass-runner.md). |

The hard line: `/loop` and `ScheduleWakeup` are **session-scoped** and die with the session. `/schedule` survives session close. Choose by that lifetime first, then by shape.

## Hard rules

1. **Every scheduled cloud agent terminates in a deterministic artifact** - a findings file or an explicit no-op log - never an open-ended wait. *Why: a routine that leaves no record cannot be told from one that silently failed; "did it run?" must be answerable from the artifact.*
2. **Creating or modifying a `/schedule` routine requires explicit user approval each time, and the routine is read-only / report-producing unless the user authorizes mutation.** *Why: a cron is standing repeat authorization, which the shared-state rule in [`../../CLAUDE.md`](../../CLAUDE.md) §8 otherwise forbids; gating creation and any mutating step keeps "authorization once does not authorize again" intact.*
3. **`/loop` and `ScheduleWakeup` are never used for work that must outlive the session.** That work is a `/schedule` routine. *Why: the loop stops the moment the session closes; relying on it for durable recurring work silently drops the work.*
4. **Bound every wait with a deadline and a liveness probe. No foreground `sleep`, no open-ended wait.** *Why: a background agent that hangs before coming to rest emits no completion signal; an unbounded wait on it never returns.*
5. **Scheduled or looped work that produces graded findings still runs under pass-runner scoring and cross-verification.** The schedule is a trigger, not a second spawn path. *Why: an unscored automated fan-out reintroduces exactly the ungoverned path [`../../CLAUDE.md`](../../CLAUDE.md) §5 exists to kill.*
6. **A routine that mutates shared system state (`calibration.json`, `lessons/`, git) is the pass-runner invoked headlessly, not a new writer.** *Why: the single-writer rules in [`../process/CALIBRATION.md`](../process/CALIBRATION.md) and [`../process/LEARNING.md`](../process/LEARNING.md) depend on one recompute authority; a cron that writes directly bypasses the audit.*
7. **A writing sub-agent is spawned where it cannot block on a permission prompt, and empty output past the deadline is a failure, not a wait.** Spawn writing sub-agents in a non-blocking write posture (`acceptEdits` / pre-granted `Write` + `Edit` / `bypassPermissions` for worktree). Treat a sub-agent that returns nothing by its Rule #4 deadline as failed: stop and report per the project Subagent Failure Handling rule, never continue waiting. *Why: a `Write` that surfaces an unanswerable approval prompt blocks forever and is not a terminal error, so the Rule #4 deadline is the only thing that converts a silent hang into a fast, named failure (LESSON-0001).*

## Bounded-wait and liveness discipline

When a fan-out's outputs are files (e.g. `*-findings.json`), do not wait on notifications alone:

1. **Bound every wait.** Set a deadline (typically 5-10 min). Poll for the expected files (glob) rather than relying only on the completion notification; treat the notification contract as partial.
2. **Run short fixed fan-outs (1-3 min) in the foreground.** Synchronous spawns return when done or error out; they cannot silently hang on a missed signal, so foreground is safer for a fixed, short fan-out.
3. **Liveness probe.** After launching N background agents, periodically count the output files that exist. If one is missing past the deadline, ping or re-spawn that specific agent; recover proactively, not hours late.
4. **Match poll cadence to the watched state.** Poll a CI run that changes in minutes every few minutes, not every few seconds; idle ticks with no specific signal should back off.

## Where scheduled work already belongs (cross-references)

- **`/evolve` (Phase 08):** the quarterly audit and a lighter weekly dependency + CVE sweep are `/schedule` routines. See [`../../commands/evolve.md`](../../commands/evolve.md), [`../process/TECHNICAL_DEBT.md`](../process/TECHNICAL_DEBT.md) §"Hard rules" (quarterly hotspot regeneration).
- **Calibration maintenance:** a nightly routine ages 30-day-pending rows and recomputes the snapshot when no session is open. See [`../process/CALIBRATION.md`](../process/CALIBRATION.md) §"Scheduled maintenance".
- **Lesson hygiene:** a weekly digest-only candidate sweep. See [`../process/LEARNING.md`](../process/LEARNING.md) §"Scheduled candidate sweep".
- **Observability + on-call:** cause-based-alert archival, SLO review, stale-runbook flagging on fixed cadences. See [`OBSERVABILITY.md`](OBSERVABILITY.md), [`ON_CALL.md`](ON_CALL.md).
- **Auto-merge / worktree waits:** the same bounded-wait + liveness discipline governs the worktree path. See [`../platform/AUTO_MERGE.md`](../platform/AUTO_MERGE.md) §"Worktree-based task execution".

## Anti-patterns to flag

- **`/loop` for durable work.** Using `/loop` for a nightly sweep; it dies with the session and the sweep silently stops.
- **Open-ended wait on a background agent.** Relying solely on the completion notification; a stalled agent emits none and the wait never returns.
- **Cron without approval.** Creating a `/schedule` routine that mutates shared state without per-creation user approval.
- **Routine with no terminating artifact.** A scheduled agent that runs and leaves nothing; you cannot distinguish success from a silent failure.
- **Second spawn path.** A scheduled or background fan-out that scores its own findings instead of routing them through the pass-runner and cross-verifier.
- **`crontab` instead of `CronCreate`.** Shelling out around the sanctioned primitive bypasses its safety surface.

## Severity calibration

| Severity | Example |
|---|---|
| blocker | A `/schedule` routine created without user approval; a scheduled routine writes `calibration.json` / `lessons/` / git outside the pass-runner |
| major | `/loop` used for work that must survive session close; a background fan-out waited on open-ended (no deadline, no liveness probe) |
| minor | Scheduled routine with no terminating artifact; poll cadence mismatched to the watched state's change rate |
| nit | Routine description does not state whether it is read-only or mutating |

## Sources

- Handbook: [`../../handbook/07-run.md`](../../handbook/07-run.md) §"Automate toil out" - automation as the principal way to reduce repetitive operational work.
- Research: [`../../research/07-operations/sre.md`](../../research/07-operations/sre.md) §"Toil" - the six-part enumerable toil test and the below-50% target, carrying [Eliminating Toil - Google SRE book](https://sre.google/sre-book/eliminating-toil/) (accessed 2026-04-24).
- Policy: [`../../CLAUDE.md`](../../CLAUDE.md) §5 (Tooling: `/loop`, `ScheduleWakeup`, background agents, deferred tools) and §8 (Escalation: the unattended/autonomous class).
- Orchestration: [`../../agents/pass-runner.md`](../../agents/pass-runner.md) - the single spawn authority that scheduled/background work runs under.
- The mapping of harness primitives (`/schedule` vs `/loop` vs `ScheduleWakeup` vs background agents) onto the toil test is a codification adopted by this system. It is consistent with, but not literally cited in, the *Eliminating Toil* source above. [UNVERIFIED - flagged per [`research/CLAUDE.md`](../../research/CLAUDE.md) §2.]
