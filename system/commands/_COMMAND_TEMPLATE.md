# _COMMAND_TEMPLATE.md

Template for new slash commands. Copy this, rename to `<command>.md`, fill in.

```yaml
---
name: <command>
description: <one sentence — what does this command do, what does the user get>
argument-hint: <optional — what args does the command take>
---
```

## Goal

One sentence. What outcome does this command produce?

## Done when

3–6 bullet points. Concrete and observable. Always include:

- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

Which handbook phase (01–08 or "review" or "cross-cutting")?

## Pre-flight

What must be true before this command runs? Examples:
- Working tree clean (or staged changes captured)
- Feature branch checked out (not main)
- No `.pipeline.json` from a prior incomplete run

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - <phase-specific standards>
```

## Sub-agents

```yaml
sub_agents:
  - <agent-name>     # what they review
  - <agent-name>
```

## Pass-loop dispatch

```
1. Write cdocs/.pipeline.json with the brief above.
2. Spawn pass-runner.
3. Read result; present to user.
```

(See [`_shared/pass-loop.md`](_shared/pass-loop.md).)

## Output

Where does the artifact land? What does the user see?

## Sources

- Handbook chapter: `../../handbook/NN-<phase>.md`
- Research files: `../../research/NN-<phase>/<files>.md`
- Standards encoded: list each standard in the load list with the source it cites.
