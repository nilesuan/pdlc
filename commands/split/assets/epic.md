# Epic {EPIC_ID}: {name}

| Field | Value |
|-------|-------|
| id | {EPIC_ID} |
| name | {name} |
| summary | {one-to-three sentence statement of what this epic delivers; populates epics[].summary in execution-plan.json} |
| path | {path to this epic.md, relative to the release directory; populates epics[].path} |

## Goal

{What this epic delivers - scope, key outcomes, and boundaries. 2-4 sentences. Trace it to the backlog/roadmap theme it comes from.}

## Stories

| id | title | estimateHours | dependencies |
|----|-------|---------------|--------------|
| {STORY_ID} | {STORY_TITLE} | ~1 | {[story-id, story-id] or none} |
| {STORY_ID} | {STORY_TITLE} | ~2 | {[story-id] or none} |

Total: {N} stories, ~{TOTAL_HOURS} hours.

## Exceptions

_Only when a story genuinely cannot be reduced under the 2h ceiling. Otherwise delete this section. One row per oversized story, matching the four-element exception template in `standards/process/TASK_SIZING.md` (realistic effort, why it can't be split, risks of oversize, acknowledged by)._

| story id | realistic estimate | why it can't be split | risks of oversize | acknowledged by |
|----------|--------------------|-----------------------|-------------------|-----------------|
| {STORY_ID} | {HOURS} | {one sentence} | {visibility, blocking, integration risk} | {accountable owner, dated} |

## Definition of Done

- [ ] Every story in the table above is complete and merged via `/build`.
- [ ] The epic delivers its stated goal end-to-end (a thin slice per story, whole outcome across the set).
- [ ] No story in the epic is left oversized without a documented exception.
