# VERSIONING.md — Conventional Commits + SemVer (libraries) / CalVer (services)

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §9.

## Commit message format

**Conventional Commits v1.0.0.** Format:

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

Allowed `<type>` values:

- `feat:` — new user-visible feature → MINOR bump
- `fix:` — bug fix → PATCH bump
- `docs:` — documentation only
- `chore:` — tooling, deps, build infra
- `refactor:` — internal restructure, no behavior change
- `test:` — adding or modifying tests
- `perf:` — performance change with no behavior change
- `style:` — formatting only (rare; should be auto-applied)
- `ci:` — pipeline / CI config changes
- `build:` — build-system changes
- `revert:` — reverts a prior commit (cite the SHA)

A breaking change is signaled by `!` after the type or a `BREAKING CHANGE:` footer → MAJOR bump.

## Hard rules

1. **Conventional Commits format on every commit to main.** Enforced via commit-msg hook + CI check.
2. **One logical change per commit.** No "fix bug + refactor + add feature" in one commit.
3. **Subject ≤ 72 chars, imperative mood.** "add user search" not "added user search" or "adds user search".
4. **Body explains *why*, not *what*.** The diff shows what; the commit message captures the reasoning.
5. **Reference issue / ADR / ticket in footer where relevant.** `Refs: ADR-014`, `Fixes: #1234`.

## SemVer (libraries, public APIs)

`MAJOR.MINOR.PATCH`:

- MAJOR — incompatible API changes
- MINOR — backwards-compatible feature additions
- PATCH — backwards-compatible bug fixes

Breaking changes require: deprecation notice → one minor release with the new path available alongside the old → MAJOR removing the old path. Per [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §14 (Deprecation policy).

## CalVer (services, internal artifacts)

For services where "version" is not a public API contract, calendar versioning is acceptable: `YYYY.MM.PATCH` or `YYYY.0M.0D`. Tie the version to the deploy, not to a release-engineering ceremony.

## Auto-changelog

Generated from commits. No hand-edited `CHANGELOG.md` for libraries — if you need to edit it, the commit message was wrong.

## Auto-rejection (used by code-reviewer)

| Trigger | Severity |
|---|---|
| Commit not in Conventional Commits format on main | Minor |
| Breaking change merged without `!` or `BREAKING CHANGE:` footer | Major |
| Subject > 72 chars | Nit |
| Subject not imperative mood | Nit |
| `chore:` covering a behavior change | Major (mislabel hides the change) |
| Multiple unrelated changes in one commit | Major (CR-SHAPE; see [`../development/CODE_REVIEW.md`](../development/CODE_REVIEW.md)) |

## Banned phrases in commit messages

- "various fixes" / "misc changes" / "stuff"
- "WIP" merged to main (WIP belongs on a feature branch, squashed before merge)
- "fix tests" without saying *what* the test was wrong about
- AI-attribution boilerplate (e.g., "Generated with Claude Code") unless the user explicitly requested it

## Anti-patterns to flag

- `git commit -m "fix"` — not Conventional Commits, no information.
- Squash-merge that flattens a 12-commit branch into one untyped commit. Either preserve the well-formed commits or compose a Conventional Commit subject.
- Type label drift: using `feat:` for refactors to inflate MINOR bumps. The audit catches this.

## Sources

- Conventional Commits v1.0.0 spec.
- SemVer 2.0.0 spec.
- CalVer (calver.org) for service-versioning rationale.
- [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §9 for full URL list.
