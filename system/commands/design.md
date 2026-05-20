---
name: design
description: Phase 03 — make the few decisions expensive to reverse later. Produces user flows, C4 diagrams, ADRs for load-bearing choices, data model, API contracts, and a STRIDE threat model.
argument-hint: [feature-or-system-name]
---

# /design

## Goal

Ship a design package that lets the team build in parallel without re-asking basic questions. Load-bearing decisions are captured in ADRs; threat model exists.

## Done when

- 3–5 core user flows drawn and reviewed (action → system response → user sees).
- C4 context + container diagrams exist and are current.
- ADR exists for: deployment shape, primary data store, auth strategy, multi-tenancy model, API style.
- Core data model drawn (10–30 entities, relationships, lifecycle, tenant scoping).
- API contract style chosen (REST default for external); versioning and error shape documented.
- STRIDE threat model done: container diagram + threats + chosen responses (accept / eliminate / mitigate / transfer).
- Non-functional targets stated: availability target, p95 latency, RTO/RPO, accessibility (WCAG 2.2 AA), security baseline (OWASP Top 10).
- Design doc exists for any non-trivial project (crosses modules, new data store, API definition, security-sensitive, hard to undo, 3+ engineers in parallel).
- Team agrees the artifacts are load-bearing; an implementer can start without re-asking basics.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

03 — Design

## Pre-flight

- Phase 02 plan + MVP scope agreed.
- The user named the feature or system being designed (command argument).
- For brownfield: the existing C4 container diagram is up to date OR the first task is to refresh it.

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Plan strategy | `planning/<release>/strategy.md` | Pass 1 |
| MVP scope (incl. NOT-in-scope) | `planning/<release>/mvp.md` | Pass 1 |
| OKRs | `planning/<release>/okrs.md` | Pass 1 |
| (Brownfield) Current C4 container diagram | `docs/architecture/c4-container.md` (or equivalent) | Pass 1 |
| Riskiest assumption | named in `mvp.md` | Pass 2 (informs threat model) |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "force_model": "opus",
  "agents": {
    "systems-architect": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/QUALITY.md",
        "standards/development/SOLID.md",
        "standards/development/CLEAN_ARCHITECTURE.md",
        "standards/docs/ADR.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md",
        "standards/security/AUTH.md",
        "standards/frameworks/STRIDE_THREAT_MODELING.md"
      ]
    },
    "platform-engineer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/platform/AWS_ECS_TERRAFORM.md",
        "standards/release/CONTINUOUS_DELIVERY.md"
      ]
    }
  }
}
```

`force_model: opus` applies to all three sub-agents on every pass — design errors compound into expensive rework. STRIDE_THREAT_MODELING is loaded by default in this phase (always activated regardless of brief keywords).

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Are the load-bearing decisions (deployment shape, primary store, auth, multi-tenancy, API style) each captured in an ADR with alternatives and consequences, and is the C4 context+container current? |
| 2 | Proof & Safety | Has every container in the C4 diagram been put through STRIDE-per-element with chosen responses, and are NFRs (availability, p95, RTO/RPO, accessibility, security baseline) explicit and measurable? |
| 3 | Ship Readiness | Can a new implementer start without re-asking basics, and have load-bearing trade-offs been distributed (design doc reviewed, ADRs accepted, threat model signed off)? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/development/SOLID.md
  - standards/development/CLEAN_ARCHITECTURE.md
  - standards/security/OWASP.md
  - standards/security/AUTH.md
  - standards/docs/ADR.md
```

## Sub-agents

```yaml
sub_agents:
  - systems-architect    # design proposals + ADRs (opus)
  - security-reviewer    # STRIDE pass (opus)
  - platform-engineer    # deployment shape, IaC implications (opus for design pass)
```

The pass-runner sets `force_model: opus` for all three on the first pass — design errors compound.

## Pass-loop dispatch

Pass-runner produces:

1. **User flows** in Mermaid sequence diagrams: 3–5 core journeys.
2. **C4 diagrams**: context + container. Component-level only where genuinely uncertain.
3. **ADRs** under `docs/adr/`: one per load-bearing decision, using [`../standards/docs/ADR.md`](../standards/docs/ADR.md).
4. **Data model** in Mermaid ER or PlantUML: entities, relationships, tenancy column on every shared table.
5. **API contract**: OpenAPI or schema definitions; versioning in path; one error shape; idempotency keys for mutating ops.
6. **Threat model** at `docs/threat-models/<feature>.md`: STRIDE per element, threats scored, chosen responses.
7. **Non-functional targets** at `docs/nfr/<feature>.md`.

Pass-runner enforces:

- Big Design Up Front with no Phase-01 contact: refuse, route back.
- Microservices on day one: blocker unless ADR explains the team-size and traffic-scale justification.
- Custom auth: blocker unless ADR explains why a real provider doesn't fit.
- Premature scaling optimizations (sharding before one tenant): major.
- Skipping threat model "because we're small": blocker.
- Design review as theatre (sign-off without comments): major — record at least one specific question per reviewer.

## Output

Artifacts under `docs/`. Pass-runner returns:

- Paths to all written ADRs.
- Path to threat model.
- The two most consequential trade-offs from the design pass, surfaced for the user.
- Score against exit checklist; gaps listed.

## Sources

- Handbook: [`../../handbook/03-design.md`](../../handbook/03-design.md)
- Research:
  - [`../../research/03-design/system-architecture.md`](../../research/03-design/system-architecture.md) — Nygard ADRs; Fowler MonolithFirst; MicroservicePremium; C4 model
  - [`../../research/03-design/api-design.md`](../../research/03-design/api-design.md) — Fielding REST; Google API Design Guide; Microsoft Azure/Graph; gRPC and GraphQL trade-offs
  - [`../../research/03-design/ux-design.md`](../../research/03-design/ux-design.md) — NN/g Design Thinking; Nielsen heuristics; WCAG 2.2 AA
  - [`../../research/03-design/security-design.md`](../../research/03-design/security-design.md) — OWASP STRIDE
  - [`../../research/03-design/design-docs-rfcs.md`](../../research/03-design/design-docs-rfcs.md) — Ubl (Google design docs); Frazelle (Oxide RFD)
