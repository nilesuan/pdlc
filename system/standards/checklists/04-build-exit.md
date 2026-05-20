# 04-build-exit.md — Phase 04 (Build) exit checklist

**Authoritative source:** [`../../../handbook/04-build.md`](../../../handbook/04-build.md); [`../development/TRUNK_BASED.md`](../development/TRUNK_BASED.md), [`../development/TDD.md`](../development/TDD.md), [`../development/CODE_REVIEW.md`](../development/CODE_REVIEW.md).

This checklist is run at the end of `/build` (per work item / per merge).

## Done-when

- [ ] **Branch lifetime ≤ 2 days.** Older branches are forced to ship-or-discard.
- [ ] **Tests written test-first** for new behavior (TDD: Red → Green → Refactor). Tdd_strict mode enforced for `**/auth/**`, `**/crypto/**`, `**/billing/**`.
- [ ] **Refactor step taken** (or explicitly skipped with rationale). The Two-Hats rule respected: no "refactor + feature" commits.
- [ ] **Code review completed** with ≥ 1 approver per CODEOWNERS. Reviewer responded within 1 business day. Comments labelled (Nit / Optional / blocker).
- [ ] **CI green:** lint, format, tests, security scan, container scan.
- [ ] **Conventional Commit format** on every commit on main. See [`../release/VERSIONING.md`](../release/VERSIONING.md).
- [ ] **CL size:** target ≈ 100 LoC; ≥ 600 LoC mixing concerns triggers reviewer-rejection on size alone.
- [ ] **Clean Architecture boundaries respected** — domain/use-case/adapter/infra layering preserved. See [`../development/CLEAN_ARCHITECTURE.md`](../development/CLEAN_ARCHITECTURE.md).
- [ ] **SOLID applied to new code** (legacy untouched unless explicitly in scope). See [`../development/SOLID.md`](../development/SOLID.md).
- [ ] **No secrets in commits.** Pre-commit + CI scans clean.
- [ ] **Feature flag default off** for new user-visible behavior; documented enable/disable path.
- [ ] **Logs / metrics / traces wired** before merge, not after. See [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).
- [ ] **Migrations are expand/contract** if schema changes. See [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md).

## Auto-rejection

| Trigger | Severity |
|---|---|
| Direct push / commit to `main` | Blocker |
| `--no-verify` used to bypass hooks on a commit reaching `main` | Blocker |
| Secret in diff | Blocker |
| Test passing on first run before any implementation (tdd_strict) | Major |
| Refactor + feature in same commit | Major (Two Hats) |
| CL > 1000 LoC mixing concerns | Major (CR rejection on size) |
| Lint / format failing on PR | Major (CR rejection — machine should have caught) |
| New public function without test | Major |
| Approval given without a single specific comment | Minor (review-as-theatre signal) |
| Migration + code change shipped together (no expand/contract) | Major |

## What good looks like

- Each commit on the branch is a Conventional-Commits-typed, self-contained change that could be reviewed in isolation.
- Tests clearly drive the design — small, behavior-focused, no mocking of internal seams.
- The branch was born this morning and merges this afternoon.
- The PR description explains the *why*; the diff explains the *what*.

## Sources

- Paul Hammant, *Trunk-Based Development* (trunkbaseddevelopment.com).
- Kent Beck, *Test-Driven Development: By Example* (2002); Beck "Canon TDD" (2023).
- Robert C. Martin, *Clean Architecture* (2017); Martin "Solid Relevance" (2020).
- Google, *Engineering Practices: Code Review* (google.github.io/eng-practices/review/).
- Conventional Commits 1.0.0 (conventionalcommits.org).
- Handbook: [`../../../handbook/04-build.md`](../../../handbook/04-build.md).
