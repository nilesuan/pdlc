# Bug Triage and Management

**Question:** How do teams distinguish severity from priority, structure a bug lifecycle, and set service-level objectives for fixing bugs?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Severity vs. priority

These are two distinct, often conflated, attributes of a bug.

**Severity** measures the impact of the defect on the system. Wikipedia's software bug article summarizes it as: "Severity is a measure of the impact the bug has. This impact may be data loss, financial, loss of goodwill, and wasted effort." [Software bug — Wikipedia](https://en.wikipedia.org/wiki/Software_bug) (accessed 2026-04-24).

Common severity categories listed by the same source:

- Crash or hang
- No workaround (user cannot accomplish a task)
- Has workaround (user can still accomplish the task)
- Visual defect (e.g., misspelling)
- Documentation error

Alternative vocabularies seen in tools include "critical, high, low, blocker, trivial." [Software bug — Wikipedia](https://en.wikipedia.org/wiki/Software_bug) (accessed 2026-04-24).

**Priority** describes the importance of resolving the bug relative to others. The same source notes that priority "may be similar or identical to severity ratings" but is "a different aspect": "A bug with low severity but easy to fix may get a higher priority than a bug with moderate severity that requires significantly more effort to fix." [Software bug — Wikipedia](https://en.wikipedia.org/wiki/Software_bug) (accessed 2026-04-24).

**Practical framing [SYNTHESIS]:** Severity is a property of the bug and the product; priority is a property of the team's queue and schedule. They should be tracked as separate fields. Severity feeds risk and SLA selection; priority feeds sprint/iteration planning. Conflating them leads to two failure modes: critical-severity bugs getting low priority because they are hard to reproduce, and low-severity cosmetic bugs getting high priority because they are visible to a loud stakeholder.

---

## 2. Bug lifecycle

A widely-used but non-standardized lifecycle is: New → Assigned → In Progress → Resolved → Verified → Closed, with branches for Reopened and Rejected/Won't Fix. Atlassian, Bugzilla, GitHub Issues, and similar tools each implement a variant. No single primary source was fetched in this session for a canonical lifecycle diagram; therefore the exact states and transitions are marked `[UNVERIFIED]` in this document. A citable source (e.g., Bugzilla documentation or an Atlassian Jira workflow reference) should be added before treating any specific state diagram as authoritative.

---

## 3. Security-specific bug severity: CVSS

Security bugs are scored with the Common Vulnerability Scoring System, maintained by the Forum of Incident Response and Security Teams (FIRST.Org) through its CVSS Special Interest Group. The system is described as providing "a way to capture the principal characteristics of a vulnerability and produce a numerical score reflecting its severity." [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).

The current version is **CVSS v4.0**, published November 2023. [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).

CVSS v4.0 defines four metric groups:

1. **Base** — intrinsic, time-invariant properties (Attack Vector, Complexity, Requirements, Privileges, User Interaction; Confidentiality/Integrity/Availability impact for both vulnerable and subsequent systems).
2. **Threat** — exploitability in the wild, primarily via "Exploit Maturity."
3. **Environmental** — organization-specific weighting (security requirements, modified base metrics reflecting mitigations).
4. **Supplemental** — Safety, Automatable, Recovery, Value Density, Response Effort, Provider Urgency — these "do not modify the final score" but add analytical context.

[CVSS v4.0 Specification Document — FIRST.Org](https://www.first.org/cvss/v4.0/specification-document) (accessed 2026-04-24).

**Qualitative severity bands** (applied uniformly at the NVD):

| Band | v3.x / v4.0 range |
|------|-------------------|
| None | 0.0 |
| Low | 0.1 – 3.9 |
| Medium | 4.0 – 6.9 |
| High | 7.0 – 8.9 |
| Critical | 9.0 – 10.0 |

[NVD CVSS — NIST](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24); [CVSS v4.0 Specification — FIRST.Org](https://www.first.org/cvss/v4.0/specification-document) (accessed 2026-04-24).

NIST explicitly cautions that "CVSS is not a measure of risk." When complete information is unavailable, the NVD applies "a worst case scenario approach," which may assign a 10.0 until more data is available. [NVD CVSS — NIST](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).

---

## 4. Service-level objectives for bug fixing

Concrete SLA tables are typically set per-product or per-contract rather than by an industry body. No specific SLA matrix (e.g., "Critical in 24 hours, High in 7 days") was sourced in this session; such numbers are deliberately not asserted here. This section is `[UNVERIFIED]` as stated. A reliable primary — for instance a major SaaS vendor's published security patching SLA, or NIST SP 800-40 Rev. 4 — should be fetched before publishing specific timelines.

What *is* verified: NIST SP 800-40 Rev. 4 (April 2022, final) frames patching as "the process of identifying, prioritizing, acquiring, installing, and verifying the installation of patches, updates, and upgrades throughout an organization," and positions it as "a cost of doing business, and a necessary part of what organizations need to do in order to achieve their missions." [NIST SP 800-40 Rev. 4 — NIST, April 2022](https://csrc.nist.gov/pubs/sp/800/40/r4/final) (accessed 2026-04-24). The full PDF was not parsed into this document; specific lifecycle phases (e.g., "identify, plan, acquire, test, deploy, verify") are `[UNVERIFIED]` without a reread of the PDF text.

---

## 5. Triage: integrating severity, priority, and CVSS

**Operational pattern [SYNTHESIS]** — A triage process typically:

1. Ingests the bug report into a tracker with a standardized template.
2. Assigns *severity* from impact on the user/system (and, if security-related, a CVSS vector/score from FIRST.Org metrics).
3. Assigns *priority* from severity + effort + strategic context (who reported it, which customer, what release it blocks).
4. Maps priority to an SLA clock that feeds the team's scheduling system.
5. Tracks resolution to close the record, with verification that the fix landed in the affected versions.

This is synthesized from the distinct sources above; a single canonical end-to-end triage specification was not fetched.

---

## Sources

- [Software bug — Wikipedia](https://en.wikipedia.org/wiki/Software_bug) (accessed 2026-04-24).
- [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).
- [CVSS v4.0 Specification Document — FIRST.Org](https://www.first.org/cvss/v4.0/specification-document) (accessed 2026-04-24).
- [Vulnerability Metrics (CVSS) — NIST NVD](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).
- [NIST SP 800-40 Rev. 4 — NIST, April 2022](https://csrc.nist.gov/pubs/sp/800/40/r4/final) (accessed 2026-04-24).

---

## Open questions

- No canonical bug-lifecycle state diagram was fetched. Add a primary source (Bugzilla docs, Atlassian Jira workflow, or a textbook) before asserting specific states.
- Specific bug-fix SLA numbers are not given here; sourcing them requires fetching a vendor SLA or a government guideline that publishes exact days.
- Full text of NIST SP 800-40 Rev. 4 was not parsed in this session (the PDF fetch returned binary); a text extraction is needed to cite specific lifecycle phases.
- The distinction between *production incidents* (see Stage 07) and *bug reports* in the tracker is policy-dependent and not covered here.
