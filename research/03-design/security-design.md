# Security Design

**Question:** How do industry-grade software teams design for security during the design stage — specifically threat modelling, security-relevant quality attributes, and canonical references?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Threat modelling

### 1.1 OWASP framing

OWASP defines threat modelling as work that "identif[ies], communicate[s], and understand[s] threats and mitigations within the context of protecting something of value." A threat model is "a structured representation of all the information that affects the security of an application." [Threat Modeling — OWASP community page](https://owasp.org/www-community/Threat_Modeling) (accessed 2026-04-24).

OWASP organises the work around four questions:

1. "What are we working on?"
2. "What can go wrong?"
3. "What are we going to do about it?"
4. "Did we do a good job?"

[Threat Modeling — OWASP community page](https://owasp.org/www-community/Threat_Modeling) (accessed 2026-04-24).

### 1.2 OWASP four-step process

From OWASP's Threat Modeling Process page:

1. **Scope your work** — "gaining an understanding of what you're working on": data flow diagrams, identifying where attackers could interact, recognising protected resources and trust boundaries.
2. **Determine threats** — using structured categorisation (e.g., STRIDE) against data sources, processes, data flows, and interactions.
3. **Determine countermeasures and mitigation** — choose among: **Accept** ("decide that the business impact is acceptable"), **Eliminate** (remove vulnerable components), **Mitigate** ("add checks or controls that reduce the risk impact"), **Transfer** (shift responsibility to insurers or customers).
4. **Assess your work** — confirm that the output contains "a diagram, a threats list and a control list."

OWASP also notes that "threat modeling is not an approach to reviewing code, but it does complement the security code review process."

[Threat Modeling Process — OWASP community page](https://owasp.org/www-community/Threat_Modeling_Process) (accessed 2026-04-24).

### 1.3 STRIDE

Microsoft's Threat Modeling Tool documentation defines the STRIDE categories:

| Letter | Category | Microsoft's description |
|---|---|---|
| **S** | Spoofing | "Involves illegally accessing and then using another user's authentication information, such as username and password." |
| **T** | Tampering | "Involves the malicious modification of data … unauthorized changes made to persistent data … and the alteration of data as it flows between two computers over an open network." |
| **R** | Repudiation | "Associated with users who deny performing an action without other parties having any way to prove otherwise." |
| **I** | Information Disclosure | "Involves the exposure of information to individuals who are not supposed to have access to it." |
| **D** | Denial of Service | "Denial of service (DoS) attacks deny service to valid users — for example, by making a Web server temporarily unavailable or unusable." |
| **E** | Elevation of Privilege | "An unprivileged user gains privileged access and thereby has sufficient access to compromise or destroy the entire system." |

[Threats — Microsoft Threat Modeling Tool, Microsoft Learn](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) (accessed 2026-04-24).

Microsoft also frames STRIDE as an aid to structured questioning: "How can an attacker change the authentication data? What is the impact if an attacker can read the user profile data? What happens if access is denied to the user profile database?" [Threats — Microsoft Threat Modeling Tool](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) (accessed 2026-04-24).

### 1.4 PASTA and other methodologies

[CONTESTED / UNVERIFIED in the sources I fetched.] The OWASP community page at https://owasp.org/www-community/Threat_Modeling explicitly mentions only "STRIDE, Kill Chains, or Attack Trees" as examples of structured approaches and does not describe PASTA on that page. Consequently, PASTA cannot be sourced from the OWASP pages fetched in this session. Using PASTA as a cited methodology here would require a follow-up fetch of a primary source (e.g., Ucedavélez & Morana's PASTA book, or an OWASP-wiki PASTA page that actually describes it).

The same caveat applies to Trike, LINDDUN, OCTAVE, and VAST: none were directly sourced in this session.

---

## 2. OWASP Application Security Verification Standard (ASVS)

OWASP's ASVS project describes itself as "a basis for testing web application technical security controls and also provides developers with a list of requirements for secure development." The project defines three objectives:

1. "As a metric" — a standard to assess web application trustworthiness.
2. "As guidance" — direction for security control developers.
3. "During procurement" — a baseline for specifying security verification requirements.

Current version: **5.0.0**, "released LIVE at Global AppSec EU Barcelona 2025" on 2025-05-30. Requirements follow a `<chapter>.<section>.<requirement>` format, with a recommended reference format that includes the version, e.g., `v5.0.0-1.2.5`.

[OWASP Application Security Verification Standard project page](https://owasp.org/www-project-application-security-verification-standard/) (accessed 2026-04-24).

---

## 3. OWASP Top 10

OWASP describes the Top 10 as "a standard awareness document for developers and web application security. It represents a broad consensus about the most critical security risks to web applications" and "Globally recognized by developers as the first step towards more secure coding." The page references the current 2025 version. [OWASP Top Ten project page](https://owasp.org/www-project-top-ten/) (accessed 2026-04-24).

[UNVERIFIED] The specific ten categories in the 2025 edition were not enumerated on the project-page content I fetched. The ranked list should come from a direct fetch of the `owasp.org/Top10/2025/` pages before being cited here.

---

## 4. Security among quality attributes (ISO/IEC 25010)

Security is one of the eight characteristics in ISO/IEC 25010's product quality model. Its sub-characteristics, per Wikipedia: **confidentiality, integrity, non-repudiation, accountability, authenticity**. [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24).

Microsoft's Azure Well-Architected Framework independently lists **Security** as one of its five pillars: "Protect the workload from attacks by maintaining confidentiality and data integrity." [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24).

[SYNTHESIS] The sources agree that security in the design phase has two distinct outputs: (a) threat-model artefacts (diagram, threats list, controls list — per OWASP), and (b) security requirements aligned to ISO/IEC 25010's sub-characteristics and to a verification standard like OWASP ASVS.

---

## 5. Secure design in microservices architectures

Microsoft's microservices guidance lists concrete security practices at the design layer:

- "Improve security by using mutual Transport Layer Security (mTLS) for service-to-service encryption."
- "Implement role-based access control and use API gateways to enforce policies."
- "Offload cross-cutting concerns, such as authentication and Secure Sockets Layer termination, to the gateway."
- Embedding security logic inside each microservice is called out as an anti-pattern: "offloading security to dedicated components keeps services focused and cleaner."

[Microservices Architecture Style — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24).

Microsoft's event-driven architecture guidance adds: "events are often visible to multiple components in a workload, even if those components don't consume them or aren't meant to consume them. To operate with an 'assume breach' mindset, be mindful of what information you include in events to prevent unintended information exposure." [Event-Driven Architecture Style — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24).

---

## Open questions

- **PASTA primary citation.** Not sourced in this session.
- **Microsoft SDL threat modelling guidance.** `learn.microsoft.com/en-us/security/engineering/threat-modeling` returned HTTP 404 in this session; a current SDL URL should be located.
- **OWASP 2025 Top 10 list.** Not enumerated in the fetched sources; direct fetch of `owasp.org/Top10/2025/` is a follow-up.
- **NIST secure-development references.** NIST SP 800-218 (SSDF) and SP 800-53 were not fetched this session.
- **Security testing (DAST/SAST/SCA) in design.** Covered better in Stage 05 (Testing) and Stage 06 (Release).

---

## Sources

- [Threat Modeling — OWASP community page](https://owasp.org/www-community/Threat_Modeling) (accessed 2026-04-24)
- [Threat Modeling Process — OWASP community page](https://owasp.org/www-community/Threat_Modeling_Process) (accessed 2026-04-24)
- [Threats — Microsoft Threat Modeling Tool, Microsoft Learn](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) (accessed 2026-04-24)
- [OWASP Application Security Verification Standard project page](https://owasp.org/www-project-application-security-verification-standard/) (accessed 2026-04-24)
- [OWASP Top Ten project page](https://owasp.org/www-project-top-ten/) (accessed 2026-04-24)
- [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24)
- [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24)
- [Microservices Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24)
- [Event-Driven Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24)
