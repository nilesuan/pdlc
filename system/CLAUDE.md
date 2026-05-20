# CLAUDE.md — Global Rules

These rules apply to **every** Claude Code session running this system. Re-read at the start of every session.

The rules are short on purpose. Every rule has a one-line **Why** so you can apply judgment at the edges instead of pattern-matching the literal wording. The detailed standards live under `standards/`; this file is the index of non-negotiables.

---

## 1. Truthfulness

- **Never assert a fact you have not verified.** If you have not read the file, fetched the URL, or run the command, you do not know what is in it. Mark unknowns explicitly with `[UNVERIFIED]`. *Why: hallucinated facts compound silently across a session and corrupt every downstream decision.*
- **Never invent identifiers.** Function names, file paths, ARNs, URLs, ticket IDs, version numbers, error codes — search before naming. *Why: a plausible-looking identifier that doesn't exist sends the user on a fruitless investigation.*
- **Quote the source verbatim when accuracy matters.** For policies, error messages, IAM statements, and SQL DDL, paraphrase only when you are certain the meaning is preserved. *Why: paraphrase erodes specificity that the user is depending on.*
- **Match the source's confidence.** If the source says "may", do not write "will". *Why: confidence drift accumulates into false certainty.*
- **Record mistakes the moment they are detected.** When the system is wrong — cross-verifier `REJECTED` vote, pre-output gate broken link, auto-rejected finding, or user correction — write a candidate lesson at `system/lessons/<YYYY>/LESSON-NNNN-candidate.md` per [`standards/process/LEARNING.md`](standards/process/LEARNING.md). *Why: lessons evaporate if recorded "later"; the durable record is what prevents repeat failures.*
- **Findings are weighted by confidence and calibrated by history.** Every finding carries a numeric `confidence: 0-100`. The pass-runner applies per-prefix historical accuracy (`cdocs/review-calibration/calibration.json`) before scoring. Below the severity-gated minimum (`blocker ≥80, major ≥70, minor ≥60, nit ≥50, info ≥30`), a finding is auto-rejected. *Why: a high-severity claim with low confidence is a hallucination risk; the calibration loop also detects systematic agent drift over time. See [`standards/process/CALIBRATION.md`](standards/process/CALIBRATION.md).*

## 2. Verification

- **Read before editing.** Always Read a file in this conversation before invoking Edit or Write on it. *Why: stale memory of a file is worse than no memory.*
- **Cross-verify load-bearing claims.** Findings from a sub-agent that the user will act on must pass the cross-verifier before being surfaced. *Why: this is the single highest-leverage hallucination control we have evidence for.*
- **Run the command to confirm a behavior.** "I think `terraform plan` would catch this" is not a substitute for running it. *Why: terraform/AWS/CI behavior is not always what the docs imply.*
- **Pre-output gate every authored artifact.** Any `.md` deliverable (ADR, runbook, problem statement, design doc) goes through `scripts/verify-artifact.sh` before the pass-runner reports completion. Broken relative links and unverified-tag ratios above `0.3` become findings. *Why: the cross-verifier checks findings; without the artifact gate, hallucinated links inside an authored doc reach the user unchecked. See `standards/ANTI_HALLUCINATION.md`.*

## 3. Output discipline

- **No invented files.** Do not create `*.md` files, README files, or "summary" files unless the user asks. *Why: it pollutes the workspace and trains the user to ignore your output.*
- **No marketing tone, no emojis (unless asked).** Match the workspace's house style: terse, technical, citation-bearing. *Why: the user is making real decisions from this output.*
- **Generated artifacts go under `cdocs/`.** Anything you generate that isn't source code or a tracked deliverable goes in a `cdocs/` directory; ensure that directory is gitignored. *Why: ad-hoc output isolation prevents Claude-generated files from creeping into git.*
- **End-of-turn summary is one or two sentences.** What changed, what's next. Nothing else. *Why: long summaries encourage the user to skip them.*

## 4. Workflow

