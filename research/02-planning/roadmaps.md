# Roadmapping

**Question:** What forms do product roadmaps take in modern software product practice, where did the dominant formats come from, and how does outcome-based roadmapping differ from feature-based?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. The Now / Next / Later roadmap

### Origin

[VERIFIED] The Now/Next/Later roadmap was created by Janna Bastow in 2012 while building ProdPad. Her stated motivation: "The Now-Next-Later roadmap exists because timeline roadmaps aren't effective, simple as that" ([Why I Invented the Now-Next-Later Roadmap — Janna Bastow, ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/) (accessed 2026-04-24)).

### Column semantics

[VERIFIED] The three columns escalate in definition as they get closer to delivery ([Bastow, ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/) (accessed 2026-04-24)):

- **Now** — "clearly defined, much more detailed, and completely spec'd out"; granular work pieces ready for immediate action.
- **Next** — "fewer specifics and details" since they're "not right in front of you yet."
- **Later** — "big boulder blocks that you can see in the distance but don't need to break down yet"; the "undefined future."

### Critique of date-based roadmaps

[VERIFIED] Bastow argues deadline-driven approaches produce: "endlessly shifting deadlines," damaged team morale from missed targets, and a "feature factory" disconnected from strategy. Fixed dates represent "an illusion" that slows rather than accelerates progress ([Bastow, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/) (accessed 2026-04-24)).

[SYNTHESIS] The core insight is an epistemic one: confidence in what should be built decreases rapidly with time-distance. Gantt-style roadmaps imply equal confidence across months/quarters, which is typically false. Now/Next/Later is a visualization that refuses to express more precision than the team has.

---

## 2. Theme-based roadmaps

[VERIFIED] ProdPad positions theme-based roadmaps as communicating "problems to be solved" rather than feature lists. They cite Jared Spool's framing that themes are "a promise to solve problems, not build features," and Teresa Torres: "Rather than sharing feature lists with the rest of the company, we should be communicating how we will make decisions" ([Theme-Based Product Roadmaps — ProdPad](https://www.prodpad.com/blog/how-to-build-a-product-roadmap-everyone-understands/) (accessed 2026-04-24)).

