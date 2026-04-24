# Stage 02: Planning & Prioritization

**Question:** What are the industry-accepted practices, frameworks, and canonical sources for product planning, prioritization, roadmapping, estimation, and goal-setting in software product development?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

This stage sits between ideation (discovery) and design/development. It translates validated problems and a product vision into ordered, estimable work that teams can execute. Topics covered below, with separate sibling files for depth:

- Product strategy and vision — this file (section 1)
- Roadmapping — this file (section 2); see also `roadmaps.md`
- Prioritization frameworks — see `prioritization.md`
- OKRs — see `okrs.md`
- Estimation — see `estimation.md`
- Backlog management, sprint planning, release planning, capacity/velocity — this file (sections 3–6)

The document uses the tagging system defined in `/Users/nile/Projects/pdlc/CLAUDE.md`: [VERIFIED], [SYNTHESIS], [UNVERIFIED], [CONTESTED], [OUT OF DATE].

---

## 1. Product Strategy and Vision

### 1.1 Why planning starts with vision and strategy

Planning in the sense of "what should we build next quarter?" is downstream of two earlier questions: *where are we going* (vision) and *how will we get there* (strategy). Both Marty Cagan (Silicon Valley Product Group) and Richard Rumelt make a strong form of this point.

[VERIFIED] Marty Cagan draws a sharp line between vision and strategy. In an interview with Mind the Product, he states: "Vision is describing your destination... it's all about how are you going to make your customers' lives better." He continues: "Product strategy is very different... It's like, okay, that sounds awesome. How in the world are we going to do that?" ([Product vision and strategy – Marty Cagan on The Product Experience – Mind the Product, n.d.](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/) (accessed 2026-04-24))

