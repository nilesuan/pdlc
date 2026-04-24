# Design Documents and RFCs

**Question:** How do engineering organisations that publish their processes (Google, Oxide Computer) formalise design documents and "Request for Comments/Discussion" workflows during the design stage?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Design docs at Google

Malte Ubl's "Design Docs at Google" (2020) describes design documents as "informal documents created by the software engineer or engineers about to embark on a coding project" for the purpose of laying out high-level implementation strategy and key design decisions before implementation.

Stated functions of the design doc, per Ubl:

- "Early identification of design issues when making changes is still cheap."
- Achieving organisational consensus around the design.
- Ensuring cross-cutting concerns (security, privacy, observability) are considered.
- Scaling senior engineers' knowledge throughout the organisation.
- Creating organisational memory about design decisions.
- Serving as a summary artefact in an engineer's technical portfolio.

Underlying philosophy: "As software engineers our job is not to produce code per se, but rather to solve problems." Design docs enable problem-solving through unstructured prose that can be more concise than code.

Typical structure (per the article): context and scope, goals and non-goals, design details with trade-offs, alternatives considered, and cross-cutting concerns. Ubl notes that design docs typically run 10–20 pages for larger projects, with "mini design docs" for incremental work.

[Design Docs at Google — Malte Ubl, industrialempathy.com, 2020-07-06](https://www.industrialempathy.com/posts/design-docs-at-google/) (accessed 2026-04-24).

---

## 2. Requests for Discussion (RFDs) at Oxide Computer

Jessie Frazelle's "RFD 1: Requests for Discussion" (2020) outlines Oxide Computer's decision-making workflow, modelled on IETF's Request for Comments (RFC) tradition, with an explicit bias toward publishing rough thinking.

Key points, per Frazelle:

- **Timeliness over polish.** Ideas should be "timely rather than polished." The article accepts that "philosophical positions without examples or other specifics, specific suggestions or implementation techniques without introductory or background explication, and explicit questions without any attempted answers are all acceptable."
- **Scope.** RFDs apply broadly: "RFDs not only apply to technical ideas but overall company ideas and processes as well," covering architecture, API changes, internal processes, testing designs, and company-wide improvements.
- **Six-state workflow.** prediscussion → ideation → discussion → published → committed → abandoned.
- **Tooling.** Short URLs (e.g., `12.rfd.oxide.computer`), a CSV index, chat-bot integration, and a shared rendering site for external stakeholder feedback.

[RFD 1: Requests for Discussion — Jessie Frazelle, oxide.computer, 2020-07-24](https://www.oxide.computer/blog/rfd-1-requests-for-discussion) (accessed 2026-04-24).

---

## 3. How ADRs, design docs, and RFCs/RFDs relate

[SYNTHESIS — combining the three fetched primary sources.]

| Artefact | Granularity | Author | Lifecycle | Primary source |
|---|---|---|---|---|
| **Design doc** (Google) | A single project/change, 10–20 pages | Engineer(s) about to build | Written pre-implementation; reviewed; archived | [Ubl 2020](https://www.industrialempathy.com/posts/design-docs-at-google/) |
| **RFD** (Oxide) | Any technical or process idea | Anyone | Six-state workflow; can be company-wide | [Frazelle 2020](https://www.oxide.computer/blog/rfd-1-requests-for-discussion) |
| **ADR** (Nygard) | One architecturally significant decision, 1–2 pages | The team making the decision | Proposed → accepted → (later) deprecated or superseded | [Nygard 2011](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) |

The three overlap but are not identical:

- A design doc or RFD can contain multiple decisions; an ADR records exactly one.
- ADRs are typically stored in-repo next to code; design docs and RFDs often live in separate systems but can be mirrored.
- Google's design doc is oriented to a build about to happen; Oxide's RFD is oriented to any discussion — technical or organisational — before it crystallises.

---

## 4. Role in the PDLC design stage

[SYNTHESIS — combining sources.]

- **During discovery / planning (Stages 01–02):** lightweight RFDs or design-doc drafts can surface alternatives and make cross-cutting concerns (privacy, security, operability) legible before commitment.
- **During design (Stage 03):** a full design doc is the main written artefact, backed by ADRs for decisions that meet Nygard's significance bar.
- **Into development (Stage 04):** ADRs travel with the code; design docs tend to be frozen once accepted.

Neither Ubl nor Frazelle explicitly use the term "PDLC stage," but both articles describe the artefact as preceding and informing coding, consistent with this stage placement.

---

## Open questions

- **Google Eng-Practices documentation.** Google also publishes `google.github.io/eng-practices/` (code review guidance); a follow-up pass could fetch the explicit design-review material if it exists.
- **Microsoft / Meta / Netflix design-doc processes.** Not fetched in this session. Known candidates: Netflix Tech Blog, Meta Engineering blog, Microsoft engineering playbook.
- **Rust / Kubernetes RFC processes.** Both publish public RFC repositories (`rust-lang/rfcs`, `kubernetes/enhancements`). Not fetched in this session; would be strong primary sources for open-source RFC practice.
- **Template examples.** Neither fetched primary source provided a full public template; only structural description.

---

## Sources

- [Design Docs at Google — Malte Ubl, industrialempathy.com, 2020-07-06](https://www.industrialempathy.com/posts/design-docs-at-google/) (accessed 2026-04-24)
- [RFD 1: Requests for Discussion — Jessie Frazelle, oxide.computer, 2020-07-24](https://www.oxide.computer/blog/rfd-1-requests-for-discussion) (accessed 2026-04-24)
- [Documenting Architecture Decisions — Michael Nygard, cognitect.com, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24) — cross-referenced for ADR lifecycle
