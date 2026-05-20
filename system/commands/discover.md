---
name: discover
description: Phase 01 — find a problem worth solving and gather evidence it's real, painful, and addressable. Produces a problem statement, an evidence log, an Opportunity Solution Tree, and a proceed/pivot/kill decision.
argument-hint: [segment-or-problem-area]
---

# /discover

## Goal

Land a sharp problem statement, backed by 10–15 customer interviews and a documented riskiest-assumption test, with the team aligned on proceed / pivot / kill.

## Done when

- 10–15 customer interviews completed in last 4 weeks (recorded, transcribed where possible).
- Problem statement (one sentence, `[segment] needs [job], because [insight], but [obstacle]`) survives reading it back to 3 customers.
- Evidence log has ≥ 2 verbatim quotes per major claim.
- Riskiest assumption tested at least once with the cheapest evidence that actually proves it.
- Opportunity Solution Tree (OST) or JTBD canvas drawn with prioritized opportunities (not features).
- Decision (proceed / pivot / kill) written with evidence; team aligned.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

01 — Discover

## Pre-flight

- A working directory exists for this discovery effort. Default: `discovery/<slug>/`.
- The user has named at least a candidate segment or problem area (the command's argument).
- No prior discovery artifact for the same segment exists, OR the user explicitly wants to refresh / extend.

## Dependency Gate

This is the entry phase; gates are minimal. The pass-runner refuses to start unless:

| Artifact | Path | Required by |
|---|---|---|
| Working directory | `discovery/<slug>/` (writable) | All passes |
| Candidate segment | command argument or first user message | Pass 1 |
| Existing discovery artifacts (if refresh) | `discovery/<slug>/decision.md` | Pass 1 (only when `--refresh`) |

If any required artifact is missing, the pass-runner stops and tells the user what to provide. No scoring proceeds.

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
        "standards/process/CUSTOMER_FEEDBACK.md"
      ]
    }
  }
}
```

`short_circuit_threshold` is the score above which a single pass is sufficient — if pass 1 returns ≥ 93, the pass-runner stops without running pass 2.

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Is the problem statement specific (segment, job, insight, obstacle), and are the interview prompts story-based, not leading? |
| 2 | Proof & Safety | Does each major claim have ≥ 2 verbatim quotes traceable to an interview ID, and is the riskiest assumption named with the cheapest evidence that would prove it? |
| 3 | Ship Readiness | Is the proceed/pivot/kill decision documented with evidence and a named accountable owner, and does the OST distinguish tested from untested assumptions? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/process/CUSTOMER_FEEDBACK.md
```

## Sub-agents

```yaml
sub_agents:
  - systems-architect    # reviews problem clarity, refuses premature solutionizing
```

This phase is unusually light on tech specialists. The problem is the artifact. Run a single specialist; the cross-verifier ensures evidence is real.

## Pass-loop dispatch

The pass-runner produces:

1. **Interview plan** (3–5 per week, 2–4 weeks). Story-based prompts ("tell me about the last time you...") — NOT attitudinal ("would you use...?"). Refuses leading questions on review.
2. **Evidence log skeleton** under `discovery/<slug>/evidence-log.md` — running list of quotes, contexts, claims. Each quote tagged with the interview ID.
3. **Problem-statement draft** using the canonical template.
4. **Opportunity Solution Tree (OST)** in Mermaid — desired outcome → opportunities → solutions → assumption tests.
5. **Riskiest-assumption test plan** — the four big risks (value, usability, feasibility, business viability) with the cheapest evidence per risk.
6. **Decision artifact** at `discovery/<slug>/decision.md` — proceed / pivot / kill with evidence.

The pass-runner enforces the anti-patterns:

- No "everyone who uses spreadsheets" segments — too broad.
- No solutions in the problem statement.
- No leading questions in the interview prompts (cross-verifier checks).
- No quantifying before 10 interviews.
- No skipping evidence "because we know our users".

## Output

Artifacts under `discovery/<slug>/`:

- `problem.md` — one-sentence problem statement + segment definition + journey + persona sketch.
- `evidence-log.md` — interview-by-interview log of quotes.
- `ost.md` — Opportunity Solution Tree (Mermaid).
- `riskiest-assumption-tests.md` — what was tested, how, what we learned.
- `decision.md` — proceed / pivot / kill with date and signatories.

Pass-runner returns: artifact paths, interview count, score against the exit checklist, gaps to close before exiting Phase 01.

## Sources

- Handbook: [`../../handbook/01-discover.md`](../../handbook/01-discover.md) (prescriptions and DoD)
- Research:
  - [`../../research/01-ideation/discovery.md`](../../research/01-ideation/discovery.md) — Torres (continuous discovery, OST), Cagan (four big risks), Ries (pivot-or-persevere)
  - [`../../research/01-ideation/user-research.md`](../../research/01-ideation/user-research.md) — NN/g story-based interviews, Nielsen 5-user rule
  - [`../../research/01-ideation/requirements.md`](../../research/01-ideation/requirements.md) — problem-statement, persona, journey-map templates
- Anti-pattern list mirrors handbook's Phase 01 "Anti-patterns" section.
