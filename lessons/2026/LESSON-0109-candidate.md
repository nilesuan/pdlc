---
id: LESSON-0109
date: 2026-10-05
trigger: user-correction
phases: [08]
keywords: [auto-memory, MEMORY.md, CLAUDE.md, feedback-memory, standing-rule, per-project]
related-rules: [CLAUDE.md]
status: candidate
---

## What went wrong

The user gave a standing rule for all work: "Keep noisy output (test runs, logs) out of the main conversation by always using a subagent." It was saved only as a feedback memory under `projects/-Users-nile--claude/memory/`, which loads only in sessions started from `~/.claude`, and the reply offered CLAUDE.md as an option instead of putting the rule there. The user corrected it: "update the system with this rule instead of just memory". The rule now lives in CLAUDE.md §5 and the memory copy was deleted.

## Why it happened (root cause)

Two placement defaults point the same way: the harness memory instructions file guidance on how to work as `feedback` memory, and CLAUDE.md §7 says "Save user preferences, project context, and corrections" to memory. Neither separates a project preference from a rule meant for every session, and auto-memory is per-project (24 separate memory directories exist under `projects/`), so a global rule saved there silently stops applying outside one directory.

## How to prevent it (the rule)

When the user states a rule for all work ("always", "never", "from now on") without scoping it to a project, add it to CLAUDE.md in the same change, reconciling any rule it conflicts with, and keep auto-memory for project-specific context.

## Verification

A standing rule given in a session appears in CLAUDE.md (or the standard behind it) in the same change, and a `grep -rl` for its key phrase across `projects/*/memory/` finds no copy.
