---
id: LESSON-0076
date: 2026-09-28
trigger: self-detected
phases: [01, 02, 02.5, 03, 04, 05, 06, 07, 08]
keywords: [lessons, INDEX.md, lesson-loading, global-path, project-relative, cwd, working-directory, pass-runner, orchestrator]
related-rules: [standards/process/LEARNING.md, agents/pass-runner.md]
status: candidate
---

# Lesson loading reads the global `~/.claude/lessons/INDEX.md`, never a project-relative path

## What went wrong

Before pass 1 of a `/design` run, the pass-runner checked for an active lesson index with `cat lessons/INDEX.md`
from a Bash shell whose working directory was the project repository (`/Users/nile/Projects/karaoke`). That
resolved to a project-relative path that does not exist, and the check reported "NO LESSONS INDEX", which the
pass-runner recorded as "no lessons to load" in its own pipeline record. The real index, at
`/Users/nile/.claude/lessons/INDEX.md`, held 26 active lessons at the time, several of which matched the run's
brief on their own keyword lists (`worktree`, `cross-verifier`, `adr`, among others) and should have been inlined
into every sub-agent's pass-1 brief. The gap was only caught after pass 1 completed, when the cross-verifier wrote
two new candidate stubs to the correct global path and their existence made the mismatch visible.

## Why it happened (root cause)

`standards/process/LEARNING.md` and `agents/pass-runner.md` both write the lesson-loading path as `lessons/INDEX.md`,
a path that is correct only relative to the system root (`~/.claude/`, the directory containing `CLAUDE.md` and
`MAPPING.md`), matching how `standards/`, `agents/` and `commands/` are always read from that root. Nothing in
either document states this explicitly, and nothing marks the instruction as system-root-relative the way
`standards/frameworks/trigger-index.json`'s own evaluation note does for framework specs ("Spec paths are relative
to the system root"). A Bash check run from the project's own working directory silently resolved to a different,
empty location instead of failing loudly, so the miss produced a plausible-looking negative rather than an error.

## How to prevent it (the rule)

Read `lessons/INDEX.md` and every lesson file with the absolute path `~/.claude/lessons/...` (or the session's
resolved equivalent), never with a path resolved against the current working directory; when checking with Bash,
either `cd` to the system root first or pass the absolute path directly, and if the check reports "no index", read
the absolute path a second way (e.g. `ls ~/.claude/lessons/`) before recording that no lessons are active.

## Verification

Before a pass-runner's `pipeline.json`-equivalent record claims `lessons_active: []` with a stated reason of "no
index found", it names the absolute path it checked, and that path resolves under the home directory's
`.claude/lessons/`, never under the working repository.
