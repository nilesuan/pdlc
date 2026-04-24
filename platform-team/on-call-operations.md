---
name: on-call and operations
description: On-call rotation, severity tiers, escalation, runbook discipline, and operational metrics for a 4-person platform team
type: operational
---

# On-call & operations

**Last updated:** 2026-04-24.
**Status:** Advisory. Severity and target metrics below are SYNTHESIS from widely-used SRE practice patterns (Google SRE book, PagerDuty incident response docs) — adapt to your actual risk profile and tune against postmortem data once you have any.

## The honest starting point at 4 people

A 4-person platform team cannot run a healthy 24×7 pager rotation. Your options are:

1. **Business-hours primary, best-effort after-hours** — the default for most internal-facing platforms. Product teams own their own business-hour triage; platform on-call escalation is page-in, not primary overnight.
2. **Primary on-call rotation of the 3 ICs, Platform Head as secondary** — a 1-in-3 primary rotation is hot. Sustainable for 2–3 quarters, not for years. Plan the 5th seat before burnout shows up.
3. **Shared rotation with product teams for production issues** — platform owns platform-layer pages (ECS, ALB, Terraform state, IAM), product teams own their service pages. This is the healthiest split and the one to push toward.

**Recommendation for now:** option 3 for product-service pages, option 2 for platform-layer pages, until the team grows to 5–6.

---

## Rotation shape (3-person IC rotation)

```
Week 1:  Cloud & IaC primary   | CI/CD & DevEx secondary  | SRE off
Week 2:  CI/CD & DevEx primary | SRE secondary            | Cloud & IaC off
Week 3:  SRE primary           | Cloud & IaC secondary    | CI/CD & DevEx off
```

Platform Head is **backup to secondary** for Sev 0 only.

**Handoff:** Monday morning sync, written summary posted in an on-call channel. Outstanding pages, open incidents, follow-ups needed.

**Comp time:** at this rotation intensity, explicitly compensate:
- Each week of primary = 1 day of flex time, usable within 30 days
- Any Sev 0/1 page outside business hours = comp time the next business day (take the morning, the day, whatever is needed)
- Sustained interrupts (>3 after-hours pages in a week) = automatic 1-day decompression before returning to focused work

Do not treat comp time as optional; the team watches whether the leader protects recovery time and calibrates effort accordingly.

---

## Severity tiers

| Severity | Criteria | Response | Notification |
|---|---|---|---|
| **Sev 0** | Platform-wide outage. Multiple product services down. ECS cluster unreachable, AWS region event, Terraform state corrupted, IAM blast. | All-hands immediate. Incident commander: Platform Head or senior IC. War room opened. Exec comms every 30 min. | Page primary + secondary + Platform Head. Customer comms within 15 min of confirmation. |
| **Sev 1** | Single shared component degraded (shared ALB, observability blind, CI/CD broken, critical IAM issue). Affects multiple teams' ability to ship or operate. | Primary on-call, escalate to secondary within 15 min if not ACK'd. Platform Head kept informed. | Page primary. Slack broadcast to platform customers. |
| **Sev 2** | Single product team or single non-critical subsystem affected. Not customer-facing. | Primary on-call, business hours next day if after-hours. | Slack / email, no page. |
| **Sev 3** | Non-urgent; backlog or planned work. | Normal ticket queue. | None. |

**Key rule:** the on-call engineer declares severity on first response. It can be upgraded or downgraded, but do not leave it ambiguous — it drives notification paths.

---

## Target metrics

These are targets to track over time, not numbers to hit immediately. Establish the baseline first, then compress.

| Metric | Sev 0 | Sev 1 | Sev 2 |
|---|---|---|---|
| **MTTA** (time to acknowledge) | ≤ 5 min | ≤ 15 min | business hours |
| **MTTR** (time to recover) | ≤ 4 h | ≤ 24 h | ≤ 5 business days |
| **Postmortem published** | ≤ 5 business days | ≤ 10 business days | optional |
| **Action items closed** | 80% within 30 days | 70% within 60 days | — |

**Do not gate severity declaration on MTTR targets.** Engineers will under-declare to avoid missing a metric, which defeats the point.

---

## Escalation policy

```
Alert fires
    ↓
Primary on-call   [15 min ACK window]
    ↓ (no ACK, or primary explicitly escalates)
Secondary on-call [15 min ACK window]
    ↓ (no ACK, or Sev 0)
Platform Head
    ↓ (if Platform Head unreachable, Sev 0, >30 min into incident)
Skip-level executive / CTO
```

