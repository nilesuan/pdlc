# User Research Methods

**Question:** What are the core user research methods used during ideation and discovery, how do they differ, and when is each appropriate?

**Status:** Draft
**Last updated:** 2026-04-24

Primary source for this document is the Nielsen Norman Group (NN/g). NN/g is a named-author UX research consultancy founded by Jakob Nielsen and Don Norman; its articles are dated and attributed.

---

## 1. The method map (Rohrer, NN/g)

NN/g categorizes 20 UX research methods along three axes:

- **Attitudinal ↔ Behavioral** — "what people say" vs. "what people do."
- **Qualitative ↔ Quantitative** — direct observation vs. indirect mathematical/statistical measurement.
- **Context of use** — natural, scripted, limited, or decontextualized product interaction.

Methods also align to three product-development stages: **Strategize** (generative), **Design** (formative), **Launch & Assess** (summative).

[VERIFIED] [When to Use Which User-Experience Research Methods — Christian Rohrer, NN/g, 2022-07-17](https://www.nngroup.com/articles/which-ux-research-methods/) (accessed 2026-04-24).

The 20 methods on NN/g's chart include: usability testing, field studies, contextual inquiry, participatory design, focus groups, interviews, eyetracking, usability benchmarking, remote moderated testing, unmoderated testing, concept testing, diary studies, customer feedback, desirability studies, card sorting, tree testing, analytics, clickstream analytics, A/B testing, and surveys. [VERIFIED] (same source).

## 2. Phase-based sequencing (Farrell, NN/g)

NN/g recommends matching methods to project phase:

- **Discover** — field studies, user interviews, diary studies, stakeholder interviews, competitive testing, consultation with sales/support staff. Core guidance: *"Go where the users are, watch, ask, and listen."*
- **Explore** — competitive analysis, persona building, user stories, task analysis, journey mapping, paper and clickable prototype testing, card sorting.
- **Test** — qualitative usability testing (in-person or remote), benchmark testing, accessibility evaluation, diary studies for long-term feedback.
- **Listen** — surveys, analytics and metrics review, search log analysis, FAQ analysis, social media monitoring, user forum analysis.

If budget is limited, NN/g's single most-recommended activity is "qualitative (think-aloud) usability testing."

[VERIFIED] [UX Research Cheat Sheet — Susan Farrell, NN/g, 2017-02-12](https://www.nngroup.com/articles/ux-research-cheat-sheet/) (accessed 2026-04-24).

---

## 3. User interviews

**Definition.** *"A research method where the interviewer asks participants questions about a topic, listens to their responses, and follows up with further questions to learn more."* [VERIFIED] [User Interviews 101 — Rosala & Pernice, NN/g, 2023-09-17](https://www.nngroup.com/articles/user-interviews/) (accessed 2026-04-24).

**Purpose.** Reveal experiences, pain points, mental models, motivations, and needs; build team empathy. [VERIFIED] (same source).

**NN/g's 6-step practice:**
1. Identify specific research goals.
2. Prepare an interview guide with open-ended questions.
3. Pilot the guide before full deployment.
4. Start with easy, comfortable questions.
5. Build rapport through active listening (verbal and nonverbal).
6. Probe deeper — "Tell me more about that."

[VERIFIED] (same source).

**Positioning.** Interviews are **attitudinal** and belong to the Empathize phase; they are *not* a substitute for observing actual behavior. [VERIFIED] (same source).

**Limitations.**
- Self-report bias; poor recollection; missing details.
- Social-desirability bias.
- Data quality depends heavily on interviewer skill.
- Do not capture observed behavior.

[VERIFIED] (same source).

---

## 4. Usability testing

**Definition.** "A popular UX research methodology" in which a facilitator asks participants to perform tasks using specific interfaces while observing behavior and gathering feedback. [VERIFIED] [Usability Testing 101 — Kate Moran, NN/g, 2019-12-01](https://www.nngroup.com/articles/usability-testing-101/) (accessed 2026-04-24).

**Three elements:** facilitator, participant, realistic task. The facilitator observes and listens without influencing results.

**Two modes:**
- **Moderated** — facilitator interacts directly with participant, in-person or remote (screen-sharing).
- **Unmoderated** — participant completes tasks independently via online tools; researchers review recordings afterward.

[VERIFIED] (same source).

**Goals:** identify design problems, uncover improvement opportunities, understand user behavior. *"Iterative design requires observations of real users because designers alone cannot create optimal experiences without empirical testing data."* [VERIFIED] (same source).

### Sample size: "5 users" rule

Nielsen's 2000 article argues that for qualitative usability testing, 5 participants uncover most usability problems, after which returns diminish sharply. The formula (Nielsen & Landauer):

> **Problems found = N · (1 − L)ⁿ**
> where N = total problems in the design, L ≈ 0.31 (share found per typical user), n = number of test users.

**Key numbers from the article:**
- First user surfaces ~31% of all usability problems.
- After 5 users, additional users largely duplicate findings.
- Better practice: run **three studies of 5 users** rather than one study of 15 — iterate design between rounds.

**When to test more users:**
- For highly distinct user groups (e.g., children + parents): 3–4 users per group for two groups; 3 per group for three or more groups.

[VERIFIED] [Why You Only Need to Test with 5 Users — Jakob Nielsen, NN/g, 2000-03-18](https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/) (accessed 2026-04-24).

> Caveat: the "5 users" rule applies to **qualitative** usability testing aimed at surfacing problems. **Quantitative** benchmarking (measuring task time, success rate with statistical confidence) requires substantially larger samples — implied by Nielsen's article but not explicitly quantified on the fetched page. [SYNTHESIS]

---

## 5. Field studies and contextual inquiry

**Definition.** Field studies are *"a type of context research that takes place in the user's natural environment"* rather than in controlled settings. [VERIFIED] [Field Studies — Farrell & Fessenden, NN/g, 2024-01-12](https://www.nngroup.com/articles/field-studies/) (accessed 2026-04-24).

**Benefits:**
- Realistic insights — actual behavior in genuine scenarios.
- Contextual understanding — workflow integration, distractions, social interactions that lab studies miss.

[VERIFIED] (same source).

**Contextual inquiry.** *"In-depth observation and interviews of a small sample of users to gain a robust understanding of work practices and behaviors."* Most field-based usability tests fall into this category — observation combined with participant explanation. [VERIFIED] (same source).

**Methodology spectrum.** Field studies range from purely observational (direct observation) to more interview-focused (ethnography). Planning considerations: clear research questions, proper permissions, team alignment, observer management. [VERIFIED] (same source).

> "Ethnography" as a distinct NN/g method page was not fetchable in this session (the URL tried returned 404). The Field Studies page references the observation-to-ethnography spectrum. Treat specific ethnographic-method definitions not on that page as **[UNVERIFIED]** here.

---

## 6. Diary studies

**Definition.** *"A qualitative user research method used to collect insights about user behaviors, activities, and experiences over time and in context."* [VERIFIED] [Diary Studies — Kim Flaherty, NN/g, 2024-03-29](https://www.nngroup.com/articles/diary-studies/) (accessed 2026-04-24).

Participants document interactions as they naturally occur, over periods from days to months.

**Three data-collection protocols:**
1. **Event-based** — participants log entries when a specific interaction happens.
2. **Interval-based** — reporting at regular scheduled times.
3. **Signal-based** — participants respond when prompted (SMS, push notifications).

[VERIFIED] (same source).

**When to use.** Behavioral habits and frequency patterns; motivations and attitudes over extended periods; changes in perception or loyalty; multi-touchpoint customer journeys; device/channel preferences; external collaboration factors. Diary studies "excel at capturing contextual, longitudinal insights that single-session methods like usability testing cannot provide." [VERIFIED] (same source).

---

## 7. Surveys

**Definition.** Surveys gather user feedback through structured questions. NN/g distinguishes **quantitative surveys** (count results, closed-ended, large random samples, statistical representativeness) from **qualitative surveys** (open-ended questions, fewer participants, rich descriptive feedback). [VERIFIED] [Qualitative Surveys — Susan Farrell, NN/g, 2016-09-25](https://www.nngroup.com/articles/qualitative-surveys/) (accessed 2026-04-24).

**Best practices (from NN/g):**
- **Iterative testing is essential.** Test drafts with colleagues, then conduct 4 rounds with target-audience participants using think-aloud.
- **Keep surveys brief** — extra questions reduce response rates and validity.
- **Front-load important questions** — participants abandon surveys midway.
- **Randomize question order** to prevent bias.
- **Mark fields "(Required)" or "(Optional)"** after each question.
- **Avoid jargon** and define subjective terms (e.g., "essential," "frequent").

[VERIFIED] (same source).

**Limitations.** NN/g is explicit: "qualitative survey metrics are rarely representative for the whole target audience." Results reflect respondent opinions only, without statistical validation. [VERIFIED] (same source).

---

## 8. Personas

**Definition.** *"A fictional, yet realistic, description of a typical or target user of the product."* [VERIFIED] [Personas Study Guide — Kate Kaplan, NN/g, 2022-10-09](https://www.nngroup.com/articles/personas-study-guide/) (accessed 2026-04-24).

**Purposes:**
- Promote empathy among team members.
- Increase awareness and memorability of target users.
- Prioritize product features.
- Inform design decisions.

[VERIFIED] (same source).

**When to use:**
- Design ideation and scenario mapping.
- Feature prioritization.
- Segmenting analytics to uncover UX insights.
- Recruiting research participants.
- Guiding expert reviews.
- Agile environments.

[VERIFIED] (same source).

**Creation approaches.** Three variants — **lightweight, qualitative, statistical** — each with different cost and confidence tradeoffs. [VERIFIED] (same source).

**Caveat.** Personas require regular updates and are subject to common pitfalls (becoming stereotypes, going stale). NN/g positions them as "living documents." [VERIFIED] (same source).

---

## 9. Journey maps

**Definition.** *"A journey map is a visualization of the process that a person goes through in order to accomplish a goal."* [VERIFIED] [Journey Mapping 101 — Sarah Gibbons, NN/g, 2018-12-09](https://www.nngroup.com/articles/journey-mapping-101/) (accessed 2026-04-24).

**Five core components** (NN/g's list):

1. **Actor** — the persona or user whose perspective the map represents. Typically one actor per map to maintain narrative clarity.
2. **Scenario + Expectations** — the situation, goal, and anticipated outcomes.
3. **Journey phases** — high-level stages (e.g., discover, try, buy, use, seek support).
4. **Actions, mindsets, and emotions** — user behaviors, thoughts/questions, emotional responses plotted across phases.
5. **Opportunities** — where the experience can be improved, including ownership and measurement approach.

[VERIFIED] (same source).

**Purpose.** Two functions: facilitate team alignment through collaborative creation, and produce a shared artifact that communicates user understanding across the organization. [VERIFIED] (same source).

---

## 10. Picking a method — short heuristic

This is a [SYNTHESIS] from the NN/g pages above, not a direct quotation:

| Question you're trying to answer | Fitting method(s) |
|---|---|
| Who are our users and what do they need? | User interviews; field studies; diary studies |
| How do users currently get the job done? | Field studies; contextual inquiry; diary studies |
| Can users complete this specific task? | Usability testing (qualitative, 5 users, iterative) |
| Which of two designs performs better? | A/B testing; usability benchmarking |
| How satisfied are users at scale? | Quantitative surveys; analytics |
| Where does the experience break down across a long flow? | Journey mapping; diary studies |

---

## Sources (all accessed 2026-04-24)

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

## Open questions

- **Ethnography** as a standalone NN/g method page — fetch failed. A dedicated source is needed for ethnographic research distinct from field studies and contextual inquiry.
- **Quantitative usability-test sample sizing** — Nielsen's 5-user rule is qualitative-only; a companion NN/g piece on benchmark sizing (e.g., Tullis & Albert-style guidance) was not fetched and should be added when used.
- **A/B testing methodology** — NN/g lists it as one of the 20 methods but we did not fetch a dedicated NN/g page on experimentation; that gap is better filled in Stage 05 (Testing) or Stage 07 (Operations) as it applies there too.
- **Statistical confidence in qualitative research** — several NN/g pages caution about representativeness; a source that consolidates the practical implications (sample size vs. confidence for qualitative claims) would be useful.
