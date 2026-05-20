# MAPPING.md — System → Handbook → Research traceability

This is the index that traces every system artifact back to its source: the prescriptive `handbook/` chapter and the citation-bearing `research/` files (or `platform-team/` policy docs) that ground it.

If you cannot find an entry here for a claim, the claim is not grounded — open an issue or add the source.

## Phase commands

| System artifact | Handbook chapter | Research / policy source |
|---|---|---|
| `commands/discover.md` | `handbook/01-discover.md` | `research/01-ideation/` (Discovery, JTBD, ODI, OST, four-risks) |
| `commands/plan.md` | `handbook/02-plan.md` | `research/02-planning/` (OKRs, RICE, Now/Next/Later, strategy kernel) |
| `commands/design.md` | `handbook/03-design.md` | `research/03-design/` (C4, Clean Arch, STRIDE, ADR, NFRs) |
| `commands/build.md` | `handbook/04-build.md` | `research/04-development/` + `platform-team/engineering-policy.md` §1, §4, §6, §7, §8, §9 |
| `commands/test.md` | `handbook/05-test.md` | `research/05-testing/` + `platform-team/engineering-policy.md` §5 |
| `commands/ship.md` | `handbook/06-ship.md` | `research/06-release/` + `platform-team/engineering-policy.md` §3 + `platform-team/developer-guidelines.md` §8, §9 + `NOTES.md` |
| `commands/run.md` | `handbook/07-run.md` | `research/07-operations/` + `platform-team/developer-guidelines.md` §6 (Observability) + `platform-team/on-call-operations.md` |
| `commands/evolve.md` | `handbook/08-evolve.md` | `research/08-maintenance/` + `platform-team/developer-guidelines.md` §14 (Deprecation policy) |

## Cross-cutting commands

| System artifact | Source |
|---|---|
| `commands/review.md` | `platform-team/engineering-policy.md` §8; `standards/development/CODE_REVIEW.md` |
| `commands/_shared/pass-loop.md` | This system; orchestration pattern from `SYSTEM.md` analysis of `.claude.old` |
| `commands/_shared/pipeline-handoff.md` | This system; orchestration pattern |
| `commands/_shared/evidence-format.md` | `standards/EVIDENCE.md` |

## Phase exit checklists

| Checklist | Distilled from |
|---|---|
| `standards/checklists/01-discover-exit.md` | `handbook/01-discover.md` "Done when" + four-risks (Cagan), CDH (Torres) |
| `standards/checklists/02-plan-exit.md` | `handbook/02-plan.md` + Rumelt strategy kernel, Doerr OKRs, Wodtke Radical Focus |
| `standards/checklists/03-design-exit.md` | `handbook/03-design.md` + C4 (Brown), Clean Arch (Martin), STRIDE (Shostack) |
| `standards/checklists/04-build-exit.md` | `handbook/04-build.md` + `platform-team/engineering-policy.md` §1, §4, §6, §7, §8, §9 |
| `standards/checklists/05-test-exit.md` | `handbook/05-test.md` + `platform-team/engineering-policy.md` §5 + Cohn / Fowler / Vocke / Dodds |
| `standards/checklists/06-ship-exit.md` | `handbook/06-ship.md` + Humble & Farley + `NOTES.md` deployment policy + DORA |
| `standards/checklists/07-run-exit.md` | `handbook/07-run.md` + Google SRE Book + Allspaw |
| `standards/checklists/08-evolve-exit.md` | `handbook/08-evolve.md` + Fowler tech-debt quadrant + Strangler Fig + RFC 8594 |

## Domain standards

### Development

| Standard | Source |
|---|---|
| `standards/development/TRUNK_BASED.md` | `platform-team/engineering-policy.md` §1; Hammant *Trunk-Based Development*; DORA |
| `standards/development/TDD.md` | `platform-team/engineering-policy.md` §4; Beck *TDD By Example*; Fowler "TestDrivenDevelopment" |
| `standards/development/SOLID.md` | `platform-team/engineering-policy.md` §6; Martin "Solid Relevance" (2020) |
| `standards/development/CLEAN_ARCHITECTURE.md` | `platform-team/engineering-policy.md` §7; Martin "The Clean Architecture" (2012) |
| `standards/development/CODE_REVIEW.md` | `platform-team/engineering-policy.md` §8; Google Engineering Practices; Bacchelli & Bird ICSE 2013 |
| `standards/development/PYTHON.md` | PEP 8 (verified); `handbook/04-build.md` §"Automate with a formatter / linter / type checker"; `research/04-development/coding-practices.md` §5–6; `research/05-testing/non-functional-testing.md` (Bandit via OWASP) |
| `standards/development/TYPESCRIPT.md` | Google Style Guides (TypeScript guide listed, verified); Airbnb JS Style Guide (verified); `handbook/04-build.md` §"Automate with a formatter / linter / type checker"; `research/04-development/coding-practices.md` §5–6 |

