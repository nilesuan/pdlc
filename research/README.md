# Research — Software Product Development Life Cycle (PDLC)

**Scope:** Document the industry-grade end-to-end life cycle for building, shipping, operating, and maintaining software products.

**Rules:** All content in this folder must follow [`../CLAUDE.md`](../CLAUDE.md): verified sources only, explicit uncertainty tags, no fabrication. Any claim without a fetched source is tagged `[UNVERIFIED]`, `[SYNTHESIS]`, `[CONTESTED]`, or `[OUT OF DATE]`.

**Last updated:** 2026-04-24
**Overall status:** Draft — initial research pass complete. Each stage has been researched against primary sources; remaining open questions are consolidated below for a verification pass.

---

## Index

### 00 — Overview & Lifecycle Frameworks [`00-overview/`](00-overview/)
- [`README.md`](00-overview/README.md) — PDLC vs SDLC, stage map, orientation
- [`models.md`](00-overview/models.md) — Waterfall, V-Model, Spiral, Iterative, Agile, Scrum, XP, Kanban, Lean, DevOps/CD, Lean Startup
- [`frameworks.md`](00-overview/frameworks.md) — SAFe, LeSS, Disciplined Agile, ISO/IEC/IEEE 12207 & 15288
- [`industry-research.md`](00-overview/industry-research.md) — DORA, Accelerate, Stack Overflow Survey, Thoughtworks Radar

### 01 — Ideation & Discovery [`01-ideation/`](01-ideation/)
- [`README.md`](01-ideation/README.md) — stage overview
- [`discovery.md`](01-ideation/discovery.md) — Torres continuous discovery, Cagan, Lean Startup, Andreessen PMF, Design Thinking, JTBD, dual-track
- [`user-research.md`](01-ideation/user-research.md) — NN/g methods catalog, personas, journey maps
- [`requirements.md`](01-ideation/requirements.md) — IEEE 29148, user stories (Cohn), 3 C's, INVEST, story mapping, opportunity solution trees

### 02 — Planning & Prioritization [`02-planning/`](02-planning/)
- [`README.md`](02-planning/README.md) — vision, backlog, sprint planning, Kanban WIP, release planning
- [`roadmaps.md`](02-planning/roadmaps.md) — Now/Next/Later, theme-based, outcome-based
- [`prioritization.md`](02-planning/prioritization.md) — RICE, MoSCoW, Kano, ICE, WSJF, Cost of Delay
- [`okrs.md`](02-planning/okrs.md) — OKRs (Doerr, Grove, Google)
- [`estimation.md`](02-planning/estimation.md) — story points, Planning Poker, #NoEstimates, velocity

### 03 — Design & Architecture [`03-design/`](03-design/)
- [`README.md`](03-design/README.md) — stage index, cross-cutting findings
- [`system-architecture.md`](03-design/system-architecture.md) — styles (monolith, microservices, event-driven, serverless), DDD, C4, NFRs
- [`adrs.md`](03-design/adrs.md) — Nygard template, ADR community patterns
- [`api-design.md`](03-design/api-design.md) — REST (Fielding), GraphQL, gRPC, Google/Microsoft API guidelines
- [`security-design.md`](03-design/security-design.md) — OWASP threat modelling, STRIDE, ASVS, Top 10
- [`ux-design.md`](03-design/ux-design.md) — design thinking, prototyping, Nielsen heuristics, design systems, WCAG/ADA/EAA
- [`design-docs-rfcs.md`](03-design/design-docs-rfcs.md) — Google design docs, Oxide RFDs, comparisons

### 04 — Development [`04-development/`](04-development/)
- [`README.md`](04-development/README.md) — index and cross-cutting observations
- [`version-control.md`](04-development/version-control.md) — Git, Git Flow, GitHub Flow, GitLab Flow, Trunk-Based Development, DORA findings
- [`code-review.md`](04-development/code-review.md) — Google's code-review guide, pair/mob programming
- [`coding-practices.md`](04-development/coding-practices.md) — TDD, BDD, refactoring, Clean Architecture, style guides, SonarQube
- [`documentation.md`](04-development/documentation.md) — Diátaxis, code-as-docs, OpenAPI, dev containers

