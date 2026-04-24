# Stage 07 — Operations & Reliability

**Question:** What industry-grade practices govern running software in production — keeping it reliable, observable, responsive to incidents, and operationally sustainable?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

This stage covers the "run" phase of the product development life cycle: the period after a change has been deployed (Stage 06) and before it is actively being evolved with new features (Stage 08). Topics include Site Reliability Engineering (SRE), DevOps culture, observability, monitoring and alerting, incident response, postmortems, on-call practice, runbooks, capacity planning, disaster recovery, security operations, cost / FinOps, and platform engineering.

Focused sub-documents live alongside this README:

- `sre.md` — SRE principles, SLIs/SLOs/SLAs, error budgets, toil
- `observability.md` — three pillars, monitoring methods, OpenTelemetry, observability vs monitoring
- `incident-response.md` — incident command, roles, severities, postmortem culture, learning from incidents
- `security-ops.md` — NIST CSF 2.0, OWASP Top 10, security operations
- (This README) — on-call, runbooks, capacity planning, DR, FinOps, platform engineering, and synthesis

---

## 1. DevOps Culture as Operational Foundation

Operations in a modern software organisation is shaped by the DevOps movement. Two artefacts are most often cited as its intellectual foundation.

### The Three Ways

Gene Kim articulates three underlying principles — "the values and philosophies that frame the processes, procedures, practices of DevOps" [VERIFIED]:

- **First Way — Flow / Systems Thinking:** emphasises "the performance of the entire system, as opposed to the performance of a specific silo of work or department"; never passing known defects downstream; preventing local optimisation from creating system-wide degradation.
- **Second Way — Amplify Feedback Loops:** creating "right to left feedback loops," shortening and amplifying them, embedding knowledge where needed.
- **Third Way — Culture of Continual Experimentation and Learning:** "continual experimentation, taking risks and learning from failure" while recognising that "repetition and practice is the prerequisite to mastery."

