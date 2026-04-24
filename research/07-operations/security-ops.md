# Security Operations

**Question:** What frameworks govern the operational-security side of running a production software system?

**Status:** Draft

**Last updated:** 2026-04-24

---

## NIST Cybersecurity Framework 2.0

NIST's Cybersecurity Framework is described as a resource for "industry, government, and organizations to reduce cybersecurity risks" and to help entities "better understand and improve their management of cybersecurity risk." The current version is **CSF 2.0**, released **26 February 2024**. Source: [NIST releases Version 2.0 of landmark Cybersecurity Framework](https://www.nist.gov/news-events/news/2024/02/nist-releases-version-20-landmark-cybersecurity-framework) (accessed 2026-04-24).

### Six core functions

CSF 2.0's organising structure, per the same NIST press release [VERIFIED]:

1. **Govern** — new in CSF 2.0 — "encompasses how organizations make and carry out informed decisions on cybersecurity strategy," emphasising that cybersecurity is a major enterprise risk requiring senior-leadership attention.
2. **Identify** — recognise and understand the cybersecurity landscape and assets.
3. **Protect** — implement safeguards against threats.
4. **Detect** — discover and identify security incidents.
5. **Respond** — react and contain.
6. **Recover** — restore systems and normal operations.

NIST states: "these functions provide a comprehensive view of the life cycle for managing cybersecurity risk" when taken together.

