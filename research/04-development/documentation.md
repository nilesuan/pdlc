# Documentation and Developer Experience

**Question:** How should software projects approach code comments, API documentation, architecture documentation, and developer environments, and what primary sources define the practices (Diátaxis, OpenAPI, dev containers)?

**Status:** Draft

**Last updated:** 2026-04-24

## 1. The Diátaxis framework

Diátaxis is a documentation framework authored by **Daniele Procida** (copyright notice on diataxis.fr explicitly lists him), published at [diataxis.fr](https://diataxis.fr/). [VERIFIED] ([Diátaxis — Daniele Procida](https://diataxis.fr/) (accessed 2026-04-24)).

> **Source-availability note.** Initial `WebFetch` on diataxis.fr returned HTTP 403, but `curl` with a standard User-Agent fetched the canonical site successfully on 2026-04-24. All quotes below are taken directly from the canonical site pages.

The framework's overall definition, verbatim ([Diátaxis home page](https://diataxis.fr/) (accessed 2026-04-24)):

> "Diátaxis is a way of thinking about and doing documentation. It prescribes approaches to content, architecture and form that emerge from a systematic approach to understanding the needs of documentation users. Diátaxis identifies four distinct needs, and four corresponding forms of documentation — tutorials, how-to guides, technical reference and explanation. It places them in a systematic relationship, and proposes that documentation should itself be organised around the structures of those needs."

The name itself: "Diátaxis, from the Ancient Greek δῐᾰ́τᾰξῐς: dia ('across') and taxis ('arrangement')" (same source).

The four types, verbatim from the per-type pages fetched 2026-04-24:

1. **Tutorials** — "A tutorial is an experience that takes place under the guidance of a tutor. A tutorial is always learning-oriented. A tutorial is a practical activity, in which the student learns by doing something meaningful, towards some achievable goal." ([Tutorials — Diátaxis](https://diataxis.fr/tutorials/) (accessed 2026-04-24)).

2. **How-to Guides** — "How-to guides are directions that guide the reader through a problem or towards a result. How-to guides are goal-oriented. A how-to guide helps the user get something done, correctly and safely; it guides the user's action." ([How-to guides — Diátaxis](https://diataxis.fr/how-to-guides/) (accessed 2026-04-24)).

3. **Reference** — "Reference guides are technical descriptions of the machinery and how to operate it. Reference material is information-oriented… The only purpose of a reference guide is to describe, as succinctly as possible, and in an orderly way." ([Reference — Diátaxis](https://diataxis.fr/reference/) (accessed 2026-04-24)).

4. **Explanation** — "Explanation is a discursive treatment of a subject, that permits reflection. Explanation is understanding-oriented. Explanation deepens and broadens the reader's understanding of a subject." ([Explanation — Diátaxis](https://diataxis.fr/explanation/) (accessed 2026-04-24)).

The four types are intended to be treated as separate modes of writing; the framework's value is in preventing one document from trying to be all four at once.

## 2. Code comments — contested

Views on code comments diverge across sources. This document does not pick a winner.

### Fowler — code as primary documentation

Martin Fowler argues code should be the primary documentation of a software system [VERIFIED]. Key claims on [CodeAsDocumentation — Fowler](https://martinfowler.com/bliki/CodeAsDocumentation.html) (accessed 2026-04-24):

- Code is "the only one that is sufficiently detailed and precise to act in that role."
- "Most code bases aren't very good documentation" — reflecting effort, not inherent limits.
- Declaring code as documentation "creates a responsibility: developers must actively work to make code readable."
- Practical path to clarity: peer review on readability, learning from style guides, aligning with team standards.

The article does **not** discuss code comments specifically. Fowler's view here is about code-level clarity, not a claim that comments are bad.

### Google — comments as a review dimension

Google's code-review guide lists "Comments" as one of the eight dimensions reviewers evaluate, alongside design, functionality, complexity, testing, naming, style, and documentation updates [VERIFIED]. [Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) (accessed 2026-04-24).

Google's comment-writing guidance is about *review comments* (tone, severity labels, etc.), not *code comments*, so there is no conflict between the two sections — they address different things.

### Summary [SYNTHESIS]

On the fetched sources, there is no direct primary-source disagreement this session. A fuller [CONTESTED] treatment would require fetching specific positions (e.g. Martin's *Clean Code* book's chapter on comments versus more permissive views); that was not done here.

## 3. API documentation — OpenAPI

The **OpenAPI Specification (OAS)**, formerly known as Swagger, is maintained at [swagger.io/specification/](https://swagger.io/specification/) [VERIFIED]. The spec "defines a standard, language-agnostic interface to HTTP APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection." [OpenAPI Specification — Swagger](https://swagger.io/specification/) (accessed 2026-04-24).

Purposes listed on the fetched page:

- **Documentation and discovery** — humans and tools can understand an API without source or traffic inspection.
- **Code generation** — "code generation tools to generate servers and clients in various programming languages, testing tools, and many other use cases."
- **Standardization** — a language-agnostic format so different tools and teams can work consistently.
- **Integration** — API testing, mocking, monitoring, governance.

## 4. Architecture documentation and runbooks

The task brief also asks about architecture docs and runbooks. No primary-source URLs for these were successfully fetched in this session (e.g., ADR template docs, SRE-book runbook chapters). Rather than assert practices from memory, this section is deferred.

What *can* be said from what was fetched [VERIFIED]:

- DORA lists **"documentation quality"** as one of its core capabilities. [DORA capabilities](https://dora.dev/capabilities/) (accessed 2026-04-24).
- DORA lists **"monitoring and observability"** as a core capability (relevant to runbook culture). Same source.

Specific content from DORA's "documentation quality" capability page was not fetched this session — [UNVERIFIED] for the exact findings. Follow-up: fetch `dora.dev/capabilities/documentation-quality/`.

## 5. Developer experience — dev containers

The **Development Containers Specification** is an open standard at [containers.dev](https://containers.dev/) [VERIFIED]. Dev containers "allow you to use a container as a full-featured development environment" for coding, separating tools and libraries, and supporting CI and testing. The spec adds development-specific settings and configuration to containers, providing core metadata along with reusable components called **Features** and **Templates**, enabling shared container setup across tech stacks. Maintained by Microsoft (copyright notice visible on the fetched page). [Development Containers Specification — containers.dev](https://containers.dev/) (accessed 2026-04-24).

### Why dev containers matter for PDLC [SYNTHESIS from what was fetched]

- New-contributor onboarding: a `.devcontainer.json` lets a contributor open a repo in a container with tools, language versions, and extensions pre-configured rather than running a README's setup list.
- Parity with CI: the same container can be used locally and in CI, reducing "works on my machine" drift.

This is synthesis based on the specification's stated purpose above; it is not a numerical claim about time savings or defect reduction.

## 6. Other tooling — deferred

The task brief mentions IDEs and "local dev environment philosophy." No IDE-specific primary source (JetBrains, VS Code docs, the "Teach, Don't Tell" philosophy by any named author) was fetched this session. These are deferred to a later pass to avoid training-data paraphrase.

## Sources

- [Diátaxis — Daniele Procida](https://diataxis.fr/) (accessed 2026-04-24)
- [Tutorials — Diátaxis](https://diataxis.fr/tutorials/) (accessed 2026-04-24)
- [How-to guides — Diátaxis](https://diataxis.fr/how-to-guides/) (accessed 2026-04-24)
- [Reference — Diátaxis](https://diataxis.fr/reference/) (accessed 2026-04-24)
- [Explanation — Diátaxis](https://diataxis.fr/explanation/) (accessed 2026-04-24)
- [Diataxis documentation framework — evildmp GitHub mirror](https://github.com/evildmp/diataxis-documentation-framework) (accessed 2026-04-24)
- [CodeAsDocumentation — Martin Fowler](https://martinfowler.com/bliki/CodeAsDocumentation.html) (accessed 2026-04-24)
- [Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) (accessed 2026-04-24)
- [OpenAPI Specification — Swagger](https://swagger.io/specification/) (accessed 2026-04-24)
- [DORA capabilities catalog](https://dora.dev/capabilities/) (accessed 2026-04-24)
- [Development Containers Specification — containers.dev](https://containers.dev/) (accessed 2026-04-24)

## Open questions

- [RESOLVED 2026-04-24] Direct fetches of `diataxis.fr` pages — succeeded via curl; verbatim per-type definitions now inline above.
- `dora.dev/capabilities/documentation-quality/` and `dora.dev/capabilities/monitoring-and-observability/` were not fetched — their specific content is unknown here.
- Architecture Decision Records (ADRs, Michael Nygard's 2011 format) — no primary-source URL fetched; deferred.
- SRE-book-style runbook guidance (Google SRE Book, chapter on playbooks) — no primary-source URL fetched; deferred to stage 07 (Operations).
- OpenAPI governance history (SmartBear donation to the Linux Foundation in 2015 renaming Swagger to OpenAPI) was not verified in this session.
