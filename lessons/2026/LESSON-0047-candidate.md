---
id: LESSON-0047
date: 2026-09-24
trigger: xv-downgraded
phases: [04]
keywords: [absence, only, none, every, exactly, no-other, nothing-else, quantifier, search-scope, LESSON-0021, LESSON-0008, overclaim]
related-rules: [lessons/2026/LESSON-0021-lint-absence-claims-before-verification.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md, standards/EVIDENCE.md]
status: active
---

## What went wrong

Four findings from two independent reviewers (code-reviewer, security-reviewer), each in a `/review` pass with LESSON-0021 already loaded into every brief, ran a real, correctly-executed search or test and then stated the result with an absolute quantifier -- "exactly these two ... nothing else," "every number in the doc," "no post-fix re-measurement," "the only [test] ... no test" -- that claimed more than that specific search covered. The cross-verifier re-ran each search with a wider scope and found the quantifier false in every case: a grep the filer read as exhaustive had two more hits elsewhere in the same codebase; "every number" had one dated counter-example a few lines further into the same document; an absolute "no re-measurement" claim was true for one of two fixes it was applied to and false for the other; a "the only test with this weakness" search covered one file when a second file had the identical weakness.

## Why it happened (root cause)

LESSON-0021 requires a pasted search behind an absence or uniqueness claim, and all four findings had one -- each search was real, honestly run, and correctly reported on its own terms. The rule as loaded does not require the search's *scope* to be shown to match the *quantifier's* actual breadth: "nothing else" needs a search that covers everything the claim ranges over, not just the one place the filer thought to check. A pasted command satisfies the letter of LESSON-0021 without satisfying its purpose when the command's scope is narrower than the word "every" or "only" in the claim built on top of it.

## How to prevent it (the rule)

When a finding's claim contains an absolute quantifier (only, exactly, every, all, none, no other, nothing else), state next to the pasted search what specific scope it covers (which files, which time window, which code paths), and confirm that scope is at least as wide as the claim's quantifier before asserting it -- a clean search result is not itself evidence of exhaustiveness.

## Verification

- The category that should fall to zero: a cross-verifier downgrade citing a quantified claim whose pasted search covered less than the claim's own scope.
- Provenance note: this is a same-session recurrence of LESSON-0021 in a codebase and project (prbot PR review) unrelated to LESSON-0021's origin (the song-processing `/solve` pipeline), despite LESSON-0021's text and keywords being loaded into every sub-agent brief for this pass. If this recurs a third time in a third project, per LESSON-0021's own escalation pattern the fix should stop being "load the lesson text" and become a mechanical lint step (compare the search's stated scope against the claim's quantifier words) before findings reach the cross-verifier.
