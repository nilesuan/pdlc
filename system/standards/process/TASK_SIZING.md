# TASK_SIZING.md — Leaf-task sizing and the verification pass

**Authoritative sources:** [`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) §"Step 6 — Size items (relative, not hours)" and §"Step 8 — Establish backlog refinement (weekly)"; [`../../../research/02-planning/estimation.md`](../../../research/02-planning/estimation.md).

## What this standard is for

When a `/plan` decomposition produces tasks and subtasks, **every leaf task must be sized at 1–2 hours of work**, including reading the surrounding context, writing the change, and testing it. After the initial decomposition, the planner runs a **mandatory verification pass** that re-walks every task and confirms each is actually 1–2 hours; the first-pass estimate is not accepted on its own. If a task genuinely cannot be reduced to 1–2 hours, it is surfaced explicitly as a documented exception with its reason — never silently left oversized.

This standard governs the **leaf-level decomposition** that feeds `/build`. It does not replace [`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) Step 6's relative-sizing ritual (Fibonacci points, Planning Poker) used for backlog estimation; it specifies what happens once an estimated backlog item is broken into the concrete tasks an engineer will actually execute.

## Rationale

Three failure modes this rule guards against, each grounded in the planning literature:

1. **Oversized tasks hide complexity.** Mike Cohn's *Agile Estimating and Planning* (Prentice Hall PTR, 2005) argues that estimate uncertainty grows non-linearly with size — the Fibonacci scale (1, 2, 3, 5, 8, 13, 21) is "structured to match the observation that estimate uncertainty grows with size" [VERIFIED — [`../../../research/02-planning/estimation.md`](../../../research/02-planning/estimation.md) §2]. A "half-day" task is rarely a single half-day; it is usually two or three things bundled, each with its own risk. Splitting until each leaf is 1–2 hours forces the bundle apart so the risks become visible.
2. **Oversized tasks are harder to track.** The handbook's own decomposition rule fires at this same threshold: items above 13 points / size L are "too big to start" and must be split before they enter Sprint Planning ([`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) §"Step 6"). At leaf level, the equivalent threshold is the working day: a task that cannot be finished in 1–2 hours stalls in `in-progress` long enough to obscure whether it is actually progressing or quietly stuck.
3. **First-pass estimates are optimistic.** Engineers consistently under-estimate small tasks because they price the change itself but not the surrounding work — reading the existing code, finding the test fixtures, running the suite, fixing a flake exposed by the change. A verification pass that asks "would a competent engineer finish this in 1–2 hours **including reading context, editing, testing**?" is the cheapest available correction; it catches the optimistic estimates while the plan is still cheap to change.

The rule is **not** that small tasks are inherently better than larger ones in some abstract sense. The rule is that at the leaf level — the granularity an engineer pulls into their working day — 1–2 hours is the band where the first three failure modes above stop being structural defects of the plan and become normal execution noise. Above that band the task is a bundle; below it the task is an interruption.

## Hard rules

1. **Every leaf task is sized at 1–2 hours of work.** "Work" includes reading the surrounding context, editing, testing locally, and self-review. Not wall-clock; effort.
2. **The verification pass is non-skippable.** Every plan that produces leaf tasks runs a second pass that walks every task and re-asks the 1–2 hour question. The first-pass estimate is not the final estimate.
3. **"0.5 day" / "half a day" / "an afternoon" tasks must be split.** Day-fractioned units silently re-introduce the bundle the rule exists to prevent. Convert to hours and decompose.
4. **"15 min" / "5 min" tasks must be bundled or dropped.** Below ~30 minutes the coordination overhead (stand-up mention, branch, PR, review) exceeds the work. Bundle into the adjacent task it actually depends on; if it cannot be bundled, drop it as not worth tracking.
5. **Exceptions are surfaced explicitly, not hidden.** A task that genuinely cannot be reduced to 1–2 hours is named in the plan as an **exception** with: (a) the reason it cannot be split, (b) the realistic effort estimate, (c) the explicit risks of the oversize. Never silently leave an oversized task in the plan.
6. **Exceptions trigger an explicit acknowledgement.** The plan's accountable owner reads each exception; an oversized task that nobody acknowledged is a finding, not a feature.
7. **Reading and testing time count as work.** A task that estimates "1 hour of editing" but requires three hours of reading the existing module and writing tests is a 4-hour task and must be split — the editing-only number is the wrong number.

