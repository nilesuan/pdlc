---
id: LESSON-0098
date: 2026-10-02
trigger: broken-link
phases: [03]
keywords: [cdocs, gitignored, relative-link, worktree, run-record, markdown-link, verify-artifact]
related-rules: [standards/ANTI_HALLUCINATION.md, scripts/verify-artifact.sh]
status: candidate
---

## What went wrong

An ADR addendum cited the `/split` run record that motivated it as a Markdown relative link,
`[run record](../../cdocs/split-v1-2026-09-30.md)`. The pre-output gate found it broken: `cdocs/` is gitignored, so
a fresh worktree never has the file a sibling checkout's `cdocs/` holds, and the link resolved to nothing on disk.

## Why it happened (root cause)

`cdocs/` artifacts are addressed by path constantly in run records and in conversation (the task brief that started
this very pass does so correctly, as plain text), which makes writing a path as a path transfer automatically into
a Markdown link - where a link is checked for resolution and a plain-text path is not. Nothing distinguishes "a path
I am naming" from "a path I am linking to" at the point of writing, so the gitignored status of the target, and the
fact that a worktree is a separate checkout that never receives it, was not considered.

## How to prevent it (the rule)

Before writing a Markdown relative link, check whether the target is under a gitignored directory (`cdocs/`, or any
path `git check-ignore` accepts); if so, cite it as a code-formatted plain-text path, never as a `[text](path)`
link, since gitignored content is not guaranteed to exist in every checkout or worktree that will read the
document.

## Verification

The pre-output gate (`scripts/verify-artifact.sh`) reports `broken=0` on the artifact; a regression check greps the
artifact for `](...cdocs/` and confirms zero hits that are real Markdown link syntax (as opposed to a code-fenced or
backtick-quoted path).
