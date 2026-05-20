# AUTO_MERGE.md — Automated merge policy

**Authoritative source:** [`../../../NOTES.md`](../../../NOTES.md) (auto-merge rules, automated code reviews sufficient); [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §8 (Code review).

## The policy

Automated merge is allowed when **all** of the following hold:

1. **All required pipelines green** — build, test, lint, security scans, container scans.
2. **CODEOWNERS approval present** — for every changed path with a CODEOWNERS entry.
3. **Automated review gates green** — code-reviewer agent findings ≤ minors only (no blockers, no majors).
4. **No unresolved review threads.**
5. **Branch up-to-date with `main`** — no stale-merge surprise.
6. **No merge during deploy freeze windows** (if a freeze is active).

If all six hold, the MR may auto-merge on the agreed schedule (immediate, batched, or scheduled).

## Worktree-based task execution

Task-executing sub-agents work in isolated git worktrees (Claude Code's `Agent` tool spawn includes `isolation: "worktree"`). At end-of-task, the sub-agent commits, pushes the feature branch, and opens the MR with **auto-merge enabled** AND **source-branch deletion on merge** (GitLab `glab mr create --remove-source-branch`; GitHub `gh pr merge --auto --delete-branch`).

Auto-merge here is "set up the merge to proceed when gates pass" — not "merge regardless." The six gates in [`## The policy`](#the-policy) above still apply: CI green, CODEOWNERS satisfied, automated reviews ≤ minors, no unresolved threads, branch up-to-date, no freeze. If any gate fails or any trigger in [`## When auto-merge is NOT allowed`](#when-auto-merge-is-not-allowed) fires, auto-merge waits or is rejected per the same rules.

The orchestrator (see [`../../agents/pass-runner.md`](../../agents/pass-runner.md) §"Briefing sub-agents") spawns code-changing sub-agents with worktree isolation. Each sub-agent follows [`../AGENT_PREAMBLE.md`](../AGENT_PREAMBLE.md) §"Working on code tasks (worktree + MR workflow)" for the commit / push / MR steps.

## When auto-merge is NOT allowed

- **Schema migration in the diff** — requires human approval; expand/contract reasoning is too easy to automate-wrong.
- **`infra/` or `terraform` changes touching production resources** — `terraform plan` on the MR must be reviewed by a human.
- **Public API change** (added/removed/renamed endpoint, breaking schema change) — requires deprecation review.
- **Auth / authz / crypto / billing path** (`**/auth/**`, `**/crypto/**`, `**/billing/**`) — human approval required regardless of automated review verdict.
- **Touching `CODEOWNERS` itself or branch protection settings** — meta-changes get extra scrutiny.
- **Large diff (> 1000 LoC)** — automatic flag; oversized PRs do not auto-merge. Per [`../development/CODE_REVIEW.md`](../development/CODE_REVIEW.md).
- **Author is a bot and the diff is non-trivial** (e.g., Renovate bumping a transitive dep that pulls a new license / new direct dep).

## The "automated review sufficient" carve-out

Per NOTES.md: routine refactors, internal-API changes, doc updates, and dependency bumps **can rely on automated review alone** (no human approval required) when:

- Diff is < 200 LoC.
- No paths in the protected list above are touched.
- Code-reviewer + qa-engineer + cross-verifier all return clean (no findings ≥ minor).
- The author is not the same agent that performed the review.

This exists because over-rotating to "human reviews everything" creates queue pressure that defeats the goal. Automation is trusted within the boundary where it has been calibrated; humans are reserved for the cases where calibration is uncertain.

## Auto-rejection (used by code-reviewer / platform-engineer)

| Trigger | Severity |
|---|---|
| Auto-merge enabled on MR touching `**/auth/**` / `**/crypto/**` / `**/billing/**` | Blocker |
| Auto-merge enabled on MR with schema migration | Blocker |
| Auto-merge with `infra/` changes affecting prod | Major |
| Auto-merge on public API change | Major |
| Auto-merge on >1000 LoC MR | Major |
| Branch not up-to-date with main but auto-merge enabled | Minor (race condition risk) |
| Self-approval used to satisfy CODEOWNERS for auto-merge | Blocker |
| Required pipeline marked "allow failure" but auto-merge proceeds | Blocker |

## Bot PRs (Renovate, Dependabot, etc.)

- Patch / minor bumps with passing tests and clean SCA → auto-merge OK.
- Major bumps → human review required.
- New transitive dependencies introduced (license / supply-chain shift) → human review required.
- Lockfile-only changes from a tool we trust → auto-merge OK.

## Anti-patterns to flag

- "Add `auto-merge` label, walk away" without confirming the gates above are wired.
- Disabling tests temporarily and auto-merging "to unblock CI." Now you've shipped untested code.
- Auto-merge bypassing the `terraform plan` review on infra changes. Plans aren't review-by-stamp.
- Bot accounts approving as a code owner. Bots don't review; they sign off.

## Sources

- [`../../../NOTES.md`](../../../NOTES.md) — explicit user policy on auto-merge.
- [`../development/CODE_REVIEW.md`](../development/CODE_REVIEW.md).
- GitLab "Merge when pipeline succeeds" + "Auto-merge" documentation.
- GitHub "Auto-merge" docs (parallel feature, same principles).