## Decomposition rules

The decomposition produces leaf tasks; the verification pass certifies them. Both steps are required.

### Initial decomposition

- **Slice vertically, not horizontally.** A 1–2 hour task is a thin end-to-end slice of behavior, not a layer of plumbing detached from the rest. The vertical slice is testable on its own; the horizontal slab is not.
- **Each leaf has one acceptance criterion.** Multiple acceptance criteria are usually multiple tasks. If the criterion is "reconcile flow handles Stripe + PayPal + manual entry," that is three tasks.
- **Each leaf names the file or module it touches.** Untargeted tasks ("improve error handling") are bundles. The file/module pin is what makes the 1–2 hour estimate concrete.
- **Reading and testing are explicit in the estimate.** When sizing, ask: how long to read the existing context? to edit? to write/run the tests? Sum, then check against the 1–2 hour band.
- **Setup and scaffolding are their own tasks.** "Add the new endpoint" is two tasks if the route file does not yet exist (scaffold + endpoint). Hide neither inside the other.

### Splitting heuristics for oversized tasks

If the first-pass estimate is over 2 hours, split along one of these axes — they are the splitting patterns the agile literature documents most consistently (per Cohn 2005 and decomposition literature surveyed in [`../../../research/02-planning/estimation.md`](../../../research/02-planning/estimation.md) §1):

- **By workflow step.** A "checkout" task → input validation, then totals calculation, then payment-gateway call, then receipt.
- **By data variation.** "Handle all transaction types" → one task per type, ordered by value/volume.
- **By acceptance criterion.** Each AC becomes its own task with its own test.
- **Happy path first, then errors.** The happy-path task and the error-path tasks are separate; bundling them hides the harder one.
- **Spike out the unknown.** If the estimate is "2 hours if X works, half a day if it doesn't," that is a spike (a fixed-time investigation that produces a decision, not a feature) followed by the real task. Do not collapse them.

### Bundling heuristics for under-sized tasks

If the first-pass estimate is under 30 minutes:

- **Fold into the immediate next task that depends on it.** A 10-minute "rename function" before a 90-minute "extract module" is part of the extract.
- **Group like-with-like.** Five 10-minute config-flag flips become one 50-minute "flip the five flags and verify each."
- **Drop the trivial.** A task that is genuinely 5 minutes and stands alone is administrative noise — a comment in the relevant PR, not a backlog item.

## Verification pass

After the initial decomposition is done, before the plan is accepted, the planner runs a verification pass over every leaf task. The pass is **explicit and non-skippable** — it is a separate step in the plan workflow, not an inner-loop polish.

For each leaf, ask exactly:

> *Would a competent engineer, familiar with this codebase but not pre-loaded on this specific change, actually finish this in 1–2 hours — including reading the surrounding context, editing, running the test suite locally, and self-reviewing the diff?*

The verb tense matters: **actually finish**, not "be writing." A task where the engineer is "still typing at the 90-minute mark" is over-band. Adjust:

- Estimate inflates → split per the heuristics above.
- Estimate collapses → bundle per the heuristics above.
- Estimate cannot be made 1–2 hours by either splitting or bundling → mark as an **exception** with reason, realistic estimate, and risk note.

Every adjustment from the verification pass is recorded as a change to the plan, not a silent rewrite. The verification pass is over when every leaf either fits the 1–2 hour band or is a documented exception.

### Exception template

When a task genuinely cannot be reduced, surface it as:

```
EXCEPTION — <task name>
  Estimated effort: <realistic hours>
  Why it can't be split: <one sentence>
  Risks of oversize: <visibility, blocking, integration risk>
  Acknowledged by: <accountable owner, dated>
```

Common legitimate exception cases (from planning literature and from observed practice; flag if the underlying claim does not match your situation):

