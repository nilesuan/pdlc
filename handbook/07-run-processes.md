# Phase 07 — Run: Processes

**Companion to:** [`07-run.md`](07-run.md)
**Last updated:** 2026-04-24

This document decomposes Phase 07 into discrete, repeatable processes. `07-run.md` tells you *what operations is* and *why the industry converged on SRE / CSF / ICS*; this file tells you *who runs each process, when, with what inputs, and how you know it's done*.

---

## How to read this

Each process below follows the same ten-field pattern:

- **Purpose** — the one sentence that explains why this process exists.
- **RACI** — Responsible / Accountable / Consulted / Informed.
- **Triggers** — the events that start the process.
- **Inputs** — the artifacts / information required to run it.
- **Activities** — the concrete steps.
- **Outputs** — the artifacts / decisions that result.
- **Tools / templates** — what actually supports the work.
- **Cadence / duration** — how often it runs and how long it takes.
- **Exit gate** — the objective test that says "done."
- **Pitfalls** — the specific ways this process fails in practice.

Phase 07 is continuous; these processes run forever with changing cadence. Most never truly "exit" — they meet their gate for the current cycle and restart.

---

## Process inventory

| # | Process | Typical cadence | Primary owner |
|---|---|---|---|
| 1 | SLO Definition & Error Budget Policy | Per service at launch; quarterly review | Service tech lead |
| 2 | Observability Instrumentation (OpenTelemetry) | Per service at launch; per new component | Service author |
| 3 | Dashboard Authoring & Maintenance | Per service; reviewed monthly | Service tech lead |
| 4 | Structured Logging & Log Hygiene | Per service; audited quarterly | Service author + security |
| 5 | Alerting Rule Authoring & Tuning | Per SLO; tuned continuously | Service tech lead |
| 6 | Runbook Authoring & Maintenance | Per alert / per standard scenario; tested quarterly | Alert / scenario owner |
| 7 | On-Call Rotation Management | Weekly handoff; quarterly rotation review | Engineering manager / SRE lead |
| 8 | Incident Response (ICS) | Per incident | Incident Commander |
| 9 | Postmortem & Action Item Tracking | Per incident; weekly / monthly review | Incident owner |
| 10 | Capacity Planning & Load Testing | Ahead of launches / known growth; quarterly | Service tech lead + platform |
| 11 | Disaster Recovery / Backup Drill | At least quarterly | Platform / SRE |
| 12 | Security Operations (CSF Detect / Respond / Patch) | Continuous; patching on SLA; quarterly review | Security lead (or eng lead at small scale) |
| 13 | FinOps / Cost Review | Daily dashboard; monthly review | Finance + engineering |
| 14 | Game Day / Chaos Experiment | Quarterly minimum | Platform / SRE + service team |
| 15 | Continuous Feedback to Phases 02 / 08 | Weekly / per incident | Tech leads + product |

---

## Default RACI

Convention: **R** = does the work; **A** = signs off; **C** = consulted before commit; **I** = notified after.

| Process | Service author | Service tech lead | On-call | IC | Platform / SRE | Security | Eng mgr | Product |
|---|---|---|---|---|---|---|---|---|
| SLO & error budget | C | R, A | I | — | C | — | C | C |
| OTel instrumentation | R | A | I | — | C | — | — | — |
| Dashboards | R | A | C | — | C | — | — | C |
| Structured logging | R | A | — | — | C | C | — | — |
| Alerting rules | R | A | C | — | C | — | — | — |
| Runbooks | R | A | C | — | C | — | — | — |
| On-call rotation | — | C | R (participates) | — | C | — | R, A | I |
| Incident response | — | C | R (first responder) | R, A | C | C (security incidents) | I | I |
| Postmortem | — | C | C | R, A (first) | C | C | I | I |
| Capacity planning | C | R | — | — | R | — | — | C |
| DR / backup drill | — | C | — | — | R, A | C | I | — |
| Security ops / patching | C | C | C | — | C | R, A | — | I |
| FinOps cost review | C | C | — | — | R | — | — | C |
| Game day / chaos | C | C | C | C | R, A | C | I | I |
| Continuous feedback | C | R | C | C | C | C | C | R, A |

---

## 1) SLO Definition & Error Budget Policy

**Purpose.** Decide explicitly how reliable the service needs to be, measure it from real traffic, and turn the gap into a policy that trades velocity against stability — so the team does not negotiate reliability ad hoc during every incident.

**RACI.** R, A: service tech lead. C: platform, product, eng mgr. I: team, leadership.

**Triggers.**
- Service reaches production.
- Quarterly SLO review.
- A sustained pattern of budget exhaustion (signals that the SLO is miscalibrated or the service is under-provisioned).

**Inputs.**
- 28 days of production traffic to baseline against (if available).
- SLA commitments to customers (if any) — the SLO must be stricter than the SLA.
- The SRE vocabulary: SLI (what you measure), SLO (target), SLA (contractual promise).
- Historical incident rate and failure modes.

**Activities.**
1. Identify user-facing behaviour to measure: availability (success rate), latency (p99 under threshold), correctness (jobs completing without exhaustion), freshness (data appearing in time). Not CPU, memory, queue depth — those are causes, not symptoms.
2. Pick **2–5 SLOs per service**. More than five and no one can reason about them together.
3. Baseline each from production. If current is 99.93%, do not set 99.99% and declare yourself in violation.
4. Set the target **slightly stricter than current reality** — gentle pressure, not immediate failure. 99.9% is a defensible default when baseline is 99.93–99.97%.
5. Define the measurement window: rolling 28 days is the standard (calendar months skew by length).
6. Compute the error budget = 1 − SLO. (99.9% over 28 days = ~40 min of permitted failure.)
7. Write the **error-budget policy** explicitly:
   - Budget intact → ship aggressively.
   - Budget half-spent → normal caution.
   - Budget exhausted → feature freeze until paid back; only reliability, bug fixes, and rollbacks merge.
8. Publish the SLOs, error budget, and policy in the service README and a team-visible dashboard.
9. Review quarterly. Tighten, loosen, or restate based on data.

**Outputs.**
- SLO document committed to the service repo (2–5 SLIs, targets, windows).
- Error-budget policy (written, signed off).
- SLO dashboard with current burn visible.

**Tools / templates.**
- Prometheus + recording rules / Datadog / Grafana SLO / Honeycomb / Nobl9 / Sloth.
- Service README section reserved for SLOs.
- SLO doc template (SLI definition, target, window, justification).

**Cadence / duration.** Initial definition: 2–5 hours. Quarterly review: 30–60 minutes per service.

**Exit gate.**
- SLOs named, targeted, with windows and measurement methods documented.
- SLIs emitted from production and visible on the dashboard.
- Error-budget policy written and agreed; product and eng mgr bought in.

