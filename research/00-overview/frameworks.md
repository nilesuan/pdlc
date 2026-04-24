# 00 — Scaling Frameworks and Formal Standards

**Question:** What scaled-agile frameworks and formal lifecycle standards are referenced in industry PDLC practice, and what do their primary sources actually say?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Scaling frameworks

### 1.1 SAFe (Scaled Agile Framework)

SAFe is created and maintained by Scaled Agile, Inc. The framework's official site describes SAFe as a methodology for implementing lean and agile practices at scale across organizations [Scaled Agile Framework — framework.scaledagile.com](https://framework.scaledagile.com/) (accessed 2026-04-24; the `scaledagileframework.com` URL redirects to this canonical host).

The framework organizes around six disciplines: Lean Portfolio Management, Team and Technical Agility, Product Development Flow, Large Solution Integration and Delivery, Leadership and Culture, and the Big Picture (overarching visualization) [framework.scaledagile.com](https://framework.scaledagile.com/) (accessed 2026-04-24).

The current major version at time of access is SAFe 6.0 [framework.scaledagile.com](https://framework.scaledagile.com/) (accessed 2026-04-24).

[UNVERIFIED] SAFe's detailed role list (Release Train Engineer, Product Owner, Product Manager, Solution Architect, etc.) and cadence concepts (PI Planning, ARTs, value streams) were not fetched in this session; downstream stage documents that need those specifics should fetch the SAFe site's specific articles.

### 1.2 LeSS (Large-Scale Scrum)

LeSS is maintained by The LeSS Company B.V., whose site frames it as "not about scaling a framework — it's about redesigning your organization to build better products, faster, and with fewer obstacles" [less.works](https://less.works/) (accessed 2026-04-24).

Four framework emphases per the site:

1. Simplifying structure — eliminating silos; cross-functional teams on a unified Product Backlog.
2. Amplifying learning — transparency and rapid feedback loops.
3. Technical excellence — CI, test automation, a clear Definition of Done.
4. Enabling resilience — simplicity, team ownership, continuous improvement.

[less.works](https://less.works/) (accessed 2026-04-24).

[UNVERIFIED] The site description is summary-level. The book *Large-Scale Scrum: More with LeSS* by Craig Larman and Bas Vodde and the LeSS framework rules page were not fetched in this session.

### 1.3 Disciplined Agile (DA) / Disciplined Agile Delivery (DAD)

DAD was introduced in 2012 through the book *Disciplined Agile Delivery: A Practitioner's Guide to Agile Software Delivery in the Enterprise* by Scott Ambler and Mark Lines [WebSearch summary — DAD](https://www.amazon.com/Disciplined-Agile-Delivery-Practitioners-Enterprise/dp/0132810131) (accessed 2026-04-24 via search).

In 2019, the Project Management Institute (PMI) acquired the Disciplined Agile framework [WebSearch summary — DAD](https://en.wikipedia.org/wiki/Disciplined_agile_delivery) (accessed 2026-04-24 via search). Disciplined Agile is now hosted under pmi.org/disciplined-agile [attempted fetch — pmi.org/disciplined-agile/about returned 403 in this session].

Per the search summary, DAD extends Scrum with practices drawn from XP, Agile Modeling, Unified Process, Kanban, agile data, and others, and organizes delivery into three phases (Inception, Construction, Transition) across ~21 process goals [WebSearch summary — DAD](https://en.wikipedia.org/wiki/Disciplined_agile_delivery) (accessed 2026-04-24 via search).

[UNVERIFIED at primary] The authoritative pmi.org page was not fetched successfully in this session. Claims above are sourced to the search summary and should be verified against the PMI pages before being quoted prescriptively in downstream stage documents.

---

## 2. Formal standards

### 2.1 ISO/IEC/IEEE 12207:2017 — Software life cycle processes

[VERIFIED] Official title: "ISO/IEC/IEEE International Standard - Systems and software engineering -- Software life cycle processes" [IEEE SA — ISO/IEC/IEEE 12207:2017](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24).

Scope, per IEEE SA: "The standard establishes a framework applicable to acquisition of software systems, supply, development, operation, maintenance, and disposal of software products. It covers the software portion of systems and applies whether performed internally or externally to an organization" [IEEE SA — 12207](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24).

[VERIFIED] Publication date: November 15, 2017 (board approval September 28, 2017). IEEE SA explicitly states the 2017 edition is "Superseded by 12207-2026" [IEEE SA — 12207](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24). The 2026 revision's full text was not fetched in this session; the successor status is confirmed from the IEEE SA landing page.

Process structure (2017 edition), per Wikipedia's article on the standard:

- **Agreement Processes** — acquisition and supply.
- **Organizational Project-Enabling Processes** — infrastructure, portfolio, quality, knowledge management.
- **Technical Management Processes** — planning, risk management, configuration management, quality assurance.
- **Technical Processes** — 14 processes spanning requirements definition through disposal.

Total: 30 processes (reduced from 43 in earlier editions after alignment with 15288:2015) [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24).

Version history, per Wikipedia:

- 1995 — original edition, five primary processes.
- 2002 — Amendment 1.
- 2004 — Amendment 2.
- 2008 — second edition.
- 2017 — IEEE joined as editor; aligned with ISO/IEC/IEEE 15288:2015; 30 processes.

[ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24).

Important note from Wikipedia: the standard "does not prescribe a specific software life cycle model" — processes recur across stages rather than being aligned one-to-one to phases [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24). This is the crucial bridge between the standards worldview and the stage-oriented structure of most PDLC literature.

### 2.2 ISO/IEC/IEEE 15288:2023 — System life cycle processes

[VERIFIED] Official title: "ISO/IEC/IEEE International Standard - Systems and software engineering--System life cycle processes" [IEEE SA — ISO/IEC/IEEE 15288:2023](https://standards.ieee.org/ieee/15288/10424/) (accessed 2026-04-24).

Scope, per IEEE SA: the standard "establishes a common framework of process descriptions for describing the life cycle of systems created by humans, defining a set of processes and associated terminology from an engineering viewpoint" [IEEE SA — 15288](https://standards.ieee.org/ieee/15288/10424/) (accessed 2026-04-24).

[VERIFIED] Publication date: May 16, 2023 (board approval March 30, 2023); supersedes ISO/IEC/IEEE 15288:2015 [IEEE SA — 15288](https://standards.ieee.org/ieee/15288/10424/) (accessed 2026-04-24).

History and process count, per Wikipedia: first published 2002 (editor Stuart Arnold, architect Harold Lawson); IEEE adopted as IEEE 15288 in 2004; revisions in 2008, 2015, and 2023. The standard defines 30 processes organized into four categories: Agreement (2), Organizational project-enabling (6), Technical management (8), Technical (14) [ISO/IEC 15288 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_15288) (accessed 2026-04-24).

Relationship to 12207: both are "complementary standards within the SC 7 Integrated set of Standards. While ISO/IEC 12207 focuses specifically on software lifecycle processes, ISO/IEC 15288 addresses broader systems engineering lifecycle and processes" [ISO/IEC 15288 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_15288) (accessed 2026-04-24).

### 2.3 Other IEEE standards relevant to PDLC

IEEE publishes standards for specific lifecycle concerns — requirements (e.g., IEEE 29148), architecture descriptions (e.g., IEEE/ISO/IEC 42010), and software verification/validation (e.g., IEEE 1012). [UNVERIFIED] None of these standard pages were fetched in this session; downstream stage documents should fetch specific standards when a load-bearing claim depends on them rather than citing them from memory here.

---

## Sources

- [framework.scaledagile.com — Scaled Agile Framework homepage](https://framework.scaledagile.com/) (accessed 2026-04-24)
- [less.works — Large-Scale Scrum homepage](https://less.works/) (accessed 2026-04-24)
- [IEEE SA — ISO/IEC/IEEE 12207:2017](https://standards.ieee.org/ieee/12207/5672/) (accessed 2026-04-24)
- [IEEE SA — ISO/IEC/IEEE 15288:2023](https://standards.ieee.org/ieee/15288/10424/) (accessed 2026-04-24)
- [ISO/IEC 12207 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_12207) (accessed 2026-04-24)
- [ISO/IEC 15288 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_15288) (accessed 2026-04-24)

## Open questions

- ISO.org pages returned HTTP 403 for direct WebFetch; IEEE SA landing pages for 12207:2017 and 15288:2023 were re-fetched 2026-04-24 and confirm titles/dates/supersession — the full text of all three standards (12207:2017, 15288:2023, 12207-2026) remains behind paid licensing.
- SAFe 6.0's specific structural elements (ART, PI Planning, etc.) are not verified here — SAFe-specific stage documents should fetch the relevant framework.scaledagile.com pages directly.
- The PMI Disciplined Agile hub (`pmi.org/disciplined-agile/about`) returned 403; DAD details are sourced to a search summary and need primary-source verification.
