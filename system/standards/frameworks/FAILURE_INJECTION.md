# FAILURE_INJECTION.md — Conditional escalation

**Authoritative source:** [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md); Principles of Chaos Engineering (principlesofchaos.org, verified 2026-04-24).

## Activation

Loaded when the brief contains any of: `external-service`, `retry`, `circuit-breaker`, `availability`, `chaos`, `fault-injection`.

## Why

Per the Principles of Chaos Engineering: "Chaos Engineering is the discipline of experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions in production." Code that talks to external services has a failure mode for every external thing — they need to be exercised.

## The Principles' four steps

1. Define normal behavior using a measurable output.
2. Hypothesize that this normal behavior continues in both control and experimental groups.
3. Introduce real-world variables (server crashes, dependency failures, network slowness, etc.).
4. Attempt to disprove the hypothesis by observing differences between groups.

Plus the canonical fifth principle: **minimize blast radius** — contain and reduce negative customer impact from experiments.

## Required artifacts

- **Failure-injection plan** at `chaos/<feature>/plan.md` covering the relevant scenarios:

| Scenario | Injection method | Expected behavior | Observed |
|---|---|---|---|
| Network timeout | Inject delay > timeout | Retry → fall back; no 5xx to user | (record) |
| Service unavailable (5xx) | Inject 503 from external API | Circuit breaker opens; cached/degraded response | (record) |
| Partial response | Inject partial body | Validation rejects; safe error | (record) |
| Corrupt data | Inject malformed payload | Parse error caught; log + safe default | (record) |
| Rate limiting | Inject 429 | Backoff + retry; respect Retry-After | (record) |

- **Recovery time** measured per scenario.
- **Blast-radius assessment**: is this run in stage with synthetic traffic, or in prod with a small fraction?

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Hypothesis | Normal behavior named with a measurable output |
| 2 | Scenarios | Plan covers timeout, 5xx, partial, corrupt, rate-limit (the five canonical edges) |
| 3 | Run | Injections executed; observed behavior recorded |
| 4 | Compliance | Observed == expected for every scenario; recovery time within target |
| 5 | Productionization | Test wired into a recurring schedule (CI / weekly job / game day) |

## Escalation impact

- `max_passes = 5`.
- A change adding/modifying external-service integration without an injection scenario is an automatic `blocker`.
- Observed behavior diverging from expected without remediation is an automatic `blocker`.

## Anti-patterns to flag

- "Chaos" with no hypothesis — that's just breaking things.
- Production injection with no blast-radius limit.
- Retry logic with no maximum or backoff (compounds outages).
- Circuit breaker with no half-open recovery path (stuck open forever).

## Sources

- [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md) — Principles of Chaos [VERIFIED]; Netflix Chaos Monkey [VERIFIED].
- [`../../../research/07-operations/sre.md`](../../../research/07-operations/sre.md) — game days; SRE practice of failure exercises.
- [`../operations/ON_CALL.md`](../operations/ON_CALL.md) — runbook coupling for chaos-discovered failure modes.