**Pitfalls.**
- **Aspirational SLOs no one measures.** "Four nines!" on a slide. Decoration.
- **Too many SLOs.** A dashboard of 30 "objectives" is not objectives; it's dashboard panels.
- **SLO on a cause, not a symptom.** "CPU under 70%" is a resource target, not a user-facing objective.
- **Error budget that never triggers a freeze.** If the policy never halts features, it is not a policy.
- **SLO equal to SLA.** No margin. The first breach is a customer refund.

---

## 2) Observability Instrumentation (OpenTelemetry)

**Purpose.** Emit structured telemetry that lets the team ask new questions of the running system without shipping new code — so outages are investigated with data, not speculation.

**RACI.** R: service author. A: service tech lead. C: platform. I: on-call.

**Triggers.**
- New service being built.
- New component / integration / background job added.
- Visibility gap discovered (during postmortem: "we couldn't tell which tenant was affected").

**Inputs.**
- Service language SDK for OpenTelemetry.
- Chosen backend (Datadog, Honeycomb, New Relic, Grafana Cloud, or self-hosted LGTM).
- Sampling / cardinality policy from platform.
- Standard attribute schema (user ID, tenant ID, request ID, service name, environment, version).

**Activities.**
1. Adopt **OpenTelemetry unconditionally** as the instrumentation SDK. Decouples instrumentation from backend; switching vendors does not mean re-instrumenting the code.
2. Configure OTLP exporter to the chosen backend. Never bake a vendor SDK into application code.
3. Instrument the four signal sources:
   - Every HTTP handler: duration, status, route, user/tenant ID, request ID, version.
   - Every external call: destination, duration, status, error type, retry count.
   - Every background job / queue consumer: duration, outcome, retries, queue lag.
   - Key business events: signup, purchase, activation, cancellation — as events with rich attributes, not counts.
4. Enable auto-instrumentation for frameworks (HTTP servers, DB drivers, HTTP clients) to get traces cheaply.
5. Add **deploy markers** to the metrics backend so dashboards show version boundaries.
6. Set sampling policy: head-based sampling for baseline traffic; tail-based sampling if errors should always be captured.
7. Redact sensitive fields at the SDK layer (see process 4 — no passwords / tokens / raw PII).

**Outputs.**
- OTel instrumentation in the service code.
- Traces, metrics, and logs flowing to the backend for this service.
- Deploy markers visible on metrics dashboards.

**Tools / templates.**
- OpenTelemetry SDKs (per language) and OTLP.
- Backend: Datadog / Honeycomb / Grafana Cloud / New Relic / self-hosted Prometheus + Loki + Tempo + Grafana.
- Sentry separately for error tracking (stack traces, release correlation).
- A shared `telemetry.{ts,go,py}` helper module per service for consistent attribute emission.

**Cadence / duration.** Per service: 1–3 days to instrument initially. Per new component: minutes to hours.

**Exit gate.**
- Every HTTP handler, external call, and background job emits spans with standard attributes.
- Business events visible as events (not just metrics).
- Deploy markers appear on the dashboards.
- No sensitive data in telemetry.

**Pitfalls.**
- **Vendor SDK in application code.** Moving backends means a rewrite.
- **Three separate stacks (logs / metrics / traces).** Charity Majors' critique — silos prevent slicing. Prefer a unified backend or at least a shared attribute schema.
- **Logs as telemetry.** Printing is not instrumenting. Unstructured logs cannot be queried at scale.
- **Ad-hoc attribute names.** `user_id` vs `userId` vs `uid` in the same service. Adopt a schema.
- **No sampling.** Unbounded cardinality + volume bankrupts you before it helps you.

---

## 3) Dashboard Authoring & Maintenance

**Purpose.** Give responders a boring, glance-able surface that answers "is it broken and is it getting worse?" within two seconds — so dashboards support action under stress, not admiration during reviews.

**RACI.** R: service author. A: service tech lead. C: on-call, platform. I: product.

**Triggers.**
- New service reaches production.
- New SLO added.
- Major feature shipped that warrants its own business metric.
- Quarterly dashboard review.

**Inputs.**
- Telemetry from process 2.
- SLOs from process 1.
- The Four Golden Signals definition (latency, traffic, errors, saturation).
- RED (Rate / Errors / Duration) for services; USE (Utilisation / Saturation / Errors) for resource investigations.

**Activities.**
1. Build **one dashboard per service** with the Four Golden Signals on the top row:
   - Latency — p50 / p95 / p99, success vs error separated.
   - Traffic — requests per second or active users.
   - Errors — rate of 5xx (explicit), 4xx trends (policy), business-error rate (implicit).
   - Saturation — queue depth, thread-pool usage, memory headroom.
2. Add SLO burn-rate panels immediately below, prominent. Current 28-day burn, short-window multi-burn-rate status.
3. Include deploy markers as annotations.
4. Build a **separate business metrics dashboard**: signups, activations, conversions, revenue. Same deploy markers. Operations teams look at the first; exec + product look at the second; responders look at both during incidents.
5. Author dashboards **as code**. Terraform + Grafonnet, Datadog dashboard JSON, or the backend's native API. Hand-maintained dashboards drift within weeks.
6. Keep widgets **boring** — line charts and numbers. No exotic visualisations; a responder at 3 a.m. cannot learn a new chart type.
7. Review monthly: remove panels no one looks at; add panels that were missed during the last incident.

**Outputs.**
- Service dashboard JSON / HCL committed to the repo.
- Business metrics dashboard.
- Deploy markers wired in.

**Tools / templates.**
- Grafana (with Grafonnet / Jsonnet) / Datadog / Honeycomb / Looker / etc.
- A shared "service dashboard" starter template per the platform.
- Git-tracked dashboard definitions.

**Cadence / duration.** Per service: 4–8 hours initial build. Monthly review: 30 minutes.

**Exit gate.**
- Four Golden Signals on top row.
- SLO burn-rate panels visible.
- Dashboard-as-code committed.
- Responder can answer "broken? getting worse?" in under two seconds from the top row.

**Pitfalls.**
- **Hand-maintained dashboards.** Drift; nobody remembers who owns them.
- **Exotic visualisations.** Clever under demo conditions, illegible under incident conditions.
- **No deploy markers.** Responder cannot correlate the spike to a deploy without cross-referencing another tool.
- **One mega-dashboard with every service.** Nobody owns it; no one updates it; it ages into uselessness.
- **No business dashboard.** Infrastructure green while revenue drops for an hour.

---

## 4) Structured Logging & Log Hygiene

**Purpose.** Produce a queryable event stream from production while never logging data that turns the log stream into a breach — so investigation is possible and compliant.

**RACI.** R: service author. A: service tech lead. C: security, platform. I: compliance.

**Triggers.**
- Service being instrumented.
- New feature handling sensitive data (payment, PII, health).
- Discovery of a logging leak (postmortem finding).
- Quarterly log-content audit.

**Inputs.**
- Structured log library (zap / zerolog / pino / structlog / logrus / tracing-rs).
- The standard attribute schema (shared with OTel — process 2).
- Regulatory regime applicable to the data (GDPR / CPRA / HIPAA / PCI DSS).
- OWASP Top 10:2025 A09 guidance (Logging & Alerting Failures).

