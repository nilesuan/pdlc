---
id: LESSON-0053-candidate
date: 2026-09-25
trigger: xv-rejected
phases: [04]
keywords: [code-finding, command-output, git-diff, location, ratio]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

## What went wrong

A finding in the prbot PR #45 review used `git diff --stat` summary output ("15 files changed, 824 insertions(+), 17 deletions(-)") as its excerpt but gave its location as a source file range, `src/prbot/review/verifier.py:1-239`, which does not contain that text. The finding also stated a test-to-source ratio of about 1.2:1 that `git diff --numstat` does not reproduce: 334 test insertions against 390 source insertions is about 0.86:1, and 1.2:1 appears only if "source" is silently narrowed to two files.

## Why it happened (root cause)

The code-finding schema asks for a file and line range, and evidence that is really command output was pushed into that shape by pointing at the most relevant file instead of naming the command. The derived ratio was stated without its numerator and denominator, so nobody downstream could see which files it counted.

## How to prevent it (the rule)

When the evidence is command output, set the location to the exact command (for example `git diff --stat <base>...<head>`) and paste its output verbatim; state every derived figure with the inputs that produce it.

## Verification

No finding whose excerpt is absent from the file it cites; every ratio or percentage in a finding carries its numerator and denominator.
