# Observability, Monitoring & Alerting

**Question:** How do modern teams understand what a running system is doing — what data they collect, how they interpret it, and when they decide to wake a human up?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Observability vs monitoring

### OpenTelemetry's definitions

OpenTelemetry, the CNCF-governed standard, defines the terms directly [VERIFIED]:

> "Observability lets you understand a system from the outside by letting you ask questions about that system without knowing its inner workings."

Telemetry is "data emitted from a system and its behavior" in the form of traces, metrics, and logs. Instrumented applications emit "signals—traces, metrics, and logs."

Source: [Observability Primer — OpenTelemetry](https://opentelemetry.io/docs/concepts/observability-primer/) (accessed 2026-04-24).

OpenTelemetry itself is described as "an observability framework and toolkit designed to facilitate the generation, export, and collection of telemetry data such as traces, metrics, and logs." It is vendor- and tool-agnostic, provides the OTLP protocol, APIs, SDKs, a Collector, and instrumentation libraries. Crucially, OpenTelemetry "itself is not an observability backend" — it collects and exports, while storage and visualisation are left to separate tools (Jaeger, Prometheus, commercial backends, etc.). Source: [What is OpenTelemetry?](https://opentelemetry.io/docs/what-is-opentelemetry/) (accessed 2026-04-24).

### Charity Majors on the distinction

Charity Majors (Honeycomb co-founder) defines observability as [VERIFIED]:

> "the power to ask new questions of your system, without having to ship new code or gather new data"

Her framing sets up the contrast with monitoring:

- **Monitoring** — known-unknowns, actionable alerts.
- **Observability** — unknown-unknowns, arbitrary new questions answered from already-captured data.

The Honeycomb observability manifesto lists five tenets:

1. **No pre-aggregation** — raw events must be retrievable; aggregation destroys the ability to answer unanticipated questions.
2. **High-cardinality support** — user IDs, request IDs, IP addresses must be first-order group-by entities.
3. **Structured data** — fields and types enable computation.
4. **Preserve event context** — do not strip correlation by forcing everything into metrics/time-series.
5. **Observability-driven development** — instrument during development, not after.

Source: [Observability — A Manifesto, Charity Majors, Honeycomb](https://www.honeycomb.io/blog/observability-a-manifesto) (accessed 2026-04-24).

**[SYNTHESIS]** OpenTelemetry provides a tool-agnostic way to *emit* high-quality telemetry; Majors' manifesto describes what properties a *backend* must have to turn that telemetry into observability. These two sources are complementary, not competing.

---

## The three pillars

Per OpenTelemetry's primer [VERIFIED]:

- **Logs** — "A timestamped message emitted by services or other components" that are not necessarily tied to a specific user request; "they lack contextual information but become more useful when correlated with spans and traces."
- **Metrics** — "Aggregations over a period of time of numeric data about your infrastructure or application," such as error rates, CPU utilisation, request rates.
- **Traces** — "the path taken by a single request… as it propagates through multiple services," composed of spans that demonstrate end-to-end request journeys.

Source: [Observability Primer — OpenTelemetry](https://opentelemetry.io/docs/concepts/observability-primer/) (accessed 2026-04-24).

**[CONTESTED]** The "three pillars" framing itself is contested in the observability community. Majors in particular has argued publicly that pillar-based thinking misses the point (observability is not three separate stacks but one structured event stream you can slice arbitrarily). The OpenTelemetry primer presents the three signals as complementary, not as the definition of observability. Both views are represented above; readers should treat "three pillars" as a useful taxonomy rather than a definition.

---

## Monitoring methods

### Google's Four Golden Signals

From Google's Monitoring Distributed Systems chapter [VERIFIED], the four essential metrics for user-facing systems:

1. **Latency** — "The time it takes to service a request." Track successful and failed request latencies separately.
2. **Traffic** — "A measure of how much demand is being placed on your system, measured in a high-level system-specific metric."
3. **Errors** — "The rate of requests that fail, either explicitly (e.g., HTTP 500s), implicitly (for example, an HTTP 200 success response, but coupled with the wrong content), or by policy."
4. **Saturation** — "How 'full' your service is. A measure of your system fraction, emphasizing the resources that are most constrained."

The same chapter distinguishes:

- **White-box monitoring** — internal system metrics, logs, internal-stats endpoints.
- **Black-box monitoring** — "Testing externally visible behavior as a user would see it."

And symptoms vs causes: "Your monitoring system should address two questions: what's broken, and why?"

Source: [Monitoring Distributed Systems — Google SRE book](https://sre.google/sre-book/monitoring-distributed-systems/) (accessed 2026-04-24).

### Brendan Gregg's USE Method

Brendan Gregg published the USE Method as a systematic resource-performance checklist [VERIFIED]:

> "For every resource, check utilization, saturation, and errors."

Definitions from the page:

- **Resource** — physical server functional components (CPUs, disks, buses, etc.), extendable to software resources (mutex locks, thread pools, file descriptor capacity).
- **Utilisation** — average time a resource was busy servicing work, as a percentage over an interval.
- **Saturation** — degree to which a resource has extra work it cannot service (queue length).
- **Errors** — count of error events that may degrade performance or go unnoticed when failures are recoverable.

Gregg says the method "solves about 80% of server issues with 5% of the effort" and should be employed early in performance investigations.

Source: [The USE Method — Brendan Gregg](https://www.brendangregg.com/usemethod.html) (accessed 2026-04-24).

### Tom Wilkie's RED Method

RED is Tom Wilkie's microservice-oriented monitoring framework [VERIFIED]:

- **Rate** — "the number of requests per second"
- **Errors** — "the number of those requests that are failing"
- **Duration** — "the amount of time those requests take"

Wilkie's own framing of the USE/RED relationship (quoted on the Grafana blog):

> "It's like the RED Method is about caring about your users and how happy they are, and the USE Method is about caring about your machines and how happy they are."

RED, Wilkie notes, is essentially a subset of Google's Four Golden Signals — RED plus saturation equals the Golden Signals.

Source: [The RED Method: How to Instrument Your Services — Tom Wilkie / Grafana Labs](https://grafana.com/blog/the-red-method-how-to-instrument-your-services/) (accessed 2026-04-24).

### Method comparison

| Method | Asks about | Best for |
|---|---|---|
| Four Golden Signals | latency, traffic, errors, saturation | user-facing services |
| RED | rate, errors, duration | microservices (user-perspective) |
| USE | utilisation, saturation, errors | hardware/infrastructure/resources |

**[SYNTHESIS]** from the three cited sources above. Each method has its own citation; the comparison table is a summary of the three.

---

## Alerting

Google's Practical Alerting chapter offers specific advice [VERIFIED]:

- Separate queues: "teams send their page-worthy alerts to their on-call rotation and their important but subcritical alerts to their ticket queues."
- Do not page on single-machine failures at scale: "being alerted for single-machine failures is unacceptable because such data is too noisy to be actionable." Instead, "a large system should be designed to aggregate signals and prune outliers."
- Require duration thresholds to prevent flapping: "the rules allow a minimum duration for which the alerting rule must be true before the alert is sent. Typically, this duration is set to at least two rule evaluation cycles."
- Combine white-box and black-box monitoring: "By using both targets, we can detect localized failures and suppress alerts."

Source: [Practical Alerting from Time-Series Data — Google SRE book](https://sre.google/sre-book/practical-alerting/) (accessed 2026-04-24).

**[SYNTHESIS]** A practical alerting discipline, reading across these sources: page on user-visible symptoms (SLO burn), not on internal causes; batch and ticket the subcritical; require persistence to cut noise; tie each alert to a documented response (runbook).

---

## Sources

- [Observability Primer — OpenTelemetry](https://opentelemetry.io/docs/concepts/observability-primer/) (accessed 2026-04-24)
- [What is OpenTelemetry?](https://opentelemetry.io/docs/what-is-opentelemetry/) (accessed 2026-04-24)
- [Observability — A Manifesto, Charity Majors, Honeycomb](https://www.honeycomb.io/blog/observability-a-manifesto) (accessed 2026-04-24)
- [Monitoring Distributed Systems — Google SRE book](https://sre.google/sre-book/monitoring-distributed-systems/) (accessed 2026-04-24)
- [The USE Method — Brendan Gregg](https://www.brendangregg.com/usemethod.html) (accessed 2026-04-24)
- [The RED Method — Tom Wilkie, Grafana Labs](https://grafana.com/blog/the-red-method-how-to-instrument-your-services/) (accessed 2026-04-24)
- [Practical Alerting from Time-Series Data — Google SRE book](https://sre.google/sre-book/practical-alerting/) (accessed 2026-04-24)

---

## Open questions

- **Observability standardisation** — OpenTelemetry is clearly the standard for emission. What is the current state of standardisation on the backend/query side? No single primary source fetched during this session answered that.
- **"Three pillars" critique** — worth a dedicated primary source (e.g. a specific Charity Majors article arguing against pillar-thinking). The manifesto hints at it but does not state it directly.
- **Alerting-as-code / alert fatigue research** — any peer-reviewed or industry-survey data on alert fatigue rates would strengthen the "alerts must be actionable" claim beyond Google's internal assertion.