### 05 — Testing & Quality [`05-testing/`](05-testing/)
- [`README.md`](05-testing/README.md) — stage overview, primary-sources index
- [`test-models.md`](05-testing/test-models.md) — pyramid (Cohn/Fowler), trophy (Dodds), honeycomb
- [`test-levels.md`](05-testing/test-levels.md) — unit, integration, contract (Pact), E2E, ATDD
- [`test-automation.md`](05-testing/test-automation.md) — automation principles, flakiness, coverage
- [`non-functional-testing.md`](05-testing/non-functional-testing.md) — performance (k6/JMeter/Gatling), OWASP security, WCAG/axe, usability
- [`quality-engineering.md`](05-testing/quality-engineering.md) — shift-left, QA vs QE, DORA test-automation capability
- [`chaos-and-production-testing.md`](05-testing/chaos-and-production-testing.md) — Principles of Chaos, Netflix, canary, dark launch, A/B
- [`exploratory-and-context-driven.md`](05-testing/exploratory-and-context-driven.md) — Bach, Kaner, CDT 7 principles
- [`test-data-and-environments.md`](05-testing/test-data-and-environments.md) — TDM, synthetic data, PII

### 06 — Release & Deployment [`06-release/`](06-release/)
- [`README.md`](06-release/README.md) — index and synthesis
- [`cicd.md`](06-release/cicd.md) — CI, Continuous Delivery vs Deployment, pipelines, GitHub Actions / GitLab CI / Jenkins
- [`deployment-strategies.md`](06-release/deployment-strategies.md) — blue-green, canary, rolling, shadow/dark, rollback
- [`feature-flags.md`](06-release/feature-flags.md) — Hodgson taxonomy, progressive delivery, SemVer, Keep a Changelog
- [`dora-metrics.md`](06-release/dora-metrics.md) — DORA four/five keys, DB migrations, expand/contract, pt-osc/gh-ost, SLSA, SBOM

### 07 — Operations & Reliability [`07-operations/`](07-operations/)
- [`README.md`](07-operations/README.md) — DevOps culture, on-call, runbooks, capacity, DR, chaos, FinOps, platform engineering, Team Topologies
- [`sre.md`](07-operations/sre.md) — SLIs/SLOs/SLAs, error budgets, toil
- [`observability.md`](07-operations/observability.md) — three pillars, OpenTelemetry, Four Golden Signals, USE, RED
- [`incident-response.md`](07-operations/incident-response.md) — ICS, PagerDuty roles, postmortem culture, LFI movement
- [`security-ops.md`](07-operations/security-ops.md) — NIST CSF 2.0 six functions, OWASP Top 10 2021

### 08 — Maintenance & Evolution [`08-maintenance/`](08-maintenance/)
- [`README.md`](08-maintenance/README.md) — Lehman's laws, ISO/IEC 14764 categories, refactoring-at-scale, feedback-loop framing
- [`technical-debt.md`](08-maintenance/technical-debt.md) — Cunningham OOPSLA '92, Fowler quadrant, Tornhill
- [`bug-management.md`](08-maintenance/bug-management.md) — severity vs priority, CVSS, SLA framing
- [`dependency-management.md`](08-maintenance/dependency-management.md) — SemVer, Dependabot, Renovate, left-pad/SolarWinds/Log4Shell
- [`deprecation.md`](08-maintenance/deprecation.md) — RFC 8594 Sunset, Stripe/GitHub API versioning, Strangler Fig
- [`feedback-loops.md`](08-maintenance/feedback-loops.md) — NPS, CES, CSAT, retrospectives, PDCA, Toyota Kata
- [`security-patching.md`](08-maintenance/security-patching.md) — CVE, CVSS v4.0, coordinated disclosure, NIST SP 800-40 Rev. 4

---

## Volume & sourcing

