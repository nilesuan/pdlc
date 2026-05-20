# OBSERVABILITY.md — SLOs, Four Golden Signals, OpenTelemetry

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §6 (Observability requirements); [`../../../handbook/07-run.md`](../../../handbook/07-run.md); [`../../../research/07-operations/observability.md`](../../../research/07-operations/observability.md).

## The three pillars

- **Logs** — structured, JSON, with `request_id` / `trace_id` correlating to traces.
- **Metrics** — RED (Rate, Errors, Duration) for services; USE (Utilization, Saturation, Errors) for resources.
- **Traces** — OpenTelemetry semantic conventions; request → span tree across services.

The pillars are correlated by IDs. A log without a trace ID is hard to investigate; a trace without metrics is hard to alert on. Wire all three.

## SLOs (Service Level Objectives)

1. **Each service defines 2–5 SLOs.** Not 1 (insufficient picture); not 10 (un-actionable).
2. **SLO formats:**
   - Availability: `≥ 99.9% of requests succeed (HTTP 2xx/3xx/4xx user-error) over 28 days`
   - Latency: `p99 < 300ms over 28 days`
   - Freshness / correctness for data services
3. **Error budget = 1 − SLO.** A 99.9% target → 0.1% error budget → 43m of 28-day window. When budget is exhausted, feature work pauses; reliability work prioritized.
4. **SLOs reviewed quarterly.** If always met → tighten or retire. If always missed → fix the system or relax with rationale.

## Four Golden Signals (Google SRE)

For every user-facing service, dashboard:

1. **Latency** — p50, p95, p99 of successful requests; separate dashboard line for failed requests.
2. **Traffic** — requests per second / queue depth.
3. **Errors** — rate of failed requests, by code class.
4. **Saturation** — CPU / memory / I/O / connection-pool / queue-length, normalized to capacity.

If a service does not have these four panels, the dashboard is incomplete.

## Hard rules

1. **OpenTelemetry SDK + OTLP exporter** for traces and metrics. Vendor-neutral collection.
2. **Structured logs (JSON).** Required fields: `timestamp`, `level`, `service`, `trace_id`, `span_id`, `message`, plus domain fields. No string-formatted log lines.
3. **No PII in logs without explicit redaction policy.** Email, phone, name → redact or hash. Per [`../security/AUTH.md`](../security/AUTH.md) and compliance.
4. **Every alert has a runbook link.** No alert without an answer to "what does the on-call do?"
5. **Alerts are actionable.** Symptom-based (user-impact) preferred over cause-based (CPU 90%). Cause-based alerts that have not fired for 60 days → archive.
6. **Dashboards are versioned in code.** Grafana JSON / Datadog terraform / CloudWatch dashboards in `infra/` with the rest of the stack.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Service has zero SLOs | Major |
| Service has > 8 alerts firing weekly with no runbook | Major (alert fatigue) |
| Logs unstructured (printf-style) | Major |
| `console.log(JSON.stringify(user))` or equivalent — full PII in logs | Blocker |
| Trace propagation broken across a service hop (no `traceparent` header) | Major |
| Dashboard exists only in UI (not in code) | Minor |
| Alert without a runbook link | Major |
| Synthetic / blackbox monitoring missing on critical user journey | Major |

## Symptom > cause for alerting

> "Page on what the user sees, not on what you fear."

| Page-worthy | Not page-worthy |
|---|---|
| Checkout error rate > 1% over 5 min | CPU > 90% on app-1 |
| p99 latency > 1s for 10 min | Disk usage 75% (capacity-plan, don't page) |
| Synthetic checkout transaction failing | Memory leak suspect (instrument, don't page) |

CPU/memory alerts belong in capacity dashboards, not on-call pages.

## What to instrument first (in priority order)

1. Health endpoint returning structured status.
2. RED metrics on every external endpoint.
3. Trace context propagation through every async boundary.
4. Domain events (signups, checkouts, errors-by-class) as metrics, not logs.
5. Saturation: connection pools, queue depths, lock waits.

## Anti-patterns to flag

- "We log everything" → log volume buries the signal. Log decisions, errors, and boundaries; not every loop iteration.
- Alert thresholds set to "whatever fires twice a week" — that's the signal you've calibrated to noise, not impact.
- `if (DEBUG) log.info(...)` everywhere — flag-gated logs that everyone has on in prod. Use levels and structured fields.
- Dashboards with 40 panels nobody reads. Curate to the four golden signals + a few domain panels.

## Sources

- Google SRE Book (Beyer et al., 2016) — Four Golden Signals, SLO/error-budget framing.
- OpenTelemetry semantic conventions (opentelemetry.io/docs/specs/semconv/).
- Brendan Gregg, USE Method (brendangregg.com/usemethod.html).
- Tom Wilkie, RED Method (rabbitstack.github.io / weave.works origin).
- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §6.
- Research: [`../../../research/07-operations/observability.md`](../../../research/07-operations/observability.md).
- Handbook: [`../../../handbook/07-run.md`](../../../handbook/07-run.md).
