---
id: LESSON-0060-candidate
date: 2026-09-25
trigger: xv-downgraded
phases: [04, 05]
keywords: [absence, completeness, enumeration, branch, no-evidence-of, independently, LESSON-0021, recurrence]
related-rules: [lessons/2026/LESSON-0021-lint-absence-claims-before-verification.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: candidate
source-run: cdocs/review-prbot-pr42-r2/lesson-candidate-2.md
---

## What went wrong

Two findings in the same pass (`/Users/nile/.claude/cdocs/review-prbot-pr42-r2/review-2026-09-25T001900Z.md`) were downgraded by the cross-verifier for the same shape of error, in a project where LESSON-0021 (lint absence claims before verification) was already loaded into both sub-agents' briefs. `CR-SHAPE-01`'s evidence asserted "no evidence of an actual split" after checking `git branch -a` from the reviewed worktree, but did not check whether a *different* remote branch also carried part of the PR's commits — one did (`origin/fix/review-followups`, forked mid-branch, carrying 6 of the 12 total commits). `CR-DUP-01`'s claim that a fact was "independently recomputed three times... with no shared helper" was found, on the cross-verifier's own count, to be two genuinely-independent sites plus one related-but-distinct check.

## Why it happened (root cause)

Both claims used an implicit universal quantifier ("no evidence of a split," "three independent sites") backed by a search that covered the reviewer's own working assumption of the full space (one local worktree's branch list; a manual read of three functions) rather than the actual full space the claim asserted (every branch that could carry this work; every place in the codebase that derives this fact). LESSON-0021's rule — ground every absence/uniqueness claim in a pasted search — was followed in form (both reviewers did paste real commands and real output) but not in scope: the search that was pasted did not range over everything the claim's own wording quantified over.

## How to prevent it (the rule)

When a finding's claim contains an absolute or count quantifier over a named category (all branches, every commit, N independent sites), the pasted evidence must show the search was run over the *full extent of that category* — not a search that happens to be nearby and returns a matching answer. For "no other branch carries this," that means checking every remote branch, not the one the reviewer already had checked out. For "N independent sites," that means the reviewer lists all N and the cross-verifier — or the reviewer, before filing — can recount them from the same evidence.

## Verification

- The finding category that should fall to zero: a `DOWNGRADED` vote whose reason names an unchecked member of the claim's own quantified category (an unexamined branch, an uncounted site) that the cross-verifier had to find on its own initiative.
- If this recurs in a third project with LESSON-0021 already loaded, per that lesson's own precedent (recorded inside `LESSON-0021`'s "Recurrence" addenda), the fix is mechanical — a linter checking that a claim's quantifier words ("no other," "only," "N sites") are followed by evidence whose search scope textually matches the quantified category — not a fourth lesson.
