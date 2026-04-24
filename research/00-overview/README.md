# 00 — Overview: PDLC vs SDLC, Stages, and Research Map

**Question:** What is the Product Development Life Cycle (PDLC), how does it differ from the classical Software Development Life Cycle (SDLC), and how is this research folder organized to cover it?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Scope of this overview

This document and its siblings in `/research/00-overview/` establish the vocabulary, models, standards, and industry evidence that the rest of the PDLC research folder will build on. It is the first of nine stage folders; the others (`01-ideation` through `08-maintenance`) address individual life cycle stages in depth.

The three companion documents in this folder:

- `models.md` — lifecycle models (Waterfall, V-Model, Spiral, Agile, Scrum, XP, Kanban, Lean, DevOps/CD, Lean Startup) with primary-source citations.
- `frameworks.md` — scaling frameworks (SAFe, LeSS, Disciplined Agile) and formal standards (ISO/IEC/IEEE 12207, 15288).
- `industry-research.md` — DORA / Accelerate State of DevOps, the Accelerate book, Stack Overflow Developer Survey, Thoughtworks Technology Radar.

---

## 2. Definitions: PDLC vs SDLC

### 2.1 SDLC (Software Development Life Cycle)

The SDLC is a process framework that spans software from acquisition and concept through retirement. The most authoritative modern definition is in the international standard ISO/IEC/IEEE 12207:2017, whose scope is quoted by IEEE Standards Association: the standard establishes a framework applicable to "acquisition of software systems, supply, development, operation, maintenance, and disposal of software products" and covers the software portion of systems [IEEE SA — ISO/IEC/IEEE 12207 (2017)](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24). The 2017 revision aligns with ISO/IEC/IEEE 15288 and defines 30 processes, reduced from 43 in earlier editions after redundant software-specific items were merged or removed [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24).

The Wikipedia entry notes the standard "does not prescribe a specific software life cycle model" — the same processes recur across different stages rather than being aligned one-to-one to phases [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24). [VERIFIED]

### 2.2 PDLC (Product Development Life Cycle)

[VERIFIED — 2026-04-24] PDLC is not defined by an ISO/IEC/IEEE standard. The closest formal treatments of a product lifecycle are AIPMM's **ProdBOK® Guide** ("The Guide to the Product Management and Marketing Body of Knowledge"), which uses the term "product management lifecycle" to cover goods and services broadly ([AIPMM ProdBOK landing page](https://aipmm.com/prodbok) (accessed 2026-04-24)), and the PMI **PMBOK Guide**, which is project-oriented rather than product-oriented. The acronym "PDLC" itself is used in practitioner and vendor material without a single canonical source.

In practice, PDLC broadens the unit of planning from a project (a delivery with a fixed scope and end) to a product (a long-lived value stream with continuous discovery, delivery, and operation). The research in this folder treats PDLC as covering the software SDLC plus the product-management activities upstream (ideation, problem validation, opportunity framing) and operation-side activities downstream (observability, incident response, iteration) that the classical SDLC treats as adjacent but not central.

[SYNTHESIS] This framing is a synthesis from: (a) the Scrum Guide's description of Scrum as a framework to "generate value through adaptive solutions for complex problems" rather than deliver a fixed project scope [Scrum Guide 2020 — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24); (b) the Lean Startup emphasis on validated learning through the Build-Measure-Learn loop rather than a one-shot build [The Lean Startup — Ries](https://theleanstartup.com/principles) (accessed 2026-04-24); and (c) DORA's research premise that software delivery is a continuous capability, not a project, measured across deployment frequency, lead time, change failure rate, and failed-deployment recovery time [DORA — Four Keys](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24).

### 2.3 How they differ and overlap

Overlap: both describe the same underlying engineering work — requirements, design, build, verify, release, operate, maintain.

Difference:

- **Unit of work.** SDLC, as framed by ISO/IEC/IEEE 12207, is organized around processes applied to a software product within a system [IEEE SA — 12207](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24). PDLC, as used in product-led orgs, is organized around a product's value stream over its lifetime — which includes evaluating whether to build at all.
- **Endpoint.** The SDLC includes "disposal" as a lifecycle process [IEEE SA — 12207](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24). PDLC in a product-led organization commonly loops back to discovery rather than ending; the Scrum Guide frames this as the Product Goal being "the long-term objective for the Scrum Team" which "meets the Product Goal (or abandons it)" before selecting a next one [Scrum Guide 2020 — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).
- **Continuous vs staged.** Agile and DevOps practices collapse the traditional staged SDLC into continuous flows. Martin Fowler defines Continuous Delivery as "a software development discipline where you build software in such a way that the software can be released to production at any time" [ContinuousDelivery — Fowler, 2013/2014](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24).

