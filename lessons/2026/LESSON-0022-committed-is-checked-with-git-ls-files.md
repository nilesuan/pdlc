---
id: LESSON-0022
date: 2026-09-18
trigger: xv-downgraded
phases: [02.5, 04, 05]
keywords: [committed, tracked, untracked, in-CI, git-ls-files, working-tree, test-file]
related-rules: [lessons/2026/LESSON-0019-candidate.md, standards/EVIDENCE.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 2 (resumed), Sofaoke `song-processing`, 2026-09-18. `DOWNGRADED` on SEC-SSRF-02 and SEC-DESIGN-01 (`cdocs/.pipeline-solve/pass2/xv-A.yaml`) for the same root cause.

## What went wrong

Two findings said a fix was held by "a committed test" in CI, or called a probed code path "committed", while the test file and the change were untracked working-tree edits awaiting the orchestrator's commit. CI runs only what is in git, so at filing time nothing in CI held the fix.

## Why it happened (root cause)

A test that passes locally feels like a gate. The workstream's brief said "make NO commit; the orchestrator commits after review", so every file it wrote was untracked by design, and the finding described the intended end state as the current one.

## How to prevent it (the rule)

**Before a finding says code is committed, tracked or held in CI, run `git ls-files --error-unmatch <path>` on each path it names; if a path is untracked, say "in the working tree, pending commit" instead.**

## Verification

- `cdocs/.pipeline-solve/tools/lint_findings.py` in that project flags a finding whose claim or evidence says committed, tracked or in CI while a repo path it names is not returned by `git ls-files` (TRACKED check; covered by its `--self-test`).
- The category that should fall to zero is a `DOWNGRADED` vote for calling a working-tree file committed.
