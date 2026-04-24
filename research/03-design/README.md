# 03 — Design & Architecture

**Question:** What does industry-grade software design and architecture look like — process, deliverables, and supporting practices — between planning and construction in a product's lifecycle?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

This document indexes Stage 03 of the PDLC: the activities that translate validated requirements and plans (Stages 01–02) into a technical design that developers can build against (Stage 04). It covers the architecture process, architectural styles, domain modelling, diagramming, API design, non-functional requirements, threat modelling, UX design, accessibility, and how engineering organisations formalise design decisions (RFCs, ADRs, design docs).

Detail lives in topic files:

- `system-architecture.md` — architecture process, ADRs, styles/patterns, DDD, C4, NFRs
- `api-design.md` — REST, GraphQL, gRPC, and published API guidelines
- `security-design.md` — threat modelling, OWASP verification, secure-design references
- `ux-design.md` — UX process, wireframes and prototypes, design systems, heuristics, accessibility
- `adrs.md` — Architecture Decision Record format, origins, templates, examples
- `design-docs-rfcs.md` — how engineering teams write and review design documents

---

## What the sources agree on

1. **Architecture is a decision-making activity, not a diagram.** Architecture Decision Records (ADRs) were popularised by Michael Nygard's 2011 post "Documenting Architecture Decisions," which frames architecture as a sequence of significant, justified decisions rather than a single upfront artefact. [Documenting Architecture Decisions — Michael Nygard, 2011](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24); [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24).

2. **Bounded contexts, not a unified model, scale.** Eric Evans' Domain-Driven Design (2003) introduced Bounded Contexts and Ubiquitous Language as the strategic tools for organising domain models at scale. [Domain-Driven Design — Martin Fowler bliki](https://martinfowler.com/bliki/DomainDrivenDesign.html) (accessed 2026-04-24); [BoundedContext — Martin Fowler bliki](https://martinfowler.com/bliki/BoundedContext.html) (accessed 2026-04-24); [Ubiquitous Language — Martin Fowler bliki](https://martinfowler.com/bliki/UbiquitousLanguage.html) (accessed 2026-04-24).

3. **Prefer the simpler architecture until forces push otherwise.** Fowler's "MonolithFirst" (2015) recommends starting monolithic and extracting services only after boundaries stabilise; "Microservice Premium" warns that microservices carry real, recurring costs. [MonolithFirst — Martin Fowler, 2015](https://martinfowler.com/bliki/MonolithFirst.html) (accessed 2026-04-24); [MicroservicePremium — Martin Fowler](https://martinfowler.com/bliki/MicroservicePremium.html) (accessed 2026-04-24).

4. **Diagrams should be hierarchical.** Simon Brown's C4 model (Context → Container → Component → Code) is the most-referenced modern diagram approach on the primary sources in scope. [The C4 model — Simon Brown, c4model.com](https://c4model.com/) (accessed 2026-04-24).

