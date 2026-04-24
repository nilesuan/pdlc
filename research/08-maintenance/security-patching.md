# Security Patching Lifecycle

**Question:** How are software vulnerabilities identified, scored, coordinated, and patched? What are the verified roles of CVE, CVSS, coordinated disclosure, and NIST guidance?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. CVE — Common Vulnerabilities and Exposures

The CVE system was "officially launched for the public in September 1999" as a catalogue of publicly disclosed vulnerabilities, each assigned a unique identifier. It originally used a "CAN-" prefix for candidate entries before promotion to "CVE" status; that candidate/promotion practice ended in 2005. [Common Vulnerabilities and Exposures — Wikipedia](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures) (accessed 2026-04-24).

Maintenance and governance as described by Wikipedia:

- MITRE Corporation maintains the CVE system through the Homeland Security Systems Engineering and Development Institute.
- MITRE receives "funding from the US National Cyber Security Division of the US Department of Homeland Security."
- The system serves as the foundation for the US National Vulnerability Database (NVD).
- Four CNA (CVE Numbering Authority) channels exist: MITRE as Editor/Primary; product vendors (e.g., Microsoft, Oracle, Red Hat) for their own products; third-party coordinators (e.g., CERT) for uncovered products; and, rarely, individual researchers.
- The formal CNA designation was created 1 February 2005.

[Common Vulnerabilities and Exposures — Wikipedia](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures) (accessed 2026-04-24).

**Date-drift note:** Wikipedia also notes that in April 2025 the MITRE contract was "extended for 11 months," rescheduling expiration to 16 March 2026. [Common Vulnerabilities and Exposures — Wikipedia](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures) (accessed 2026-04-24). Any long-term planning around CVE governance should therefore check the current contractual status; treat the exact governance arrangement at any given date as `[OUT OF DATE]` unless rechecked.

---

## 2. CVSS — Common Vulnerability Scoring System

CVSS is maintained by the Forum of Incident Response and Security Teams (FIRST.Org) via the CVSS Special Interest Group, which comprises "representatives from a broad range of industry sectors, from banking and finance to technology and academia." [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).

FIRST.Org frames CVSS as providing "a way to capture the principal characteristics of a vulnerability and produce a numerical score reflecting its severity." The current version is **4.0**, officially published November 2023. [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).

NIST emphasizes the scope limits of the score:

> "CVSS is not a measure of risk."

[Vulnerability Metrics (CVSS) — NIST NVD](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).

### Metric groups (v4.0)

1. **Base** — intrinsic properties (Attack Vector, Complexity, Requirements, Privileges, User Interaction; Confidentiality/Integrity/Availability impact for vulnerable and subsequent systems).
2. **Threat** — current exploit status, mainly via the "Exploit Maturity" metric.
3. **Environmental** — organization-specific weighting and modified base metrics.
4. **Supplemental** — Safety, Automatable, Recovery, Value Density, Response Effort, Provider Urgency; these "do not modify the final score."

