---
id: LESSON-0034
date: 2026-09-19
trigger: self-detected
phases: [04, 06]
keywords: [auto-merge, gh pr merge --auto, required status checks, branch protection, ruleset, ci, merge before checks]
related-rules: [standards/platform/AUTO_MERGE.md, standards/release/CONTINUOUS_DELIVERY.md, standards/process/LEARNING.md]
status: active
---

**Provenance.** Sofaoke, 2026-09-19. The orchestrator opened PR #13 (the web smoke-test hang fix) and ran `gh pr merge 13 --auto --squash --delete-branch`, meaning it to merge once CI passed. The repository allows auto-merge but had no required status checks on `main`. GitHub merged the PR at once, at 10:24:53Z, while all four of its checks were still pending.

## What went wrong

Auto-merge was treated as "merge when the checks pass". GitHub auto-merge waits only for the checks a branch rule or ruleset *requires*. With none required, the PR was already mergeable, so enabling auto-merge merged it immediately and CI ran only afterwards, on `main`. The change had been verified locally on Linux first, so nothing broke. But `main` took a commit no CI run had passed, which the prod-deployability rule forbids.

## Why it happened (root cause)

The gate that auto-merge waits on lives in the repository's settings, not in the command. Nobody checked that the settings named any check before relying on auto-merge to wait for one.

## How to prevent it (the rule)

**Before enabling auto-merge, confirm the target branch requires at least the status checks the change must pass (`gh api repos/{owner}/{repo}/rules/branches/{branch}`, or the branch-protection endpoint). If none are required, wait for the checks yourself (`gh pr checks --watch`) and merge only when every one is green.**

## Verification

- Every `gh pr merge --auto` in a transcript is preceded by a read of the branch's required checks, or followed by `gh pr checks --watch` before any merge.
- No PR has a merge time earlier than its last required-for-this-change check's completion time.
- The category that should fall to zero: a PR merged with its checks still pending.
