# 00 — Industry Research and Benchmarks

**Question:** What empirical research and industry reports anchor modern PDLC claims, and what do they actually say?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. DORA — DevOps Research and Assessment

### 1.1 What DORA is

DORA describes itself as "the largest and longest running research program of its kind, that seeks to understand the capabilities that drive software delivery and operations performance" [dora.dev — homepage](https://dora.dev/) (accessed 2026-04-24).

Origin: DORA was founded by Nicole Forsgren and Gene Kim in 2015 and was acquired by Google in 2018 [WebSearch summary — DORA / Accelerate background](https://en.wikipedia.org/wiki/DevOps_Research_and_Assessment) (accessed 2026-04-24 via search).

### 1.2 The Four Keys (and now a Fifth)

The DORA Four Keys — the foundational metrics for software delivery performance — are defined on the DORA guide page [DORA — Metrics for software delivery performance](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24), with the following verbatim definitions:

- **Deployment Frequency** — "The number of deployments over a given period or the time between deployments."
- **Change Lead Time** — "The amount of time it takes for a change to go from committed to version control to deployed in production."
- **Change Failure Rate** — "The ratio of deployments that require immediate intervention following a deployment. Likely resulting in a rollback of the changes or a 'hotfix' to quickly remediate any issues."
- **Failed Deployment Recovery Time** — "The time it takes to recover from a deployment that fails and requires immediate intervention."

The DORA page also notes an evolution to a five-metric model, adding **deployment rework rate** ("The ratio of deployments that are unplanned but happen as a result of an incident in production") [DORA — Four Keys](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24).

A classical grouping, restated by the 2024 report: deployment frequency and change lead time measure throughput; change failure rate and failed deployment recovery time measure stability [DORA 2024 Report — dora.dev/research/2024/dora-report](https://dora.dev/research/2024/dora-report/) (accessed 2026-04-24).

### 1.3 DORA capabilities

DORA publishes a catalog of capabilities — practices that correlate with high software delivery performance — organized into Core (technical and process), AI, and uncategorized organizational categories, totaling 37 capabilities on the page at the time of access [DORA — Capabilities](https://dora.dev/capabilities/) (accessed 2026-04-24).

### 1.4 The 2024 Accelerate State of DevOps Report

Title: "Accelerate State of DevOps Report 2024" [DORA 2024 Report — dora.dev](https://dora.dev/research/2024/dora-report/) (accessed 2026-04-24). The Google Cloud announcement blog notes this marks the 10th anniversary of DORA's investigation [Announcing the 2024 DORA report — Google Cloud Blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2024-dora-report) (accessed 2026-04-24).

Authors, per the announcement: Nathen Harvey (DORA Lead) and Derek DeBellis (Researcher) [Announcing the 2024 DORA report — Google Cloud Blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2024-dora-report) (accessed 2026-04-24).

Key findings, per the announcement blog:

- More than 75% of respondents rely on AI for at least one daily professional responsibility.
- More than 33% experienced "moderate" to "extreme" productivity increases from AI.
- A 25% increase in AI adoption correlated with a 7.5% improvement in documentation quality, 3.4% in code quality, and 3.1% in code review speed.
- AI adoption was also associated with a 1.5% decrease in delivery throughput, 7.2% reduction in delivery stability, and 39% of respondents reporting little to no trust in AI-generated code.
- Platform engineering increases developer productivity but may cause temporary performance dips during implementation, and is more prevalent in larger organizations.

[Announcing the 2024 DORA report — Google Cloud Blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2024-dora-report) (accessed 2026-04-24).

The dora.dev research page identifies six major insights: AI amplifies productivity at some stability cost; user-centric approaches drive quality; organizational priority instability harms productivity; platform engineering requires stability management; transformational leadership reduces burnout; cloud infrastructure flexibility correlates with success [DORA 2024 Report — dora.dev](https://dora.dev/research/2024/dora-report/) (accessed 2026-04-24).

[VERIFIED] The 2024 report PDF (fetched directly 2026-04-24) states: "This year, nearly 3,000 working professionals from a variety of industries around the world shared their experiences." Cumulatively over a decade of DORA research, "We have heard from more than 39,000 professionals working at organizations of every size and across many different industries globally." ([2024 Accelerate State of DevOps Report PDF — services.google.com, pp. 3, 84](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

[VERIFIED] The 2024 report confirms the four-tier model re-emerged: Elite (19% of respondents, 89% CI 18–20%), High (22%, 21–23%), Medium (35%, 33–36%), Low (25%, 23–26%). Tier thresholds for change lead time, deployment frequency, change failure rate, and failed deployment recovery time are given verbatim in `06-release/dora-metrics.md` ([2024 Accelerate State of DevOps Report PDF — services.google.com, p. 13](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

[VERIFIED] DORA's fifth metric is named **rework rate** (not "reliability"). The 2024 report groups rework rate with change failure rate as the two stability metrics, and positions change lead time, deployment frequency, and failed deployment recovery time as the three throughput metrics ([2024 Accelerate State of DevOps Report PDF — services.google.com, p. 11](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

### 1.5 Accelerate (the book)

*Accelerate: The Science of Lean Software and DevOps: Building and Scaling High Performing Technology Organizations* was published March 2018 by Nicole Forsgren (PhD), Jez Humble, and Gene Kim, through IT Revolution Press [Accelerate — itrevolution.com](https://itrevolution.com/product/accelerate/) (accessed 2026-04-24); O'Reilly's mirror confirms "Publication Date: March 2018," "ISBN: 9781457191435," 288 pages [Accelerate — oreilly.com/library/view](https://www.oreilly.com/library/view/accelerate/9781457191435/) (accessed 2026-04-24).

Research base, per the publisher page: "four years of groundbreaking research ... including data collected from the State of DevOps reports conducted with Puppet," using rigorous statistical methods [Accelerate — itrevolution.com](https://itrevolution.com/product/accelerate/) (accessed 2026-04-24). The O'Reilly preview re-states the same: the book is based on "a four-year study using rigorous statistical methods to identify what drives high-performing teams" [Accelerate — oreilly.com](https://www.oreilly.com/library/view/accelerate/9781457191435/) (accessed 2026-04-24). [VERIFIED] on the four-year research basis; the survey-respondent total (~23,000 data points from "a variety of companies of various different sizes") is described at this level in the Wikipedia article on the book [Accelerate (book) — Wikipedia](https://en.wikipedia.org/wiki/Accelerate_(book)) (accessed 2026-04-24) [SYNTHESIS — Wikipedia is secondary; primary book text was not directly read].

**24 capabilities framework.** [VERIFIED via Wikipedia-secondary of the book]: Accelerate identifies "24 practices to improve software delivery which they refer to as 'key capabilities'" grouped into five categories — Continuous Delivery (8 practices), Architecture (2), Product and Process (4), Lean Management and Monitoring (5), and Cultural (5) [Accelerate (book) — Wikipedia](https://en.wikipedia.org/wiki/Accelerate_(book)) (accessed 2026-04-24). The live DORA capabilities catalog has since expanded (39 capabilities in Core / AI / General categories as of 2026-04-24) [DORA — Capabilities](https://dora.dev/capabilities/) (accessed 2026-04-24).

**Predictive framing (primary source).** DORA's own research page states the program "applies behavioral science methodology to uncover the predictive pathways which connect ways of working, via software delivery performance, to organizational goals and individual well-being," and that the 2015 findings established "High-performing IT organizations consistently outperform their counterparts in terms of four key software delivery metrics" [DORA — Research](https://dora.dev/research/) (accessed 2026-04-24). Nicole Forsgren's professional research page lists the contemporaneous peer-reviewed companion papers: Forsgren et al. 2017 "DORA Platform: DevOps Assessment and Benchmarking" (International Conference on Design Science Research); Forsgren & Kersten 2018 "DevOps Metrics" in *ACM Queue* 15(6) (cross-published in CACM); Forsgren, Rothenberger, Humble, Thatcher, Smith 2020 "A Taxonomy of Software Delivery Performance Profiles" (AMCIS 2020) [Nicole Forsgren — Research page](https://nicolefv.com/research) (accessed 2026-04-24).

The book won the Shingo Institute Publication Award [Accelerate — itrevolution.com](https://itrevolution.com/product/accelerate/) (accessed 2026-04-24).

---

## 2. Stack Overflow Developer Survey

The 2024 Stack Overflow Developer Survey collected responses in May 2024 from "over 65,000 developers," specifically 65,437 respondents from 185 countries [2024 Stack Overflow Developer Survey](https://survey.stackoverflow.co/2024/) (accessed 2026-04-24).

Selected verbatim top-lines from the site:

- "62.3% Have used JavaScript in the past year."
- 49% of developers use PostgreSQL — "the most popular database for the second year in a row."
- "76% of all respondents are using or are planning to use AI tools in their development process."
- "70% of professional developers do not perceive AI as a threat to their job."
- "84% of respondents are working: either part-time, freelancing, or full-time."
- "66% of developers have a BA/BS or MA/MS degree despite only 49% of developers learning to code at school."

[2024 Stack Overflow Developer Survey](https://survey.stackoverflow.co/2024/) (accessed 2026-04-24).

Methodology: respondents were recruited primarily through Stack Overflow's own channels — onsite messaging, blog posts, email/newsletter subscribers, banner ads, social media [WebSearch summary — 2024 survey methodology](https://survey.stackoverflow.co/2024/methodology) (accessed 2026-04-24 via search; direct fetch not performed).

**Caveat on use.** The Stack Overflow survey is a self-selected opt-in panel skewed toward Stack Overflow's user base (web/full-stack/back-end; 185 countries but with Europe overrepresented among the top-responding countries per the search summary) and should be treated as popularity signal among engaged Stack Overflow users, not a probability sample of the global developer population. [SYNTHESIS] from the methodology recruitment channels and the reported response distribution.

---

## 3. Thoughtworks Technology Radar

The Thoughtworks Technology Radar is described on the publisher's site as "a twice-yearly snapshot of tools, techniques, platforms, languages and frameworks" based on Thoughtworks' global teams' experience [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar) (accessed 2026-04-24).

Structure:

- Four **quadrants**: Techniques, Platforms, Tools, Languages and Frameworks.
- Four **rings** (recommendation levels): Adopt, Trial, Assess, Hold. (The page fetched labeled the fourth ring "Caution"; Thoughtworks' long-running convention is "Hold" — the access visit captured a summary wording rather than the full legend; this is [CONTESTED / UNVERIFIED] until the legend page is fetched.)

Published by the Thoughtworks Technology Advisory Board, led by CTO Rachel Laycock [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar) (accessed 2026-04-24).

Most recent volume at time of access: Volume 34, April 2026 [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar) (accessed 2026-04-24).

**Caveat on use.** The Radar reflects a single consulting firm's experience across its engagements; it is a strong opinion signal but is not a random sample of industry practice [SYNTHESIS — stated by the Radar's own framing that it is based on Thoughtworks' teams' experience].

---

## 4. How to use this research downstream

- Use DORA metrics when defining success measures for delivery-stage documents (06-release, 07-operations). Cite the DORA guide page directly rather than third-party summaries where possible.
- Use Scrum Guide wording (not paraphrase) for role/event/artifact definitions in stage docs that touch planning (02-planning) and development (04-development).
- Use Agile Manifesto and Principles as first-principles references — they are short, stable, and directly quotable.
- Use Stack Overflow Survey as a popularity/sentiment signal, not as a causal claim source.
- Use Thoughtworks Radar as an opinion signal; when a specific technology's maturity is load-bearing to a claim, cite Thoughtworks plus at least one other independent source.
- Use ISO/IEC/IEEE 12207 and 15288 when a claim depends on the standards' formal process definitions. Fetch IEEE SA or a licensed copy; the ISO.org pages are paywalled and 403 to unauthenticated fetches.

---

## Sources

- [dora.dev — DORA homepage](https://dora.dev/) (accessed 2026-04-24)
- [DORA — Metrics for software delivery performance (Four Keys)](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)
- [DORA — Research index](https://dora.dev/research/) (accessed 2026-04-24)
- [DORA — Capabilities catalog](https://dora.dev/capabilities/) (accessed 2026-04-24)
- [DORA 2024 Report — dora.dev/research/2024/dora-report/](https://dora.dev/research/2024/dora-report/) (accessed 2026-04-24)
- [2024 Accelerate State of DevOps Report PDF — services.google.com](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)
- [Announcing the 2024 DORA report — Google Cloud Blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2024-dora-report) (accessed 2026-04-24)
- [Accelerate — IT Revolution Press product page](https://itrevolution.com/product/accelerate/) (accessed 2026-04-24)
- [Accelerate — O'Reilly Library mirror](https://www.oreilly.com/library/view/accelerate/9781457191435/) (accessed 2026-04-24)
- [Accelerate (book) — Wikipedia](https://en.wikipedia.org/wiki/Accelerate_(book)) (accessed 2026-04-24)
- [Nicole Forsgren — Research page (peer-reviewed companion papers)](https://nicolefv.com/research) (accessed 2026-04-24)
- [2024 Stack Overflow Developer Survey](https://survey.stackoverflow.co/2024/) (accessed 2026-04-24)
- [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar) (accessed 2026-04-24)

## Open questions

- The Thoughtworks Radar ring wording ("Hold" vs "Caution") needs resolution by fetching the legend page directly.
- ~~A primary copy of the Accelerate research methodology~~ — **PARTIALLY RESOLVED 2026-04-24 verification pass 3.** The four-year research basis is VERIFIED directly from the IT Revolution publisher page and the O'Reilly mirror. The 24-capabilities / five-categories structure and the "~23,000 data points" research base are VERIFIED via the Wikipedia article on the book (secondary but specific). DORA's own research page is the primary source for the "predictive pathways" framing and the 2015 "four key metrics" finding. The book's full text and appendix statistical methods remain unread in this session; the ACM Queue "DevOps Metrics" article (Forsgren & Kersten 2018) returned HTTP 403 both directly and via dl.acm.org; Wayback Machine is unreachable from this environment.
