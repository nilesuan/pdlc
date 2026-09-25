---
id: LESSON-0072
date: 2026-09-26
trigger: self-detected
phases: [02.5, 04, 05, 06]
keywords: [absence, empty-result, zero, grep, rtk, zsh, word-splitting, positive-control, planted-control, secret-scan, public-push, enforcement, test-controls, LESSON-0008, LESSON-0044]
related-rules: [standards/process/LEARNING.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md, lessons/2026/LESSON-0044-candidate.md, RTK.md]
status: candidate
---

# An empty search is evidence only after the same invocation has found a known positive

## What went wrong

Two absence claims in one session, both from searches that could not have found the thing.
A reply said nothing enforces the LEARNING.md rule that lesson stubs are committed. The search
behind it was a `git grep` for "git add" or "commit" near "lessons", while the check that does
exist, in `scripts/test-controls.sh`, is worded "recorded lessons are actually durable" and
"no lesson file is left untracked". Later, a secret and PII scan of the 67 files about to be
pushed to a public repository printed nothing. The file list sat in a shell variable, zsh does
not split an unquoted `$VAR`, so grep received every path as one filename, and the `rtk` grep
wrapper swallowed the resulting error. Re-run with the files listed directly and a planted
control file, the control matched and so did real files; a follow-up scan found two lessons
naming real people, which were then held back from the push.

## Why it happened (root cause)

An empty result looks the same whether the search found nothing or never ran. `RTK.md` says to
re-run a command only when its output is empty "when output was clearly expected", and a clean
scan is exactly the case where empty output is expected, so that rule never fires. The first
claim is the LESSON-0008 failure (searching the reviewer's vocabulary, not the artifact's); the
second is the LESSON-0044 failure (a zero whose reach was never shown).

## How to prevent it (the rule)

Before reporting that a search found nothing, show that the same invocation finds a known
positive - a planted control file passed alongside the real files, or a file already known to
match - and before saying nothing enforces a rule, run the repository's own control runner.

## Verification

A reply or finding that reports a zero names the control hit from the same command. In zsh,
file lists reach grep as globs or `${=VAR}`, never a bare `$VAR`.
