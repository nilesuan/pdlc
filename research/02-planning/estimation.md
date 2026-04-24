# Estimation

**Question:** How do software product teams estimate work — story points, t-shirt sizing, Fibonacci, planning poker, and the #NoEstimates critique — and what are the canonical sources?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Story points (Mike Cohn)

### Definition

[VERIFIED] Mike Cohn defines story points: "Story points are a unit of measure for expressing an estimate of the overall effort that will be required to fully implement a product backlog item or any other piece of work" ([What Are Story Points and Why Do We Use Them? — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/what-are-story-points) (accessed 2026-04-24)).

### Relative, not absolute

[VERIFIED] "A user story that is assigned two story points should be twice as much effort as a one-point story. The actual numbers matter far less than their proportional relationships — teams could use 1, 2, 3 or 100, 200, 300 with identical results" (paraphrased from Cohn's post; exact text from the post: "Story points serve much the same purpose. They allow individuals with differing skill sets and speeds of working to agree") ([The Main Benefit of Story Points — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/the-main-benefit-of-story-points) (accessed 2026-04-24)).

### Why relative estimation works

[VERIFIED] Cohn uses a running-trail analogy: "When we try to put a time estimate on running this trail, we find we can't because we work (run) at different rates" — but both runners can agree the trail is 5 miles ([Mountain Goat, n.d.](https://www.mountaingoatsoftware.com/blog/the-main-benefit-of-story-points) (accessed 2026-04-24)). Story points abstract individual speed out of the estimate.

### Components of effort

[VERIFIED] Story point estimates incorporate "the amount of work involved, complexity of implementation, and any inherent risk or uncertainty — all unified under the measurement of overall effort required" (Cohn; [Mountain Goat, n.d.](https://www.mountaingoatsoftware.com/blog/what-are-story-points) (accessed 2026-04-24)).

---

## 2. Planning Poker (James Grenning)

### Origin

[VERIFIED] "James Grenning first defined and named Planning Poker in 2002. The method later gained wider recognition when Mike Cohn promoted it through his book *Agile Estimating and Planning*, which was published in November 2005. Cohn's company subsequently trademarked the term" ([Planning poker — Wikipedia](https://en.wikipedia.org/wiki/Planning_poker) (accessed 2026-04-24)).

### Mechanism

[VERIFIED] "The core mechanism relies on simultaneous estimation to prevent bias. Team members 'make estimates by playing numbered cards face-down to the table, instead of speaking them aloud.' This approach avoids the cognitive bias of anchoring, where 'the first number spoken aloud sets a precedent for subsequent estimates'" ([Wikipedia, n.d.](https://en.wikipedia.org/wiki/Planning_poker) (accessed 2026-04-24)).

### Fibonacci sequence

[VERIFIED] The typical deck uses "the Fibonacci sequence (0, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89)." Rationale: "The reason for using the Fibonacci sequence instead of simply doubling each subsequent value is because estimating a task as exactly double the effort as another task is misleadingly precise" ([Wikipedia, n.d.](https://en.wikipedia.org/wiki/Planning_poker) (accessed 2026-04-24)).

[SYNTHESIS] The spacing between Fibonacci values widens as numbers grow (1, 2, 3, 5, 8, 13 — gaps of 1, 1, 2, 3, 5), which matches the observation that estimate uncertainty grows with size. A 21 is not "1.5× a 13" with meaningful precision; the scale's design makes that impossible to claim.

---

## 3. T-shirt sizing

[SYNTHESIS] T-shirt sizing (XS / S / M / L / XL) is mentioned in the original task but I could not locate a named originator in this session's searches. Conceptually it is a coarser relative-sizing scheme than Fibonacci points — the same pattern (relative, proportional, ordinal) with fewer bins. It appears across Mountain Goat posts and Agile coaching literature but is not tied to a single canonical paper. [UNVERIFIED] — treat as common-practice vocabulary rather than a formally defined framework here.

---

## 4. #NoEstimates (Woody Zuill, Vasco Duarte)

### Origin

[VERIFIED] Vasco Duarte initiated the conversation around 2011–2012 while preparing a presentation titled "Story Points considered harmful." He states: "The earliest recorded tweet with the #NoEstimates was by Woody Zuill, and after that the conversation on Twitter took off." Duarte credits Zuill's catalytic role: "Woody Zuill talked to 100+ people on skype about the topic" ([Q&A with Vasco Duarte on the #NoEstimates Book — InfoQ](https://www.infoq.com/articles/book-review-noestimates/) (accessed 2026-04-24)).

### Core critique

[VERIFIED] Duarte's objection: "estimates are not a good tool because they fail to deliver on the promise (know the duration/cost within acceptable range), and additionally promote many different dysfunctions." He cites evidence that "Of the large systems that are completed, about 66% experience schedule delays & cost overrun" ([InfoQ, n.d.](https://www.infoq.com/articles/book-review-noestimates/) (accessed 2026-04-24)).

### Proposed alternative

[VERIFIED] Focus on value over output: "selecting high-impact experiments (Features or Stories), and not mindlessly deliver of a long list" prioritizes impact rather than completion metrics. Continuous scope management is "the most important tool for software project management." Planning without estimation: "you can easily decide which stories to take into a sprint without sizing those stories" ([Duarte, InfoQ, n.d.](https://www.infoq.com/articles/book-review-noestimates/) (accessed 2026-04-24)).

[SYNTHESIS] NoEstimates does not argue against thinking about size; it argues against the ritual of assigning numbers that are then aggregated into velocity figures and used for commitment. The alternatives Duarte proposes — slicing to small, uniform stories and counting throughput — are not incompatible with Scrum but reject the typical story-point layer.

---

## 5. Velocity and capacity for estimation

See also `README.md` section 6.

[VERIFIED] "Velocity-driven sprint planning is based on the premise that the amount of work a team will do in the coming sprint is roughly equal to what they've done in prior sprints" ([Velocity-Driven Sprint Planning — Mike Cohn, Mountain Goat](https://www.mountaingoatsoftware.com/blog/velocity-driven-sprint-planning) (accessed 2026-04-24)).

[VERIFIED] Cohn offers two definitions of velocity and warns: "The most important thing is to clarify with everyone on the team, including the product owner and ScrumMaster, is exactly what your team means when they use the term 'velocity'" ([Know Exactly What Velocity Means — Mountain Goat](https://www.mountaingoatsoftware.com/blog/know-exactly-what-velocity-means-to-your-scrum-team) (accessed 2026-04-24)).

[VERIFIED] The 2020 Scrum Guide makes no mention of velocity at all — only capacity, in passing: "the more the Developers know about their past performance, their upcoming capacity, and their Definition of Done, the more confident they will be in their Sprint forecasts" ([The 2020 Scrum Guide](https://scrumguides.org/scrum-guide.html) (accessed 2026-04-24)).

[SYNTHESIS] Velocity is therefore a practitioner convention, not a framework artifact. Using it for cross-team comparison or as a productivity KPI diverges from both the Scrum Guide (which does not include it) and Cohn's own guidance (which warns that teams can mean different things by it).

---

## 6. Summary: three lenses on estimation

| Approach | Core idea | Canonical source |
|---|---|---|
| Story points (relative) | Strip out individual speed; estimate relative complexity | Cohn, Mountain Goat |
| Planning Poker | Use simultaneous card reveals + Fibonacci to reduce anchoring | Grenning 2002; Cohn 2005 book |
| #NoEstimates | Skip point estimates; use throughput + small, uniform stories | Zuill, Duarte, ~2012 |

All rows sourced from fetches above.

---

## Open Questions

- [UNVERIFIED] Exact trademark status of "Planning Poker" — Wikipedia states Cohn's company trademarked the term; the trademark registry itself was not checked.
- [UNVERIFIED] Woody Zuill's December 2012 blog post that originated the #NoEstimates tweet — search results reference it but the blog URL was not fetched in this session.
- [UNVERIFIED] T-shirt sizing canonical origin.
- [OUT OF DATE RISK] Mountain Goat blog posts are not visibly dated in the fetch output; the *content* of Cohn's story-point argument has remained consistent across editions of *Agile Estimating and Planning*, but the specific post text could have been updated.

---

## Sources

All fetched on 2026-04-24.

1. [What Are Story Points and Why Do We Use Them? — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/what-are-story-points)
2. [The Main Benefit of Story Points — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/the-main-benefit-of-story-points)
3. [Know Exactly What Velocity Means to Your Scrum Team — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/know-exactly-what-velocity-means-to-your-scrum-team)
4. [Velocity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/velocity-driven-sprint-planning)
5. [Capacity-Driven Sprint Planning — Mike Cohn, Mountain Goat Software](https://www.mountaingoatsoftware.com/blog/capacity-driven-sprint-planning)
6. [Planning poker — Wikipedia](https://en.wikipedia.org/wiki/Planning_poker)
7. [Q&A with Vasco Duarte on the #NoEstimates Book — InfoQ](https://www.infoq.com/articles/book-review-noestimates/)
8. [The 2020 Scrum Guide — Schwaber & Sutherland](https://scrumguides.org/scrum-guide.html)