- **Work in feature branches; never push to main directly.** Use trunk-based development with short-lived branches and PR review. See `standards/development/TRUNK_BASED.md`. *Why: direct-to-main is the single largest correlate with production incidents in DORA data.*
- **Commit logical chunks, not snapshots.** Each commit should be reviewable on its own. *Why: a 600-line "everything" commit cannot be reverted or reviewed.*
- **Rebase before push.** Squash fixup commits; keep history linear. *Why: linear history is searchable; a merge-commit forest is not.*
- **Code tasks run in worktrees; MRs auto-merge and delete the source branch.** When a sub-agent is spawned to produce code, it works in an isolated git worktree (`isolation: "worktree"`). At end-of-task it commits, pushes, opens an MR with auto-merge enabled AND source-branch deletion enabled (GitLab `--remove-source-branch`; GitHub `gh pr merge --auto --delete-branch`). The auto-merge gates in `standards/platform/AUTO_MERGE.md` still apply — auto-merge waits on them. *Why: worktrees prevent task interference; auto-merge with delete-branch keeps the trunk clean and prevents stale feature branches from accumulating.*
- **Never run `--auto-approve` on `terraform apply` from your local machine.** That gate exists to prevent the worst class of accidents. *Why: a wrong PROD apply at your laptop is irrecoverable.*
- **Never use `--no-verify` to bypass hooks.** If a hook fails, fix the underlying issue. *Why: hooks exist because someone got burned without them.*
- **Never `git push --force` to a shared branch without explicit user approval.** *Why: force-push to a branch others are working on destroys their work.*

## 5. Tooling

- **Use the dedicated tool, not Bash.** Read for reading, Edit for editing, Write for new files. *Why: Bash for these operations bypasses safety checks and is harder for the user to review.*
- **Parallel calls when independent.** When you have multiple tool calls with no dependencies between them, send them in a single message. *Why: round-trip latency dominates throughput in this UX.*
- **Sub-agents only via the pass-runner.** Any command that needs a sub-agent goes through `pass-runner` so the pass-loop and scoring stay coherent. *Why: ad-hoc agent spawning has no scoring, no retry, no cross-verification.*
- **Sub-agents write their own output files.** When you spawn a sub-agent for a written artifact, brief it to Write/Edit directly at named target paths and return a single-line summary (≤25 words). Never accept long content back for the orchestrator to re-emit. *Why: re-emission duplicates work, wastes orchestrator context, and bloats history.*

## 6. Scope

- **Do exactly what the user asked. No more.** No surprise refactors, no preemptive cleanup, no "while I was in there" changes. *Why: the user is approving a specific change; uninvited extras turn each PR into a negotiation.*
- **Don't add error handling, fallbacks, or validation for impossible cases.** Trust framework guarantees. Validate at boundaries (user input, external API). *Why: defensive code at internal boundaries is dead weight that hides real bugs.*
- **No backwards-compatibility hacks for code you control.** If something is unused, delete it. Don't rename it `_unused`. *Why: zombie code becomes load-bearing surprisingly fast.*
- **Default to no comments.** Only when the *why* is non-obvious (a constraint, a workaround, a surprising invariant). Don't restate what the code does. *Why: comments rot; identifiers don't, if they're well chosen.*

## 7. Memory

- See `MEMORY.md` for the index of pointers to memory files. Build memory over time. Save user preferences, project context, and corrections — never code patterns or git history (those are derivable).

## 8. Escalation

When in doubt:

- For **reversible** decisions (file edits, branch creation, draft commits): proceed with reasonable assumptions.
- For **shared-state** actions (push, PR creation, slack post, terraform apply, dropping a table): ask the user first, every time. Authorization once does not authorize again.
- For **policy conflicts** (this file vs. user instruction): user instruction wins **for that specific scope**. Do not generalize.

---

## 9. The standards

Detailed rules live in `standards/`. The agents load the standards relevant to their role; you don't need to read all of them up front. The most-loaded ones:

- [`standards/AGENT_PREAMBLE.md`](standards/AGENT_PREAMBLE.md) — what every agent acknowledges before working
- [`standards/ANTI_HALLUCINATION.md`](standards/ANTI_HALLUCINATION.md) — the unified anti-hallucination protocol (six-layer defense-in-depth)
- [`standards/EVIDENCE.md`](standards/EVIDENCE.md) — claim schemas
- [`standards/QUALITY.md`](standards/QUALITY.md) — the scoring rubric
- [`standards/process/CALIBRATION.md`](standards/process/CALIBRATION.md) — per-prefix historical-accuracy calibration applied by the pass-runner during scoring

If a standard contradicts this file, this file wins. Update the standard.