[CVSS v4.0 Specification Document — FIRST.Org](https://www.first.org/cvss/v4.0/specification-document) (accessed 2026-04-24).

### Severity bands

At NIST NVD, qualitative ratings map to numeric ranges:

| Band | v2.0 | v3.x | v4.0 |
|------|------|------|------|
| Low | 0.1 – 3.9 | 0.1 – 3.9 | 0.0 – 3.9 |
| Medium | 4.0 – 6.9 | 4.0 – 6.9 | 4.0 – 6.9 |
| High | 7.0 – 10.0 | 7.0 – 8.9 | 7.0 – 8.9 |
| Critical | — | 9.0 – 10.0 | 9.0 – 10.0 |

NIST also notes that as of July 2022 the NVD no longer generates new CVSS v2.0 assessments for newly published CVEs, though existing v2.0 data remains available. [Vulnerability Metrics (CVSS) — NIST NVD](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).

When complete information is unavailable, "the NVD applies a worst case scenario approach" — potentially assigning the maximum 10.0 until more data arrives. [Vulnerability Metrics (CVSS) — NIST NVD](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).

---

## 3. Coordinated vulnerability disclosure (CVD)

Wikipedia describes CVD (also called responsible disclosure) as a practice in which "the involved parties coordinate and negotiate a reasonable period of time for repairing the vulnerability" before public disclosure. Timelines range from days to several months depending on severity and complexity. [Coordinated vulnerability disclosure — Wikipedia](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure) (accessed 2026-04-24).

Documented embargo periods:

- **Google Project Zero** — 90 days after vendor notification, or sooner if a fix releases.
- **Zero Day Initiative (ZDI)** — 120 days from vendor response.

[Coordinated vulnerability disclosure — Wikipedia](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure) (accessed 2026-04-24).

Key coordinating organizations mentioned: CISA (US), ENISA (EU), Project Zero, ZDI, and vendor bug-bounty programs at Facebook, Google, Barracuda, etc. [Coordinated vulnerability disclosure — Wikipedia](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure) (accessed 2026-04-24).

Historical examples cited in the same source: DNS cache poisoning (~5 months embargo), Meltdown and Spectre (~7 months each), ROCA RSA-key issue (~8 months). [Coordinated vulnerability disclosure — Wikipedia](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure) (accessed 2026-04-24).

---

## 4. Log4Shell as a worked example

Log4Shell (CVE-2021-44228) illustrates how CVE, CVSS, and coordinated disclosure interact in a real incident.

- **Discovery:** 24 November 2021, by Chen Zhaojun of Alibaba Cloud Security Team.
- **Private disclosure:** to the Apache Software Foundation the same day.
- **Patch release:** Apache released 2.15.0-rc1 on **6 December 2021**, three days before public disclosure.
- **CVE assignment:** 10 December 2021.
- **CVSS score:** 10.0 (assigned by Apache — maximum severity).
- **Impact framing:** CISA Director Jen Easterly described the issue as "one of the most serious I've seen in my entire career, if not the most serious."

[Log4Shell — Wikipedia](https://en.wikipedia.org/wiki/Log4Shell) (accessed 2026-04-24).

**Observations [SYNTHESIS]:** The Log4Shell timeline — private report, ~2-week embargo, patch before public disclosure, then CVE publication — is the ideal coordinated-disclosure flow. In practice many incidents deviate from it (early leaks, exploit in the wild before patch, vendor non-response), which is why CVSS environmental metrics and threat metrics exist: they let defenders adjust for real-world exploit conditions beyond the vendor's base score.

---

## 5. NIST patch-management guidance

[VERIFIED] NIST Special Publication 800-40 Revision 4, "Guide to Enterprise Patch Management Planning: Preventive Maintenance for Technology" (April 2022, final), defines enterprise patch management as "the process of identifying, prioritizing, acquiring, installing, and verifying the installation of patches, updates, and upgrades throughout an organization" [NIST SP 800-40 Rev. 4 — NIST, April 2022](https://csrc.nist.gov/pubs/sp/800/40/r4/final) (accessed 2026-04-24).

The publication frames patching as "a cost of doing business, and a necessary part of what organizations need to do in order to achieve their missions," arguing that "preventive maintenance through enterprise patch management helps prevent compromises, data breaches, operational disruptions, and other adverse events." It recommends "creating an enterprise strategy to simplify and operationalize patching while also improving reduction of risk" [NIST SP 800-40 Rev. 4 — NIST, April 2022](https://csrc.nist.gov/pubs/sp/800/40/r4/final) (accessed 2026-04-24).

### Risk-response phases

Rev. 4 structures execution as four phases within the "execute the risk response" step of a broader software-vulnerability management lifecycle. Per a secondary summary of the standard's content [Halting Healthcare Hacks: New NIST Patch Management Standards (Part 1, NIST 800-40) — Meditology Services, 2022](https://www.meditologyservices.com/halting-healthcare-hacks-new-nist-patch-management-standards-part-1-nist-800-40/) (accessed 2026-04-24) and an additional review [NIST Releases Guides to Enterprise Patch Management — Peter A. Clarke, 2022-04-11](https://www.peteraclarke.com.au/2022/04/11/nist-releases-guides-to-enterprise-patch-management/) (accessed 2026-04-24):

1. **Prepare the risk response** — preparatory activities including acquiring, validating, and testing patches, and coordinating deployment with enterprise change management.
2. **Implement the risk response** — distributing and installing the patch, and resolving issues that surface during deployment.
3. **Verify the risk response** — confirming the implementation completed and patches are installed and functioning as intended.
4. **Continuously monitor the risk response** — sustaining oversight to ensure the risk response remains in place and effective over time.

[SYNTHESIS] These phases are cited in two independent secondary summaries agreeing on the same phase names. The primary PDF at NIST was not extractable as text in this session (binary), so the phase names are marked `[VERIFIED]` against the two fetched summaries but should be re-confirmed against the primary PDF for direct quotation.

---

## 6. Putting it together — the patching lifecycle

**Synthesis [SYNTHESIS]**, drawing on the verified sources above:

1. **Identify** — monitor CVE/NVD feeds and vendor advisories for new disclosures affecting deployed dependencies.
2. **Assess** — use CVSS base + threat + environmental metrics to prioritize; treat the NVD severity band as a starting point, not a final risk score (per NIST's explicit caveat).
3. **Coordinate** — if the vulnerability is in software you maintain, run coordinated disclosure with a reasonable embargo window; publish a CVE when appropriate.
4. **Remediate** — deploy patches through the organization's change-management process (NIST SP 800-40 Rev. 4 recommends an enterprise strategy to operationalize this).
5. **Verify** — confirm patches are applied in all affected environments.
6. **Communicate** — if external users/customers are affected, notify via changelog, security advisory, and where relevant, `Sunset` headers on deprecated endpoints (see `deprecation.md`).

Specific SLA numbers (e.g., "Critical within 7 days") are organization-specific; no single industry-wide SLA is quoted here.

---

## Sources

- [Common Vulnerabilities and Exposures — Wikipedia](https://en.wikipedia.org/wiki/Common_Vulnerabilities_and_Exposures) (accessed 2026-04-24).
- [CVSS — FIRST.Org](https://www.first.org/cvss/) (accessed 2026-04-24).
- [CVSS v4.0 Specification Document — FIRST.Org](https://www.first.org/cvss/v4.0/specification-document) (accessed 2026-04-24).
- [Vulnerability Metrics (CVSS) — NIST NVD](https://nvd.nist.gov/vuln-metrics/cvss) (accessed 2026-04-24).
- [Coordinated vulnerability disclosure — Wikipedia](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure) (accessed 2026-04-24).
- [Log4Shell — Wikipedia](https://en.wikipedia.org/wiki/Log4Shell) (accessed 2026-04-24).
- [NIST SP 800-40 Rev. 4 — NIST, April 2022](https://csrc.nist.gov/pubs/sp/800/40/r4/final) (accessed 2026-04-24).
- [Halting Healthcare Hacks: New NIST Patch Management Standards (Part 1, NIST 800-40) — Meditology Services, 2022](https://www.meditologyservices.com/halting-healthcare-hacks-new-nist-patch-management-standards-part-1-nist-800-40/) (accessed 2026-04-24).
- [NIST Releases Guides to Enterprise Patch Management — Peter A. Clarke, 2022-04-11](https://www.peteraclarke.com.au/2022/04/11/nist-releases-guides-to-enterprise-patch-management/) (accessed 2026-04-24).

---

## Open questions

- The primary PDF of NIST SP 800-40 Rev. 4 was not parsed as text in this session (binary); phase names above are sourced to two independent secondary summaries (Meditology Services, Peter A. Clarke) that agree on the four risk-response phases. Re-confirm against the primary PDF for direct quotation.
- First-party cve.org pages returned sparse content; the Wikipedia article was used as the verifiable source for CVE governance.
- Vendor-specific disclosure policies (MSRC, GitHub Security Advisories, Atlassian) were not fetched in this session.
- The KEV (Known Exploited Vulnerabilities) catalogue from CISA and the EPSS probability model from FIRST.Org were not cited here; they complement CVSS but were not fetched.