- **51 documents**, ~75,000 words across 9 stages.
- **Primary sources fetched and cited** in this research pass: ~220 unique URLs across agents (aggregate, with some overlap across stages).
- Every factual claim is either cited inline to a URL fetched in this pass, or tagged with an explicit uncertainty marker per [`../CLAUDE.md`](../CLAUDE.md).

## Key open questions (verification pass needed)

These items were flagged by the research agents as not fully verified from primary sources in this pass. They should be resolved in a follow-up pass, either by fetching the source, finding an alternative, or confirming the claim should be left as `[UNVERIFIED]` / removed.

**Primary sources blocked / paywalled / not fetched this pass:**
- ~~Royce 1970 "Managing the Development of Large Software Systems"~~ — **RESOLVED in verification pass 2026-04-24:** fetched from `raw.githubusercontent.com/tpn/pdfs/master/Managing%20the%20Development%20of%20Large%20Software%20Systems%20-%201970%20(waterfall).pdf`. Royce's "I believe in this concept, but the implementation described above is risky and invites failure" critique and the five improvements (preliminary program design, document the design, do it twice, plan/control/monitor testing, involve the customer) are now VERIFIED directly.
- ISO official standards pages (iso.org) — HTTP 403 throughout. **IEEE SA landing pages for 12207:2017, 15288:2023, and 29148:2018 were re-fetched on 2026-04-24 in the Standards & Formal References verification pass**; their full titles, publication dates, and supersession status are now `[VERIFIED]` (12207:2017 is "Superseded by 12207-2026"). **ISO/IEC 14764:2022** text remains paywalled, but the four maintenance-category definitions (corrective, adaptive, perfective, preventive) are now `[VERIFIED]` via Wikipedia's citation chain to peer-reviewed textbooks (Varga 2018; Tripathy & Naik 2014). **ISO/IEC 25010:2023** primary text remains paywalled; the revision's nine-characteristic structure (Safety added; Usability → Interaction Capability; Portability → Flexibility) is `[VERIFIED]` via arc42 and SARM write-ups of the 2023 release.
- ~~SVPG / Marty Cagan site — HTTP 403 throughout~~ — **RESOLVED 2026-04-24 Modern Industry Sources verification pass:** `svpg.com/four-big-risks/` (Cagan 2017) and `svpg.com/product-discovery/` (Cagan 2007) fetched directly via curl. Four-risk list (value/usability/feasibility/business viability) and Cagan's own framing of product discovery are now cited verbatim in `01-ideation/discovery.md`. Vision/strategy-specific SVPG pages were not retried this pass.
- Primary books not fetched directly: ~~Doerr *Measure What Matters*~~, ~~Grove *High Output Management*~~, ~~Rumelt's strategy book~~, ~~Reinertsen on cost of delay~~, ~~McCarthy *Product Roadmaps Relaunched*~~, ~~Accelerate (Forsgren/Humble/Kim) full text~~.
  - **Doerr *Measure What Matters* (2018) — RESOLVED 2026-04-24 verification pass 3:** all three load-bearing claims attributed to the book are `[VERIFIED]` via Doerr's companion site whatmatters.com. Specifically: (a) "Objective + 3–5 Key Results" structure via `/faqs/how-many-okrs-to-have` (verbatim: "a maximum of three Objectives, each with 3-5 Key Results"); (b) Drucker→Grove→Doerr→Google lineage via `/articles/the-origin-story` and `/faqs/okr-meaning-definition-example`; (c) CFR = Conversations/Feedback/Recognition framework via `/resources/difference-between-okr-cfr` with verbatim component definitions. Book text itself not fetched. Documented in `research/02-planning/okrs.md`.
  - **Grove *High Output Management* (1983) — RESOLVED 2026-04-24 verification pass 3:** the book text itself was not fetched, but the attribution of the OKR predecessor framework (Grove's MBO/iMBO, "Key Results" coined by Grove) to this specific book is `[VERIFIED]` via (a) Wikipedia's High Output Management entry citing the book directly ("introduces Grove's 'management by objective' approach, also known as the objectives and key results (OKR) framework") and (b) Ben Horowitz's 2015 foreword to the Vintage reprint (a16z.com/2015/11/13/high-output-management/). Documented in `research/02-planning/okrs.md`.
  - **Rumelt *Good Strategy Bad Strategy* (2011) — RESOLVED 2026-04-24 verification pass 3:** the kernel (diagnosis + guiding policy + coherent action) is `[VERIFIED]` via two independent secondaries that quote Rumelt directly — Farnam Street's "A Primer on Strategy" (fs.blog/a-primer-on-strategy/) with verbatim Rumelt quotes on guiding policy ("signpost, marking the direction forward…") and coherent action ("feasible coordinated policies, resource commitments, and actions…"), plus Lenny's Newsletter summary. The McKinsey Quarterly 2011 adaptation URL exists on mckinsey.com but did not render via WebFetch/curl this pass (timeout / HTTP/2 INTERNAL_ERROR). Documented in `research/02-planning/README.md` §1.2.
  - **Reinertsen *Principles of Product Development Flow* (2009) — RESOLVED 2026-04-24 verification pass 3:** "If you only quantify one thing, quantify the Cost of Delay" maxim and the "85% of product managers don't know the Cost of Delay" empirical claim are `[VERIFIED]` via two independent secondaries (SAFe's WSJF extended-guidance page and InfoQ's 2015 coverage of Joshua Arnold's Lean Kanban France 2014 workshop). Book title and subtitle (*Second Generation Lean Product Development*) confirmed via Reinertsen's own consulting site reinertsenassociates.com/books/ (accessed 2026-04-24 via curl -k due to expired TLS cert). Book text itself not fetched. Documented in `research/02-planning/prioritization.md` §5–6.
  - **McCarthy et al. *Product Roadmaps Relaunched* (2017) — RESOLVED 2026-04-24 verification pass 3:** authors (Lombardo, McCarthy, Ryan, Connors), publisher (O'Reilly Media, October 2017), ISBN (9781491971710), core argument, and three outcome-theme section headings ("Vision Is the Outcome You Seek" Ch 4; "Outcome Versus Output" Ch 4; "Themes Are About Outcomes, Not Outputs" Ch 5) now `[VERIFIED]` via the O'Reilly Library preview chapters plus the ProductPlan book review carrying verbatim quotations. Five-component roadmap (Vision, Business Objectives, Themes, Timeframes, Disclaimer) also VERIFIED via Chapter 2 preview. Full interior chapter prose remains paywalled. Documented in `research/02-planning/roadmaps.md` §2.
  - **Accelerate (Forsgren/Humble/Kim 2018) — PARTIALLY RESOLVED 2026-04-24 verification pass 3:** four-year research base VERIFIED via IT Revolution and O'Reilly mirror; 24-capabilities / five-category structure (Continuous Delivery 8, Architecture 2, Product and Process 4, Lean Management and Monitoring 5, Cultural 5) VERIFIED via Wikipedia article on the book; predictive-pathways framing VERIFIED via DORA's own `research/` page ("applies behavioral science methodology to uncover the predictive pathways which connect ways of working, via software delivery performance, to organizational goals"); peer-reviewed companion papers inventoried via Forsgren's own research page (Forsgren/Kersten "DevOps Metrics" ACM Queue 15(6) 2018; Forsgren et al. 2017 DORA Platform DSR paper; Forsgren et al. *Taxonomy of Software Delivery Performance Profiles* AMCIS 2020). Book internal verbatim quotations and the statistical appendix remain unread; the ACM Queue full-text article returned HTTP 403 at both queue.acm.org and dl.acm.org this session. Documented in `research/00-overview/industry-research.md` §1.5 and `research/06-release/dora-metrics.md`.
  - **Beck *TDD By Example* (2003) — PARTIALLY RESOLVED 2026-04-24 Development Classics verification pass:** Red-Green-Refactor cycle, "Fake It (till you make it)", "Obvious Implementation," and "Triangulation" now `[VERIFIED]` via (a) Beck's own 2023 Substack "Canon TDD" (tidyfirst.substack.com/p/canon-tdd) for the design-practice framing and canonical cycle, and (b) Stanislaw Pankevich's 2016 annotated notes (stanislaw.github.io) which quote the book verbatim. The book itself is still not fetched directly.
  - **Martin *Clean Code* (2008) — PARTIALLY RESOLVED 2026-04-24:** SOLID and SRP are now `[VERIFIED]` via Martin's own cleancoder.com posts (2014 SRP post, 2020 "Solid Relevance") — and these correctly attribute SOLID to Martin's earlier principles work (late-1990s / *Agile Software Development: Principles, Patterns, and Practices* 2002), **not** to *Clean Code*. Misattribution of SOLID to *Clean Code* has been corrected in `research/04-development/coding-practices.md`. Dan Abramov's 2020 "Goodbye, Clean Code" critique (overreacted.io) is now `[VERIFIED]` and cited. Book-internal claims (function-length rules, "comments are failure" stance) remain `[UNVERIFIED]`.
  - **Feathers *Working Effectively with Legacy Code* (2004) — PARTIALLY RESOLVED 2026-04-24:** book's structural anchors (Ch. 4 "The Seam Model", Part III "Dependency Breaking Techniques") and Feathers' seam definitions/types (preprocessing/link/object, with his stated hierarchy) are now `[VERIFIED]` via the Pearson/InformIT product page and a book-excerpt article on InformIT (article p=359417). The widely-cited "legacy code = code without tests" definition line itself was not extracted from a fetched page and remains `[UNVERIFIED]` until a publisher preface excerpt is captured.
  - **Kerth *Project Retrospectives* (2001) — RESOLVED 2026-04-24:** publication details (Dorset House, 2001, ISBN 978-0-932633-44-6, foreword by Gerald M. Weinberg) and the Prime Directive's exact wording are now `[VERIFIED]` via the Dorset House publisher page and retrospectivewiki.org. Both sources independently confirm the Directive quotation. Cited in `research/08-maintenance/feedback-loops.md` §6 and `research/08-maintenance/README.md` §5.
- HBR articles (Reichheld NPS body, ~~Dixon/Freeman/Toman CES body~~, Christensen JTBD body) — gated. **NPS formula now VERIFIED via Bain & Company (Reichheld's firm)** rather than Wikipedia. **CES — RESOLVED 2026-04-24 verification pass 3** via MeasuringU (Jeff Sauro): CES 1.0 question ("How much effort did you personally have to put forth to handle your request?"), 5-point scale, mean formula; CES 2.0 7-point agree/disagree scale and top-3-box scoring; Matt Dixon's own attribution to CEB (later Gartner) cross-verified via i-scoop.eu and 360 Magazine 2020 interviews. The 75,000-respondent figure from the HBR article body remains [SYNTHESIS] — HBR page is paywalled, figure triangulates across multiple independent summaries. Christensen HBR 2016 title/authors/date/opening-statistics verified via landing page.
- ~~Microsoft Research code-review study (Bacchelli & Bird, ICSE 2013) — not fetched~~ — **PARTIALLY RESOLVED 2026-04-24:** Microsoft Research landing-page abstract fetched; findings (reviews deliver knowledge-transfer more than defect-finding; understanding is the bottleneck) now VERIFIED from abstract. Full PDF text remained unparseable via WebFetch.
- ~~Etsy "blameless postmortems" 2012 post and learningfromincidents.io — not cleanly fetched.~~ — **PARTIALLY RESOLVED 2026-04-24 Modern Industry Sources verification pass:** `etsy.com/codeascraft/blameless-postmortems` still HTTP 403; `learningfromincidents.io` still TLS internal error. However, Allspaw's own 2013 kitchensoap.com companion post ("Learning from Failure at Etsy") was fetched via curl and carries the same Just Culture / blameless argument; verbatim quotes now in `07-operations/incident-response.md`. LFI community site remains unreachable.
- ~~`diataxis.fr` returned 403~~ — **RESOLVED 2026-04-24 Modern Industry Sources verification pass:** all five canonical pages (`/`, `/tutorials/`, `/how-to-guides/`, `/reference/`, `/explanation/`) fetched via curl. Verbatim per-type definitions (learning-oriented / goal-oriented / information-oriented / understanding-oriented) now in `04-development/documentation.md`.
- `docs.gitlab.com` returned 403 / auth-gated; mirrored via GitHub and about.gitlab.com.
- CISA / `cisa.gov/sbom` — still HTTP 403 on 2026-04-24 Modern Industry Sources verification pass (both `/sbom` and `/topics/cyber-threats-and-advisories/sbom`); Wayback Machine not accessible from this environment. Continuing to lean on NTIA.
- ~~Potvin/Levenberg Google monorepo paper (CACM) — abstract only~~ — **PARTIALLY RESOLVED 2026-04-24:** CACM and dl.acm.org fulltext URLs still returned HTTP 403, but the specific statistics (~25,000 developers, ~1B LOC, 35M commits, 15M LOC/week, 86TB) are now VERIFIED via two independent summaries of the paper (alastairreid.github.io and AcaWiki). **Corrected a factual error**: trunkbaseddevelopment.com's "35,000-developer" phrasing was inconsistent with the paper's ~25,000 figure; corrected in `04-development/version-control.md` and `08-maintenance/README.md`.
- NIST SP 800-40 Rev. 4 — primary PDF still binary to WebFetch. **In verification pass 2026-04-24**, the four "execute the risk response" phases (**Prepare** → **Implement** → **Verify** → **Continuously monitor**) are now `[VERIFIED]` via two independent secondary summaries (Meditology Services and Peter A. Clarke) that agree on the phase names. Wording is at the summary level, not direct quotation from the NIST document.

**Attribution uncertainties (status after Attribution-Mysteries verification pass 2026-04-24):**
- ~~Dark-launch origin at Facebook/Flickr — commonly stated but unverified~~ — **RESOLVED and CORRECTED 2026-04-24.** Verified origin is the Facebook Chat 2008 post by Eugene Letuchy ([engineering.fb.com, 13 May 2008](https://engineering.fb.com/2008/05/13/web/facebook-chat/)), which introduces the term "dark launch" verbatim. The common Flickr attribution is **incorrect** — the 2009 "Flipping Out" post ([code.flickr.net, 2 Dec 2009](https://code.flickr.net/2009/12/02/flipping-out/)) introduces "flags" and "flippers" (feature flags) but does not use the phrase "dark launch." Correction applied to `06-release/deployment-strategies.md`.
- ~~James Governor RedMonk "progressive delivery" 2018 post — returned 404~~ — **RESOLVED 2026-04-24** via contemporaneous secondary primaries. SD Times 2018 coverage directly references and quotes Governor's August 2018 RedMonk post; IT Revolution's "Four A's" article confirms Governor/Harrison/Waterhouse/Zimman framework. The original RedMonk URL still 404s. Updated `06-release/feature-flags.md`.
- ~~Google "35,000-developer monorepo" count~~ — **RESOLVED 2026-04-24 as CONTESTED with both sides cited.** trunkbaseddevelopment.com explicitly states "35000 developers and QA automators"; Potvin & Levenberg CACM 2016 gives ~25,000 engineers (via research.google and AcaWiki). Both counts now documented with the scope difference explained in `04-development/version-control.md`.
- ~~Woody Zuill canonical mob-programming definition~~ — **RESOLVED 2026-04-24.** Verified verbatim at mobprogramming.org: "All the brilliant people working on the same thing, at the same time, in the same space, and on the same computer." Updated `04-development/code-review.md`.
- ~~Larry Smith "shift-left" Dr. Dobb's 2001 article — only via Wikipedia~~ — **RESOLVED 2026-04-24.** Verified verbatim via the jacobfilipp.com DDJ mirror ([article mirror](https://jacobfilipp.com/DrDobbs/articles/DDJ/2001/0109/0109e/0109e.htm)); ACM DL metadata (DOI 10.5555/500399.500404) confirms venue/author/year. Updated `05-testing/quality-engineering.md`.
- ~~"PDLC" as a term has no ISO/IEEE anchor distinct from SDLC~~ — **RESOLVED 2026-04-24.** No ISO/IEC/IEEE standard defines PDLC for software; AIPMM's ProdBOK uses "product management lifecycle" rather than "PDLC" explicitly; PMBOK is project- not product-oriented. PDLC is documented as an industry convention rather than a standardized term. Updated `00-overview/README.md`.
- **Vincent Driessen GitFlow 2020 update — RE-VERIFIED 2026-04-24.** Closing sentence re-verified verbatim: "Always remember that panaceas don't exist. Consider your own context. Don't be hating. Decide for yourself." Updated `04-development/version-control.md`.

**Recency gaps:**
- ~~OWASP Top 10: 2021 used with `[OUT OF DATE]` flag; 2025 final list not yet available on fetched pages~~ — **RESOLVED in verification pass 2026-04-24:** `owasp.org/Top10/2025/` and `owasp.org/Top10/2025/0x00_2025-Introduction/` both fetched. Top 10:2025 is the 8th installment; full A01–A10 list documented in `07-operations/security-ops.md` along with 2021 → 2025 deltas. Individual per-category pages not yet drilled.
- ~~DORA fifth metric (Rework Rate / Reliability)~~ — **RESOLVED 2026-04-24 Modern Industry Sources verification pass:** the 2024 Accelerate State of DevOps Report PDF (`services.google.com/fh/files/misc/2024_final_dora_report.pdf`) was fetched and read directly. The fifth metric is named **rework rate** (not "reliability"). 2024 respondent count ("nearly 3,000 working professionals"), decade cumulative (>39,000), and verbatim tier thresholds for Elite/High/Medium/Low are now cited in `06-release/dora-metrics.md` and `00-overview/industry-research.md`.
- ~~Microsoft REST API Guidelines vNext replacement page — not fetched~~ — **RESOLVED 2026-04-24:** deprecation of the top-level `Guidelines.md` is `[VERIFIED]`; the two replacements are the **Azure REST API Guidelines** (`microsoft/api-guidelines vNext/azure/Guidelines.md`, last change 2025-Mar-28) for Azure data-plane APIs, and the **Microsoft Graph REST API Guidelines** (`microsoft/api-guidelines vNext/graph/GuidelinesGraph.md`). Documented in `03-design/api-design.md` §4.2.
- ~~Current ISO/IEC 25010 revision vs 2011 — iso25000.com and Wikipedia disagree; flagged `[CONTESTED]`~~ — **RESOLVED 2026-04-24:** the 2023 revision is current; iso25000.com reflects the new layout, Wikipedia's main body had not yet been updated to cover it. Documented in `03-design/system-architecture.md` §6.1.
- ~~Current Netflix Simian Army 2011 blog post — TLS error~~ — **RESOLVED 2026-04-24 Modern Industry Sources verification pass:** fetched via curl -k from `netflixtechblog.com/the-netflix-simian-army-16e57fbab116`. Verbatim descriptions of all eight Simians named in the original post (Chaos Monkey, Latency Monkey, Conformity Monkey, Doctor Monkey, Janitor Monkey, Security Monkey, 10-18 Monkey, Chaos Gorilla) and authors (Yury Izrailevsky, Ariel Tseitlin; published 2011-07-19) now in `05-testing/chaos-and-production-testing.md`.

## Conventions

Each stage document follows this structure:

- **Question** — the specific question the document answers
- **Status** — Draft / Reviewed / Verified
- **Last updated** — YYYY-MM-DD
- **Body** — content with inline citations `[Title — Author/Org, Year](URL) (accessed 2026-04-24)` and uncertainty tags (`[VERIFIED]`, `[SYNTHESIS]`, `[UNVERIFIED]`, `[CONTESTED]`, `[OUT OF DATE]`)
- **Sources** — every URL fetched with access date
- **Open questions** — what remains unverified
