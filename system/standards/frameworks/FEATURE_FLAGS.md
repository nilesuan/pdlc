# FEATURE_FLAGS.md — Conditional escalation

**Authoritative source:** [`../../../research/06-release/feature-flags.md`](../../../research/06-release/feature-flags.md); Pete Hodgson, "Feature Toggles" (martinfowler.com, 2017).

## Activation

Loaded when the brief contains any of: `behavior-change`, `phased-rollout`, `canary`, `percentage`, `flag`, `toggle`.

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
| 2 | Defaults | Default state is the safe state (off for new behavior; on for ops/permissioning) |
| 3 | Rollout | Rollout plan named (canary %, ring, percentage) with a clear advancement criterion |
| 4 | Kill switch | Off-path tested; runbook covers "flip to off when X" |
| 5 | Cleanup | For release toggles: cleanup ticket filed with deadline; deletion path described |

## Escalation impact

- `max_passes = 5`.
- A release toggle without a cleanup ticket and deadline is a `major`.
- A flag without a kill-switch test for ops/permissioning categories is a `major`.

## Anti-patterns to flag

- A "release toggle" that has been at 100% for > 30 days (becomes legacy code with two paths).
- An "ops toggle" being used to A/B test (categories collapse; ownership lost).
- A flag that gates security-sensitive paths defaulting to **on** for new behavior.

## Sources

- [`../../../research/06-release/feature-flags.md`](../../../research/06-release/feature-flags.md) — Hodgson taxonomy [VERIFIED].
- [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md) — relationship between flags and canary / dark launching.
- [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md) — promotion policy uses flags for ops kill switches.
