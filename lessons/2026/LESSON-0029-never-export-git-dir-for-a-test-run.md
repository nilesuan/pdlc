---
id: LESSON-0029
date: 2026-09-19
trigger: self-detected
phases: [02.5, 04, 05]
keywords: [GIT_DIR, git-archive, export, test-suite, verification-run, shared-branch, git-config, side-effect, parallel-agents]
related-rules: [agents/cross-verifier.md, standards/AGENT_PREAMBLE.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 4 (resumed), Sofaoke `song-processing`, 2026-09-19, while re-running recorded test commands. Found and reverted within about 80 seconds; no other commit landed in that window, and no run record under `cdocs/` names the stray commit.

## What went wrong

A verification step re-ran a committed test suite on a `git archive` export outside the repository. One test skipped there because it needs git history, so the suites were run with `GIT_DIR` exported to the real repository's `.git`. The pin-gate self-test then ran its fixture's `git init`, `git config user.name test`, `git add -A` and `git commit -m base` in a temporary directory; with `GIT_DIR` set, all four acted on the real repository. The result was a commit authored "test" on the shared branch `solve/pipeline-end-to-end` (02:29:32Z), an index holding only the temporary tree, and a repo-local identity of `test <t@example.invalid>` that every agent's next commit would have used. It was undone with `git update-ref` guarded by the old value, `git reset -q` and `git config --local --unset` on both keys (02:30:52Z).

## Why it happened (root cause)

`GIT_DIR` redirects every git command in the process tree, including the ones a test aims at its own scratch repository. It was exported for the whole suite to fix one read-only test, and the suite was not checked first for tests that write to git.

## How to prevent it (the rule)

**Never export `GIT_DIR` or `GIT_WORK_TREE` for a test run; to give an export git history, create it with `git worktree add --detach <dir> <commit>` (then `git worktree remove`) or accept the one skip, and before any verification run check the suite for `git init`, `commit`, `config`, `add`, `reset` or `checkout` calls.**

## Verification

- A verification command line containing `GIT_DIR=` or `GIT_WORK_TREE=` is a finding against the verifier.
- After any test run on a shared checkout, `git reflog -3` and `git config --local --get user.name` show no change the run did not intend.
- The category that should fall to zero: commits on a shared branch whose author is a test fixture's identity.
