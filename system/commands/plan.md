---
name: plan
description: Phase 02 — turn validated opportunities into a concrete plan for the first release with a measurement framework. Produces strategy, MVP scope, OKRs, roadmap, and a prioritized backlog.
argument-hint: [opportunity-or-product-name]
---

# /plan

## Goal

Convert Phase 01's evidence into a one-page strategy, an MVP with explicit scope and a riskiest-assumption test, OKRs, a Now/Next/Later roadmap, and a backlog with the top 10–20 items prioritized.

## Done when

- One-page product strategy exists (vision, Rumelt kernel, how-we-win, metrics).
- MVP scope doc with explicit "not in scope" and named riskiest assumption.
- OKRs set: 1–3 Objectives, 3–5 outcome-based Key Results each; committed/aspirational labeled; decoupled from compensation.
- Now/Next/Later roadmap (theme rows, OKR-linked, dates only on Now).
- Backlog prioritized with one framework (RICE default); top 10–20 items scored.
- Top of backlog has 1.5–2 sprints of Ready work (estimated, acceptance criteria, agreed).
- Sprint cadence chosen and documented (2-week Scrum default; Kanban with WIP limits if work is uniform).
- Weekly backlog refinement and weekly/biweekly CFR scheduled with named attendees.
- Every leaf task is sized at 1–2 hours of work; the mandatory verification pass has been run; any oversized tasks are surfaced as documented exceptions with reason and accountable-owner acknowledgement (per [`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md)).
- Team can name the riskiest assumption the MVP tests.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

02 — Plan

## Pre-flight

- Phase 01 discovery artifact exists (a `proceed` decision, not pivot/kill).
- Product owner / accountable role identified (handbook's "Founder/PM" seat).
- Engineering and design have read the discovery artifact.

## Dependency Gate

The pass-runner refuses to start unless every row is satisfied:

| Artifact | Path | Required by |
|---|---|---|
| Discovery decision = proceed | `discovery/<slug>/decision.md` | All passes |
| Problem statement | `discovery/<slug>/problem.md` | Pass 1 |
| Evidence log | `discovery/<slug>/evidence-log.md` | Pass 1 |
| Opportunity Solution Tree | `discovery/<slug>/ost.md` | Pass 1 |
| Riskiest-assumption tests | `discovery/<slug>/riskiest-assumption-tests.md` | Pass 2 |
| Named accountable owner | recorded in `decision.md` | Pass 3 |

A pivot or kill decision is a hard stop — the command refuses to plan a project the team has decided not to pursue.

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "agents": {
    "systems-architect": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/QUALITY.md",
        "standards/process/TASK_SIZING.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Does the strategy contain Rumelt's three elements (diagnosis + guiding policy + coherent actions); are the OKRs outcome-based rather than feature lists; and is every leaf task sized 1–2 hours with the mandatory verification pass completed (per [`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md))? |
| 2 | Proof & Safety | Does the MVP name the single riskiest assumption and how it will be tested, and are RICE scores grounded in Phase 01 evidence rather than internal opinion? |
| 3 | Ship Readiness | Is sprint cadence + weekly CFR scheduled with named attendees, and does the backlog have 1.5–2 sprints of Ready work with a named accountable owner per OKR? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/process/TASK_SIZING.md
```

## Sub-agents

```yaml
sub_agents:
  - systems-architect    # reviews scope; flags premature optimization, scope creep
```

## Pass-loop dispatch

Pass-runner produces, in order:

1. **Strategy.md** — Rumelt kernel (diagnosis + guiding policy + coherent actions) + vision + how-we-win + 3–5 success metrics.
2. **mvp.md** — In-scope, **explicitly NOT in scope**, accepted crudeness, the single riskiest assumption.
3. **okrs.md** — 1–3 Objectives, 3–5 outcome-based KRs each, committed vs aspirational labeled, NOT coupled to compensation, NOT a feature checklist.
4. **roadmap.md** — Now / Next / Later with theme rows, OKR-linked, dates only on Now.
5. **backlog.md** — top 10–20 items with RICE scores, plus 1.5–2 sprints of Ready work at the top.
6. **cadence.md** — sprint cadence, ceremonies, attendees, weekly CFR schedule.

Pass-runner enforces the anti-patterns:

- Feature-based roadmaps with hard dates on Later: blocker.
- OKRs as task tracker: blocker (KRs must describe outcomes, not activities).
- Multiple prioritization frameworks running simultaneously: major.
- Velocity committed as promise to stakeholders: major (forecast, not promise).
- Planning Later items in detail: minor (will invalidate).
- Missing "what's out of scope" in MVP: blocker.

## Output

Artifacts under `planning/<release-name>/`. Pass-runner returns artifact paths, score against exit checklist, the top 1–2 risks the user should resolve before exiting Phase 02.

## Sources

- Handbook: [`../../handbook/02-plan.md`](../../handbook/02-plan.md)
- Research:
  - [`../../research/02-planning/README.md`](../../research/02-planning/README.md) — Rumelt strategy, Cagan vision/strategy
  - [`../../research/02-planning/okrs.md`](../../research/02-planning/okrs.md) — Doerr, *Measure What Matters*; CFRs
  - [`../../research/02-planning/roadmaps.md`](../../research/02-planning/roadmaps.md) — Bastow Now/Next/Later; outcome-based not feature-based
  - [`../../research/02-planning/prioritization.md`](../../research/02-planning/prioritization.md) — Intercom RICE
  - [`../../research/02-planning/estimation.md`](../../research/02-planning/estimation.md) — Cohn story points; Duarte #NoEstimates
