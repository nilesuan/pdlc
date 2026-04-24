# Phase 07 — Run

**Goal:** Keep the product reliably available for customers — know when it breaks, fix it fast, learn from it, and build a system that improves with every incident.

**Duration:** Continuous, 24/7.

**You are done when:** You're not. But: you have SLOs, observability, on-call, and incident response working — and they catch issues before customers do more often than not.

---

## What this phase is about

Operations is not "someone else's job" after the code ships. Every team that ships code runs it. Even if you eventually split SRE from product engineering, the product engineers remain accountable for their service's reliability.

Mindset: **reliability is a feature**. Users who experience outages don't care about feature velocity. And yet — as Google's SRE book argues — "100% is probably never the right reliability target: not only is it impossible to achieve, it's typically more reliability than a service's users want or notice." The job of this phase is to decide how reliable you need to be, measure it honestly, and build the muscle to respond when you fall short.

The shape of the work is a loop: **detect → respond → recover → learn**. That loop is the same for availability incidents, latency incidents, and security incidents. It is the same whether you are a two-person team with Sentry and a Slack channel or a 500-person organisation with a dedicated SRE function. What changes with scale is the tooling and the ceremony, not the loop.

## Who does what

- **Product engineer:** owns reliability of their service. They instrument it, they are paged for it, they write the postmortem when it breaks.
- **On-call rotation:** everyone on the team who can meaningfully respond. No permanent heroes.
- **Incident commander (IC):** chosen per-incident, not a permanent role. Rotates. Coordinates, does not fix.
- **(Later) SRE / platform team:** builds the tooling — dashboards, runbook generators, chaos frameworks — that makes operating easy. Not a janitorial service for dev teams; a product team whose customer is the stream-aligned engineer.

One principle from the outset: **you build it, you run it**. If you cannot operate what you ship, you cannot ship it.

## Inputs

- A running production system from Phase 06 (live, deployable, instrumented with at least error tracking).
- A team willing to share the pager.
- Leadership that treats reliability as a product concern, not an operations tax.

---

## Service Level Objectives (SLOs)

### The core idea

SRE draws precise distinctions. Treat these as non-negotiable vocabulary:

- **SLI (Service Level Indicator):** what you measure. "A carefully defined quantitative measure of some aspect of the level of service that is provided." Examples: percentage of requests that complete in under 500 ms, percentage of requests that return 2xx/3xx, percentage of successful background-job executions.
- **SLO (Service Level Objective):** the target for the SLI. "A target value or range of values for a service level that is measured by an SLI." Example: `99.9% of API requests complete in under 500 ms, measured over a rolling 28 days`.
- **SLA (Service Level Agreement):** a contractual promise to customers with consequences for missing it. The SRE book's diagnostic: "ask 'what happens if the SLOs aren't met?': if there is no explicit consequence, then you are almost certainly looking at an SLO."

A useful nesting: the SLI is what you measure, the SLO is the promise you make to yourself, the SLA is the promise (with money attached) you make to a customer. Your SLO should always be stricter than your SLA so you have margin before you owe anyone a refund.

### How to pick good SLOs

- **Start from user-facing behavior.** Availability, latency, correctness, freshness — not CPU, not memory, not queue depth. Those are causes; your SLOs measure symptoms.
- **2–5 SLOs per service.** Not one per component, not thirty. You want a dashboard a human can read.
- **99.9% ("three nines") is a reasonable starting point** for most SaaS. That is 43 minutes of permitted downtime per month, about 8 hours and 45 minutes per year. 99.99% ("four nines") is 4.3 minutes per month — achievable but expensive and rarely what users actually need.
- **Measure over a rolling window**, typically 28 or 30 days. Calendar months skew because lengths differ; a rolling window gives you a continuously comparable number.

Example SLO set for a typical SaaS API service:

1. **Availability:** 99.9% of successful requests per 28-day rolling window (SLI: `count(2xx or 3xx) / count(all) ≥ 0.999`).
2. **Latency:** 99% of successful requests complete in under 500 ms at the p99.
3. **Correctness:** 99.95% of background jobs complete without retry exhaustion.
4. **Freshness (if applicable):** 99% of analytics events appear in dashboards within 5 minutes.

### Error budgets

