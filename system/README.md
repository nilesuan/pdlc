# system/ — A PDLC-grounded Claude Code workflow

A Claude Code workflow configuration (agents, commands, standards, hooks) whose every prescription is grounded in this repository's [`handbook/`](../handbook/) and [`research/`](../research/).

**Last updated:** 2026-04-26

---

## What this is

A **Claude Code workflow system** designed to be installed into `~/.claude/`. It tells Claude how to behave when working on a real software product across the full lifecycle — from problem discovery through production maintenance.

Two things make it different from an ad-hoc collection of agents and prompts:

1. **Every standard cites a handbook chapter and a research file.** No invented prescriptions. If a standard says "use trunk-based development", the standard file links the handbook chapter that picks it and the research file that justifies it. See [`MAPPING.md`](MAPPING.md) for the full system-file → handbook → research index.
2. **A multi-pass scoring loop with mandatory cross-verification.** Sub-agents produce findings with evidence; a cross-verifier confirms claims against actual sources before they're returned. This is the same pattern used in `~/.claude.old/` and is documented as the most effective hallucination defense across many sessions of dogfooding.

---

## How this relates to the rest of the repo

| Layer | Directory | Style | Audience |
|---|---|---|---|
| Evidence | [`research/`](../research/) | Descriptive, cited | Researchers, anyone wanting to debate a choice |
| Prescription | [`handbook/`](../handbook/) | Single opinionated path | Practitioners reading a chapter |
| Configuration | `system/` (this dir) | Machine-readable, terse | Claude Code at runtime |

The handbook tells a human what to do. The research tells a human why. **`system/` tells Claude how to enforce it.**

---

## Layout

```
system/
  README.md              this file
  CLAUDE.md              global rules (lives at ~/.claude/CLAUDE.md after install)
  MEMORY.md              global memory pointers
  MAPPING.md             system file → handbook chapter → research file index

  agents/                specialist sub-agents (sonnet/opus/haiku per role)
    pass-runner.md       multi-pass orchestrator
    cross-verifier.md    hallucination killer — confirms claims against sources
    systems-architect.md architecture and design-review
    security-reviewer.md OWASP/STRIDE specialist
    qa-engineer.md       testing strategy and test-quality reviewer
    platform-engineer.md AWS / ECS / Terraform / GitLab CI specialist
    code-reviewer.md     readability, idioms, conventions

  commands/              one slash command per handbook phase + /review
    discover.md          /discover  — phase 01
    plan.md              /plan      — phase 02
    design.md            /design    — phase 03
    build.md             /build     — phase 04
    test.md              /test      — phase 05
    ship.md              /ship      — phase 06
    run.md               /run       — phase 07
    evolve.md            /evolve    — phase 08
    review.md            /review    — cross-verifier-led PR review
    _shared/             shared command snippets
      pass-loop.md
      pipeline-handoff.md
      evidence-format.md
    _COMMAND_TEMPLATE.md template for new commands

  standards/             policies referenced by agents and commands
    AGENT_PREAMBLE.md    non-negotiables loaded by every agent
    EVIDENCE.md          claim schemas and auto-rejection triggers
    QUALITY.md           85/100 quality gate, deduction table, coverage rules

    development/
      TRUNK_BASED.md
      TDD.md
      SOLID.md
      CLEAN_ARCHITECTURE.md
      CODE_REVIEW.md

    testing/
      TEST_STRATEGY.md

    release/
      CONTINUOUS_DELIVERY.md
      DEPLOYMENT_PIPELINE.md
      CONTAINER_TAGGING.md
      VERSIONING.md

    operations/
      OBSERVABILITY.md
      ON_CALL.md

    security/
      OWASP.md
      AUTH.md

    platform/
      AWS_ECS_TERRAFORM.md
      TERRAFORM_DISCIPLINE.md
      GITLAB_SECURITY.md
      AUTO_MERGE.md
      AWS_NAMING.md

    docs/
      ADR.md
      DIATAXIS.md

    checklists/          phase-exit checklists distilled from handbook DoDs
      01-discover-exit.md
      02-plan-exit.md
      03-design-exit.md
      04-build-exit.md
      05-test-exit.md
      06-ship-exit.md
      07-run-exit.md
      08-evolve-exit.md

  scripts/
    context-monitor.sh   status-line script (model, context %, cost)
    audit-log.sh         append-only tool-use log (rotates at 1MB)

  settings.example.json  example ~/.claude/settings.json with hooks wired
```

---

## Installation

1. Copy the contents of this directory into `~/.claude/`:

   ```bash
   cp -r system/* ~/.claude/
   cp system/settings.example.json ~/.claude/settings.json
   chmod +x ~/.claude/scripts/*.sh
   ```

2. Edit `~/.claude/settings.json` — adjust paths, MCP allow-lists, and any hooks you don't want.

3. Verify install:

   ```bash
   ls ~/.claude/agents/        # should list 7 agents
   ls ~/.claude/commands/      # should list 9 commands
   ls ~/.claude/standards/     # should list standard categories
   ```

4. From any project directory, type `/discover` (or any phase command) in Claude Code to confirm the command is registered.

The `system/` directory in this repo remains the **source of truth**. Re-syncing your home dir from this repo is the recommended way to update.

---

## Architecture

### Two lifecycles, one orchestrator

The system separates the **product lifecycle** (handbook phases 01–08) from the **engineering sublifecycle** (a typical task: pick problem → solve → split into PRs → build → review → ship). They share the same orchestrator (`pass-runner`) and the same scoring engine.

### Pass-loop scoring

Every command that produces a non-trivial artifact runs through **3 passes by default**, escalating to **5** if an optional framework triggers (security-sensitive code, public API, schema migration, etc.). Each pass:

