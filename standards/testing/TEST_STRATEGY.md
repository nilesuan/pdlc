# TEST_STRATEGY.md — Suite shape and discipline

**Authoritative source:** [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §5; [`../../handbook/05-test.md`](../../handbook/05-test.md).

## The pyramid (default)

Many unit tests. Fewer integration. Far fewer end-to-end.

```
         /\
        /E2\         critical user journeys only
       /----\
      /  IT  \       cross-component contracts
     /--------\
    /   UNIT   \     bulk of confidence; fast feedback
   /------------\
```

## When to use the trophy instead

Frontend SPAs with thin client logic and substantial behavior arising from component composition: heavier integration tests (testing-library + jsdom or real browser via Playwright Component Testing) buy more confidence per line than unit tests.

Backend services: pyramid. Always.

## Hard rules

1. **Pyramid (or trophy for SPA frontends).** Inverted pyramid — heavy E2E, sparse unit — is rejected.
2. **When a higher-level test catches a bug, write a lower-level test reproducing it before the fix merges.** (Fowler / Vocke.)
3. **Tests follow Arrange–Act–Assert (or Given–When–Then) structure.**
4. **Test code is held to the same quality standard as production code.** Reviewed, refactored, kept maintainable.
5. **E2E tests are limited to critical user journeys.** Each E2E test justifies itself by the journey it protects.
6. **Every feature flag has a default-off test.** For each flag, a test asserts the behavior with the flag in its default (off) state, and a second asserts the on-state behavior. The off path is what production runs after the merge; an untested off path is an untested production. Policy §3.4; see [`../frameworks/FEATURE_FLAGS.md`](../frameworks/FEATURE_FLAGS.md) §"Baseline mandate".
7. **The suite includes a prod-deployability test.** Suite-level, not unit-level: it proves main could go to prod as it stands (artifact identity, prod-config dry-run, flags-off smoke, migration compatibility, rollback rehearsal) and blocks on red. Policy §3.5; the five assertions and the gate rules are in [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md) §"The prod-deployability gate".

## Coverage gates (from [`../QUALITY.md`](../QUALITY.md))

| Scope | Floor |
|---|---|
| Project-wide line | 80% |
| Project-wide branch | 70% |
| `**/auth/**`, `**/crypto/**`, `**/billing/**` line | 95% |
| Mutation score (if configured) | 60% |

A change that drops coverage > 2% on any axis without offsetting gain → `QA-COV-*` major finding.

## Flag-state testing

Flag-gated code doubles the state space, and only one of those states is the one production is actually in after a merge. Test both, and be explicit about which is the default.

| Test | Asserts | Required |
|---|---|---|
| Default-off | Behavior with the flag unset / default. This is what prod runs post-merge. | Always, per hard rule 6 |
| Flag-on | The new behavior when the flag is enabled. | Always |
| Fail-closed | Flag service unreachable / config missing / evaluation error falls back to the **off** path. | Always |
| Flip-back | Turning the flag off after it has been on returns the old behavior (no one-way state written while on). | When the feature writes persistent state |

The default-off test is not "the test for the old code". It is the test for *this commit's* production behavior. Deleting it when the flag reaches 100% is correct only as part of removing the flag itself and its dead path.

## Composition verification (wiring stories)

For stories that compose multiple runtime components (entry-point setup, plugin registration, dependency-injection containers, daemon lifecycles), unit tests are not enough. Wiring bugs hide between correct components. The composition test runs from the **real entry point** through to the leaf with **no internal mocks** — internal seams use real types; mocks are limited to external boundaries.

Required when the brief mentions `wire`, `entry-point`, `daemon`, `lifecycle`, `register`, `multi-component`, or `main()`. See [`../frameworks/COMPOSITION_VERIFICATION.md`](../frameworks/COMPOSITION_VERIFICATION.md) — a `[WIRE]`-tagged story without a composition test is a non-overridable blocker (`COMP-WIRE-01`).

Composition tests sit **between** unit and integration: faster than full integration (no real DB) but slower than unit (real internal types). Most valuable on stories that are mostly wiring.

## Test doubles — fakes over mocks

Hierarchy of preference (Meszaros taxonomy, refined by Fowler):

1. **Fake** — a working but simplified implementation (in-memory DB, fake HTTP server). Preferred. Refactor-resilient.
2. **Stub** — returns canned values. OK for narrow inputs.
3. **Spy** — records calls. OK to verify side effects.
4. **Mock** — verifies interactions in detail. Use sparingly; brittle to refactoring.

Mocking your own internal seams (between modules in the same service) is almost always wrong. Use a fake at the system boundary.

## Flake hygiene

- Flaky tests quarantined within 1 day of detection (CI marks them, builds keep going).
- Quarantine queue burned down weekly. A test in quarantine > 14 days is deleted (or fixed).
- Flake rate target: < 1% across the suite.

## Non-functional testing

| Category | Tool | Trigger |
|---|---|---|
| SAST | language-specific (Bandit, gosec, ESLint security plugin) | every PR |
| SCA | Dependabot / Renovate / Snyk | every PR + nightly |
| Secrets | gitleaks / trufflehog | pre-commit hook + CI |
| DAST | OWASP ZAP / nuclei | nightly against staging |
| A11y | axe-core | every UI PR |
| Perf | k6 | smoke on PR; full suite before launch |
| WCAG 2.2 AA | axe-core + manual keyboard test | every UI release |
| Prod-deployability | pipeline gate (see [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md)) | every commit on main; blocking |

## Anti-patterns to flag

- 100% coverage as the goal. Tests for the number, not for confidence.
- Tests coupled to implementation; break on every refactor.
- Mocking internal seams. Green suite, broken system.
- Flaky tests everyone ignores. The signal you're not paying attention to.
- Giant E2E suites > 40 minutes. Engineers stop running them.
- Testing the framework. (Testing React's `useState` is testing React.)
- Testing only the flag-on path because "that's the real feature". Production is running the off path; that is the one you shipped.
- Treating the deployability gate as an E2E test to be trimmed for speed. It is not testing the product, it is testing that the product can ship.

## Sources

- Fowler, "TestPyramid"; Vocke, "The Practical Test Pyramid"; Cohn (Succeeding with Agile); Dodds, "The Testing Trophy" — full citations in [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §5.
- Test doubles: Meszaros, *xUnit Test Patterns*; see [`../../research/05-testing/test-levels.md`](../../research/05-testing/test-levels.md).
- Coverage targets: Fowler "TestCoverage" (also: 100% is a smell).
- Handbook: [`../../handbook/05-test.md`](../../handbook/05-test.md).
- Hard rules 6 and 7 come from [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.4 and §3.5, both marked `[SYNTHESIS]` there (this organization's codification, not a claim of Fowler / Vocke / Cohn / Dodds).
