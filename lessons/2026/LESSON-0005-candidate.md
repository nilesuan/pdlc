---
id: LESSON-0005
date: 2026-08-21
trigger: audit-finding
phases: [04, 05, 07]
keywords: [inert-control, silent-failure, unfired-hook, config-validation, dead-guard, self-verification, drift, permission-rule, path-mismatch, tag-pattern, gate]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/operations/SCHEDULED_WORK.md, CLAUDE.md]
status: active
---

## What went wrong

A drift audit of this system found **four independent controls that read as active in the repository but did nothing at runtime**, none of which had ever announced its own failure:

1. `permissions.deny` carried `Bash(:(){ :|:& };:)` to block fork bombs. The permission-rule parser rejects it ("Empty parentheses") and **skips the rule**, so it never blocked anything.
2. `verify-artifact.sh` tallied uncertainty tags by matching the exact literal `[UNVERIFIED]`, while this repo overwhelmingly writes `[UNVERIFIED - reason]`. The tally always reported 0, so the unverified-ratio check in CLAUDE.md section 2 could never exceed its 0.3 threshold.
3. `audit-log.sh` read the session ID from `CLAUDE_SESSION_ID`, a variable Claude Code does not set. Every audit record was written with `session_id: "unknown"`, destroying the correlation the log exists to provide.
4. `context-monitor.sh` looked for `.pipeline.json` in the project root, while `agents/pass-runner.md` and `commands/_shared/pass-loop.md` both place it at `cdocs/.pipeline.json`. The file was never found, so the context-budget warning never fired.

Separately, `settings.example.json` - the file the README tells users to start from - failed `claude doctor` validation outright, and the non-blocking write posture the standards require of writing sub-agents was never actually set on any of the seven agent definitions.

## Why it happened (root cause)

Every one of these fails **open and silently**. A skipped permission rule, a regex that matches nothing, an unset environment variable with a default, and a missing file on a path that exits 0 all produce exactly the same observable output as a healthy system: no error, no warning, no log line. The repository documents each control's intent in prose, and prose cannot fail a test.

The deeper cause is that this system had **no mechanism for verifying its own controls fire**. Standards were checked for internal consistency (links resolve, tool names spell correctly) but never for behavior. Nothing ever asserted "feed this guard a fork bomb and expect exit 2," or "write a file with a broken link and expect the gate to speak up." A control's existence in the repo was treated as evidence that it worked.

## How to prevent it (the rule)

**A control that can fail silently MUST have a test that makes it speak.** For every guard, gate, hook, matcher, and threshold this system defines, there must be a check that feeds it input it is supposed to reject and asserts the rejection actually happens - not that the file exists, not that the prose describes it, but that the mechanism produces its failure signal on demand. Config that another tool validates (`settings.json`) MUST be run through that validator. A path or identifier shared between a script and a document MUST be asserted equal by something executable, because prose agreement is not agreement.

## Verification

- Every script under `scripts/` has at least one negative test: input it must reject, and the expected exit code or output. `guard-dangerous-bash.sh` had this property informally and was the only one of the four that turned out to be correct.
- Any config file the repository ships as a template is validated by the tool that consumes it, as part of the same check that lints the Markdown.
- Any path, environment variable, or pattern named in both a script and a document is asserted equal by an executable check, not by review.
- The finding category that should drop to zero is "control documented as active, observed inert."