**Activities.**
1. Emit **JSON (structured) logs only**, never plain text. Every log line is a queryable event.
2. Include on every line: timestamp, request ID, user/tenant ID (hashed if necessary), service name, environment, version, severity.
3. Build a **redaction layer at the SDK boundary**. Deny-list: passwords, auth tokens, API keys, session cookies, raw payment details, raw PII (email in some regimes, full names with tokens, health data). The redactor intercepts structured fields, not regex-matches on output strings.
4. Allow hashed / truncated identifiers where a full identifier would be leaking.
5. Set **retention** per class of data:
   - App/request logs: 30 days warm, up to 1 year cold.
   - Regulated data: per regime (PCI: specific durations; HIPAA: 6 years; GDPR: "no longer than necessary").
   - Security/audit logs: retained longer than app logs, separately, with stricter access.
6. Log levels: DEBUG suppressed in production by default; INFO for state-changing events; WARN for recoverable; ERROR for pages-worthy.
7. Rotate and centralise: ship to log backend (Loki / Datadog Logs / CloudWatch / Humio / Elastic), never keep on local disks.
8. Quarterly **log-content audit**: sample raw log lines. Any prohibited field surfaces → fix the redactor, not just the line.

**Outputs.**
- Structured log output across all services.
- Redaction layer tested with unit tests against the deny-list.
- Retention policy written down and enforced by the log backend.

**Tools / templates.**
- Language-appropriate structured loggers.
- Log backends (Loki, Datadog, Humio, Elastic, CloudWatch, Splunk).
- A `logger.{ts,go,py}` helper forcing the schema.
- A log-content scanning tool (internal or Datadog / Rapid7) for periodic audits.

**Cadence / duration.** Initial setup: 1–2 days. Audit: 1 hour per quarter.

**Exit gate.**
- Every service produces JSON logs with the standard attribute schema.
- Redaction unit tests pass.
- Retention matches the regulatory regime.
- Audit finds no prohibited fields in sampled logs.

**Pitfalls.**
- **Plain-text logs.** Not queryable at scale; no correlation possible.
- **Passwords or tokens in logs.** OWASP A09 plus regulatory exposure; one grep away from a breach.
- **"Temporary" DEBUG logs shipped to prod.** Accidental over-sharing and unaffordable volume.
- **Unscoped retention.** Keep-everything-forever costs, and violates data-minimisation principles.
- **Log level used as severity.** Level is the router; severity belongs in the event schema.

---

## 5) Alerting Rule Authoring & Tuning

**Purpose.** Page humans only when human action is needed in the next hour — so on-call stays discriminating, alerts stay actionable, and real pages do not get lost in noise.

**RACI.** R: service author. A: service tech lead. C: on-call, platform. I: team.

**Triggers.**
- New SLO established.
- New failure mode discovered in a postmortem.
- On-call shift flagged noisy alerts.
- Quarterly alert review.

**Inputs.**
- SLOs from process 1.
- Historical alert noise stats (pages per shift, actionability rate).
- The SRE Workbook's multi-window, multi-burn-rate alerting formulas.
- Google's rule: "every page should be actionable."

**Activities.**
1. For every SLO, author **SLO burn-rate alerts** using the multi-window, multi-burn-rate pattern:
   - Page when the service is about to exhaust one month's budget in one hour (fast burn).
   - Page when about to exhaust one day's budget in six hours (sustained burn).
   - Combining windows avoids flaps on short spikes and catches real regressions quickly.
2. Classify each alert into a queue:
   - **Page** — human action required within the hour.
   - **Ticket / email / Slack channel** — someone reviews next business day.
   - **Dashboard-only** — metric belongs on the dashboard, not in anyone's inbox.
3. Require **duration thresholds** (at least two evaluation cycles before firing) to prevent flapping.
4. Attach a **runbook link** to every alert. No exceptions; runbook-less alerts get deleted.
5. Tag alerts with owner team / service so paging routes cleanly.
6. Do **not** page on single-machine failures at scale. Aggregate to service-level then alert.
7. Track alert health: **target < 2 unactionable pages per shift**. Anything above → tune, deduplicate, or delete.
8. Quarterly review:
   - Alerts that never fired: delete or revise.
   - Alerts that fired but produced no action: delete, re-scope, or re-queue.
   - Alerts that fired but no one found the runbook: fix the runbook or fix the alert.

**Outputs.**
- Alert rules as code (Prometheus rules, Datadog monitor HCL, Grafana alerts, Honeycomb triggers).
- Alert → runbook links enforced by lint rule or CI check.
- Alert health dashboard (pages per shift, actionable rate).

**Tools / templates.**
- Prometheus alerting rules / Alertmanager / Datadog monitors / Honeycomb triggers / Grafana alerts.
- PagerDuty / Opsgenie / Incident.io for routing and escalation.
- A "signal-to-noise" ratio panel per on-call service.

**Cadence / duration.** Per SLO: 1–3 hours. Quarterly review: 60 minutes per service.

**Exit gate.**
- Every page has a runbook link.
- Every page is actionable (human action required within the hour).
- Alerts-per-shift below threshold for the last two shifts.
- No alerts paging on single-machine failures in an aggregated fleet.

**Pitfalls.**
- **Alerting on every anomaly.** Fastest way to destroy on-call discipline.
- **Pages without runbooks.** Responder googles in an incident.
- **Static thresholds that never update.** "CPU > 80%" set in 2022; service now has 10× traffic.
- **No severity / queue separation.** Every warning becomes a page; team tunes out.
- **Alerts only in the tool's GUI.** Not reviewed like code; drifts; breaks silently.

---

## 6) Runbook Authoring & Maintenance

**Purpose.** Give a responder (possibly sleep-deprived, possibly new to the service) the minimum steps to understand the alert, mitigate it, and escalate — so incident response is not a debugging session from scratch every time.

**RACI.** R: alert / scenario owner. A: service tech lead. C: on-call. I: platform.

**Triggers.**
- New alert created.
- New standard operational scenario identified (certificate rotation, cache flush, failover, credential rotation, traffic shift).
- Game day or incident found a runbook gap.
- Quarterly runbook test (game-day walkthrough).

**Inputs.**
- The alert definition or the scenario description.
- Current dashboards.
- Relevant mitigations (rollback, flag flip, failover, read-only mode).
- Escalation contacts.

