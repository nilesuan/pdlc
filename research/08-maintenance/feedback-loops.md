# Customer Feedback Loops and Continuous Improvement

**Question:** What metrics do teams use to gather customer feedback in production, how do they integrate that feedback back into discovery, and what are the verified frameworks for continuous improvement (retrospectives, PDCA, Kata)?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Net Promoter Score (NPS)

NPS was introduced by Fred Reichheld in the December 2003 Harvard Business Review article "The One Number You Need to Grow." The HBR landing page confirms the title, date (December 2003 issue), and the author's identification as "a Boston-based director emeritus at Bain & Company." [The One Number You Need to Grow — Reichheld, HBR 2003](https://hbr.org/2003/12/the-one-number-you-need-to-grow) (accessed 2026-04-24). Note: the HBR page is gated; the fetched excerpt did not include the article body.

The method, verified this session against Reichheld's firm Bain & Company and cross-checked with Wikipedia:

- **Core question:** "How likely is it that you would recommend [product/service/company] to a friend or colleague?" on a 0–10 scale [Introducing: The Net Promoter System — Bain & Company](https://www.bain.com/insights/introducing-the-net-promoter-system-loyalty-insights/) (accessed 2026-04-24). [VERIFIED]
- **Categories:** Promoters score 9–10; Passives 7–8; Detractors 0–6 [Bain & Company, same URL] (accessed 2026-04-24). [VERIFIED]
- **Formula:** NPS = % Promoters − % Detractors [Bain & Company, same URL] (accessed 2026-04-24). [VERIFIED]
- **Follow-up questions:** Bain recommends pairing the rating with open-ended "Why?" and "What could we do better?" prompts [Bain & Company, same URL] (accessed 2026-04-24). [VERIFIED]

Secondary cross-reference: [Net Promoter Score — Wikipedia](https://en.wikipedia.org/wiki/Net_Promoter_Score) (accessed 2026-04-24) confirms the same scale, categories, and formula.

`[CONTESTED]` note: Academic and practitioner critiques of NPS as a loyalty predictor exist. This document does not cite a specific critique in this session; the source is Wikipedia-secondary. Do not treat NPS as a validated predictor of revenue without reading the specific methodological literature.

---

## 2. Customer Effort Score (CES)

CES was introduced by Matthew Dixon, Karen Freeman, and Nick Toman in the July–August 2010 HBR article "Stop Trying to Delight Your Customers." The HBR page confirms authors, issue date, and the opening thesis: "The idea that companies must 'delight' their customers has become so entrenched that managers rarely examine it." [Stop Trying to Delight Your Customers — Dixon, Freeman, Toman, HBR 2010](https://hbr.org/2010/07/stop-trying-to-delight-your-customers) (accessed 2026-04-24). [VERIFIED — title, authors, date, opening thesis only]

### CES 1.0 (the 2010 HBR article)

[VERIFIED via MeasuringU — Jeff Sauro, an academic UX-measurement practitioner whose site tracks the CES specifically] The original CES question as introduced in the 2010 HBR article:

> "How much effort did you personally have to put forth to handle your request?"

Scale: **5-point** (1 = very low effort, 5 = very high effort). Scoring: "average of all respondent scores; lower scores indicate better performance." ([10 Things to Know about the Customer Effort Score — MeasuringU](https://measuringu.com/customer-effort-score/) (accessed 2026-04-24)).

[VERIFIED independently via i-scoop.eu interview with Matt Dixon] Matt Dixon himself: "Before the book, the CEB came up with the Customer Effort Score (CES)." The 2010 HBR article is the originating publication ([Matthew Dixon: why and how to become a low effort organization — i-scoop.eu](https://www.i-scoop.eu/matthew-dixon-the-why-and-how-to-become-a-low-effort-organization/) (accessed 2026-04-24)).

[VERIFIED via 360 Magazine 2020 interview with Dixon] The follow-up book was *The Effortless Experience: Conquering the New Battleground for Customer Loyalty* (Dixon, Toman, DeLisi, 2013), which "led to … the Customer Effort Score (CES)" ([Matt Dixon unpacks how the Customer Effort Score led to the Tethr Effort Index — 360 Magazine, 2020](https://360magazine.com/2020/10/22/matt-dixon-tethr-effort-index/) (accessed 2026-04-24)).

### CES 2.0

[VERIFIED via MeasuringU] CES was revised by Gartner Group (which acquired CEB, the original research company):

- The revised wording removes the word "effort" and asks about ease of interaction (standard form used across CES 2.0 implementations: "[The company] made it easy for me to handle my issue" or "…to [complete task]").
- Scale: **7-point** agreement/disagreement scale (1 = Strongly Disagree to 7 = Strongly Agree).
- Scoring: "top-three-box" approach — sum respondents selecting 5, 6, or 7, divide by total respondents; some implementations still use the mean instead.

([10 Things to Know about the Customer Effort Score — MeasuringU](https://measuringu.com/customer-effort-score/) (accessed 2026-04-24)).

[CONTESTED across implementations] MeasuringU explicitly notes that "others still report the mean score" and use different point scales and questions, creating comparability challenges across CES implementations. Downstream documents should state which CES variant (1.0 5-point mean vs. 2.0 7-point top-3-box) they are referring to.

### Underlying study

[SYNTHESIS — HBR body paywalled; summary triangulated] The 2010 HBR article reports a study of "more than 75,000 people interacting with contact-center representatives or using self-service channels." The finding, verbatim from published summaries of the article: "going above and beyond in addressing customer issues is bad for business" — reducing effort predicts loyalty better than exceeding expectations. The 75,000 figure and this conclusion are consistent with the opening-thesis excerpt the HBR page does expose and across multiple independent secondary summaries (MeasuringU and Formbricks).

---

## 3. Customer Satisfaction (CSAT)

CSAT is a family of satisfaction-rating practices rather than a single method. Wikipedia defines customer satisfaction as "the number of customers, or percentage of total customers, whose reported experience with a firm, its products, or its services (ratings) exceeds specified satisfaction goals." [Customer satisfaction — Wikipedia](https://en.wikipedia.org/wiki/Customer_satisfaction) (accessed 2026-04-24).

Common instruments:

- A 5-point rating scale. The article notes "individuals who rate their satisfaction level as '5' are likely to become return customers."
- A 7-point semantic differential scale described in the research literature ("six-item 7-point semantic differential scale").

[Customer satisfaction — Wikipedia](https://en.wikipedia.org/wiki/Customer_satisfaction) (accessed 2026-04-24).

The article does not attribute CSAT to a single inventor or date, and it does not specify a canonical formula; do not assert a canonical CSAT calculation in downstream documents without a more specific source.

---

## 4. Choosing between NPS, CES, CSAT

**Synthesis [SYNTHESIS] — grounded in the sources above:**

- NPS asks about recommendation likelihood (intention to refer), on a 0–10 scale, computed as %Promoters − %Detractors.
- CES asks specifically about effort required in an interaction (the "Stop Trying to Delight" premise is that reducing effort predicts loyalty better than delighting).
- CSAT asks about satisfaction with a specific interaction or product, typically on a 5- or 7-point scale.

A common pattern is to use CSAT or CES for per-interaction measurement (ticket resolution, transaction completion) and NPS as a periodic trend indicator across the customer base. Specific integration playbooks (e.g., "survey after every ticket close") were not sourced in this session and are not prescribed here.

---

## 5. Closing the loop to Stage 01 (ideation)

Feedback metrics produce two distinct signals:

1. **Structured scores** (NPS, CES, CSAT, churn rate) that trend over time.
2. **Verbatim feedback** collected as open-ended responses or support tickets.

The verbatim channel is typically the higher-value input to discovery: a sustained drop in NPS indicates *that* something is wrong; the "Why?" text reveals *what*. This framing is supported by Reichheld's HBR treatment of the NPS survey pattern (which traditionally pairs the numeric question with an open-ended "Why?") but the specific HBR text was not extracted in this session; treat the "why? matters more than the number" framing as `[SYNTHESIS]` grounded in section 1.

**Lehman alignment [SYNTHESIS]:** Lehman's 8th law (Feedback System) states that E-type software evolution is a multi-level feedback system. Customer metrics are the outermost feedback loop — the one that connects the running system in production back to the discovery activities in Stage 01. A team that runs production without such a loop satisfies Lehman's 1st law (Continuing Change) in raw activity but not in direction. See `README.md` section 1 for the Lehman laws reference.

---

## 6. Retrospectives — Kerth

Norman L. Kerth's *Project Retrospectives: A Handbook for Team Reviews* (Dorset House Publishing, 2001) is the canonical book reference for facilitated team retrospectives, including the "Prime Directive."

**Publication details [VERIFIED]:** author Norman L. Kerth; foreword by Gerald M. Weinberg; ISBN 978-0-932633-44-6; published 2001 by Dorset House Publishing. [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24).

**The Prime Directive [VERIFIED]** — exact wording from Kerth:

> "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand."

[The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24). The Dorset House publisher page corroborates the same quotation (with a minor "he or she" phrasing variant typical of 2001-era writing): "Regardless of what we discover, we must understand and truly believe that everyone did the best job he or she could, given what was known at the time, his or her skills and abilities, the resources available, and the situation at hand." [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24).

The directive's stated purpose is to establish psychological safety by removing blame, enabling teams to examine project outcomes without defensive posturing. The book itself was not fetched directly; the two independent sources above (publisher page + retrospectivewiki.org) agree on author, title, and Directive content.

---

## 7. PDCA (Plan–Do–Check–Act)

The PDCA cycle originated with Walter Shewhart at Bell Telephone Laboratories in the 1920s as a three-step approach; W. Edwards Deming modified it in the 1940s and applied it in Japan in the 1950s. Japanese practitioners shortened the steps to the present four. Deming personally preferred PDSA (Plan-Do-*Study*-Act), believing "study" better captured Shewhart's intent than "check." [PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24).

The four phases as described in that article:

- **Plan** — establish objectives and processes required to deliver desired results.
- **Do** — carry out the objectives from the planning step.
- **Check** — evaluate data and results; compare actual outcomes to expectations.
- **Act** — improve the process by investigating root causes and modifying procedures.

[PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24).

---

## 8. Toyota Kata (Rother)

Mike Rother's *Toyota Kata* (McGraw-Hill, published August 2009) introduces two patterns:

- **Improvement Kata** — a four-part model: consider vision/direction, grasp current condition, define target condition, iterate toward it while discovering obstacles.
- **Coaching Kata** — a structured mentor-mentee routine that teaches the Improvement Kata and sustains it culturally.

Rother argues sustained competitive advantage comes not from specific solutions but from mastering "a routine for developing fitting solutions repeatedly." [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24).

---

## 9. How retrospectives, PDCA, and Kata relate

**Synthesis [SYNTHESIS]:** These are not competing frameworks; they operate at different scopes.

- **PDCA** governs a single improvement experiment — one hypothesis, one change, one measurement.
- **Improvement Kata** governs a *sequence* of PDCA cycles aimed at a defined target condition.
- **Retrospectives** govern team learning across a delivery cadence (iteration, release, incident), producing the hypotheses that become PDCA plans and setting the target conditions that the Kata pursues.

Each is verified separately in sections 6–8 (retrospectives remain `[UNVERIFIED]` pending a fetched source). The relationship framing above is synthesis, not cited to a single source.

---

## Sources

- [The One Number You Need to Grow — Reichheld, HBR 2003](https://hbr.org/2003/12/the-one-number-you-need-to-grow) (accessed 2026-04-24; gated — header metadata only).
- [Stop Trying to Delight Your Customers — Dixon, Freeman, Toman, HBR 2010](https://hbr.org/2010/07/stop-trying-to-delight-your-customers) (accessed 2026-04-24; gated — header metadata only).
- [10 Things to Know about the Customer Effort Score — MeasuringU (Jeff Sauro)](https://measuringu.com/customer-effort-score/) (accessed 2026-04-24).
- [Matthew Dixon: why and how to become a low effort organization — i-scoop.eu](https://www.i-scoop.eu/matthew-dixon-the-why-and-how-to-become-a-low-effort-organization/) (accessed 2026-04-24).
- [Matt Dixon unpacks how the Customer Effort Score led to the Tethr Effort Index — 360 Magazine, 2020](https://360magazine.com/2020/10/22/matt-dixon-tethr-effort-index/) (accessed 2026-04-24).
- [Net Promoter Score — Wikipedia](https://en.wikipedia.org/wiki/Net_Promoter_Score) (accessed 2026-04-24).
- [Introducing: The Net Promoter System — Bain & Company](https://www.bain.com/insights/introducing-the-net-promoter-system-loyalty-insights/) (accessed 2026-04-24).
- [Customer satisfaction — Wikipedia](https://en.wikipedia.org/wiki/Customer_satisfaction) (accessed 2026-04-24).
- [PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24).
- [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24).
- [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24).
- [The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24).

---

## Open questions

- NPS formula and scale are now VERIFIED via Bain & Company (Reichheld's firm) rather than just Wikipedia; the HBR 2003 article body itself remains gated and is not quoted.
- ~~CES formula and scale remain `[UNVERIFIED]`~~ — **RESOLVED 2026-04-24 verification pass 3.** CES 1.0 wording ("How much effort did you personally have to put forth to handle your request?"), 5-point scale, and mean-score formula are VERIFIED via MeasuringU (Jeff Sauro), which is an authoritative UX-measurement resource that tracks this specific metric and cites the 2010 HBR article. CES 2.0 (7-point agree/disagree scale, top-three-box scoring, acquired and updated by Gartner after its purchase of CEB) is VERIFIED via the same MeasuringU reference. Matt Dixon's own attribution of CES origin to CEB is VERIFIED via the i-scoop.eu interview and 360 Magazine 2020 interview. The 75,000-respondent study size and the "going above and beyond … is bad for business" conclusion from the HBR article body itself remain [SYNTHESIS] — the HBR page remains paywalled; the figure triangulates across multiple independent secondary summaries.
- Kerth's *Project Retrospectives* publication year (2001, Dorset House) and the Prime Directive wording are now `[VERIFIED]` via the Dorset House publisher page and retrospectivewiki.org.
- Empirical validity of NPS as a growth predictor is `[CONTESTED]`; specific critiques (e.g., from the marketing-science literature) were not fetched.
- Practitioner comparison literature for "when to use NPS vs. CES vs. CSAT" was not fetched.
