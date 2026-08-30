# FEATURE_FLAGS.md - Baseline mandate + conditional escalation

**Authoritative source:** [`../../research/06-release/feature-flags.md`](../../research/06-release/feature-flags.md); Pete Hodgson, "Feature Toggles" (martinfowler.com, 2017).

## Two layers: baseline (always) and escalation (conditional)

This file has an **unconditional baseline** and a **conditional escalation**. Do not read the keyword list as permission to skip the baseline.

- **Baseline mandate** (below) applies to *every* feature, in every brief, whether or not a keyword matched. It is binding via [`../../CLAUDE.md`](../../CLAUDE.md) §4 and [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.4, and it is enforced by always-loaded standards: [`../development/TRUNK_BASED.md`](../development/TRUNK_BASED.md), [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md), and the build / test / ship exit checklists.
- **Escalation** (the pass-by-pass table further down, `max_passes = 5`) is loaded by the pass-runner only when the brief contains any of: `behavior-change`, `phased-rollout`, `canary`, `percentage`, `flag`, `feature-flag`, `toggle`, `default-off`, `kill-switch`.

## Baseline mandate (unconditional)

**Every feature ships behind a feature flag, and the flag defaults to off.** A *feature* is any new or changed user-reachable behavior. Six clauses, all binding ([`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.4):

1. **Flag before merge.** The flag exists and gates the code path before the feature's first commit merges. No feature reaches trunk unflagged.
2. **Default off everywhere, prod included.** The off path is the path a fresh deploy of main takes.
3. **Enabling is separate from merging.** A flag change, never a merge, never a deploy. Enabling is revertible without a redeploy.
4. **Fail-closed.** Unresolvable flag state (service unreachable, config missing, evaluation error) takes the **off** path. Never fail-open into new behavior.
5. **The off path is tested.** An automated test asserts default-off behavior. "Off" is a supported state, not an untried branch.
6. **Deletion planned at creation.** Cleanup ticket + deadline filed with the flag (release toggles: 30 days post-100%).

**Scope carve-outs** (these are not features, so the mandate does not apply): behavior-preserving refactors, bug fixes restoring already-specified behavior, changes with no user-reachable surface. Ops and permissioning toggles default to their **safe** state (the state prod already runs in) rather than literally off. Anything else needs an ADR ([`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §12).

**Why off by default:** merging is not releasing. A flag defaulting on makes the merge itself the release, which reinstates exactly the coupling the flag was bought to break, and it removes the cheap rollback (flip off) in favor of the expensive one (revert and redeploy). It is also what makes "main is always deployable" (see [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md)) survivable: a half-built feature on trunk is inert.

## Why

Flags decouple **deployment** (code is running) from **release** (feature is reachable) from **exposure** (specific users see it). Hodgson's canonical taxonomy names four categories with different lifetimes and ownership; mixing them up is how stale flags accumulate into permanent technical debt.

## The four toggle categories (Hodgson)

| Category | Purpose | Typical lifetime | Owner |
|---|---|---|---|
| Release toggle | Hide unfinished work in main; flip on at release | Short — remove ≤ 30 days post-100% | Feature team |
| Experiment toggle | A/B test variants; data drives decision | Until experiment closes | Product / data |
| Ops toggle | Kill switch / circuit breaker; flip in production without redeploy | Indefinite — owned permanently | Ops / platform |
| Permissioning toggle | Per-user/segment access (e.g., paid tiers) | Indefinite | Product |

## Required artifacts

- **Flag registry entry** at `flags/<flag-name>.md` (or equivalent) with:
  - Name, category, default state, rollout plan, kill-switch procedure, cleanup plan, **stale-flag deadline** (max 30 days post-100% rollout for release toggles).
- **Evidence the kill switch works**: either a runbook entry or a test that exercises the off-state path.
- **Cleanup ticket** filed at the same time the flag is added (with the deadline as the due date).

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Category | Flag is categorized correctly; permission/ops vs release/experiment is unambiguous |
| 2 | Defaults | Default state is the safe state (off for new behavior; on for ops/permissioning). Includes the fail-closed path: unresolvable flag state falls back to off |
| 3 | Rollout | Rollout plan named (canary %, ring, percentage) with a clear advancement criterion |
| 4 | Kill switch | Off-path tested; runbook covers "flip to off when X" |
| 5 | Cleanup | For release toggles: cleanup ticket filed with deadline; deletion path described |

## Escalation impact

- `max_passes = 5`.
- A release toggle without a cleanup ticket and deadline is a `major`.
- A flag without a kill-switch test for ops/permissioning categories is a `major`.

## Baseline auto-rejection (applies with or without escalation)

| Trigger | Severity |
|---|---|
| Feature merged on an unflagged code path | Blocker |
| Flag default is on for new user-reachable behavior | Blocker |
| Flag default differs between environments (off in dev, on in prod, or vice versa) | Blocker |
| Unresolvable flag state falls through to the new behavior (fail-open) | Blocker |
| No test asserting the default-off path | Major |
| Enabling the feature requires a redeploy rather than a flag change | Major |
| Release toggle created without a cleanup ticket and deadline | Major |

## Anti-patterns to flag

- A "release toggle" that has been at 100% for > 30 days (becomes legacy code with two paths).
- An "ops toggle" being used to A/B test (categories collapse; ownership lost).
- A flag that gates security-sensitive paths defaulting to **on** for new behavior.
- A flag whose default is set per environment ("off in dev, on in prod"). The default is a property of the code, not of the environment; per-environment defaults mean prod is running a path nothing else ever exercised.
- A flag read once at process start and cached forever. That is a deploy-time constant wearing a flag's name; the kill switch does not work.
- Flag checks scattered across the call path instead of one decision point at the edge. Every extra check is another place the off path can diverge from what was tested.

## Sources

- [`../../research/06-release/feature-flags.md`](../../research/06-release/feature-flags.md) — Hodgson taxonomy [VERIFIED].
- [`../../research/05-testing/chaos-and-production-testing.md`](../../research/05-testing/chaos-and-production-testing.md) — relationship between flags and canary / dark launching.
- [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md) - promotion policy uses flags for ops kill switches; the prod-deployability gate smoke-tests main with all new flags off.
- [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.4 - the binding text for the baseline mandate. §3.4 is marked `[SYNTHESIS]`: it is this organization's strengthening of Hodgson's release-toggle category, not a claim Hodgson makes in that form.
- [`../../CLAUDE.md`](../../CLAUDE.md) §4 - the non-negotiable one-liner.