Source: [The Three Ways: The Principles Underpinning DevOps — Gene Kim, IT Revolution](https://itrevolution.com/articles/the-three-ways-principles-underpinning-devops/) (accessed 2026-04-24).

### CALMS

CALMS — Culture, Automation, Lean, Measurement, Sharing — is a widely used DevOps assessment framework. Atlassian's canonical explainer credits the expansion of the earlier CAMS acronym to Jez Humble. Each pillar:

- **Culture:** shared responsibility across dev and ops, open communication.
- **Automation:** configuration as code, continuous delivery, automated deploys to identically provisioned environments to make "works on my machine!" irrelevant.
- **Lean:** visualise WIP, limit batch sizes, manage queues, streamline and eliminate non-value-adding activity.
- **Measurement:** data-driven decisions, visibility into systems and SDLC processes.
- **Sharing:** knowledge flows freely across silos.

Source: [CALMS Framework — Atlassian](https://www.atlassian.com/devops/frameworks/calms-framework) (accessed 2026-04-24). **[CONTESTED — partial fetch]** Atlassian's page returned mostly navigation content at fetch time; the pillar descriptions above are consistent with the Atlassian summary surfaced via web search but should be re-verified against a clean fetch. A corroborating secondary summary appears in multiple industry explainers indexed during the search (see Sources).

### DORA's Software Delivery Metrics

The DORA programme, now housed under Google Cloud, publishes an annual State of DevOps report and defines a small set of metrics for software delivery performance [VERIFIED]:

- **Change Lead Time** — "the amount of time it takes for a change to go from committed to version control to deployed in production."
- **Deployment Frequency** — "the number of deployments over a given period or the time between deployments."
- **Failed Deployment Recovery Time** — "the time it takes to recover from a deployment that fails and requires immediate intervention" (formerly Mean Time to Recovery).
- **Change Fail Rate** — "the ratio of deployments that require immediate intervention following a deployment."
- **Deployment Rework Rate** — "the ratio of deployments that are unplanned but happen as a result of an incident in production."

Throughput (the first two) and instability (the last three) are distinct families; DORA's position is that "speed and stability are not tradeoffs." Source: [DORA's software delivery performance metrics — DORA / Google Cloud](https://dora.dev/guides/dora-metrics/) (accessed 2026-04-24).

**[OUT OF DATE]** note: the fifth metric (Rework Rate) appears in the 2024 report cycle; earlier sources still list "four key metrics." See the Dora guide above for the current definition set.

---

## 2. On-Call Practices

### Google SRE's on-call guidance

Google's SRE Workbook (Chapter 8) gives specific numbers and principles [VERIFIED]:

- **Project-work balance:** "Team staffing must be adequate to ensure time for project work," with SREs targeting "at least 50% of their time on project work."
- **Minimum team size:** "you need a bare minimum of five people per site to sustain on-call in a multisite, 24/7 configuration, and eight people in a single-site, 24/7 configuration."
- **Shift cap:** target "a maximum of two incidents per on-call shift" so each has adequate follow-up time.
- **Shift length:** "we recommend limiting shift lengths to 12 hours. Shorter shifts are better for the mental health of your engineers."
- **Follow-the-sun pairing:** "SRE teams at Google are paired across time zones for service continuity."
- **Compensation:** "Google offers time-off-in-lieu or cash compensation, capped at some proportion of the overall salary."
- **Overall goal:** "to provide coverage for critical services, while making sure that we never achieve reliability at the expense of an on-call engineer's health."

Source: [On-Call — SRE Workbook, Google](https://sre.google/workbook/on-call/) (accessed 2026-04-24).

### PagerDuty's on-call expectations

PagerDuty publishes a public incident response guide describing expected on-call behaviour [VERIFIED]:

- Being on-call means "you are able to be contacted at any time in order to investigate and fix issues that may arise for the system you are responsible for."
- Acknowledge alerts within an escalation window (PagerDuty's guide recommends 5 minutes); determine urgency and resolve or escalate.
- Explicit non-expectation: being on-call does not require being first to acknowledge every alert, and escalation "is encouraged, not shameful."
- Hand off unresolved matters to the next shift; a backup shift enables knowledge transfer.

Source: [Being On-Call — PagerDuty Incident Response](https://response.pagerduty.com/oncall/being_oncall/) (accessed 2026-04-24).

### Compensation & burnout

Both sources agree that on-call imposes sleep and cognitive cost, and that compensation and shift design must reflect this. Neither source quotes a universal compensation formula — Google notes only that it is "capped at some proportion of the overall salary" (source above). Local law (e.g. EU working-time regulations) can make this materially different across regions. **[UNVERIFIED]** — specific legal compliance claims are out of scope here.

---

## 3. Runbooks and Playbooks

**Purpose:** Runbooks document how to respond to specific operational conditions (failed deploy, elevated error rate, disk filling). Google SRE's "Practical Alerting" discussion notes that alerts should be tied to documented responses, and the Incident Management chapter explicitly recommends "prepare procedures in advance" as a best practice.

Source: [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/) (accessed 2026-04-24).

**Automation / self-healing:** Google's Eliminating Toil chapter frames automation as the principal mechanism for reducing repetitive operational work; toil is defined partly by being "automatable" and so runbook steps that satisfy that criterion are candidates for automation. Source: [Eliminating Toil — Google SRE book](https://sre.google/sre-book/eliminating-toil/) (accessed 2026-04-24).

**[UNVERIFIED]** The specific distinction between "runbook" (one procedure, one page) and "playbook" (collection of runbooks plus decision trees) is widely used but I did not locate a canonical primary source defining the distinction during this session. Treat as common industry usage rather than an authoritative taxonomy.

---

## 4. Capacity Planning

Google SRE's launch guidance gives concrete capacity-planning principles [VERIFIED]:

- Demand is hard to predict. "Public interest is notoriously hard to predict, and some Google products had to accommodate launch spikes up to 15 times higher than initially estimated."
- Launch spikes differ from steady state; historical data is insufficient for peak projection.
- Phased rollout: "launching initially in one region or country at a time" builds confidence before global deployment.
- Redundancy: "if you need three replicated deployments to serve 100% of your traffic at peak, you need to maintain four or five deployments, one or two of which are redundant."
- Load testing is necessary because overload behaviour "is very hard to predict from first principles."

Source: [Reliable Product Launches at Scale — Google SRE book](https://sre.google/sre-book/reliable-product-launches/) (accessed 2026-04-24).

**[SYNTHESIS]** These principles compose into a practical loop: forecast demand with conservative margins, add headroom for redundancy, load-test to validate, roll out in stages, and re-forecast as real usage data arrives. Each step has a specific citation above; the loop itself is an inference.

---

## 5. Disaster Recovery & Business Continuity

Two NIST-defined terms anchor DR planning [VERIFIED]:

- **Recovery Time Objective (RTO):** "The overall length of time an information system's components can be in the recovery phase before negatively impacting the organization's mission or mission/business processes." Source: [NIST Glossary — RTO, SP 800-34 Rev. 1](https://csrc.nist.gov/glossary/term/recovery_time_objective) (accessed 2026-04-24).
- **Recovery Point Objective (RPO):** "The point in time to which data must be recovered after an outage." Source: [NIST Glossary — RPO, SP 800-34 Rev. 1](https://csrc.nist.gov/glossary/term/recovery_point_objective) (accessed 2026-04-24).

RTO sets a bound on acceptable downtime; RPO sets a bound on acceptable data loss. Together they drive backup frequency, replication topology, and failover design. **[SYNTHESIS]** from the two definitions above.

### Chaos engineering as DR verification

The Principles of Chaos Engineering site (maintained by the founding practitioners including Netflix engineers) defines the discipline as "experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions in production" [VERIFIED]. The five principles it lists are:

1. Build a Hypothesis around Steady State Behavior (measure output such as "throughput, error rates, latency percentiles").
2. Vary Real-world Events (hardware failures, malformed responses, traffic changes).
3. Run Experiments in Production — "sampling real traffic is the only way to reliably capture the request path."
4. Automate Experiments to Run Continuously.
5. Minimize Blast Radius — "ensure the fallout from experiments are minimized and contained."

Source: [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24).

Chaos engineering ties to DR by providing a continuous, testable way to verify that failure assumptions (e.g. "we can fail over in RTO minutes") hold against a live system rather than against a plan document. **[SYNTHESIS]** from the two sources above.

---

## 6. Cost & FinOps

The FinOps Foundation defines FinOps as [VERIFIED]:

> "an operational framework and cultural practice which maximizes the business value of technology, enables timely data-driven decision making, and creates financial accountability through collaboration between engineering, finance, and business teams."

The framework has four **Domains** (Understand Usage & Cost; Quantify Business Value; Optimize Usage & Cost; Manage the FinOps Practice), nineteen **Capabilities**, three **Phases** (Inform, Optimize, Operate), and six **Principles**, including "Everyone takes ownership for their technology usage" and "Take advantage of the variable cost model of the cloud."

Sources:
- [What is FinOps? — FinOps Foundation](https://www.finops.org/introduction/what-is-finops/) (accessed 2026-04-24)
- [FinOps Framework — FinOps Foundation](https://www.finops.org/framework/) (accessed 2026-04-24)

FinOps is explicitly positioned as a cross-functional discipline (engineering + finance + product) rather than as a cost-cutting activity owned by finance alone.

---

## 7. Platform Engineering & Internal Developer Platforms

Platform engineering is "the discipline of designing and building toolchains and workflows that enable self-service capabilities for software engineering organizations in the cloud-native era." An Internal Developer Platform (IDP) is "the sum of all the tech and tools that a platform engineering team binds together to pave golden paths for developers" [VERIFIED].

Source: [What is Platform Engineering? — platformengineering.org](https://platformengineering.org/blog/what-is-platform-engineering) (accessed 2026-04-24).

Key concepts from the same source:

- **Golden paths / paved roads** — pre-integrated, opinionated defaults that match "the preferred abstraction level of the individual developer."
- **Cognitive load reduction** — the IDP "encompasses a variety of technologies and tools, integrated in a manner that reduces cognitive load on developers while retaining essential context and underlying technologies."
- **Autonomy** — "autonomous delivery teams can make use of the platform to deliver product features at a higher pace, with reduced coordination."

### Team Topologies connection

Matthew Skelton and Manuel Pais' Team Topologies names four fundamental team types and three interaction modes [VERIFIED]:

- **Stream-aligned team** — "aligned to a flow of work from (usually) a segment of the business domain."
- **Platform team** — "a grouping of other team types that provide a compelling internal product to accelerate delivery by Stream-aligned teams."
- **Enabling team** — "helps a Stream-aligned team to overcome obstacles. Also detects missing capabilities."
- **Complicated Subsystem team** — "where significant mathematics/calculation/technical expertise is needed."

Interaction modes: **Collaboration**, **X-as-a-Service**, **Facilitation**.

Source: [Key Concepts — Team Topologies, Matthew Skelton & Manuel Pais](https://teamtopologies.com/key-concepts) (accessed 2026-04-24).

**[SYNTHESIS]** An IDP is the product a platform team delivers to stream-aligned teams via the X-as-a-Service interaction mode; this maps the Team Topologies vocabulary onto platform engineering's "IDP as compelling internal product" concept. Each term is independently cited above.

---

## How the pieces fit

**[SYNTHESIS]** from the cited sources above:

- **Reliability is a product feature** (SRE) — expressed quantitatively via SLIs/SLOs and an error budget. (See `sre.md`.)
- **Observability is how you see what is happening** (OpenTelemetry, honeycomb) — it is a pre-requisite to SLO measurement, alerting, and incident response. (See `observability.md`.)
- **Incident response is how you survive the moments reliability is at risk** (Google SRE Managing Incidents, PagerDuty) — with declared roles, defined severities, and a living incident document. (See `incident-response.md`.)
- **Postmortem culture is how you convert incidents into durable improvement** (Google SRE Postmortem Culture, Etsy Code as Craft, Learning From Incidents) — blameless and widely shared.
- **On-call, runbooks, capacity planning, DR, chaos engineering** are the operational practices that make the above work day-to-day.
- **Security operations** (NIST CSF 2.0, OWASP Top 10) run in parallel and share the same detect → respond → recover shape. (See `security-ops.md`.)
- **FinOps and platform engineering** sit alongside SRE as peer disciplines — cost observability and developer-experience respectively — often staffed by the same kind of platform/infrastructure people.

---

## Sources

All URLs fetched during this session, with access date 2026-04-24:

- [The Three Ways: The Principles Underpinning DevOps — IT Revolution](https://itrevolution.com/articles/the-three-ways-principles-underpinning-devops/)
- [DORA's software delivery performance metrics](https://dora.dev/guides/dora-metrics/)
- [DORA Research](https://dora.dev/research/)
- [DORA Quickcheck](https://dora.dev/quickcheck/)
- [CALMS Framework — Atlassian](https://www.atlassian.com/devops/frameworks/calms-framework) (partial fetch; see note)
- [On-Call — SRE Workbook](https://sre.google/workbook/on-call/)
- [Being On-Call — PagerDuty Incident Response](https://response.pagerduty.com/oncall/being_oncall/)
- [PagerDuty Incident Response home](https://response.pagerduty.com/)
- [Reliable Product Launches at Scale — Google SRE book](https://sre.google/sre-book/reliable-product-launches/)
- [Eliminating Toil — Google SRE book](https://sre.google/sre-book/eliminating-toil/)
- [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/)
- [NIST Glossary — RTO](https://csrc.nist.gov/glossary/term/recovery_time_objective)
- [NIST Glossary — RPO](https://csrc.nist.gov/glossary/term/recovery_point_objective)
- [Principles of Chaos Engineering](https://principlesofchaos.org/)
- [What is FinOps? — FinOps Foundation](https://www.finops.org/introduction/what-is-finops/)
- [FinOps Framework](https://www.finops.org/framework/)
- [What is Platform Engineering? — platformengineering.org](https://platformengineering.org/blog/what-is-platform-engineering)
- [Key Concepts — Team Topologies](https://teamtopologies.com/key-concepts)
- [SRE Book Table of Contents](https://sre.google/sre-book/table-of-contents/)
- [SRE Workbook Table of Contents](https://sre.google/workbook/table-of-contents/)

Additional sources cited in the sub-documents (`sre.md`, `observability.md`, `incident-response.md`, `security-ops.md`) are listed at the end of each file.

---

## Open questions

- **Runbook vs playbook taxonomy** — find a canonical primary source (or document that none exists and it is de facto usage).
- **On-call compensation norms** — survey data (State of DevOps, Stack Overflow Developer Survey, or similar) would anchor the claim beyond Google's internal policy.
- **CALMS attribution** — re-fetch the Atlassian page cleanly; if it still returns navigation-only, find a primary source (Jez Humble talk or article) for the acronym expansion.
- **DORA 2024/2025 metric set** — confirm the Rework Rate is the fifth metric in the most recent official report, not a derivative secondary-source interpretation.
- **Ops maturity model** — is there a canonical, citable maturity model for operations (beyond FinOps' Crawl/Walk/Run and CALMS)? The SRE Maturity Model referenced in some industry talks needs primary sourcing.
- **Chaos engineering adoption rates** — any current survey data on adoption vs. awareness would strengthen the "chaos is mainstream" implication.