**Rules:**
- Auto-escalation is mechanical (PagerDuty/Opsgenie config), not something the on-call manually pages up.
- Platform Head is a **last-resort backup**, not primary triage. Protect their focus time so the team does not default to escalating everything.
- Exec paging is rare — reserved for Sev 0 crossing 30 min, or any incident requiring external comms (customers, press, regulators).

---

## Runbook discipline

**Rule:** every actionable alert points to a runbook. If an alert fires and there is no runbook, the first action after resolving the incident is to write one before the next rotation.

**What a runbook contains:**

1. **What this alert means** — one sentence, symptom not cause
2. **Who is affected and how** — customer-facing? internal-only? which product teams?
3. **How to confirm** — dashboard links, log queries, commands to run
4. **Immediate mitigations** — in order of reversibility (safe → risky)
5. **Root cause diagnosis steps** — decision tree
6. **Escalation triggers** — conditions under which to page more people
7. **Known related incidents** — links to past postmortems

**Where runbooks live:** in the repo alongside Terraform and service code, not in a wiki. Wikis rot; git-tracked markdown reviewed alongside code changes stays alive.

**"No orphan alerts" rule:** during quarterly review, every alert firing in the last 90 days is checked against whether its runbook resolved the incident. Alerts without actionable runbooks get deleted or replaced.

---

## Postmortem process

**Every Sev 0 and Sev 1 gets a written postmortem. Every postmortem is blameless.**

Template sections:
- **Summary** — 2–3 sentences, what happened and impact
- **Impact** — duration, scope (services, teams, customers), quantified where possible
- **Timeline** — UTC timestamps, what happened, who did what
- **Root cause** — 5-whys or similar, stopping at a systemic cause, not a person
- **What went well** — actively look for this; it reinforces healthy behavior
- **What went badly** — honest, not punitive
- **Action items** — each with an owner, a due date, and a tracking issue linked

**Review meeting:** within 10 business days of the incident. Whole platform team + affected product team leads. 30 minutes. Not a trial — a learning session.

**Action item hygiene:** tracked in the same issue tracker as product work, reviewed monthly. Stale action items (>60 days open) are either done, deleted, or explicitly deprioritized with a written reason.

---

## Operational cadences

| Cadence | What happens |
|---|---|
| **Daily (async)** | On-call posts morning status in platform-oncall channel: overnight pages, open incidents, anything the team should know |
| **Weekly 30 min** | On-call handoff, open incident review, action item triage |
| **Monthly 60 min** | Metrics review: MTTA/MTTR trends, error budget burn, cost trajectory, developer NPS if measured |
| **Quarterly** | Runbook audit, alert hygiene review, DR test, SLO review with product teams, headcount plan check-in |
| **Annually** | Disaster recovery full drill (region failover, account-level recovery, secret rotation drill), postmortem retrospective (what patterns recurred this year?) |

---

## What to measure, what not to measure

**Measure:**
- MTTA, MTTR per severity
- Error budget burn per SLO
- % of alerts with valid runbooks
- % of postmortem action items closed on time
- Pages per on-call rotation (leading indicator of burnout)
- Cost per product team served

**Do not measure (as individual performance metrics):**
- Number of incidents caused by an individual — this drives under-reporting
- Speed of individual triage — this drives shortcut-taking
- Ticket throughput on the SRE — this misrepresents reliability work as output

**The distinction:** team-level reliability metrics drive system health. Individual-level reliability metrics drive defensive behavior.

---

## First 90 days (if standing up from scratch)

Rough sequence if the team is new and on-call is not yet formalized:

- **Weeks 1–2** — baseline: inventory existing alerts, identify which are actionable, dump non-actionable ones. Write up current state of incident handling (likely ad hoc).
- **Weeks 3–4** — tooling: PagerDuty/Opsgenie configured, rotation set up, severity definitions written, #platform-oncall channel with bot posting page summaries.
- **Weeks 5–8** — runbooks: every currently-firing alert gets a runbook or gets deleted. Start with Sev 0/1 candidates.
- **Weeks 9–12** — process: first postmortem template used on a real incident, first monthly metrics review, first quarterly runbook audit scheduled.

By end of 90 days: rotation is functioning, severity declaration is automatic, runbook rate is >80% of actionable alerts, first postmortem has been written and reviewed.
