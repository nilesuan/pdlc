# CODE_REVIEW.md — Code review standards

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §8.

## What review is for

The reviewer's job is to approve a CL once it **improves the overall health of the codebase, even if not perfect** (Google).

The eight dimensions a review covers (Google Engineering Practices):

1. Design
2. Functionality
3. Complexity
4. Testing
5. Naming
6. Comments
7. Style
8. Documentation

## Hard rules

1. **Automated checks pass before human review.** Lint, format, static analysis, security scans, full CI. Human time is not for what a machine can do.
2. **One CL = one self-contained thing.** No bundled refactor + feature.
3. **Target ≈ 100 LoC per CL.** ≈ 1000+ LoC is oversized; reviewers may reject on size alone.
4. **Reviewer responds within 1 business day.** "Respond" = review or hand off with a clear ETA. Silence is not acceptable.
5. **Comment severity labelled.** `Nit:` (non-blocking polish), `Optional:` / `FYI:`, otherwise blocking. `Nit:` does not block approval.
6. **Multiple valid approaches → reviewer defers to author** when the author has justified.
7. **Review the code, not the author.** Explain reasoning.

## Auto-rejection (used by code-reviewer agent)

| Trigger | Severity |
|---|---|
| PR > 1000 LoC mixing concerns | Major (recommend split) |
| PR > 600 LoC mixing concerns | Major |
| Lint / format failing on PR | Major (machine should have caught — fix before re-requesting review) |
| Commit message not Conventional Commits format | Minor |
| Reviewer comment thread > 1 business day with no response | Process finding (no severity, surface to user) |
| Approval given without a single specific comment in the entire PR | Minor (review-as-theatre signal) |

## Comment style

- Lead with what's wrong (or right) and why.
- Cite the standard or pattern, not opinion: "Per CLEAN_ARCHITECTURE.md, domain shouldn't import infra" beats "I prefer not to do this".
- Distinguish blocking from non-blocking with the `Nit:` / `Optional:` prefix.
- "Could we…" + reason beats "we should…" — invites collaboration.

## Anti-patterns to flag

- Stamp-of-approval reviews ("LGTM" with no comment trail). The qa-engineer + code-reviewer + cross-verifier triple removes this dynamic by always producing a finding trail.
- Bikeshedding on style when a formatter exists. If `ruff format` / `prettier` / `gofmt` is running in CI, style is not a review topic.
- "Address all comments before merge" without distinguishing blocker from nit.
- Days-long review queues. The 1-business-day rule is the contract.

## Severity calibration

| Severity | Example |
|---|---|
| blocker | Lying comment, broken Clean Architecture boundary, secret in diff, public API changed without deprecation |
| major | PR > 600 LoC mixing concerns, missing test for new public function, dead code, SOLID violation in hot path |
| minor | Long function (50+ lines), magic number, suboptimal idiom |
| nit | Naming preference, redundant docstring, whitespace |

## Sources

- Google Engineering Practices on Code Review — see [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §8 for full URL list.
- Bacchelli & Bird, "Expectations, Outcomes, and Challenges of Modern Code Review", ICSE 2013 — modern code review delivers more value as knowledge-transfer than defect-finding.
- Research: [`../../../research/04-development/code-review.md`](../../../research/04-development/code-review.md).
- Handbook: [`../../../handbook/04-build.md`](../../../handbook/04-build.md).