- **Indivisible third-party migration step.** A library upgrade where the upgrade itself is one atomic version-bump commit and the test/fix work cannot start until the bump compiles — the bump is one task, the follow-up fixes are separate. [SYNTHESIS — derived from preparatory-refactoring guidance in [`TECHNICAL_DEBT.md`](TECHNICAL_DEBT.md) §"Repayment cadence" rather than a single citation; flag if the case in front of you does not fit the pattern.]
- **Time-boxed spike on an unknown.** A 4-hour "investigate whether approach X works" with a hard timebox and a written decision at the end. The timebox itself is the discipline. [SYNTHESIS — extends the spike pattern named in [`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) §"Step 6" beyond its source's exact framing.]
- **Atomic data migration.** Some schema migrations and backfills must run as a single transaction. Split the *preparation* and *verification* before/after, but accept the migration step itself.
- **Unsplittable infrastructure provisioning.** A Terraform apply that creates a network and the resources inside it, where the apply is one transaction. Plan and verify around it; the apply itself is one task.

Cases that are **not** legitimate exceptions:

- "It feels like one thing." Feelings are not exceptions; the splitting heuristics above almost always apply.
- "We don't have time to decompose it." This is the failure mode the verification pass exists to catch — surface as a finding, not as an exception.
- "It will probably take longer but we'll see." Document the realistic estimate and split, or document as an exception with the actual number.

## How `/plan` encodes this

The `/plan` command ([`../../commands/plan.md`](../../commands/plan.md)) loads this standard and enforces the rule via:

- **Pass 1 (Correctness):** "every leaf task is sized 1–2 hours; the verification pass has been run; exceptions (if any) are documented with reason and acknowledgement."
- **Done-when bullet:** the plan is not done until the verification pass has been completed and any exceptions are explicitly recorded.

The `systems-architect` agent loads this standard alongside the existing `EVIDENCE.md` / `QUALITY.md` / `AGENT_PREAMBLE.md` set and applies the rule when reviewing the decomposition.

## Anti-patterns to flag

- **"Half-day" tasks.** Day-fractioned units bundle 2–3 leaves. Convert to hours and split.
- **First-pass estimates accepted without a verification pass.** This is the failure the verification pass exists to catch. A plan whose leaf estimates were never re-walked has not earned its 1–2 hour claim.
- **Silent oversize.** A 4-hour task left in the plan with no exception note. The next sprint, it stalls, and the team learns nothing because the oversize was never named.
- **Reading time omitted.** "1 hour of editing" on an unfamiliar module is not 1 hour of work. The estimate must include the read.
- **Test time omitted.** "1 hour to write the change, then we'll see about tests" is two tasks pretending to be one.
- **Tasks that touch >1 module without justification.** Almost always a bundle. Split by module.
- **The "and" anti-pattern.** A task title with "and" — "add endpoint and update docs and run migration" — is three tasks. The conjunction is the smell.
- **Re-baselining the band.** "Our team's 1–2 hours is everyone else's full day." If that is true, the team is not doing the verification pass; they are renaming the failure.
- **Verification pass treated as a polish step.** It is a separate, named pass over every leaf — not a quick sanity check during decomposition.

## Severity calibration

| Severity | Example |
|---|---|
| blocker | Plan submitted without the verification pass; multiple leaves over 4 hours with no exception notes |
| major | Some leaves are "half-day" sized; verification pass run but adjustments not recorded |
| minor | A leaf at 2.5 hours that should have been split; an exception missing the risk note |
| nit | Acceptance-criterion phrasing implies bundling but the underlying tasks are correctly split |

## Sources

- [`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) §"Step 6 — Size items (relative, not hours)" — relative sizing, Fibonacci, "anything above 13 (or L) is too big to start; split it."
- [`../../../handbook/02-plan.md`](../../../handbook/02-plan.md) §"Step 8 — Establish backlog refinement (weekly)" — refinement as ongoing decomposition; "team splits items that are too big (>13 points / > L)."
- [`../../../research/02-planning/estimation.md`](../../../research/02-planning/estimation.md) §1 (Cohn on relative sizing; effort = work + complexity + uncertainty), §2 (Fibonacci scale matches uncertainty growth with size).
- Mike Cohn, *Agile Estimating and Planning*, Prentice Hall PTR, 2005 — relative effort sizing, splitting, the structural argument that small uniform stories make planning tractable. Cited in [`../../../research/02-planning/estimation.md`](../../../research/02-planning/estimation.md) §1.
- Related standard: [`TECHNICAL_DEBT.md`](TECHNICAL_DEBT.md) — preparatory refactoring rule ("make the change easy, then make the easy change") informs the splitting heuristic of separating the refactor from the feature.
- The specific **1–2 hour band** as the leaf-task target, and the **mandatory verification pass** as a named, non-skippable step, are codifications adopted by this system. They are consistent with — but not literally cited in — the agile-decomposition literature surveyed above. [UNVERIFIED — flagged per [`../../../CLAUDE.md`](../../../CLAUDE.md) §2.]
