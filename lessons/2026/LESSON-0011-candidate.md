---
id: LESSON-0011
date: 2026-09-14
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [stale-observation, handoff, solution-plan, harness-promotion, concurrent-task, at-the-time-of-writing, disk-state, absence-claim, tests-directory, pass-close]
related-rules: [CLAUDE.md, agents/cross-verifier.md, standards/docs/TECH_SELECTION.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md]
status: candidate
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 3 (Handoff), Sofaoke `song-processing`, 2026-09-14. Verdict `SP-S5-07` in `solutions/song-processing/xv-pass3.yaml` (worktree `agent-a8afdab2afe77758e`).

## What went wrong

The handoff plan's regression-harness section, headed "Recorded as observed on 2026-09-14, while this pass was running", says: "No `tests/` directory exists in the repository yet, so the exit checklist's harness-promotion box is not met at the time of writing." The same section counts untracked files as "In the repository tree", so the claim is about the working tree.

On disk, `tests/` and `tests/spike-regression/` were created at 21:30:24, and all four test files existed by 21:35:46. The plan was written in one piece at 21:37:39, about seven minutes later. At cross-verification the directory held 59 test functions, four promoted metric modules, hash-pinned requirements, a README and a CI workflow (`spike-regression.yml`, created 21:40:57). The absence claim was already false when it was written, in an artifact meant as the owner's final reference.

## Why it happened (root cause)

The sentence described state that a concurrent task in the same pass was changing; the plan itself says promotion was happening "during this pass". The state was observed at one moment and written into a permanent artifact later, with no re-check at the final write and none after the concurrent task finished. "At the time of writing" reads like a timestamped check but was not one, so nothing forced a re-check. It is also an absence claim with no command output behind it, the pattern LESSON-0008 describes.

## How to prevent it (the rule)

Before the last write of a handoff artifact, and again after every concurrent task in the pass has returned, re-run the check behind each sentence about current file, test or git state, and write the check's result with its time; never carry an earlier observation into the final text.

## Verification

- At pass close, list every state claim in the pass's artifacts ("exists", "does not exist", "N tests", "untracked") and re-run its check after all sub-agents have returned. Any mismatch blocks closing the pass.
- Mechanical check for absence claims: a path whose creation time (`stat -f %SB`) is earlier than the artifact's last modification contradicts a "does not exist" sentence in that artifact.
- The category that should drop to zero: "handoff artifact contradicted by disk at cross-verification".