### Testing

| Standard | Source |
|---|---|
| `standards/testing/TEST_STRATEGY.md` | `platform-team/engineering-policy.md` §5; `handbook/05-test.md`; Cohn / Fowler / Vocke / Dodds; Meszaros |

### Release

| Standard | Source |
|---|---|
| `standards/release/CONTINUOUS_DELIVERY.md` | `platform-team/engineering-policy.md` §3; `handbook/06-ship.md`; Humble & Farley *Continuous Delivery* |
| `standards/release/DEPLOYMENT_PIPELINE.md` | `platform-team/developer-guidelines.md` §9; `NOTES.md` |
| `standards/release/CONTAINER_TAGGING.md` | `platform-team/developer-guidelines.md` §8; `NOTES.md` (build-once policy); cosign / SLSA |
| `standards/release/VERSIONING.md` | `platform-team/engineering-policy.md` §9; Conventional Commits 1.0.0; SemVer 2.0.0 |

### Operations

| Standard | Source |
|---|---|
| `standards/operations/OBSERVABILITY.md` | `platform-team/developer-guidelines.md` §6 (Observability requirements); `research/07-operations/observability.md`; Google SRE Book; OpenTelemetry semantic conventions |
| `standards/operations/ON_CALL.md` | `handbook/07-run.md`; `platform-team/on-call-operations.md`; `research/07-operations/incident-response.md`; `research/07-operations/sre.md`; Google SRE Book; Allspaw debriefing guide |

### Security

| Standard | Source |
|---|---|
| `standards/security/OWASP.md` | `platform-team/developer-guidelines.md` §10 (Security baseline); `research/03-design/security-design.md`; `research/05-testing/non-functional-testing.md`; OWASP Top 10; OWASP ASVS; NIST SP 800-218 |
| `standards/security/AUTH.md` | `platform-team/developer-guidelines.md` §10 (Security baseline); `research/03-design/security-design.md`; OWASP ASVS V2/V3/V4; NIST SP 800-63B; RFC 6749 / 7636 / 7519 / 8252 / 8725; OIDC Core 1.0 |

### Platform

| Standard | Source |
|---|---|
| `standards/platform/AWS_ECS_TERRAFORM.md` | `platform-team/developer-guidelines.md` §1–3 (Naming/Limits/Tags), §4 (Terraform), §5 (Secrets), §7 (Networking), §8 (Container images), §10 (Security baseline); AWS ECS Best Practices; AWS Well-Architected; `NOTES.md` (production stack) |
| `standards/platform/TERRAFORM_DISCIPLINE.md` | `platform-team/developer-guidelines.md` §4 (Terraform and infrastructure repository model); `NOTES.md` (plan-on-MR / apply-on-merge); Brikman *Terraform Up & Running* |
| `standards/platform/GITLAB_SECURITY.md` | `platform-team/developer-guidelines.md` §11 (Repository standards), §9 (Deployment requirements), §10 (Security baseline); `NOTES.md`; OWASP CI/CD Top 10; SLSA |
| `standards/platform/AUTO_MERGE.md` | `NOTES.md`; `platform-team/engineering-policy.md` §8 |
| `standards/platform/AWS_NAMING.md` | `platform-team/developer-guidelines.md` §1 (Master naming schema), §2 (AWS resource naming & limits), §3 (Required tags) |

### Documentation

| Standard | Source |
|---|---|
| `standards/docs/ADR.md` | Nygard "Documenting Architecture Decisions" (2011); `platform-team/engineering-policy.md` §12 (Deviations — ADR policy); `platform-team/developer-guidelines.md` §14 (Deprecation policy); `research/03-design/adrs.md` |
| `standards/docs/DIATAXIS.md` | Procida *Diátaxis* (diataxis.fr); `handbook/04-build.md`, `handbook/07-run.md` |

### Process

