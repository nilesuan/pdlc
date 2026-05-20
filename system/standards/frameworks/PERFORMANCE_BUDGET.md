# PERFORMANCE_BUDGET.md — Conditional escalation

**Authoritative source:** [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md); Grafana k6 documentation (verified 2026-04-24).

## Activation

Loaded when the brief contains any of: `latency`, `p99`, `p95`, `hot-path`, `bundle-size`, `database-query`, `load-test`.

## Why

Performance regressions are easy to introduce and hard to attribute after the fact. Set a budget per metric, measure baseline before the change, measure after, decide. The budget is the contract; the test is the proof.

## Required artifacts

- **Budget document** at `perf/<surface>/budget.md` (or equivalent) with explicit numbers per metric:
  - Response time p50 / p95 / p99 — milliseconds.
  - Bundle size (frontend) — kilobytes after compression.
  - Memory ceiling (backend) — MB resident.
  - Query count / DB roundtrips per request.
- **Baseline measurements** taken on the unmodified code under representative load.
- **Post-change measurements** taken under the same load.
- **Compliance status**: PASS / FAIL per metric. FAIL → optimization plan or scope reduction.

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Budget | Budget exists with explicit numbers per metric; not "fast enough" hand-waving |
| 2 | Baseline | Baseline measurements captured against unmodified code |
| 3 | Load test | Test ran under representative load (not just one synthetic request) |
| 4 | Compliance | All metrics within budget; or, FAIL flagged with optimization plan |
| 5 | Continuous | Test wired into CI for the changed surface; regression alerts configured |

## Test types (k6 taxonomy)

Per the k6 documentation, six test types apply:

- **Smoke** — minimum traffic; sanity check.
- **Average load** — expected production load.
- **Stress** — beyond expected load; identify breakpoint.
- **Soak** — sustained load over hours; reveal memory leaks / connection issues.
- **Spike** — sudden load surge; recovery behavior.
- **Breakpoint** — progressive increase until failure.

Choose the test type per surface. A latency-sensitive endpoint usually wants smoke + average + stress; a streaming surface adds soak.

## Escalation impact

- `max_passes = 5`.
- A change to a hot-path endpoint with no perf measurement is an automatic `blocker`.
- Post-change p99 above budget without an optimization plan is an automatic `blocker`.

## Sources

- [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md) — k6 test types [VERIFIED] (Grafana docs, 2026-04-24).
- [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) — where perf tests sit in the suite shape.
- [`../../../research/07-operations/observability.md`](../../../research/07-operations/observability.md) — production metrics consumed for budget verification.
