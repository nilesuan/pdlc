# lessons/

Durable storage for lessons learned from system mistakes. The authoritative source for what counts as a mistake, when to record, the file structure, and the loader semantics is [`../standards/process/LEARNING.md`](../standards/process/LEARNING.md).

## Adding a lesson

1. The pass-runner or cross-verifier writes a candidate stub at `<YYYY>/LESSON-NNNN-candidate.md` when a triggering event fires (see LEARNING.md §"What counts as a mistake").
2. The user reviews the stub. Edits the prevention rule, adds the right keywords, confirms the framing is blameless.
3. On promotion, rename to `<YYYY>/LESSON-NNNN-<slug>.md` and add a row to `INDEX.md` under `## Active`. The slug is short kebab-case naming the failure mode (`broken-handbook-link`, not `agent-x-error`).

## Naming convention

```
lessons/
  INDEX.md
  README.md
  <YYYY>/
    LESSON-NNNN-<slug>.md            — promoted lesson
    LESSON-NNNN-<slug>-candidate.md  — pre-promotion stub
```

`NNNN` is zero-padded sequence per calendar year, starting `0001`. The year directory is the year the lesson was first detected, not the year it was promoted.

## Retiring a lesson

A lesson retires when both criteria in LEARNING.md §"Retiring lessons" hold (≥ 1 year inactive AND a structural change makes the failure mode impossible). Update the lesson file's frontmatter to `status: retired` with `retired:` date and `retired-reason:`, then move its row from `## Active` to `## Retired` in `INDEX.md`. The file is kept on disk; retirement does not delete history.
