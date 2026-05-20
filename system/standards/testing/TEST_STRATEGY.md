# TEST_STRATEGY.md — Suite shape and discipline

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §5; [`../../../handbook/05-test.md`](../../../handbook/05-test.md).

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

## Coverage gates (from [`../QUALITY.md`](../QUALITY.md))

| Scope | Floor |
|---|---|
| Project-wide line | 80% |
| Project-wide branch | 70% |
| `**/auth/**`, `**/crypto/**`, `**/billing/**` line | 95% |
| Mutation score (if configured) | 60% |

A change that drops coverage > 2% on any axis without offsetting gain → `QA-COV-*` major finding.

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

## Anti-patterns to flag

- 100% coverage as the goal. Tests for the number, not for confidence.
- Tests coupled to implementation; break on every refactor.
- Mocking internal seams. Green suite, broken system.
- Flaky tests everyone ignores. The signal you're not paying attention to.
- Giant E2E suites > 40 minutes. Engineers stop running them.
- Testing the framework. (Testing React's `useState` is testing React.)

## Sources

- Fowler, "TestPyramid"; Vocke, "The Practical Test Pyramid"; Cohn (Succeeding with Agile); Dodds, "The Testing Trophy" — full citations in [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §5.
- Test doubles: Meszaros, *xUnit Test Patterns*; see [`../../../research/05-testing/test-levels.md`](../../../research/05-testing/test-levels.md).
- Coverage targets: Fowler "TestCoverage" (also: 100% is a smell).
- Handbook: [`../../../handbook/05-test.md`](../../../handbook/05-test.md).