[VERIFIED] Cagan describes the time horizon of vision as "five to 10 years out. So it's not something you're going to deliver tomorrow" ([Mind the Product interview, n.d.](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/) (accessed 2026-04-24)). In Product Compass's summary of Cagan's work, the product vision is "the future you are trying to create and, most importantly, how this vision will improve the lives of your customers," while product strategy "is all about which problems are the most important to solve" and its "core output is a set of business or customer problems to solve (team objectives)" ([Product Model First Principles In Depth: Product Team and Product Strategy — Product Compass, n.d.](https://www.productcompass.pm/p/product-model-first-principles-transformed-cagan) (accessed 2026-04-24)).

[VERIFIED] Cagan emphasizes a cadence difference: strategy is "a living thing... we are explicitly revisiting it every quarter" ([Mind the Product, n.d.](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/) (accessed 2026-04-24)).

### 1.2 Rumelt's kernel of good strategy

[VERIFIED] Richard Rumelt's 2011 book *Good Strategy Bad Strategy: The Difference and Why It Matters* frames strategy as a three-part "kernel": (1) a **diagnosis** that identifies the nature of the challenge, (2) a **guiding policy** for dealing with the challenge, and (3) a set of **coherent actions** designed to carry out the guiding policy. Rumelt identifies weak diagnosis as "the most common cause of bad strategy," and another common failure as "confusing goals with strategy" ([Good Strategy, Bad Strategy — Lenny's Newsletter, n.d.](https://www.lennysnewsletter.com/p/good-strategy-bad-strategy-richard) (accessed 2026-04-24)).

[VERIFIED] Rumelt's own phrasing of the three components, via Farnam Street's primer on strategy: the guiding policy is "the approach to dealing with the obstacles called out in the diagnosis. It is like a signpost, marking the direction forward but not defining the details of the trip"; coherent actions are "feasible coordinated policies, resource commitments, and actions designed to carry out the guiding policy" ([A Primer on Strategy — Farnam Street (Shane Parrish)](https://fs.blog/a-primer-on-strategy/) (accessed 2026-04-24)).

[VERIFIED] Rumelt's McKinsey Quarterly article "The Perils of Bad Strategy" (2011, Issue 1, pp. 30–39) was adapted from the book and is an independent primary-source-equivalent for the same framework; it is referenced throughout the strategy literature ([McKinsey Quarterly, 2011](https://www.mckinsey.com/capabilities/strategy-and-corporate-finance/our-insights/the-perils-of-bad-strategy) (article page did not render cleanly via WebFetch/curl in this session — publication existence confirmed via Wikipedia's Rumelt entry and SCIRP reference database)).

[SYNTHESIS] Combining Cagan and Rumelt: a product plan (roadmap, OKRs, sprint backlog) is only trustworthy if it traces back to a clear diagnosis of the user/market problem, a stated policy for addressing it, and a set of coherent actions. Feature lists that skip diagnosis are the "bad strategy" that Rumelt warns about; the planning artifacts below are tools for expressing coherent actions given a guiding policy.

---

## 2. Roadmapping

See also `roadmaps.md` for extended treatment.

### 2.1 Now / Next / Later

[VERIFIED] The Now/Next/Later roadmap format was created by Janna Bastow in 2012 while building ProdPad. In her own words: "The Now-Next-Later roadmap exists because timeline roadmaps aren't effective, simple as that." The three columns: **Now** items are "clearly defined, much more detailed, and completely spec'd out"; **Next** items have "fewer specifics and details" since they're "not right in front of you yet"; **Later** items are "big boulder blocks that you can see in the distance but don't need to break down yet" ([Why I Invented the Now-Next-Later Roadmap — Janna Bastow, ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/) (accessed 2026-04-24)).

Bastow's critique of date-based (Gantt-style) roadmaps: they produce "endlessly shifting deadlines," damaged team morale from missed targets, and a "feature factory" disconnected from strategy. Fixed dates are, in her framing, "an illusion" ([ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/) (accessed 2026-04-24)).

### 2.2 Theme-based roadmaps

[VERIFIED] ProdPad positions theme-based roadmaps as communicating "problems to be solved" rather than feature lists, using the Now-Next-Later structure. They quote Jared Spool's framing that themes are "a promise to solve problems, not build features," and Teresa Torres: "Rather than sharing feature lists with the rest of the company, we should be communicating how we will make decisions" ([Theme-Based Product Roadmaps — ProdPad, n.d.](https://www.prodpad.com/blog/how-to-build-a-product-roadmap-everyone-understands/) (accessed 2026-04-24)).

### 2.3 Outcome-based vs. feature-based

[VERIFIED] Teresa Torres (Product Talk) draws the outcome/output distinction precisely: "Business outcomes measure the health of the business. Product outcomes measure a change in customer behavior." She argues product teams "do have the ability to directly influence product outcomes—changes in customer behavior—that can ultimately contribute to business outcomes," but typically cannot directly move business metrics ([Ask Teresa: What's the Difference Between OKRs and Outcomes? — Teresa Torres, Product Talk, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/) (accessed 2026-04-24)).

Torres argues the reorientation "Instead of: 'We are building output X because we think it will result in outcome Y,' we start with: 'We want outcome Y, how might we get there?'" because "the real value of starting with an outcome is it helps us focus on value creation rather than just output creation" ([Product Talk, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/) (accessed 2026-04-24)).

[SYNTHESIS] Across Bastow, Torres, ProdPad, and Cagan, a consistent picture: modern roadmaps express problems/outcomes at coarse time horizons rather than dated features. Quarterly/annual Gantt roadmaps persist in many organizations; the above sources argue against them but the practice is not uniform. [CONTESTED] — the industry is not unified here.

---

## 3. Backlog Management

### 3.1 Product Backlog (Scrum Guide)

[VERIFIED] The 2020 Scrum Guide defines the Product Backlog as "an emergent, ordered list of what is needed to improve the product. It is the single source of work undertaken by the Scrum Team" ([The 2020 Scrum Guide — Schwaber & Sutherland, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

The Scrum Guide further defines **Product Backlog refinement** as "the act of breaking down and further defining Product Backlog items into smaller more precise items" and "an ongoing activity to add details, such as a description, order, and size" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

The **Product Goal** "describes a future state of the product which can serve as a target for the Scrum Team to plan against" and is "the long-term objective for the Scrum Team" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

[VERIFIED] Accountability: "The Product Owner is accountable for maximizing the value of the product resulting from the work of the Scrum Team." The Product Owner is accountable for "effective Product Backlog management" including "Developing and explicitly communicating the Product Goal," "Creating and clearly communicating Product Backlog items," "Ordering Product Backlog items," and "ensuring that the Product Backlog is transparent, visible and understood" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

[VERIFIED] Notably, the Scrum Guide does *not* prescribe how items should be ordered — only that they must be. It also makes **no mention of velocity**; on capacity it notes only that "the more the Developers know about their past performance, their upcoming capacity, and their Definition of Done, the more confident they will be in their Sprint forecasts" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)). This is a frequently under-appreciated fact: velocity is *not* a Scrum artifact.

### 3.2 Refinement / grooming

[SYNTHESIS] "Grooming" is an older colloquial term; the 2020 Scrum Guide uses "refinement." The practice — incremental breakdown and estimation of backlog items ahead of sprint planning — is described in the Scrum Guide as "an ongoing activity" rather than a separate ceremony (see verified quote above).

---

## 4. Iteration / Sprint Planning

### 4.1 Scrum Guide specifics

[VERIFIED] "Sprint Planning initiates the Sprint by laying out the work to be performed for the Sprint. This resulting plan is created by the collaborative work of the entire Scrum Team" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

Sprint Planning addresses three topics ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)):

1. **Why is this Sprint valuable?** — the Product Owner explains how the product gains value, and the team collaborates to "define a Sprint Goal that communicates why the Sprint is valuable to stakeholders."
2. **What can be Done this Sprint?** — "the Developers select items from the Product Backlog to include in the current Sprint."
3. **How will the chosen work get done?** — "Developers plan the work necessary to create an Increment that meets the Definition of Done... by decomposing Product Backlog items into smaller work items of one day or less."

Outputs: "The Sprint Goal, the Product Backlog items selected for the Sprint, plus the plan for delivering them are together referred to as the Sprint Backlog." Timebox: "Sprint Planning is timeboxed to a maximum of eight hours for a one-month Sprint" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

**Sprint** itself: "Sprints are the heartbeat of Scrum, where ideas are turned into value. They are fixed length events of one month or less to create consistency." **Sprint Backlog** composition: "the Sprint Goal (why), the set of Product Backlog items selected for the Sprint (what), as well as an actionable plan for delivering the Increment (how)" ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

### 4.2 Kanban and WIP limits

[VERIFIED] The *Kanban Guide* (co-published by Prokanban.org / Kanban community) defines Kanban as "a strategy for optimizing the flow of value through a process" comprising three practices: (1) defining and visualizing workflow, (2) actively managing items in a workflow, and (3) improving the workflow ([The Kanban Guide — Kanbanguides.org, 2025](https://kanbanguides.org/english/) (accessed 2026-04-24)).

On WIP limits: "Kanban system members must explicitly control the number of work items in a workflow from started to finished." Controlling WIP creates a pull system where work is selected only when capacity exists. Flow is defined as "the movement of potential value through a system." The four mandatory flow metrics are WIP, Throughput, Work Item Age, and Cycle Time ([Kanban Guide, 2025](https://kanbanguides.org/english/) (accessed 2026-04-24)).

[SYNTHESIS] Scrum and Kanban differ structurally: Scrum uses a timeboxed Sprint with a fixed commitment (Sprint Backlog forecast); Kanban uses continuous flow with explicit WIP limits. Teams commonly combine them ("Scrumban"), but the two guides are distinct documents with different emphases.

---

## 5. Release Planning

### 5.1 Sprint planning vs. release planning

[SYNTHESIS] The Scrum Guide (2020) defines Sprint Planning (above) but does *not* define "release planning" as a formal event; earlier Scrum literature used the term more often. In continuous-delivery environments, release becomes a separate concern from iteration (see Stage 06 of this research).

### 5.2 Quarterly planning cycles

[VERIFIED] SAFe's **Planning Interval (PI)** is "a cadence-based timebox in which Agile Release Trains deliver continuous value to customers in alignment with PI Objectives," typically an "8 to 12-week timebox" consisting of "four or five development iterations, followed by an Innovation and Planning (IP) iteration" ([Planning Interval — Scaled Agile Framework, n.d.](https://framework.scaledagile.com/program-increment/) (accessed 2026-04-24)). Note: SAFe renamed Program Increment to Planning Interval; both terms appear in older documentation.

[SYNTHESIS] Quarterly planning is also implicit in OKR practice (see `okrs.md`) and in Cagan's assertion that "we are explicitly revisiting [product strategy] every quarter" ([Mind the Product, n.d.](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/) (accessed 2026-04-24)). A quarterly cadence is therefore common across disparate frameworks, though neither Scrum nor the Kanban Guide require it.

---

## 6. Capacity and Velocity

### 6.1 What velocity is

[VERIFIED] Mike Cohn offers two complementary definitions: "Velocity measures how much functionality a team delivers in a sprint" and "Velocity measures a team's ability to turn ideas into new functionality in a sprint." He emphasizes: "The most important thing is to clarify with everyone on the team, including the product owner and ScrumMaster, is exactly what your team means when they use the term 'velocity'" ([Know Exactly What Velocity Means to Your Scrum Team — Mike Cohn, Mountain Goat Software, n.d.](https://www.mountaingoatsoftware.com/blog/know-exactly-what-velocity-means-to-your-scrum-team) (accessed 2026-04-24)).

### 6.2 Velocity-driven vs. capacity-driven sprint planning

[VERIFIED] Cohn describes velocity-driven sprint planning as "based on the premise that the amount of work a team will do in the coming sprint is roughly equal to what they've done in prior sprints" ([Velocity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software, n.d.](https://www.mountaingoatsoftware.com/blog/velocity-driven-sprint-planning) (accessed 2026-04-24)).

In capacity-driven planning, the team identifies tasks and roughly estimates hours, then asks "Can we commit to this?" Story points/velocity play a role only as a sanity check at the end ([Capacity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software, n.d.](https://www.mountaingoatsoftware.com/blog/capacity-driven-sprint-planning) (accessed 2026-04-24)).

### 6.3 Misuse of velocity

[VERIFIED] The Scrum Guide (2020) does not mention velocity at all ([Scrum Guide, 2020](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)). [SYNTHESIS] This is a strong signal that velocity is an emergent team metric, not a Scrum artifact, and treating it as a fixed productivity KPI (for cross-team comparison, incentive, or headcount decisions) diverges from the framework that produced it. The #NoEstimates movement (see `estimation.md`) takes this critique further.

---

## Methodology

Primary sources were located via targeted search queries and fetched directly:

- Scrum: `scrumguides.org/scrum-guide.html` (multiple passes for different sections)
- Kanban: `kanbanguides.org/english/`
- RICE: `intercom.com/blog/rice-simple-prioritization-for-product-managers/`
- OKRs: `whatmatters.com`, `whatmatters.com/faqs/okr-meaning-definition-example`, `whatmatters.com/resources/google-okr-playbook`
- SAFe: `framework.scaledagile.com/wsjf/`, `framework.scaledagile.com/program-increment/`
- Cagan: `mindtheproduct.com` interview; `productcompass.pm` summary. svpg.com was initially blocked (HTTP 403 via WebFetch) but re-fetched successfully via curl on 2026-04-24 for `svpg.com/product-discovery/` and `svpg.com/four-big-risks/` — see `01-ideation/discovery.md` §2 for the verified SVPG quotes.
- Bastow: `prodpad.com/blog/invented-now-next-later-roadmap/`
- Torres: `producttalk.org/2023/03/okrs-vs-outcomes/`
- Cohn: `mountaingoatsoftware.com/blog/what-are-story-points`, `mountaingoatsoftware.com/blog/the-main-benefit-of-story-points`, `mountaingoatsoftware.com/blog/know-exactly-what-velocity-means-to-your-scrum-team`, `mountaingoatsoftware.com/blog/velocity-driven-sprint-planning`, `mountaingoatsoftware.com/blog/capacity-driven-sprint-planning`
- Planning poker: `en.wikipedia.org/wiki/Planning_poker`
- Kano: `en.wikipedia.org/wiki/Kano_model`, kanomodel.com (homepage fetched; detail pages 403/404)
- MoSCoW: `en.wikipedia.org/wiki/MoSCoW_method`
- Rumelt: `lennysnewsletter.com/p/good-strategy-bad-strategy-richard`
- ICE: `itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/`
- Cost of Delay: `en.wikipedia.org/wiki/Cost_of_delay`
- NoEstimates: `infoq.com/articles/book-review-noestimates/`

Fetches that failed in this session (403/404) and were therefore *not* cited as if read: svpg.com article pages, mountaingoatsoftware.com/blog/velocity-is-killing-agility, producttalk.org/product-roadmaps, productplan.com/glossary/now-next-later-roadmap, productplan.com/learn/agile-release-planning, kanomodel.com/discover-the-kano-model, asq.org/quality-resources/kano-model, agilealliance.org/glossary/moscow, whatmatters.com/resources/google-okr-playbook (second attempt), mountaingoatsoftware.com/agile/topics/planning-poker.

---

## Sources

All URLs below were fetched in this session on 2026-04-24.

1. [The 2020 Scrum Guide — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html)
2. [RICE: Simple Prioritization for Product Managers — Intercom (Sean McBride)](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/)
3. [What Matters — homepage](https://www.whatmatters.com/)
4. [What Matters — OKR meaning, definition, example](https://www.whatmatters.com/faqs/okr-meaning-definition-example)
5. [Weighted Shortest Job First — Scaled Agile Framework](https://framework.scaledagile.com/wsjf/)
6. [Planning Interval — Scaled Agile Framework](https://framework.scaledagile.com/program-increment/)
7. [Product vision and strategy – Marty Cagan on The Product Experience — Mind the Product](https://www.mindtheproduct.com/product-vision-and-strategy-marty-cagan-on-the-product-experience-part-1-of-2/)
8. [Product Model First Principles In Depth: Product Team and Product Strategy — Product Compass](https://www.productcompass.pm/p/product-model-first-principles-transformed-cagan)
9. [Why I Invented the Now-Next-Later Roadmap — Janna Bastow, ProdPad, 2022](https://www.prodpad.com/blog/invented-now-next-later-roadmap/)
10. [Theme-Based Product Roadmaps — ProdPad](https://www.prodpad.com/blog/how-to-build-a-product-roadmap-everyone-understands/)
11. [Ask Teresa: What's the Difference Between OKRs and Outcomes? — Teresa Torres, Product Talk, 2023](https://www.producttalk.org/2023/03/okrs-vs-outcomes/)
12. [What Are Story Points and Why Do We Use Them? — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/what-are-story-points)
13. [The Main Benefit of Story Points — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/the-main-benefit-of-story-points)
14. [Know Exactly What Velocity Means to Your Scrum Team — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/know-exactly-what-velocity-means-to-your-scrum-team)
15. [Velocity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/velocity-driven-sprint-planning)
16. [Capacity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/capacity-driven-sprint-planning)
17. [Planning poker — Wikipedia](https://en.wikipedia.org/wiki/Planning_poker)
18. [Kano model — Wikipedia](https://en.wikipedia.org/wiki/Kano_model)
19. [MoSCoW method — Wikipedia](https://en.wikipedia.org/wiki/MoSCoW_method)
20. [Cost of delay — Wikipedia](https://en.wikipedia.org/wiki/Cost_of_delay)
21. [Good Strategy, Bad Strategy — Lenny's Newsletter on Rumelt (2011)](https://www.lennysnewsletter.com/p/good-strategy-bad-strategy-richard)
21a. [A Primer on Strategy — Farnam Street (Shane Parrish)](https://fs.blog/a-primer-on-strategy/) — corroborates Rumelt kernel with direct quotes on guiding policy and coherent action.
22. [The Tool That Will Help You Choose Better Product Ideas — Itamar Gilad](https://itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/)
23. [Q&A with Vasco Duarte on the #NoEstimates Book — InfoQ](https://www.infoq.com/articles/book-review-noestimates/)
24. [The Kanban Guide — Kanbanguides.org, 2025](https://kanbanguides.org/english/)
25. [Kano Model — kanomodel.com (homepage)](https://kanomodel.com/)

---

## Open Questions

- [UNVERIFIED] Bruce McCarthy's specific framing of product roadmap alternatives: the original task named him alongside ProductPlan/SVPG/Torres, but I was unable to fetch a primary source by McCarthy in this session. His book *Product Roadmaps Relaunched* is referenced widely, but I have not verified a quote.
- [PARTIAL RESOLUTION 2026-04-24] SVPG pages `svpg.com/product-discovery/` and `svpg.com/four-big-risks/` were successfully re-fetched via curl and are now cited in `01-ideation/discovery.md`. The vision- and strategy-specific SVPG pages (e.g., svpg.com/product-vision-faq/, svpg.com/vision-vs-strategy/) were not retried this verification pass; Cagan's vision/strategy positions continue to rely on the Mind the Product interview and Product Compass summary.
- [UNVERIFIED] The exact "five benefits" or "playbook" text from What Matters beyond the fetched pages. Google's internal OKR playbook is summarized in a cached page but the primary Google document is not re-verified in this session.
- [UNVERIFIED] The exact text of the Kano Model as written by Noriaki Kano (1984 original Japanese-language paper). Wikipedia and kanomodel.com homepage were used; the primary paper itself was not fetched.
- [PARTIAL RESOLUTION 2026-04-24 verification pass 3] Richard Rumelt's exact phrasing from the book — Lenny's Newsletter and Farnam Street (fs.blog/a-primer-on-strategy/) both now cite Rumelt verbatim on the three kernel components (guiding policy: "signpost, marking the direction forward…"; coherent actions: "feasible coordinated policies, resource commitments, and actions…"). The McKinsey Quarterly 2011 article adaptation exists but did not render via WebFetch this pass. If the book text is needed for load-bearing decisions, consult the book directly.
- [OUT OF DATE RISK] Story point / velocity pages from Mountain Goat do not carry visible dates in the fetch — Cohn has updated these over many years. Treat the conceptual claims as durable but verify any numeric claim against the page currently served.
