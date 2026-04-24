# 00 — Lifecycle Models

**Question:** What are the major software lifecycle models, where do they come from, and when are they used?

**Status:** Draft

**Last updated:** 2026-04-24

This document summarizes each major lifecycle model with its original source, key characteristics, and typical use context. Where the original paper was not directly fetched, the source is flagged and a secondary source is cited.

---

## 1. Waterfall (Royce, 1970)

The waterfall model is the archetypal sequential lifecycle: preliminary analysis → requirements → design → development → integration and testing → deployment → maintenance → evaluation → disposal [Waterfall model — Wikipedia](https://en.wikipedia.org/wiki/Waterfall_model) (accessed 2026-04-24).

It is attributed to Winston W. Royce's 1970 paper "Managing the Development of Large Software Systems," published in the Proceedings of IEEE WESCON (pp. 328–388). The paper was fetched directly this session from a GitHub-hosted PDF mirror of the original: [Managing the Development of Large Software Systems — Royce, 1970 (tpn/pdfs mirror)](https://raw.githubusercontent.com/tpn/pdfs/master/Managing%20the%20Development%20of%20Large%20Software%20Systems%20-%201970%20(waterfall).pdf) (accessed 2026-04-24). [VERIFIED]

**Important correction.** Royce did **not** endorse the naive sequential model he drew. After presenting the sequential diagram, Royce writes verbatim: "I believe in this concept, but the implementation described above is risky and invites failure" [Managing the Development of Large Software Systems — Royce, 1970](https://raw.githubusercontent.com/tpn/pdfs/master/Managing%20the%20Development%20of%20Large%20Software%20Systems%20-%201970%20(waterfall).pdf) (accessed 2026-04-24). [VERIFIED — primary source fetched this session]

Royce then devoted most of the paper to five improvements that mitigate the risk of the naive approach: (1) introduce a preliminary program design before analysis; (2) document the design comprehensively; (3) "do it twice" — build a pilot/simulation version; (4) plan, control, and monitor testing; (5) involve the customer throughout [Managing the Development of Large Software Systems — Royce, 1970](https://raw.githubusercontent.com/tpn/pdfs/master/Managing%20the%20Development%20of%20Large%20Software%20Systems%20-%201970%20(waterfall).pdf) (accessed 2026-04-24). [VERIFIED]

Earlier phased development: Herbert D. Benington described phased development in 1956 for the SAGE project, predating Royce [Waterfall model — Wikipedia](https://en.wikipedia.org/wiki/Waterfall_model) (accessed 2026-04-24).

**When used today.** Regulated, contract-driven, or safety-critical contexts where requirements are fixed and change is costly — e.g., some government procurement, medical devices. [SYNTHESIS] Supporting evidence is indirect (V-Model descendants are used in regulated contexts — see below); a direct survey of current waterfall usage was not fetched in this session.

---

## 2. V-Model

The V-Model extends waterfall by pairing each constructive phase (requirements analysis, system design, architecture design, module design) with a corresponding verification phase (user acceptance testing, system testing, integration testing, unit testing), bent upward after coding to form a "V" shape [V-Model (software development) — Wikipedia](https://en.wikipedia.org/wiki/V-Model_(software_development)) (accessed 2026-04-24).

Wikipedia notes early formalization by Kevin Forsberg and Harold Mooz in 1991 ("The Relationship of System Engineering to the Project Cycle"), though no single founder is named; the model also has parallel development in German government procurement (V-Modell XT) [V-Model (software development) — Wikipedia](https://en.wikipedia.org/wiki/V-Model_(software_development)) (accessed 2026-04-24).

**Characteristics.** Each design phase has a matching test phase planned at the same time. Critics note it "provides only a slight variant" on waterfall and shares waterfall's rigidity [V-Model — Wikipedia](https://en.wikipedia.org/wiki/V-Model_(software_development)) (accessed 2026-04-24).

**When used today.** Safety-critical or certified domains (automotive per ISO 26262, defense, aerospace) where test planning must trace explicitly to requirements. [UNVERIFIED] No primary domain standard was fetched in this session.

---

## 3. Spiral (Boehm, 1986 / 1988)

Barry Boehm first described the spiral model in "A Spiral Model of Software Development and Enhancement," published August 1986 in ACM SIGSOFT Software Engineering Notes and republished in a more widely read form in May 1988 in IEEE Computer [Spiral model — Wikipedia](https://en.wikipedia.org/wiki/Spiral_model) (accessed 2026-04-24).

The spiral is risk-driven. Wikipedia quotes Boehm: the spiral is "a process model generator," where "choices based on a project's risks generate an appropriate process model for the project" [Spiral model — Wikipedia](https://en.wikipedia.org/wiki/Spiral_model) (accessed 2026-04-24). Each cycle performs four basic activities:

1. Consider stakeholder win conditions.
2. Identify and evaluate alternative approaches.
3. Identify and resolve risks from selected approaches.
4. Obtain stakeholder approval and commitment for the next cycle.

[Spiral model — Wikipedia](https://en.wikipedia.org/wiki/Spiral_model) (accessed 2026-04-24).

**When used today.** Large, high-risk, novel systems where risk reduction warrants multiple prototype cycles. [UNVERIFIED] A current industry survey of spiral-model use was not fetched in this session.

---

## 4. Iterative / Incremental

Iterative and incremental development (IID) is the parent category of spiral, RUP, and agile methods: deliver successive versions, each improving on the last. The Agile Manifesto's third principle codifies this for modern practice: "Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale" [Principles behind the Agile Manifesto](https://agilemanifesto.org/principles.html) (accessed 2026-04-24).

[UNVERIFIED] A single canonical source defining "iterative and incremental development" was not fetched in this session; the term is used widely but without one anchor text. Readers wanting a primary source should seek Craig Larman's published treatment — not fetched here.

---

## 5. Agile (Agile Manifesto, 2001)

The Agile Manifesto was published in 2001 by 17 signatories: Kent Beck, Mike Beedle, Arie van Bennekum, Alistair Cockburn, Ward Cunningham, Martin Fowler, James Grenning, Jim Highsmith, Andrew Hunt, Ron Jeffries, Jon Kern, Brian Marick, Robert C. Martin, Steve Mellor, Ken Schwaber, Jeff Sutherland, and Dave Thomas [Manifesto for Agile Software Development](https://agilemanifesto.org/) (accessed 2026-04-24).

The four values, verbatim:

> - "Individuals and interactions over processes and tools"
> - "Working software over comprehensive documentation"
> - "Customer collaboration over contract negotiation"
> - "Responding to change over following a plan"
>
> That is, while there is value in the items on the right, we value the items on the left more.

[Manifesto for Agile Software Development](https://agilemanifesto.org/) (accessed 2026-04-24).

The twelve principles behind the manifesto cover: early and continuous delivery of valuable software, welcoming changing requirements, delivering working software frequently, daily business/developer collaboration, motivated individuals, face-to-face conversation, working software as primary progress measure, sustainable pace, technical excellence and good design, simplicity, self-organizing teams, and regular reflection and adjustment [Principles behind the Agile Manifesto](https://agilemanifesto.org/principles.html) (accessed 2026-04-24). All twelve are cited verbatim from the principles page.

---

## 6. Scrum (Scrum Guide, 2020)

The authoritative reference is the 2020 Scrum Guide by Ken Schwaber and Jeff Sutherland [The 2020 Scrum Guide — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).

Definition, quoted from the Guide: "Scrum is a lightweight framework that helps people, teams and organizations generate value through adaptive solutions for complex problems" [Scrum Guide 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).

Structure:

- **Scrum Team** with three accountabilities: Developers, Product Owner, Scrum Master [Scrum Guide 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).
- **Five events:** the Sprint (container, one month or less), Sprint Planning, Daily Scrum (15-minute progress inspection), Sprint Review, Sprint Retrospective [Scrum Guide 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).
- **Three artifacts, each with a commitment:** Product Backlog (with Product Goal), Sprint Backlog (with Sprint Goal), Increment (with Definition of Done) [Scrum Guide 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24).

Revision history: the Scrum Guide has been revised in 2010, 2011, 2013, 2016/2017, and 2020. The 2013 revision formally added the five Scrum Values (commitment, courage, focus, openness, respect). The 2020 revision made the guide less prescriptive, introduced the Product Goal, unified the team into a single Scrum Team, and simplified language to under 13 pages [Scrum Guide Revisions — scrumguides.org](https://scrumguides.org/revisions.html) (accessed 2026-04-24).

---

## 7. Extreme Programming (XP, Kent Beck)

Kent Beck developed XP on the Chrysler Comprehensive Compensation System (C3) project starting 1996. The book *Extreme Programming Explained: Embrace Change* was published in 1999 (second edition 2004, with Cynthia Andres) [ExtremeProgramming — Fowler bliki](https://martinfowler.com/bliki/ExtremeProgramming.html) (accessed 2026-04-24).

Martin Fowler describes XP: "Extreme Programming (XP) is a software development methodology developed primarily by Kent Beck" and notes it "popularized several influential practices that are now widely adopted in software development" — continuous integration, refactoring, test-driven development, and agile planning [ExtremeProgramming — Fowler](https://martinfowler.com/bliki/ExtremeProgramming.html) (accessed 2026-04-24).

Fowler adds that XP "combines both technical and management practices, which ... makes it particularly effective for achieving higher levels of agile maturity compared to methodologies that focus solely on management approaches" [ExtremeProgramming — Fowler](https://martinfowler.com/bliki/ExtremeProgramming.html) (accessed 2026-04-24).

[UNVERIFIED at primary] The five XP values often cited (Communication, Simplicity, Feedback, Courage, Respect) appear in the Wikipedia entry for XP but the primary source is Beck's book, which was not fetched in this session. They should be sourced from the book or Beck's own writing before being used prescriptively downstream.

---

## 8. Kanban

The reference text for Kanban in software development is David J. Anderson's 2010 book *Kanban: Successful Evolutionary Change for Your Technology Business* [Kanban (development) — Wikipedia](https://en.wikipedia.org/wiki/Kanban_(development)) (accessed 2026-04-24).

The current community reference is the *Kanban Guide*, most recently updated May 2025, developed collaboratively by John Coleman, Daniel Vacanti, Colleen Johnson, Prateek Singh, Julia Wester, Christian Neverdal, Magdalena Firlit, Tom Gilb, and Steve Tendon [The Kanban Guide — kanbanguides.org](https://kanbanguides.org/english/) (accessed 2026-04-24).

The guide defines three practices and four mandatory measures:

Practices:
1. Defining and visualizing the workflow.
2. Actively managing items in a workflow.
3. Improving the workflow.

Measures:
- WIP (Work in Progress)
- Throughput
- Work Item Age
- Cycle Time

[The Kanban Guide — kanbanguides.org](https://kanbanguides.org/english/) (accessed 2026-04-24).

**When used today.** Teams with continuous inbound work (operations, support, maintenance) and teams that want flow-based metrics rather than iteration-based ones. [SYNTHESIS] derived from the Kanban Guide's emphasis on flow metrics over iteration metrics.

---

## 9. Lean Software Development (Poppendieck, 2003)

Mary and Tom Poppendieck articulated seven principles of Lean Software Development in their 2003 book *Lean Software Development: An Agile Toolkit* (Addison-Wesley) [Lean Software Development — WebSearch summary](https://www.amazon.com/Lean-Software-Development-Agile-Toolkit/dp/0321150783) (accessed 2026-04-24 via search; direct fetch not performed).

The seven principles, as reported by multiple summaries of the book:

1. Eliminate waste
2. Amplify learning
3. Decide as late as possible
4. Deliver as fast as possible
5. Empower the team
6. Build integrity in
7. See the whole

[OUT OF DATE / UNVERIFIED at primary] The exact wording of the principles as published in the 2003 book was not fetched in this session. These are reproduced from a search summary and an O'Reilly catalog page and should be confirmed against the book before quoting prescriptively.

---

## 10. DevOps and Continuous Delivery (Humble & Farley, 2010; Patrick Debois, 2009)

**DevOps as a movement** emerged in the late 2000s. Patrick Debois organized the first "DevOpsDays" in Ghent, Belgium in 2009, which popularized the term and the community [DevOps — Wikipedia](https://en.wikipedia.org/wiki/DevOps) (accessed 2026-04-24). Wikipedia defines DevOps as "a set of practices intended to reduce the time between committing a change to a system and the change being placed into normal production, while ensuring high quality" [DevOps — Wikipedia](https://en.wikipedia.org/wiki/DevOps) (accessed 2026-04-24).

**Continuous Delivery** was defined by Jez Humble and David Farley in their 2010 book *Continuous Delivery: Reliable Software Releases Through Build, Test, and Deployment Automation* (Addison-Wesley) [Continuous delivery — Wikipedia](https://en.wikipedia.org/wiki/Continuous_delivery) (accessed 2026-04-24).

Martin Fowler's definition, quoted verbatim: "a software development discipline where you build software in such a way that the software can be released to production at any time" [ContinuousDelivery — Fowler](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24). Fowler enumerates four indicators:

- Software is deployable throughout its lifecycle.
- The team prioritizes keeping software deployable over working on new features.
- Anybody can get fast, automated feedback on the production readiness of their systems any time somebody makes a change.
- You can perform push-button deployments of any version of the software to any environment on demand.

[ContinuousDelivery — Fowler](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24).

**Continuous Delivery vs Continuous Deployment.** Continuous Deployment means every change that passes the pipeline is automatically promoted to production; Continuous Delivery makes this possible but keeps the final step as a business decision. "Continuous Deployment requires Continuous Delivery as a prerequisite" [ContinuousDelivery — Fowler](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24).

**Continuous Integration (prerequisite to CD).** Fowler's current definition: "Continuous Integration is a software development practice where each member of a team merges their changes into a codebase together with their colleagues changes at least daily" [ContinuousIntegration — Fowler, 2024 revision](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24). The article lists eleven practices, including version-controlled mainline, automated builds, self-testing code, daily mainline commits, automated build triggers on commit, immediate-fix protocol for broken builds, fast build times (~10 minutes), hiding work-in-progress behind feature flags/keystones, production-like testing, visibility, and automated deployment [ContinuousIntegration — Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24).

---

## 11. Lean Startup (Ries, 2011)

Eric Ries published *The Lean Startup* in 2011. The official principles page enumerates the Lean Startup method's five principles [The Lean Startup — Principles](https://theleanstartup.com/principles) (accessed 2026-04-24):

1. Entrepreneurs are everywhere.
2. Entrepreneurship is management.
3. Validated learning.
4. Build-Measure-Learn.
5. Innovation accounting.

Key concepts, from the principles page:

- **Build-Measure-Learn:** the loop where startups "turn ideas into products, measure how customers respond, and then learn whether to pivot or persevere" [theleanstartup.com/principles](https://theleanstartup.com/principles) (accessed 2026-04-24).
- **MVP (Minimum Viable Product):** the initial product version used to begin the learning process — to "test assumptions with real customers before full-scale development" [theleanstartup.com/principles](https://theleanstartup.com/principles) (accessed 2026-04-24).
- **Pivot:** "a structural course correction to test a new fundamental hypothesis about the product, strategy and engine of growth" [theleanstartup.com/principles](https://theleanstartup.com/principles) (accessed 2026-04-24).

**Why it matters for PDLC.** Lean Startup supplies the upstream "ideation / discovery" loop that the classical SDLC does not prescribe — an explicit method for deciding *what* to build before asking *how* to build it.

---

## Sources

- [Manifesto for Agile Software Development — 2001](https://agilemanifesto.org/) (accessed 2026-04-24)
- [Principles behind the Agile Manifesto](https://agilemanifesto.org/principles.html) (accessed 2026-04-24)
- [The 2020 Scrum Guide — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)
- [Scrum Guide Revisions — scrumguides.org](https://scrumguides.org/revisions.html) (accessed 2026-04-24)
- [Waterfall model — Wikipedia](https://en.wikipedia.org/wiki/Waterfall_model) (accessed 2026-04-24)
- [Managing the Development of Large Software Systems — Winston W. Royce, 1970 (PDF via tpn/pdfs mirror)](https://raw.githubusercontent.com/tpn/pdfs/master/Managing%20the%20Development%20of%20Large%20Software%20Systems%20-%201970%20(waterfall).pdf) (accessed 2026-04-24)
- [V-Model (software development) — Wikipedia](https://en.wikipedia.org/wiki/V-Model_(software_development)) (accessed 2026-04-24)
- [Spiral model — Wikipedia](https://en.wikipedia.org/wiki/Spiral_model) (accessed 2026-04-24)
- [Kanban (development) — Wikipedia](https://en.wikipedia.org/wiki/Kanban_(development)) (accessed 2026-04-24)
- [The Kanban Guide — kanbanguides.org](https://kanbanguides.org/english/) (accessed 2026-04-24)
- [ExtremeProgramming — Martin Fowler bliki](https://martinfowler.com/bliki/ExtremeProgramming.html) (accessed 2026-04-24)
- [ContinuousIntegration — Martin Fowler (2024 revision)](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [ContinuousDelivery — Martin Fowler bliki](https://martinfowler.com/bliki/ContinuousDelivery.html) (accessed 2026-04-24)
- [MicroservicePrerequisites — Martin Fowler bliki](https://martinfowler.com/bliki/MicroservicePrerequisites.html) (accessed 2026-04-24)
- [DevOps — Wikipedia](https://en.wikipedia.org/wiki/DevOps) (accessed 2026-04-24)
- [Continuous delivery — Wikipedia](https://en.wikipedia.org/wiki/Continuous_delivery) (accessed 2026-04-24)
- [The Lean Startup — Principles](https://theleanstartup.com/principles) (accessed 2026-04-24)

## Open questions

- Royce 1970 paper verified this session via GitHub-hosted PDF mirror; the "risky and invites failure" quote and the five improvements are now VERIFIED against the primary text.
- The 2003 Poppendieck principles are reproduced from a search-result summary; the book was not fetched. Before quoting prescriptively, the primary text should be consulted.
- Kent Beck's XP values (Communication, Simplicity, Feedback, Courage, Respect) need primary-source verification from *Extreme Programming Explained*; Fowler's bliki does not enumerate them verbatim.
- A direct DORA page listing the four keys in canonical wording was fetched; the current DORA model includes a fifth metric, "deployment rework rate" — this should be considered when downstream stages quote DORA.
