---
name: run
description: Phase 07 — keep the product reliably available. Reviews SLOs, observability wiring, alerting, on-call rotation, runbooks, incident response, and postmortem hygiene.
argument-hint: [service-or-system]
---

# /run

## Goal

Audit the operations surface for reliability: SLOs measured and observed, observability wired, alerting actionable, on-call rotating, incidents handled with the IC pattern, postmortems blameless and acted upon.

## Done when

- 2–5 SLOs per service; SLI/SLO/SLA distinguished; rolling 28-day window.
- Error budget defined as `1 - SLO`; budget-exhaustion policy documented (feature freeze until paid back).
- OpenTelemetry instrumentation in place (logs + metrics + traces).
- Four Golden Signals dashboard per service: latency, traffic, errors, saturation.
- Structured logs include `request_id`, `user_id`, `service`, `env`, `version`. No passwords, tokens, or raw PII.
- Alerts are actionable; every alert has a runbook link; SLO burn-rate alerting (multi-window, multi-burn-rate).
- On-call rotation: primary + secondary, ≤ 12-hour shifts, < 2 unactionable pages per shift, follow-the-sun if multi-timezone.
- Incident process: severity framework, IC pattern, status page, blameless postmortem within 1 week, action items tracked.
- Backups tested within 90 days; RTO/RPO measured against design targets.
- NIST CSF 2.0 functions mapped to team responsibilities.
- CVE patching SLA defined and met (e.g., critical 7 days, high 30 days).
- Cost tagging across cloud resources; monthly review.
- Last 90 days: at least one game day exercise.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

07 — Run

## Pre-flight

- The service is in production (or about to enter).
- Observability platform identified (Datadog / Honeycomb / Grafana stack / CloudWatch).
- On-call tool identified (PagerDuty / Opsgenie / GitLab on-call).

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Service running in prod | observability platform shows live data | Pass 1 |
| Observability platform | named in `NOTES.md` or service `README.md` | Pass 1 |
| OpenTelemetry instrumentation | trace export configured | Pass 1 |
| On-call tool wired | rotation visible | Pass 1 |
| SLO definitions | `docs/slos/<service>.md` | Pass 1 |
| Runbook directory | `docs/runbooks/` exists with at least one runbook per critical alert | Pass 2 |
| Postmortem template | `docs/postmortem-template.md` | Pass 3 |
| Backup-restore evidence | log entry in last 90 days at `docs/runbooks/backup-restore.md` | Pass 3 |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "agents": {
    "platform-engineer": {
      "model": "opus",
      "model_reviewing_existing": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/operations/OBSERVABILITY.md",
        "standards/operations/ON_CALL.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Does each user-facing endpoint have a measurable SLO with a 28-day rolling window, are the Four Golden Signals (latency / traffic / errors / saturation) on a dashboard per service, and are logs structured with the required keys? |
| 2 | Proof & Safety | Does every alert link to a runbook, is the on-call rotation healthy (≥ 2 people, < 2 unactionable pages/shift), are logs free of credentials/PII, and are CVE patching SLAs being met? |
| 3 | Ship Readiness | Is the error-budget policy actually observed (feature freeze when exhausted), have backups been restored within 90 days against the RTO/RPO, are postmortem action items aging within their due dates, and has there been a game day in the last 90 days? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/operations/OBSERVABILITY.md
  - standards/operations/ON_CALL.md
  - standards/security/OWASP.md          # for A09 logging hygiene
```

## Sub-agents

```yaml
sub_agents:
  - platform-engineer    # primary (opus for SLO/dashboard design; sonnet for review)
  - security-reviewer    # log hygiene; secrets in logs; CVE SLA (opus)
```

## Pass-loop dispatch

Pass-runner produces a **run-readiness report**. Per pass:

1. **SLOs.** For each user-facing endpoint or critical job: is there an SLO? Is the SLI measurable from current metrics? Window? Target?
2. **Error-budget policy.** Document exists? Is "feature freeze when exhausted" actually observed in the last quarter?
3. **Telemetry.** OpenTelemetry traces propagating across service boundaries? Logs structured? Metrics emitted (RED + USE)?
4. **Dashboards.** One per service. Top row: Four Golden Signals. SLO burn rate prominent. Business metrics separate. Dashboards as code.
5. **Alerting.** Each alert: actionable in < 1h? Runbook linked? Severity appropriate? Burn-rate alerting on SLOs (not "5xx > 0").
6. **On-call.** Rotation healthy? Primary + secondary? < 2 unactionable pages/shift? Follow-the-sun if applicable? Never someone's first week?
7. **Runbooks.** Each alert has one. Each runbook: signal, hypothesis, mitigations, escalation, contact.
8. **Incident response.** IC pattern adopted? Severity framework written? Status page wired? Postmortem template includes Five Whys / contributing factors / action items?
9. **Postmortem aging.** Action items closed within their stated due date? > 30 days unclosed: surface.
10. **Logging hygiene.** Spot-check logs for credentials, tokens, full PANs, raw PII. Even one finding is blocker.
11. **Backups.** Last restore test? RTO/RPO measured?
12. **Cost.** Tagging compliance; monthly review; idle resources flagged?

## Hard blockers

- Logs contain credentials / tokens / raw PII / full PANs.
- An alert has no runbook.
- On-call is a single person (not a rotation).
- Backups never tested.
- Critical-CVE SLA missed for > 30 days.

## Output

Artifact at `cdocs/run-audit-<timestamp>.md`:

- SLO table per service.
- Dashboard inventory.
- Alert inventory with runbook coverage.
- On-call health.
- Postmortem aging.
- Top 5 actions for the next 30 days.

## Sources

- Handbook: [`../../handbook/07-run.md`](../../handbook/07-run.md)
- Research:
  - [`../../research/07-operations/sre.md`](../../research/07-operations/sre.md) — Google SRE Book; SRE Workbook; SLO/SLI; toil
  - [`../../research/07-operations/observability.md`](../../research/07-operations/observability.md) — OpenTelemetry; Charity Majors; Four Golden Signals; RED; USE
  - [`../../research/07-operations/incident-response.md`](../../research/07-operations/incident-response.md) — Google Managing Incidents; PagerDuty IR; Allspaw blameless postmortems
  - [`../../research/07-operations/security-ops.md`](../../research/07-operations/security-ops.md) — NIST CSF 2.0; OWASP Top 10:2025 (A03 supply chain, A09 logging)
- Platform: [`../../platform-team/on-call-operations.md`](../../platform-team/on-call-operations.md)
