# TECHNICAL_DEBT.md — Tracking and repaying technical debt

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §10 (Refactoring); [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"Managing technical debt"; [`../../../research/08-maintenance/technical-debt.md`](../../../research/08-maintenance/technical-debt.md).

## What technical debt is

Ward Cunningham introduced the metaphor in his 1992 OOPSLA experience report on the WyCash portfolio management system: "Shipping first time code is like going into debt. A little debt speeds development so long as it is paid back promptly with a rewrite." He named the carrying cost — "Every minute spent on not-quite-right code counts as interest on that debt" — and the failure mode: "Entire engineering organizations can be brought to a stand-still under the debt load of an unconsolidated implementation."

Cunningham's later (2009) clarification, restated in Fowler's bliki entry, sharpens the definition: debt is the gap between what the code says and what the team **now understands** to be the right way to model the domain. It is not a synonym for "messy code." Sloppy code without an evolved understanding is not debt — it is just sloppy code.

Three things follow from Cunningham's framing that the handbook ([`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"Cunningham's metaphor") preserves:

1. **Debt is a feature, not a bug.** A small deliberate amount speeds delivery and lets you learn. Refusing all debt is its own failure mode — you ship slowly and learn little.
2. **Interest is real and ongoing.** Every change near the debt costs more than it should. Interest compounds.
3. **Paying down is a concrete act** — refactoring, consolidation, rewriting — not a vague intention.

Two operational consequences from Fowler's "Technical Debt" entry:

- **Interest is triggered by modification activity, not the passage of time.** A confusing module that nobody touches accrues no interest. The same module on the hot path of every feature change accrues a lot. Fowler illustrates with a concrete example: if a confusing module structure makes a feature take six days instead of four, the two-day difference is the interest cost.
- **Cleanup work that targets stable unchanged modules is wasted effort.** Repayment goes where the code is being changed.

> Source: [Technical Debt — Martin Fowler](https://martinfowler.com/bliki/TechnicalDebt.html); [The WyCASH Portfolio Management System — Ward Cunningham, OOPSLA '92](https://c2.com/doc/oopsla92.html). See [`../../../research/08-maintenance/technical-debt.md`](../../../research/08-maintenance/technical-debt.md) §§1–2 for full quotations.

## Fowler's debt quadrant

Fowler's "TechnicalDebtQuadrant" classifies debt along two axes — **deliberate vs. inadvertent** and **prudent vs. reckless** — and matters because the response to each cell is different.

| | Prudent | Reckless |
|---|---|---|
| **Deliberate** | "We must ship now and deal with consequences." May be fine to carry indefinitely if interest is low. | "We don't have time for design." Fowler: "usually a reckless debt, because people underestimate where the DesignPayoffLine is." |
| **Inadvertent** | "Now we know how we should have done it." Fowler: "It's often the case that it can take a year of programming on a project before you understand what the best design approach should have been." Dominant category in any real system. | "What's layering?" Fowler: results in "crippling interest payments or a long period of paying down the principal." |

Fowler's framing of the quadrant's purpose:

> "The real question is whether or not the debt metaphor is helpful about thinking about how to deal with design problems, and how to communicate that thinking."

The quadrant is a **diagnostic, not a priority ordering.** Reaction differs by cell:

- **Deliberate–Reckless / Inadvertent–Reckless** → fix the **process** (training, code review, pairing, design review) — not just the code. Cleaning up the symptom without fixing the source generates the same debt next quarter.
- **Deliberate–Prudent** → may not need to be repaid if interest is genuinely small.
- **Inadvertent–Prudent** → unavoidable on novel problems; budget refactoring time and treat as the steady state.

> Source: [TechnicalDebtQuadrant — Martin Fowler](https://martinfowler.com/bliki/TechnicalDebtQuadrant.html). Full text in [`../../../research/08-maintenance/technical-debt.md`](../../../research/08-maintenance/technical-debt.md) §3.

## Hotspot analysis (Tornhill)

Adam Tornhill's *Your Code as a Crime Scene* (Pragmatic Bookshelf, second edition, February 2024) prescribes "Visualize codebases via a geographic profile from commit data to find development hotspots, prioritize technical debt, and uncover hidden dependencies." Files showing both **high churn** (frequent commits) and **high complexity** are where modification-driven interest is actually being paid.

This operationalizes Fowler's claim that interest accrues from change activity:

- A complex file with low churn = paper interest. Don't chase it.
- A simple file with high churn = noise. Don't chase it either.
- A complex file with high churn = the hotspot. Repayment here has the highest expected return.

CodeScene (Tornhill's product) automates this. A first-pass approximation is `git log --pretty=format: --name-only | sort | uniq -c | sort -rg` cross-referenced with a complexity metric and the incident-to-file map.

> Source: [Your Code as a Crime Scene, Second Edition — Adam Tornhill, Pragmatic Bookshelf, 2024](https://pragprog.com/titles/atcrime2/your-code-as-a-crime-scene-second-edition/). Full treatment in [`../../../research/08-maintenance/technical-debt.md`](../../../research/08-maintenance/technical-debt.md) §4.

## Repayment cadence

The handbook (Phase 08) sets the default: **15–20% of engineering capacity, continuously, every sprint** — not "after the next big launch."

Two repayment patterns, both required:

1. **Continuous, in-flight with feature work.** Refactor in small PRs alongside the change that surfaces the debt. Per the handbook, the boy-scout-style framing is: leave the module materially better than you found it; the PR that adds a feature to a module also cleans up that module's obvious messes. This is the **default cadence** and is the bulk of repayment.
2. **Preparatory refactoring, then the easy change.** Per Engineering Policy §10.3 and Fowler's *Preparatory Refactoring Example*: "make the change easy, then make the easy change" (Kent Beck). Refactor first to make the upcoming feature change small and obvious; then ship the feature.

Two patterns to **avoid**:

- **Big-bang refactoring sprints.** They fail for the same reasons rewrites fail — large batch, delayed integration, no user-visible benefit shipped along the way. The handbook calls these out explicitly.
- **Tech-debt freezes followed by bursts.** Capacity must be **continuous**. Sprint-N-only debt work, with feature-only sprints around it, predictably collapses the moment a launch slips.

The Engineering Policy "Two Hats" rule applies: at any moment you are either in **refactoring mode** (behavior preserved, tests stay green) or **feature-addition mode**. You do not mix the two in a single commit or CL.

> Sources: [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §§10.1–10.3; [Preparatory Refactoring Example — Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html); [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"How to pay it down".

## When to repay vs. leave alone

Apply Fowler's interest-from-modification rule:

| Situation | Repay? |
|---|---|
| File is on the hotspot list (high churn × high complexity) and a feature change is planned in the area | Yes — preparatory refactor first |
| File is on the hotspot list and no feature change is planned | Yes — schedule on debt budget, prioritize by hotspot rank |
| File is complex but rarely modified (no churn) | No — paper interest. Don't pay down speculatively. |
| Reckless debt accumulating in new code (Deliberate–Reckless / Inadvertent–Reckless quadrants) | Fix the process upstream first; clean code follows |
| Deliberate–Prudent debt with documented small interest | Carry. Revisit if churn rises |
| Senior engineer "just wants to clean it up" with no churn or business signal | No — pet-project refactor; redirect to the hotspot list |

The "leave it alone" cases are not laziness — they are the explicit diagnosis that interest is not being paid here, so principal repayment has no return.

## Hard rules

1. **Debt is named, not implied.** A PR that knowingly takes on debt names it in the description. If it is load-bearing, an ADR is written before merge (per [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §12).
2. **Debt budget is allocated, tracked, and spent.** 15–20% of engineering capacity per sprint, continuously. If the budget was not spent on debt, the team names that explicitly at the retro — it does not silently roll forward.
3. **Hotspot list is the priority order.** Repayment targets the hotspot list, not whichever module the loudest engineer dislikes. The hotspot list is regenerated at least quarterly and shared with the team.
4. **No big-bang refactor sprints; no full rewrites without an ADR.** Strangler-fig is the default for legacy modernization (per [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"Legacy modernization").
5. **Debt comments in code are dated and ticketed.** `// TODO(debt):` / `// FIXME(debt):` includes a one-line description and a ticket or ADR reference. Untracked TODOs are dead weight and accumulate without being read.
6. **Reckless-quadrant debt is a process finding, not just a code finding.** It triggers a review of how the debt was introduced — which means the response is upstream (training, review, pairing, design review), not a one-time cleanup.

## How `/evolve` encodes debt repayment

The `/evolve` quarterly audit ([`../../commands/evolve.md`](../../commands/evolve.md)) checks debt repayment as a Pass 1 / Pass 3 concern via the systems-architect agent.

Pass-loop coverage:

- **Pass 1 (Correctness):** "is debt inventoried per Fowler quadrant with hotspot analysis."
- **Pass 3 (Ship Readiness):** "is debt capacity (15–20%) actually being spent on debt rather than features labeled 'refactor'."

Inputs the audit expects (per the `/evolve` Dependency Gate):

- `docs/debt/inventory.md` — debt items, each tagged to a Fowler quadrant cell.
- Commit-history hotspot output (CodeScene export, `git log` summary, or equivalent).
- Last quarter's retrospective action items, which are reviewed for unspent debt budget rolling forward.

The audit produces an inventory of the **top-10 debt items** mapped to Fowler quadrant in `cdocs/evolve-quarterly-<YYYY-Qn>.md`. Items absent from the hotspot list are demoted; items on the hotspot list without a planned action become Pass 1 findings. Reckless-quadrant items trigger an additional process finding routed to the team lead, not just an action item against the code.

The audit also flags the named anti-patterns from the handbook:

- "We'll refactor after the next big launch" — debt budget not spent; the launch always slips.
- 500-item bug/debt backlog nobody triages — backlog without triage is archaeology, not work.
- 2-year rewrite projects that never ship — strangle, do not rewrite.
- Pet-project refactors disguised as debt paydown — the hotspot/quadrant lens defeats this.

A team without a hotspot list, without a quadrant-tagged inventory, or without evidence the debt budget was actually spent on debt fails the audit at Pass 1, Pass 1, and Pass 3 respectively. The remediation in each case is in this document; the audit's job is to surface the gap, not to manufacture the answer.

## Anti-patterns to flag

- **Debt as an excuse to rewrite.** A rewrite is justified only when *all* of: incremental change cannot fix the blocker; capacity exists to run both systems in parallel until handoff; the domain is well-understood; executive commitment exists to ship. If any is missing, strangle. (Per [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"Rewrites".)
- **"We'll fix it later" without a ticket.** Any debt taken on without a tracking artifact (ticket, ADR, or in-code `TODO(debt):` with reference) does not exist for the next maintainer. It does, however, accrue interest.
- **"Refactor" PRs that change behavior.** Per [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §10.1, refactoring preserves observable behavior. A PR that changes behavior is a feature, fix, or breaking change — and must be labelled as such (Conventional Commits §9). Mislabelled `refactor:` commits hide change-failure-rate signal in DORA.
- **Cleaning the easy code.** The senior engineer reformats a low-churn utility module instead of touching the painful hotspot. Looks like debt repayment, returns nothing. Hotspot list is the answer.
- **One huge debt-paydown sprint.** Big batch, delayed integration, ships nothing for users, predictably gets cancelled at the first launch slip. Continuous 15–20% beats Q4 cleanup sprint every time.
- **NPS-of-debt:** counting `// TODO`s as a metric without context. The count goes up, the count goes down — neither tells you whether interest is being paid. Hotspot churn × complexity does.
- **Debt inventory that never gets touched.** A 500-item backlog where nothing is ever closed becomes archaeology within six months. Either work the items or close them as "won't fix."
- **Reckless-quadrant findings treated as a code problem.** Cleaning up a reckless-debt artifact without fixing the process that produced it generates the same debt next quarter, by the same author, with the same review.

## Severity calibration

| Severity | Example |
|---|---|
| blocker | PR knowingly introduces load-bearing reckless debt without an ADR; `refactor:` PR that changes observable behavior in a domain on the hotspot list |
| major | Debt budget unspent for two consecutive quarters; no hotspot analysis exists; rewrite project started without an ADR or capacity for parallel run |
| minor | `TODO(debt):` without a ticket reference; debt comment older than 12 months with no action; `// HACK` style comment without an owner |
| nit | Refactor scope creep on a feature PR (split into a separate refactor-only CL per "Two Hats") |

## Sources

- [The WyCASH Portfolio Management System — Ward Cunningham, OOPSLA '92, 26 March 1992](https://c2.com/doc/oopsla92.html) — original debt metaphor.
- [Technical Debt — Martin Fowler, 2003 / 2019 rewrite](https://martinfowler.com/bliki/TechnicalDebt.html) — interest-from-modification framing; Cunningham 2009 clarification reference.
- [TechnicalDebtQuadrant — Martin Fowler](https://martinfowler.com/bliki/TechnicalDebtQuadrant.html) — deliberate/inadvertent × prudent/reckless quadrant.
- [Your Code as a Crime Scene, Second Edition — Adam Tornhill, Pragmatic Bookshelf, 2024](https://pragprog.com/titles/atcrime2/your-code-as-a-crime-scene-second-edition/) — hotspot analysis (churn × complexity).
- [Preparatory Refactoring Example — Martin Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html) — "make the change easy, then make the easy change" (Beck); Two Hats.
- [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §10 — refactoring rules, Two Hats, preparatory refactoring.
- [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §"Managing technical debt" — 15–20% capacity rule, tracking, repayment cadence, anti-patterns.
- [`../../../research/08-maintenance/technical-debt.md`](../../../research/08-maintenance/technical-debt.md) — full primary-source verification with quotations.
- [`../../commands/evolve.md`](../../commands/evolve.md) — quarterly audit that operationalizes the rules above.
