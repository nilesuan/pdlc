# 07-run-exit.md — Phase 07 (Run) exit checklist

**Authoritative source:** [`../../../handbook/07-run.md`](../../../handbook/07-run.md); [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md), [`../operations/ON_CALL.md`](../operations/ON_CALL.md).

This checklist is run at "ready to operate" milestone (a service entering prod) and revisited each quarter for live services.

## Done-when (service in production)

- [ ] **2–5 SLOs defined** per service, formatted as `≥ X% over 28-day window`.
- [ ] **Error budget calculated** and tracked. Policy for budget-exhausted state agreed.
- [ ] **Four Golden Signals dashboard** exists: latency (p50/p95/p99), traffic, errors, saturation. See [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).
- [ ] **OpenTelemetry instrumentation** active: traces, metrics, structured logs with correlated IDs.
- [ ] **Logs structured (JSON)** with `trace_id`, `service`, `level`, domain fields.
- [ ] **PII redaction** in place; no plaintext PII in logs.
- [ ] **Alerts symptom-based**, not cause-based. Each alert has a runbook link.
- [ ] **Alert volume sustainable:** < 2 pages per person per week on the rotation.
- [ ] **On-call rotation defined** with primary + secondary; shift ≤ 1 week; ≥ 4 people.
- [ ] **Runbook exists for every alert.** Last-updated date present and < 12 months old.
- [ ] **Incident commander pattern** documented; team knows how to call a SEV1.
- [ ] **Blameless postmortem template** in repo / runbook tool. SEV1/SEV2 postmortems within 5 business days.
- [ ] **Audit logs** for sensitive operations (auth events, data access, admin actions).
- [ ] **Backups + restore tested.** A backup not exercised is not a backup.
- [ ] **Capacity headroom** ≥ 30% under expected peak for typical workloads.

## Auto-rejection

| Trigger | Severity |
|---|---|
| Service in prod with zero SLOs | Major |
| No on-call rotation documented | Major |
| Alert without a runbook | Major |
| Plaintext PII in logs | Blocker |
| Auth events not audit-logged | Major |
| > 8 weekly alerts firing without runbooks (alert fatigue) | Major |
| Postmortem missing for SEV1/SEV2 > 5 business days | Major (process) |
| Postmortem with named blame | Major |
| Backup never restore-tested | Major |
| Trace propagation broken across hop | Major |
| Cause-based alert paging on-call (e.g., "CPU 90%") with no user impact | Minor |

## What good looks like

- An on-call could be handed the runbook for the most common alert and resolve it without paging the dev team.
- Dashboards are curated to the four signals + a small number of domain-specific panels — not 40 random widgets.
- The error budget is referenced in real planning conversations ("we're 60% through this month's budget — let's slow on flag-flipping").
- Incidents follow the pattern: page → ack → IC declared → mitigation → all-clear → postmortem with action items that actually land.

## Quarterly review items

- SLO attainment: meeting / not meeting / over-attaining (tighten or retire).
- Alert hygiene: any alert that hasn't fired in 6 months → archive. Any alert that fires > 5×/week without escalation → fix or remove.
- Runbook freshness: update or delete > 12-month-stale runbooks.
- Postmortem action-item completion rate.
- On-call burnout signals (sleep-disrupting pages, rota imbalance).

## Sources

- Beyer, Jones, Petoff, Murphy, *Site Reliability Engineering* (2016) — SRE Book.
- Beyer, Murphy, Rensin, Kawahara, Thorne, *The Site Reliability Workbook* (2018).
- John Allspaw, *Etsy Debriefing Facilitation Guide* (2016).
- OpenTelemetry semantic conventions (opentelemetry.io).
- Atlassian *Incident Handbook* — IC role definitions.
- Handbook: [`../../../handbook/07-run.md`](../../../handbook/07-run.md).