The error budget is the complement of your SLO. If your SLO is 99.9% over 28 days, your budget is 0.1% of 28 days — 40 minutes and 19 seconds of permitted failure per window. The SRE book frames the budget as the arbiter of the eternal tension between product velocity (ship features) and reliability (don't break things):

- **Budget intact:** ship aggressively. Launch the risky experiment. Deploy on a Friday.
- **Budget half-spent:** normal caution.
- **Budget exhausted:** freeze feature work until you pay it back. Only reliability work, bug fixes, and rollbacks.

The budget becomes "a common incentive that allows both product development and SRE to focus on finding the right balance between innovation and reliability." Make this a **real team practice**, not a theoretical metric printed on a slide. If the budget never halts features, you have decoration, not a policy.

### Setting up your first SLO

1. **Pick the most user-impactful metric.** For 95% of web products, that is "percentage of successful requests over the last 28 days." Start there.
2. **Baseline it.** What does current behavior look like over the last 28 days? If you are at 99.93%, do not set an SLO of 99.99% and declare yourself in violation.
3. **Set the SLO slightly stricter than current reality.** Create gentle pressure, not immediate failure. 99.9% is a good default if you are currently around 99.93–99.97%.
4. **Instrument it.** You need the SLI emitted from production. See Observability, below.
5. **Track weekly.** Put the current budget burn on the team's status review. Review the trend, not just the absolute number.

**Anti-pattern:** SLOs set aspirationally ("we want four nines!") and never measured. Pick a number you can defend from the data, measure it, and tighten it quarterly.

---

## Observability

Observability is "the power to ask new questions of your system, without having to ship new code or gather new data" (Charity Majors). Contrast with monitoring, which is the narrower practice of watching known signals and firing known alerts. You need both.

### The three pillars (and a caveat)

OpenTelemetry describes three signal types:

- **Logs** — timestamped messages. Structured, JSON, correlated to requests and users.
- **Metrics** — numeric aggregates over time. Request rates, error rates, latency percentiles, resource utilisation.
- **Traces** — the end-to-end path of a single request as it crosses services, composed of spans.

Caveat: the "three pillars" framing is **contested**. Practitioners like Charity Majors argue it encourages siloed stacks — a logs tool, a metrics tool, a tracing tool — instead of one coherent event stream you can slice arbitrarily. Treat the three pillars as a useful taxonomy for what you emit, not as three separate products you must buy. Modern backends (Honeycomb, Datadog, Grafana's LGTM stack) aim to unify them.

### What to instrument

At a minimum, emit structured telemetry from:

- **Every HTTP handler:** duration, status code, route, user/tenant ID, request ID, version.
- **Every external call:** destination, duration, status, error type, retry count.
- **Every background job / queue consumer:** duration, outcome, retry count, queue lag.
- **Key business events:** signups, purchases, activations, cancellations. Emit these as events with rich attributes, not as counts.
- **Deploys:** annotate your dashboards with deploy markers so you can see correlation.

### Recommended stack

- **OpenTelemetry (OTel) as the instrumentation SDK.** Vendor-neutral, CNCF-governed, industry standard. Emit via OTLP.
- **Backend — pick one, not six.** Small team: Datadog, Honeycomb, New Relic, or Grafana Cloud. Self-hosted if you have the operational capacity: Prometheus (metrics) + Loki (logs) + Tempo (traces) + Grafana (visualisation).
- **Error tracking: Sentry.** Separate from your general telemetry, specialised for stack traces, release correlation, and source-map handling.

**Recommend OpenTelemetry unconditionally.** It decouples instrumentation from backend. If your backend fails or gets expensive, you change the export target, not the instrumentation in your code. This is the single highest-leverage observability decision you will make.

### Four Golden Signals

From Google's Monitoring Distributed Systems chapter, the four metrics every user-facing service must display:

1. **Latency** — time to service a request. Track successful and failed separately.
2. **Traffic** — demand on the system (requests per second, active users, whatever best measures user demand).
3. **Errors** — rate of explicit failures (5xx), implicit failures (wrong content on 200), and policy failures.
4. **Saturation** — how full the service is. Queue depth, thread-pool use, memory headroom.

These belong on the top row of every service dashboard. If a responder cannot answer "is it broken, and is it getting worse?" from the first four tiles, the dashboard is wrong.

### RED vs USE

Two complementary methods, each from a named practitioner:

- **RED (Tom Wilkie, Grafana Labs):** Rate, Errors, Duration. For services that take requests. "How are your users doing?"
- **USE (Brendan Gregg):** Utilisation, Saturation, Errors. For resources (CPUs, disks, network, thread pools). "How are your machines doing?"

Wilkie's own framing: "It's like the RED Method is about caring about your users and how happy they are, and the USE Method is about caring about your machines and how happy they are." RED plus Saturation equals the Four Golden Signals. Use RED for service dashboards, USE for capacity investigations.

### Dashboards

- **One dashboard per service.** Four Golden Signals on the top row. SLO burn rate prominent.
- **Separate business metrics dashboard.** Signups, activations, revenue, feature adoption. Overlays help correlate outages with revenue impact.
- **Automate.** Dashboards as code (Terraform, Grafonnet, Datadog's dashboard JSON). Hand-maintained dashboards drift and go stale.
- **Keep them boring.** Widgets responders can interpret in two seconds. No exotic visualisations.

### Logs

- **Structured (JSON), never plain text.** Every log line is a queryable event.
- **Include on every line:** timestamp, request ID, user ID (or tenant ID), service name, environment, version, severity.
- **Never log:** passwords, auth tokens, API keys, session cookies, raw payment details, or raw PII. Hashed identifiers are acceptable; raw personal data is not. This ties directly to OWASP Top 10:2025 A09 (Security Logging & Alerting Failures) — you want enough detail to investigate, not enough to leak.
- **Retention policy that matches compliance.** 30 days for warm, 1 year for cold, regulated data per its regime. Longer retention costs money; shorter retention forecloses investigation.

### Alerting

From Google's Practical Alerting chapter, non-negotiable rules:

- **Alert on SLO burn rate, not on every anomaly.** Multi-window, multi-burn-rate alerting from the SRE Workbook is the gold standard: page when you are about to exhaust one month's budget in one hour, or one day's budget in six hours. This catches real customer impact and filters noise.
- **Every page must be actionable.** Google's framing: "Every page should be actionable." If there's nothing a human needs to do within the next hour, it is not a page. It is a ticket, or a dashboard panel, or a metric.
- **Separate queues:** page for critical; email/Slack for subcritical; ticket for "someone should look at this next week."
- **Do not page on single-machine failures at scale.** "Being alerted for single-machine failures is unacceptable because such data is too noisy to be actionable." Aggregate, then alert.
- **Require duration thresholds.** At least two evaluation cycles before firing, to prevent flapping.
- **Every alert has a runbook link.** No exceptions.

**Anti-pattern:** alerting on every anomaly. Alert fatigue is the single most common on-call failure mode. If the team ignores pages, you have a symptom of bad alerts, not bad engineers.

---

## On-call

### Rotation design

Rules of thumb, drawn from Google's SRE Workbook and PagerDuty's incident response guide:

- **Team of 5+ on one site:** everyone on the rotation; one-week shifts. Google's guidance: "a bare minimum of eight people in a single-site, 24/7 configuration." Below that, consider follow-the-sun or a reduced-hours rotation.
- **Primary + secondary:** the secondary picks up if primary misses an acknowledgement.
- **Handoff at the same time each week**, e.g. Monday 10:00 local. Include a live handoff meeting covering open incidents, ongoing issues, recent changes.
- **Never someone's first week.** New joiners shadow before they carry.
- **Follow-the-sun at 2+ timezones.** Google's approach: "SRE teams at Google are paired across time zones for service continuity." Nobody is on at 3 a.m. on purpose if you can avoid it.
- **Shift length:** Google recommends "limiting shift lengths to 12 hours. Shorter shifts are better for the mental health of your engineers." For a one-week on-call, this translates to splitting primary/secondary windows rather than one person being live for 168 hours.

### What on-call means

From PagerDuty's guide: "you are able to be contacted at any time in order to investigate and fix issues that may arise for the system you are responsible for." The implications:

- **You are responsible, not the only person working.** Escalation "is encouraged, not shameful." Pull in subject-matter experts. Wake people up if you need to. Nobody gets a medal for suffering alone.
- **Acknowledge within your documented response time.** PagerDuty's recommendation: 5 minutes. Set yours to something specific and measure it.
- **Hand over cleanly.** Write up open incidents and hot spots before you hand off.
- **You are not expected to be first to acknowledge every alert.** The person who is available acknowledges.

### On-call health

- **Target fewer than 2 unactionable pages per shift.** Google's SRE Workbook targets "a maximum of two incidents per on-call shift." Above that, you do not have time to follow up on anything. Track the number.
- **If pages exceed threshold for two consecutive shifts, stop feature work** on that service until the root cause is fixed. This is the error-budget policy applied to human-budget spend.
- **Do not run on-call as an endurance test.** Google explicitly targets "at least 50% of their time on project work" for SREs; for product engineers, at least 80%. An on-call week is not meant to destroy a productive week.
- **Compensate.** Google "offers time-off-in-lieu or cash compensation, capped at some proportion of the overall salary." At companies that can afford it, pay for on-call. At companies that cannot, give time-off-in-lieu and limit rotation frequency. Where local law mandates it (EU working-time rules, for example), comply.

### On-call runbook

**Every alert has a runbook.** Format:

```
# Runbook: <alert name>

## What fires this
- The exact condition (SLI, threshold, window)

## What to check first
1. <dashboard link>
2. <recent deploys>
3. <upstream dependencies>

## How to mitigate
- Option A: <safe rollback>
- Option B: <feature flag off>
- Option C: <failover>

## How to escalate
- Page <next tier / domain expert>
- Slack channel: #<incident>
```

Keep runbooks in a versioned repo next to the code. Review them in PRs. Test them at least quarterly by **actually following the runbook during a game day**, not just reading it.

---

## Incident response

The framework is based on the Incident Command System (ICS), imported from emergency services. Google's Managing Incidents chapter names this lineage explicitly: "The framework is based on the Incident Command System, known for its clarity and scalability in emergency response."

### Severity levels

Adopt a tiered severity framework. A common, defensible scheme:

- **SEV1 — major user-facing outage or data loss.** All-hands. Page on-call, page secondary, page engineering leadership. Status page updated. Customer communications within 15 minutes.
- **SEV2 — significant degradation or some users affected.** Page on-call. Status page updated. Internal communications.
- **SEV3 — minor or internal.** Ticket, no page. Handled during business hours.
- **SEV4 — cosmetic or small.** Triage in normal hours. Logged for trend analysis.

Tie severity thresholds to SLO impact, customer impact, and data-integrity impact. Publish the definitions. When in doubt, **declare the higher severity**. Downgrading a SEV1 is easy; upgrading a SEV3 after it has smouldered for an hour is not.

### The process

1. **Detect.** Alert, customer report, monitoring anomaly. Detection time is a metric (MTTD — Mean Time To Detect). Improve it.
2. **Declare.** Create an incident channel (Slack, Teams — a dedicated room per incident, not a repurposed general channel). Assign Incident Commander. Page per severity. Open an incident document.
3. **Triage.** Assess severity. Bring in responders. Update status page. Draft the first customer comm.
4. **Mitigate.** **Restore service first, understand root cause later.** Rollback, failover, feature-flag off, traffic-shift away. The customer does not care about your debugging narrative.
5. **Communicate.** Status page every 15–30 minutes during SEV1/2. Internal Slack updates on a cadence. Stakeholder email on major incidents.
6. **Resolve.** Confirm service restored. Post the all-clear. Downgrade severity. Leave the incident doc open.
7. **Postmortem.** Blameless, documented, with action items. Published within one week.

### Roles during an incident

Adapted from Google and PagerDuty:

- **Incident Commander (IC).** Coordinates, does not fix. Runs the incident. Assigns tasks. Makes the call on severity, escalation, and resolution. IC is explicitly hands-off from keyboard work; if the IC is also trying to debug, the incident has no commander.
- **Operational Lead / Subject-Matter Responder(s).** Technical work. The SRE book: "The operations team should be the only group modifying the system during an incident." No freelance fixes from people outside the response team.
- **Communications Lead.** Status page, customer comms, internal updates. Splits off from the IC at SEV1/2. PagerDuty separates this into **Customer Liaison** (external) and **Internal Liaison** (exec/internal stakeholders) at scale.
- **Scribe.** Maintains the timeline. Can be partially automated via a Slack bot that timestamps key events.
- **Deputy (PagerDuty convention).** Backs up the IC. Takes over on handoff or if the IC rotates out.

### The golden rule

**Mitigate first, understand later.** Do not dig into root cause while customers are bleeding. Roll back the last deploy. Failover to a standby. Turn off the feature flag. Read-only mode if the database is in trouble. The investigation happens after the bleeding stops.

### Handoff

Long incidents outlive shifts. Hand over the IC role explicitly, in writing, in the incident channel:

```
HANDOFF at 22:00 UTC
Outgoing IC: @alice
Incoming IC: @bob
Status: SEV2, mitigated with traffic shift to region B
Open threads: [links]
Next actions: [list]
```

---

## Postmortems

### Blameless

From Google's SRE book: a blameless postmortem "must focus on identifying the contributing causes of the incident without indicting any individual or team for bad or inappropriate behavior."

The philosophy:

> "You can't 'fix' people, but you can fix systems and processes to better support people making the right choices."

And:

> "Removing blame from a postmortem gives people the confidence to escalate issues without fear."

John Allspaw's work at Etsy gave this its popular articulation in the software industry. The argument, drawn from aviation and medicine's Just Culture research: you must investigate "mistakes in a way that focuses on the situational aspects of a failure's mechanism and the decision-making process of individuals proximate to the failure." An engineer "who thinks they're going to be reprimanded" is disincentivized to give the details necessary to learn from the failure.

Leadership must model this. The SRE Workbook: leaders must "consistently exemplify blameless behavior and encourage blamelessness in every aspect of postmortem discussion." If senior management privately asks "whose fault was that?", nothing in the ritual saves the culture.

### What a postmortem contains

- **Summary** — two sentences, readable by anyone at the company.
- **Timeline** — from first detection to resolution, with timestamps and actor names (role names, not finger-pointing).
- **Impact** — users affected, revenue lost, SLO budget spent, duration.
- **Root cause and contributing factors** — the 5 Whys or equivalent, framed as contributing conditions rather than one blameable cause.
- **What went well** — praise the responders. Genuinely.
- **What went wrong** — the process failures, tool failures, knowledge gaps.
- **Where we got lucky** — the near-misses. Captures resilience.
- **Action items** — each with an owner, due date, and issue tracker link.

### Template

Use this as a starting template. Adapt to your tooling.

```markdown
# Postmortem: <title>

- **Incident ID:** INC-YYYY-NNNN
- **Severity:** SEV1/2/3
- **Date:** YYYY-MM-DD
- **Duration:** <minutes>
- **Author(s):** @name
- **Status:** Draft | In Review | Final
- **Published:** YYYY-MM-DD

## Summary
<2-sentence plain-English description; readable by anyone.>

## Impact
- **Users affected:** <count / %>
- **Revenue impact:** <$ or qualitative>
- **SLO budget spent:** <e.g. 40 min of 43 min monthly budget>
- **Duration from first customer impact to full recovery:** <minutes>

## Timeline (UTC)
| Time | Event | Who |
|------|-------|-----|
| HH:MM | Deploy of v1.23.4 | release bot |
| HH:MM | p99 latency breaches 500 ms | monitor |
| HH:MM | Alert fired to primary on-call | pager |
| HH:MM | On-call acks | @alice |
| HH:MM | IC declared | @alice |
| HH:MM | Status page updated | @bob |
| HH:MM | Rollback initiated | @alice |
| HH:MM | Service restored | monitor |
| HH:MM | Incident resolved | @alice |

## Root cause and contributing factors
- **Primary cause:** <what broke>
- **Contributing factors:**
  - <gap in test coverage>
  - <ambiguous runbook>
  - <stale dependency>
- **Why it was not caught earlier:** <detection gap>

## What went well
- <fast detection>
- <clean rollback>
- <good comms>

## What went wrong
- <alert did not page the right team>
- <runbook was out of date>

## Where we got lucky
- <a worse version of this would have caused data loss; we caught it at latency degradation>

## Action items
| # | Item | Owner | Type | Due | Ticket |
|---|------|-------|------|-----|--------|
| 1 | Add integration test for X | @carol | Prevent | 2026-05-15 | ENG-123 |
| 2 | Update runbook for Y | @dave | Mitigate | 2026-05-01 | ENG-124 |
| 3 | Improve alert for Z | @eve | Detect | 2026-05-08 | ENG-125 |

## Lessons
<1–3 paragraphs. What did we learn that should change how we operate?>
```

### Action items

- **Treat them like features** — assigned, sized, reviewed at sprint planning, tracked to completion.
- **Each action item has a verifiable end state.** "Improve monitoring" is not an action item. "Add an alert on `X.p99 > 500ms` with runbook link and page on-call" is.
- **Aging action items are a cultural smell.** If postmortem actions sit open for 60+ days, you are doing postmortems as theatre. Publish the aging list monthly.

### Cadence and distribution

- **Publish within one week** of incident closure (SRE Workbook).
- **Accessible to everyone at the company.** Secrecy breeds blame. Openness breeds learning.
- **Review in a regular forum** — a weekly or biweekly "incident review" — not as a one-time email.
- **Invite junior engineers to attend.** The best onboarding material you have.

### A note on root cause

Traditional root-cause analysis (RCA) assumes there is *the* cause. The Learning From Incidents movement, drawing on resilience engineering (Woods, Dekker, Hollnagel), argues incidents are the surprising intersection of many contributing conditions. Hindsight bias — the tendency to collapse a messy event into a tidy narrative — is the primary obstacle to learning.

Practical recommendation: write "contributing factors," not "the root cause." Allow that multiple conditions had to align, and that different responders might reasonably disagree about weighting.

---

## Runbooks

- **Every alert has a runbook.** Linked from the alert body.
- **Every standard on-call scenario has a runbook** — deploy rollback, database failover, cache flush, certificate rotation, credential rotation, traffic shift.
- **Format:** Triggers → Checks → Mitigations → Escalation.
- **Keep in a versioned repo.** Reviewed like code. A PR for a runbook change.
- **Test quarterly.** Actually follow the runbook in a game day. If the steps do not work, you have found a bug before a 3 a.m. responder does.
- **Automate toil out.** Google's Eliminating Toil chapter frames automation as the principal way to reduce repetitive operational work. A runbook step that never requires judgment is a candidate for a button, a script, or a self-healing system.

---

## Capacity planning

Google SRE's launch guidance is unsparing about how badly humans predict demand: "Public interest is notoriously hard to predict, and some Google products had to accommodate launch spikes up to 15 times higher than initially estimated."

Rules:

- **For small teams:** trust your cloud's autoscaling defaults; watch for cost blowouts. Tag resources so you can find the culprit.
- **Plan for traffic spikes.** Known launches, marketing campaigns, holidays, integration announcements. Pre-scale and warm caches. Do not rely on autoscaling to keep up with a 10x spike in 60 seconds.
- **Load test before expected growth.** Overload behaviour "is very hard to predict from first principles." Use tools like k6, Locust, or vendor-managed load generators.
- **Add redundancy.** Google's guidance: "if you need three replicated deployments to serve 100% of your traffic at peak, you need to maintain four or five deployments, one or two of which are redundant." N+1 at minimum, N+2 for critical systems.
- **Error budget is a capacity signal.** If you are burning budget from saturation, you are under-provisioned.

---

## Disaster recovery / business continuity

Two NIST-defined terms anchor DR planning:

- **RTO (Recovery Time Objective):** the maximum acceptable downtime. "The overall length of time an information system's components can be in the recovery phase before negatively impacting the organization's mission."
- **RPO (Recovery Point Objective):** the maximum acceptable data loss, measured in time. "The point in time to which data must be recovered after an outage."

A concrete example: RTO = 1 hour, RPO = 5 minutes means "after a disaster, we are back online within an hour, and we lose at most the last 5 minutes of writes." These numbers drive backup frequency, replication topology, and failover architecture.

Concrete practices:

- **Backups tested at least quarterly.** An untested backup is not a backup. Restore to a clean environment; verify the data; measure the restore time against RTO.
- **Document the restore procedure as a runbook.** The first time you restore from backup must not be during a disaster.
- **Multi-region only if the business case demands it.** Multi-region is expensive — duplicated data stores, cross-region traffic, higher operational complexity. Most early-stage SaaS products do not need it. Multi-AZ within a region handles most realistic failures.
- **Chaos engineering as DR verification.** The Principles of Chaos Engineering define it as "experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions in production." You build confidence in your DR plan by breaking things on purpose, not by writing another document. See Chaos Engineering below.

---

## Security operations

Security operations in this phase run in parallel to reliability operations, sharing the same **detect → respond → recover** shape. The organising framework: **NIST Cybersecurity Framework (CSF) 2.0**, released 26 February 2024. Its six functions:

1. **Govern** (new in CSF 2.0) — senior-leadership accountability for cybersecurity strategy.
2. **Identify** — know your assets, threats, and risks.
3. **Protect** — safeguards (access control, encryption, hardening). Mostly Phase 03/06 work.
4. **Detect** — discover incidents. This is where Phase 07 observability becomes security-operational.
5. **Respond** — contain and eradicate.
6. **Recover** — restore service.

Map the six functions to team responsibilities and publish the map. Even a 5-person company can do a crude version (engineering owns Detect/Respond/Recover, founders own Govern/Identify, vendor choices cover Protect).

Concrete practices:

- **Detection.** Runtime security logs, anomaly detection, and (at scale) a SIEM. OWASP Top 10:2025 **A09 (Security Logging & Alerting Failures)** exists because most breaches go undetected for months. Your observability stack reduces this risk directly — if you are logging structured events with user context, you can detect credential-stuffing, anomalous data access, and privilege escalation.
- **Response runbooks for the top incident types.** Credential leak, suspicious data access, dependency compromise, lost device, account takeover. Each needs a runbook with who to call, how to rotate, how to revoke, how to notify.
- **Patching.** Track CVEs against your dependency manifest. Dependabot, Renovate, Snyk, or GitHub's native alerts. Patch within an SLA (e.g. critical within 7 days, high within 30). This connects to Phase 08 (dependency management).
- **Suppliers and supply chain.** OWASP Top 10:2025 **A03 (Software Supply Chain Failures)** is now a top-3 risk. Pin dependencies, verify signatures, maintain an SBOM (Software Bill of Materials).
- **Incident response for security incidents** uses the same ICS structure as reliability incidents — IC, Comms Lead, Scribe. A credential leak is an incident; declare it.

The ops loop in this phase (monitor, respond, postmortem) transfers directly to security-ops. You do not run a separate incident process for security unless you are large enough to have a Security Operations Centre (SOC).

---

## FinOps

Cloud cost is an operational concern. The FinOps Foundation defines FinOps as "an operational framework and cultural practice which maximizes the business value of technology, enables timely data-driven decision making, and creates financial accountability through collaboration between engineering, finance, and business teams."

Minimum practice:

- **Tag every cloud resource** with service, team, environment, cost centre. Untagged resources become orphans nobody owns and nobody turns off.
- **Daily cost dashboard.** At least per-service. Spike alerts on unusual spend.
- **Monthly review of top spenders.** Pull the top 10 resources by cost. Ask: do we still need this? Is it right-sized?
- **Right-size before scaling out.** It is cheaper to tune your existing capacity than to double it.
- **Reserved capacity / savings plans** once usage is predictable (roughly 30%+ baseline).

FinOps is explicitly cross-functional — engineering + finance + product — not a cost-cutting activity owned by finance alone. Engineers own their bill.

---

## Platform engineering / Internal developer platform

Platform engineering is "the discipline of designing and building toolchains and workflows that enable self-service capabilities for software engineering organizations in the cloud-native era." An Internal Developer Platform (IDP) is "the sum of all the tech and tools that a platform engineering team binds together to pave golden paths for developers."

Scale guidance:

- **When you are small (<15 engineers):** do not build a platform. Use your cloud provider directly. Accept some inconsistency across services for the sake of speed.
- **At ~30+ engineers:** dedicate a platform team. Its customer is the stream-aligned engineer. Its product is the golden path (the opinionated, pre-integrated way to build-test-deploy-run).
- **Team Topologies (Skelton & Pais):** stream-aligned teams deliver features; the platform team delivers the IDP as an X-as-a-Service; enabling teams fill capability gaps; complicated-subsystem teams handle narrow specialist domains.

Rule: **do not build a platform before you have the problem.** A platform team with no customers is a cost centre that invents demand. A platform team formed in response to real developer pain is a force multiplier.

---

## Chaos engineering

Not day one. Chaos engineering is for when you have meaningful reliability commitments and a complex system whose failure modes you no longer fit in your head. The Principles of Chaos Engineering list five tenets:

1. Build a hypothesis around steady-state behaviour.
2. Vary real-world events (host failure, dependency timeout, network partition, traffic spike).
3. Run experiments in production (sampled, bounded).
4. Automate experiments to run continuously.
5. Minimise blast radius.

For most teams, **game days beat automated chaos.** A game day is a scheduled exercise where you inject a failure in a test or off-peak environment and run the full incident response. You learn whether your runbooks work, whether alerts fire, whether the on-call can find the dashboard at 2 a.m. from their phone.

Start simple: "What is our worst realistic scenario, and have we practiced it?" The answer is usually "database failover" or "primary region down." Run those as game days. Automate when the exercise becomes routine.

---

## Anti-patterns

Flag these. They kill teams.

- **"It's working, don't touch it."** The moment a service becomes too scary to deploy, it becomes the source of every future outage.
- **Alerting on every anomaly.** Alert fatigue is the end of on-call discipline. Responders tune out. The real page gets missed.
- **Heroes.** A single person who knows how the system really works. Bus factor of 1. Sustainable only until they burn out or leave.
- **Postmortems without action items** — or with action items that never close.
- **Aging action items that linger for months.** A cultural tell.
- **SLOs set aspirationally, never measured.** Decoration.
- **On-call that's a single person forever.** Not a rotation; a life sentence.
- **Logs with passwords, tokens, or PII.** OWASP A09 plus regulatory disaster waiting to happen.
- **No runbooks.** Every 3 a.m. page is a fresh investigation.
- **"We'll monitor it manually."** You won't.
- **Blame framed as "accountability."** Punishing the person who hit the button teaches the team to hide problems, not to fix them.

---

## Scale notes

- **Solo / pre-product-market-fit:** Uptime Robot + Sentry + a single Slack channel for alerts. Self-designate as incident commander. Write postmortems for yourself. Run a game day once a quarter.
- **Team of 5:** Full on-call rotation (you may need follow-the-sun if not colocated). SLOs on your top 3 user-facing services. OpenTelemetry from day one. PagerDuty or Opsgenie. Runbooks for each alert. Monthly incident review.
- **Team of 50:** Dedicated platform team. Tiered on-call (L1 triage, L2 domain experts). Runbook automation and self-service tools. Formal incident commander rotation. Error-budget policy that actually freezes feature work when hit.
- **Team of 500+:** SRE as a function, embedded per stream or per platform. Error budgets drive planning at the quarterly level. Formal incident command with full ICS roles. SOC for security. FinOps team. Chaos engineering program with continuous experiments.

---

## Exit checklist

- [ ] **SLOs defined and measured** for top user-facing services (2–5 per service, rolling 28-day window).
- [ ] **Error-budget policy written down** and actually observed (feature freezes when exhausted).
- [ ] **OpenTelemetry instrumentation** in place across services.
- [ ] **Four Golden Signals dashboard** per service; business metrics dashboard separate.
- [ ] **Structured logs** with request/user/service/env/version; no passwords, tokens, or raw PII.
- [ ] **Alerting actionable** and ties to runbooks; SLO burn-rate alerts in place.
- [ ] **On-call rotation** running with primary + secondary; documented ack time; fewer than 2 unactionable pages per shift.
- [ ] **Every alert has a runbook** linked from its body.
- [ ] **Incident severity framework** adopted and published.
- [ ] **Incident command process** practiced — IC, Comms Lead, Scribe, handoff.
- [ ] **Blameless postmortem process** running; action items tracked to completion; incident reviews on a cadence.
- [ ] **Backups tested** within the last 90 days; restore time measured against RTO.
- [ ] **NIST CSF 2.0 functions** mapped to team responsibilities.
- [ ] **CVE patching SLA** defined (e.g. critical within 7 days, high within 30).
- [ ] **Cost tagging** across cloud resources; monthly cost review scheduled.
- [ ] **Game day executed** against at least one realistic failure scenario.

---

## Why this works

Each recommendation above traces back to the research under [`../research/07-operations/`](../research/07-operations/):

- **SLOs, error budgets, toil** — the reliability-as-a-feature model, the SLI/SLO/SLA vocabulary, the error-budget policy, and the toil definition and 50% cap are drawn from Google's SRE book (Embracing Risk, Service Level Objectives, Eliminating Toil chapters) and the SRE Workbook. See [`../research/07-operations/sre.md`](../research/07-operations/sre.md).
- **Observability — three pillars, OpenTelemetry, Four Golden Signals, RED, USE, actionable alerting** — come from OpenTelemetry's own observability primer, Charity Majors' Honeycomb manifesto, Google's Monitoring Distributed Systems and Practical Alerting chapters, Brendan Gregg on USE, and Tom Wilkie on RED. See [`../research/07-operations/observability.md`](../research/07-operations/observability.md).
- **Incident response — ICS lineage, the four/six roles, commander hand-off, blameless postmortems, the Learning From Incidents critique of single-root-cause thinking** — draw on Google's Managing Incidents and Postmortem Culture chapters, the SRE Workbook's postmortem updates, PagerDuty's public incident-response documentation, and John Allspaw's work at Etsy / Kitchen Soap plus IT Revolution. See [`../research/07-operations/incident-response.md`](../research/07-operations/incident-response.md).
- **Security operations — NIST CSF 2.0's six functions, OWASP Top 10:2025 risks (especially A03 supply chain and A09 logging/alerting failures), the detect→respond→recover shape shared with SRE** — from NIST and OWASP primary sources. See [`../research/07-operations/security-ops.md`](../research/07-operations/security-ops.md).
- **On-call staffing, shift length, compensation, page caps; capacity planning principles; DR's RTO/RPO; chaos engineering tenets; FinOps definition; platform engineering and Team Topologies mapping** — all traced in the top-level [`../research/07-operations/README.md`](../research/07-operations/README.md), drawing on Google's SRE Workbook On-Call chapter, PagerDuty's Being On-Call guide, Google SRE's Reliable Product Launches chapter, NIST SP 800-34's RTO/RPO definitions, the Principles of Chaos Engineering site, the FinOps Foundation's framework, platformengineering.org's definitions, and Skelton & Pais' Team Topologies.

The shape of Phase 07 — one detect-respond-recover-learn loop, applied to availability, latency, and security — is the synthesis across those sources. If you disagree with a specific recommendation, read the linked research and pick differently. The handbook picks; the research explains.