| Standard | Source |
|---|---|
| `standards/process/TEAM_SCALING.md` | `handbook/00-team-lean.md`; `handbook/00-team-full.md` |
| `standards/process/TECHNICAL_DEBT.md` | `platform-team/engineering-policy.md` §10 (Refactoring); `handbook/08-evolve.md`; `research/08-maintenance/technical-debt.md`; Cunningham OOPSLA '92; Fowler "TechnicalDebt" + "TechnicalDebtQuadrant"; Tornhill *Your Code as a Crime Scene* (2nd ed., 2024) |
| `standards/process/CUSTOMER_FEEDBACK.md` | `handbook/01-discover.md`; `handbook/08-evolve.md`; `research/01-ideation/discovery.md`; `research/01-ideation/user-research.md`; `research/08-maintenance/feedback-loops.md`; Reichheld HBR 2003 (NPS); Dixon et al. HBR 2010 (CES) |
| `standards/process/TASK_SIZING.md` | `handbook/02-plan.md` §"Step 6 — Size items" + §"Step 8 — Establish backlog refinement"; `research/02-planning/estimation.md` §§1–2; Cohn *Agile Estimating and Planning* (2005). The 1–2 hour leaf-task band and the mandatory verification pass are codifications adopted by this system, flagged `[UNVERIFIED]` against any single named source. |
| `standards/process/LEARNING.md` | `handbook/08-evolve.md`; `research/08-maintenance/feedback-loops.md` §§6–9 (Kerth Prime Directive; PDCA Shewhart/Deming; Rother Toyota Kata 2009); `research/07-operations/incident-response.md` (Allspaw blameless postmortems). The automatic candidate-stub capture, keyword-matching loader, and 1-year-plus-structural-change retirement rule are codifications adopted by this system, flagged `[UNVERIFIED]` against any single named source. |
| `standards/process/CALIBRATION.md` | Per-prefix historical-accuracy calibration; consumed by pass-runner scoring. Ported from `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4b–4d and `~/.claude.old/commands/amrr.md` §"Step 4c. Feedback Capture". Cross-references: `agents/pass-runner.md`, `standards/QUALITY.md`. |

### Frameworks (conditional escalation)

These specs are loaded by `pass-runner` only when a brief contains the activation keywords. They escalate `max_passes` from 3 to 5 and add framework-specific blocker rules. See [`standards/frameworks/OPTIONAL_FRAMEWORKS.md`](standards/frameworks/OPTIONAL_FRAMEWORKS.md) for the index and machine-readable trigger registry at [`standards/frameworks/trigger-index.json`](standards/frameworks/trigger-index.json).

| Framework | Trigger keywords | Source |
|---|---|---|
| `standards/frameworks/OPTIONAL_FRAMEWORKS.md` | (index — always loaded) | This system; pattern from `~/.claude.old/OPTIONAL_FRAMEWORKS.md` |
| `standards/frameworks/trigger-index.json` | (machine-readable trigger registry) | This system |
| `standards/frameworks/STRIDE_THREAT_MODELING.md` | `auth`, `PII`, `payment`, `internet-facing`, `STRIDE` | `research/03-design/security-design.md`; Shostack STRIDE-per-element; OWASP Threat Modeling |
| `standards/frameworks/CHARACTERIZATION_TESTING.md` | `legacy-code`, `no-tests`, `refactor`, `behavior-preservation` | Feathers *Working Effectively with Legacy Code* (seam model, dependency-breaking); `research/08-maintenance/README.md` |
| `standards/frameworks/CONTRACT_REGRESSION.md` | `public-API`, `shared-library`, `cross-team`, `consumer`, `provider`, `Pact` | `research/05-testing/test-levels.md` (Pact docs verified) |
| `standards/frameworks/FEATURE_FLAGS.md` | `behavior-change`, `phased-rollout`, `canary`, `percentage`, `flag`, `toggle` | `research/06-release/feature-flags.md`; Hodgson "Feature Toggles" (martinfowler.com, 2017) |
| `standards/frameworks/PERFORMANCE_BUDGET.md` | `latency`, `p99`, `p95`, `hot-path`, `bundle-size`, `database-query`, `load-test` | `research/05-testing/non-functional-testing.md`; Grafana k6 docs (verified) |
| `standards/frameworks/FAILURE_INJECTION.md` | `external-service`, `retry`, `circuit-breaker`, `availability`, `chaos`, `fault-injection` | `research/05-testing/chaos-and-production-testing.md`; Principles of Chaos (verified) |
| `standards/frameworks/COMPOSITION_VERIFICATION.md` | `wire`, `entry-point`, `daemon`, `lifecycle`, `register`, `multi-component`, `main()` | This system; pattern from `~/.claude.old/commands/build.md` Composition Verification |
| `standards/frameworks/EXPERIMENTATION.md` | `A/B-test`, `experiment`, `hypothesis`, `primary-metric`, `hypothesis-ledger`, `holdout` | `handbook/06-ship.md`; `handbook/08-evolve.md`; `handbook/08-evolve-processes.md` §4; `research/06-release/deployment-strategies.md` (Fowler "CanaryRelease"); `research/05-testing/chaos-and-production-testing.md` (A/B definition); Hodgson "Feature Toggles" 2017 (cross-ref `FEATURE_FLAGS.md`) |

## Foundation files

| File | Purpose | Source |
|---|---|---|
| `README.md` | Architecture overview, install, layout | This system; `SYSTEM.md` analysis |
| `CLAUDE.md` | Global rules (truthfulness, verification, scope, etc.) | This system; `CLAUDE.md` (root) research-rules; `platform-team/engineering-policy.md` |
| `MEMORY.md` | Index of memory pointers | This system pattern |
| `MAPPING.md` | This file | This system |
| `standards/AGENT_PREAMBLE.md` | Non-negotiables every agent loads | This system |
| `standards/ANTI_HALLUCINATION.md` | Unified six-layer anti-hallucination protocol; defines the pre-output gate (layer 6), hallucination KPIs, and escalation thresholds | This system; CLAUDE.md (root) §§1–4; CLAUDE.md (system) §§1–2; cross-verifier; EVIDENCE.md; QUALITY.md |
| `standards/process/CALIBRATION.md` | Per-prefix historical-accuracy calibration applied during scoring; complementary to ANTI_HALLUCINATION.md (catches systematic agent drift across passes) | This system; ported from `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4 and `~/.claude.old/commands/amrr.md` §"Step 4c. Feedback Capture" |
| `standards/EVIDENCE.md` | The three claim schemas | This system; CLAUDE.md research-rules grounding |
| `standards/QUALITY.md` | Scoring formula | This system; from `SYSTEM.md` analysis of `.claude.old` |
| `lessons/INDEX.md` | Durable lesson storage; loader input for the pass-runner before pass 1 | This system, defined by `standards/process/LEARNING.md` |

