# Stage 01 — Ideation & Discovery

**Question:** What does the "front end" of the software product development lifecycle look like — from a vague idea to a validated problem, target users, and a set of requirements ready for planning? What are the canonical frameworks, methods, and artifacts, and who defined them?

**Status:** Draft
**Last updated:** 2026-04-24

---

## 1. Scope and framing

This document covers the *pre-delivery* stage of the PDLC: activities that happen before (and alongside) building software, whose purpose is to decide what is worth building and for whom. The topics split into three clusters:

1. **Discovery frameworks** — how teams structure the work of figuring out what to build (Cagan/SVPG, Torres's continuous discovery, Lean Startup, Design Thinking, JTBD).
2. **User research methods** — how teams gather evidence from users (interviews, usability testing, field studies, surveys, diary studies).
3. **Requirements and artifacts** — how teams capture what they learn and communicate it to delivery (user stories, personas, journey maps, opportunity solution trees, problem statements, formal requirements per ISO/IEC/IEEE 29148).

Supporting documents in this folder go deeper on each:

- `discovery.md` — Cagan, Torres, Lean Startup, Design Thinking, JTBD in depth.
- `user-research.md` — user research methods (NNG-sourced).
- `requirements.md` — requirements engineering, user stories, artifacts.

---

## 2. What "product discovery" means

### Teresa Torres: discovery vs. delivery

Teresa Torres defines the split explicitly: *"Product discovery is used to describe the work that we do to make decisions about what to build, while product delivery is the work we do to build, ship, and maintain a production quality product."* [VERIFIED] [Product Discovery — Teresa Torres, 2021](https://www.producttalk.org/2021/08/product-discovery/) (accessed 2026-04-24).

Torres frames modern discovery as *continuous* rather than project-bounded. Her prescription centers on two weekly habits: **customer interviewing** (gathering stories that reveal needs, pain points, and desires — which she calls "opportunities") and **assumption testing** across five risk categories: desirable, viable, feasible, usable, and ethical. The unit of output is an **outcome → opportunities → solutions** structure, typically visualized as an opportunity solution tree. [VERIFIED] [Continuous Discovery — Teresa Torres, 2021](https://www.producttalk.org/continuous-discovery/) (accessed 2026-04-24).

### Marty Cagan / SVPG

The SVPG primary sources were not fetchable in this session (svpg.com returned HTTP 403 to WebFetch). Claims about Cagan's "four risks" framing (value, usability, feasibility, business viability) and his distinction between discovery and delivery are therefore **[UNVERIFIED]** here and must be confirmed against a fetched source (SVPG, *Inspired*, or *Empowered*) before relying on them. Torres's framing above covers the same conceptual territory and is cited directly.

### Why discovery matters (as stated by the cited authors)

- Torres argues that without weekly customer contact, teams drift into the *curse of knowledge* — experts lose sight of the customer's perspective, and decisions become disconnected from real user experience. [VERIFIED] [Product Discovery — Teresa Torres, 2021](https://www.producttalk.org/2021/08/product-discovery/) (accessed 2026-04-24).
- Eric Ries frames the purpose of a startup as "to learn how to build a sustainable business," and introduces *validated learning* as "a rigorous method for demonstrating progress when one is embedded in the soil of extreme uncertainty." [VERIFIED] [Principles — The Lean Startup, Eric Ries](https://theleanstartup.com/principles) (accessed 2026-04-24).
- Marc Andreessen's *Rachleff's Corollary* — "The only thing that matters is getting to product/market fit" — makes the case that everything a pre-PMF startup does should be in service of finding that fit. [VERIFIED] [The Only Thing That Matters — Marc Andreessen, 2007](https://pmarchive.com/guide_to_startups_part4.html) (accessed 2026-04-24).

---

## 3. Problem–solution fit and product–market fit

### Andreessen on PMF

Marc Andreessen defines **product/market fit** as "being in a good market with a product that can satisfy that market." He describes PMF as something founders *can feel*: when present, "the customers are buying the product just as fast as you can make it" and "usage is growing just as fast as you can add more servers"; when absent, "word of mouth isn't spreading… the sales cycle takes too long… press reviews are kind of blah." [VERIFIED] [The Only Thing That Matters — Marc Andreessen, 2007](https://pmarchive.com/guide_to_startups_part4.html) (accessed 2026-04-24).

Note that Andreessen attributes the framing to Andy Rachleff ("Rachleff's Corollary") rather than claiming it as original. [VERIFIED] (same source).

### Lean Startup's take

Ries's site lists five core principles, including **Build-Measure-Learn**, **validated learning**, and **innovation accounting**. Build-Measure-Learn is described as the cycle where startups "turn ideas into products, measure how customers respond, and then learn whether to pivot or persevere." A **pivot** is defined as "a structural course correction to test a new fundamental hypothesis about the product, strategy and engine of growth." [VERIFIED] [Principles — The Lean Startup, Eric Ries](https://theleanstartup.com/principles) (accessed 2026-04-24).

The MVP is introduced as the first step in that cycle — the minimum artifact that lets you begin rapid learning without "developing a fully polished product." [VERIFIED] (same source).

### Problem–solution fit (terminology note)

The phrase "problem/solution fit" is commonly used as a milestone *before* PMF (you have evidence customers recognize a problem and value your proposed solution). A primary, fetched source for this exact term was not obtained in this session; treat specific definitions as **[UNVERIFIED]** until a Lean Startup / Ash Maurya source is fetched. The conceptual content — that you need to validate the problem before scaling the solution — is supported by both Andreessen and Ries above. [SYNTHESIS]

---

## 4. Jobs-to-be-Done

### Christensen's framing

Clayton Christensen (with Hall, Dillon, Duncan) published "Know Your Customers' 'Jobs to Be Done'" in *Harvard Business Review*, September 2016. The article's metadata and authorship were verified via fetch; the full article body is paywalled, so direct quotations from the article itself are **[UNVERIFIED]** here. [VERIFIED (authorship/date only)] [Know Your Customers' Jobs to Be Done — Christensen, Hall, Dillon, Duncan, HBR, 2016](https://hbr.org/2016/09/know-your-customers-jobs-to-be-done) (accessed 2026-04-24).

The Christensen Institute states the core principle: "People don't simply buy or pick products or services; they pull them into their lives to make progress." It frames JTBD as "a lens that reveals the circumstances — or forces — that drive people and organizations toward and away from decisions" — examining functional, social, and emotional dimensions rather than demographics. The site also records the canonical **milkshake example**: morning buyers "hired" the shake for commute-time hunger and entertainment; afternoon buyers hired it as a treat for kids — and the shake's real competition was bananas and bagels, not other shakes. [VERIFIED] [Jobs to Be Done — Christensen Institute](https://www.christenseninstitute.org/theory/jobs-to-be-done/) (accessed 2026-04-24).

### Ulwick's Outcome-Driven Innovation (ODI)

Tony Ulwick (Strategyn) operationalizes JTBD through **Outcome-Driven Innovation**. Ulwick's definition: "people buy products and services to get a job done," and markets should be defined around "a group of people pursuing a shared functional goal, not around products or demographics." Three principles: jobs remain stable while products change; customer needs are quantifiable; and innovation succeeds when solutions perform measurably better than alternatives. The ODI methodology has six phases — define the job; uncover needs via job mapping; gather importance/satisfaction data; discover segments with distinct unmet needs; formulate market strategy; formulate product strategy. [VERIFIED] [Jobs-to-be-Done — Strategyn / Tony Ulwick](https://strategyn.com/jobs-to-be-done/) (accessed 2026-04-24).

> **Note on attribution:** Christensen popularized the theory in the mainstream; Ulwick has publicly asserted priority on much of the underlying methodology. Both are cited here as separate strands of JTBD practice without adjudication. [CONTESTED] — full attribution history is outside scope of what the two fetched pages establish.

---

## 5. Design Thinking

### Stanford d.school — the five modes

The d.school's *Design Thinking Bootleg* (2018) identifies five modes: **Empathize, Define, Ideate, Prototype, Test**. These are described as "modes" rather than a strict linear sequence; each card in the associated toolkit is color-coded to one or more modes. Authors: Scott Doorley, Sarah Holcomb, Perry Klebahn, Kathryn Segovia, Jeremy Utley. [VERIFIED] [Design Thinking Bootleg — Stanford d.school, 2018](https://dschool.stanford.edu/resources/design-thinking-bootleg) (accessed 2026-04-24).

The d.school's introductory "Get Started" page explicitly does *not* prescribe the five-phase model as a rigid framework — it emphasizes "process, principles & mindsets." [VERIFIED] [Getting Started With Design — Stanford d.school](https://dschool.stanford.edu/resources/getting-started-with-design-thinking) (accessed 2026-04-24).

### IDEO

IDEO.org's Design Kit describes **human-centered design** in three phases: **Inspiration** (direct learning from users through immersion), **Ideation** (synthesis, opportunity identification, solution development), and **Implementation** (bringing solutions to market). Core quote: "It's a process that starts with the people you're designing for and ends with new solutions that are tailor made to suit their needs." [VERIFIED] [Human-Centered Design — IDEO.org Design Kit](https://www.designkit.org/human-centered-design.html) (accessed 2026-04-24).

IDEO U (a separate entity) describes a *seven-phase* variant — Frame a Question, Gather Inspiration, Synthesize for Action, Generate Ideas, Make Ideas Tangible, Test to Learn, Share the Story — and the four design dimensions: **desirability, feasibility, viability, responsibility** (the last one added more recently). IDEO U cites David Kelley: "The main tenet of design thinking is empathy for the people you're trying to design for." [VERIFIED] [What Is Design Thinking? — IDEO U, updated 2025-03-27](https://www.ideou.com/blogs/inspiration/what-is-design-thinking) (accessed 2026-04-24).

> **Note:** The five-mode (d.school) and three-phase (IDEO.org) and seven-phase (IDEO U) framings differ. They are not competing "correct answers"; they are different pedagogical groupings of the same underlying activities. [SYNTHESIS]

---

## 6. User research methods (summary)

NNG's method map organizes 20 methods along three axes: **attitudinal vs. behavioral**, **qualitative vs. quantitative**, and **context of use** (natural / scripted / limited / decontextualized). [VERIFIED] [When to Use Which User-Experience Research Methods — Christian Rohrer, NN/g, 2022-07-17](https://www.nngroup.com/articles/which-ux-research-methods/) (accessed 2026-04-24).

Core methods relevant to the ideation stage:

- **User interviews** — attitudinal, one-on-one, open-ended. Used during the Empathize phase to reveal experiences, mental models, motivations. Limitations: self-report bias, social-desirability bias, dependence on interviewer skill. [VERIFIED] [User Interviews 101 — Rosala & Pernice, NN/g, 2023-09-17](https://www.nngroup.com/articles/user-interviews/) (accessed 2026-04-24).
- **Usability testing** — behavioral. A facilitator asks a participant to perform realistic tasks on the product. NNG recommends 5 participants per user segment based on Nielsen & Landauer's model showing diminishing returns past that point. [VERIFIED] [Usability Testing 101 — Kate Moran, NN/g, 2019-12-01](https://www.nngroup.com/articles/usability-testing-101/) (accessed 2026-04-24); [Why You Only Need to Test with 5 Users — Jakob Nielsen, NN/g, 2000-03-18](https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/) (accessed 2026-04-24).
- **Field studies / contextual inquiry** — researchers observe users in their natural environment, combining observation with targeted interviewing. Valuable for surfacing workflow, context, and social factors that lab studies miss. [VERIFIED] [Field Studies — Farrell & Fessenden, NN/g, 2024-01-12](https://www.nngroup.com/articles/field-studies/) (accessed 2026-04-24).
- **Diary studies** — longitudinal, participant-recorded. Three protocols: event-based, interval-based, signal-based. Used for habits, longitudinal attitudes, multi-touchpoint journeys. [VERIFIED] [Diary Studies — Kim Flaherty, NN/g, 2024-03-29](https://www.nngroup.com/articles/diary-studies/) (accessed 2026-04-24).
- **Surveys** — quantitative surveys use structured closed-ended questions on large samples for statistical representativeness; qualitative surveys use open-ended questions on smaller samples. NNG warns that qualitative survey results "are rarely representative for the whole target audience." NNG recommends piloting + four rounds of think-aloud testing before deployment. [VERIFIED] [Qualitative Surveys — Susan Farrell, NN/g, 2016-09-25](https://www.nngroup.com/articles/qualitative-surveys/) (accessed 2026-04-24).

NNG also aligns methods to project phase: **Discover** (field studies, interviews, diary studies, stakeholder interviews) → **Explore** (personas, journey maps, task analysis, prototype testing, card sorting) → **Test** (qualitative usability testing, benchmarks, accessibility) → **Listen** (surveys, analytics, search logs, support data). [VERIFIED] [UX Research Cheat Sheet — Susan Farrell, NN/g, 2017-02-12](https://www.nngroup.com/articles/ux-research-cheat-sheet/) (accessed 2026-04-24).

Depth on each method is in `user-research.md`.

---

## 7. Requirements engineering and user stories

### The formal standard: ISO/IEC/IEEE 29148:2018

ISO/IEC/IEEE 29148:2018 is the current international standard for requirements engineering, covering systems and software throughout the life cycle. It "contains provisions for the processes and products related to the engineering of requirements" and provides guidelines for applying requirements processes from ISO/IEC/IEEE 15288 (systems) and 12207 (software). It specifies required information items, their content, and format, and treats requirements engineering as iterative/recursive rather than linear. [VERIFIED] [IEEE 29148 — IEEE Standards Association, 2018](https://standards.ieee.org/ieee/29148/6932/) (accessed 2026-04-24); [ISO/IEC/IEEE 29148 — SEBoK reference entry](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148) (accessed 2026-04-24).

> The full text of the standard is paywalled. Detailed internal structure (e.g., exact section names, Shall-statement templates, SRS contents) is **[UNVERIFIED]** from primary source here and should be filled in from the purchased standard before citing specifics.

### User stories (Cohn, Agile Alliance)

A user story is "a short, simple description of a feature told from the perspective of the person who desires the new capability, usually a user or customer of the system." The canonical template is "**As a [type of user], I want [some goal] so that [some reason]**." [VERIFIED] [User Stories — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/agile/user-stories) (accessed 2026-04-24).

Cohn credits Ron Jeffries's **Three C's** — Card, Conversation, Confirmation — as the structural model: the card is the placeholder/reminder, the conversation fills in detail, and confirmation is the acceptance tests that prove the story is done. Cohn adds that detail is captured via *conditions of satisfaction* — high-level acceptance tests that specify what must be true when the story is complete. [VERIFIED] (same source). The 3 C's are also recorded on the Agile Alliance glossary. [VERIFIED] [User Stories — Agile Alliance Glossary](https://www.agilealliance.org/glossary/user-stories/) (accessed 2026-04-24).

**INVEST** (Independent, Negotiable, Valuable, Estimable, Small, Testable) is a checklist for story quality, originated by **Bill Wake** in **2003** and later popularized by Cohn in *User Stories Applied* (2004). [VERIFIED] [INVEST — Agile Alliance Glossary](https://www.agilealliance.org/glossary/invest/) (accessed 2026-04-24).

Cohn explicitly states the template is not sacred — the "so that" clause shouldn't be mandatory (he includes it in 97% of stories himself), and teams should avoid following the template slavishly when it doesn't fit the context. [VERIFIED] [Advantages of the As a user, I want… User Story Template — Mike Cohn](https://www.mountaingoatsoftware.com/blog/advantages-of-the-as-a-user-i-want-user-story-template) (accessed 2026-04-24).

### Functional vs. non-functional requirements

The functional / non-functional distinction is standard in requirements engineering and is codified in ISO/IEC/IEEE 29148. However, the *specific* definitions from 29148 were not fetched in this session (the standard is paywalled). Treat any quoted definition as **[UNVERIFIED]** pending access to the standard text. [SYNTHESIS from SEBoK reference above, which identifies 29148 as the authority on the construct of "a good requirement."]

Depth on requirements is in `requirements.md`.

---

## 8. Artifacts of discovery

- **Personas** — "a fictional, yet realistic, description of a typical or target user of the product." Purposes: build empathy, align the team, guide prioritization, segment analytics. NNG notes three approaches (lightweight, qualitative, statistical) and emphasizes personas must be treated as "living documents." [VERIFIED] [Personas Study Guide — Kate Kaplan, NN/g, 2022-10-09](https://www.nngroup.com/articles/personas-study-guide/) (accessed 2026-04-24).

- **Journey maps** — "a visualization of the process that a person goes through in order to accomplish a goal." NNG specifies five components: **actor**, **scenario + expectations**, **journey phases**, **actions/mindsets/emotions**, and **opportunities**. The artifact serves team alignment and shared understanding. [VERIFIED] [Journey Mapping 101 — Sarah Gibbons, NN/g, 2018-12-09](https://www.nngroup.com/articles/journey-mapping-101/) (accessed 2026-04-24).

- **Opportunity solution trees (Torres)** — a visual tree: a single **outcome** (root, typically a product outcome measuring customer behavior/sentiment), branches into **opportunities** ("an unmet customer need, pain point, or desire"), which branch into **solutions** ("a product, a feature, a service, a workflow, a process, documentation, or anything else that we offer to customers to help address a known opportunity"), and then into **assumption tests**. Torres advises 3–4 story-based customer interviews as a prerequisite. [VERIFIED] [Opportunity Solution Tree — Teresa Torres, 2023-12-06](https://www.producttalk.org/opportunity-solution-tree/) (accessed 2026-04-24).

- **User story maps (Patton)** — a visual model of the user's journey through the product, used to organize and prioritize stories. Patton describes it as "a dead simple idea" that keeps "users and what they're doing with your product front and center" rather than letting the backlog become a feature list. [VERIFIED] [Story Mapping — Jeff Patton Associates](https://jpattonassociates.com/story-mapping/) (accessed 2026-04-24).

- **Problem statements** — primary-source fetch for a canonical problem-statement definition failed (HTTP 403/404 on the sources tried). This artifact is widely used in Design Thinking (after the Define mode) and in Lean Startup problem framing, but the *specific* canonical definition is **[UNVERIFIED]** in this session.

---

## 9. How discovery integrates with delivery

### Dual-track development (Patton, citing Sy)

Jeff Patton defines **dual-track development** as "two concurrent types of work within a single agile product development process: discovery and development." The **discovery track** focuses on "fast learning and validation," with short, irregular cycles (hours to days), hypothesis testing, and a high rate of *killing* ideas; the **development track** focuses on "predictability and quality," with predictable sprint cycles and production-quality output. [VERIFIED] [Dual-Track Development — Jeff Patton, 2017-05-10 (updated 2023-04-12)](https://jpattonassociates.com/dual-track-development/) (accessed 2026-04-24).

Patton explicitly attributes the original formulation to **Desirée Sy's 2007 paper** *"Adapting Usability Investigations for Agile User-Centered Design."* He quotes Sy: "Although the dual tracks depicted seem separate, in reality, designers need to communicate every day with developers." Patton's core principle: "Discovery and development are shown in two tracks because they're two kinds of work, and two kinds of thinking" — but they should involve the whole team, not separate silos. [VERIFIED] (same source).

### Continuous discovery as the integrating mechanism

Torres's continuous discovery (see §2) is the operating model that keeps discovery *alongside* delivery rather than *before* it: weekly customer interviews + weekly assumption tests + updates to the opportunity solution tree, feeding a steady stream of validated ideas into the delivery track. [VERIFIED] [Continuous Discovery — Teresa Torres, 2021](https://www.producttalk.org/continuous-discovery/) (accessed 2026-04-24).

---

## 10. Methodology

### Search queries used
- Direct URL fetches for known primary sources (producttalk.org, theleanstartup.com, nngroup.com articles, dschool.stanford.edu, strategyn.com, designkit.org, jpattonassociates.com, mountaingoatsoftware.com, agilealliance.org, hbr.org, christenseninstitute.org, pmarchive.com).
- Web search: `"IEEE 29148" 2018 requirements engineering scope site:ieee.org OR site:computer.org`.

### Sources attempted but not obtained
- `svpg.com/product-discovery/` and `svpg.com/four-big-risks/` — HTTP 403. Marty Cagan / SVPG primary content not verifiable this session; any Cagan-specific claim is tagged [UNVERIFIED].
- `jtbd.info` (Alan Klement's explainer) — TLS certificate failure.
- `iso.org` pages for 29148 and HBR long-form articles — HTTP 403. Direct standard text / HBR full text not fetched.
- `designkit.org` phase-specific subpages — some 404s. Only the top human-centered-design page was fetched.
- Reforge and Bridging-the-Gap problem-statement sources — HTTP 403/404.

### Notes on confidence
- The strongest claims in this document are those backed by NNG articles (dated, authored, methodological) and Torres's blog (primary source, author).
- Attribution of specific ideas to Cagan, Christensen (HBR article body), or the IEEE 29148 text interior is not verified from primary fetched content this session and is flagged where it appears.

---

## 11. Open questions

1. **Cagan/SVPG primary content.** Need an alternative route to SVPG (mirror, book excerpt, conference talk transcript) to verify the "four risks" framing and discovery/delivery definitions directly.
2. **ISO/IEC/IEEE 29148 interior.** Specific section structure, the definition of "a good requirement" characteristics (unambiguous, complete, consistent, verifiable, etc.), and the SRS / StRS / SyRS content templates require access to the paywalled standard.
3. **Problem/solution fit** — canonical definition source (Ash Maurya, Steve Blank, or Lean Startup original) needs to be fetched to avoid the term being [UNVERIFIED].
4. **JTBD article body.** The 2016 HBR Christensen et al. piece is paywalled — need an alternative (Christensen's *Competing Against Luck* book excerpts, an HBS Working Knowledge summary, or a public talk) to quote Christensen directly on the theory's definitions.
5. **IDEO stage-count inconsistency.** The d.school (5 modes), IDEO.org (3 phases), and IDEO U (7 phases) framings differ; a single canonical IDEO source that reconciles them would strengthen the design-thinking section.
6. **Problem statement canonical source.** Neither the d.school Bootleg PDF nor IDEO's design kit page yielded an inline definition; need to fetch one (e.g., d.school's "How Might We" + problem-statement template, or IDEO Method Cards).

---

## Sources (all accessed 2026-04-24)

### Discovery
- [Product Discovery — Teresa Torres, 2021](https://www.producttalk.org/2021/08/product-discovery/)
- [Continuous Discovery — Teresa Torres, 2021](https://www.producttalk.org/continuous-discovery/)
- [Opportunity Solution Tree — Teresa Torres, 2023](https://www.producttalk.org/opportunity-solution-tree/)
- [The Only Thing That Matters — Marc Andreessen, 2007](https://pmarchive.com/guide_to_startups_part4.html)
- [Principles — The Lean Startup, Eric Ries](https://theleanstartup.com/principles)
- [The Lean Startup (home) — Eric Ries](https://theleanstartup.com/)

### Jobs-to-be-Done
- [Know Your Customers' Jobs to Be Done — Christensen, Hall, Dillon, Duncan, HBR, 2016 (metadata only; body paywalled)](https://hbr.org/2016/09/know-your-customers-jobs-to-be-done)
- [Jobs to Be Done — Christensen Institute](https://www.christenseninstitute.org/theory/jobs-to-be-done/)
- [Jobs-to-be-Done — Strategyn / Tony Ulwick](https://strategyn.com/jobs-to-be-done/)

### Design Thinking
- [Design Thinking Bootleg — Stanford d.school, 2018](https://dschool.stanford.edu/resources/design-thinking-bootleg)
- [Getting Started With Design — Stanford d.school](https://dschool.stanford.edu/resources/getting-started-with-design-thinking)
- [Human-Centered Design — IDEO.org Design Kit](https://www.designkit.org/human-centered-design.html)
- [What Is Design Thinking? — IDEO U, 2025](https://www.ideou.com/blogs/inspiration/what-is-design-thinking)

### User research methods (NN/g)
- [When to Use Which User-Experience Research Methods — Christian Rohrer, NN/g, 2022](https://www.nngroup.com/articles/which-ux-research-methods/)
- [UX Research Cheat Sheet — Susan Farrell, NN/g, 2017](https://www.nngroup.com/articles/ux-research-cheat-sheet/)
- [User Interviews 101 — Rosala & Pernice, NN/g, 2023](https://www.nngroup.com/articles/user-interviews/)
- [Usability Testing 101 — Kate Moran, NN/g, 2019](https://www.nngroup.com/articles/usability-testing-101/)
- [Why You Only Need to Test with 5 Users — Jakob Nielsen, NN/g, 2000](https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/)
- [Field Studies — Farrell & Fessenden, NN/g, 2024](https://www.nngroup.com/articles/field-studies/)
- [Diary Studies — Kim Flaherty, NN/g, 2024](https://www.nngroup.com/articles/diary-studies/)
- [Qualitative Surveys — Susan Farrell, NN/g, 2016](https://www.nngroup.com/articles/qualitative-surveys/)
- [Personas Study Guide — Kate Kaplan, NN/g, 2022](https://www.nngroup.com/articles/personas-study-guide/)
- [Journey Mapping 101 — Sarah Gibbons, NN/g, 2018](https://www.nngroup.com/articles/journey-mapping-101/)

### Requirements engineering and agile artifacts
- [User Stories — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/agile/user-stories)
- [Advantages of the "As a user, I want…" User Story Template — Mike Cohn](https://www.mountaingoatsoftware.com/blog/advantages-of-the-as-a-user-i-want-user-story-template)
- [User Stories — Agile Alliance Glossary](https://www.agilealliance.org/glossary/user-stories/)
- [INVEST — Agile Alliance Glossary](https://www.agilealliance.org/glossary/invest/)
- [IEEE 29148 — IEEE Standards Association, 2018](https://standards.ieee.org/ieee/29148/6932/)
- [ISO/IEC/IEEE 29148 — SEBoK reference entry](https://sebokwiki.org/wiki/ISO/IEC/IEEE_29148)

### Dual-track / story mapping
- [Dual-Track Development — Jeff Patton, 2017/2023](https://jpattonassociates.com/dual-track-development/)
- [Story Mapping — Jeff Patton Associates](https://jpattonassociates.com/story-mapping/)
