---
id: LESSON-0027
date: 2026-09-19
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [absence-claim, concurrent-run, shared-files, data-file, runtime-read, model-pins, quantifier, scope, LESSON-0024]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0021-candidate.md, lessons/2026/LESSON-0024-candidate.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 4 (resumed), Sofaoke `song-processing`, 2026-09-19. `REJECTED` on E2E4-LOCK-01 (`cdocs/.pipeline-solve/pass4/xv-A.yaml`). No measurement changed: the edit touched prose and exemption lines, not a pin row.

## What went wrong

A finding said a pass "changed none of the files D2 round 4 loads while it ran". Its evidence was `git diff --stat HEAD` over three Python files (the htdemucs loader, the weights module and the pin-gate parser), run before the pass's second commit, with no output. The loader reads a fourth file at load time, `eval/model-pins.md`, through `weights.PINS_PATH`. The same pass's commit `c98a790` (00:18:30Z) edited that file while D2 round 4 was running, and D2's held-out and anchor stages started new separation workers after it (00:41Z and 00:54Z) whose records name `"torch_load_guard": "eval/model-pins.md"`. The claim was contradicted by the pass's own commit.

## Why it happened (root cause)

The set of "files a concurrent run loads" was built from the import graph, which lists code modules, and not from what the code opens at run time. The check also ran before the commit it was meant to cover, so the pass's later edits were outside its scope.

## How to prevent it (the rule)

**Before claiming a change left a concurrent run's inputs alone, list what that run opens as well as what it imports (grep its code path for `open(`, `read_text`, `Path(` and path constants), and diff that whole list across every commit made during the run's window (`git diff --stat <start>..<end> -- <files>`), pasting the command and its output.**

## Verification

- A claim that a pass "changed none of" another workstream's inputs carries a diff over a commit range covering the whole run, not a working-tree diff at one moment.
- The file list in that diff includes data files the code reads at run time, such as pin tables, manifests and configs.
- The category that should fall to zero: a cross-verifier `REJECTED` vote on a "left X alone" claim that a commit in the window contradicts.
