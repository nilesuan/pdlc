# 05-test-exit.md — Phase 05 (Test) exit checklist

**Authoritative source:** [`../../handbook/05-test.md`](../../handbook/05-test.md); [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).

This checklist is run at the end of `/test` — typically before merge to main and again before promotion to preprod.

## Done-when

- [ ] **Suite shape audited** — pyramid (or trophy for SPA frontends). Inverted pyramids rejected. See [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
- [ ] **Coverage gates met:**
  - Project line ≥ 80%
  - Project branch ≥ 70%
  - `**/auth/**`, `**/crypto/**`, `**/billing/**` line ≥ 95%
  - Mutation score ≥ 60% if configured
- [ ] **No coverage drop > 2%** on any axis without explicit offsetting gain.
- [ ] **Test doubles policy respected** — fakes preferred over mocks; no mocking of internal seams. (Hierarchy: fake → stub → spy → mock.)
- [ ] **Flake hygiene:** flake rate < 1%; quarantined tests < 14 days old; no `it.skip` / `@pytest.mark.skip` without an issue link.
- [ ] **E2E suite < 40 minutes wall clock**, limited to critical user journeys.
- [ ] **SAST run** (language-appropriate). No new High / Critical findings.
- [ ] **SCA run** (Dependabot / Renovate / Snyk). No unaddressed Critical CVEs in direct deps.
- [ ] **Secrets scan** (gitleaks / trufflehog) clean.
- [ ] **DAST against staging** if a UI / API surface changed (OWASP ZAP / nuclei). Findings triaged.
- [ ] **A11y check** (axe-core) for UI changes. WCAG 2.2 AA on every UI release.
- [ ] **Perf smoke (k6)** for endpoints with NFRs. Full perf suite before launch.
- [ ] **Contract tests** green for any service-to-service interface change.
- [ ] **Failure-mode tests** for new failure paths (timeout, retry, circuit breaker, partial degradation).
- [ ] **Flag-state tests** for every flag touched: default-off, flag-on, and fail-closed (unresolvable state falls back to off). Flip-back test where the feature writes persistent state. See [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) §"Flag-state testing".
- [ ] **Prod-deployability gate green** on this commit, with all five assertions run (artifact identity, prod-config dry-run, flags-off smoke, migration compatibility, rollback rehearsal). See [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md) §"The prod-deployability gate".
- [ ] **Gate is required, not advisory** - not `allow_failure`, not skipped, not muted for flakiness.

## Auto-rejection

| Trigger | Severity |
|---|---|
| Coverage drop > 2% without offset | Major |
| Auth/crypto/billing path under 95% line coverage | Major |
| Inverted test pyramid (heavy E2E, sparse unit) | Major |
| Mocking of internal seams discovered | Major |
| E2E suite > 40 min wall clock | Major |
| Flaky test in main suite (not quarantined) | Major |
| `it.skip` / pytest-skip without issue link | Minor |
| Unaddressed Critical CVE in production dependency | Major |
| New UI without axe-core run | Major |
| Test asserts on private state / internal helper calls | Major (brittle) |
| Flag introduced without a default-off test | Major |
| No fail-closed test for flag resolution failure | Major |
| Prod-deployability gate missing, muted, or `allow_failure` | Blocker |
| Deployability gate skips the prod-config dry-run or the rollback rehearsal | Major |
| Flags-off smoke test replaced by a flags-on run | Major |

## What good looks like

- A red-bar / green-bar history — when something breaks, the test catches it; when refactoring, tests stay green.
- Test code reviewed and refactored to the same standard as production code.
- The suite is fast enough to run on a laptop while developing.
- Failure-mode tests exist and are non-trivial — they catch things the happy path can't.

## Sources

- Mike Cohn, *Succeeding with Agile* (2009) — original test pyramid.
- Martin Fowler, "TestPyramid" (martinfowler.com/bliki/TestPyramid.html).
- Ham Vocke, "The Practical Test Pyramid" (martinfowler.com).
- Kent C. Dodds, "The Testing Trophy" (kentcdodds.com).
- Gerard Meszaros, *xUnit Test Patterns* (2007) — test double taxonomy.
- OWASP Testing Guide (owasp.org/www-project-web-security-testing-guide/).
- WCAG 2.2 (w3.org/TR/WCAG22/).
- Handbook: [`../../handbook/05-test.md`](../../handbook/05-test.md).
- Flag-state and deployability items: [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.4, §3.5 (both `[SYNTHESIS]` there).
