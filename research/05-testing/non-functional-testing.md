# Non-Functional Testing — Performance, Security, Accessibility, Usability

**Question:** What are the canonical categories of non-functional testing, and what are the verified frameworks and tools for each?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Functional vs non-functional — why the split matters

Wikipedia's *Software testing* entry describes the split: "Functional testing verifies specific actions work correctly, while non-functional testing addresses qualities like scalability, performance, and security." [VERIFIED] [Software testing — Wikipedia](https://en.wikipedia.org/wiki/Software_testing) (accessed 2026-04-24).

The practical distinction: functional tests ask "does the system do X?"; non-functional tests ask "does the system do X under load / securely / accessibly / usably?"

---

## Performance and load testing

Performance testing is a family of non-functional tests concerned with how a system behaves under a given workload, not whether it produces the correct output.

### Representative tools

**k6 (Grafana)** — "an open-source, developer-friendly load testing tool." k6's documentation identifies six primary performance test types: smoke, average-load, stress, soak, spike, and breakpoint testing. It also supports browser performance via the k6 browser API and chaos/resilience testing via fault injection capabilities. k6 targets "engineers, QA specialists, SDETs, and SREs." [VERIFIED] [Grafana k6 Docs](https://grafana.com/docs/k6/latest/) (accessed 2026-04-24).