Source: [NIST releases Version 2.0 of landmark Cybersecurity Framework](https://www.nist.gov/news-events/news/2024/02/nist-releases-version-20-landmark-cybersecurity-framework) (accessed 2026-04-24).

The top-level framework home page is [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework) (accessed 2026-04-24); it confirms CSF 2.0 as current but does not list the six functions on the landing page itself.

**[SYNTHESIS]** The Detect/Respond/Recover trio in CSF 2.0 maps neatly onto the same three-phase shape SRE uses for availability incidents (monitor, respond, postmortem). In both domains, you cannot skip detection and still do the other two well.

---

## OWASP Top 10

The OWASP Top 10 is "a standard awareness document for developers and web application security" that "represents a broad consensus about the most critical security risks to web applications." [VERIFIED] The current release is **OWASP Top 10:2025**, referred to on the OWASP site as "the 8th installment" of the list [OWASP Top 10:2025](https://owasp.org/Top10/2025/) (accessed 2026-04-24); [OWASP Top 10:2025 Introduction](https://owasp.org/Top10/2025/0x00_2025-Introduction/) (accessed 2026-04-24).

### The 2025 list [VERIFIED]

Per the OWASP Top 10:2025 landing page and its Introduction, the categories are:

| ID | Name |
|---|---|
| A01:2025 | Broken Access Control |
| A02:2025 | Security Misconfiguration |
| A03:2025 | Software Supply Chain Failures |
| A04:2025 | Cryptographic Failures |
| A05:2025 | Injection |
| A06:2025 | Insecure Design |
| A07:2025 | Authentication Failures |
| A08:2025 | Software or Data Integrity Failures |
| A09:2025 | Security Logging & Alerting Failures |
| A10:2025 | Mishandling of Exceptional Conditions |

Source: [OWASP Top 10:2025](https://owasp.org/Top10/2025/) (accessed 2026-04-24); [OWASP Top 10:2025 Introduction](https://owasp.org/Top10/2025/0x00_2025-Introduction/) (accessed 2026-04-24).

Methodology (2025 edition): the ranking was derived from analysis of approximately 175,000 CVE records mapped to CWEs, using CVSS exploit/impact scoring, with 12 candidate categories ranked from data and two categories promoted via a community survey [OWASP Top 10:2025 Introduction](https://owasp.org/Top10/2025/0x00_2025-Introduction/) (accessed 2026-04-24).

### The 2021 list (historical)

| ID | Name | Shortest description |
|---|---|---|
| A01 | Broken Access Control | Failures in access-restriction mechanisms. |
| A02 | Cryptographic Failures | Weaknesses in encryption and data protection. |
| A03 | Injection | Malicious code insertion. |
| A04 | Insecure Design | Fundamental design flaws in security architecture. |
| A05 | Security Misconfiguration | Improper system/application setup. |
| A06 | Vulnerable and Outdated Components | Libraries with known security issues. |
| A07 | Identification and Authentication Failures | Broken login/session management. |
| A08 | Software and Data Integrity Failures | Compromised updates/dependencies (supply chain). |
| A09 | Security Logging and Monitoring Failures | Inadequate security event tracking. |
| A10 | Server Side Request Forgery (SSRF) | Unauthorised server-side requests. |

Source: [OWASP Top 10:2021](https://owasp.org/Top10/2021/) (accessed 2026-04-24).

[SYNTHESIS] Observed shifts 2021 → 2025: Security Misconfiguration rose from A05 to A02; Supply Chain failures emerged as a standalone category (A03:2025), promoted from the narrower "Vulnerable and Outdated Components" (A06:2021); a brand-new A10:2025 "Mishandling of Exceptional Conditions" replaces SSRF at the #10 slot; Injection moved from A03 to A05; A09's name changed from "Logging and Monitoring" to "Logging & Alerting" failures.

---

## CISA (Cybersecurity and Infrastructure Security Agency)

CISA is the US federal agency responsible for operational cybersecurity coordination and critical-infrastructure defence. Direct fetches of cisa.gov returned 403s during this session, so I cannot independently cite its materials here.

**[UNVERIFIED]** CISA publishes Known Exploited Vulnerabilities (KEV), joint advisories with FBI/NSA, and "Secure by Design" pledges — these are industry-referenced but not verified via fetch in this session. Treat CISA-attributed claims as requiring re-verification before inclusion in load-bearing decisions.

---

## How sec-ops and SRE relate

**[SYNTHESIS]** from the above sources plus Google SRE's detect-respond-learn pattern:

- Both SRE and sec-ops operate on a detect → respond → recover → learn loop. SRE's "incident" is typically availability- or latency-driven; sec-ops' incident is typically a threat or breach. The organisational shape — declared commander, living incident document, postmortem — transfers.
- CSF 2.0's **Protect** function maps to things that largely precede production (design reviews, hardening, access management) — overlapping with Stage 03 (design) and Stage 06 (release) more than Stage 07. **Detect**, **Respond**, **Recover**, **Govern** are where day-to-day ops lives.
- Security Operations Centres (SOCs) and SIEM tooling are the analogue of SRE's monitoring and on-call setup for the security domain. **[UNVERIFIED]** I did not fetch a primary source for the SOC/SIEM definitions in this session; treat those terms as placeholders requiring primary sourcing in a follow-up pass.
- OWASP Top 10 A09 (logging and monitoring failures) is the direct tie between observability discipline and security posture: you cannot detect what you are not logging. This is one area where SRE-grade observability directly reduces security risk.

---

## Sources

- [NIST Cybersecurity Framework (landing)](https://www.nist.gov/cyberframework) (accessed 2026-04-24)
- [NIST releases Version 2.0 of landmark Cybersecurity Framework](https://www.nist.gov/news-events/news/2024/02/nist-releases-version-20-landmark-cybersecurity-framework) (accessed 2026-04-24)
- [OWASP Top 10:2025](https://owasp.org/Top10/2025/) (accessed 2026-04-24)
- [OWASP Top 10:2025 Introduction](https://owasp.org/Top10/2025/0x00_2025-Introduction/) (accessed 2026-04-24)
- [OWASP Top 10:2021](https://owasp.org/Top10/2021/) (accessed 2026-04-24)
- [OWASP Top 10 (project home)](https://owasp.org/www-project-top-ten/) (accessed 2026-04-24)

---

## Open questions

- **CSF 2.0 Categories and Subcategories** — the six functions expand into categories (e.g., `ID.AM`, `PR.AC`). A direct fetch of the CSF 2.0 document itself (NIST CSWP 29) would let us cite the next layer of detail.
- **OWASP Top 10:2025 per-category pages** — individual A0x pages (risk, attack vectors, prevention guidance) were not drilled into this pass; they should be fetched when a specific category is used as a load-bearing source.
- **OWASP Top 10:2025 release date precision** — the pages confirm this is the final 8th installment but do not state a specific date on the fetched landing/intro pages; a release-notes page would pin the date down.
- **SOC/SIEM primary sources** — find authoritative definitions (NIST SP 800-137, MITRE ATT&CK, or a clearly cited vendor reference) for Security Operations Center and SIEM, rather than relying on training-data recall.
- **CISA materials** — re-attempt fetching from cisa.gov (e.g. the KEV catalog, Shields Up, Secure by Design pledge) once the 403 resolves.
- **SBOM / supply-chain controls** — A03:2025 (Software Supply Chain Failures) is explicitly supply-chain; a citable primary source for SLSA, SBOM (CISA, NTIA), and sigstore would complete the picture. Out of scope for this first pass.
