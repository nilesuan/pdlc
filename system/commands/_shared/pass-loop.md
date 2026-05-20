# _shared/pass-loop.md

Shared snippet: every phase command dispatches the same way once it has assembled its brief.

```
1. Write .pipeline.json under cdocs/ with:
   - command: <command name>
   - phase: <01-08 or "review">
   - task: <user's request, verbatim>
   - standards_to_load: [list of standards/*.md paths]
   - sub_agents: [list of agent names]
   - max_passes: 3 (or 5 if escalation triggered)
   - feature_flags: { ... }     # optional per-command flags

2. Spawn pass-runner with the brief:
   "Read cdocs/.pipeline.json. Run the multi-pass loop. Spawn the listed
    sub-agents. Run cross-verifier each pass. Score per QUALITY.md. Return
    when score ≥ 85 with no blockers, or after MAX_PASSES."

   The pre-output gate (`scripts/verify-artifact.sh`) runs after the
   cross-verifier and before the final summary, per
   [`../../standards/ANTI_HALLUCINATION.md`](../../standards/ANTI_HALLUCINATION.md).

3. Read pass-runner's final result. Present to user as:
   - One-line summary
   - Score and pass count
   - Open blockers (if any)
   - Path to the full artifact under cdocs/<command>-<timestamp>.md

4. If user asks to retry or address findings, re-dispatch with a new
   .pipeline.json that includes user_response and prior findings.
```

This pattern is reused verbatim by every command. If you need a different orchestration shape, write a new shared snippet rather than diverging silently.
