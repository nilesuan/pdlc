# CUSTOMER_FEEDBACK.md — Customer feedback standards

**Authoritative sources:**

- Handbook: [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) (Closing the loop) and [`../../../handbook/01-discover.md`](../../../handbook/01-discover.md) (continuous discovery, story-based interviews).
- Research: [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §§1–5 (NPS, CES, CSAT) and [`../../../research/01-ideation/discovery.md`](../../../research/01-ideation/discovery.md) §1 (Torres) / [`../../../research/01-ideation/user-research.md`](../../../research/01-ideation/user-research.md) §§3, 7 (interviews, surveys).

## What this standard covers

The four feedback channels that connect a running product to the next discovery cycle:

1. Numeric satisfaction surveys (NPS, CSAT, CES).
2. Continuous customer interviews (qualitative, story-based).
3. Verbatim text capture (open-ended responses, support tickets, in-product feedback).
4. The loop from signal back to a `/discover` ticket.

Out of scope here: usage analytics dashboards, A/B test design, retrospectives. Those are covered in their own standards and in the `/evolve` command pass-loop.

## Hard rules

1. **NPS, CSAT, CES are not interchangeable.** Pick the right instrument for the question. Mixing them in one dashboard without labels is a category error.
2. **Numeric score without verbatim is noise.** Every NPS/CSAT/CES survey ships with the open-ended "Why?" prompt. Reading the verbatim text is part of the workflow, not optional.
3. **Do not switch CES variants mid-year.** CES 1.0 (5-point effort) and CES 2.0 (7-point agreement) are different scales; trends become incomparable when you swap.
4. **One customer interview per week, every week.** Continuous discovery does not stop at launch. A week with zero interviews is yellow; two consecutive weeks is red.
5. **Story-based interviews only.** "Tell me about the last time you [did the thing]" beats "would you use a feature that...". Attitudinal questions belong in marketing copy tests, not discovery.
6. **Survey body is short.** NN/g: extra questions reduce response rates and validity; front-load the questions that matter.
7. **Feedback that produces a roadmap change goes through `/discover`.** A single complaint becomes a ticket only after it shows up across multiple independent customers — not from a sample of one.

## The three numeric instruments

### NPS — Net Promoter Score

- **Origin:** Fred Reichheld, "The One Number You Need to Grow," *Harvard Business Review*, December 2003 [VERIFIED — feedback-loops.md §1].
- **Question:** "How likely is it that you would recommend [product/service/company] to a friend or colleague?" 0–10 scale [VERIFIED via Bain & Company — feedback-loops.md §1].
- **Categories:** Promoters 9–10, Passives 7–8, Detractors 0–6 [VERIFIED via Bain — same].
- **Formula:** NPS = % Promoters − % Detractors [VERIFIED via Bain — same].
- **Pair with:** open-ended "Why?" prompt; Bain explicitly recommends this [VERIFIED — same].
- **When to use:** quarterly trend across the customer base; long-term loyalty signal.
- **Caveat — empirical validity:** the academic critique of NPS as a revenue/loyalty *predictor* is `[CONTESTED]` per feedback-loops.md §1; do not market NPS as a validated growth predictor without reading the methodological literature.

### CES — Customer Effort Score

- **Origin:** Matthew Dixon, Karen Freeman, Nick Toman, "Stop Trying to Delight Your Customers," *Harvard Business Review*, July–August 2010 [VERIFIED — feedback-loops.md §2].
- **Premise (per HBR opening thesis, verified):** the idea that companies must "delight" their customers has become entrenched and rarely examined; reducing customer effort predicts loyalty better than exceeding expectations [VERIFIED — feedback-loops.md §2 opening thesis only; the supporting study figures are `[SYNTHESIS]` because the HBR body is paywalled].
- **CES 1.0 question:** "How much effort did you personally have to put forth to handle your request?" 5-point scale (1 = very low effort, 5 = very high effort); average all responses, lower is better [VERIFIED via MeasuringU — feedback-loops.md §2].
- **CES 2.0 question:** agreement-style — "[The company] made it easy for me to handle my issue," 7-point Strongly Disagree → Strongly Agree; standard scoring is the "top-three-box" sum (count of 5/6/7 over total) though some implementations report the mean [VERIFIED via MeasuringU; CONTESTED across implementations — feedback-loops.md §2].
- **When to use:** transactional, immediately after a specific interaction (ticket close, onboarding completion, friction-heavy flow). Best predictor of loyalty for support experiences per the 2010 HBR thesis.

### CSAT — Customer Satisfaction

- **Origin:** no single attributable inventor or canonical formula in the fetched sources [VERIFIED — feedback-loops.md §3 explicitly notes this gap].
- **Common instruments:** 5-point rating scale or 7-point semantic differential, per the Wikipedia overview cited in feedback-loops.md §3 [VERIFIED, weak-source caveat: Wikipedia for orientation].
- **Question shape:** "How satisfied were you with [the interaction / the product / this experience]?" — variants vary.
- **When to use:** transactional micro-feedback after a specific event. Use CSAT *or* CES on a given touchpoint, not both — they answer overlapping questions and double up the survey burden.
- **Caveat:** because CSAT lacks a canonical formula, document your scale and computation locally so trends remain comparable.

### Picking between them

This is `[SYNTHESIS]` from feedback-loops.md §4:

| Question | Instrument |
|---|---|
| "How loyal is our base over time?" | NPS, quarterly |
| "Was this specific interaction easy?" | CES, after the interaction |
| "Was this specific interaction satisfying?" | CSAT, after the interaction |

Do not run all three on the same touchpoint. Pick one transactional metric (CSAT or CES) per surface; reserve NPS for the periodic, base-wide read.

## Sampling and survey discipline

What the sources support directly:

- **Front-load the important questions.** NN/g: participants abandon surveys midway, so the consequential questions go first [VERIFIED — user-research.md §7].
- **Keep surveys brief.** NN/g: extra questions reduce response rates and validity [VERIFIED — same].
- **Randomize question order** to prevent ordering bias [VERIFIED — same].
- **Iteratively pilot the survey** on colleagues, then on 4 rounds of think-aloud sessions with target users before sending in anger [VERIFIED — same].
- **Avoid jargon and define subjective terms** ("essential," "frequent") [VERIFIED — same].
- **Mark fields Required vs Optional** so respondents know what they must answer [VERIFIED — same].

What the sources explicitly *do not* support:

- A specific minimum-sample-size threshold for NPS, CSAT, or CES is not in feedback-loops.md or the cited Bain/MeasuringU pages [UNVERIFIED]. Do not invent one. If you need confidence intervals, consult a survey-statistics source before publishing the number.
- The "5 users" rule is for *qualitative usability testing* (Nielsen), not for satisfaction surveys [VERIFIED — user-research.md §4]. Do not cite it as a sample-size justification for NPS/CSAT/CES.

Bias to actively avoid:

- **Leading questions.** "Would you use a feature that helps you do X faster?" is for sales pitches, not research; people are polite and will say yes [VERIFIED — handbook/01-discover.md, anti-pattern 2].
- **Sampling only the loud.** A satisfaction survey routed only to power users measures power users.
- **Self-selection drift.** When response rates drop, the respondents who remain are not representative; note response rate alongside the score.
- **Switching scales between periods.** Specifically called out for CES 1.0 vs 2.0 [VERIFIED — feedback-loops.md §2; handbook/08-evolve-processes.md §131-132].

## Qualitative customer interviews

The continuous-discovery practice from Torres applies in both `/discover` and `/evolve`.

- **Cadence:** at least one customer interview per week, every week, indefinitely [VERIFIED — Torres "good product discovery teams [engage with customers at least weekly]," research/01-ideation/discovery.md §1; reinforced in handbook/08-evolve.md and handbook/08-evolve-processes.md §158].
- **Interview shape:** semi-structured, anchored on stories, not opinions. NN/g 6-step practice [VERIFIED — user-research.md §3]:
  1. Identify specific research goals.
  2. Prepare an interview guide with open-ended questions.
  3. Pilot the guide.
  4. Start with easy, comfortable questions.
  5. Build rapport through active listening.
  6. Probe deeper — "Tell me more about that."
- **Logistics (per handbook/01-discover.md Step 2):** 30–45 minutes, recorded with consent, two team members in the room (interviewer + note-taker), incentive appropriate to the segment.
- **Output:** transcript or notes go into the evidence log — verbatim quote, speaker pseudonym + role, date, theme, source link.

### Jobs-to-be-Done framing

When stories cluster around a recurring "progress the customer is trying to make," frame the cluster as a JTBD opportunity:

- **Christensen:** "People don't simply buy or pick products or services; they pull them into their lives to make progress." Functional, social, and emotional dimensions [VERIFIED via Christensen Institute — research/01-ideation/discovery.md §6].
- **Use it when** the unifying signal across customers is the job, not the role.
- **Companion: Ulwick's Outcome-Driven Innovation** — markets defined around shared functional goals, not products or demographics [VERIFIED — same].

The JTBD framing is descriptive (what the customer is trying to accomplish), not prescriptive (what to build). Solutions go below opportunities on Torres's Opportunity Solution Tree [VERIFIED — research/01-ideation/discovery.md §1].

## Feedback-to-action loop

Numeric and qualitative signal converge on a single question: *what do we put on the roadmap?* The handbook's Phase 08 routes feedback through these stages:

1. **Capture.** Numeric scores stream into a satisfaction dashboard; verbatim text and interview notes stream into a searchable repository [VERIFIED — handbook/08-evolve-processes.md §99-104].
2. **Read.** Weekly product-team review (≤ 30 minutes) walks the metric trends *and* the verbatim sample. Reading the open text is mandatory; numbers without text are ignored [VERIFIED — handbook/08-evolve.md, "Closing the loop concretely" + handbook/08-evolve-processes.md §104].
3. **Cluster.** A signal that recurs across ≥ 2–3 independent customers becomes a candidate opportunity. A signal mentioned by one customer once is logged but does not move the roadmap.
4. **Open a `/discover` ticket** for any candidate opportunity that would change the roadmap. The ticket carries the verbatim quotes that produced it. From there it follows the Phase 01 process: segment definition, additional interviews, riskiest-assumption test, decision (proceed / pivot / kill).
5. **Close the loop publicly.** When a feedback-driven change ships, tell the customers who provided the input. A changelog entry plus a direct note to the original reporters ("we shipped X because you and others raised Y") is the discipline that sustains response rates.

The handbook's exit checklist for `/evolve` requires a "voice-of-customer" channel that operates weekly [VERIFIED — handbook/08-evolve.md, exit checklist].

## Anti-patterns

- **NPS as a vanity metric.** A quarterly score that goes up with no investigation of *why* manufactures confidence. The "Why?" verbatim is the signal [VERIFIED — handbook/08-evolve.md, "A note on NPS as a vanity metric"].
- **Survey-of-one decisions.** One angry customer becomes one feedback ticket, not a roadmap change. Cluster across independent customers before committing engineering time.
- **Asking customers to design.** "Would you use a feature that does X?" produces polite agreement, not evidence. Ask about past behaviour; the customer is not the designer [VERIFIED — handbook/01-discover.md, anti-pattern 2].
- **Treating opinions as evidence.** A founder's "I know our users want X" or a sales rep's "customers always ask for X" is a hypothesis, not a finding. Evidence is a customer, on the record, telling you about a specific experience [VERIFIED — handbook/01-discover.md, anti-pattern 3].
- **Discovery once, then never again.** Teams that interview only at kickoff and again after launch are blind for 90% of the journey [VERIFIED — handbook/01-discover.md, anti-pattern 6].
- **Leading interview questions.** Pre-loaded with the answer the team wants. "Tell me about the last time you..." beats "do you wish there was a way to..." [VERIFIED — handbook/01-discover.md, anti-pattern 2].
- **Switching CES variants mid-year.** Trends become incomparable [VERIFIED — handbook/08-evolve-processes.md §132; feedback-loops.md §2].
- **Running NPS without the verbatim prompt.** Skip the survey instead [VERIFIED — handbook/08-evolve.md].
- **Quantifying before qualitative discovery.** A 500-person survey before 10 interviews counts noise — you do not yet know which questions matter [VERIFIED — handbook/01-discover.md, anti-pattern 5; user-research.md §7 NN/g warning that "qualitative survey metrics are rarely representative"].

## Cross-links

- **`/discover`** — Phase 01 entry process. Customer interviews, evidence log, Opportunity Solution Tree, riskiest-assumption test, proceed/pivot/kill decision. See [`../../commands/discover.md`](../../commands/discover.md) and [`../../../handbook/01-discover.md`](../../../handbook/01-discover.md).
- **`/evolve`** — quarterly evolution audit. Confirms feedback loops are live, customer interview cadence is unbroken, NPS/CSAT/CES instrumentation is producing readable verbatim. See [`../../commands/evolve.md`](../../commands/evolve.md) and [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md).

## Sources

All citations trace back through:

- Research: [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §§1–5 (Reichheld 2003 NPS via Bain; Dixon/Freeman/Toman 2010 CES via MeasuringU; CSAT via Wikipedia overview).
- Research: [`../../../research/01-ideation/discovery.md`](../../../research/01-ideation/discovery.md) §1 (Torres continuous discovery, OST), §6 (Christensen JTBD, Ulwick ODI).
- Research: [`../../../research/01-ideation/user-research.md`](../../../research/01-ideation/user-research.md) §3 (NN/g user interviews), §7 (NN/g surveys), §4 (Nielsen 5-users — usability only, not surveys).
- Handbook: [`../../../handbook/01-discover.md`](../../../handbook/01-discover.md) (Step 2 interview practice; anti-patterns 2, 3, 5, 6).
- Handbook: [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) (quantitative + qualitative signals, "NPS as vanity metric" warning, weekly cadence).
- Handbook: [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §§97–132 (configured surveys, anti-patterns).
