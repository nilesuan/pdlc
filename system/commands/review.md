---
name: review
description: Cross-cutting code/PR review. Spawns code-reviewer, qa-engineer, security-reviewer, and (when IaC is touched) platform-engineer. Cross-verified findings returned with severity and recommendations. Use BEFORE pushing or as part of PR review.
argument-hint: [target — "uncommitted" | "branch" | "PR <id>"]
---

# /review

## Goal

Comprehensive review of a code change set against the system's standards, with cross-verified findings prioritized by severity.

This command is the everyday review tool. It complements `/build` (which runs reviewers as part of an active build cycle) by being a stand-alone review that can target any state: uncommitted changes, a feature branch, or an existing PR.

## Done when

- Findings produced with severity, evidence, and recommendation.
- Cross-verifier has confirmed each finding's evidence and emitted `adjusted_confidence` (0-100) and `adjusted_severity` per finding.
- Each surviving finding has a `confidence: 0-100`, has been calibrated against `cdocs/review-calibration/calibration.json`, and meets the severity-gated minimum (blocker ≥80, major ≥70, minor ≥60, nit ≥50, info ≥30). Findings below threshold were auto-rejected.
- Score returned per [`../standards/QUALITY.md`](../standards/QUALITY.md). Critical override (blocker AND calibrated_confidence ≥ 80 → score = 0) was checked.
- Open blockers and majors surfaced; nits collapsed if many.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

Cross-cutting (most relevant in 04 Build, 06 Ship, but useful any time).

## Pre-flight

Resolve the target:

- `uncommitted` (default): `git diff` against HEAD.
- `branch`: `git diff main...HEAD` on current branch.
- `PR <id>`: fetch the PR diff (GitHub: `gh pr diff <id>`; GitLab: `glab mr diff <id>`).

If the diff is > 2000 LoC, ask the user to scope tighter or accept that review will be coarser.

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Resolvable diff target | `git diff` / `gh pr diff` succeeds | Pass 1 |
| Diff size ≤ 2000 LoC | `git diff --shortstat` | Pass 1 (else: ask user to narrow scope) |
| Repo is a git working tree | `.git/` present | Pass 1 |
| (If PR target) PR exists and is fetchable | `gh pr view <id>` / `glab mr show <id>` returns 0 | Pass 1 |
| (If IaC in diff) Terraform / Helm / k8s tooling | `terraform`/`helm`/`kubectl` in PATH | Pass 1 |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 1,
  "max_passes_when_iterating": 3,
  "escalated_max_passes": 5,
  "agents": {
    "code-reviewer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/development/CODE_REVIEW.md",
        "standards/development/SOLID.md",
        "standards/development/CLEAN_ARCHITECTURE.md",
        "standards/development/TRUNK_BASED.md"
      ]
    },
    "qa-engineer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/testing/TEST_STRATEGY.md",
        "standards/development/TDD.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md",
        "standards/security/AUTH.md"
      ]
    },
    "platform-engineer": {
      "model": "opus",
      "auto_add_when": "diff_touches:**/*.tf,**/.gitlab-ci.yml,**/.github/workflows/**",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/platform/AWS_ECS_TERRAFORM.md",
        "standards/platform/TERRAFORM_DISCIPLINE.md",
        "standards/platform/GITLAB_SECURITY.md",
        "standards/release/CONTAINER_TAGGING.md"
      ]
    }
  }
}
```

`max_passes` defaults to **1** for `/review` (snapshot review). Pass `--passes 3` to iterate when issues are partially fixed between passes.

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Do the findings cite real file:line evidence, do severities match the standards, are all relevant standards loaded for the diff content (auth → AUTH.md, IaC → platform standards, tests → TEST_STRATEGY.md), and does every finding's `confidence` (0-100) support its severity (≥80 for blocker, ≥70 major, ≥60 minor, ≥50 nit, ≥30 info)? |
| 2 | Proof & Safety | (When iterating) Does the cross-verifier confirm every surviving finding's evidence still exists, and are its `adjusted_confidence` / `adjusted_severity` outputs reflected in the score? Are coverage / OWASP / perf / contract / threat-model checks complete for the changed surfaces? |
| 3 | Ship Readiness | (When iterating) Are findings actionable with clear recommendations, is severity-grouping correct (blockers → majors → minors → nits), and are nits collapsed into a per-file roll-up rather than spammed inline? |

### Calibration

Every `/review` invocation appends one row per surviving finding to `cdocs/review-calibration/history.jsonl` with `outcome: pending`, and recomputes `cdocs/review-calibration/calibration.json` whenever the count of resolved-outcome rows hits a multiple of 5. Per [`../standards/process/CALIBRATION.md`](../standards/process/CALIBRATION.md). The user marks each finding accepted or rejected after the pass; outcomes that stay `pending` for >30 days are excluded from the next recomputation. The `--no-calibration` flag bypasses the per-prefix multiplier (uses 1.0) and notes this in the score_breakdown.

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/development/CODE_REVIEW.md
  - standards/development/TRUNK_BASED.md
  - standards/development/SOLID.md
  - standards/development/CLEAN_ARCHITECTURE.md
  - standards/security/OWASP.md
  - standards/security/AUTH.md
```

