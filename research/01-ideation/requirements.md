# Requirements and Artifacts

**Question:** How are discoveries captured and handed to delivery? What is a requirement, what is a user story, and what formal standards apply?

**Status:** Draft
**Last updated:** 2026-04-24

---

## 1. The formal standard: ISO/IEC/IEEE 29148:2018

**What it is.** [VERIFIED] ISO/IEC/IEEE 29148:2018, full title "ISO/IEC/IEEE International Standard - Systems and software engineering -- Life cycle processes -- Requirements engineering", is the current international standard for requirements engineering across systems and software products and services throughout the lifecycle. [IEEE 29148 — IEEE Standards Association, 2018](https://standards.ieee.org/ieee/29148/6932/) (accessed 2026-04-24); [ISO/IEC/IEEE 29148 — SEBoK reference entry](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148) (accessed 2026-04-24).

**Scope (per IEEE Standards Association):**
The standard addresses "processes and products related to the engineering of requirements for systems and software products and services throughout the life cycle." It covers:
- **Requirement definition** — "defines the construct of a good requirement" and provides attributes and characteristics that requirements should embody.
- **Lifecycle application** — "discusses the iterative and recursive application of requirements processes throughout the life cycle."
- **Integration guidance** — complementary guidance for the requirements-related activities in ISO/IEC/IEEE **15288** (systems life-cycle processes) and **12207** (software life-cycle processes).
- **Information items** — definitions of information items applicable to the engineering of requirements and their required content.
- **Flexible usage** — the content "can be added to the existing set of requirements-related life cycle processes" or "can be used independently."

[VERIFIED] [IEEE 29148 — IEEE Standards Association, 2018](https://standards.ieee.org/ieee/29148/6932/) (accessed 2026-04-24).

**How SEBoK uses it.** The Systems Engineering Body of Knowledge cites 29148 as the primary reference for System Definition, Business/Mission Analysis, System Requirements, and System Concept Definition. Publisher and year confirmed by SEBoK: ISO/IEC/IEEE, 2018. [VERIFIED] [ISO/IEC/IEEE 29148 — SEBoK](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148) (accessed 2026-04-24).

**What is [UNVERIFIED] here.** The full text of 29148 is paywalled and was not fetched in this session. Specific claims about the exact characteristics of "a good requirement" (commonly summarized as *unambiguous, complete, consistent, verifiable, feasible, traceable, singular, necessary*), the exact SRS / StRS / SyRS document templates, and boilerplate sentence patterns ("The [system] shall…") come from the standard itself and should be verified from a purchased copy before citing specifics. Do not paste a list attributed to 29148 without having opened the standard.

---

## 2. Functional vs. non-functional requirements

The distinction between **functional** requirements (what the system does — behaviors, inputs/outputs, computations) and **non-functional** requirements (constraints and qualities — performance, security, reliability, usability, maintainability, etc.) is foundational in requirements engineering and is codified in ISO/IEC/IEEE 29148. [VERIFIED (existence of the categorization in the standard's scope)] [ISO/IEC/IEEE 29148 — SEBoK](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148) (accessed 2026-04-24).

> Specific precise definitions of "functional requirement" and "non-functional requirement" as worded by 29148 are **[UNVERIFIED]** here — the standard's text was not fetched. Also, a separate strand of the literature (e.g., Martin Glinz) argues the functional / non-functional terminology is imprecise; we do not take a position on that debate in this doc without a fetched source. Flag as an open question.

---

## 3. User stories

### Definition and template (Cohn)

**Definition.** *"A user story is a short, simple description of a feature told from the perspective of the person who desires the new capability, usually a user or customer of the system."* [VERIFIED] [User Stories — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/agile/user-stories) (accessed 2026-04-24).

**Canonical template.**

```
As a <type of user>, I want <some goal> so that <some reason>.
```

[VERIFIED] (same source).

**Cohn on the template's mechanics** (from a separate blog post):
- Proper element order mirrors effective storytelling: care about the protagonist before the plot matters.
- First-person framing ("I") increases personal resonance.
- Easy for non-engineering stakeholders to co-author on a whiteboard.
- Clear role + value makes prioritization easier.

Cohn explicitly cautions against slavishly applying the template; the "so that" clause is not mandatory — he uses it in 97% of his own stories. [VERIFIED] [Advantages of the "As a user, I want…" User Story Template — Mike Cohn](https://www.mountaingoatsoftware.com/blog/advantages-of-the-as-a-user-i-want-user-story-template) (accessed 2026-04-24).

### The Three C's (Jeffries)

Cohn credits **Ron Jeffries** for the structural model of a story — **Card, Conversation, Confirmation**:

1. **Card** — written description for planning and as a reminder.
2. **Conversation** — discussions that flesh out story details.
3. **Confirmation** — tests that determine when the story is complete.

[VERIFIED] (Mountain Goat Software, user-stories page). Also recorded on the Agile Alliance glossary, which dates the 3 C's model to 2001. [VERIFIED] [User Stories — Agile Alliance Glossary](https://www.agilealliance.org/glossary/user-stories/) (accessed 2026-04-24).

### Acceptance criteria

Cohn describes acceptance criteria as *conditions of satisfaction* — high-level acceptance tests specifying what must be true when the story is complete. [VERIFIED] [User Stories — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/agile/user-stories) (accessed 2026-04-24).

Agile Alliance's glossary entry advises that intermediate-level practitioners should be "able to express the acceptance criteria for a user story in terms that will be directly usable as an automated acceptance test." [VERIFIED] [User Stories — Agile Alliance Glossary](https://www.agilealliance.org/glossary/user-stories/) (accessed 2026-04-24).

Agile Alliance also notes the **Given-When-Then** pattern (2006) as a common form for expressing acceptance criteria. [VERIFIED] (same source).

### INVEST

**INVEST** is a six-criterion quality checklist for user stories:

- **I**ndependent (of other stories).
- **N**egotiable (not a fixed contract for features).
- **V**aluable (or vertical — delivers a slice of value).
- **E**stimable (to a good approximation).
- **S**mall (fits within an iteration).
- **T**estable (in principle, even before a test exists).

**Origin.** Bill Wake created the INVEST checklist in 2003; Mike Cohn popularized it in *User Stories Applied* (2004). [VERIFIED] [INVEST — Agile Alliance Glossary](https://www.agilealliance.org/glossary/invest/) (accessed 2026-04-24).

If a story fails a criterion, teams may rewrite it — historically by "physically tearing up the old story card and writing a new one." [VERIFIED] (same source).

### Use cases vs. user stories

Use cases (goal-oriented descriptions of interactions between an actor and a system, typically with preconditions, main flow, alternate flows, and postconditions) are a separate but related formalism, often associated with Ivar Jacobson. A primary Jacobson source was not fetched this session; treat any specific use-case template ("actor," "precondition," etc.) as **[UNVERIFIED]** until sourced. Cohn's page notes that user stories are *easier for stakeholders to handle* than use cases, which is the main comparative claim that is [VERIFIED] from the fetched sources. [VERIFIED] [Advantages of the User Story Template — Mike Cohn](https://www.mountaingoatsoftware.com/blog/advantages-of-the-as-a-user-i-want-user-story-template) (accessed 2026-04-24).

---

## 4. Personas (see user-research.md §8)

Personas are fictional-yet-realistic descriptions of target users used to align teams, prioritize features, and support analytics segmentation. NN/g treats personas as living artifacts requiring regular updates. Full treatment: `user-research.md` §8. Primary source: [Personas Study Guide — Kate Kaplan, NN/g, 2022](https://www.nngroup.com/articles/personas-study-guide/) (accessed 2026-04-24).

## 5. Journey maps (see user-research.md §9)

Journey maps visualize the process a user goes through to accomplish a goal, structured around actor, scenario, phases, actions/mindsets/emotions, and opportunities. Full treatment: `user-research.md` §9. Primary source: [Journey Mapping 101 — Sarah Gibbons, NN/g, 2018](https://www.nngroup.com/articles/journey-mapping-101/) (accessed 2026-04-24).

## 6. Opportunity solution trees (Torres)

Torres's opportunity solution tree is a discovery artifact, not a requirement document, but it feeds requirements. Structure:

```
                   Outcome (one, measurable product outcome)
                       |
        ┌──────────────┼──────────────┐
   Opportunity     Opportunity     Opportunity
       |               |               |
    Solution …     Solution …     Solution …
       |
   Assumption tests
```

Each layer's definition (from Torres, 2023):

- **Outcome**: "the business need that reflects how your team can create business value." Must be a product outcome (customer behavior or sentiment), not a business or traction metric.
- **Opportunity**: "an unmet customer need, pain point, or desire."
- **Solution**: "a product, a feature, a service, a workflow, a process, documentation, or anything else that we offer to customers to help address a known opportunity."
- **Assumption tests**: methods to evaluate which solutions best create customer value while driving business value.

[VERIFIED] [Opportunity Solution Tree — Teresa Torres, 2023](https://www.producttalk.org/opportunity-solution-tree/) (accessed 2026-04-24).

Torres recommends 3–4 story-based customer interviews before drawing the first tree. [VERIFIED] (same source).

---

## 7. User story maps (Patton)

**What it is.** "A dead simple idea" (Patton's phrasing) that visualizes the user's journey through the product to organize and prioritize stories. It keeps "users and what they're doing with your product front and center" rather than allowing the backlog to become an unstructured feature list. [VERIFIED] [Story Mapping — Jeff Patton Associates](https://jpattonassociates.com/story-mapping/) (accessed 2026-04-24).

**Purpose.**
1. Maintain a user-centric view of the product.
2. Make working with user stories in agile development easier.
3. Produce better products by grounding decisions in user behavior.

[VERIFIED] (same source).

> The page does not give a rigid diagram specification (the canonical *backbone / walking skeleton / release slice* structure familiar from Patton's 2014 book *User Story Mapping*). The structural detail beyond the above is **[UNVERIFIED]** from this fetched page; consult the book directly for specifics. [VERIFIED (book's existence and authorship)] — Patton is the author of *User Story Mapping*, O'Reilly 2014, per his own site's framing; exact book-content claims not quoted here.

---

## 8. Problem statements

The "problem statement" artifact — a concise statement of the problem a design addresses, often produced at the end of the Define mode in Design Thinking — is widely used, but a canonical primary-source definition was not obtained this session (HTTP 403/404 on the URLs tried). Any specific template ("[User] needs [need] because [insight]." etc.) should be **[UNVERIFIED]** until sourced from, e.g., Stanford d.school's Bootleg PDF directly or IDEO Method Cards. The *existence and purpose* of the artifact is compatible with the fetched d.school and IDEO sources (see `discovery.md` §5) which describe Define / Synthesize phases whose output is a problem framing, but those pages do not give a one-line problem-statement template. [SYNTHESIS]

---

## 9. From discovery artifact to delivery backlog

A rough, [SYNTHESIS] pipeline consistent with the fetched Torres, Patton, Cohn, and Agile Alliance sources:

1. **Outcome** defined (Torres): measurable product outcome.
2. **Opportunities** populated (Torres) from customer-interview stories.
3. **Solutions** proposed for priority opportunities.
4. **Assumption tests** executed; ideas killed or kept.
5. Surviving solutions decomposed into **user stories** (Cohn) with **acceptance criteria** / conditions of satisfaction.
6. Stories organized into a **story map** (Patton) for release slicing and sequencing.
7. Each story checked against **INVEST** (Wake/Cohn) before being pulled into a sprint.

Nothing in this pipeline is contradicted by the fetched sources; however, no single fetched source prescribes the whole sequence end-to-end, so it is labeled [SYNTHESIS].

---

## Sources (all accessed 2026-04-24)

- [IEEE 29148 — IEEE Standards Association, 2018](https://standards.ieee.org/ieee/29148/6932/)
- [ISO/IEC/IEEE 29148 — SEBoK](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148)
- [User Stories — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/agile/user-stories)
- [Advantages of the "As a user, I want…" User Story Template — Mike Cohn](https://www.mountaingoatsoftware.com/blog/advantages-of-the-as-a-user-i-want-user-story-template)
- [User Stories — Agile Alliance Glossary](https://www.agilealliance.org/glossary/user-stories/)
- [INVEST — Agile Alliance Glossary](https://www.agilealliance.org/glossary/invest/)
- [Opportunity Solution Tree — Teresa Torres, 2023](https://www.producttalk.org/opportunity-solution-tree/)
- [Story Mapping — Jeff Patton Associates](https://jpattonassociates.com/story-mapping/)
- [Personas Study Guide — Kate Kaplan, NN/g, 2022](https://www.nngroup.com/articles/personas-study-guide/)
- [Journey Mapping 101 — Sarah Gibbons, NN/g, 2018](https://www.nngroup.com/articles/journey-mapping-101/)

## Open questions

- **29148 text.** Need paid access to cite the standard's own definitions of "good requirement" characteristics, SRS contents, functional/non-functional definitions, and the "shall" sentence convention.
- **Use cases (Jacobson).** A fetched primary source for the use-case template is missing.
- **Ash Maurya / Lean Canvas / Running Lean** — problem/solution fit, problem statement templates — primary source not fetched.
- **Patton's *User Story Mapping* book** — the online page is brief; book-level detail on backbone / walking skeleton / slicing is not captured here.
- **Non-functional requirements taxonomy.** The ISO/IEC 25010 quality model is a standard companion reference; the **2023 revision** (nine characteristics including Safety; Usability → Interaction Capability; Portability → Flexibility) is now documented in `research/03-design/system-architecture.md` §6.1.