**Apache JMeter** — "open source software, a 100% pure Java application designed to load test functional behavior and measure performance." Originally built for web applications; now supports HTTP/HTTPS, SOAP/REST, JDBC, SMTP/POP3/IMAP, JMS, FTP, LDAP, TCP, and Java objects. An important limitation JMeter itself documents: "JMeter is not a browser" — it operates at the protocol level and does not execute JavaScript. [VERIFIED] [Apache JMeter](https://jmeter.apache.org/) (accessed 2026-04-24).

**Gatling** — a load-testing and performance-engineering platform; marketing describes it as "Continuous Performance Intelligence." Supports tests written as code, no-code, or via Postman collections; integrates into CI/CD via CLI and APIs; can generate "millions of virtual users." [VERIFIED] [Gatling](https://gatling.io/) (accessed 2026-04-24).

### Test types

The six types from k6 are broadly used in the industry:

- **Smoke** — minimal-load verification the system works at all.
- **Average-load** — simulates expected workload.
- **Stress** — pushes beyond expected load to find breaking points.
- **Soak** — extended-duration test at average load.
- **Spike** — sudden, sharp load change.
- **Breakpoint** — progressive increase until failure. [VERIFIED] [Grafana k6 Docs](https://grafana.com/docs/k6/latest/) (accessed 2026-04-24).

---

## Security testing — OWASP taxonomy

OWASP's DevSecOps Guideline is the primary reference. It identifies four scanning categories within the vulnerability-scanning section:

- **SAST (Static Application Security Testing)** — analyzing source code and binaries without executing the application.
- **DAST (Dynamic Application Security Testing)** — testing running applications to identify runtime vulnerabilities.
- **IAST (Interactive Application Security Testing)** — combines elements of static and dynamic testing during application execution.
- **SCA (Software Composition Analysis)** — addresses vulnerabilities in third-party dependencies and open-source components.

The stated goal is to "detect security issues (by design or application vulnerability) as fast as possible," implementing a shift-left security philosophy throughout the pipeline. [VERIFIED] [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/latest/) (accessed 2026-04-24).

### SAST details

OWASP's community page on source code analysis tools: SAST tools "analyze source code or compiled versions of code to help find security flaws." Strengths include scalability ("can be run on lots of software, and can be run repeatedly") and detection of buffer overflows and SQL injection. Results pinpoint problematic code by filename, location, line number, and code snippet. [VERIFIED] [Source Code Analysis Tools — OWASP](https://owasp.org/www-community/Source_Code_Analysis_Tools) (accessed 2026-04-24).

Limitations documented by OWASP:

- Difficulty detecting authentication, access control, and cryptographic vulnerabilities.
- "High numbers of false positives."
- Challenges analyzing code that cannot be compiled without proper libraries/instructions.
- Limited effectiveness with configuration-related security issues. [VERIFIED] [Source Code Analysis Tools — OWASP](https://owasp.org/www-community/Source_Code_Analysis_Tools) (accessed 2026-04-24).

OWASP's *Static Code Analysis* page adds that these tools use techniques like "Taint Analysis and Data Flow Analysis" and primarily serve "as aids for an analyst to help them zero in on security relevant portions of code so they can find flaws more efficiently." [VERIFIED] [Static Code Analysis — OWASP](https://owasp.org/www-community/controls/Static_Code_Analysis) (accessed 2026-04-24).

Named tools from OWASP's directories (commercial and open source): Checkmarx, Veracode, Fortify, Semgrep, Bandit, Brakeman. [VERIFIED] [Source Code Analysis Tools — OWASP](https://owasp.org/www-community/Source_Code_Analysis_Tools) (accessed 2026-04-24).

### DAST details

OWASP's *Vulnerability Scanning Tools* page: Web Application Vulnerability Scanners are commonly referred to as "Dynamic Application Security Testing (DAST) Tools." They scan web applications to identify issues including cross-site scripting, SQL injection, command injection, and path traversal. OWASP's listing spans SaaS, on-premises, and hybrid tools and includes open-source options like Nikto, Nuclei, OpenVAS, Wapiti, and the Zed Attack Proxy. [VERIFIED] [Vulnerability Scanning Tools — OWASP](https://owasp.org/www-community/Vulnerability_Scanning_Tools) (accessed 2026-04-24).

### OWASP Web Security Testing Guide (WSTG)

The WSTG is OWASP's comprehensive testing reference: "the premier cybersecurity testing resource for web application developers and security professionals." It uses a standardized identifier system `WSTG-<category>-<number>`. Version 4.2 (released December 3, 2020) is the current stable version at the time of this fetch; version 5.0 is in development. It is licensed CC BY-SA 4.0 and maintained by the OWASP Foundation. [VERIFIED] [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/) (accessed 2026-04-24).

---

## Accessibility testing

### WCAG (Web Content Accessibility Guidelines)

WCAG is an international standard from the W3C that explains "how to make web content more accessible to people with disabilities." [VERIFIED] [W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

**The POUR principles** — WCAG 2.2 organizes guidelines around four core principles:

- **Perceivable** — content must be presented in ways users can perceive.
- **Operable** — users must be able to navigate and interact with content.
- **Understandable** — information and operations must be clear.
- **Robust** — content must work with various assistive technologies. [VERIFIED] [W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

**Conformance levels** — Level A (basic), Level AA (enhanced, "commonly required"), Level AAA (advanced). [VERIFIED] [W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

**Versions**:

| Version | Release date | Notes |
|---|---|---|
| WCAG 2.0 | Dec 11, 2008 | 12 guidelines |
| WCAG 2.1 | June 5, 2018 | Added 1 guideline + 17 success criteria (mobile focus) |
| WCAG 2.2 | Oct 5, 2023 | Added 9 success criteria; 4.1.1 Parsing marked obsolete |

All versions are backward compatible. ISO/IEC 40500:2025 is noted as a standard designation. [VERIFIED] [W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

### Automated accessibility testing — axe

**axe** is a digital accessibility testing platform by Deque Systems. Its core, **axe-core**, is an open-source rules engine released by Deque in 2015. Deque describes axe-core as "the global standard in accessibility testing." The platform supports three approaches: automated testing (rules engines scan against WCAG), semi-automated guided testing, and manual testing with assistive technology. Deque claims automation can "find and fix up to 80% of issues" across web, mobile, and test stacks. [VERIFIED] [Axe — Deque](https://www.deque.com/axe/) (accessed 2026-04-24).

[SYNTHESIS] The "up to 80%" figure is a Deque marketing claim, not an independent measurement. Automated accessibility testing is broadly acknowledged in the field to catch only a subset of issues; manual evaluation remains necessary for the rest.

---

## Usability testing

### Definition

Wikipedia: "Usability testing is a technique in user-centered interaction design that evaluates products by observing real users." It is "an irreplaceable usability practice, since it gives direct input on how real users use the system." [VERIFIED] [Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing) (accessed 2026-04-24).

A key distinction: usability testing involves "systematic observation under controlled conditions to determine how well people can use the product." Users must actually use the product for its intended purpose, not merely comment on it. This separates usability testing from market research and qualitative research. [VERIFIED] [Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing) (accessed 2026-04-24).

### History

Usability testing predates web development. It began in the 1940s with studies of machinery operation (including aircraft controls during WWII). The field formalized in the 1980s with personal computing and Human-Computer Interaction (HCI). Dedicated usability labs were established in the 1990s. [VERIFIED] [Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing) (accessed 2026-04-24).

### Primary methods

From the Wikipedia entry:

- **Guerrilla / hallway testing** — informal public interviews.
- **Remote testing** — synchronous (moderated) or asynchronous (unmoderated).
- **Expert review / heuristic evaluation**.
- **A/B testing** — for web design optimization.
- **Automated expert reviews** using AI. [VERIFIED] [Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing) (accessed 2026-04-24).

---

## Sources

- [Software testing — Wikipedia](https://en.wikipedia.org/wiki/Software_testing) (accessed 2026-04-24)
- [Grafana k6 Docs](https://grafana.com/docs/k6/latest/) (accessed 2026-04-24)
- [Apache JMeter](https://jmeter.apache.org/) (accessed 2026-04-24)
- [Gatling](https://gatling.io/) (accessed 2026-04-24)
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/latest/) (accessed 2026-04-24)
- [Source Code Analysis Tools — OWASP](https://owasp.org/www-community/Source_Code_Analysis_Tools) (accessed 2026-04-24)
- [Static Code Analysis — OWASP](https://owasp.org/www-community/controls/Static_Code_Analysis) (accessed 2026-04-24)
- [Vulnerability Scanning Tools — OWASP](https://owasp.org/www-community/Vulnerability_Scanning_Tools) (accessed 2026-04-24)
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/) (accessed 2026-04-24)
- [W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24)
- [Axe — Deque](https://www.deque.com/axe/) (accessed 2026-04-24)
- [Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing) (accessed 2026-04-24)

---

## Open questions

- OWASP's detailed distinctions between SAST, DAST, IAST at the section-body level (2-a through 2-d of the DevSecOps Guideline) were referenced by title only in the page fetched; the full methodology text for each would require fetching each section page separately.
- The "up to 80%" figure from Deque is a vendor claim; an independent empirical study of automated accessibility tooling coverage was not located in this session.
- The specific guidelines count per WCAG version reported here (12 in 2.0, +1 in 2.1, +9 criteria in 2.2) matches the fetched W3C summary but should be cross-checked against the WCAG quick reference for criterion-level detail.