1. Sub-agents (specialists) produce findings with evidence.
2. `cross-verifier` confirms each claim against the actual source (file/line/URL).
3. A score is computed against the [`QUALITY.md`](standards/QUALITY.md) deduction table.
4. If `score < 85` and passes remaining, retry with feedback.

The pass-runner is the only agent allowed to spawn sub-agents. This keeps the pass-loop coherent.

### Evidence as a first-class artifact

Every finding from a sub-agent must include evidence in one of three schemas (see [`EVIDENCE.md`](standards/EVIDENCE.md)):

- **`code-finding`** — file path, line numbers, code excerpt, claim about behavior
- **`factual-assertion`** — quoted text, source URL or doc path, page/section
- **`design-claim`** — handbook chapter or ADR cited, the part of the claim that's synthesis vs. directly sourced

Auto-rejection triggers (no review needed) include: missing location, dead source, weasel grounding ("typically", "industry-standard"), restated claim with no evidence, impossible location.

### Cross-verifier as hallucination killer

Before any pass returns, `cross-verifier` re-reads each cited source and votes `CONFIRMED` / `DOWNGRADED` / `REJECTED` per claim. Rejected claims are dropped from the finding set. Downgraded claims have their confidence lowered and are flagged for the user. This is the single most effective control in the system; it is not optional.

### Anti-hallucination

The cross-verifier is one piece of a six-layer defense-in-depth protocol. The full stack (CLAUDE.md truthfulness rules → AGENT_PREAMBLE non-negotiables → pre-output evidence checks → EVIDENCE.md claim schemas → cross-verifier audit → `scripts/verify-artifact.sh` pre-output gate) is documented in [`standards/ANTI_HALLUCINATION.md`](standards/ANTI_HALLUCINATION.md). Each layer catches a different failure mode; the layered design exists because no single check catches everything. The pre-output gate is the last line: every authored Markdown artifact runs through `scripts/verify-artifact.sh` before the pass-runner reports completion.

### Model tiering

- **opus**: architecture, security, cross-verification, anything where reasoning errors compound
- **sonnet**: implementation, normal review, command orchestration
- **haiku**: gates, state checking, mechanical transforms (lint, format, simple validation)

The pass-runner picks the tier per agent based on the criteria in [`AGENT_PREAMBLE.md`](standards/AGENT_PREAMBLE.md).

---

## Phase → command mapping

| # | Phase | Command | Primary handbook chapter | Primary specialist agent |
|---|---|---|---|---|
| 01 | Discover | `/discover` | `handbook/01-discover.md` | systems-architect |
| 02 | Plan | `/plan` | `handbook/02-plan.md` | systems-architect |
| 03 | Design | `/design` | `handbook/03-design.md` | systems-architect |
| 04 | Build | `/build` | `handbook/04-build.md` | code-reviewer + qa-engineer |
| 05 | Test | `/test` | `handbook/05-test.md` | qa-engineer |
| 06 | Ship | `/ship` | `handbook/06-ship.md` | platform-engineer |
| 07 | Run | `/run` | `handbook/07-run.md` | platform-engineer |
| 08 | Evolve | `/evolve` | `handbook/08-evolve.md` | systems-architect |
| — | Review | `/review` | (cross-cutting) | cross-verifier + code-reviewer |

Every command runs through `pass-runner`, which loads the relevant standards based on the phase.

---

## Standards index

Each standard file ends with a "Sources" section that cites the handbook chapter and research file(s) that justify it.

**Foundational** (loaded by every agent)
- [`AGENT_PREAMBLE.md`](standards/AGENT_PREAMBLE.md) — non-negotiables
- [`EVIDENCE.md`](standards/EVIDENCE.md) — claim schemas
- [`QUALITY.md`](standards/QUALITY.md) — scoring rubric

**Development** (Phase 04)
- `TRUNK_BASED.md`, `TDD.md`, `SOLID.md`, `CLEAN_ARCHITECTURE.md`, `CODE_REVIEW.md`

**Testing** (Phase 05)
- `TEST_STRATEGY.md`

**Release** (Phase 06)
- `CONTINUOUS_DELIVERY.md`, `DEPLOYMENT_PIPELINE.md`, `CONTAINER_TAGGING.md`, `VERSIONING.md`

**Operations** (Phase 07)
- `OBSERVABILITY.md`, `ON_CALL.md`

**Security** (cross-cutting, weighted in Phase 04 and 06)
- `OWASP.md`, `AUTH.md`

**Platform** (the user's actual production stack)
- `AWS_ECS_TERRAFORM.md`, `TERRAFORM_DISCIPLINE.md`, `GITLAB_SECURITY.md`, `AUTO_MERGE.md`, `AWS_NAMING.md`

**Docs**
- `ADR.md`, `DIATAXIS.md`

---

## Customizing

The system is opinionated but every prescription is traceable. To diverge:

1. Read the standard's "Sources" section.
2. Read the cited handbook chapter and research file.
3. Edit the standard. Add a `**Local override:**` block explaining why this team chose differently.
4. Update [`MAPPING.md`](MAPPING.md) so the divergence is visible.

Do **not** silently edit prescriptions. The traceability is what makes the system trustworthy over time.

---

## Comparison to `~/.claude.old/`

This system is a deliberately leaner successor:

- 7 agents (vs. 22). The roles that survived are the ones the dogfooding evidence in `cdocs/` showed actual reach for.
- 9 commands (vs. 30+). One per handbook phase plus `/review`. No experimental or duplicate commands.
- ~25 standards (vs. 30+). Every one cites a handbook chapter; nothing freestanding.
- Single pass-loop pattern. The old system accumulated multiple orchestration patterns over time; this one starts with one.

For a full inventory and analysis of the predecessor, see [`../SYSTEM.md`](../SYSTEM.md).