## Agents

| Agent | Phase span | Source |
|---|---|---|
| `agents/pass-runner.md` | All phases (orchestrator) | This system |
| `agents/cross-verifier.md` | All phases (verification) | This system; CLAUDE.md anti-hallucination rules |
| `agents/systems-architect.md` | 03 Design (primary); review of all phases | `handbook/03-design.md`; `standards/development/CLEAN_ARCHITECTURE.md` |
| `agents/security-reviewer.md` | 03 Design; 04 Build; 06 Ship | `standards/security/OWASP.md`; `standards/security/AUTH.md` |
| `agents/qa-engineer.md` | 04 Build; 05 Test | `standards/testing/TEST_STRATEGY.md`; `standards/development/TDD.md` |
| `agents/platform-engineer.md` | 06 Ship; 07 Run; cross-cutting infra | All `standards/platform/*` and `standards/release/*`; `NOTES.md` |
| `agents/code-reviewer.md` | 04 Build (per-PR review) | `standards/development/CODE_REVIEW.md`; `platform-team/engineering-policy.md` §8 |

## Scripts

| Script | Purpose | Wiring |
|---|---|---|
| `scripts/context-monitor.sh` | Warn on `.pipeline.json` size | `SessionStart`, `UserPromptSubmit` hooks in `settings.example.json` |
| `scripts/audit-log.sh` | Append per-tool-call audit record | `PostToolUse` hook in `settings.example.json` |
| `scripts/verify-artifact.sh` | Pre-output gate (layer 6) — checks relative-link resolution, lists external URLs, tallies uncertainty tags on authored Markdown artifacts | Invoked by `pass-runner` per artifact before final summary; defined by `standards/ANTI_HALLUCINATION.md` |

## How to extend the mapping

1. Adding a new standard → add a row in the appropriate Domain Standards table; cite the `handbook/` chapter (if any) and the `research/` or `platform-team/` source.
2. Adding a new command → add a row in the Phase Commands or Cross-Cutting Commands table.
3. Adding a new agent → add a row in the Agents table; specify which phases the agent operates in and which standards it loads.
4. If a new standard has no upstream source in `handbook/` / `research/` / `platform-team/` → that standard is **not** allowed in this system. Add the source first.

## Sources

- This system was bootstrapped from analysis of `~/.claude.old/` recorded in `/Users/nile/Projects/pdlc/SYSTEM.md`.
- Authoritative policy documents that ground most standards:
  - [`../platform-team/engineering-policy.md`](../platform-team/engineering-policy.md)
  - [`../platform-team/developer-guidelines.md`](../platform-team/developer-guidelines.md)
  - [`../NOTES.md`](../NOTES.md)
- Methodology + verifiable-claims discipline:
  - [`../CLAUDE.md`](../CLAUDE.md) (research rules)
- Phase prescriptions:
  - [`../handbook/`](../handbook/)
- Citations:
  - [`../research/`](../research/)
