---
name: build
description: Phase 04 — implement a feature with TBD discipline, TDD, small PRs, peer review, and refactor-with-passing-tests. Produces a feature branch with reviewed commits and a green CI run.
argument-hint: [issue-id-or-feature-name]
---

# /build

## Goal

Implement a single feature on a short-lived feature branch using TDD where possible, with each commit reviewable on its own and a green CI run before PR.

## Done when

- Feature branch created from main, named per [`../standards/development/TRUNK_BASED.md`](../standards/development/TRUNK_BASED.md).
- Tests written first (Red); implementation makes them pass (Green); refactor with tests still passing.
- Each commit is logical and reviewable on its own; commit messages follow Conventional Commits.
- Branch is rebased on main (not merge-committed); history is linear.
- CI is green: build, lint, type, unit, integration, security scans (SAST + dependency + secret scan).
- Coverage meets [`../standards/QUALITY.md`](../standards/QUALITY.md) gates: 80% line / 70% branch project-wide; 95% on `**/auth/**`, `**/crypto/**`, `**/billing/**`.
- PR opened with description: what, why, screenshots / curl examples for behavior changes.
- Sub-agents executing build tasks ran in isolated git worktrees (per [`../agents/pass-runner.md`](../agents/pass-runner.md) §"Briefing sub-agents").
- MR opened with auto-merge enabled AND source-branch deletion enabled on merge (per [`../standards/platform/AUTO_MERGE.md`](../standards/platform/AUTO_MERGE.md) §"Worktree-based task execution").
- No new top-level dependencies without justification block in PR description.
- No commits directly to main. No `--no-verify`. No `--auto-approve`.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

04 — Build

## Pre-flight

- Issue exists in tracker (Linear / Jira / GitHub Issues) with acceptance criteria.
- A design exists or this is small enough to not warrant one (handbook: "non-trivial" threshold).
- Working tree clean. On a feature branch (or about to create one).

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Issue with acceptance criteria | tracker (URL recorded in PR description) | Pass 1 |
| Design ADR (when non-trivial) | `docs/adr/NNNN-*.md` | Pass 1 |
| Threat model entry (when touching auth/PII/payments) | `docs/threat-models/<feature>.md` | Pass 1 (escalates STRIDE framework) |
| Feature branch off main | `git symbolic-ref HEAD` ≠ `refs/heads/main` | Pass 1 |
| Working tree clean | `git status --porcelain` empty (or only the in-flight commit) | Pass 1 |
| Test file alongside implementation | `tests/<…>` or `<src>__tests__/` | Pass 2 (TDD-strict in `**/auth/**`, `**/crypto/**`, `**/billing/**`) |

If the diff touches a hot-path endpoint, a `perf/<surface>/budget.md` must exist or be created in this build (PERFORMANCE_BUDGET framework activates).

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "feature_flags": {
    "tdd_strict": "auto",
    "tdd_strict_paths": ["**/auth/**", "**/crypto/**", "**/billing/**"]
  },
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
      "auto_add_when": "diff_touches:**/auth/**,**/crypto/**,**/billing/**,**/input/**",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md",
        "standards/security/AUTH.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Does the change implement the acceptance criteria, with a test that fails before and passes after, and does it respect the design ADR + Clean Architecture + SOLID? |
| 2 | Proof & Safety | Are coverage gates met (80/70 project; 95 sensitive paths), is TDD discipline preserved (test predates implementation in TDD-strict paths), and does OWASP / static analysis come back clean on changed lines? |
| 3 | Ship Readiness | Is CI green end-to-end, are commits Conventional and reviewable on their own, is the PR description complete (what / why / curl-or-screenshot), and does the diff stay under 600 LoC of mixed concerns? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/development/TRUNK_BASED.md
  - standards/development/TDD.md
  - standards/development/SOLID.md
  - standards/development/CLEAN_ARCHITECTURE.md
  - standards/development/CODE_REVIEW.md
  - standards/security/OWASP.md
  - standards/security/AUTH.md         # if touching auth
  # Conditional language standards (loaded by file extension in the diff)
  - standards/development/PYTHON.md     # if diff includes *.py / pyproject.toml
  - standards/development/TYPESCRIPT.md # if diff includes *.ts / *.tsx / tsconfig.json / package.json