> **Note on terminology.** "PDLC" is used in industry but is not standardized by ISO/IEEE. Where a claim below requires a standardized source, this research cites SDLC standards; where it requires a product-management source, it cites Scrum, Lean Startup, or DORA. Cross-framework claims are tagged [SYNTHESIS].

---

## 3. The stages at a glance

Modern product organizations treat the following as continuous, overlapping activities rather than strict sequential phases — this is the explicit thrust of the Agile Manifesto's principle "Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale" [Principles behind the Agile Manifesto](https://agilemanifesto.org/principles.html) (accessed 2026-04-24) and DORA's positioning of deployment frequency as a primary performance measure [DORA Four Keys](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24).

The research folder uses these stage names:

| # | Folder | Activity |
|---|---|---|
| 00 | `00-overview` | Definitions, models, standards, industry research (this folder) |
| 01 | `01-ideation` | Discovery, problem validation, requirements elicitation |
| 02 | `02-planning` | Roadmaps, prioritization, estimation |
| 03 | `03-design` | Architecture, UX, technical design |
| 04 | `04-development` | Coding practices, version control, code review |
| 05 | `05-testing` | Testing strategies, QA, quality gates |
| 06 | `06-release` | CI/CD, deployment, release management |
| 07 | `07-operations` | Monitoring, incident response, SRE |
| 08 | `08-maintenance` | Support, iteration, deprecation |

These stage names map to — but are not identical to — ISO/IEC/IEEE 12207's process groups (Agreement, Organizational Project-Enabling, Technical Management, Technical), because the standard's groups cut across the stages above rather than mirroring them [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24). [SYNTHESIS] The research-folder layout is a pragmatic reading-order for a product engineer, not a claim that these are the "official" stages.

---

## 4. Why this research exists

Per `VISION.md`, the goal is to document the industry-grade product development life cycle from ideation to production to maintenance, with every claim verified. Per `CLAUDE.md` §3, sources must be fetched and read before being cited. This overview exists so that downstream stage documents can assume the reader has a grounded definition of PDLC vs SDLC, a mental map of lifecycle models, and an awareness of the standards and empirical research that anchor later prescriptive claims.

---

## Sources (this document)

- [Scrum Guide 2020 — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)
- [Agile Manifesto — 2001](https://agilemanifesto.org/) (accessed 2026-04-24)
- [Principles behind the Agile Manifesto](https://agilemanifesto.org/principles.html) (accessed 2026-04-24)
- [IEEE SA — ISO/IEC/IEEE 12207 (2017)](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24)
- [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24)
- [ContinuousDelivery — Fowler](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24)
- [The Lean Startup — Ries, principles page](https://theleanstartup.com/principles) (accessed 2026-04-24)
- [DORA Four Keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)
- [AIPMM ProdBOK Guide landing page](https://aipmm.com/prodbok) (accessed 2026-04-24)

## Open questions

- **"PDLC" as a standalone term — verified status.** The verification pass (2026-04-24) confirmed: no ISO/IEC/IEEE standard defines "Product Development Life Cycle" for software; the closest bodies-of-knowledge treatments are (a) AIPMM's **ProdBOK® Guide** ([aipmm.com/prodbok](https://aipmm.com/prodbok) (accessed 2026-04-24)), which uses "product management lifecycle" rather than "PDLC" specifically and covers goods and services broadly, and (b) the PMI **PMBOK Guide**, which is project-oriented rather than product-oriented. The acronym "PDLC" is used across vendor, consulting, and education material (Charter Global, GeeksforGeeks, Ministry of Testing, HCLTech, AKF Partners, Carbon Design System, among others surfaced in 2026-04-24 search) but has no single canonical standard behind it. **Conclusion:** PDLC is *not* a standardized term; it is an industry convention that broadens SDLC with product-management concerns. This research treats PDLC as such — a framing device whose component claims resolve to SDLC (ISO/IEC/IEEE 12207) plus product-management sources (ProdBOK, Scrum Guide, Lean Startup, DORA) where those apply.
- ISO pages returned HTTP 403 for direct fetches; primary standard text was accessed through IEEE Standards Association and Wikipedia. A full reading of the standard requires a licensed copy.
