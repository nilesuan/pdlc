# _shared/pipeline-handoff.md

How the pass-runner hands values to sub-agents. **Sub-agents do not read `.pipeline.json` directly.** The pass-runner reads it and inlines the relevant fields into each sub-agent's brief. This keeps each sub-agent's context budget small.

## What goes in `.pipeline.json`

```json
{
  "command": "build",
  "phase": "04",
  "task": "Add idempotency-key support to POST /payments",
  "standards_to_load": [
    "standards/AGENT_PREAMBLE.md",
    "standards/EVIDENCE.md",
    "standards/QUALITY.md",
    "standards/development/TDD.md",
    "standards/development/CODE_REVIEW.md",
    "standards/security/OWASP.md"
  ],
  "sub_agents": ["code-reviewer", "qa-engineer", "security-reviewer"],
  "max_passes": 3,
  "pass": 1,
  "previous_score": null,
  "open_findings": [],
  "feature_flags": {
    "tdd_strict": true,
    "coverage_floor": 0.80
  }
}
```

## What the pass-runner inlines per sub-agent

For each sub-agent, build a tailored brief:

```
You are <agent>. Phase 04 (Build).

Task: <task verbatim>

Load standards:
- AGENT_PREAMBLE.md
- EVIDENCE.md
- <agent-specific standards>

Files in scope:
- <list of changed files with line ranges>

Previous-pass findings to verify or close:
- <only those addressed to this agent>

Return findings per EVIDENCE.md. Honor your finding-ID prefix.
```

The full `.pipeline.json` is **not** in the brief. Only the fields the sub-agent needs.

## Why

- Sub-agents loading the full pipeline JSON pollutes their context with fields they don't use.
- The pass-runner is the single source of truth for orchestration state. Sub-agents reading the pipeline directly creates two readers and races.
- Keeping briefs small means more headroom for the actual review.
