# Stage 08 — Maintenance & Evolution

**Question:** Once software is in production, what determines whether it continues to serve users well, degrades, or is successfully evolved? What are the verified frameworks, standards, and practices for maintaining and evolving software over time?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

This stage covers what happens after software is live: how it must continuously adapt (Lehman), how the industry categorizes the work (ISO/IEC 14764), how technical debt accumulates and is managed, and how product teams close the loop back to discovery via customer feedback. Narrower topics are in sibling documents:

- `technical-debt.md` — Cunningham origin, Fowler quadrant, modern measurement.
- `bug-management.md` — severity vs. priority, bug lifecycle.
- `dependency-management.md` — semver, lockfiles, Dependabot/Renovate, supply-chain incidents.
- `deprecation.md` — RFC 8594 Sunset header, Stripe/GitHub API versioning, legacy modernization.
- `feedback-loops.md` — NPS, CES, CSAT, retrospectives, continuous improvement.

---

## 1. Lehman's Laws of Software Evolution

Meir M. Lehman (with Laszlo Belady) began formulating laws of software evolution in 1974, expanding them in 1978, 1991, and 1996. The laws apply specifically to **E-type programs** — software that solves real-world problems and is embedded in an operational environment that itself changes. [Lehman's laws of software evolution — Wikipedia](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) (accessed 2026-04-24). The canonical primary publication is: Lehman, M. M. (1980), "Programs, Life Cycles, and Laws of Software Evolution," *Proceedings of the IEEE*, 68(9), 1060–1076, DOI [10.1109/proc.1980.11805](https://doi.org/10.1109/proc.1980.11805). The primary IEEE paper was not directly fetched this session (IEEE Xplore URL returned 418 via WebFetch); exact wording below is `[VERIFIED]` against Wikipedia's article which quotes Lehman's formulations verbatim.

The eight laws as summarized by Wikipedia:

1. **Continuing Change (1974)** — an E-type system must be continually adapted or it becomes progressively less satisfactory.
2. **Increasing Complexity (1974)** — complexity increases unless work is done to maintain or reduce it.
3. **Self Regulation (1974)** — evolution processes are self-regulating.
4. **Conservation of Organisational Stability (1978)** — average effective global activity rate is invariant over system lifetime.
5. **Conservation of Familiarity (1978)** — incremental growth must be constrained by what teams/users can absorb.
6. **Continuing Growth (1991)** — functional content must be continually increased to maintain user satisfaction.
7. **Declining Quality (1996)** — quality will appear to decline unless the system is rigorously maintained and adapted to its environment.
8. **Feedback System (1996)** — E-type evolution processes are multi-level, multi-loop, multi-agent feedback systems.

[Lehman's laws of software evolution — Wikipedia](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) (accessed 2026-04-24).

**Implication for PDLC [SYNTHESIS]:** Laws 1, 2, 6, and 7 together imply that a running system in production cannot be in steady-state. Planning for maintenance, refactoring, and continued delivery is a requirement of the problem domain, not a sign of poor original design. This motivates treating Stage 08 as a continuous process rather than a terminal phase, and feeding observations back to Stage 01 (ideation).

---

## 2. Categories of Software Maintenance (ISO/IEC 14764)

The international standard ISO/IEC/IEEE 14764:2022 defines the software maintenance process within the software life cycle. It is listed on the ISO catalogue: [ISO/IEC/IEEE 14764:2022 Software engineering — Software life cycle processes — Maintenance — iso.org](https://www.iso.org/standard/80710.html) (accessed 2026-04-24 via search result metadata; standard itself paywalled). An earlier edition, ISO/IEC 14764:2006, is referenced by IEEE Std 14764-2006.

The standard categorizes maintenance into four types. The Wikipedia Software maintenance article paraphrases the standard with each definition traced to a peer-reviewed textbook citation:

- [VERIFIED] **Corrective maintenance** — "modification of software to fix a bug or other failure to meet requirements" (cited by Wikipedia to Varga 2018, p. 5) [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).
- [VERIFIED] **Adaptive maintenance** — "modification of software performed after delivery to ensure its continuing usability in a changed or changing environment" (Varga 2018, p. 5) [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).
- [VERIFIED] **Perfective maintenance** — "enhancement of software after delivery to improve qualities such as user experience, processing efficiency, and maintainability" (Tripathy & Naik 2014, p. 27) [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).
- [VERIFIED] **Preventive maintenance** — "forward-looking modification of software after delivery to ensure it continues to meet requirements or fix problems that have not manifested yet" (Tripathy & Naik 2014, p. 27) [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).

Per the same Wikipedia article: "Enhancement (perfective and adaptive combined) comprises approximately 80% of software maintenance work." [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).

The four-way split is commonly described along two dimensions — timing (reactive vs. proactive) and goal (correction vs. enhancement) — so that corrective and adaptive handle problems/environment shifts, while perfective and preventive invest in long-term quality. [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24). These definitions are `[VERIFIED]` through the Wikipedia citation chain to peer-reviewed textbooks (Varga 2018; Tripathy & Naik 2014), one step removed from the ISO/IEC 14764 standard text itself, which is paywalled.

**Budgeting implication [UNVERIFIED]:** Practitioners sometimes quote that a majority of post-release effort goes to maintenance, and that adaptive/perfective activities dominate over corrective activities. This session did not fetch an authoritative survey with a current number; treat it as unverified until a sourced study (e.g., a current empirical software engineering paper) is added.

---

## 3. Refactoring at Scale and Legacy Modernization

Two anchor sources for large-scale change:

**The monorepo / large-scale-refactoring model at Google.** Rachel Potvin and Josh Levenberg described Google's monolithic repository in *Communications of the ACM* 59(7), pp. 78–87 in July 2016 ("Why Google Stores Billions of Lines of Code in a Single Repository"). The paper is catalogued at [Why Google Stores Billions of Lines of Code in a Single Repository — research.google, 2016](https://research.google/pubs/pub45424/) (accessed 2026-04-24). Per the paper's reported statistics (summarised at [Why Google Stores Billions of Lines of Code in a Single Repository — alastairreid.github.io, 2016](https://alastairreid.github.io/RelatedWork/papers/potvin:cacm:2016/) (accessed 2026-04-24) and [AcaWiki paper notes](https://acawiki.org/Why_Google_Stores_Billions_of_Lines_of_Code_in_a_Single_Repository) (accessed 2026-04-24)): the repository in January 2015 held approximately 1 billion lines of code, 9 million unique source files, 35 million commits, **about 25,000 developers** (not 35,000), 86TB of data, with ~15 million lines of code changed weekly. [VERIFIED via secondary summaries of the paper] The full CACM fulltext URL returned HTTP 403 on direct fetch this session; these figures are sourced to independent summaries that consistently cite the same paper.

**The Strangler Fig pattern (Fowler).** The definitive short-form reference is Martin Fowler's bliki entry, revised 22 August 2024, which describes incrementally replacing a legacy system with new components that grow around and eventually replace the old one. Fowler writes that the modernization "begins with small additions, often new features, that are built on top of, yet separate to the legacy code base" and emphasizes that a Strangler Fig approach "doesn't make the exercise easy" but lets "investment and returns occur gradually and visibly." [Strangler Fig Application — Martin Fowler, 2024](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).

**Feathers on seams and dependency breaking.** Michael Feathers' *Working Effectively with Legacy Code* (Prentice Hall, 2004) is the canonical reference for introducing tests into untested code bases. The publisher InformIT confirms the book's structural anchors:

- The book's table of contents names **Chapter 4: "The Seam Model"** and **Part III: "Dependency Breaking Techniques"** [VERIFIED]. [Working Effectively with Legacy Code — Pearson/InformIT product page](https://www.informit.com/store/working-effectively-with-legacy-code-9780131177055) (accessed 2026-04-24).

An InformIT article excerpt from the book itself (article p=359417) provides Feathers' own seam definitions [VERIFIED]:

- **Seam:** "a place where you can alter behavior in your program without editing in that place."
- **Enabling point:** "a place where you can make the decision to use one behavior or another."
- Three seam types with Feathers' own hierarchy: **preprocessing seams** (C/C++ macros; e.g., `#ifdef TESTING`), **link seams** (classpath/linker substitution), and **object seams** — with Feathers stating "object seams are the best choice in object-oriented languages."

[Working Effectively with Legacy Code, Chapter 4 excerpt — Michael Feathers / InformIT](https://www.informit.com/articles/article.aspx?p=359417&seqNum=3) (accessed 2026-04-24). The widely-attributed "legacy code = code without tests" framing is consistent with Feathers' broader writing but the exact definition was not extracted verbatim from a fetched page this session; treat that specific phrasing as `[UNVERIFIED]` until a publisher excerpt of the book's preface/definition page is captured.

---

## 4. Customer Support and Feedback Loops: Closing the Loop to Stage 01

Maintenance is not purely inward-facing. Three widely-cited customer metrics feed product discovery:

- **Net Promoter Score (NPS).** Introduced by Fred Reichheld in the December 2003 Harvard Business Review article "The One Number You Need to Grow." The HBR landing page confirms author, date, and title: [The One Number You Need to Grow — Reichheld, HBR 2003](https://hbr.org/2003/12/the-one-number-you-need-to-grow) (accessed 2026-04-24). The HBR page body is gated. The formula — core question "How likely is it that you would recommend [product/service/company] to a friend or colleague?" on a 0–10 scale; Promoters 9–10, Passives 7–8, Detractors 0–6; NPS = %Promoters − %Detractors — is verified against Reichheld's firm Bain & Company: [Introducing: The Net Promoter System — Bain & Company](https://www.bain.com/insights/introducing-the-net-promoter-system-loyalty-insights/) (accessed 2026-04-24). [VERIFIED]

- **Customer Effort Score (CES).** Matthew Dixon, Karen Freeman, and Nick Toman's HBR article "Stop Trying to Delight Your Customers" (July–August 2010 issue) argued that reducing customer effort predicts loyalty better than delighting. The article's authorship and date are confirmed at [Stop Trying to Delight Your Customers — Dixon, Freeman, Toman, HBR 2010](https://hbr.org/2010/07/stop-trying-to-delight-your-customers) (accessed 2026-04-24). The specific CES formula was not extracted from the HBR page in this session and is therefore marked `[UNVERIFIED]` in this document; do not assert a precise scale here without a fetched primary source.

- **Customer Satisfaction (CSAT).** A general satisfaction-rating measure. Wikipedia describes common 5-point and 7-point-semantic-differential variants but does not attribute CSAT to a single inventor; the article treats it as a long-standing marketing-research practice rather than a defined method. [Customer satisfaction — Wikipedia](https://en.wikipedia.org/wiki/Customer_satisfaction) (accessed 2026-04-24). Treat any claim of a canonical CSAT formula as `[UNVERIFIED]` without a specific source.

Details (full formulas, respondent handling, comparison) are in `feedback-loops.md`.

**Closing the loop [SYNTHESIS]:** Taken with Lehman's Law 8 (Feedback System), these metrics are the operational plumbing of the feedback loop between live software and Stage 01 (ideation). The pattern is: (1) metric + verbatim feedback collected in production; (2) analysis surfaces problem hotspots; (3) those hotspots become candidate inputs to discovery. Without such a loop, a product can satisfy Lehman's Law 1 (Continuing Change) in volume but not in direction.

---

## 5. Continuous Improvement: Retrospectives, PDCA, Kata

- **Retrospectives (Kerth).** Norman L. Kerth's *Project Retrospectives: A Handbook for Team Reviews* (Dorset House, 2001) is the canonical citation for facilitated team retrospectives and the "Prime Directive." [VERIFIED] The Dorset House publisher page confirms author, ISBN (978-0-932633-44-6), publication year 2001, and Gerald M. Weinberg's foreword. [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24). The Prime Directive's exact wording is now `[VERIFIED]` via retrospectivewiki.org, which reproduces the full quotation: "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand." [The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24). Full content is cited in `feedback-loops.md` §6.

- **PDCA (Plan–Do–Check–Act).** The PDCA cycle originated with Walter Shewhart in the 1920s at Bell Telephone Laboratories and was modified and promoted by W. Edwards Deming; Deming himself preferred "Plan-Do-Study-Act." The four phases are: Plan (establish objectives and processes), Do (execute), Check (evaluate results against expectations), Act (adjust processes based on findings). [PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24).

- **Toyota Kata.** Mike Rother's book *Toyota Kata* (McGraw-Hill, published August 2009) introduced two patterns: the **Improvement Kata** (a four-step routine: consider vision, grasp current condition, define target condition, iterate toward it while discovering obstacles) and the **Coaching Kata** (a mentor-mentee routine that teaches the Improvement Kata). [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24).

**Implication [SYNTHESIS]:** These three frames answer different questions. PDCA governs a single change; the Improvement Kata governs a sequence of changes toward a target condition; retrospectives govern team learning across a delivery cadence. In a mature PDLC, they coexist: retrospectives decide what to improve next, the kata shapes how the team iterates toward the target, and PDCA is the unit of work inside each iteration.

---

## Sources

- [CLAUDE.md — local project rules, 2026](file:///Users/nile/Projects/pdlc/CLAUDE.md) (accessed 2026-04-24).
- [Lehman's laws of software evolution — Wikipedia](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) (accessed 2026-04-24).
- [Software maintenance — Wikipedia](https://en.wikipedia.org/wiki/Software_maintenance) (accessed 2026-04-24).
- [ISO/IEC/IEEE 14764:2022 — iso.org catalogue entry, via search metadata](https://www.iso.org/standard/80710.html) (accessed 2026-04-24; full standard not fetched, catalogue entry only).
- [Why Google Stores Billions of Lines of Code in a Single Repository — Potvin & Levenberg, CACM 2016 (research.google listing)](https://research.google/pubs/pub45424/) (accessed 2026-04-24; abstract only).
- [Why Google Stores Billions of Lines of Code in a Single Repository — paper notes, alastairreid.github.io](https://alastairreid.github.io/RelatedWork/papers/potvin:cacm:2016/) (accessed 2026-04-24).
- [Why Google Stores Billions of Lines of Code in a Single Repository — AcaWiki](https://acawiki.org/Why_Google_Stores_Billions_of_Lines_of_Code_in_a_Single_Repository) (accessed 2026-04-24).
- [Strangler Fig Application — Martin Fowler, 2024](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).
- [Working Effectively with Legacy Code — Pearson/InformIT product page](https://www.informit.com/store/working-effectively-with-legacy-code-9780131177055) (accessed 2026-04-24).
- [Working Effectively with Legacy Code, Chapter 4 excerpt — Michael Feathers / InformIT](https://www.informit.com/articles/article.aspx?p=359417&seqNum=3) (accessed 2026-04-24).
- [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24).
- [The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24).
- [The One Number You Need to Grow — Reichheld, HBR 2003](https://hbr.org/2003/12/the-one-number-you-need-to-grow) (accessed 2026-04-24; gated).
- [Stop Trying to Delight Your Customers — Dixon, Freeman, Toman, HBR 2010](https://hbr.org/2010/07/stop-trying-to-delight-your-customers) (accessed 2026-04-24; gated).
- [Net Promoter Score — Wikipedia](https://en.wikipedia.org/wiki/Net_Promoter_Score) (accessed 2026-04-24).
- [Introducing: The Net Promoter System — Bain & Company](https://www.bain.com/insights/introducing-the-net-promoter-system-loyalty-insights/) (accessed 2026-04-24).
- [Customer satisfaction — Wikipedia](https://en.wikipedia.org/wiki/Customer_satisfaction) (accessed 2026-04-24).
- [PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24).
- [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24).

---

## Open questions

- Lehman's 1980 *Proceedings of the IEEE* paper DOI (10.1109/proc.1980.11805) is now cited. The IEEE Xplore page returned HTTP 418 to WebFetch; the verbatim law wording is still sourced via Wikipedia's article which quotes Lehman directly.
- ISO/IEC/IEEE 14764:2022 standard text remains paywalled. The four category definitions are now `[VERIFIED]` via the Wikipedia citation chain to peer-reviewed textbooks (Varga 2018; Tripathy & Naik 2014). A fetched copy of the standard itself would let the paraphrases be replaced with primary quotation.
- Potvin & Levenberg paper full text at dl.acm.org and cacm.acm.org both returned HTTP 403 this session; the ~25,000-developer, ~1 billion LOC, 35 million commits figures are verified via two consistent independent summaries (alastairreid.github.io and AcaWiki) rather than the primary fulltext.
- Feathers' *Working Effectively with Legacy Code*: the book's structural anchors (Ch. 4 "The Seam Model", Part III "Dependency Breaking Techniques") and Feathers' seam-type definitions are now `[VERIFIED]` via the Pearson/InformIT product page and a book-excerpt article on InformIT (article p=359417). The verbatim "legacy code is code without tests" framing remains `[UNVERIFIED]` — the excerpt retrieved did not expose the preface page where that specific sentence lives.
- Kerth's Prime Directive wording and publication date for *Project Retrospectives* (2001) are now `[VERIFIED]` via the Dorset House publisher page and retrospectivewiki.org.
- Empirical claims about effort distribution across maintenance categories (e.g., corrective vs. perfective as a share of total post-release effort) are deliberately omitted pending a sourced study.
- CES formula and scale are deliberately not specified here; the HBR source page did not expose them in the fetched excerpt.
