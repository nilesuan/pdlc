---
name: evolve
description: Phase 08 — turn a running product into one users love. Audits feedback loops, technical debt, dependency hygiene, deprecation policy, and the year-over-year sustainability of delivery.
argument-hint: [service-or-product]
---

# /evolve

## Goal

Confirm the team has live feedback loops, controlled tech debt, clean dependencies, a humane deprecation policy, and sustained delivery year over year.

## Done when (per quarter)

- North Star metric + 3–5 input metrics tracked and reviewed weekly.
- At least one customer interview per week (continuous discovery from Phase 01, never paused).
- Bug SLAs met for > 90% of bugs by severity.
- Dependency updates merged within policy (Dependabot/Renovate green; lockfile committed).
- CVE patch SLAs met for > 95% of applicable vulnerabilities.
- Technical-debt capacity (15–20%) actually spent on debt — not feature work labeled "refactor".
- Retrospective action items reviewed; closed or replanned with new dates.
- Deprecations announced with dates and migration guides (RFC 8594 Sunset header).
- Roadmap re-prioritized against the quarter's signal; OKRs refreshed.
- SBOM regenerated and archived per release.
- DORA four keys + on-call health metrics reviewed; adverse trends have a named owner.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.
- Active lessons in [`../lessons/INDEX.md`](../lessons/INDEX.md) reviewed; any due for retirement (≥ 1 year inactive AND a structural change makes the failure mode impossible, per [`../standards/process/LEARNING.md`](../standards/process/LEARNING.md) §"Retiring lessons") are retired with `retired:` date and one-line `retired-reason:` recorded in INDEX.md.

## Phase

08 — Evolve

## Pre-flight

