---
name: solve
description: Phase 02.5 — turn a problem into a proven solution plan. Classifies the load-bearing decisions, eliminates on hard constraints, researches candidates, runs pre-registered bake-offs, and emits selection ADRs backed by measured evidence.
argument-hint: [problem-name-or-slug]
---

# /solve

## Goal

Produce a solution plan whose load-bearing technology and architecture decisions are each backed by a measured result against a threshold declared before the measurement was taken, so `/design` and `/split` can build on them without re-litigating them.

## Done when

- Every decision the solution depends on is listed in `solutions/<slug>/decision-register.md` and classified load-bearing / reversible / routine per [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) §"Decision classes".
- Hard constraints are written in `solutions/<slug>/constraints.md` **before** any candidate list, and every candidate eliminated by one is recorded with the constraint that killed it.
- Every load-bearing decision carries Tier 3 evidence (our workload, our data, pre-registered threshold), or a recorded reason why a lower tier is sufficient.
- Every spike has a pre-registration record written before its code, and a result appended after: `solutions/<slug>/spikes/<decision-slug>.md`.
- Every load-bearing decision has a selection ADR under `docs/adr/` with Alternatives carrying measured values, an Evidence table with tier tags, and a Reversal cost section.
- Spike harnesses are promoted into the repo's test tree as regression gates, not discarded.
- `solutions/<slug>/solution-plan.md` exists and is consumable by `/design` (architecture shape) and `/split` (story decomposition).
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

02.5 — Cross-cutting bridge. Consumes a validated problem; emits the decisions `/design` and `/split` depend on.

## Pre-flight

- A problem statement exists, either from `/discover` + `/plan` or as a written brief when the problem is purely technical.
- A working directory exists for this effort. Default: `solutions/<slug>/`.
- The user can name at least one hard constraint, or has explicitly confirmed there are none. "None" is a claim and gets recorded as one.
- Working tree clean. On a feature branch, not main.
- No stale `cdocs/.pipeline.json` from a prior incomplete run.

## Dependency Gate

The pass-runner refuses to start unless every required row is satisfied:

| Artifact | Path | Required by |
|---|---|---|
| Problem statement | `discovery/<slug>/problem.md`, or a written brief in the command invocation | Pass 1 |
| MVP scope, **when `/plan` has run for this work** | `planning/<release>/mvp.md` | Pass 1 (scope boundary for what must be decided now) |
| Discovery decision = proceed, **when `/discover` has run** | `discovery/<slug>/decision.md` | Pass 1 |
| Representative workload or corpus | named in the brief; path recorded in `constraints.md` | Pass 2 (no spike without one) |
| Named accountable owner | recorded in `decision-register.md` | Pass 3 |

Where `/discover` and `/plan` artifacts exist, they are required. `/solve` is a bridge, not a bypass: it does not license skipping problem validation on a product build. A purely technical problem with no product-discovery phase may enter here with a written brief.

If Pass 2's representative workload is missing, the pass-runner stops and asks for it. A bake-off on unrepresentative input produces a number that decides nothing (per [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) §"Anti-patterns").

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
        "standards/docs/ADR.md",
        "standards/docs/TECH_SELECTION.md",
        "standards/development/PRINCIPLES.md"
      ]
    },
    "qa-engineer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/docs/TECH_SELECTION.md",
        "standards/testing/TEST_STRATEGY.md",
        "standards/frameworks/EXPERIMENTATION.md"
      ]
    },
    "platform-engineer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/docs/TECH_SELECTION.md",
        "standards/platform/AWS_ECS_TERRAFORM.md",
        "standards/release/CONTINUOUS_DELIVERY.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/docs/TECH_SELECTION.md",
        "standards/security/OWASP.md",
        "standards/frameworks/STRIDE_THREAT_MODELING.md"
      ]
    }
  },
  "evidence_base": [
    "techstacks/"
  ]
}
```

`force_model: opus` on all four: a wrong load-bearing selection is discovered during the migration it forces. `qa-engineer` is escalated to opus in this phase because it owns the acceptance thresholds, and a threshold that measures the wrong thing is the failure mode this whole command exists to prevent.

`evidence_base` wires [`../techstacks/`](../techstacks/) in as the Tier 1 desk-research corpus. Where it has no coverage of the domain, that gap is itself a finding: it means Tier 1 evidence must come from external sources under [`../standards/EVIDENCE.md`](../standards/EVIDENCE.md) schema 2, and it raises the case for going straight to Tier 3.

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Framing | Is the decision list complete and correctly classified, are the hard constraints written before any candidate list, and has constraint elimination been applied before anything was benchmarked? |
| 2 | Proof | Does every load-bearing decision have a pre-registered spike with one primary metric and a threshold declared before results, run on a representative workload, with disqualifications recorded as results? |
| 3 | Handoff | Does every selection ADR carry measured alternatives, tier-tagged evidence, and a reversal cost, are the spike harnesses promoted to regression gates, and can `/design` and `/split` consume the plan without re-opening the decisions? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/docs/ADR.md
  - standards/docs/TECH_SELECTION.md
  - standards/development/PRINCIPLES.md
  - standards/frameworks/EXPERIMENTATION.md
  - standards/testing/TEST_STRATEGY.md
  - standards/checklists/02.5-solve-exit.md   # the exit gate this command is scored against
```

