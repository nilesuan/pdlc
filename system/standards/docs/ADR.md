# ADR.md — Architecture Decision Records

**Authoritative source:** Michael Nygard, "Documenting Architecture Decisions" (2011); [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §12 (Deviations — ADR policy); [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §14 (Deprecation policy); [`../../../research/03-design/adrs.md`](../../../research/03-design/adrs.md).

## What an ADR is

A short, dated, immutable record of an architecturally-significant decision: the context, the choice, and the consequences. ADRs accumulate to form a project's institutional memory.

> "Architecturally significant" = a choice that's expensive to reverse, that other parts of the system will depend on, or that constrains future options. (Examples: chosen database, chosen auth provider, microservices vs. monolith, sync-vs-async messaging.)

## When to write one

- Adopting a new service / library / framework with system-wide impact.
- Picking between options where reasonable engineers would disagree.
- Deviating from a stated standard (e.g., this system's Clean Architecture rule).
- Deprecating a component or contract.
- Choosing a data format / API style that downstream code will depend on.

When in doubt, write one. ADRs are cheap; "why did we do this?" investigations months later are not.

## When NOT to write one

- Routine implementation choices ("which test framework"). Capture in code, README, or CONTRIBUTING.
- Reversible choices ("which logging library inside this service"). Refactor when needed.
- Style preferences. Use a formatter and `style/` doc.

## Format (Nygard, lightly modernized)

```markdown
# ADR-NNNN: <Decision title>

- **Status:** Proposed | Accepted | Superseded by ADR-XXXX | Deprecated
- **Date:** YYYY-MM-DD
- **Authors:** <names>
- **Deciders:** <names / roles who agreed>
- **Tags:** <area>, <env>, <component>

## Context

<What forces are at play? Technical, business, organizational. State the problem before the solution.>

## Decision

<We will <do this thing>.>

## Consequences

<What becomes easier? What becomes harder? What new constraints does this introduce? Be honest about the negatives.>

## Alternatives considered

- **Option A:** <description>. Rejected because <reason>.
- **Option B:** <description>. Rejected because <reason>.

## Links

<Related ADRs, RFCs, design docs, tickets, source data.>
```

## Hard rules

1. **Numbered, never renumbered.** Once `ADR-0014` exists, that number is permanent. Even if superseded.
2. **Immutable once Accepted.** Don't edit the body. Write a new ADR that supersedes it; update the old ADR's status to "Superseded by ADR-XXXX".
3. **Stored in the repo.** `docs/adr/0001-record-decisions.md`, `0002-...`, etc. Reviewed via PR like code.
4. **One decision per ADR.** Don't bundle.
5. **Status moves forward only.** Proposed → Accepted; Accepted → Superseded or Deprecated. Never back to Proposed.
6. **Deciders explicitly listed.** "We" without names is unaccountable.
7. **Alternatives section non-empty.** If the decision has no alternatives, it's not a decision.

## Auto-rejection (used by systems-architect / code-reviewer)

| Trigger | Severity |
|---|---|
| Architecturally-significant change merged without ADR | Major |
| ADR missing Alternatives section | Major |
| ADR missing Consequences section | Major |
| ADR with status "Accepted" being edited (vs. superseded) | Major |
| Deviation from Clean Architecture / SOLID / standards in this system without an ADR | Major |
| ADR number reused after a deletion | Major (numbers are permanent) |

## How to file an ADR in this system

1. Find the next number: `ls docs/adr/ | tail`.
2. Create `docs/adr/NNNN-short-slug.md` with status `Proposed`.
3. Open a PR. Reviewers (CODEOWNERS for architecture) discuss in PR comments.
4. On merge, status flips to `Accepted` (in the same PR or a follow-up).
5. If later superseded: write the new ADR; update the old one's status line only.

## Anti-patterns to flag

- ADRs that read like marketing copy ("we boldly chose..."). Be plain. State trade-offs.
- ADRs that omit the rejected options. The value is in the comparison.
- "ADR" that's actually a how-to or a runbook. That belongs in `docs/`, not `docs/adr/`.
- 200-page ADRs. Cap at 1–2 pages of decision; supporting analysis goes in linked docs.
- Backfilling ADRs months after the fact and pretending they were Accepted at decision time. If you must backfill, date it accurately and label it as a retroactive record.

## Tooling

- [adr-tools](https://github.com/npryce/adr-tools) (Pryce) — `adr new` scaffolds the next file.
- [Log4Brains](https://github.com/thomvaill/log4brains) — renders ADR set as a website.
- Both optional. The discipline is in the repo, not the tool.

## Sources

- Michael Nygard, "Documenting Architecture Decisions" (2011) — cognitect.com/blog/2011/11/15/documenting-architecture-decisions.
- ThoughtWorks Tech Radar — ADR adoption history.
- [adr.github.io](https://adr.github.io/) — community templates and examples.
