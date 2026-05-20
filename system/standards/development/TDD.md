# TDD.md — Test-Driven Development

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §4.

## Hard rules

1. **New functionality is developed using TDD.** Red → Green → Refactor. (Fowler.)
2. **Canon TDD (Beck) is authoritative when Fowler's summary is ambiguous.** Five steps: list scenarios; turn one into a test; pass it; optionally refactor; loop until list is empty.
3. **Never skip the refactor step.** Skipping it is "the most common way to screw up TDD" (Fowler) — produces tested-but-messy code.

## Default

- TDD is not required for exploratory spikes that get thrown away. Any spike whose code survives to trunk is backfilled with tests before merge.

## Auto-rejection (used by qa-engineer in `feature_flags.tdd_strict: true` mode)

| Trigger | Severity |
|---|---|
| Implementation file's first commit predates the test file's first commit | Major |
| Test passes on the first run before any implementation | Major (test is meaningless if it never failed) |
| Test asserts implementation, not behavior (e.g., asserts on private state) | Major |
| Refactor commit changes test behavior | Major (Two Hats violation) |
| New code has no test | Blocker for public APIs and bug fixes; major for internal |

`tdd_strict` is on by default for paths matching `**/billing/**`, `**/auth/**`, `**/crypto/**`. Off by default for UI-only changes.

## Two-Hats discipline

(Fowler, Refactoring §10.) At any moment you are either in **refactoring mode** (behavior preserved, tests stay green) or **feature mode**. Don't mix in a single commit. The qa-engineer flags PRs that combine both.

## What "behavior" means in tests

- Inputs and outputs of functions; state changes observable through public API; side effects visible to callers.
- Not: which methods were called on private dependencies; which internal helper was used; which order private methods executed.

## Anti-patterns to flag

- Mocking everything and asserting that mocks were called → tests pass with broken behavior.
- 100% coverage as the team goal → tests written for the number, not for confidence.
- Snapshot tests on everything → change-detectors, not behavior assertions.
- Tests skipped (`it.skip`, `@pytest.mark.skip`) without an issue link.

## Sources

- [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §4 cites Fowler "TestDrivenDevelopment", Beck "Canon TDD".
- Research: [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §1 (TDD), [`../../../research/05-testing/test-models.md`](../../../research/05-testing/test-models.md).
- Handbook: [`../../../handbook/04-build.md`](../../../handbook/04-build.md) and [`../../../handbook/05-test.md`](../../../handbook/05-test.md).