## Sub-agents

```yaml
sub_agents:
  - systems-architect    # decision framing, architecture options, selection ADRs (opus)
  - qa-engineer          # bake-off harness, acceptance thresholds, regression promotion (opus)
  - platform-engineer    # operational fit, run cost, deployment consequence of each candidate (opus)
  - security-reviewer    # data residency, licence, supply chain, regulated-data handling (opus)
```

The security pass is not optional and it runs in Pass 1, not at the end. Residency, licence, and regulated-data constraints eliminate candidates before benchmarking, and discovering them afterwards wastes the entire spike (per [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) §"Constraint-first ordering").

## Pass-loop dispatch

Pass-runner produces, in order:

1. **Constraints** at `solutions/<slug>/constraints.md`: hard constraints with their source, written before candidates exist. Residency and regulated-data rules first.
2. **Decision register** at `solutions/<slug>/decision-register.md`: every decision, its class, its owner, its status, and the ADR number once filed.
3. **Candidate shortlists**: two to four survivors per load-bearing decision, with every elimination attributed to the constraint that caused it.
4. **Spike pre-registrations** at `solutions/<slug>/spikes/<decision-slug>.md`, written before spike code.
5. **Spike results** appended to the same file: measured primary metric against the pre-registered threshold, guardrails, and the decision.
6. **Selection ADRs** under `docs/adr/`, sharing the design-ADR number sequence, per [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) §"The selection ADR".
7. **Regression harnesses** promoted from spike code into the repo's test tree, wired to run in CI. Where the chosen component is probabilistic (model, LLM, OCR, classifier, embedding), the `probabilistic-components` trigger fires and the spike's corpus and thresholds become the artifacts required by [`../standards/frameworks/PROBABILISTIC_COMPONENTS.md`](../standards/frameworks/PROBABILISTIC_COMPONENTS.md).
8. **Solution plan** at `solutions/<slug>/solution-plan.md`: the chosen approach end to end, with each component pointing at the ADR that chose it and the gate that holds it.

Pass-runner enforces:

- Threshold set or moved after results were seen: blocker.
- Load-bearing decision on Tier 0 or Tier 1 evidence with no stated exemption: blocker.
- Candidate benchmarked despite failing a hard constraint: major, and the spike result is discarded as unusable.
- Single-candidate "selection" with no recorded disqualification of alternatives: major.
- Alternatives rejected without the measured value that rejected them: major.
- Spike code discarded rather than promoted to a regression gate: minor.
- Decision register with unclassified entries: major — an unclassified decision has no evidence bar to clear.
- Scope inflation: a routine decision escalated to a bake-off is a minor finding, per [`../CLAUDE.md`](../CLAUDE.md) §6 (match verification effort to stakes).

## Output

Artifacts under `solutions/<slug>/` and `docs/adr/`. Pass-runner returns:

- Path to the solution plan.
- Paths to every selection ADR written, with its decision class and evidence tier.
- The table of primary metrics: decision, threshold, measured value, verdict.
- Decisions that remain open, with what each is blocked on.
- Score against exit checklist ([`../standards/checklists/02.5-solve-exit.md`](../standards/checklists/02.5-solve-exit.md)); gaps listed.

Hand off to `/design <name>` for architecture shape, C4, data model, API contract, and threat model. `/design` consumes the selection ADRs rather than re-opening them.

## Sources

- Handbook: [`../handbook/02.5-solve.md`](../handbook/02.5-solve.md). The chapter declares its own weaker grounding: no `research/` document covers technology-selection method, so the discipline is assembled from adjacent verified sources. Recorded in [`../MAPPING.md`](../MAPPING.md).
- Standards:
  - [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) — decision classes, evidence tiers, bake-off protocol, selection-ADR format
  - [`../standards/docs/ADR.md`](../standards/docs/ADR.md) — Nygard record format and hard rules
  - [`../standards/frameworks/EXPERIMENTATION.md`](../standards/frameworks/EXPERIMENTATION.md) — pre-registration, one primary metric, no peeking, HARKing
- Research:
  - [`../research/03-design/adrs.md`](../research/03-design/adrs.md) — Nygard ADRs, decision-record practice
  - [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) — riskiest-assumption test; cheapest evidence that actually proves it
  - [`../research/02-planning/prioritization.md`](../research/02-planning/prioritization.md) — Cost of Delay as the frame for reversal cost
- Evidence base: [`../techstacks/`](../techstacks/) — tool-landscape survey, Tier 1 desk research, with [`../techstacks/00-methodology.md`](../techstacks/00-methodology.md) supplying the source hierarchy and claim tagging.
