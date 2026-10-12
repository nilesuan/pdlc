---
id: LESSON-0102
date: 2026-10-02
trigger: xv-rejected
phases: [03]
keywords: [still-open, left-open, open-items, residual, follow-up, same-pass-fix, stale-characterization]
related-rules: [agents/cross-verifier.md, standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md]
status: candidate
source-run: /design follow-up, karaoke project, worktree design-gaps, 2026-10-02 (item B8, reattach as a partial undo)
---

## What went wrong

An item handed to the cross-verifier as "still open, to report to the user" said that re-attaching a detached upload does not point the `VIDEO#` reference back at the original song, does not cancel the request the detach started, and that "no record says what should happen to any of these." The current files said otherwise. The same pass had deleted the Excluded line the item rested on from `planning/v1/stories/010-song-quality-monitoring/016b-reattach-by-hand.md` ("The new request or song the detach started, which no record says what to do with."). It had also added UC-33 step 8 (`docs/use-cases.md`) and 016b's Included bullets, which settle exactly those cases: cancel the still-open re-request, point its queue entries and `VIDEO#` back, and refuse with `409 already-a-song` once the re-request has made a song. Of the item's four parts, only the D5 corpus entry was really still open. The kept-audio part did not apply: the audio is deleted only when the re-request becomes a song, and that is exactly when re-attach is refused.

## Why it happened (root cause)

The open-items list was put together from reviewer findings written against an earlier state of the change set. Nobody re-read it against the files after the pass's own fixes landed. Each item's wording was carried forward as text instead of being worked out again from the current files. So a gap the pass had already closed was about to be reported to the user as open.

## How to prevent it (the rule)

Before reporting an item as still open, re-read every file it cites as it stands after all of the pass's fixes, quote the current text that shows the gap with file:line, and drop or narrow any part of the item that the current files already answer.

## Verification

Each still-open item in a pass's final report carries a quote of the current file at file:line. The cross-verifier should no longer REJECT "still open" items whose gap a fix in the same pass already closed.
