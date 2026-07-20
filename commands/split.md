---
name: split
description: Cross-cutting bridge that decomposes a release plan's backlog and roadmap into epics and build-ready ~1h stories, sequenced into a wave execution plan for /build.
argument-hint: [release-name]
---

# /split

## Goal

Turn the tracked plan under `planning/<release-name>/` (backlog + roadmap, optionally design ADRs) into epics and thin, self-contained ~1h stories, each a build-ready unit for `/build`, plus a wave execution plan that orders them by dependency.

## Done when

- Every prioritized backlog item in `planning/<release-name>/` is decomposed into an epic (`epic.md`) with a story table, and every leaf into a story file under `planning/<release-name>/stories/`.
- Every story targets ~1 hour (the low end of the 1-2 hour band in [`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md)), is a thin vertical slice with one primary acceptance criterion, names the file or module it touches, and is self-contained enough to hand to `/build` on its own.
- The mandatory TASK_SIZING verification pass has been run: stories over the 2-hour ceiling are split into sub-tasks (`NNNa`/`NNNb`), stories under the 30-minute floor are bundled, and any genuine oversize is a documented exception with reason, realistic estimate, risks of oversize, and accountable-owner acknowledgement.
- Story dependencies form a DAG (no cycles) grouped into dependency-ordered waves; `stories/execution-plan.json` validates against [`split/assets/execution-plan.schema.json`](split/assets/execution-plan.schema.json).
- Each story carries Acceptance Criteria in given/when/then and Verification Commands; no JIRA artifacts are emitted (no import file, no custom fields, dependencies are a plain list of story ids).
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol - see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

Cross-cutting - bridges /plan (Phase 02) and /build (Phase 04). Consumes the plan; emits the units build implements.

## Pre-flight

- `/plan` has completed for this release: `planning/<release-name>/` exists with `backlog.md`, `roadmap.md`, and `mvp.md`.
- Working tree clean (or in-flight changes captured). On a feature branch, not main.
- No stale `cdocs/.pipeline.json` from a prior incomplete run.

## Dependency Gate

The pass-runner refuses to start unless every required row is satisfied:

| Artifact | Path | Required by |
|---|---|---|
| Prioritized backlog | `planning/<release-name>/backlog.md` | Pass 1 (scope to decompose into stories) |
| Now/Next/Later roadmap | `planning/<release-name>/roadmap.md` | Pass 1 (epic and wave sequencing) |
| MVP scope | `planning/<release-name>/mvp.md` | Pass 1 (in-scope vs out-of-scope boundaries) |
| Design ADR (when a story touches a load-bearing decision) | `docs/adr/NNNN-*.md` | Pass 1 (optional; the reference is carried into each build unit) |

If a required row is missing: STOP. Suggest "Run `/plan <release-name>` first."

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
    },
    "qa-engineer": {
      "model": "sonnet",
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
| 1 | Correctness | Is every backlog item decomposed into epics and thin vertical-slice stories, each targeting ~1h (low end of the 1-2h band per [`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md)) with exactly one primary acceptance criterion and the file or module it touches named? |
| 2 | Proof & Safety | Has the mandatory TASK_SIZING verification pass re-walked every leaf, splitting anything over the 2h ceiling into sub-tasks (`NNNa`/`NNNb`), bundling anything under the 30-minute floor, documenting any exception, and are acceptance criteria testable given/when/then? |
| 3 | Ship Readiness | Do story dependencies form a DAG with no cycles, are stories grouped into dependency-ordered waves, is each story a self-contained build-ready unit for `/build` with Verification Commands, and does `execution-plan.json` validate against the schema? |

## Story sizing

[`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md) is authoritative for leaf-task sizing. `/split` does not restate it; it applies it with one calibration:

- **Target ~1 hour per story - the low end of TASK_SIZING's 1-2 hour band.** Each story is a thin vertical slice with exactly one primary acceptance criterion and names the file or module it touches (TASK_SIZING "Initial decomposition": slice vertically, one acceptance criterion per leaf, pin the file/module).
- **The 2-hour ceiling is hard.** A story whose verified estimate exceeds 2 hours is split into sub-tasks with letter suffixes (`NNNa`, `NNNb`), never stretched. Sub-tasks appear in the story's Sub-tasks section and in `execution-plan.json` under `subtasks`.
- **The 30-minute floor is hard.** A story under ~30 minutes is bundled into the adjacent story it depends on, per TASK_SIZING's bundling heuristics.
- **The verification pass is mandatory and non-skippable.** Pass 2 re-walks every leaf and re-asks the 1-2 hour question. Inflated estimates are split, collapsed estimates are bundled, and anything that genuinely cannot be made to fit is surfaced as a documented exception with reason, realistic estimate, risks of oversize, and accountable-owner acknowledgement.

Aiming at ~1h is a target inside the band, not a replacement for it: the ceiling, floor, and verification pass TASK_SIZING mandates all still apply.

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
  - systems-architect    # dependency sequencing, wave DAG, no cycles
  - qa-engineer          # acceptance-criteria testability (given/when/then)
```

## Pass-loop dispatch

```
1. Write cdocs/.pipeline.json with the brief above (command: split, phase:
   cross-cutting, task: user's request verbatim, standards_to_load, sub_agents,
   max_passes). The pass-runner reads it and inlines per-agent briefs; sub-agents
   do NOT read .pipeline.json directly.
2. Spawn pass-runner.
3. Read result; present to user.
```

(See [`_shared/pass-loop.md`](_shared/pass-loop.md) and [`_shared/pipeline-handoff.md`](_shared/pipeline-handoff.md).)

Pass-runner produces, in order:

1. `planning/<release-name>/stories/execution-plan.json` - the machine-readable wave plan; validates against [`split/assets/execution-plan.schema.json`](split/assets/execution-plan.schema.json).
2. `planning/<release-name>/stories/NNN-epic-name/epic.md` per epic (template [`split/assets/epic.md`](split/assets/epic.md)).
3. `planning/<release-name>/stories/NNN-epic-name/NNN-story-name.md` per story (template [`split/assets/story.md`](split/assets/story.md)).

Numbering: epic folders `001-`, `002-`; story files `001-`, `002-` reset per epic; lowercase kebab-case.

## Output

Tracked artifacts under `planning/<release-name>/stories/`, alongside the other phase directories `/plan` writes. Pass-runner returns artifact paths, the score against the exit checklist, epic/story/wave counts, and any oversize exceptions the user must acknowledge. Each story is a build-ready unit: hand a single story file plus its design ADR to `/build`.

## Sources

- Handbook: [`../handbook/02-plan.md`](../handbook/02-plan.md) - the plan this command decomposes (backlog, roadmap, leaf sizing).
- Standard: [`../standards/process/TASK_SIZING.md`](../standards/process/TASK_SIZING.md) - authoritative leaf-task sizing and the mandatory verification pass; `/split` targets its low-end ~1h.
- Upstream producer: [`plan.md`](plan.md) - writes `planning/<release-name>/`. Downstream consumer: [`build.md`](build.md) - implements one story per unit.
- Predecessor command shape (epic/story/wave decomposition, `[WIRE]` steps): `~/.claude.old/commands/split.md` (JIRA machinery removed in this port).