5. **Quality attributes are formalised.** ISO/IEC 25010 enumerates eight product-quality characteristics (functional suitability, performance efficiency, compatibility, usability, reliability, security, maintainability, portability). Cloud vendor frameworks (e.g. Microsoft's Azure Well-Architected Framework) map their pillars onto a similar set. [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24); [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24).

6. **Threat modelling answers four questions.** OWASP frames threat modelling around: What are we working on? What can go wrong? What are we going to do about it? Did we do a good job? STRIDE is the most commonly cited structured categorisation. [Threat Modeling — OWASP community page](https://owasp.org/www-community/Threat_Modeling) (accessed 2026-04-24); [Threats (STRIDE) — Microsoft Learn](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) (accessed 2026-04-24).

7. **Accessibility has a public, versioned standard.** WCAG 2.2 (October 2023) is the current W3C/WAI recommendation; it adopts the POUR principles (Perceivable, Operable, Understandable, Robust) with three conformance levels (A, AA, AAA). [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

8. **Usability heuristics have a canonical list.** Jakob Nielsen's 10 usability heuristics (1994; last updated 2024 per the article) remain the most-cited baseline for interaction critique. [10 Usability Heuristics — Nielsen Norman Group](https://www.nngroup.com/articles/ten-usability-heuristics/) (accessed 2026-04-24).

---

## What the sources disagree on, or don't say

- **STRIDE vs PASTA vs others.** The OWASP community page on threat modelling explicitly names STRIDE and Kill Chains; PASTA is not on that page. That page therefore cannot be cited for PASTA. See `security-design.md` for treatment and the note that more specialised OWASP references would be required to cite PASTA. [CONTESTED] within sources.
- **Microservices definition.** Fowler & Lewis (2014) define microservices with nine characteristics; `microservices.io` (Chris Richardson) defines them more tersely as "independently deployable, loosely coupled" and emphasises a pattern language. The two are compatible but focus differently; both are cited in `system-architecture.md`.
- **Service-Oriented Architecture (SOA).** Fowler's 2005 "Service Oriented Ambiguity" argues SOA is "a semantics-free concept." The sources in scope do not converge on a single SOA definition, and this doc treats SOA as the broader, pre-microservices umbrella that Fowler critiques rather than a single pattern.

---

## Sources

- [Documenting Architecture Decisions — Michael Nygard, cognitect.com, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24)
- [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24)
- [The C4 model — c4model.com, Simon Brown](https://c4model.com/) (accessed 2026-04-24)
- [Microservices — Martin Fowler & James Lewis, martinfowler.com/articles, 2014-03-25](https://martinfowler.com/articles/microservices.html) (accessed 2026-04-24)
- [MonolithFirst — Martin Fowler, 2015-06-03](https://martinfowler.com/bliki/MonolithFirst.html) (accessed 2026-04-24)
- [MicroservicePremium — Martin Fowler](https://martinfowler.com/bliki/MicroservicePremium.html) (accessed 2026-04-24)
- [ServiceOrientedAmbiguity — Martin Fowler, 2005-07-01](https://martinfowler.com/bliki/ServiceOrientedAmbiguity.html) (accessed 2026-04-24)
- [microservices.io — Chris Richardson](https://microservices.io/) (accessed 2026-04-24)
- [Serverless Architectures — Mike Roberts, martinfowler.com/articles, 2018-05-22](https://martinfowler.com/articles/serverless.html) (accessed 2026-04-24)
- [Event-Driven Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24)
- [Microservices Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24)
- [Break a Monolith into Microservices — Zhamak Dehghani, martinfowler.com, 2018-04-24](https://martinfowler.com/articles/break-monolith-into-microservices.html) (accessed 2026-04-24)
- [Domain-Driven Design — Martin Fowler bliki](https://martinfowler.com/bliki/DomainDrivenDesign.html) (accessed 2026-04-24)
- [BoundedContext — Martin Fowler bliki](https://martinfowler.com/bliki/BoundedContext.html) (accessed 2026-04-24)
- [UbiquitousLanguage — Martin Fowler bliki](https://martinfowler.com/bliki/UbiquitousLanguage.html) (accessed 2026-04-24)
- [Use Tactical DDD to Design Microservices — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) (accessed 2026-04-24)
- [System Context Diagram — c4model.com](https://c4model.com/diagrams/system-context) (accessed 2026-04-24)
- [Container Diagram — c4model.com](https://c4model.com/diagrams/container) (accessed 2026-04-24)
- [Component Diagram — c4model.com](https://c4model.com/diagrams/component) (accessed 2026-04-24)
- [Software System — c4model.com](https://c4model.com/abstractions/software-system) (accessed 2026-04-24)
- [Fielding Dissertation Chapter 5 (search summary) — ics.uci.edu](https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) (search-result summary only; direct fetch returned 403; access date 2026-04-24)
- [REST — Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer) (accessed 2026-04-24)
- [gRPC — grpc.io](https://grpc.io/) (accessed 2026-04-24)
- [GraphQL specification — graphql/graphql-spec GitHub repo](https://github.com/graphql/graphql-spec) (accessed 2026-04-24)
- [Google API Design Guide — cloud.google.com/apis/design (via redirect docs.cloud.google.com)](https://docs.cloud.google.com/apis/design) (accessed 2026-04-24)
- [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24)
- [ISO/IEC 25010 overview — iso25000.com](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010) (accessed 2026-04-24)
- [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24)
- [Threat Modeling — OWASP community page](https://owasp.org/www-community/Threat_Modeling) (accessed 2026-04-24)
- [Threat Modeling Process — OWASP community page](https://owasp.org/www-community/Threat_Modeling_Process) (accessed 2026-04-24)
- [Threats (STRIDE) — Microsoft Learn](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats) (accessed 2026-04-24)
- [OWASP Application Security Verification Standard project page](https://owasp.org/www-project-application-security-verification-standard/) (accessed 2026-04-24)
- [OWASP Top Ten project page](https://owasp.org/www-project-top-ten/) (accessed 2026-04-24)
- [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24)
- [Introduction to Web Accessibility — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-intro/) (accessed 2026-04-24)
- [ADA Web Guidance — ada.gov](https://www.ada.gov/resources/web-guidance/) (accessed 2026-04-24)
- [European Accessibility Act — European Commission](https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/union-equality-strategy-rights-persons-disabilities-2021-2030/european-accessibility-act_en) (accessed 2026-04-24)
- [10 Usability Heuristics — Nielsen Norman Group, Jakob Nielsen](https://www.nngroup.com/articles/ten-usability-heuristics/) (accessed 2026-04-24)
- [Design Thinking 101 — Nielsen Norman Group](https://www.nngroup.com/articles/design-thinking/) (accessed 2026-04-24)
- [Design Systems 101 — Nielsen Norman Group, Therese Fessenden](https://www.nngroup.com/articles/design-systems-101/) (accessed 2026-04-24)
- [Shopify Polaris](https://polaris-react.shopify.com/) (accessed 2026-04-24)
- [Design Docs at Google — Malte Ubl, industrialempathy.com, 2020-07-06](https://www.industrialempathy.com/posts/design-docs-at-google/) (accessed 2026-04-24)
- [RFD 1: Requests for Discussion — Jessie Frazelle, oxide.computer blog, 2020-07-24](https://www.oxide.computer/blog/rfd-1-requests-for-discussion) (accessed 2026-04-24)
- [Documenting Software Architectures (Views and Beyond), 2nd ed. — Clements et al., 2010 (book entry on O'Reilly)](https://www.oreilly.com/library/view/documenting-software-architectures/9780132488617/) (accessed 2026-04-24)

---

## Open questions

- **PASTA and Trike threat-modelling methodologies:** OWASP community pages I fetched do not themselves define PASTA or Trike. Separate primary sources (e.g., the Ucedavélez & Morana PASTA book or OWASP wiki pages for those methodologies) are needed before either can be cited here.
- **Fielding dissertation direct quotation:** Chapter 5 returned HTTP 403 on direct fetch in this session. Wikipedia and UC Irvine search summaries confirm the structure of REST's six constraints, but for a primary-source quote the dissertation itself (or its PDF) must be re-fetched.
- **Microsoft REST API Guidelines:** The canonical `github.com/microsoft/api-guidelines/blob/vNext/Guidelines.md` page is marked deprecated and redirects to per-product guidance (Azure, Microsoft Graph). A re-pass should fetch the current Azure REST API Guidelines and Microsoft Graph REST API Guidelines directly.
- **Material Design and Fluent UI principles:** Neither page returned substantive principle text in this session; Polaris was the only first-party design-system page that yielded content. A follow-up pass should fetch Material 3 and Fluent UI principle pages with fallback search terms.
- **ISO/IEC 25010:2023 vs 2011:** The iso25000.com page and Wikipedia cite slightly different groupings (e.g., "interaction capability" on iso25000.com vs "usability" on Wikipedia). The authoritative ISO page itself was blocked (403). Sources should be reconciled against the current ISO publication, which I could not access in this session. [CONTESTED]
- **State-of-practice evidence:** No survey data (Stack Overflow, DORA, ThoughtWorks Tech Radar) on the adoption of ADRs, C4, or DDD was fetched in this session. Adoption-rate claims in later drafts should come with a fetched survey citation.
