---
name: observability
description: Industry-standard observability stacks — metrics, logs, traces, profiling, APM
type: research
---

# Observability

**Question:** What are the current industry-standard choices for application and infrastructure observability in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Metrics, logs, traces (the "three pillars"), plus profiling, real-user monitoring, error tracking, and synthetic monitoring. Security-specific monitoring (SIEM) overlaps with `13-security.md`.

## Shape of the decision

Observability breaks into three parallel decisions:

1. **Instrumentation standard** — how application code emits telemetry. **OpenTelemetry** has become the industry-standard instrumentation layer.
2. **Storage + query backend** — where telemetry lands and how it is searched/alerted-on. Split between SaaS (Datadog, New Relic, Dynatrace, Honeycomb) and open-source self-hosted (Prometheus + Grafana + Loki + Tempo + Mimir, or Elastic / OpenSearch stack).
3. **Error tracking and RUM / front-end** — Sentry dominates error tracking; various tools for real-user monitoring.

The 2024–2026 shift is that OpenTelemetry has effectively won the instrumentation-standard war; the *backend* market is still a contest.

## Evidence base

- **OpenTelemetry CNCF status.** Per [[OpenTelemetry CNCF project page](https://www.cncf.io/projects/opentelemetry/)] (accessed 2026-04-24) [VERIFIED]: project accepted into CNCF on 2019-05-07, moved to Incubating on 2021-08-26. **28,161 total contributors (+17% YoY), 5,374 contributing organizations, 13,010 GitHub stars**. Health score 90/100, software value estimate $335.6M. Maturity level as displayed: **Incubating**.
- The CNCF master project list at [[cncf.io/projects](https://www.cncf.io/projects/)] (accessed 2026-04-24) [VERIFIED] lists OpenTelemetry under **Incubating**, not Graduated. Some secondary sources have reported OpenTelemetry as "graduated" — this is [CONTESTED] and the CNCF primary pages do not support graduated status. As of 2026-04-24, OpenTelemetry is Incubating.
- **OpenTelemetry adoption signal.** CNCF 2025 survey flagged OpenTelemetry as the "second-highest-velocity CNCF project" with "more than 24,000 contributors"; observability profiling usage reached ~20% [[CNCF 2025 announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)] (accessed 2026-04-24) [VERIFIED].
- **Datadog market share.** Secondary reporting citing IDC puts Datadog at 38% of the global observability-tool market [UNVERIFIED — IDC report not fetched as primary; the 38% figure is widely repeated]. Gartner Peer Insights shows Datadog at 4.5 stars / 868 reviews and Grafana Labs at 4.6 / 416, but those are sentiment not share [UNVERIFIED primary data, from the same secondary summary].

## Instrumentation: OpenTelemetry (OTel)

**Why OTel.** Before OTel, every APM vendor shipped a proprietary agent; switching cost was high. The CNCF consolidated OpenTracing and OpenCensus into OpenTelemetry, aiming for a vendor-neutral standard.

- **Signals covered:** traces, metrics, logs (logs general availability has been the long-running work), plus baggage and semantic conventions.
- **Logs GA status (per [[opentelemetry.io/status](https://opentelemetry.io/status/)] accessed 2026-04-24) [VERIFIED]:** Logs are marked **Stable** in the C++, C#/.NET, PHP, and Java SDKs; **Beta** in Go; **Development** in Erlang/Elixir, JavaScript, Kotlin, Python, Ruby, and Swift. Logs are therefore not universally GA across OTel language SDKs as of April 2026; traces and metrics are further along.
- **Components:** SDKs for all major languages, the **OTel Collector** (can receive, process, export in many formats), and the wire protocol **OTLP**.
- **Vendor support:** AWS, Google Cloud, Microsoft Azure, Datadog, Dynatrace, New Relic, and Splunk all maintain native OpenTelemetry exporters or collectors [[OpenTelemetry — CNCF project page](https://www.cncf.io/projects/opentelemetry/)] [VERIFIED through vendor-facing OpenTelemetry documentation; specific vendor integrations are a matter of public record].

**What OTel replaces.** Language-specific APM agents from individual vendors. New observability stacks in 2024–2026 are almost universally built OTel-first; vendor agents are becoming thin OTel wrappers or optional add-ons.

## Metrics: Prometheus

Prometheus is the dominant open-source metrics system. CNCF **graduated** project per the CNCF master project list [[cncf.io/projects](https://www.cncf.io/projects/)] (accessed 2026-04-24) [VERIFIED]. CNCF 2024 Survey: **73% production / 12% evaluating** (n=689) — third among graduated projects behind Kubernetes and Helm [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].

- **Model:** pull-based HTTP scrape, time-series metrics, PromQL query language.
- **Ecosystem:** Alertmanager for alerting; Grafana as the canonical dashboarding frontend; long-term-storage backends include **Thanos**, **Cortex**, **Mimir** (Grafana Labs), and **VictoriaMetrics**.
- **OpenMetrics** — Prometheus exposition format submitted as an OpenMetrics standard; OpenTelemetry can emit OpenMetrics-compatible output.

## Dashboards and visualization: Grafana

Grafana is near-ubiquitous as the open-source dashboarding tool, used in both open-source and commercial stacks.

- **Grafana OSS** is MIT-licensed (though Grafana Labs has tightened some sub-projects' licenses over time) [UNVERIFIED details; Grafana Labs has published explanations].
- **Grafana Cloud** is the managed offering.
- Grafana can ingest from many backends: Prometheus, Loki, Tempo, Mimir, Elasticsearch, PostgreSQL, MySQL, CloudWatch, BigQuery, Datadog, New Relic, etc.

## The Grafana stack for open-source-heavy shops

The opinionated all-Grafana stack:

- **Metrics:** Prometheus → long-term in Mimir / Thanos / VictoriaMetrics.
- **Logs:** Loki.
- **Traces:** Tempo.
- **Profiling:** Pyroscope (acquired by Grafana Labs in 2023) [UNVERIFIED date; widely reported].
- **Frontend:** Grafana (dashboards, alerting).

This stack is self-hostable in entirety and aligns with OpenTelemetry ingestion on the backend.

## The SaaS APM / observability vendors

- **Datadog** — broadest-feature SaaS platform; metrics + logs + traces + APM + security + CI visibility + infrastructure monitoring. Reported ~38% market share [UNVERIFIED — secondary IDC citation].
- **New Relic** — long-standing APM pioneer; rebuilt as "New Relic One" with unified platform pricing.
- **Dynatrace** — enterprise-strong, AI-driven ("Davis" engine), heavy in Java/.NET environments.
- **Splunk** — originally log-management, now full observability suite (Splunk Observability includes SignalFx metrics and APM). Owned by Cisco since 2024 [UNVERIFIED close date].
- **Honeycomb** — distinguished by its focus on high-cardinality event data for exploratory debugging; smaller share but strong in engineering-led orgs.
- **Chronosphere** — metrics-heavy observability at scale; competitive with Prometheus-backed stacks.
- **Lightstep** (acquired by ServiceNow), **Instana** (IBM), **AppDynamics** (Cisco) — each occupy parts of the enterprise APM market.
- **Sumo Logic** — log analytics + observability.

## Logging specifically

- **Elastic Stack (ELK / Elasticsearch + Logstash + Kibana)** — long-time open-source logging default. Post-license-change, **OpenSearch** (Apache 2.0 fork) is the preferred choice in AWS shops.
- **Loki** (Grafana Labs) — logs-in-object-storage model, PromQL-ish query (LogQL). Lower-cost alternative to Elasticsearch for log volume.
- **Fluentd, Fluent Bit** — open-source log forwarders; Fluent Bit is CNCF graduated.
- **Vector** (Datadog/Timber) — Rust-based log/metric router. Rising.
- **SaaS log platforms:** Datadog Logs, Splunk, Sumo Logic, Honeycomb, Coralogix.

## Tracing specifically

- **OTel → backend.** Tempo (Grafana Labs), **Jaeger** (CNCF graduated), **Zipkin** (older), and cloud-vendor backends (AWS X-Ray, GCP Cloud Trace, Azure Monitor App Insights).
- Many SaaS APMs (Datadog, New Relic) ingest OTLP natively.

## Error tracking and RUM

- **Sentry** — dominant application error-tracking platform. Widely used for backend errors + frontend JS errors + performance monitoring and session replay. Self-hostable with caveats.
- **Rollbar, Bugsnag, Raygun** — long-standing error-tracking tools; smaller share than Sentry.
- **Real-user monitoring (RUM):** Datadog RUM, Sentry Performance, New Relic Browser, Cloudflare Web Analytics, Google Search Console / Web Vitals.

## Profiling

- **Continuous profiling** (always-on, low-overhead CPU/memory profiling) is newer to mainstream observability. CNCF 2025 notes ~20% of respondents use profiling in their observability stack [[CNCF 2025 announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)] [VERIFIED].
- **Pyroscope / Parca / Polar Signals** — open-source continuous profiling. Pyroscope now at Grafana Labs; Parca is pure open source.
- **Datadog Continuous Profiler**, **Google Cloud Profiler**, **AWS CodeGuru Profiler** — cloud / SaaS options.

## Synthetic monitoring

Scripted checks against production from external agents:

- **Checkly, Datadog Synthetics, New Relic Synthetics, Pingdom, Site24x7, UptimeRobot** — widely used.
- Status-page providers (Statuspage, Better Stack, Instatus) are adjacent.

## Putting the stack together (typical 2026 defaults)

- **Open-source-leaning team on Kubernetes:** OpenTelemetry instrumentation → OTel Collector → Prometheus / Mimir (metrics) + Loki (logs) + Tempo (traces) + Pyroscope (profiling) → Grafana. Alertmanager for routing.
- **SaaS-leaning team:** OpenTelemetry instrumentation → OTel Collector → Datadog (or New Relic, Dynatrace) for everything.
- **Hybrid (common):** OTel instrumentation + Grafana dashboards + Datadog for specific workloads (e.g., security, APM) + Sentry for error tracking.
- **Error tracking specifically:** Sentry is the near-universal choice regardless of the rest of the stack.

The universal layer across all of these is **OpenTelemetry as the instrumentation API**. [SYNTHESIS from OTel's broad vendor support and rapid CNCF adoption growth.]

## Sources (accessed 2026-04-24)

- [OpenTelemetry — CNCF project page](https://www.cncf.io/projects/opentelemetry/)
- [OpenTelemetry — language / signal status page](https://opentelemetry.io/status/)
- [CNCF master project list — Graduated and Incubating](https://www.cncf.io/projects/)
- [CNCF Annual Cloud Native Survey 2024 — report PDF (March 2025)](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)
- [CNCF Annual Cloud Native Survey 2025 — Announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)

## Open questions

- **Datadog 38% market share** — IDC citation not fetched as primary.
- **Relative split among Datadog / New Relic / Dynatrace / Splunk / Grafana Cloud** — no single cross-vendor survey extracted.
- **Loki vs ELK adoption share** — anecdotally shifting toward Loki for cost; no primary survey.
- **Sentry market share in error tracking** — widely cited as dominant; no primary survey.
