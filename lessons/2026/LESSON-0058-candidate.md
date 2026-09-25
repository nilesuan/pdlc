---
id: LESSON-0058-candidate
date: 2026-09-25
trigger: self-detected
phases: [04, 05]
keywords: [grep, grep-P, macos, bsd-grep, check, or-echo, success-message, known-positive, scanner, false-pass, em-dash]
related-rules: [standards/ANTI_HALLUCINATION.md, lessons/2026/LESSON-0005-silent-control-needs-a-negative-test.md]
status: candidate
source-run: prbot PRs #42-#45 fix session, 2026-09-24/25
---

## What went wrong

Seven times across one session, a check for em and en dashes in newly added lines ran as `git diff -U0 | grep -E '^\+' | grep -n -P '[\x{2013}\x{2014}]' || echo "no em/en dashes added"`. macOS ships BSD grep, which has no `-P` option: every run exited 2 with "invalid option", and the `|| echo` printed the success message. Each check was reported as passing although it had tested nothing. It surfaced only when a later run printed grep's usage text. A working scanner, validated on a commit known to add 54 dash lines, then found none in the session's commits, so the output happened to be clean.

## Why it happened (root cause)

The failure path and the success path printed the same thing. `cmd || echo ok` treats any non-zero exit as "no matches", but grep exits 1 for no matches and 2 for an error. The check was never run against an input known to contain the thing it looks for.

## How to prevent it (the rule)

A check that looks for something must be shown to find it once before its silence is trusted: run it on a known positive first. Never let an error and a clean result print the same message; distinguish grep's exit 1 (no match) from 2 (error), or do the scan in Python. On macOS, do not use `grep -P`.

## Verification

The rule held if the next such check in a session is preceded by a run on a known positive that reports at least one hit.