**Activities.**
1. Use the standard runbook format: **Triggers → Checks → Mitigations → Escalation**.
2. Keep runbooks in a **versioned repo next to the code**. PR review applies; drift is visible.
3. Write in imperative present tense, step-by-step, with links (dashboard URLs, recent-deploys query, feature-flag URL).
4. Include at least two mitigation options when possible — rollback, flag off, failover — in order of preference.
5. Include explicit escalation: "page next tier after N minutes of failed mitigation" / "Slack #channel for SME."
6. **Test each runbook at least quarterly** by actually following it during a game day (process 14). Reading a runbook is not testing a runbook.
7. Automate toil out: a step that never requires judgment becomes a button, a script, or a self-healing system (Google's Eliminating Toil framing).

**Outputs.**
- Runbook markdown committed to repo.
- Runbook URL referenced in the corresponding alert.
- Game-day test notes confirming runbook correctness (or PRs fixing it).

**Tools / templates.**
- Markdown in the service repo (or a central runbooks repo).
- A standard runbook template in the handbook.
- Link-check CI to verify runbook URLs resolve.

**Cadence / duration.** Per runbook: 30–90 minutes initial; 15 minutes per quarterly test.

**Exit gate.**
- Runbook exists for every page-worthy alert and every standard operational scenario.
- All runbooks tested in the last quarter.
- No dead links; URLs resolve.
- At least one on-call responder has exercised each runbook at 3 a.m. equivalent (game day).

**Pitfalls.**
- **Runbook written but never tested.** The first real-world test is an incident.
- **Out-of-date commands.** `kubectl` flags change, API endpoints rename. Found at 3 a.m.
- **Runbook references tools the responder does not have access to.** Plan for permissions, not just for steps.
- **Narrative runbooks.** "First, consider whether..." Imperative steps only.
- **Automated steps that nobody has re-tested in a year.** Automation rot.

---

## 7) On-Call Rotation Management

**Purpose.** Share operational responsibility across the team so the service can be operated around the clock without creating heroes, burning people out, or violating working-time norms.

**RACI.** R: engineering manager / SRE lead. A: engineering manager. C: service tech lead, on-call participants. I: team, platform.

**Triggers.**
- Service reaches production and needs 24/7 coverage.
- Rotation member leaves or joins.
- Shift feedback indicates unsustainable load.
- Quarterly rotation review.

**Inputs.**
- Team size (must meet the SRE Workbook rule-of-thumb floor; see activities).
- Geographic distribution (single-site vs follow-the-sun).
- Local labour laws (EU working-time directive and equivalents).
- PagerDuty / Opsgenie / Incident.io rotation tooling.
- Compensation policy (time-off-in-lieu vs cash, capped share of salary).

**Activities.**
1. Set the rotation shape:
   - **Team of 5+ at one site:** one-week shifts, everyone participating. If fewer than Google's eight-person floor, consider reducing hours, follow-the-sun, or paying for external on-call help.
   - **Multiple timezones:** follow-the-sun pairing so no one is live at 3 a.m. on purpose.
2. Run **primary + secondary**. Secondary picks up if primary misses the ack window.
3. Limit shifts to **12 continuous hours of live duty**. A one-week on-call splits primary / secondary across the day so a single person is not live for 168 hours.
4. Schedule **handoff at the same time every week** (e.g. Monday 10:00 local). Handoff includes a live meeting covering open incidents, ongoing issues, and recent changes.
5. Never rotate a new joiner before a shadow cycle. Shadow → secondary → primary.
6. Define ack SLA (PagerDuty suggests 5 minutes). Measure it; report on it.
7. Publish **on-call health metrics**: pages-per-shift, actionable rate, acks-within-SLA. Target fewer than 2 unactionable pages per shift.
8. If pages exceed threshold for two consecutive shifts → **freeze feature work on that service** until root cause is resolved. (Error-budget policy applied to humans.)
9. Compensate: time-off-in-lieu, cash stipend capped per Google's example, or both. Comply with local law.

**Outputs.**
- Rotation schedule in the paging tool.
- Handoff notes template.
- On-call health dashboard.
- Written compensation policy.

**Tools / templates.**
- PagerDuty / Opsgenie / Incident.io / xMatters for scheduling and paging.
- Handoff template in the team repo.
- An on-call onboarding checklist (access, permissions, shadow cycle).

**Cadence / duration.** Weekly handoff: 15–30 minutes. Quarterly review: 60 minutes.

**Exit gate.**
- Rotation scheduled and running.
- Primary + secondary configured.
- Ack SLA measured.
- Handoffs happening on time.
- Compensation policy published.
- Pages-per-shift inside target.

**Pitfalls.**
- **Permanent hero.** Same person holding the pager every week.
- **Rotation too thin.** Under-eight-person rotations burn people out; reduce scope or buy coverage.
- **No ack SLA.** You cannot measure failure without a threshold.
- **No shadow cycle.** New joiner's first page is their first exposure to the runbook.
- **Silence on compensation.** People quit rather than ask.
- **Crossing the working-time directive for EU engineers.** Legal exposure.

---

## 8) Incident Response (ICS)

**Purpose.** Coordinate responders under stress using a role framework borrowed from emergency services — so the goal (restore service) does not get lost in the debugging, and communication keeps pace with the work.

**RACI.** R: Incident Commander. A: Incident Commander (for the incident); service tech lead (for service health). C: responders, Comms Lead, Scribe. I: product, leadership, customers (through status page).

**Triggers.**
- Alert fires at page severity.
- Customer-reported outage confirmed.
- On-call judgement: "this needs an incident channel."
- Security event suspected or confirmed.

**Inputs.**
- Severity definitions (SEV1 / SEV2 / SEV3 / SEV4).
- Incident tracker (Incident.io / PagerDuty / FireHydrant / Rootly / Statuspage).
- Runbooks (process 6).
- Dashboards (process 3).
- Status page.

**Activities.**
1. **Detect.** An alert fires, a user reports, or a monitor anomaly becomes a concern.
2. **Declare.** Open a dedicated incident channel (Slack / Teams — never a repurposed general channel). Assign an **Incident Commander**. Page per severity. Open the incident document.
3. **Assign roles** (per severity):
   - **IC** — coordinates, does not fix. Makes severity / escalation / resolution calls. Hands-off from keyboard work.
   - **Operational Lead / Subject-Matter Responders** — technical work. Only responders modify the system during an incident.
   - **Comms Lead** (SEV1/2) — status page, customer comms, internal updates. Splits into Customer Liaison and Internal Liaison at scale.
   - **Scribe** — timeline; can be partially automated by a Slack bot.
   - **Deputy** — backs up the IC; takes over on handoff.
4. **Triage.** Confirm severity. When in doubt, declare higher; downgrading a SEV1 is easy.
5. **Mitigate first.** Rollback, flag off, traffic shift, failover, read-only mode. Root cause comes later. Customer bleeding trumps understanding.
6. **Communicate.** Status page updated every 15–30 minutes during SEV1/2. Internal updates on cadence. Stakeholder email for major incidents.
7. **Handoff** if the incident outlives a shift: explicit written handoff in channel — outgoing IC, incoming IC, status, open threads, next actions.
8. **Resolve.** Service confirmed restored. All-clear posted. Severity downgraded. Incident doc kept open for postmortem.
9. Open the postmortem (process 9) within 24 hours of resolution.

**Outputs.**
- Incident channel with full timeline.
- Incident document (summary, timeline, status-page history, comms log).
- Status-page history.
- Paged responders' ack timestamps.

**Tools / templates.**
- Incident platform (Incident.io, PagerDuty, FireHydrant, Rootly, Grafana OnCall).
- Slack incident channel naming convention (e.g. `#inc-<date>-<service>-<short-slug>`).
- Incident document template with sections for timeline, impact, roles.
- Status page (Statuspage, Incident.io statuspage, self-hosted).

**Cadence / duration.** Per incident. Duration varies; resolution-quality is what matters.

**Exit gate.**
- Service restored; SLIs back to baseline.
- Incident document up to date.
- All-clear posted internally and on status page.
- Postmortem slated.

**Pitfalls.**
- **IC also debugging.** No commander; responders talk past each other.
- **Freelance fixes.** Non-responders making "one quick change" to help. Creates a second incident.
- **Repurposed general channel.** Hard to track the incident alongside day-to-day chatter.
- **Root-cause-first behaviour.** Responders dig into code while the customer sees 500s.
- **Silent status page.** Customers find out from Twitter.
- **Severity debates mid-incident.** Publish definitions before the incident; declare higher when unsure.
- **Handoff by hallway conversation.** Next shift inherits chaos.

---

## 9) Postmortem & Action Item Tracking

**Purpose.** Convert incidents into learning for the whole organisation without punishing responders — and track that learning to action so the same failure does not recur.

**RACI.** R: incident owner (first-responder or IC). A: service tech lead. C: responders, product, security (for security incidents). I: all engineering.

**Triggers.** Any incident at SEV3 or above, regardless of resolution speed. Some organisations postmortem SEV4s too; minimum is SEV1–SEV3.

**Inputs.**
- Incident document + channel transcript.
- Timeline (scribe notes + automated timestamps).
- Dashboards (deploy markers, SLO burn, Four Golden Signals during the window).
- Impact data (users affected, revenue, budget spent).
- Runbooks that were (or were not) consulted.

**Activities.**
1. Within 24 hours: the first-responder (or IC) drafts the postmortem from the template below. No later than one week to final publication.
2. **Frame blamelessly**: factors, not faults. Quote the SRE book and Allspaw's work as needed — "you cannot fix people, you can fix systems and processes to better support people making the right choices."
3. Fill in the sections:
   - Summary — 2 sentences; anyone at the company can understand.
   - Impact — users affected, revenue, SLO budget spent, duration.
   - Timeline (UTC) — timestamps + actors (role names).
   - Root cause & contributing factors — plural; 5 Whys or equivalent; call them **contributing factors**, not "the root cause."
   - What went well — credit the responders.
   - What went wrong — process / tool / knowledge gaps.
   - Where we got lucky — near-misses.
   - Action items — each with owner, type (detect / prevent / mitigate), due date, ticket.
   - Lessons — what should change going forward.
4. Review the draft in a cross-team **incident review forum** (weekly or biweekly). Invite junior engineers — best onboarding material available.
5. Publish to an all-company location (wiki, repo). Secrecy breeds blame; openness breeds learning.
6. File action items as tickets in the tracker immediately. Each with:
   - Verifiable end state ("add alert on `X.p99 > 500ms`" — not "improve monitoring").
   - Owner.
   - Due date.
   - Type (detect / prevent / mitigate).
7. Review the **action-items aging list monthly**. Actions open 60+ days escalate; postmortems-as-theatre show up here.

**Outputs.**
- Published postmortem document.
- Action-item tickets in the tracker with owners and dates.
- Incident-review forum attendance and notes.
- Updated runbooks / alerts / tests / dashboards per action items.

**Tools / templates.**
- Postmortem template (see `07-run.md` for the canonical version).
- Incident-review forum on the calendar.
- Action-item aging report (weekly or monthly; visible to leadership).

**Cadence / duration.** Draft within 24 hours; final within 1 week. Incident-review forum: 30–60 minutes weekly or biweekly. Action-item review: 30 minutes monthly.

**Exit gate.**
- Postmortem published within one week.
- Action items filed with owners and due dates.
- Reviewed in the cross-team forum.
- Aging action items older than 60 days escalated.

**Pitfalls.**
- **Blame framed as "accountability."** Punishing the button-presser teaches the team to hide problems.
- **"The root cause was X."** Single-cause narrative hides the systemic contributors.
- **Action items without verifiable end states.** "Improve monitoring" is decoration.
- **Aging action items.** If they sit open for months, you're doing theatre.
- **Private postmortems.** Locks the learning inside one team.
- **No junior attendees in reviews.** Best onboarding tool, wasted.
- **Skipping postmortem because "it was small."** Small incidents are the practice runs for big ones.

---

## 10) Capacity Planning & Load Testing

**Purpose.** Know the service's ceiling before traffic finds it — so launches, campaigns, and organic growth don't discover overload behaviour in production.

**RACI.** R: service tech lead + platform. A: service tech lead. C: product (for launches), on-call. I: team.

**Triggers.**
- Known demand event approaching (launch, marketing campaign, integration, seasonal peak).
- Organic growth pushing steady-state saturation above 60–70%.
- Quarterly capacity review.
- Error-budget burn from saturation-related causes.

**Inputs.**
- Current traffic baseline (QPS, active users, p99 latency at baseline).
- Historical peaks + growth trend.
- Event-specific forecast (marketing's estimate × realistic multiplier).
- Autoscaling configuration.
- Google SRE's warning: launches can exceed initial estimates by up to 15×.

**Activities.**
1. Estimate the target load:
   - Steady-state forecast from trend.
   - Peak forecast for known events (with a 3–5× safety multiplier if the event is novel).
   - Absolute worst-case for critical services (10–15× per Google's launch guidance).
2. Run load tests against a production-like environment:
   - **Smoke** — short, minimum load; does the rig work?
   - **Average** — steady-state, hold; measure cost per request.
   - **Stress** — ramp until breakage; find the ceiling.
   - **Soak** — extended duration at expected peak; find leaks.
   - **Spike** — sudden rise to peak; test autoscaling responsiveness.
   - **Breakpoint** — find the cliff.
3. Configure autoscaling with a buffer; don't rely on scale-up to catch a 10× spike in 60 seconds. Pre-warm for known events.
4. Plan **N+1 minimum redundancy** (three replicated deployments → maintain four). N+2 for critical systems.
5. Tie the capacity plan to error-budget signals: if budget burn comes from saturation, the service is under-provisioned, not just unlucky.
6. Document the plan: baseline, forecast, pre-scale plan, rollback plan if pre-scale over-provisions.

**Outputs.**
- Capacity forecast per service.
- Load test scripts checked in.
- Load test results report (breakpoint, average cost, leak findings).
- Pre-scale runbook entries for known events.

**Tools / templates.**
- k6, Locust, Gatling, JMeter, Azure Load Testing, AWS Distributed Load Testing, Grafana k6 Cloud.
- Autoscaling config as code (HPA, Cluster Autoscaler, Karpenter, cloud-native autoscalers).
- A capacity plan template per service.

**Cadence / duration.** Pre-launch: days ahead for major events. Steady state: quarterly review + load test.

**Exit gate.**
- Capacity forecast documented.
- Load tests recent (quarter) and green against forecast.
- Pre-scale plans in runbooks for upcoming events.
- Autoscaling config as code.

**Pitfalls.**
- **Trusting autoscaling for spikes.** 60-second 10× ramp outruns most scalers.
- **Load testing on an under-sized rig.** Results not transferable.
- **Only average + stress tests.** Misses soak leaks and spike behaviour.
- **Forecast = last year × 1.2.** Product launches break the trend line.
- **No N+1.** One AZ / replica outage is an incident.
- **Capacity plan disconnected from error budget.** Burn signals ignored.

---

## 11) Disaster Recovery / Backup Drill

**Purpose.** Prove, with data, that we can restore service within RTO and data loss within RPO — because an untested backup is not a backup, and the first real restore should never be during a disaster.

**RACI.** R: platform / SRE. A: platform lead. C: security, data team, compliance. I: leadership.

**Triggers.**
- Quarterly DR cadence.
- RPO / RTO targets change (new customer commitment, new regulatory regime).
- Major architectural change affecting the restore procedure.
- Actual incident that used the DR path (turns into a real drill).

**Inputs.**
- RTO (Recovery Time Objective) and RPO (Recovery Point Objective) targets per service / data store.
- Backup mechanism (snapshot, continuous replication, point-in-time recovery).
- Restore runbook.
- Clean target environment for the drill.

**Activities.**
1. Set RTO/RPO per service / data store explicitly. Example: RTO 1 hour, RPO 5 minutes. Record in the service README.
2. Verify the backup mechanism matches RPO (continuous replication for RPO seconds; frequent snapshots for RPO minutes; daily for RPO hours).
3. Run a **restore drill at least quarterly**:
   - Restore to a clean, isolated environment.
   - Verify data integrity (row count, checksums, representative sample queries, schema version).
   - Measure time from "start restore" to "service answering requests" against RTO.
   - Record the gap; adjust backup frequency or restore procedure if RTO missed.
4. Document the restore as a runbook (process 6). The first real restore must not be during a disaster.
5. Multi-region only if the business case justifies it. Most early-stage SaaS needs multi-AZ, not multi-region.
6. Record drill results; file action items for gaps (e.g., "restore exceeded RTO by 40 minutes due to slow snapshot mount → switch to pre-attached volumes").

**Outputs.**
- DR drill report per service per quarter.
- Restore runbook updated.
- Backup frequency / retention validated against RPO.
- Action items from gaps.

**Tools / templates.**
- Cloud-native backup (AWS Backup, GCP Backup & DR, Azure Backup).
- Database-native (Postgres base backups + WAL, MySQL binlogs, managed DB point-in-time recovery).
- Chaos / game-day tooling to force failover.
- A DR drill report template.

**Cadence / duration.** Quarterly minimum; annually end-to-end including full region failover if multi-region.

**Exit gate.**
- Last drill succeeded within RTO / RPO.
- Drill report filed.
- Restore runbook current.
- Action items from gaps closed.

**Pitfalls.**
- **"We have backups" (never tested).** A backup you cannot restore is not a backup.
- **Drill on the same environment as prod.** Not a drill; an incident waiting.
- **RPO aspiration, backup cadence reality mismatch.** RPO 5 min + daily snapshot = false commitment.
- **Multi-region build without multi-region practice.** Second region silently bit-rots.
- **Restore runbook stored in the system being restored.** Circular dependency revealed at 3 a.m.
- **Drill passes because the drill ran the restore procedure, which was updated while nobody was looking.** Use pre-existing runbooks, not ad-hoc fixes during the drill.

---

## 12) Security Operations (Detect / Respond / Patch)

**Purpose.** Run the security loop as a continuous operational practice with the same shape as reliability operations — so breaches are caught, contained, and learned from rather than discovered quarters later.

**RACI.** R: security lead (or eng lead at small scale). A: security lead. C: platform, on-call, compliance. I: leadership.

**Triggers.**
- New CVE published affecting the stack.
- Anomaly in authentication / data-access logs.
- Vendor / dependency compromise disclosed.
- Lost device reported.
- Suspected or confirmed account takeover.
- Quarterly security review.

**Inputs.**
- NIST Cybersecurity Framework 2.0: six functions (Govern / Identify / Protect / Detect / Respond / Recover).
- OWASP Top 10:2025 (A03 Supply Chain Failures, A09 Logging & Alerting Failures, A06 Vulnerable & Outdated Components).
- Dependency manifest and SBOM (Phase 06 process 2).
- Observability stack — same logs, dashboards, alerts used for reliability.
- Patching SLAs (e.g., critical within 7 days, high within 30).

**Activities.**
1. **Detect.**
   - Runtime security logs flowing into the same backend as reliability logs.
   - Alert rules for anomalous patterns: auth failures above threshold, access to sensitive tables by unexpected identities, unusual data egress, privilege escalation.
   - SIEM at scale; at small scale, tagged queries on the main log backend + PR-based rules.
2. **Respond.**
   - Treat security events with the same ICS framework as reliability (process 8): IC, Ops Lead, Comms Lead, Scribe.
   - Per-incident-type runbooks for the top scenarios: credential leak, suspicious data access, dependency compromise, lost device, account takeover. Each runbook: who to call (internal counsel, cloud security contact), how to rotate, how to revoke, how to notify (customers, regulators under GDPR 72-hour breach notice).
3. **Patch.**
   - Track CVEs against the dependency manifest continuously (Dependabot, Renovate, Snyk, GitHub Advanced Security).
   - Route by severity per the patching SLA.
   - Ship through the normal pipeline — no skipping canary for a patch.
4. **Supply chain.**
   - Pin dependencies by digest / lockfile.
   - Verify signatures (cosign, sigstore, package-registry signatures).
   - Maintain SBOM (process from Phase 06); re-generate on every build.
5. **Govern / Identify.**
   - Map each CSF function to team ownership. Even 5-person orgs can do a crude map (engineering owns Detect/Respond/Recover; founders own Govern/Identify).
   - Annual (minimum) review of the map and the risk register.
6. **Quarterly review.**
   - Open CVEs past SLA.
   - Recent security incidents + postmortems.
   - Supply-chain controls updated (new scanners, SBOM formats, signing identities).

**Outputs.**
- Patching SLA dashboard (open CVEs by severity, age, owner).
- Security runbooks per top incident type.
- CSF 2.0 ownership map published.
- Security incident postmortems (same process as reliability).
- Quarterly review notes.

**Tools / templates.**
- Dependabot / Renovate / Snyk / GitHub Advanced Security / JFrog Xray.
- SIEM (Splunk / Datadog Security / Elastic Security / Panther) at scale; tagged queries at small scale.
- Cosign / Sigstore for signature verification.
- Secrets scanning (trufflehog, gitleaks, GitHub secret scanning).
- An incident-type runbook template.

**Cadence / duration.** Continuous (patching on SLA); daily (log monitoring); quarterly review: 2–3 hours.

**Exit gate.**
- No CVE open past its SLA for more than one cycle.
- Security runbooks exist for top 5 incident types and have been tested within the last year.
- CSF 2.0 ownership map current.
- Recent security events handled under ICS with postmortems.

**Pitfalls.**
- **Security as a separate incident process.** Needlessly duplicates ICS; use one process.
- **Patching without canary.** Security "fix" breaks prod; incident compounds.
- **Logs with the exact data you would need to investigate but would also cause a breach if exposed.** Process 4 exists for this.
- **SBOM generated, never consulted.** Useless unless queried when a CVE drops.
- **"We're too small for CSF."** Crude mapping beats no mapping.
- **72-hour GDPR notification missed.** Jurisdiction-specific; know yours.

---

## 13) FinOps / Cost Review

**Purpose.** Make engineering accountable for cost in the same way it is accountable for reliability — so cloud bills don't silently compound and right-sizing is part of the normal work.

**RACI.** R: platform eng (data); finance (review). A: engineering + finance co-accountable. C: service tech leads. I: leadership.

**Triggers.**
- Monthly cost cycle.
- Cost spike alert (daily dashboard).
- New service reaches production.
- Commitment-plan / reserved-capacity renewal.

**Inputs.**
- Cloud provider cost & usage export.
- Tagging policy (service, team, environment, cost centre).
- Baseline steady-state usage and trend.
- Commitment / savings plan terms.

**Activities.**
1. **Tag every cloud resource** with service, team, environment, cost centre. Untagged resources become orphans.
2. Stand up a **daily cost dashboard** per service with spike alerts on anomalies (e.g., > 20% day-over-day or > 50% versus 7-day moving average).
3. Monthly review:
   - Top 10 resources by cost. Each owner asked: still needed? right-sized? can it be moved to a savings plan?
   - Unattached / orphaned resources (no tag) identified and either tagged or deleted.
   - Non-prod environments (preview, staging) scanned for runaway cost.
4. Right-size before scaling out — tuning existing capacity is cheaper than doubling.
5. Reserved capacity / savings plans once usage is predictable (roughly 30%+ steady baseline).
6. Tie cost to SLO where possible. "This service costs $X / month to hold 99.9%; holding 99.99% would cost $Y." Cost is a reliability-tier lever.
7. Quarterly commitment review: refresh reserved / committed-use plans.

**Outputs.**
- Cost tagging compliance report.
- Monthly cost review deck (top spenders, right-sizing decisions).
- Savings-plan portfolio status.
- Spike-alert rules.

**Tools / templates.**
- Cloud-native (AWS Cost Explorer + Budgets, GCP Billing reports, Azure Cost Management).
- Third-party (CloudHealth, Apptio Cloudability, Vantage, InfraCost, OpenCost for Kubernetes).
- A tagging-policy enforcement (AWS Config rules, GCP org policy, Terraform lint).

**Cadence / duration.** Daily dashboard monitoring (automated). Monthly review: 60 minutes. Quarterly commitment review: 2 hours.

**Exit gate.**
- Tagging compliance > 95% of resources.
- Daily dashboard visible to engineering.
- Monthly review happened; top-spender questions answered.
- No runaway non-prod spend.

**Pitfalls.**
- **Finance owns cost alone.** Engineers have no incentive to right-size.
- **Untagged resources.** Nobody owns them; nobody turns them off.
- **Reserved capacity bought prematurely.** Commitment exceeds usage → waste.
- **Cost dashboard only at month end.** Spike detected long after the bill is finalised.
- **Engineers optimising pennies while architectural decisions burn thousands.** Focus top-down.
- **Right-sizing behind SLOs.** Saving cost by eating into reliability budget; wrong trade, invisible.

---

## 14) Game Day / Chaos Experiment

**Purpose.** Confirm, with evidence under realistic conditions, that runbooks work, alerts fire, and responders can find what they need — by breaking things on purpose in a bounded way.

**RACI.** R: platform / SRE. A: platform lead. C: service tech lead, on-call, IC. I: leadership.

**Triggers.**
- Quarterly cadence (minimum).
- New critical dependency added.
- Major architectural change.
- Recent incident revealed a preparedness gap.
- Pre-launch readiness for a high-stakes release.

**Inputs.**
- Hypothesis — "steady state holds even when X fails."
- Realistic failure mode to inject (host failure, dependency timeout, network partition, region impairment, traffic spike).
- Bounded blast radius plan.
- Runbooks (process 6).
- Dashboards (process 3).
- Incident response readiness (process 8).

**Activities.**
1. Write the **hypothesis** around steady-state behaviour: "During a 30% latency increase on dependency X, checkout success rate stays above 99%."
2. Pick the failure to inject. Start with game days (scheduled, announced, off-peak, test or off-peak environment) before automated production chaos.
3. Define and **minimise the blast radius**: scope to one region / one service / a small user cohort.
4. Pre-brief participants: rules of engagement, abort signal, who has the kill switch.
5. Run the exercise:
   - Inject the failure.
   - Let the team detect, declare, respond, mitigate using real alerts and runbooks.
   - Scribe documents the timeline.
   - Kill-switch operator halts if blast radius exceeds plan.
6. Debrief within 24 hours. Same structure as a postmortem (process 9): what worked, what didn't, where we got lucky, action items.
7. File action items into the same tracker as real-incident action items.
8. Graduate from game days to automated chaos (continuous experiments, production-sampled, automated) once the exercise becomes routine and findings dry up.

**Outputs.**
- Game day hypothesis + plan.
- Run log (injection time, detection time, mitigation time, recovery time).
- Debrief document.
- Action items filed.

**Tools / templates.**
- Chaos Mesh, Litmus, AWS Fault Injection Simulator, Gremlin, Chaos Toolkit.
- Feature-flag / traffic-routing tooling for blast-radius control.
- A game-day plan template (hypothesis, abort criteria, communication plan, blast radius).

**Cadence / duration.** Quarterly minimum game day: 2–4 hours including debrief. Automated chaos (at scale): continuous.

**Exit gate.**
- Hypothesis tested.
- Steady state either held (confirmation) or broke in a documented way (action items).
- Debrief done and action items filed.
- Abort worked correctly (demonstrated, not assumed).

**Pitfalls.**
- **Game day as demo.** Scripted, no real surprise. Learning is low.
- **Blast radius too large.** Game day becomes an incident.
- **No abort plan.** No kill switch means no safe stop.
- **Only injecting technical failures.** Human failure modes (pager missed, runbook missing, comms unclear) often matter more; design injections to probe them.
- **Running chaos in production before you have game days in staging.** Skipping the crawl-walk sequence.
- **Findings not actioned.** Theatre; same gaps next quarter.

---

## 15) Continuous Feedback to Phases 02 / 08

**Purpose.** Keep operational reality visible to the people planning next quarter and evolving the product — so reliability work, tech debt, and systemic gaps get capacity allocated to them rather than being perpetually outranked.

**RACI.** R: service tech lead + product. A: product (for prioritisation). C: engineering manager, platform, IC pool. I: leadership.

**Triggers.**
- Each incident (per postmortem).
- Weekly sync reviewing open operational issues.
- Error-budget burn threshold hit.
- Sprint / iteration planning.
- Quarterly roadmap refresh.

**Inputs.**
- Postmortem action items (process 9).
- Open runbook / alert / dashboard gaps.
- SLO burn trends.
- DORA delivery metrics (from Phase 06 process 12).
- Tech debt register (maintained in Phase 08).
- Customer-facing incident themes and support tickets.

**Activities.**
1. Per incident: postmortem action items feed directly into the next iteration's backlog (Phase 02 process 5 — Backlog Prioritization).
2. Weekly: service tech lead reviews open operational work — runbook gaps, alert-tuning needs, SLO-miss investigations. Surfaces any that need capacity in the upcoming sprint.
3. Error-budget burn tripping the freeze clause → feature work halts on the affected service per process 1's error-budget policy. Trigger Phase 02 replan.
4. Monthly: platform / SRE publishes a **health-of-operations** report: SLO status per service, incident count per severity, action-item aging, alert noise, cost trend. Read in roadmap syncs with product.
5. Quarterly: systemic themes from postmortems roll into the tech-debt quadrant exercise (Phase 08) and the roadmap update (Phase 02).
6. Customer-reported incident patterns inform product discovery (Phase 01) — e.g., if 30% of incidents trace to a fragile integration, it is a product-level concern, not just an engineering one.

**Outputs.**
- Weekly operational-work review notes.
- Monthly operations health report to leadership / product.
- Action items flowing into the backlog.
- Tech-debt register entries from systemic findings.
- Updated roadmap reflecting reliability investment.

**Tools / templates.**
- Incident-to-backlog linking convention (every action-item ticket references incident ID).
- A monthly operations-health report template.
- The tech-debt register (Phase 08 process 5 — Tech Debt Logging & Quadrant Classification).

**Cadence / duration.** Weekly: 30 minutes. Monthly report: 1 hour. Quarterly: 2–3 hours.

**Exit gate.**
- Action items visible in the planning backlog.
- Monthly report delivered; product and eng leadership read it.
- Error-budget policy observed when triggered.
- Systemic findings roll into the tech-debt register.

**Pitfalls.**
- **Action items in a separate tracker product never sees.** Permanent backlog island.
- **Operations report read only by SRE.** Product allocates zero capacity; debt compounds.
- **Error-budget policy ignored when inconvenient.** One exception becomes the rule; the policy dies.
- **Customer-impact patterns treated as engineering trivia.** Product disengages; incident themes recur.
- **Monthly report read, no decisions made.** Report needs to prompt a decision, not narrate status.

---

## Weekly operational rhythm

Phase 07 is continuous and mostly quiet when healthy. A representative "normal week":

| Day | Cadence |
|---|---|
| Mon (fixed time) | On-call handoff (process 7). Outgoing → incoming walkthrough: open incidents, hot spots, recent changes. |
| Tue–Thu | Pages / incidents as they arrive — response via ICS (process 8). SLO dashboards reviewed during stand-up. |
| Wed or Thu | Incident review forum (process 9): recent postmortems, action-item aging list read. |
| Fri | Operational-work review (process 15): runbook gaps, alert-tuning needs feeding into next sprint. |
| Continuous | Automated: CI patching PRs (Dependabot / Renovate), cost dashboard, alert health metrics. |

Monthly: operations health report; cost review; tagging audit.
Quarterly: SLO review; DR drill; game day; runbook test sweep; on-call rotation review; security review.

Anti-pattern symptoms that indicate this rhythm is broken:

- On-call handoff happens over ad-hoc chat; new on-call finds open incident the hard way.
- SLO burn reviewed only when an incident forces the question.
- Action items accumulate on the aging list without escalation.
- "We're too busy for the quarterly game day." (Translation: you are accumulating latent failure.)

---

## Scale notes

These are the same scale tiers used across the handbook.

**Solo founder / 1 engineer.**
- One Slack channel for alerts; Uptime Robot + Sentry; PagerDuty free tier.
- SLOs informal (target: last-30-day success rate; eyeball it weekly).
- Self-designated IC. Postmortems written for yourself — still write them.
- Game day once a quarter against the most critical dependency (typically your database / auth provider).
- Cost reviewed monthly in the bookkeeping session.

**Team of 5 (default).**
- Full rotation with follow-the-sun if not colocated; otherwise primary + secondary at one site.
- OpenTelemetry from day one; dashboards per service; Four Golden Signals mandatory.
- SLOs on the top 3 user-facing services; burn-rate alerts wired up.
- PagerDuty / Opsgenie / Incident.io.
- Runbooks for every alert; tested quarterly.
- Monthly incident review forum.
- Backups tested quarterly.
- Cost dashboard per service; monthly finance review.

**Team of 20–50.**
- Tiered on-call (L1 triage, L2 domain experts).
- Dedicated platform team owns observability stack, paging routes, SLO tooling.
- Error-budget policy enforced (freezes happen).
- IC rotation with formal role definitions; Comms Lead and Scribe routine at SEV1/2.
- Runbook automation and self-service tools.
- Security ops distinct from reliability ops (shared framework, distinct routing).
- Chaos engineering program with scheduled game days and first automated experiments.

**Team of 500+.**
- SRE as a function, embedded per stream or per platform domain.
- Error budgets drive planning at the quarterly level across the portfolio.
- Full ICS roles at SEV1 (IC, Ops Lead, Customer Liaison, Internal Liaison, Scribe, Deputy).
- Dedicated SOC for security.
- FinOps team with cross-functional governance.
- Continuous chaos experiments running in production with automated safeguards.
- Internal Developer Platform with self-service paths for observability, alerts, runbooks, and operational tooling.

Principle across tiers: the loop (detect → respond → recover → learn) is invariant. Ceremony and tooling scale with blast radius, not the loop itself.

---

## Handoff to Phase 08 and back to Phase 02

Phase 07 is the permanent feedback source for the rest of the lifecycle. What it hands off:

1. **SLO reality.** What is the service actually holding at? This is the input to the "can we promise X?" question in Phase 02 planning.
2. **Incident themes.** The top 3–5 recurring contributing factors across the last quarter's postmortems — input to the Phase 08 tech debt register and the Phase 02 roadmap.
3. **Error-budget status per service.** The signal that may freeze feature work or unlock a risk taken.
4. **Operational cost per service.** Input to pricing, product prioritisation, and architectural investment.
5. **Customer-visible incident history.** Input to product discovery (Phase 01) and product comms (Phase 06 / ongoing).
6. **Health of operations (dashboards, alert quality, on-call load).** Input to the platform team's own roadmap.
7. **Runbook / dashboard / instrumentation gaps** not yet addressed — the operational debt ledger.
8. **Security posture.** Open CVEs, recent security postmortems, CSF function maturity.

That package is what Phase 02 (next-quarter planning) and Phase 08 (evolve) consume. Phase 07 does not "exit"; it feeds.
