# ~/.claude — A PDLC-grounded Claude Code system

This repository **is** a `~/.claude` configuration directory. Its root holds the Claude Code workflow (global rules, agents, commands, standards, scripts) and it carries its own evidence base — every prescription here cites a `handbook/` chapter and a `research/` file.

**Last updated:** 2026-06-08.

---

## What this is

A Claude Code configuration that tells Claude how to behave when working on a real software product across the full lifecycle — from problem discovery through production maintenance. Two things make it more than an ad-hoc collection of prompts:

1. **Every standard cites a handbook chapter and a research file.** No invented prescriptions. If a standard says "use trunk-based development", the standard file links the handbook chapter that picks it and the research file that justifies it. See [`MAPPING.md`](MAPPING.md) for the full system-file → handbook → research index.
2. **A multi-pass scoring loop with mandatory cross-verification.** Sub-agents produce findings with evidence; a cross-verifier confirms each claim against its actual source before it is returned. This is the single most effective hallucination control in the system.

---

## The four layers

| Layer | Directory | Style | Audience |
|---|---|---|---|
| **Configuration** | root + `agents/` `commands/` `standards/` `scripts/` | Machine-readable, terse | Claude Code at runtime |
| **Prescription** | [`handbook/`](handbook/) | Single opinionated path | Practitioners reading a chapter |
| **Evidence** | [`research/`](research/) | Descriptive, cited | Anyone wanting to debate a choice |
| **Policy** | [`platform-team/`](platform-team/) | This team's platform rules | Engineers consuming the platform |

The handbook tells a human *what* to do. The research tells a human *why*. The platform-team docs record *our* AWS/ECS/Terraform/GitLab decisions. **The configuration layer tells Claude how to enforce all three.** [`techstacks/`](techstacks/) is a supporting survey of the tool landscape.

---

## Layout

```
~/.claude/                  (this repository)
  CLAUDE.md                 global operating rules (loaded every session)
  MEMORY.md                 index of persistent memory pointers
  MAPPING.md                system file → handbook chapter → research file index
  README.md                 this file
  VISION.md  NOTES.md       project intent and raw decision notes

  agents/                   specialist sub-agents (opus/sonnet/haiku per role)
    pass-runner.md          multi-pass orchestrator (only agent that spawns others)
    cross-verifier.md       hallucination killer — confirms claims against sources
    systems-architect.md    architecture and design review
    security-reviewer.md    OWASP/STRIDE specialist
    qa-engineer.md          testing strategy and test-quality review
    platform-engineer.md    AWS / ECS / Terraform / GitLab CI specialist
    code-reviewer.md        readability, idioms, conventions

  commands/                 one slash command per handbook phase + /review
    discover plan design build test ship run evolve · review
    _shared/                shared command snippets
    _COMMAND_TEMPLATE.md

  standards/                policies referenced by agents and commands
    AGENT_PREAMBLE.md  EVIDENCE.md  QUALITY.md  ANTI_HALLUCINATION.md
    development/ testing/ release/ operations/ security/ platform/
    docs/ process/ frameworks/ checklists/

  lessons/                  durable learned-mistake store (loader input for pass 1)
  scripts/                  context-monitor, audit-log, verify-artifact (pre-output gate)
  settings.example.json     annotated settings template

  handbook/                 prescriptive single-path guide (phases 01–08)
  research/                 cited evidence corpus
    CLAUDE.md               research-authoring rules (scoped to research/)
    sources/SYSTEM.md       analysis of the predecessor ~/.claude.old system
  platform-team/            AWS/ECS/Terraform/GitLab policy for this team
  techstacks/               tool-landscape survey
```

---

## Deployment — this repository *is* `~/.claude`

The recommended model is to make `~/.claude` itself the git checkout, so the running config and the source of truth are the same thing. Runtime state that Claude Code writes into `~/.claude` (history, sessions, projects, tasks, caches) is kept untracked via `.gitignore`; only the configuration and grounding layers are versioned.

After deployment, verify:

```bash
ls ~/.claude/agents/        # 7 agents
ls ~/.claude/commands/      # 9 commands
ls ~/.claude/standards/     # standard categories
```

From any project directory, type `/discover` (or any phase command) in Claude Code to confirm the command is registered. Your live `settings.json` is **user-owned and git-ignored** (it holds machine-specific permission posture) — it is never overwritten by this repo. To adopt the system's hooks and tunables, copy the relevant blocks from the annotated [`settings.example.json`](settings.example.json) template into your own `settings.json`.

---

## Architecture

### Pass-loop scoring

Every command that produces a non-trivial artifact runs through **3 passes by default**, escalating to **5** if an optional framework triggers (security-sensitive code, public API, schema migration, etc.). Each pass:

1. Sub-agents (specialists) produce findings with evidence.
2. `cross-verifier` confirms each claim against the actual source (file/line/URL).
3. A score is computed against the [`QUALITY.md`](standards/QUALITY.md) deduction table.
4. If `score < 85` and passes remain, retry with feedback.

The pass-runner is the only agent allowed to spawn sub-agents. This keeps the pass-loop coherent.

### Evidence as a first-class artifact

Every finding must include evidence in one of three schemas (see [`EVIDENCE.md`](standards/EVIDENCE.md)): `code-finding` (file/line/excerpt/behavior claim), `factual-assertion` (quoted text + source), or `design-claim` (handbook/ADR cited, synthesis vs. sourced separated). Auto-rejection triggers include missing location, dead source, weasel grounding, and restated claims with no evidence.

### Cross-verifier as hallucination killer

Before any pass returns, `cross-verifier` re-reads each cited source and votes `CONFIRMED` / `DOWNGRADED` / `REJECTED` per claim. Rejected claims are dropped; downgraded claims have their confidence lowered and are flagged. It is one piece of a six-layer defense documented in [`standards/ANTI_HALLUCINATION.md`](standards/ANTI_HALLUCINATION.md); the last layer is [`scripts/verify-artifact.sh`](scripts/verify-artifact.sh), a pre-output gate every authored Markdown artifact runs through.

### Model tiering

- **opus**: architecture, security, cross-verification — anywhere reasoning errors compound.
- **sonnet**: implementation, normal review, command orchestration.
- **haiku**: gates, state checks, mechanical transforms.

The pass-runner picks the tier per agent per the criteria in [`AGENT_PREAMBLE.md`](standards/AGENT_PREAMBLE.md).

---

## Phase → command → grounding

| # | Phase | Command | Handbook | Research |
|---|---|---|---|---|
| 01 | Discover | `/discover` | [handbook/01-discover.md](handbook/01-discover.md) | [research/01-ideation/](research/01-ideation/) |
| 02 | Plan | `/plan` | [handbook/02-plan.md](handbook/02-plan.md) | [research/02-planning/](research/02-planning/) |
| 03 | Design | `/design` | [handbook/03-design.md](handbook/03-design.md) | [research/03-design/](research/03-design/) |
| 04 | Build | `/build` | [handbook/04-build.md](handbook/04-build.md) | [research/04-development/](research/04-development/) |
| 05 | Test | `/test` | [handbook/05-test.md](handbook/05-test.md) | [research/05-testing/](research/05-testing/) |
| 06 | Ship | `/ship` | [handbook/06-ship.md](handbook/06-ship.md) | [research/06-release/](research/06-release/) |
| 07 | Run | `/run` | [handbook/07-run.md](handbook/07-run.md) | [research/07-operations/](research/07-operations/) |
| 08 | Evolve | `/evolve` | [handbook/08-evolve.md](handbook/08-evolve.md) | [research/08-maintenance/](research/08-maintenance/) |
| — | Review | `/review` | (cross-cutting) | `platform-team/engineering-policy.md` §8 |

The first trip through 01 → 08 is the idea-to-loved-product journey; afterward it is a continuous 01 ↔ 08 loop. Every command runs through `pass-runner`, which loads the standards relevant to the phase.

---

## Grounding and traceability

Each standard ends with a **Sources** section citing the handbook chapter and research file(s) that justify it. The full index is [`MAPPING.md`](MAPPING.md). The rule: **if a standard has no upstream source in `handbook/`, `research/`, or `platform-team/`, it is not allowed in this system — add the source first.**

To diverge from a prescription: read the standard's Sources, read the cited handbook chapter and research file, then edit the standard and add a `**Local override:**` block explaining why. Update `MAPPING.md` so the divergence stays visible. Do not silently edit prescriptions — the traceability is what makes the system trustworthy over time.

Research authoring (anything under `research/`) follows the stricter evidence rules in [`research/CLAUDE.md`](research/CLAUDE.md): verified sources only, explicit uncertainty tags (`[VERIFIED]` / `[SYNTHESIS]` / `[UNVERIFIED]` / `[CONTESTED]` / `[OUT OF DATE]`), no fabrication.

---

## Scope

The handbook and research target **modern web-based software products** (SaaS, web apps, API-first) built by teams of 2–20 growing through post-PMF, cloud-native, on Git and modern CI/CD. The *principles* transfer to embedded, safety-critical, or regulated contexts, but many *specifics* (release cadence, testing rigor, documentation formality) will not. The `platform-team/` policy is concrete to this team's stack: AWS, ECS-on-EC2, Terraform, GitLab.

---

## Predecessor

This system is a deliberately leaner successor to `~/.claude.old/`: 7 agents (vs. 22), 9 commands (vs. 30+), ~40 standards each citing a source, one pass-loop pattern. For the full inventory and analysis of the predecessor, see [`research/sources/SYSTEM.md`](research/sources/SYSTEM.md).
