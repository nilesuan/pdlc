# Discovery: Frameworks and Philosophies

**Question:** What are the main frameworks used to decide what software to build, who teaches them, and how do they relate?

**Status:** Draft
**Last updated:** 2026-04-24

This document goes deeper on the discovery frameworks summarized in `README.md` §2–5. It is organized by source/author so that each claim can be matched to a fetched primary source.

---

## 1. Teresa Torres — Continuous Discovery

**Definition.** Torres defines product discovery against delivery: *"Product discovery is used to describe the work that we do to make decisions about what to build, while product delivery is the work we do to build, ship, and maintain a production quality product."* [VERIFIED] [Product Discovery — Teresa Torres, 2021](https://www.producttalk.org/2021/08/product-discovery/) (accessed 2026-04-24).

**Key shift.** From project-based research (a burst of discovery at the start and end of a project) to **continuous** discovery — ongoing customer engagement that informs regular product decisions. [VERIFIED] [Continuous Discovery — Teresa Torres, 2021](https://www.producttalk.org/continuous-discovery/) (accessed 2026-04-24).

**The two weekly habits.**
1. **Customer interviewing.** Teams gather customer *stories* to uncover needs, pain points, and desires (which Torres calls *opportunities*) relevant to a specific product outcome.
2. **Assumption testing.** Teams rapidly test assumptions across five risk categories — **desirable, viable, feasible, usable, ethical** — using prototypes, surveys, data analysis, and research spikes.

[VERIFIED] (same source).

**Frequency.** Torres states that "good product discovery teams [engage with customers at least weekly]" to minimize decisions made without customer input; she names the *curse of knowledge* as the failure mode this counteracts (product experts losing sight of the customer's perspective). [VERIFIED] (same source).

**The structural model.** Outcome → Opportunities → Solutions → Assumption Tests, visualized as an **opportunity solution tree**. Torres defines each layer:

- **Outcome:** "the business need that reflects how your team can create business value"; should be a *product outcome* (customer behavior or sentiment), not a traction/revenue metric.
- **Opportunity:** "an unmet customer need, pain point, or desire."
- **Solution:** "a product, a feature, a service, a workflow, a process, documentation, or anything else that we offer to customers to help address a known opportunity."
- **Assumption tests:** methods to evaluate which solutions best create customer value while driving business value.

[VERIFIED] [Opportunity Solution Tree — Teresa Torres, 2023](https://www.producttalk.org/opportunity-solution-tree/) (accessed 2026-04-24).

Prerequisite: 3–4 story-based interviews before drawing the first tree. [VERIFIED] (same source).

---

## 2. Marty Cagan / SVPG

**Source-availability note.** `WebFetch` on svpg.com returned HTTP 403 in the initial session, but `curl` with a standard User-Agent fetched the same pages successfully on 2026-04-24. Content below is taken directly from those canonical SVPG pages.

**The Four Big Risks.** [VERIFIED] In his 2017 SVPG article updating the second edition of *INSPIRED*, Cagan names four types of risk ([The Four Big Risks — Marty Cagan, SVPG, 2017-12-04](https://www.svpg.com/four-big-risks/) (accessed 2026-04-24)):

- "**value risk** (whether customers will buy it or users will choose to use it)"
- "**usability risk** (whether users can figure out how to use it)"
- "**feasibility risk** (whether our engineers can build what we need with the time, skills and technology we have)"
- "**business viability risk** (whether this solution also works for the various aspects of our business)"

Cagan explains the change from three to four: in the first edition of *INSPIRED* he used "valuable, usable and feasible" with "valuable" bundled to mean both customers *and* business. Over time he concluded that bundling "was obscuring some pretty serious risks and challenges, and making it too easy for product managers to focus on customer value and overlook business value." Business viability risks "can be substantial and I find that these are too often under-appreciated and under-estimated (or simply avoided) by the product manager."

**Role accountability.** [VERIFIED] "The Product Manager is responsible for the value and viability risks, and overall accountable for the product's outcomes. The Product Designer is responsible for the usability risk, and overall accountable for the product's experience… The Product Lead Engineer is responsible for the feasibility risk, and overall accountable for the product's delivery." ([The Four Big Risks — Marty Cagan, SVPG, 2017](https://www.svpg.com/four-big-risks/) (accessed 2026-04-24)).

**Product Discovery vs Delivery (Cagan's framing).** [VERIFIED] In his 2007 essay "Product Discovery," Cagan argues: "Product organizations need to come to terms with the fact that the product invention process is fundamentally a creative process. It is more art than science. I prefer to think of this phase as 'product discovery' more than 'requirements and design.'" He identifies two discoveries that must happen before engineering builds anything: "you need to discover whether there are real users out there that want this product… [and] you need to discover a product solution to this problem that is usable, useful, and feasible." ([Product Discovery — Marty Cagan, SVPG, 2007-09-24](https://www.svpg.com/product-discovery/) (accessed 2026-04-24)).

**Relationship to Torres's five risk categories.** Torres's list (desirable, viable, feasible, usable, *ethical*) overlaps with Cagan's four-risk list but is not identical. Torres adds an explicit "ethical" category that Cagan's 2017 list does not name. [SYNTHESIS from the two fetched sources above.]

---

## 3. Eric Ries — Lean Startup

**What it is.** The Lean Startup is "a movement for building new products through rapid experimentation and validated learning," with the goal of helping entrepreneurs move faster while being "less wasteful." [VERIFIED] [The Lean Startup — Eric Ries (home page)](https://theleanstartup.com/) (accessed 2026-04-24).

**Build-Measure-Learn.** Ries defines the core loop: startups "turn ideas into products, measure how customers respond, and then learn whether to pivot or persevere." [VERIFIED] [Principles — The Lean Startup](https://theleanstartup.com/principles) (accessed 2026-04-24).

**Minimum Viable Product (MVP).** Described on the same page as the first step in Build-Measure-Learn — the minimum artifact to begin rapid learning without building a polished product. [VERIFIED] (same source).

> The page does not give a crisper one-sentence definition of MVP; for the canonical definition (smallest product that enables a full turn of the Build-Measure-Learn loop), consult *The Lean Startup* (2011) directly — not fetched this session.

**Validated learning.** "A rigorous method for demonstrating progress when one is embedded in the soil of extreme uncertainty." The point is to measure whether the team is *building something customers actually want and will pay for*, not intermediate engineering metrics. [VERIFIED] (same source).

**Pivot.** "A structural course correction to test a new fundamental hypothesis about the product, strategy and engine of growth." Triggered when measurement and learning reveal that the current business drivers are not working. [VERIFIED] (same source).

**Innovation accounting.** Listed as one of the five core principles on Ries's site; a structured approach to measuring progress under uncertainty. The site lists but does not fully define the concept on this page. [VERIFIED (existence of principle)] (same source).

**Core philosophy.** A startup exists "to learn how to build a sustainable business" through scientific experimentation rather than months of development before customer contact. [VERIFIED] (same source).

---

## 4. Marc Andreessen — product/market fit

**Definition.** Product/market fit = "being in a good market with a product that can satisfy that market." [VERIFIED] [The Only Thing That Matters — Marc Andreessen, 2007-06-25](https://pmarchive.com/guide_to_startups_part4.html) (accessed 2026-04-24).

**Attribution.** Andreessen frames the thesis as *Rachleff's Corollary* (after Andy Rachleff): "The only thing that matters is getting to product/market fit." [VERIFIED] (same source).

**Signals PMF is present:**
- "The customers are buying the product just as fast as you can make it."
- "Money from customers is piling up in your company checking account."
- "Usage is growing just as fast as you can add more servers."
- Word-of-mouth spreads; press attention grows.

[VERIFIED] (same source).

**Signals PMF is absent:**
- "The customers aren't quite getting value out of the product."
- "Word of mouth isn't spreading."
- "Usage isn't growing that fast."
- "Press reviews are kind of blah."
- "The sales cycle takes too long."

[VERIFIED] (same source).

Andreessen's claim is that founders *can feel* whether PMF is present — the signals are tangible, not inferential.

---

## 5. Design Thinking

### Stanford d.school

The d.school's *Design Thinking Bootleg* (2018, authored by Doorley, Holcomb, Klebahn, Segovia, Utley) uses **five modes**: **Empathize, Define, Ideate, Prototype, Test**. Cards in the deck are color-coded to these modes. [VERIFIED] [Design Thinking Bootleg — Stanford d.school, 2018](https://dschool.stanford.edu/resources/design-thinking-bootleg) (accessed 2026-04-24).

The d.school's own introductory "Get Started" page deliberately does *not* present the five modes as a linear recipe — it emphasizes "process, principles & mindsets" and points users at the Bootleg deck rather than a fixed ordering. [VERIFIED] [Getting Started With Design — Stanford d.school](https://dschool.stanford.edu/resources/getting-started-with-design-thinking) (accessed 2026-04-24).

> Per-mode prose definitions were not on either fetched page. The Bootleg PDF (not directly rendered to markdown in this session) contains them; for precise mode definitions, treat the Bootleg PDF as the primary source.

### IDEO.org — Design Kit

Three phases: **Inspiration → Ideation → Implementation**.

- Inspiration: "Direct learning from users through immersion in their lives to understand their needs."
- Ideation: "Making sense of learnings, identifying design opportunities, and developing potential solutions."
- Implementation: "Bringing solutions to market while maintaining focus on end-users throughout."

Core quote: *"It's a process that starts with the people you're designing for and ends with new solutions that are tailor made to suit their needs."*

[VERIFIED] [Human-Centered Design — IDEO.org Design Kit](https://www.designkit.org/human-centered-design.html) (accessed 2026-04-24).

### IDEO U — seven phases

IDEO U (the commercial learning platform, distinct from IDEO.org) describes **seven phases**: Frame a Question, Gather Inspiration, Synthesize for Action, Generate Ideas, Make Ideas Tangible, Test to Learn, Share the Story. IDEO U also articulates four dimensions: **desirability, feasibility, viability, responsibility** — with "responsibility" (ethics, unintended harm) as a recent addition. Quote attributed to David Kelley: *"The main tenet of design thinking is empathy for the people you're trying to design for."* [VERIFIED] [What Is Design Thinking? — IDEO U, updated 2025-03-27](https://www.ideou.com/blogs/inspiration/what-is-design-thinking) (accessed 2026-04-24).

### Reconciling the frames

The three framings (d.school 5 modes / IDEO.org 3 phases / IDEO U 7 phases) are pedagogical groupings of the same underlying activities: understand people (empathize / inspiration / frame+gather), synthesize and define the problem (define / ideation-synthesis / synthesize-for-action), generate options (ideate / ideation-solutions / generate), make things tangible (prototype / implementation / make tangible), learn through testing (test / implementation / test-to-learn). [SYNTHESIS] — these three fetched pages do not themselves explicitly reconcile the counts; the mapping above is my inference from the definitions each page gives.

Important nuance: all three sources explicitly describe the process as non-linear. IDEO U: "The process isn't strictly linear — teams may revisit phases multiple times and move between them as needed." [VERIFIED] (IDEO U page).

---

## 6. Jobs-to-be-Done

### Christensen (Christensen Institute)

Core principle: *"People don't simply buy or pick products or services; they pull them into their lives to make progress."* JTBD is described as "a lens that reveals the circumstances — or forces — that drive people and organizations toward and away from decisions," encompassing functional, social, and emotional dimensions. [VERIFIED] [Jobs to Be Done — Christensen Institute](https://www.christenseninstitute.org/theory/jobs-to-be-done/) (accessed 2026-04-24).

**The milkshake example** (from the same page): a fast-food chain discovered customers "hired" milkshakes for different purposes by time of day — morning commuters for hunger and entertainment; afternoon parents as a treat for kids. The milkshake's real competitors were bananas and bagels, not other shakes. [VERIFIED] (same source).

> The Christensen Institute page does not explicitly attribute this framing to Christensen by name on the sections quoted. The attribution is well established in secondary sources and in Christensen's *Competing Against Luck* (2016) — not fetched this session, so direct textual attribution to Christensen personally is **[UNVERIFIED]** here.

The 2016 HBR article "Know Your Customers' 'Jobs to Be Done'" by Christensen, Hall, Dillon, and Duncan exists and is dated September 2016 — verified from article metadata. The body is paywalled on HBR; the visible excerpt notes "84% of global executives reported that innovation was extremely important to their growth strategies, but a staggering 94% were dissatisfied with their organizations' innovation performance" [Know Your Customers' Jobs to Be Done — HBR, 2016](https://hbr.org/2016/09/know-your-customers-jobs-to-be-done) (accessed 2026-04-24). [VERIFIED — title, authors, date, opening statistics; body text paywalled and not quoted here]

### Ulwick — Outcome-Driven Innovation (ODI)

Ulwick's definition: *"people buy products and services to get a job done"* — and markets should be defined around "a group of people pursuing a shared functional goal, not around products or demographics." [VERIFIED] [Jobs-to-be-Done — Strategyn / Tony Ulwick](https://strategyn.com/jobs-to-be-done/) (accessed 2026-04-24).

Three principles:
1. Jobs remain stable while products change.
2. Customer needs are quantifiable.
3. Innovation succeeds when solutions perform "20%+ better" than alternatives.

[VERIFIED] (same source).

**ODI phases:**
1. Define the customer and core functional job (in solution-free language).
2. Uncover needs via qualitative research and **job mapping**.
3. Gather quantitative data on **importance** and **satisfaction** for each need.
4. Discover hidden segments with distinct unmet needs.
5. Formulate market strategy (Growth Strategy Matrix).
6. Formulate product strategy aligned to unmet outcomes.

[VERIFIED] (same source).

### Attribution note

Christensen popularized JTBD in mainstream business writing (his *HBR* work, *Competing Against Luck*); Ulwick asserts priority on significant portions of the underlying methodology. The two strands are sometimes described as a common theory with two schools; a definitive reconciliation is outside what was fetched this session. [CONTESTED] — flag for further research.

---

## 7. Dual-track development (Patton)

**Definition.** Dual-track development "combines two concurrent types of work within a single agile product development process: discovery and development." [VERIFIED] [Dual-Track Development — Jeff Patton, 2017 (updated 2023)](https://jpattonassociates.com/dual-track-development/) (accessed 2026-04-24).

**Discovery track:** focuses on "fast learning and validation"; irregular, short cycle lengths (hours to days); hypothesis testing; often kills ideas instead of building them.

**Development track:** focuses on "predictability and quality"; predictable sprint cycles; produces potentially shippable software.

[VERIFIED] (same source).

**Attribution.** Patton credits Desirée Sy's 2007 paper *"Adapting Usability Investigations for Agile User-Centered Design"* as the original formulation. He quotes Sy: *"Although the dual tracks depicted seem separate, in reality, designers need to communicate every day with developers."* [VERIFIED] (same source).

**Core principle** (Patton's own framing): *"Discovery and development are shown in two tracks because they're two kinds of work, and two kinds of thinking"* — the point is not to create separate silos but to recognize they involve the whole team. [VERIFIED] (same source).

---

## Sources (all accessed 2026-04-24)

- [Product Discovery — Teresa Torres, 2021](https://www.producttalk.org/2021/08/product-discovery/)
- [Continuous Discovery — Teresa Torres, 2021](https://www.producttalk.org/continuous-discovery/)
- [Opportunity Solution Tree — Teresa Torres, 2023](https://www.producttalk.org/opportunity-solution-tree/)
- [The Only Thing That Matters — Marc Andreessen, 2007](https://pmarchive.com/guide_to_startups_part4.html)
- [Principles — The Lean Startup, Eric Ries](https://theleanstartup.com/principles)
- [The Lean Startup (home) — Eric Ries](https://theleanstartup.com/)
- [Know Your Customers' Jobs to Be Done — HBR, 2016 (metadata only; paywalled)](https://hbr.org/2016/09/know-your-customers-jobs-to-be-done)
- [Jobs to Be Done — Christensen Institute](https://www.christenseninstitute.org/theory/jobs-to-be-done/)
- [Jobs-to-be-Done — Strategyn / Tony Ulwick](https://strategyn.com/jobs-to-be-done/)
- [Design Thinking Bootleg — Stanford d.school, 2018](https://dschool.stanford.edu/resources/design-thinking-bootleg)
- [Getting Started With Design — Stanford d.school](https://dschool.stanford.edu/resources/getting-started-with-design-thinking)
- [Human-Centered Design — IDEO.org Design Kit](https://www.designkit.org/human-centered-design.html)
- [What Is Design Thinking? — IDEO U, 2025](https://www.ideou.com/blogs/inspiration/what-is-design-thinking)
- [Dual-Track Development — Jeff Patton, 2017/2023](https://jpattonassociates.com/dual-track-development/)
- [The Four Big Risks — Marty Cagan, SVPG, 2017](https://www.svpg.com/four-big-risks/)
- [Product Discovery — Marty Cagan, SVPG, 2007](https://www.svpg.com/product-discovery/)

## Open questions

- [RESOLVED 2026-04-24] Cagan / SVPG primary sources (four risks; discovery vs. delivery) — now cited directly from svpg.com pages fetched via curl.
- HBR 2016 Christensen article header + opening statistics verified via the HBR landing page this session; the article body proper remains paywalled.
- Problem/solution fit canonical definition (likely Ash Maurya *Running Lean* or Steve Blank) — not yet fetched.
- Full Bootleg PDF content for per-mode definitions at Stanford d.school.
- Christensen vs. Ulwick attribution dispute — needs a neutral secondary source with citations if we want to take a position.