If diff touches `**/test/**` or `**/spec/**`: also load `standards/testing/TEST_STRATEGY.md`.

If diff touches `**/*.tf`, `**/.gitlab-ci.yml`, `**/.github/workflows/**`: also load `standards/platform/AWS_ECS_TERRAFORM.md`, `standards/platform/TERRAFORM_DISCIPLINE.md`, `standards/platform/GITLAB_SECURITY.md`, `standards/release/CONTAINER_TAGGING.md`.

If diff touches `**/*.py`, `pyproject.toml`, `requirements*.txt`: also load `standards/development/PYTHON.md`.

If diff touches `**/*.ts`, `**/*.tsx`, `tsconfig.json`, `package.json`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`: also load `standards/development/TYPESCRIPT.md`.

## Sub-agents

```yaml
sub_agents:
  - code-reviewer        # always (sonnet)
  - qa-engineer          # always; primary if test/spec files in diff (sonnet)
  - security-reviewer    # always (opus); pass-runner upgrades to "primary" if auth/crypto/billing/input touched
  - platform-engineer    # if IaC, pipeline, or AWS resource files in diff (opus for design; sonnet for review)
```

All reviewer agents emit `confidence: 0-100` numeric (not `high`/`medium`/`low`). The cross-verifier emits `adjusted_confidence: 0-100` and `adjusted_severity: blocker|major|minor|nit|info|n/a` per finding. The pass-runner replaces the original `confidence`/`severity` with the cross-verifier's adjusted values and then applies per-prefix calibration before scoring. See [`../standards/EVIDENCE.md`](../standards/EVIDENCE.md) §"Confidence calibration" and [`../agents/cross-verifier.md`](../agents/cross-verifier.md) §"Output".

## Pass-loop dispatch

Per pass:

1. Sub-agents review the diff. Each emits findings with their finding-ID prefix.
2. Cross-verifier runs every finding's evidence against the source.
3. Score per QUALITY.md.
4. Group findings by severity.

The pass-runner runs **1 pass by default** for `/review` (this is a snapshot review, not an iterative build). The user can request `--passes 3` to iterate when issues are found and partially fixed.

## Output

Returned in the conversation, no artifact file unless the diff is large. Format:

```
SCORE: 78/100  (1 blocker, 2 major, 5 minor, 4 nit)

BLOCKERS
  SEC-AUTH-01  src/api/auth.py:89  ...
  
MAJORS
  CR-SHAPE-02  PR is 612 LoC and bundles refactor with feature
  QA-COV-03    auth/* coverage dropped from 96% to 89%
  
MINORS / NITS
  (collapsed; see cdocs/review-<timestamp>.md for full list)
```

For PR reviews specifically, the user can ask the command to post findings as PR review comments. That requires explicit user approval each time (per the global "shared-state action" rule in `CLAUDE.md`).

## Sources

- Code review goals: Bacchelli & Bird, "Expectations, Outcomes, and Challenges of Modern Code Review" (ICSE 2013) — see [`../../research/04-development/code-review.md`](../../research/04-development/code-review.md).
- Small-PR data: Google's PR-size distribution (50% < 24 LoC); referenced in [`../../handbook/04-build.md`](../../handbook/04-build.md).
- Predecessor `/amrr` and `/codereview` patterns from `~/.claude.old/` informed the multi-agent fan-out shape; see [`../../SYSTEM.md`](../../SYSTEM.md).
