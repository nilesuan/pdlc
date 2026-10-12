---
id: LESSON-0096-candidate
date: 2026-10-02
trigger: self-detected
phases: [04, 05]
keywords: [worktree, git-worktree-remove, gitignored, cdocs, data-loss, cleanup, run-sheet]
related-rules: [standards/ANTI_HALLUCINATION.md]
status: candidate
source-run: karaoke, preparing the owner's live-audio evening, 2026-10-02
---

## What went wrong

The live-audio run sheet (`solutions/live-audio/evening-run-sheet.md`, A3) said the on-phone pitch test's 522 MB of data, `cdocs/live-audio-prep/`, existed only inside the `.claude/worktrees/live-audio-prep/` worktree, and that it had to be copied to the checkout the evening serves from. After that worktree's work merged, the worktree was removed, and the gitignored folder went with it. It was found missing on 2026-10-02 only when the evening's steps were checked against the machine: nothing under `/Users/nile` held it any more.

## Why it happened (root cause)

`git worktree remove` treats ignored files as disposable, and `cdocs/` is ignored by design, so git gives no warning. The warning that mattered was in a document, not in the tool, and nothing read the document before the removal.

## How to prevent it (the rule)

Before removing any worktree, list its ignored files (`git -C <worktree> status --porcelain --ignored`) and search the repository's docs for the worktree's name; move anything a document says lives there into the main checkout first, or confirm it can be rebuilt. Treat "lives only in this worktree" in any doc as a blocker on removal until the data is moved.

## Verification

The rule held if the next worktree removal is preceded by an ignored-files listing and a docs search for the worktree's name, both recorded.

## Recurrence

2026-10-02, karaoke, the same session: the worktrees `design-spot-signin` and `design-gaps` were removed after their run records were copied to the main checkout, though each also held `cdocs/review-calibration/` (seen in a listing of each), the calibration history the pass-runner writes relative to the worktree; `split-v1` was removed the same way and probably held one too [UNVERIFIED: its `cdocs/` was not listed in full]. The main checkout's `cdocs/review-calibration/history.jsonl` was last appended on 2026-09-28, so the entries of about four runs (2026-09-29 to 2026-10-02) are gone. For `design-gaps` the ignored-files listing was taken, but it showed only `cdocs/` as one line, and the worktree was removed in the same command that first listed what was inside it.

**Sharper rule:** list the contents of each ignored directory, not only its name, and look before running the removal, never in the same command. Before removing a worktree a pass-runner used, append its `cdocs/review-calibration/history.jsonl` lines to the main checkout's, or brief the pass-runner to write calibration to the main checkout's absolute path in the first place.
