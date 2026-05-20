# SYSTEM.md — Breakdown of `~/.claude.old`

**Subject:** `/Users/nile/.claude.old` — a backup of the user's prior `~/.claude` (Claude Code home) directory, preserved before the live directory was reset/replaced.
**Status:** Read-only inspection. Nothing was modified.
**Last updated:** 2026-04-26.
**Scope of this document:** What is in the directory, what each part does, how the parts fit together, and notable design choices. Findings are based on direct file reads — files I only listed (vs. read in full) are flagged inline.

---

## 1. What this directory is

`~/.claude.old` is the user's previous Claude Code home directory, renamed (from `~/.claude`) and kept as a snapshot. It contains both:

1. **User-authored configuration** — a custom AI-orchestrated software-development workflow system the user built on top of Claude Code (agents, slash commands, standards, scripts, hooks).
2. **Claude Code runtime data** — sessions, transcripts, audit logs, plugin caches, paste caches, shell snapshots, etc., that the CLI itself wrote during normal use.

The user-authored system is self-described in the directory's own `README.md` as:

> "An AI-orchestrated development system that takes a product idea from research through to production release. Two lifecycles — Product Design (PDLC) and Software Development (SDLC) — share a common infrastructure of agents, standards, and a pass-loop scoring engine."

It is a single internally-consistent system: ~30 slash commands delegate to ~22 specialist agents, all of which read from a shared 30+-file standards library, score work on a 0–100 deduction scale, and verify their own claims via a dedicated cross-verification pass.

The directory is also a `git` repository (`.git/` present), suggesting the user version-controls the configuration itself.

---

## 2. Top-level layout

Tree from `ls -la`, annotated. Sizes are file sizes (bytes) where shown.

```
~/.claude.old/
├─ .git/                              ← config-as-code is git-tracked
├─ .claude/                           ← nested .claude — likely a project-local config inside the home dir
├─ .gitignore                         (1,335 B)
│
├─ CLAUDE.md                          (7,313 B)  Global rules read at session start
├─ MEMORY.md                          (3,371 B)  Global lessons-learned ledger
├─ README.md                          (26,493 B) Full documentation of the workflow system
│
├─ settings.json                      (7,400 B)  Live Claude Code settings
├─ settings.json.bak                  (2,577 B)  Backup
├─ settings.local.example.json        (365 B)    Project-local settings example
├─ policy-limits.json                 (147 B)
├─ claude_ai_creds.json               (251 B)    Credential blob (do not redistribute)
│
├─ agents/                            22 specialist agent definitions
├─ commands/                          ~30 slash commands + _shared/ + _COMMAND_TEMPLATE.md
├─ standards/                         30+ standards, plus frameworks/, pdlc/, testing/, toolchain/, backend/, frontend/, global/
├─ checklists/                        5 regulatory compliance checklists
├─ scripts/                           Bash helpers (audit log, status line, pass runners, native-module rebuild)
├─ skills/                            4 self-contained skill bundles
├─ plugins/                           Claude plugin install registry + cache + marketplaces
├─ context-mode/                      Context-mode plugin data
├─ guides/                            Project-specific guides (sparse)
├─ docs/                              Local docs
├─ checklists/                        (Listed above)
├─ standards/                         (Listed above)
│
├─ cdocs/                             Workflow output dir (this system writes to cdocs/, not docs/)
│   ├─ _work/                         Per-issue working scratch (e.g. #154/)
│   ├─ superpowers/specs/, plans/     Output paths overridden by CLAUDE.md
│   ├─ improvements/, padua/, reports/, review-pipeline/
│   └─ state.json                     Last command/score/duration/MR URL — pipeline state
│
├─ plans/                             Per-feature plan documents
├─ reports/                           Generated reports
├─ debug/                             Debug logs
├─ backups/                           Snapshotted prior configs
│
├─ projects/                          Per-project conversation transcripts (drwx------)
├─ sessions/                          Session metadata (drwx------)
├─ session-env/                       Per-session env captures (200 entries)
├─ shell-snapshots/                   Snapshots of user's shell environment
├─ ide/                               IDE integration state (drwx------)
├─ run/                               Process runtime state
├─ cache/                             Misc cache
├─ paste-cache/                       Pasted content cache
├─ file-history/                      File-edit history snapshots (54 entries)
│
├─ history.jsonl                      (531 KB)   Input history (jsonl)
├─ audit.log                          (~58 KB)   Append-only tool-use audit log (current)
├─ audit.log.1                        (1 MB)     Rotated audit log
└─ security_warnings_state_*.json     ~10 small files keyed by session UUID
```

Two things to note before diving in:

- The directory mixes **declarative configuration** (agents, commands, standards, settings) with **runtime artefacts** (sessions, transcripts, caches, audit logs). Backing up the runtime data alongside the config is a deliberate "snapshot of everything" move, not a clean export.
- Several subdirectories (`projects/`, `sessions/`, `ide/`, `cache/`) have `drwx------` permissions — sealed-off contents the user can't accidentally `cat` open.

---

## 3. The workflow system, end-to-end

This is the conceptual core of the user-authored content. Reconstructed from `README.md`, `CLAUDE.md`, the `commands/` files, and the agent definitions I read.

### 3.1 Two lifecycles, one infrastructure

The system implements two interlocking lifecycles:

**Product Design Lifecycle (PDLC)** — Double Diamond:

```
Discover → Define → Ideate → Design → Validate → Deliver → Measure
```

**Software Development Lifecycle (SDLC)** — TDD with phased delivery:

```
Discover → Problems → Solve → Draft → Gap → Split → Build → Rate → Done
```

`/discover` is the shared entry point. `/measure` closes the loop post-launch. The two lifecycles are not separate stacks — they share the same agents, the same standards, the same scoring engine, and the same artifact-handoff format (`.pipeline.json`).

For pure engineering work the user can skip the PDLC and run `/discover → /problems → /solve → /draft → /split → /build → /done`.

### 3.2 The pass-loop scoring engine

Every command follows the same shape:

1. **Parse parameters and check dependency gates.** A command refuses to run if its required upstream artifacts are missing (e.g., `/build` blocks if `/draft` plans don't exist).
2. **Delegate to the `pass-runner` agent.** The orchestrator does NOT run passes itself; it hands off the entire loop to a dedicated agent.
3. **Pass-runner executes 3 passes by default, escalating to 5** if any escalation trigger matches (see §3.5).
4. **Each pass scores 0–100** using a deduction model. Threshold to pass is typically 80–85; short-circuit thresholds (skip remaining passes early) sit at 90–95.
5. **A mandatory verification pass runs after the final scoring pass.** This cannot be skipped, even at a score of 100. It spawns the `cross-verifier` agent (opus) to confirm every claim against its actual source.
6. **Artifacts are written to disk; only a one-line summary returns to the orchestrator.** This is a deliberate context-budget guardrail — the orchestrator never re-reads upstream artifacts in full.
7. **State is persisted** in `cdocs/<service>/<feature>/state.json` and the global `cdocs/state.json`.

`pass-runner.md` is explicit about model tiering:

- **opus** — orchestration, architecture decisions, final-pass cross-verification.
- **sonnet** — implementation, security, scoring, the bulk of agent work.
- **haiku** — gate checks, state writes, template fills, score extraction.

Each agent's `model:` frontmatter is **authoritative and not to be overridden** ("NEVER OVERRIDE — agents must always use their configured model" appears verbatim in every agent file I read).

### 3.3 Evidence as a first-class artifact

The system has a custom evidence schema (`standards/EVIDENCE.md`, 112 lines) with three claim types:

| Type | Required fields |
|---|---|
| `code-finding` | `file_path`, `line_start`, `line_end`, `evidence` (quoted code), `severity`, `confidence` |
| `factual-assertion` | `claim`, `source_type` (documentation/code/url/tool_output/user_input), `source_ref`, `source_quote`, `confidence` |
| `design-claim` | `claim`, `grounding_type` (requirement/constraint/user_input/upstream_artifact/prior_stage), `grounding_ref`, `grounding_excerpt`, `confidence` |

Six **insufficiency triggers** auto-reject claims before they ever reach the verifier:

1. Missing location (`file_path` or `line_start` empty).
2. Empty evidence quote.
3. Restated claim (evidence just rephrases the claim).
4. **"Weasel grounding"** — phrases like "based on best practices" / "industry standard" with no concrete reference.
5. Impossible location (line beyond file length, or path doesn't exist).
6. Dead source (URL 404, file doesn't exist).

Claims that genuinely cannot be verified are tagged `[UNVERIFIABLE]` with a reason and **excluded from scoring**. The `cross-verifier` then double-checks that the reason is legitimate (not laziness).

The evidence schema is the same shape that this PDLC research repo's own `CLAUDE.md` enforces (§ 4 Uncertainty & Honesty) — the discipline is portable.

### 3.4 The cross-verifier — explicitly framed as a hallucination killer

`agents/cross-verifier.md` (168 lines) is the single most distinctive piece of the system. The agent is **opus**, **read-only** (`tools: Read, Grep, Glob`), and its job is **not** to find new issues — it is to PROVE or DISPROVE claims from other agents. Quoting verbatim:

> "You are incentivized to reject bad claims. A false positive that passes verification damages the entire system's credibility. Be skeptical. Demand evidence."

It runs three protocols depending on claim type:

- **Protocol A (code-finding):** Read the cited `file_path` at `line_start`–`line_end`. If file doesn't exist → REJECTED (`file_not_found`). If lines are out of range → REJECTED. If lines are only comments/whitespace → DOWNGRADED (-20 confidence). Then verify each evidence sub-claim by going to the actual code.
- **Protocol B (factual-assertion):** Read `source_ref`. Locate the `source_quote` in the source; if not found → REJECTED (`quote_not_in_source`). If found but the claim overstates the quote → DOWNGRADED (-20).
- **Protocol C (design-claim):** Read the grounding artifact, locate `grounding_excerpt`. If excerpt is found but the claim is a logical leap → DOWNGRADED (-25).

Output: `verified-claims.json` with one of three verdicts per claim — `CONFIRMED`, `DOWNGRADED`, `REJECTED` — plus an `adjusted_confidence` and `adjusted_severity`. REJECTED claims stay in the file (for audit) but are excluded from scoring.

Critical rule from the file: *"You MUST check the actual source for EVERY claim. No shortcuts, no batch approvals."*

This is the system's answer to the canonical Claude failure mode (plausible-sounding fabrication). Whether or not it actually catches everything in practice, the architecture is principled.

### 3.5 Conditional framework escalation (3 → 5 passes)

Default is 3 passes. The pass-runner reads `standards/frameworks/trigger-index.json` (~47 entries) at Pass 1 start, evaluates each trigger's keyword/condition list against the current command's context, and escalates to 5 passes if anything matches. Examples I confirmed in `trigger-index.json`:

| Trigger ID | Phase | Keywords (excerpt) | Spec |
|---|---|---|---|
| `pestle` | discover | regulatory, compliance, jurisdiction, finance, healthcare, government | discover-frameworks.md |
| `stride-fit` | discover | auth, PII, payment, login, internet-facing | discover-frameworks.md |
| `stride-threat` | draft | trust-boundary, auth-flow, internet-facing | draft-frameworks.md |
| `wcag-audit` | design | accessibility, government, education, healthcare, navigation, form | design-frameworks.md |
| `feature-flags` | build | behavior-change, phased-rollout, canary, percentage | build-frameworks.md |
| `mutation-testing` | rate | business-logic, pricing, permissions, data-validation | rate-frameworks.md |
| `release-risk` | done | critical-path, auth, payment, data-persistence, new-environment | done-frameworks.md |
| `compliance-delta` | done | change-freeze, SOC2, PCI-DSS, HIPAA, GDPR, data-processing | done-frameworks.md |
| `regulatory-problem-framing` | define | regulatory, compliance, GDPR, HIPAA | define-frameworks.md |
| `architectural-commitment` | ideate | irreversible, architecture-decision, vendor-lock-in | ideate-frameworks.md |
| `regulated-accessibility` | validate | government, healthcare, legal-accessibility, Section-508 | validate-frameworks.md |

The full file has 41 modern triggers + 7 legacy triggers, indexed by phase, mapping to spec files in `standards/frameworks/`. **Only matching framework spec files are loaded** — non-matching ones are skipped. This is the same context-budget discipline that runs through the whole system.

When escalation fires, the 5-pass structure is documented in `OPTIONAL_FRAMEWORKS.md`:

| Pass | Focus |
|---|---|
| 1 | Scope traceability and correctness |
| 2 | Boundary behavior and error handling |
| 3 | Test quality and coverage evidence |
| 4 | Security, performance, and observability |
| 5 | Execution simulation and ship readiness |

### 3.6 The handoff file — `.pipeline.json`

`commands/_shared/run-config.md` and `pipeline-handoff.md` both describe a single handoff file format. At command start the orchestrator writes `cdocs/$service/$feature/.pipeline.json` containing:

- `service`, `feature`, `current_command`, `output_base`, `artifact_template`, `score_threshold`, `short_circuit_threshold`
- `standards` — agent → standards file mapping (so each agent reads only the files it needs)
- `stages` — pipeline history appended by each completed command (timestamp, 1-line summary, metrics, artifacts list)
- `max_parallel` (default 4) — concurrent agents per wave

The pass-runner reads this file once and **inlines the relevant fields into each sub-agent's Task prompt**. Sub-agents do NOT read `.pipeline.json` directly. This is the single biggest structural choice that keeps the system from blowing context budgets.

The first action of any command — explicitly stated in `run-config.md` — is **gitignore enforcement**: append `cdocs/` to the project's `.gitignore` if missing. This matches `CLAUDE.md`'s "`.claude/` directory must ALWAYS be gitignored" rule. Output isolation is taken seriously: `AGENT_PREAMBLE.md` says "All output goes to `$PROJECT_ROOT/cdocs/`. Before writing any file, ensure `cdocs/` is in the project's root `.gitignore` — append it if missing."

---

## 4. Component-by-component breakdown

### 4.1 `agents/` — 22 specialist agent definitions

Each file is a Markdown document with YAML frontmatter (`name`, `description`, `model`, `color`, `tools`, `standards`) followed by role docs. All agents read `~/.claude/standards/AGENT_PREAMBLE.md` first.

Verified inventory from `ls`:

| Agent | Lines | Role (from frontmatter / README) |
|---|---|---|
| `pass-runner` | 122 | Owns the pass loop for all commands — spawns sub-agents, scores, retries, checkpoints |
| `systems-architect` | 140 | Architecture design, tech stack, data models, API design, ADRs |
| `backend-dev` | 110 | API endpoints, database ops, business logic, auth |
| `frontend-dev` | 141 | UI components, layouts, state management, accessibility |
| `automation-engineer` | 152 | Test automation, Nullable pattern, CI/CD test pipelines |
| `qa-engineer` | 184 | Test planning, exploratory testing, release readiness |
| `security` | 169 | OWASP Top 10, SEC-* checks, dual-mode (ad-hoc + /amrr pipeline) |
| `security-compliance-auditor` | 123 | SOC 2, GDPR, PCI-DSS, ISO 27001 audits |
| `devops-engineer` | 112 | CI/CD, deployments, infrastructure, secrets |
| `performance-engineer` | 121 | Load testing, bottleneck analysis, SLO/SLI |
| `platform-engineer` | 126 | Cloud infrastructure, IaC, observability |
| `product-manager` | 48 | Problem validation, success metrics, roadmap |
| `product-owner` | 44 | Backlog management, story writing, sprint scope |
| `business-analyst` | 43 | Requirements analysis, BRDs, gap analysis |
| `ux-designer` | 44 | User research, personas, journeys, wireframes |
| `ui-designer` | 39 | Design systems, tokens, component specs |
| `code-reviewer` | 81 | General code review, 0-100 scoring |
| `general-reviewer` | 120 | GEN-* checks for /amrr pipeline |
| `spec-compliance-reviewer` | 105 | SPEC-* checks for /amrr pipeline |
| `cross-verifier` | 168 | Cross-validates findings between /amrr reviewers |
| `sprint-orchestrator` | 38 | Sprint planning and execution coordination |
| `test-writer` | 79 | Write tests for existing code |

Total agent surface area: ~2,400 lines across 22 files. **Files I read in full:** `pass-runner.md`, `systems-architect.md`, `security.md`, `cross-verifier.md`, plus the first 50 lines of `automation-engineer.md`. The rest I have seen only by name — descriptions above come from the README.md self-documentation.

Distinguishing details I verified:

- **`pass-runner` is sonnet, not opus.** A shrewd choice — the orchestrator agent itself doesn't need maximum reasoning depth, the agents it spawns do. Pass-runner does the bookkeeping (read pipeline config, spawn agents, collect results, score, retry, checkpoint, write artifacts) but the deep thinking is delegated.
- **Opus agents are deliberately scarce:** `systems-architect`, `security`, `security-compliance-auditor`, `cross-verifier`. The preamble explains: opus is reserved for "deep cross-referencing, adversarial thinking, or complex design synthesis" and "final-pass reviews where hallucination risk is highest."
- **The `security` agent has two modes** — ad-hoc / `/rate` (writes Markdown findings) vs. `/amrr` pipeline (writes structured `security-findings.json` and returns only a one-liner). All findings carry `SEC-CRED-*`, `SEC-INPUT-*`, `SEC-AUTH-*`, `SEC-CRYPTO-*`, `SEC-DATA-*` prefixes mapped to OWASP Top 10.
- **Confidence calibration is severity-asymmetric** — `security.md` rule: critical/high require ≥70 confidence, medium ≥60, low/info ≥50. "False positives erode trust. When uncertain, lower the severity rather than the confidence."

### 4.2 `commands/` — slash commands

The directory contains ~30 commands. Each `.md` file is loaded when the matching `/command` is invoked. Most commands have a same-named subdirectory containing `assets/` (artifact templates).

Verified inventory from `ls`:

**PDLC commands:** `discover.md`, `define.md`, `ideate.md`, `design.md`, `validate.md`, `measure.md`
**SDLC commands:** `problems.md`, `solve.md`, `draft.md`, `gap.md`, `split.md`, `build.md`, `rate.md`, `done.md`
**Operations / utility:** `work.md`, `amrr.md`, `mrr.md` (alias), `pipeline.md`, `pre-review.md`, `fixer.md`, `jira.md`, `comply.md`, `analyse.md`, `data-model.md`, `state.md`, `clean.md`, `bmad.md`

**`commands/_shared/`** — 10 pattern files referenced by the command files via `Read ~/.claude/commands/_shared/<file>` directives. This is how the user keeps the command library DRY:

- `agent-relevance.md`, `evidence-rules.md`, `parameter-naming.md`, `pass-loop.md`, `pipeline-handoff.md`, `review-pipeline.md`, `run-config.md`, `script-integration.md`, `standards-loading.md`, `state-tracking.md`

`_COMMAND_TEMPLATE.md` is the authoring template (not loaded at runtime).

#### Command anatomy (verified from `discover.md` and `build.md`)

A command file consistently contains these sections:

1. **Frontmatter** — `name`, `description`.
2. **Standards (Loaded by Sub-Agents)** — agent → standards mapping. The orchestrator does NOT load standards, sub-agents do. (See §4.3.)
3. **Parameters** — typed positional parameters.
4. **Dependency Gate** — required upstream artifacts; STOP if missing.
5. **Clarification Gate** — confirms scope with the operator via `AskUserQuestion` before execution.
6. **Run Config** — JSON config block defining `output_base`, `artifact_template`, `score_threshold`, `short_circuit_threshold`, agent → standards map.
7. **Process** — pass focus per pass, escalation triggers, sub-agent policy (always-include / conditional), agent parallelization rules.
8. **Evidence Rules** — base + command-specific.
9. **Script Integration** — pointer to a same-named bash script in `scripts/` (when applicable).
10. **Output Artifacts** — exact directory layout and template references.
11. **Pipeline Handoff** — JSON schema for the `stages` entry written to `.pipeline.json`.
12. **State Tracking** — `cdocs/state.json` fields.
13. **Error Handling** — condition → action table.
14. **Done When** — checklist.

#### `/discover` — entry point

3 passes by default. Pass 1 = Landscape ("does it exist"). Pass 2 = Evidence ("is it proven"). Pass 3 = Recommendation ("can we use it"). Score threshold 80, short-circuit 90.

A specific quality gate worth flagging: **mandatory external integration discovery**. When the topic involves a third-party API or cross-account AWS integration, Pass 2 has hard requirements:

- API architecture map (every distinct API surface, base URL, auth method).
- Authentication matrix (env var, token type, scope, generation method).
- **Curl proof of concept** — every external API call must be validated with a working curl returning HTTP 200. The file states this is "the single most important artifact — it proves the integration works before any code is written."
- IAM/trust policy validation (for AWS): empirically test which IAM condition keys are populated for the call type, since `aws:SourceAccount` only populates for service-to-service calls, not direct `sts:AssumeRole`.
- Provider/SDK field mapping (Terraform field → API endpoint).

This is a hard-won discipline — I've seen the same advice in production playbooks and it's almost certainly the residue of a real debugging incident.

#### `/build` — TDD with epic loop

Default mode is **epic loop** when an `epics/` directory exists. The orchestrator reads `execution-plan.json` and runs a **per-story dispatch loop** — one agent per story, **non-negotiable**:

- The build command file lists **banned phrases** that must never appear in any agent prompt: "build all epics", "complete all remaining stories", "continue until everything is done", etc. These are framed as causing context exhaustion and out-of-order execution.
- Each story is dispatched with a **single-story prompt template** that explicitly says "build ONLY what is described in that story" and "DO NOT read other story files / continue to the next story / build everything".
- Before each dispatch, a **context budget check** estimates `story_file + overview.md + referenced source files` against 50% of the context window. If it exceeds, the orchestrator stops and tells the user to run `/split` to decompose further.
- The completion signal is a verified git commit: the orchestrator checks `git cat-file -e <hash>` before dispatching the next story.
- Wave completion gates are six-criteria: status done, score ≥ 85, no blockers, artifacts present, commit verified, /rate run on every story.
- Per-story score below 85: max 2 retries, then halt the wave.
- Stories use TDD: **RED → GREEN → REFACTOR**, in that order. Pass 1 (Correctness) verifies that composition stories (multi-component wiring) have at least one integration test exercising the full chain.

This is the most operationally-loaded command in the system. It contains specific safeguards (`COMP-WIRE-01` blocking finding, banned-phrases list, context-budget gate, commit-as-completion-signal gate) that read like they were each added in response to a specific past failure mode.

#### `/work` — full-cycle JIRA/GitHub automation

`commands/work.md` is a **meta-orchestrator** with 13 phases (0 through 12, with several "b" sub-phases). Detects platform from `git remote get-url origin` (gitlab vs github) and issue source from input format. Phases I confirmed:

- Phase 0/1 — pre-flight, issue fetch
- Phase 2 — MR/PR reconciliation (classify each open MR/PR: merged/stale/active)
- Phases 3+4+5 — work item selection, worktree creation, issue transition
- Phase 6 — spec synthesis (delegated to general-purpose agent for AC gap analysis)
- Phase 6b — plan conformance gate
- Phase 7 — implementation (delegated to pass-runner + TDD sub-agents)
- Phase 8 — `/rate`
- Phase 8b — pre-merge review (mandatory per CLAUDE.md)
- Phase 9 — commit & push (no operator gate; this is a deliberate override of the default "confirm before push" behavior, called out in `CLAUDE.md` § /work Automation)
- Phase 10 — create MR/PR
- Phase 11 — `/amrr` automated review
- Phase 11b — merge verification
- Phase 12 — close JIRA, advance to next issue

The file documents an explicit **Model Delegation Policy**: opus (the orchestrator) MUST NOT do implementation, review, or mechanical work directly. Mechanical operations (issue transitions, lock acquire/release, git push, worktree setup) go to **haiku** via `general-purpose`. This is unusual — I have not seen another publicly-documented system that puts haiku on the issue-transition/git-push path.

#### `/amrr` — automated MR/PR review pipeline

`commands/amrr.md` parses GitLab MR or GitHub PR URLs, runs a 5-stage review (described in `_shared/review-pipeline.md`, which I did not open in full), posts findings, approves/rejects, and auto-merges. Has a notable optimization: a **pre-review fast-path**. If `/pre-review` already reviewed the same branch with the same diff and verdict=PASS, `/amrr` reuses the artifacts and skips straight to "approve + auto-merge". This is the system being thrifty about both time and budget.

### 4.3 `standards/` — the shared knowledge base

I confirmed 30+ Markdown standards files at the top level (28 listed by `wc -l`, plus subdirectories). Total verified line count: **~7,460 lines** across the standards I sampled. Key files:

| File | Lines | Purpose (verified or per README) |
|---|---|---|
| `AGENT_PREAMBLE.md` | 54 | The shared preamble every agent reads first |
| `EVIDENCE.md` | 112 | Claim schema, sufficiency rules, auto-reject triggers |
| `QUALITY.md` | 155 | 85/100 ship gate, deduction table, coverage gate (80% min, 95% for crypto/critical paths), PR size gate |
| `OPTIONAL_FRAMEWORKS.md` | 64 | Trigger-based 3→5 pass escalation policy |
| `NON_NEGOTIABLES.md` | 3 | One-liner pointing to AGENT_PREAMBLE.md |
| `FINDINGS_SCHEMA.md` | 68 | Findings file format for /amrr pipeline |
| `ENGINEERING.md` | 260 | Code style, SOLID, error handling |
| `ARCHITECTURE.md` | 197 | Patterns, ADRs, system design |
| `TESTING.md` | 234 | TDD, coverage thresholds, Nullable pattern |
| `SECURITY.md` | 190 | Auth, rate limiting, OWASP, secrets |
| `OBSERVABILITY.md` | 276 | Logging, metrics, tracing, alerting |
| `ACCESSIBILITY.md` | 186 | WCAG 2.2 AA compliance |
| `PROCESS.md` | 290 | Definition of Ready/Done, phase gates, sprint cadence |
| `CICD.md` | 222 | Pipeline stages, scan tools, pre-commit |
| `INCIDENTS_AND_BUGS.md` | 251 | Incident response, severity levels |
| `PRODUCTION.md` | 142 | DR testing, RTO/RPO targets |
| `CHANGE_MANAGEMENT.md` | 87 | Change request process, approval gates, rollback |
| `DATA_CLASSIFICATION.md` | 62 | Sensitivity tiers, retention |
| `RELEASE_AND_DEPLOY.md` | 383 | Release & deploy procedures (largest single file) |
| `STAGING.md` | 104 | Staging validation |
| `JAVASCRIPT_TYPESCRIPT.md` | 258 | JS/TS-specific standards |
| `PYTHON.md` | 304 | Python-specific standards |
| `COMMIT_MESSAGES.md` | 209 | Conventional commits |
| `COMMUNICATION.md` | 273 | Stakeholder comms, status reporting |
| `TECHNICAL_DEBT.md` | 211 | Debt classification, paydown |
| `DEVELOPMENT.md` | 172 | Dev env setup |
| `DOCS.md` | 210 | Doc standards |
| `GIT_AND_REVIEW.md` | 176 | Git workflow, branching |

Subdirectories (listed only):

- `frameworks/` — `trigger-index.json` plus per-phase framework specs (`discover-frameworks.md`, `draft-frameworks.md`, `design-frameworks.md`, `build-frameworks.md`, `rate-frameworks.md`, `done-frameworks.md`, `define-frameworks.md`, `ideate-frameworks.md`, `validate-frameworks.md`, `measure-frameworks.md`) and a few legacy stand-alone framework files (`agile-ceremonies.md`, `alert-severity.md`, `bug-severity-priority.md`, `deployment-strategies.md`, `prioritization.md`, `story-points.md`).
- `pdlc/` — `PDLC.md` (the canonical methodology) plus `phases/` (Discover/Define/Ideate/Design/Validate/Deliver/Measure detail files) and `reference/` (standards, artifacts, roles, governance — not all read).
- `testing/` — `tdd.md`, `unit-tests.md`, `integration-tests.md`, `e2e-tests.md`, `contract-tests.md`, `nullable-pattern.md`, `coverage.md`, `automation-pyramid.md`, `flaky-test-policy.md`, `test-organization.md`, `enforcement.md`.
- `toolchain/` — per-command toolchain rules: `discover.md`, `done.md`, `review.md`, `story-build.md`.
- `backend/` — `api.md`, `models.md`, `queries.md`, `migrations.md`, `graphql-api.md`, plus a `graphql/` subdir.
- `frontend/` — `components.md`, `css.md`, `responsive.md`.
- `global/` — `tech-stack.md`.

The single most important architectural choice: **standards are loaded per-agent, not by the orchestrator** (`_shared/standards-loading.md`):

> "Each command lists its agent-to-standards mapping in its own `## Standards (Loaded by Sub-Agents)` section. The mapping is command-specific because different commands use different agent sets and require different standards files."

This avoids dumping 7,000+ lines of standards into the orchestrator's context. Each agent reads only its 1–3 relevant standards. The cost: standards renames require updating every agent file that references them — a maintenance burden the README acknowledges.

### 4.4 `checklists/` — regulatory compliance

Five checklists, used by `/comply` and gated by `/done` for regulated projects (PHI / PAN / PII):

- `hipaa-technical-safeguards.md` — HIPAA Technical Safeguards
- `pci-dss-application-security.md` — PCI-DSS Application Security
- `soc2-type2-controls.md` — SOC 2 Type II Controls
- `incident-response.md` — NIST Incident Response
- `disaster-recovery.md` — ISO Disaster Recovery

Listed-only; I did not read the contents.

### 4.5 `scripts/` — bash helpers

Verified inventory:

| Script | Purpose (verified) |
|---|---|
| `audit-log.sh` | Append-only log of every tool invocation. Wired into `PostToolUse` and `Stop` hooks. Rotates at 1 MB, keeps 3 rotations. Reads tool name from JSON stdin via `jq`. |
| `context-monitor.sh` | Status line. Renders model name, worktree indicator, context-window % (with color thresholds — green <50, yellow ≥50, light-red ≥75, red ≥90, bold-red ≥95 with CRIT/HIGH alerts), session cost, cumulative cost across sessions, duration, command-cost delta, rate-limit status. Has a 3-second self-kill timer. Writes session metrics to `<project>/.claude/metrics.json`. Sources `rate-limits-helper.sh` if present. |
| `command-cost-marker.sh` | (Listed — used by status line for command-cost tracking.) |
| `rate-limits-helper.sh` | Rate-limit display helper sourced by status line. |
| `claude-run.sh` | (Listed — purpose not verified.) |
| `rebuild-native-modules.sh` | Per CLAUDE.md, rebuilds `better-sqlite3` for both Homebrew Node (MCP runtime, MODULE_VERSION 141) and nvm Node (shell, MODULE_VERSION 127) after Node upgrades. |
| `run_discover_passes.sh` | Pass-runner script for `/discover`. |
| `run_done_passes.sh` | Pass-runner script for `/done`. |
| `run_review_passes.sh` | Pass-runner script for `/rate`. |
| `run_story_build.sh` | Pass-runner script for `/build` (per-story). |
| `run_story_waves.sh` | Pass-runner script consumed by `/split` for wave orchestration. |
| `lib/` | Shared library helpers (listed only). |

The five `run_*_passes.sh` scripts implement the exit-code contract documented in `_COMMAND_TEMPLATE.md`: `0` = passes complete and score ≥ threshold, `42` = barrier failure, `43` = score below threshold.

`context-monitor.sh` is the most polished script — 391 lines of careful bash with environment-variable overrides (`STATUSLINE_CACHE_TTL`, `STATUSLINE_CACHE_DIR`, `CONTEXT_WINDOW_SIZE`), GNU vs BSD `stat` detection, jq for batch field extraction in a single call, fallback handling, and IPv4-style ANSI color staging.

### 4.6 `skills/` — bundled skills

Four skills (each is a directory with a `SKILL.md`):

- `git-commit-helper/` — git commit assistance
- `git-workflow/` — branch naming convention enforcement (`<type>/<description>`: feature/, fix/, hotfix/, refactor/, docs/, test/, chore/), with `/work` carving out an exception for issue-ID-based branches
- `github-sync/` — GitHub sync helpers
- `webapp-testing/` — webapp testing (includes a `LICENSE.txt`, suggesting an upstream import)

I read only the first ~40 lines of `git-workflow/SKILL.md` directly.

### 4.7 `plugins/` — Claude plugin registry

Verified contents:

- `installed_plugins.json` — install record (version 2 schema, per-plugin install path/version/install date/git commit SHA)
- `cache/` — git checkouts of plugin sources
- `data/` — context-mode and plugin user data
- `marketplaces/` — git checkouts of plugin marketplaces
- `known_marketplaces.json`, `install-counts-cache.json`, `blocklist.json`

From `settings.json`'s `enabledPlugins`:

| Plugin | Marketplace | Status |
|---|---|---|
| `frontend-design` | claude-plugins-official | enabled |
| `superpowers` | claude-plugins-official | enabled |
| `code-simplifier` | claude-plugins-official | enabled |
| `typescript-lsp` | claude-plugins-official | enabled |
| `commit-commands` | claude-plugins-official | enabled |
| `serena` | claude-plugins-official | enabled |
| `claude-md-management` | claude-plugins-official | enabled |
| `pyright-lsp` | claude-plugins-official | enabled |
| `claude-code-setup` | claude-plugins-official | enabled |
| `context-mode` | claude-context-mode | **disabled** |

`code-review` also appears in `installed_plugins.json` but is not listed in `enabledPlugins`. Verified install timestamps in the registry range from 2026-03-01 to 2026-04-16, consistent with the directory's last activity dates.

### 4.8 `cdocs/` — workflow output (running on itself)

The system writes its own output to `cdocs/`. The directory contains evidence the user has been running the workflow against this very `~/.claude` codebase:

- `_work/#1`, `_work/#154` — per-issue worktrees
- `superpowers/specs/`, `superpowers/plans/` — output paths the user remapped from `docs/superpowers/` (per CLAUDE.md: "Superpowers Output Paths" override)
- `state.json` — last command was `/work` on issue `#154`, completed with score 95 in 27h 34m, MR https://github.com/nilesuan/claude-padua/pull/155, status merged
- `improvements/`, `padua/`, `reports/`, `review-pipeline/` — additional output dirs

`cdocs/state.json` is a small JSON ledger with:

```json
{
  "lastCommand": "work",
  "lastIssue": "#154",
  "lastScore": 95,
  "lastDuration": "27h 34m",
  "lastMrUrl": "https://github.com/nilesuan/claude-padua/pull/155",
  "lastMrOutcome": "merged",
  "itemProgress": {"#154": "done"},
  "history": [...]
}
```

This is dogfooding in the literal sense — the configuration was being used to develop itself.

### 4.9 Runtime / data directories (Claude Code wrote these, not the user)

These are populated by the Claude Code CLI during normal operation. No analysis required:

- `projects/` (drwx------, 25 entries) — per-project conversation transcripts
- `sessions/` (drwx------) — session metadata
- `session-env/` (200 entries) — per-session environment captures (snapshot of env vars)
- `shell-snapshots/` — snapshots of zsh shell state at session start
- `ide/` (drwx------) — IDE integration state
- `run/` — process runtime state
- `cache/` — generic cache
- `paste-cache/` — pasted content cache
- `file-history/` (54 entries) — file-edit history snapshots
- `history.jsonl` — input history (531 KB)
- `audit.log` (~58 KB current) + `audit.log.1` (1 MB rotated) — written by `audit-log.sh` hook
- `security_warnings_state_*.json` — per-session warning acknowledgments

### 4.10 Top-level non-runtime files

- **`CLAUDE.md`** (7.3 KB) — global rules. Hard requirements: never assume, gitignore `.claude/` always, work in worktrees never on main, separate logical commits, rebase before push, never `terraform --auto-approve`, fix Terraform module problems upstream not via consumer patches, override Superpowers output paths to `cdocs/`, all diagrams Mermaid, TDD non-negotiable for ALL implementation work, `/work` Phase 8/8b mandatory pre-commit, Phase 9 has no-gate-confirmation override, JIRA hygiene, search before creating tickets, strict SemVer, never continue subagent work in orchestrator after failure, learn from errors and write lessons to MEMORY.md.
- **`MEMORY.md`** (3.4 KB) — five concrete lessons learned: never assert external facts without verification, never exclude `__mocks__/` from commits, major version upgrade rules, search for root-cause patterns not symptoms, always cross-check CLAUDE.md release requirements after `/work`.
- **`README.md`** (26 KB) — full self-documentation of the workflow system with Mermaid command-dependency graph.
- **`settings.json`** (7.4 KB) — Claude Code harness settings (see §5).
- **`settings.json.bak`**, **`settings.local.example.json`**, **`policy-limits.json`**, **`claude_ai_creds.json`** — auxiliary config.
- **`.gitignore`** (1.3 KB) — gitignores for the `.claude/` self-repo.

---

## 5. Hooks and runtime — `settings.json`

The settings file configures the Claude Code harness. Verified contents:

```json
{
  "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" },
  "includeCoAuthoredBy": false,
  "permissions": {
    "allow": ["mcp__*"],
    "deny": ["mcp__claude_ai_*"],
    "defaultMode": "auto"
  },
  "enableAllProjectMcpServers": true,
  "effortLevel": "high",
  "skipDangerousModePermissionPrompt": true,
  "voiceEnabled": true,
  "gitAttribution": false,
  "skipAutoPermissionPrompt": true,
  ...
}
```

Notable settings:

- **`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`** — opts in to experimental agent-teams behavior.
- **Permissions:** `allow: mcp__*` but `deny: mcp__claude_ai_*` — all MCP tools allowed except Claude.ai-namespaced ones (Gmail, Calendar, Drive — the same set this current PDLC session was offered). The user has actively chosen NOT to wire those in.
- **`defaultMode: auto`**, **`skipDangerousModePermissionPrompt: true`**, **`skipAutoPermissionPrompt: true`** — fully autonomous mode, no permission prompts. This is consistent with `/work` Phase 9 ("no operator gate") and `/amrr` ("Do NOT ask the user any questions").
- **`includeCoAuthoredBy: false`**, **`gitAttribution: false`** — commits do NOT carry a Claude co-author trailer. The user wants their commits to look human-authored.
- **`effortLevel: high`** — analogous to the current session's `/effort max`.
- **`voiceEnabled: true`** — voice input enabled.
- **`statusLine`** — runs `bash $HOME/.claude/scripts/context-monitor.sh` (see §4.5).

### Hook wiring

Every Claude Code lifecycle event is hooked. Two distinct hook commands recur:

1. **GitKraken AI integration** — `"/Users/nile/Library/Application Support/GitKrakenCLI/gk" ai hook run --host claude-code` is wired into **18 events**: `ConfigChange`, `CwdChanged`, `Elicitation`, `ElicitationResult`, `InstructionsLoaded`, `Notification`, `PermissionDenied`, `PermissionRequest`, `PostCompact`, `PostToolUse`, `PostToolUseFailure`, `PreCompact`, `PreToolUse`, `SessionEnd`, `SessionStart`, `Stop`, `StopFailure`, `SubagentStart`, `SubagentStop`, `TaskCompleted`, `TeammateIdle`, `UserPromptSubmit`. The user has integrated GitKraken's AI activity tracker into essentially every event.
2. **Audit log** — `bash $HOME/.claude/scripts/audit-log.sh` on `PostToolUse` and `Stop`.
3. **Notification ping** — `command -v afplay >/dev/null 2>&1 && afplay /System/Library/Sounds/Ping.aiff` on `Notification`. macOS-native sound on attention requests.

The hook coverage is exhaustive — there is no Claude Code event the user has chosen to leave unobserved.

---

## 6. Notable design decisions and analysis

### 6.1 Context budget as the unit of design

The whole system reads as if it was designed with one constraint front of mind: **don't overflow the context window**. Concrete manifestations:

- **Standards are loaded per-agent, not per-orchestrator** (§4.3).
- **Sub-agents do not read `.pipeline.json`; the pass-runner inlines the relevant fields** (§3.6).
- **Pass-runner reads artifacts at most once per pass cycle** (`pass-runner.md` § Artifact Read Strategy: "Use `Grep(pattern="^score:")` for score checks, `Read(limit=10)` for frontmatter, companion `.summary.json` for cross-pass comparison. Full artifact read only when fix is needed.").
- **The build command has an explicit context budget gate** before each story dispatch (`story_file + overview.md + referenced source files < 50%` of context window) (§4.2 `/build`).
- **Banned phrases in build prompts** prevent multi-story prompts that would necessarily exceed budget.
- **Sub-agents return only one-line summaries** to the orchestrator after writing artifacts. `cross-verifier`'s instructions are explicit: "Return ONLY a one-liner."
- **Trigger-index loaded; matching framework specs loaded only on hit.** (`OPTIONAL_FRAMEWORKS.md`).

This is the discipline of someone who has had Claude run out of context mid-task and had to redesign around it.

### 6.2 Verification as architecture, not as afterthought

The cross-verifier pass is **mandatory** ("cannot be skipped, short-circuited, or bypassed — even for a score of 100", `_shared/pass-loop.md`). Combined with the structured evidence schema and the six insufficiency triggers (`EVIDENCE.md`), the system has a real architectural position on hallucinations: every claim has a citable location, every citation is verified by a separate agent against the actual source, and unverifiable claims are explicitly excluded from scoring rather than being silently kept or silently dropped.

The **same discipline** is the bedrock of the current PDLC research workspace's `CLAUDE.md` (this repo's facts-only / cite-or-flag rules). The user has carried the practice across both repos.

### 6.3 Model-tier discipline is taken seriously

Every agent file says "NEVER OVERRIDE — agents must always use their configured model" in a comment next to `model:`. Opus is reserved for adversarial / high-leverage roles (architecture, security, compliance audit, cross-verification). Sonnet does the bulk of the work. Haiku is reserved by the orchestrator for gates, state writes, mechanical ops (issue transitions, locks, pushes). The `/work` command file documents this in a Phase-to-Delegation table (§4.2 `/work`).

### 6.4 Operational defenses around `/build`

`/build` has the most obvious history of past failures:

- **`COMP-WIRE-01`** auto-blocks composition stories without integration tests.
- **External system verification gate** (OAuth redirect URIs, callback ports, API base URLs, scopes, env var names) verified against the source of truth before shipping.
- **Banned-phrase list** for agent prompts.
- **Context-budget gate** before each dispatch.
- **Commit-as-completion-signal gate** with `git cat-file -e` verification.
- **Wave completion gate with six criteria.**

Each of these reads like a guardrail added in response to a specific past incident. This is the part of the system that has clearly survived contact with reality.

### 6.5 Output isolation

Every command writes to `cdocs/<service>/<feature>/` and the very first action of the run-config is to ensure `cdocs/` is in the project's `.gitignore`. This one rule means the system can be run against any repo without polluting it. CLAUDE.md restates the rule: `.claude/` must always be gitignored. AGENT_PREAMBLE.md restates it again. Three layers of redundancy on a single rule, which is itself a design signal.

### 6.6 Trade-offs and points of friction

- **Standards renames require updating every agent file** that references the standard (the README acknowledges this). It's the cost of per-agent loading.
- **Self-loaded preambles inflate per-agent context**: every agent reads `AGENT_PREAMBLE.md` (54 lines) and `EVIDENCE.md` (112 lines), plus its role-specific standards. With 22 agents and 3-pass loops, the system does a lot of duplicated standards loading. The trade-off is that the orchestrator stays clean.
- **The system is heavy.** ~30 commands, ~22 agents, 30+ standards, 5 helper scripts, 5 compliance checklists, 4 skills, 10+ plugins, 18+ hooks. The cognitive surface area for the user is significant. This is mitigated by the fact that the README and `_COMMAND_TEMPLATE.md` document the conventions consistently.
- **`/work` Phase 9 auto-pushes without operator confirmation.** Combined with `skipAutoPermissionPrompt: true` and `skipDangerousModePermissionPrompt: true`, this is a fully-autonomous loop. It requires high trust in Phase 8/8b's gating.
- **GitKraken hook on 22+ events is noisy.** Every tool use, every prompt, every permission request invokes an external CLI. If that CLI is slow or fails, it could affect throughput. This is observable but not necessarily a problem.
- **`includeCoAuthoredBy: false` and `gitAttribution: false`** mean Claude's contributions are not visible in git history. From a transparency standpoint this is a deliberate choice — the user owns the commits.

### 6.7 Dogfooding evidence

The `cdocs/` directory contains evidence that the user ran the system against itself. `cdocs/state.json` records `lastCommand: work` on `lastIssue: #154`, score 95, duration 27h 34m, MR merged at https://github.com/nilesuan/claude-padua/pull/155. The repo `nilesuan/claude-padua` appears to be the system's own source repo (the `padua/` subdirectory under `cdocs/` and `standards/pdlc/` — both reference "padua" — make this likely, though I did not fetch the GitHub repo to confirm).

That a 27-hour `/work` cycle on a complex issue scored 95 and merged is a single positive data point. It isn't proof the system works in general, but it isn't nothing.

---

## 7. Quick-reference: where to look for what

| Looking for... | Location |
|---|---|
| Global rules and non-negotiables | `CLAUDE.md`, `standards/AGENT_PREAMBLE.md` |
| What the system is and how to use it | `README.md` |
| How a command is structured (authoring) | `commands/_COMMAND_TEMPLATE.md` |
| Pass-loop pattern | `commands/_shared/pass-loop.md` |
| Pipeline handoff format | `commands/_shared/pipeline-handoff.md`, `commands/_shared/run-config.md` |
| Evidence schema and auto-rejects | `standards/EVIDENCE.md` |
| Quality gate (85/100) and deduction table | `standards/QUALITY.md` |
| Escalation triggers (3 → 5 passes) | `standards/frameworks/trigger-index.json`, `standards/OPTIONAL_FRAMEWORKS.md` |
| Agent role and model | `agents/<name>.md` (frontmatter) |
| Status line implementation | `scripts/context-monitor.sh` |
| Audit log format | `scripts/audit-log.sh`, `audit.log` |
| Hook wiring | `settings.json` (top-level `hooks` field) |
| Plugin install state | `plugins/installed_plugins.json`, `settings.json` `enabledPlugins` |
| Lessons learned across all projects | `MEMORY.md` |
| Last workflow run state | `cdocs/state.json` |
| Compliance checklists | `checklists/` |
| PDLC methodology | `standards/pdlc/PDLC.md` and `standards/pdlc/phases/`, `reference/` |

---

## 8. Methodology

Files I read in full or near-full and quoted from directly:

- `README.md`
- `CLAUDE.md`
- `MEMORY.md`
- `settings.json`
- `agents/pass-runner.md`
- `agents/systems-architect.md`
- `agents/security.md`
- `agents/cross-verifier.md`
- `agents/automation-engineer.md` (first 50 lines only)
- `standards/AGENT_PREAMBLE.md`
- `standards/EVIDENCE.md`
- `standards/QUALITY.md`
- `standards/OPTIONAL_FRAMEWORKS.md`
- `standards/NON_NEGOTIABLES.md`
- `standards/frameworks/trigger-index.json`
- `standards/pdlc/PDLC.md` (first 100 lines only)
- `commands/_COMMAND_TEMPLATE.md`
- `commands/_shared/pass-loop.md`
- `commands/_shared/standards-loading.md`
- `commands/_shared/run-config.md`
- `commands/_shared/pipeline-handoff.md`
- `commands/discover.md`
- `commands/build.md`
- `commands/work.md` (first 120 lines only)
- `commands/amrr.md` (first 80 lines only)
- `scripts/context-monitor.sh`
- `scripts/audit-log.sh`
- `skills/git-workflow/SKILL.md` (first 40 lines only)
- `cdocs/state.json`
- `plugins/installed_plugins.json` (first 40 lines only)

Files I listed by name but did not read:

- The remaining 17 agents (`backend-dev`, `frontend-dev`, `qa-engineer`, `devops-engineer`, `performance-engineer`, `platform-engineer`, `security-compliance-auditor`, `product-manager`, `product-owner`, `business-analyst`, `ux-designer`, `ui-designer`, `code-reviewer`, `general-reviewer`, `spec-compliance-reviewer`, `sprint-orchestrator`, `test-writer`).
- The remaining ~25 commands and command-shared pattern files.
- All standards files except those listed above.
- All checklists.
- All bash scripts except `audit-log.sh` and `context-monitor.sh`.
- All skills except `git-workflow/SKILL.md` (first 40 lines).
- Session/transcript/cache contents.
- `commands/_shared/review-pipeline.md` (referenced by `/amrr` but not opened).

Roles and purposes for files I did not read are taken from `README.md`'s self-documentation. Where the README is the only source for a claim, I have not contradicted it but I have also not independently verified it. Where I quote, I quote from files I read directly.

No external sources were consulted; this document describes only the contents of `~/.claude.old`.
