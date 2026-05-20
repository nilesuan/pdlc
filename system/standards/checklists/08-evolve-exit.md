# 08-evolve-exit.md — Phase 08 (Evolve) exit checklist

**Authoritative source:** [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md).

This checklist runs on a quarterly cadence (or whenever `/evolve` is invoked).

## Done-when (per quarterly review)

- [ ] **North-star metric reviewed** with current trend; trajectory commented (improving / flat / regressing).
- [ ] **Input metrics reviewed** (the metrics that drive the north star).
- [ ] **Customer interview cadence sustained** (target ≥ 3 / week per Torres; minimum ≥ 1 / week for the team).
- [ ] **Tech-debt audit completed**, classified by Fowler's quadrant: deliberate/inadvertent × prudent/reckless. Prioritization signal attached.
- [ ] **Bug SLAs reviewed:** open SEV1 / SEV2 count and age; trend.
- [ ] **Dependency hygiene:** outdated direct deps count; CVE backlog by severity.
- [ ] **CVE patching SLAs** met:
  - Critical < 7 days
  - High < 30 days
  - Medium < 90 days
  - Low: tracked, no SLA
- [ ] **Deprecation register reviewed.** Anything deprecated has Sunset header (RFC 8594) and a removal date. See [`../release/VERSIONING.md`](../release/VERSIONING.md).
- [ ] **Strangler Fig progress** for any active legacy modernization — measurable progress this quarter.
- [ ] **ADRs reviewed** — any superseded? Any decisions worth re-opening given new evidence?
- [ ] **DORA metrics reviewed:** deployment frequency, lead time, change failure rate, MTTR, reliability. Trend and quartile.
- [ ] **Postmortem action-item closure rate** — % of action items from prior quarter that landed.
- [ ] **Team health signals** — on-call load, alert volume, retention.

## Auto-rejection

| Trigger | Severity |
|---|---|
| Quarterly review with no north-star trend | Major |
| Deprecation announced without Sunset header / removal date | Major |
| Critical CVE > 7 days unpatched without exception ticket | Major |
| Strangler-Fig migration with no measurable progress in two consecutive quarters | Major (decide: proceed, abandon, or accept-and-document) |
| Postmortem action items > 50% unresolved from prior quarter | Major (process) |
| ADR for a deviation that was made without one this quarter | Major |
| Customer interviews skipped for entire quarter | Major (Continuous Discovery violation) |
| > 6-month-old "tmp" / "experiment" infrastructure still live | Minor (cleanup) |

## What good looks like

- The team can answer: "is the product working better than last quarter?" with metrics, not vibes.
- Tech debt is categorized and *some of it gets paid down each quarter*, not just listed.
- Deprecations actually reach removal date — the system contracts as well as expands.
- The DORA metrics show stable or improving quartile; if regressing, an explicit plan exists.
- A few decisions get re-opened with new evidence each quarter; not all decisions are forever.

## Strangler Fig discipline (Fowler)

When modernizing legacy:

1. **Identify a seam** in the legacy system.
2. **Route new behavior through the seam to new code**; old code still serves the rest.
3. **Migrate consumers progressively**, one at a time.
4. **Old code is removed when no consumer calls it.**

Anti-pattern: a "modernization" that adds the new system alongside the old indefinitely without ever cutting over. That's two systems, not modernization.

## Deprecation discipline (RFC 8594)

When removing a public surface:

1. Announce deprecation with date.
2. Add `Sunset: <HTTP-date>` header on the deprecated endpoint (RFC 8594).
3. Add `Deprecation: true` header (IETF draft).
4. Notify consumers; provide migration path.
5. On Sunset date: remove. (Or, if you can't remove, write an ADR explaining why and pick a new date.)

## Sources

- Martin Fowler, "TechnicalDebtQuadrant" (martinfowler.com/bliki/TechnicalDebtQuadrant.html, 2009).
- Martin Fowler, "StranglerFigApplication" (martinfowler.com/bliki/StranglerFigApplication.html, 2004).
- IETF RFC 8594, "The Sunset HTTP Header Field" (2019).
- *Accelerate State of DevOps* (DORA) — quarterly trend review.
- Teresa Torres, *Continuous Discovery Habits* (2021) — interview cadence.
- NIST CSF 2.0 (nist.gov/cyberframework) — vulnerability management baseline.
- Handbook: [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md).
