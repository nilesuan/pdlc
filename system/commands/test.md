---
name: test
description: Phase 05 — build durable confidence in the test suite. Reviews suite shape, coverage, test quality, flake hygiene, and non-functional testing (perf, a11y, load).
argument-hint: [scope — repo|service|directory|changed-files]
---

# /test

## Goal

Audit the test suite (or a portion of it) against pyramid/trophy shape, coverage gates, test-quality, flake hygiene, and non-functional coverage. Produce findings the team can act on.

## Done when

- Test-suite shape matches strategy (pyramid for backend; trophy acceptable for SPA frontend).
- Coverage floors met per [`../standards/QUALITY.md`](../standards/QUALITY.md): 80% line / 70% branch project-wide; 95% on auth/crypto/billing.
- Flaky tests quarantined within 1 day of detection; quarantine queue burned down weekly.
- Non-functional coverage exists where applicable: SAST + SCA + secrets scan in CI; DAST nightly against staging; axe-core on every UI PR; k6 smoke on perf-sensitive endpoints.
- E2E suite is small, reliable, and covers the core user journeys (not branch coverage).
- Test-double choices documented: fakes preferred over mocks for internal seams.
- WCAG 2.2 AA baseline on UI (axe-core green + manual keyboard test).
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

05 — Test

## Pre-flight

- Repo accessible, test runner installed.
- The user named the scope (default: full repo).

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Test runner installed | `package.json`/`pyproject.toml`/`go.mod` declares it; `--version` succeeds | Pass 1 |
| Coverage tool configured | `coverage.json`/`.coveragerc`/etc. | Pass 1 |
| Recent CI history (≥ 100 runs) | CI provider API or local cache at `.cdocs/ci-history.json` | Pass 2 (flake-rate analysis) |
| Test inventory | `find tests/ specs/` returns ≥ 1 file | Pass 1 |
| (If perf surface) Perf budget | `perf/<surface>/budget.md` | Pass 3 (PERFORMANCE_BUDGET framework) |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "agents": {
    "qa-engineer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/testing/TEST_STRATEGY.md",
        "standards/development/TDD.md"
      ]
    },
    "code-reviewer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/development/CODE_REVIEW.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Does the suite run end-to-end, is the shape right (pyramid for backend / trophy for SPA), and do tests assert behavior rather than implementation? |
| 2 | Proof & Safety | Are coverage gates met across project + sensitive paths, is the flake rate < 1% with quarantine queue burned weekly, and are mocks confined to external boundaries (not internal seams)? |
| 3 | Ship Readiness | Are SAST / SCA / secrets / DAST / a11y / perf in CI for every relevant PR, do E2E tests cover only critical user journeys (not branch coverage), and is non-functional coverage wired into the recurring schedule? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/testing/TEST_STRATEGY.md
  - standards/development/TDD.md
  # Conditional language standards (loaded by file extension in the test scope)
  - standards/development/PYTHON.md     # if scope includes *.py
  - standards/development/TYPESCRIPT.md # if scope includes *.ts / *.tsx
```

## Sub-agents

```yaml
sub_agents:
  - qa-engineer          # primary (sonnet)
  - code-reviewer        # for test-code quality (sonnet)
```

## Pass-loop dispatch

Pass-runner produces a **test-audit report** with structured findings. Each finding cites a test file and lines, or a coverage report row, or a flake-history record.

Per pass, qa-engineer checks:

1. **Suite shape.** Run coverage; emit pyramid/trophy histogram. Flag if E2E > 15% of test count.
2. **Coverage gates.** Project-wide and risk-weighted (auth/crypto/billing). Flag any drop > 2% on any axis.
3. **Test quality.** Sample 10 tests at random per scope; assess: meaningful failures, behavior over implementation, deterministic, named-after-expectation.
4. **Mocks vs fakes.** Flag mocking of internal seams. Recommend fakes.
5. **Flake hygiene.** Find tests with > 1% failure rate in last 100 runs (CI-history-driven). Quarantine recommendations.
6. **Non-functional gaps.** Are SAST / SCA / secrets / DAST / a11y / perf in place? Each gap → finding.
7. **E2E shape.** Does E2E cover user journeys, not branch coverage of internal logic? Flag E2E doing what unit could.

## Output

Artifact at `cdocs/test-audit-<timestamp>.md` with:

- Coverage histogram by directory.
- Coverage gates pass/fail.
- Flake table (top 10 worst).
- Test-double assessment.
- Non-functional checklist (each item green / red / N/A).
- Top 5 recommendations, prioritized.

## Sources

- Handbook: [`../../handbook/05-test.md`](../../handbook/05-test.md)
- Research:
  - [`../../research/05-testing/test-models.md`](../../research/05-testing/test-models.md) — Pyramid (Cohn, Fowler), Trophy (Dodds)
  - [`../../research/05-testing/test-levels.md`](../../research/05-testing/test-levels.md) — Meszaros taxonomy; Pact contract testing
  - [`../../research/05-testing/test-automation.md`](../../research/05-testing/test-automation.md) — Coverage targets; Google flake mitigation
  - [`../../research/05-testing/non-functional-testing.md`](../../research/05-testing/non-functional-testing.md) — k6, OWASP DevSecOps, WCAG 2.2 AA, axe-core
  - [`../../research/05-testing/quality-engineering.md`](../../research/05-testing/quality-engineering.md) — shift-left, two-stage CI <10 min commit build
  - [`../../research/05-testing/chaos-and-production-testing.md`](../../research/05-testing/chaos-and-production-testing.md) — canary, dark launch
