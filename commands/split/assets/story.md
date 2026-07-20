# {STORY_ID}: {title}

| Field | Value |
|-------|-------|
| id | {STORY_ID} |
| epic | {EPIC_ID} |
| type | {Story \| Task \| Sub-task} |
| estimateHours | ~1 (target the low end of the 1-2h band; see `standards/process/TASK_SIZING.md`) |
| dependencies | {[story-id, story-id] or none} |

`title` is this file's H1. `path` is this file's location, recorded in `execution-plan.json`. The `epic` field carries the bare parent epic id ({EPIC_ID}); the epic name ({EPIC_NAME}) belongs in prose, not in the field value. Field names above match the story object in `execution-plan.schema.json`.

## Goal

{One paragraph: the single behavior this story delivers and why. A thin vertical slice, not a layer of plumbing.}

## Scope

### Included

{What is in scope - the one behavior and the file or module it touches.}

### Excluded

{What is deliberately out of scope - deferred to another story or explicitly not this release.}

## Acceptance Criteria

One primary criterion per story (see `standards/process/TASK_SIZING.md` - "each leaf has one acceptance criterion"). Add a second only for an unavoidable error or edge path; if you need more, the story is a bundle and must be split.

- **given** {PRECONDITION}
  **when** {ACTION}
  **then** {EXPECTED_RESULT}

## Implementation Steps

> Steps describe behavioral contracts, not pseudocode. Each step names what to create, configure, or wire - not how to code it.

Step patterns:

1. **Create** {component} - {what it does} ({file path})
2. **Configure** {component} - {settings and their values}
3. **[WIRE]** Connect {A} to {B} - A calls B.{method}() during {lifecycle stage}
4. **Validate** {behavior} - {verification command or test}

Use the `[WIRE]` prefix for any step that connects two components. A wire step must name:

- **Caller:** which component initiates the connection
- **Callee:** which component receives the call
- **Method:** the specific method or function called
- **Lifecycle stage:** when the connection happens (startup, initialization, on-demand)

Anti-patterns:

| Pattern | Problem | Fix |
|---------|---------|-----|
| `"Add import for X, call X.doThing() on line 42"` | Pseudocode - too implementation-specific | `"[WIRE] Connect Controller to Service - Controller calls Service.process() during request handling"` |
| `"Wire up the server"` | Vague - no caller/callee/method | `"[WIRE] Connect Daemon to McpServer - Daemon calls McpServer.start() during startup"` |
| `"Start the components"` | Missing lifecycle - when does this happen? | `"[WIRE] Connect Main to Server - Main calls Server.listen() after all providers are registered"` |

{NUMBERED_STEPS}

## Sub-tasks

_Only when the verified estimate exceeds the 2h ceiling in `standards/process/TASK_SIZING.md` and the story was split. Otherwise delete this section. Sub-task ids use the parent id plus a letter suffix._

| id | title | estimateHours |
|----|-------|---------------|
| {STORY_ID}a | {SUBTASK_TITLE} | {HOURS} |
| {STORY_ID}b | {SUBTASK_TITLE} | {HOURS} |

## Definition of Done

- [ ] {FUNCTIONAL_CRITERIA - the acceptance criterion above is met}
- [ ] {QUALITY_CRITERIA - tests written and passing, self-reviewed}
- [ ] {INTEGRATION_CRITERIA - wired components verified end-to-end}

## Verification Commands

```bash
{COMMANDS_TO_VERIFY}
```
