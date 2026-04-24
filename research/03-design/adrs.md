# Architecture Decision Records (ADRs)

**Question:** What are Architecture Decision Records (ADRs), where do they come from, what structure do they follow, and what is their role in the design stage of the PDLC?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Origin

Michael Nygard introduced the ADR on the Cognitect (then Relevance) blog in November 2011 as a solution to a recurring problem: "One of the hardest things to track during the life of a project is the motivation behind certain decisions." [Documenting Architecture Decisions — Michael Nygard, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24).

Nygard's post targets decisions "that affect the structure, non-functional characteristics, dependencies, interfaces, or construction techniques" of a system — i.e., architecturally significant ones — and proposes a short, version-controlled record per decision.

---

## 2. The Nygard template

Per the 2011 article, each ADR has five sections:

1. **Title** — a short noun phrase. Example given: "ADR 1: Deployment on Ruby on Rails 3.0.10."
2. **Context** — "describes the forces at play, including technological, political, social, and project local," in value-neutral language.
3. **Decision** — "stated in full sentences, with active voice. 'We will …'"
4. **Status** — one of "proposed," "accepted," "deprecated," or "superseded." Supersede by writing a new ADR that references the old one.
5. **Consequences** — "All consequences should be listed here, not just the 'positive' ones."

Nygard also recommends:

- Store ADRs in the project repository (e.g., `doc/arch/adr-NNN.md`).
- Use lightweight formatting (Markdown or Textile).
- Keep documents "one or two pages long."
- Number sequentially without reusing numbers.

[Documenting Architecture Decisions — Michael Nygard, 2011](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24).

---

## 3. Community framing (adr.github.io)

The ADR GitHub organisation defines an Architectural Decision as "a justified design choice that addresses a functional or non-functional requirement that is architecturally significant," and an ADR as a document that "can help you understand the reasons for a chosen architectural decision, along with its trade-offs and consequences." [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24).

Stated goals of the community:

1. "Establish common vocabulary and motivate architectural decision capturing."
2. "Strengthen tooling supporting agile and iterative engineering processes."
3. "Provide resources on Architectural Knowledge Management (AKM)."

The site also references the Y-statement format ("In the context of … facing … we decided for … to achieve … accepting …") attributed to Zdun et al.'s *Sustainable Architectural Decisions*.

[Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24).

---

## 4. Adoption notes

From adr.github.io (accessed 2026-04-24):

- "The Azure Well-Architected Framework now features ADRs (as of October 2024)."
- "AWS Prescriptive Guidance recommends using ADRs for technical decision-making."
- Empirical research presentations by Michael Keeling (IBM Watson Group) and Joe Runde are referenced on the site.

[VERIFIED as present on adr.github.io; accuracy of the downstream pages (Azure WAF, AWS Prescriptive Guidance) is not independently confirmed here.]

---

## 5. How ADRs fit into the PDLC

[SYNTHESIS — combining sources in scope.] Based on Nygard's 2011 post and the adr.github.io goals:

- **When:** Create an ADR whenever a decision meets Nygard's bar — it affects structure, non-functional characteristics, dependencies, interfaces, or construction techniques. This can happen at any stage of the PDLC, not only during a dedicated "design" phase.
- **Who:** The article does not prescribe a single author/owner; the document is co-located with code so the team owning the area owns the ADR.
- **Status lifecycle:** proposed → accepted → (later) deprecated or superseded by a new ADR.
- **Storage:** alongside code (Nygard), to keep the record close to what it describes and under the same review tooling.

[UNVERIFIED] — The sources I fetched do not give an adoption-rate figure or industry survey on ADR usage, so claims of scale ("most teams use ADRs") would need a survey citation before they could be made.

---

## 6. A minimal example scaffold

The following is a restatement of Nygard's template, not a quote:

```markdown
# ADR NNN: <short noun phrase>

## Status
proposed | accepted | deprecated | superseded by ADR-MMM

## Context
What forces are at play? (technological, political, social, project-local)

## Decision
We will …

## Consequences
- Positive: …
- Negative: …
- Neutral / follow-ups: …
```

Structure drawn from [Documenting Architecture Decisions — Michael Nygard, 2011](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24).

---

## Open questions

- **Concrete public ADR examples.** adr.github.io references examples and tools; I did not fetch any repository's public ADR set in this session, so specific exemplars (e.g., a named open-source project's ADR folder) cannot be cited here.
- **MADR template.** The MADR (Markdown Architectural Decision Records) template is widely referenced; its home page was not fetched in this session.
- **PR/review workflow.** How ADRs are typically reviewed (standalone PR vs part of a feature PR) is not covered in the sources I fetched.

---

## Sources

- [Documenting Architecture Decisions — Michael Nygard, cognitect.com, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24)
- [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24)