- The product is post-launch (Phase 06 complete on at least one release).
- Some quarter has elapsed (this command is a recurring quarterly audit; running it on day 30 of launch is premature).

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| Phase 06 ship complete | `cdocs/ship-audit-*.md` exists with a passing run | Pass 1 |
| ≥ 1 quarter elapsed since launch | first prod deploy commit ≥ 90 days ago | Pass 1 |
| North Star + input metrics | dashboard URL recorded in `docs/metrics/` | Pass 1 |
| DORA metric source | CI/CD provider API or `.cdocs/dora-history.json` | Pass 1 |
| Tech-debt inventory | `docs/debt/inventory.md` | Pass 2 |
| CVE / dependency report | Dependabot / Renovate / Snyk export | Pass 2 |
| Last quarter's retro action items | `docs/retros/<YYYY-Qn>.md` | Pass 3 |
| Deprecation policy | `docs/deprecation-policy.md` (RFC 8594 Sunset) | Pass 3 |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "agents": {
    "systems-architect": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/development/CLEAN_ARCHITECTURE.md",
        "standards/docs/ADR.md",
        "standards/process/TECHNICAL_DEBT.md",
        "standards/process/CUSTOMER_FEEDBACK.md"
      ]
    },
    "qa-engineer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/testing/TEST_STRATEGY.md"
      ]
    },
    "platform-engineer": {
      "model": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/operations/OBSERVABILITY.md",
        "standards/operations/ON_CALL.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Are North Star + input metrics tracked and reviewed weekly, is debt inventoried per Fowler quadrant with hotspot analysis, and does the bug backlog have a triage cadence? |
| 2 | Proof & Safety | Are customer interviews continuous (≥ 1/week, ≥ 4 in last 4 weeks), are CVE / dependency SLAs being met, is the SBOM regenerated per release, and is the supply chain hardened (signed images, attestation, mirrored deps)? |
| 3 | Ship Readiness | Are retrospective action items closed or replanned, do deprecations have migration guides + Sunset headers, has the OKR set been refreshed for the next quarter, and is debt capacity (15–20%) actually being spent on debt rather than features labeled "refactor"? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/release/VERSIONING.md
  - standards/operations/OBSERVABILITY.md
  - standards/operations/ON_CALL.md
  - standards/security/OWASP.md
  - standards/process/TECHNICAL_DEBT.md
  - standards/process/CUSTOMER_FEEDBACK.md
```

## Sub-agents

```yaml
sub_agents:
  - systems-architect    # debt assessment, deprecation calls, rewrite-vs-refactor (opus)
  - qa-engineer          # test rot, flake aging (sonnet)
  - platform-engineer    # cost trends, cloud waste, on-call burden (sonnet)
  - security-reviewer    # CVE SLA, dependency hygiene, supply chain (opus)
```

## Pass-loop dispatch

Pass-runner produces a **quarterly evolution report**. Per pass:

### Quantitative signal (qa + platform agents)

1. North Star + input metrics dashboard exists and reviewed weekly?
2. Activation, retention, churn, MRR (or domain equivalents) trended over 4 quarters.
3. DORA four keys: deployment frequency, lead time, change-failure rate, restore time. Trend healthy or degrading?
4. On-call health: pages/shift, % actionable, sleep-disrupting pages.

### Qualitative signal (systems-architect)

1. Customer interview cadence — last 4 weeks: ≥ 4 interviews?
2. NPS data with the open "Why?" text? CSAT/CES on key interactions?
3. Support ticket pattern review — last 90 days top categories?

### Technical debt (systems-architect)

1. Debt inventory exists? Categorized per Fowler quadrant (deliberate/inadvertent × prudent/reckless)?
2. Hotspot analysis (Tornhill) — files with high churn × high complexity?
3. 15–20% capacity actually spent on debt this quarter? Or burned by features labeled "refactor"?

### Bugs (qa-engineer)

1. Triage cadence (daily or weekly, ≤ 15 min)?
2. SEV1 / SEV2 / SEV3 / SEV4 SLAs met > 90%?
3. Backlog size: > 500 untriaged is yellow; > 1000 is red.

### Dependencies + Security (security-reviewer)

1. Dependabot/Renovate enabled? PRs merged within policy?
2. Lockfile committed?
3. CVE patching SLAs met? Critical 7 days, High 30 days (or local policy).
4. SBOM per release? Archived?
5. Supply-chain hygiene: signed images, image attestation, registry mirroring for critical deps.

### Deprecations (systems-architect)

1. Anything to deprecate? Low usage, superseded, high cost/user, API replaced?
2. Strangler-fig path documented for any legacy modernization (no big-bang rewrites)?
3. Sunsets: announcement, alternative, data export, freeze → retire → remove.

## Anti-patterns to flag

- "We'll refactor after the next big launch" — the launch always slips; allocate continuously.
- 500-item bug backlog nobody triages.
- Ignoring dependency updates until a CVE hits.
- 2-year rewrite projects that never ship.
- Retros as ceremony with no follow-through.
- Sunsetting a feature without migration path.
- NPS as a vanity number — the "Why?" text is the signal.
- > 30 days no customer interview (continuous discovery is broken).

## Output

Artifact at `cdocs/evolve-quarterly-<YYYY-Qn>.md` with:

- Quantitative dashboard summary.
- Qualitative signal summary.
- Tech-debt inventory (top 10 items, Fowler quadrant).
- Bug-aging table.
- Dependency / CVE table.
- Deprecation candidates.
- Top 10 actions for the next quarter.

## Sources

- Handbook: [`../../handbook/08-evolve.md`](../../handbook/08-evolve.md)
- Research:
  - [`../../research/08-maintenance/README.md`](../../research/08-maintenance/README.md) — Lehman's laws
  - [`../../research/08-maintenance/feedback-loops.md`](../../research/08-maintenance/feedback-loops.md) — NPS (Reichheld); CES (Dixon/Freeman/Toman); CSAT; Torres continuous discovery; Kerth's Prime Directive; PDCA; Toyota Kata
  - [`../../research/08-maintenance/technical-debt.md`](../../research/08-maintenance/technical-debt.md) — Cunningham metaphor; Fowler quadrant; Tornhill hotspots
  - [`../../research/08-maintenance/bug-management.md`](../../research/08-maintenance/bug-management.md) — severity vs priority; CVSS v4.0
  - [`../../research/08-maintenance/dependency-management.md`](../../research/08-maintenance/dependency-management.md) — Semver 2.0.0; Dependabot/Renovate; left-pad/SolarWinds/Log4Shell
  - [`../../research/08-maintenance/security-patching.md`](../../research/08-maintenance/security-patching.md) — NIST SP 800-40 Rev. 4; coordinated disclosure
  - [`../../research/08-maintenance/deprecation.md`](../../research/08-maintenance/deprecation.md) — RFC 8594 Sunset; Stripe / GitHub API versioning; Fowler Strangler Fig
