# TRUNK_BASED.md — Trunk-Based Development

**Authoritative source:** [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §1.

The clauses below summarize that policy for fast lookup. The binding text lives in the policy document — when in doubt, read it.

## Hard rules

1. **One trunk: `main`.** No `develop`, no `release/*`, no environment branches. (Hammant.)
2. **Feature branches ≤ 2 working days.** From creation to merge. Longer = split smaller. (trunkbaseddevelopment.com.)
3. **≤ 3 active branches per repo at any time.** (DORA.)
4. **Every engineer merges to trunk at least once per working day.** (DORA + Fowler CI.)
5. **Incomplete work hides behind feature flags / branch-by-abstraction**, not behind long-lived branches. (Fowler.)
6. **Every feature - complete or not - ships behind a feature flag that defaults to off.** Rule 5 covers unfinished work; this covers all of it. Flag before merge, off in every environment including prod, enabling is a flag change rather than a merge or deploy, and the off path has a test. Policy §3.4; the full mandate is in [`../frameworks/FEATURE_FLAGS.md`](../frameworks/FEATURE_FLAGS.md) §"Baseline mandate".
7. **Main is always deployable to prod, and the prod-deployability gate proves it on every commit.** A red gate is stop-the-line: merges pause until trunk is deployable again. See [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md) §"The prod-deployability gate".
8. **No code freezes, no integration phases.** (DORA.)

## Default

- For repos with ≤ 15 active committers: direct commits to trunk acceptable (with post-commit review). At 16+: short-lived feature branches.

## Branch naming

- Feature: `<initials>/<issue-id>-<short-slug>` — e.g., `ns/PD-142-idempotency-key`.
- Hotfix: `hotfix/<issue-id>-<short-slug>`.
- No `develop`, `release/*`, `env-*` branches. The CI/CD policy enforces.

## Auto-rejection (used by code-reviewer / platform-engineer)

| Trigger | Severity |
|---|---|
| Branch name suggests environment branch (`develop`, `release/v1.2`, `env-prod`) | Blocker |
| Branch open > 2 working days without merge | Major |
| Repo has > 3 active feature branches | Major |
| Engineer hasn't merged to main in > 1 working day (with active work) | Minor → Major if pattern persists |
| Feature merged to main on an unflagged code path | Blocker |
| Feature flag defaulting to on for new user-reachable behavior | Blocker |
| Merging to main while the prod-deployability gate is red | Blocker |
| Prod-deployability gate marked `allow_failure` / skipped / not wired on main | Blocker |

## Anti-patterns to flag

- "We use GitFlow because the book is good" — refuse on a SaaS repo. GitFlow's caveat (the chapter author later wrote it's misapplied for CD-style work) is in [`../../research/04-development/version-control.md`](../../research/04-development/version-control.md).
- "Just merge it; we're behind" producing a 5-day branch. The policy is the answer to time pressure, not its victim.
- Hidden long-lived branches in personal forks "to avoid the merge dance".
- "The flag defaults on because the feature is finished." Finished is not the test; released is. Merge it off, then flip it.
- "Main is deployable, we just haven't deployed in a while." Unproven deployability decays silently. If the gate is not running, the claim is [UNVERIFIED].

## Sources

- See [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §1 for the full citation chain (Hammant, DORA, Fowler).
- Rules 6 and 7 are policy §3.4 and §3.5 (both marked `[SYNTHESIS]` there): this organization's codification, not a claim of Hammant/DORA/Fowler in that form.
- Handbook: [`../../handbook/04-build.md`](../../handbook/04-build.md), section on TBD.
- Research: [`../../research/04-development/version-control.md`](../../research/04-development/version-control.md).