```

## Sub-agents

```yaml
sub_agents:
  - code-reviewer        # readability, conventions, SOLID, Clean Architecture (sonnet)
  - qa-engineer          # TDD compliance, coverage, level fit, mock vs fake (sonnet)
  - security-reviewer    # OWASP scan on changed files (opus when touching auth/crypto/billing/input boundary)
```

The pass-runner adds `security-reviewer` automatically when the diff touches paths matching `**/auth/**`, `**/crypto/**`, `**/billing/**`, or any path that takes user input. Otherwise it's optional.

## Pass-loop dispatch

The build loop is the most-iterated. Pass-runner sets `max_passes: 3` (or 5 if security-reviewer escalates).

Per pass:

1. Sub-agents review the working tree's diff against main.
2. Cross-verifier confirms each finding's evidence (file/line/excerpt).
3. Score per QUALITY.md.
4. If score < 85 or any blocker: feedback loop. The user (or you) fixes, commits, re-runs.

### Banned phrases in commit messages

The pass-runner refuses commits whose message matches:

- "WIP" (use `fixup!` or amend instead)
- "fix stuff", "various fixes", "updates"
- "address comments" (describe the change, not the social motion)
- "as discussed" (the diff and PR description carry the context)

### Hard rules (blockers)

- Direct commit to main: blocker.
- `--no-verify` to bypass hooks: blocker.
- Test added that doesn't actually test the behavior (e.g., tests the mock): blocker.
- New dependency without justification: blocker.
- Secret committed: blocker (even in test fixtures — use a clearly-fake placeholder pattern).
- Coverage drop > 2% with no offsetting gain: major.
- PR > 600 LoC mixed concerns: major (recommend split).

## TDD strict mode

If `feature_flags.tdd_strict: true` is set, the qa-engineer additionally enforces:

- The test file's first commit predates (or is in the same atomic commit as) the implementation file.
- The first run of the test must fail for the right reason (the assertion, not a missing import).
- The third TDD step (refactor) doesn't change test behavior.

TDD-strict is on by default for paths matching `**/billing/**`, `**/auth/**`, `**/crypto/**`. Off by default for UI-only changes.

## Output

- Feature branch with reviewable commits and a clean CI run.
- PR opened (or PR description draft saved at `cdocs/pr-<issue>.md`) with the standard structure; auto-merge enabled and source-branch deletion enabled on merge (per [`../standards/platform/AUTO_MERGE.md`](../standards/platform/AUTO_MERGE.md) §"Worktree-based task execution").
- Score history surfaced; open findings (if any) listed for the user.

## Sources

- Handbook: [`../../handbook/04-build.md`](../../handbook/04-build.md) (read in full for command construction)
- Research:
  - [`../../research/04-development/version-control.md`](../../research/04-development/version-control.md) — TBD vs GitFlow; DORA evidence
  - [`../../research/04-development/code-review.md`](../../research/04-development/code-review.md) — Bacchelli & Bird; Google small-PR data
  - [`../../research/04-development/coding-practices.md`](../../research/04-development/coding-practices.md) §1 (TDD — Beck Canon, Fowler), §3 (Refactoring — Fowler), §4 (Clean Code — Martin, with Abramov critique), §5 (Static analysis — eslint, ruff, golangci-lint), §6 (Style guides)
  - [`../../research/04-development/documentation.md`](../../research/04-development/documentation.md) §5 (Developer experience — dev containers)
- Predecessor command shape (banned phrases, hard rules): `~/.claude.old/commands/build.md`.
