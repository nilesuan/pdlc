# ON_CALL.md — Rotation, runbooks, blameless postmortems

**Authoritative source:** [`../../../handbook/07-run.md`](../../../handbook/07-run.md); [`../../../platform-team/on-call-operations.md`](../../../platform-team/on-call-operations.md); [`../../../research/07-operations/incident-response.md`](../../../research/07-operations/incident-response.md); [`../../../research/07-operations/sre.md`](../../../research/07-operations/sre.md).

## Hard rules

1. **A service with users has an on-call.** No service goes to prod without an explicit on-call rotation defined.
2. **Rotation has at least 4 people.** Two-person rotations burn out fast; one-person rotations are not rotations.
3. **Primary + secondary.** Primary takes the page; secondary is fallback if primary doesn't ack within N minutes (typically 5–15).
4. **On-call shift ≤ 1 week.** Longer shifts erode response quality.
5. **Post-shift handoff.** Outgoing oncall briefs incoming on open incidents, recent changes, and known-fragile areas.
6. **Page only on user-impacting symptoms.** See [`OBSERVABILITY.md`](OBSERVABILITY.md) for symptom-vs-cause framing.
7. **Every alert has a runbook.** No exceptions.
8. **Incidents follow an Incident Commander pattern.** One person (IC) owns the response; others fill defined roles (operations lead, communications lead, scribe).
9. **Blameless postmortems for SEV1 / SEV2.** Within 5 business days. Public to engineering. Action items have owners and dates.

## Severity definitions (calibrate locally)

| Severity | Customer impact | Response |
|---|---|---|
| SEV1 | Service down or major data risk | Page immediately, IC, all-hands |
| SEV2 | Significant degradation, partial outage | Page primary, IC if > 30min |
| SEV3 | Limited / single-customer impact | Ticket, business-hours response |
| SEV4 | No user impact (capacity warning, lint) | Backlog |

Default to higher severity if uncertain. Downgrade after triage; don't upgrade after the fact.

## Runbook structure

Every alert links to a runbook with:

1. **What this alert means** — what symptom is it detecting?
2. **First diagnostics** — three commands / dashboards to check first.
3. **Common causes (ranked by frequency).**
4. **Mitigation steps** — including rollback (always option 1 if recent deploy).
5. **Escalation path** — who to call if mitigation doesn't work in 15 min.
6. **Last updated date** + author. Stale runbooks (> 6 months untouched) are flagged.

A runbook that just says "investigate" is not a runbook.

## Blameless postmortem template

```
# Postmortem: <incident title>
Date: YYYY-MM-DD
Severity: SEVx
Duration: HH:MM (start → end)
IC: <name>
Authors: <names>

## Summary
<2–4 sentences: what happened, what was the impact>

## Impact
- Users affected: <number / segment>
- Revenue impact: <if known>
- Data loss / corruption: <yes/no, scope>

## Timeline (UTC)
HH:MM — <event>
HH:MM — <event>
...

## Root cause
<technical explanation; multiple contributing factors expected>

## What went well
- ...

## What went poorly
- ...

## Action items
| Action | Owner | Due | Tracking |
|---|---|---|---|
| ... | ... | ... | <ticket> |

## Lessons learned
<organizational / process insights, not finger-pointing>
```

## Auto-rejection (used by platform-engineer / qa-engineer)

| Trigger | Severity |
|---|---|
| Service in prod with no documented on-call | Major |
| Alert with no runbook | Major |
| Postmortem missing for a SEV1 / SEV2 > 5 business days old | Major (process finding) |
| Postmortem with named blame (individuals listed as cause) | Major |
| Action items with no owner or no due date | Minor |
| Runbook last updated > 12 months ago | Minor |

## Anti-patterns to flag

- "Hero culture" — same person always takes pages. Sign of a fragile rotation.
- Postmortems that conclude "human error" — almost always there's a system that allowed the error. Look for the missing guardrail.
- Action items that languish for quarters. A postmortem without follow-through is theatre.
- Pager noise that nobody silences — a rotation drowning in low-quality alerts will miss the high-quality one.
- Alert routing that pages "the team" not "the on-call." Diffuse responsibility = no responsibility.

## Burnout signals to watch

- Pages per week per person. > 2 → noise problem.
- Sleep-disrupting pages per month. > 1 → review thresholds.
- "I'll just stay up to watch the deploy." → automation gap.
- Volunteer rota imbalance — same 1–2 people covering most shifts.

## Sources

- Google SRE Book (Beyer et al., 2016) — incident response, postmortem culture.
- John Allspaw, *Etsy Debriefing Facilitation Guide* (2016) — blameless postmortem framing.
- PagerDuty *Incident Response* guide (response.pagerduty.com).
- Atlassian *Incident Handbook* — IC role definitions.
- Platform team: [`../../../platform-team/on-call-operations.md`](../../../platform-team/on-call-operations.md) — current rotation policy at the team's actual head-count.
- Research: [`../../../research/07-operations/incident-response.md`](../../../research/07-operations/incident-response.md), [`../../../research/07-operations/sre.md`](../../../research/07-operations/sre.md).
- Handbook: [`../../../handbook/07-run.md`](../../../handbook/07-run.md).