[VERIFIED] Each initiative under a theme should answer three questions (per ProdPad): *What are we doing? Why are we doing it? How does this connect to our OKRs?* ([ProdPad](https://www.prodpad.com/blog/how-to-build-a-product-roadmap-everyone-understands/) (accessed 2026-04-24)).

### Lombardo, McCarthy, Ryan & Connors — *Product Roadmaps Relaunched* (2017, O'Reilly)

[VERIFIED via publisher and O'Reilly ToC] *Product Roadmaps Relaunched: How to Set Direction while Embracing Uncertainty* was published in October 2017 by O'Reilly Media (ISBN 9781491971710), authored by C. Todd Lombardo, Bruce McCarthy, Evan Ryan, and Michael Connors. The book's core argument is that roadmaps are strategic alignment tools, not release schedules, and that "roadmaps should contextualize organizational plans within a broader strategic framework" rather than being detailed feature lists ([Product Roadmaps Relaunched — O'Reilly landing](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/) (accessed 2026-04-24); [Preface — O'Reilly mirror](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/preface01.html) (accessed 2026-04-24)).

[VERIFIED via Chapter 2 preview on O'Reilly] The book's five-component roadmap definition (Chapter 2, "Components of a Roadmap"): **Product Vision**, **Business Objectives**, **Themes**, **Timeframes**, and **Disclaimer**. The chapter opens with: "A document that can effectively rally your troops around a plan needs to be more than just a list of features and dates" ([Components of a Roadmap — oreilly.com/library/view/.../ch02.html](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/ch02.html) (accessed 2026-04-24)).

[VERIFIED via Chapter 4 ToC preview] Chapter 4 ("Establishing the Why with Product Vision and Strategy") contains the section heading **"Vision Is the Outcome You Seek"** and introduces the **"Outcome Versus Output"** distinction ([Ch 4 ToC — oreilly.com](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/ch04.html) (accessed 2026-04-24)).

[VERIFIED via Chapter 5 ToC on Ch 2 page] Chapter 5 ("Uncovering Customer Needs Through Themes") contains the section heading **"Themes Are About Outcomes, Not Outputs"**, which is the book's direct statement of the outcome-theme-based roadmap thesis (section heading visible in O'Reilly's chapter previews; full elaboration is paywalled).

[VERIFIED via ProductPlan review with book quotations] ProductPlan's review of the book quotes directly: "Properly done, a product roadmap can steer your entire organization toward delivery on the company strategy"; "A product vision should be about having an impact on the lives of the people your product serves, as well as your organization"; "When conditions in the environment change, your roadmap—like any living thing—must change as well in order to survive." ([Book Review: Product Roadmaps Relaunched — ProductPlan](https://www.productplan.com/learn/product-roadmaps-relaunched) (accessed 2026-04-24)).

[SYNTHESIS] Themes + Now/Next/Later compose: the rows in a theme-based roadmap are themes (strategic problems / outcomes), and the columns are Now/Next/Later time horizons. This combination is what ProdPad recommends and is consistent with what Torres, Cagan, and Lombardo/McCarthy/Ryan/Connors argue for — all four position the unit of the roadmap as a targeted outcome or customer problem, not a feature.

---

## 3. Outcome-based vs. feature-based roadmaps

### The core distinction

[VERIFIED] Teresa Torres: "Instead of: 'We are building output X because we think it will result in outcome Y,' we start with: 'We want outcome Y, how might we get there?'" because "the real value of starting with an outcome is it helps us focus on value creation rather than just output creation" ([Ask Teresa: OKRs vs. Outcomes — Product Talk, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/) (accessed 2026-04-24)).

[VERIFIED] Her two-tier definition: "Business outcomes measure the health of the business. Product outcomes measure a change in customer behavior" ([Torres, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/) (accessed 2026-04-24)). Product teams have direct influence over product outcomes, indirect influence at best over business outcomes.

### Implication for roadmaps

[SYNTHESIS] Combining Torres with Bastow: an outcome-based roadmap states targeted customer behavior changes (product outcomes) in each theme row rather than specific features. "Reduce signup drop-off from X% to Y%" is a roadmap entry; "Add social login buttons" is a candidate *solution* that might appear in discovery/delivery backlogs once a team is tasked with the outcome. Feature-based roadmaps pre-commit to solutions before discovery.

---

## 4. Product vision as the roadmap's anchor

[VERIFIED] Marty Cagan: "Vision is describing your destination... it's all about how are you going to make your customers' lives better." Its horizon: "five to 10 years out" ([Product vision and strategy — Mind the Product](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/) (accessed 2026-04-24)).

[VERIFIED] Cagan: product strategy "is all about which problems are the most important to solve," with a "core output [of] a set of business or customer problems to solve (team objectives)" ([Product Compass summary of Cagan](https://www.productcompass.pm/p/product-model-first-principles-transformed-cagan) (accessed 2026-04-24)).

[SYNTHESIS] The Vision → Strategy → Roadmap → Backlog chain:

1. Vision (5–10 yr) — the destination.
2. Strategy — the guiding policy and set of problems to solve (Rumelt's kernel; see `README.md` §1.2).
3. Roadmap (Now/Next/Later, theme-based, outcome-based) — how strategy is expressed at quarterly granularity.
4. Backlog — the detailed, ordered list of near-term work (Scrum Guide; see `README.md` §3).

Each layer commits to less precision than the one below it, and the cadence for revising each is longer. Rumelt's kernel (diagnosis → guiding policy → coherent actions) maps onto Vision → Strategy → Roadmap at a conceptual level.

---

## 5. Release-oriented planning

[VERIFIED] SAFe's Planning Interval (formerly Program Increment) is "a cadence-based timebox in which Agile Release Trains deliver continuous value to customers in alignment with PI Objectives," typically an "8 to 12-week timebox" consisting of "four or five development iterations, followed by an Innovation and Planning (IP) iteration" ([Planning Interval — Scaled Agile Framework](https://framework.scaledagile.com/program-increment/) (accessed 2026-04-24)).

[SYNTHESIS] The PI is what quarter-long "release planning" looks like in a scaled-agile context: a cross-team plan at roughly the same horizon as quarterly OKRs. For smaller organizations, the equivalent often collapses into a quarterly planning meeting tied to OKR setting.

---

## Open Questions

- ~~[UNVERIFIED] Bruce McCarthy's book *Product Roadmaps Relaunched*~~ — **RESOLVED 2026-04-24 verification pass 3.** Authors (Lombardo, McCarthy, Ryan, Connors), publisher (O'Reilly), publication date (October 2017), ISBN, core argument, five-component roadmap structure, and three crucial section headings ("Vision Is the Outcome You Seek", "Outcome Versus Output", "Themes Are About Outcomes, Not Outputs") are now VERIFIED via the O'Reilly Library preview chapters and the ProductPlan review. The full interior chapter elaboration remains paywalled; direct book quotations at length would require a licensed O'Reilly account.
- [UNVERIFIED] ProductPlan's own definition of Now/Next/Later — productplan.com pages returned 404 in this session. ProductPlan is the name of a vendor tool (distinct from ProdPad where Bastow works). Its marketing pages were not accessible in the original pass. (Note: productplan.com/learn/product-roadmaps-relaunched *is* accessible and was used as a secondary source for book quotations in §2.)
- [UNVERIFIED] Whether Bastow's 2012 invention claim is precisely correct (Gantt-style roadmap critiques predate her post; simpler three-column roadmaps may have appeared before 2012 under other names). Her claim was accepted as written.
- [SYNTHESIS caveats] The Vision → Strategy → Roadmap → Backlog chain is my synthesis combining Cagan, Rumelt, Bastow, Lombardo/McCarthy, and the Scrum Guide. Each layer is verified; the compositional claim is inference.

---

## Sources

All fetched on 2026-04-24.

1. [Why I Invented the Now-Next-Later Roadmap — Janna Bastow, ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/)
2. [Theme-Based Product Roadmaps — ProdPad](https://www.prodpad.com/blog/how-to-build-a-product-roadmap-everyone-understands/)
3. [Ask Teresa: OKRs vs. Outcomes — Teresa Torres, Product Talk, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/)
4. [Product vision and strategy — Marty Cagan on Mind the Product](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/)
5. [Product Model First Principles In Depth — Product Compass on Cagan](https://www.productcompass.pm/p/product-model-first-principles-transformed-cagan)
6. [Planning Interval — Scaled Agile Framework](https://framework.scaledagile.com/program-increment/)
7. [The 2020 Scrum Guide — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html)
8. [Good Strategy, Bad Strategy — Lenny's Newsletter on Rumelt (2011)](https://www.lennysnewsletter.com/p/good-strategy-bad-strategy-richard)
9. [Product Roadmaps Relaunched — O'Reilly Library landing (Lombardo, McCarthy, Ryan, Connors, October 2017, ISBN 9781491971710)](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/)
10. [Product Roadmaps Relaunched — Preface (O'Reilly Library mirror)](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/preface01.html)
11. [Product Roadmaps Relaunched — Chapter 2: Components of a Roadmap (O'Reilly Library mirror)](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/ch02.html)
12. [Product Roadmaps Relaunched — Chapter 4: Establishing the Why with Product Vision and Strategy (O'Reilly Library ToC)](https://www.oreilly.com/library/view/product-roadmaps-relaunched/9781491971710/ch04.html)
13. [Book Review: Key Takeaways from Product Roadmaps Relaunched — ProductPlan](https://www.productplan.com/learn/product-roadmaps-relaunched)
