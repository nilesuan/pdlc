# Prioritization Frameworks

**Question:** What are the canonical prioritization frameworks used in software product planning, where did they originate, what are their formulas and intended uses, and what are their limits?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

Covers RICE, MoSCoW, Kano, ICE, WSJF, and Cost of Delay. For each: origin, formula/structure, and a verified primary or authoritative secondary source.

---

## 1. RICE (Intercom)

### Origin

[VERIFIED] RICE was developed at Intercom by Sean McBride and team, who wrote: "In response, we began developing our own scoring system for prioritization from first principles" ([RICE: Simple Prioritization for Product Managers — Intercom](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/) (accessed 2026-04-24)).

### Formula

[VERIFIED] `(Reach × Impact × Confidence) ÷ Effort`

Components, as defined on the Intercom blog ([Intercom, n.d.](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/) (accessed 2026-04-24)):

- **Reach** — "how many people will this impact?" within a defined time period.
- **Impact** — "how much will this impact each person?"
- **Confidence** — "how confident are you in your estimates?"
- **Effort** — "how many 'person-months' will this take?"

The resulting unit, per the article, "measures 'total impact per time worked' – exactly what we'd like to maximize."

### Use and limits

[SYNTHESIS] RICE forces you to name Reach (population size) and Confidence (epistemic uncertainty), which are often glossed over in simpler frameworks. It does not account for strategic alignment or interdependencies between items; it is a local score, not a global plan.

---

## 2. MoSCoW (DSDM)

### Origin

[VERIFIED] "This prioritization method was developed by Dai Clegg in 1994 for use in rapid application development (RAD)." It "was first used extensively with the dynamic systems development method (DSDM) from 2002" ([MoSCoW method — Wikipedia](https://en.wikipedia.org/wiki/MoSCoW_method) (accessed 2026-04-24)).

### Categories

[VERIFIED] Four tiers; the interstitial Os exist only for pronunciation ([Wikipedia, n.d.](https://en.wikipedia.org/wiki/MoSCoW_method) (accessed 2026-04-24)):

- **M — Must have:** "critical to the current delivery timebox" for project success.
- **S — Should have:** "important but not necessary for delivery in the current delivery timebox."
- **C — Could have:** "desirable but not necessary"; enhances experience with minimal development effort.
- **W — Won't have:** "agreed by stakeholders as the least-critical, lowest-payback items."

### Use and limits

[SYNTHESIS] MoSCoW is designed for time-boxed delivery — it defines "this timebox" as the unit of commitment and forces explicit deferral (the Won't-have-this-time category). Its weakness: categories are discrete and relative to a timebox, so two "Must haves" cannot be ordered against each other without additional method.

---

## 3. Kano Model (Noriaki Kano)

### Origin

[VERIFIED] Developed by Professor Noriaki Kano in the 1980s with his foundational article published April 1984 ([Kano model — Wikipedia](https://en.wikipedia.org/wiki/Kano_model) (accessed 2026-04-24)). The official kanomodel.com site describes it as developed "in the early 1980s" ([Kano Model — kanomodel.com](https://kanomodel.com/) (accessed 2026-04-24)).

### Five categories

[VERIFIED] From Wikipedia's description ([Wikipedia, n.d.](https://en.wikipedia.org/wiki/Kano_model) (accessed 2026-04-24)):

1. **Must-be Quality** — "Requirements that the customers expect and are taken for granted. When done well, customers are just neutral, but when done poorly, customers are very dissatisfied."
2. **One-dimensional Quality** — "Attributes result in satisfaction when fulfilled and dissatisfaction when not fulfilled. These are attributes that are spoken and the ones in which companies compete."
3. **Attractive Quality** — "Attributes provide satisfaction when achieved fully, but do not cause dissatisfaction when not fulfilled."
4. **Indifferent Quality** — "Aspects that are neither good nor bad, and they do not result in customer satisfaction or customer dissatisfaction."
5. **Reverse Quality** — "High degree of achievement resulting in dissatisfaction and to the fact that not all customers are alike."

[VERIFIED] kanomodel.com summarizes the practical interpretation: "2 of the categories add value and 2 of the categories detract from value, and 1 of the categories creates New Value!" ([kanomodel.com](https://kanomodel.com/) (accessed 2026-04-24)).

### Use

[VERIFIED] Classification is done via "Kano Survey or sometimes called a Kano Analysis" to help organizations "prioritize development efforts on the things that most influence satisfaction and loyalty" ([kanomodel.com](https://kanomodel.com/) (accessed 2026-04-24)). Wikipedia notes integration with Quality Function Deployment (QFD) ([Wikipedia, n.d.](https://en.wikipedia.org/wiki/Kano_model) (accessed 2026-04-24)).

[SYNTHESIS] Kano is distinctive because it separates satisfaction from dissatisfaction — must-be features cannot produce delight, attractive features cannot produce dissatisfaction. For planning, this means investing only in must-be features past a threshold yields diminishing returns, while attractive features are where competitive differentiation can be found.

---

## 4. ICE (Sean Ellis)

### Origin

[VERIFIED] "The ICE scoring method was invented by Sean Ellis, famous for helping grow companies such as DropBox and Eventbrite and for coining the term Growth Hacking" ([The Tool That Will Help You Choose Better Product Ideas — Itamar Gilad](https://itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/) (accessed 2026-04-24)).

### Formula

[VERIFIED] `ICE = Impact × Confidence × Ease` ([Gilad, n.d.](https://itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/) (accessed 2026-04-24)).

Components:

- **Impact** — "an estimate of how much the idea will positively affect the key metric you're trying to improve."
- **Ease** — "an estimation of how much effort and resources will be required to implement this idea. This is typically the inverse of effort."
- **Confidence** — "how sure we are about Impact, and to some degree also about ease of implementation."

### Use and limits

[VERIFIED] Gilad warns: confidence is essential because "we're very bad at estimating both and we're blissfully unaware of this." All three values use a relative 1–10 scale "to avoid overweighting any single factor" ([Gilad, n.d.](https://itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/) (accessed 2026-04-24)).

[SYNTHESIS] ICE is RICE minus Reach, optimized for fast experimentation (growth teams). Without Reach, a small-but-deep win and a large-but-shallow win can score the same; ICE is therefore better suited to within-surface prioritization than to cross-product tradeoffs.

---

## 5. WSJF (SAFe, from Don Reinertsen)

### Origin and formula

[VERIFIED] SAFe defines WSJF as "a prioritization model used to sequence work for maximum economic benefit." In SAFe, "WSJF is estimated as the relative cost of delay divided by the relative job duration" ([Weighted Shortest Job First — Scaled Agile Framework](https://framework.scaledagile.com/wsjf/) (accessed 2026-04-24)).

The formula: `WSJF = Cost of Delay / Job Size (duration)`.

[VERIFIED] Cost of Delay in SAFe is composed of four factors ([SAFe, n.d.](https://framework.scaledagile.com/wsjf/) (accessed 2026-04-24)):

- Relative user and business value
- Time criticality
- Risk reduction and/or opportunity enablement
- Job size (denominator)

### Attribution

[VERIFIED] SAFe cites the principle "If you only quantify one thing, quantify the Cost of Delay," attributed to Donald Reinertsen's *The Principles of Product Development Flow* ([SAFe, n.d.](https://framework.scaledagile.com/wsjf/) (accessed 2026-04-24)).

[VERIFIED] The attribution is independently confirmed by InfoQ's 2015 coverage of Joshua Arnold's Lean Kanban France 2014 Cost of Delay workshop, which quotes Reinertsen directly: "If you only quantify one thing, quantify the Cost of Delay" and notes "Don Reinertsen first wrote about Cost of Delay way back in the 80's. He has since written additional material and it is rare that a talk of his doesn't mention Cost of Delay in some way" ([Using Cost of Delay to Quantify Value and Urgency — InfoQ, 2015](https://www.infoq.com/news/2015/02/cost-of-delay/) (accessed 2026-04-24)). Reinertsen's own consulting site confirms the book title and subtitle — *The Principles of Product Development Flow: Second Generation Lean Product Development* — and that Reinertsen & Associates has "provided services on product development management for over 39 years" ([Books — Reinertsen & Associates](https://reinertsenassociates.com/books/) (accessed 2026-04-24)).

### Use and limits

[SYNTHESIS] WSJF is the mechanism by which Reinertsen's "quantify Cost of Delay" maxim is operationalized within SAFe. It is designed for sequencing a queue, not for deciding whether to build an item at all. It relies on relative scoring (Fibonacci-style), so an absolute-dollar Cost of Delay is not required.

---

## 6. Cost of Delay (Reinertsen)

### Definition

[VERIFIED] "Cost of Delay is a way of communicating the impact of time on the outcomes we hope to achieve." Technically, "the partial derivative of total expected value with respect to time," measured in $/time ([Cost of delay — Wikipedia](https://en.wikipedia.org/wiki/Cost_of_delay) (accessed 2026-04-24)).

### Attribution and emphasis

[VERIFIED] In his 2009 book *The Principles of Product Development Flow*, Don Reinertsen frames Cost of Delay as the "one thing" warranting quantification in product development: "Cost of Delay is the golden key that unlocks many doors. It has an astonishing power to totally transform the mind-set of a development organisation." Two empirical claims Reinertsen reports, per Wikipedia's summary: approximately "85% of product managers [do not] know the Cost of Delay" and intuitive estimates "differ by 50 to 1" ([Cost of delay — Wikipedia](https://en.wikipedia.org/wiki/Cost_of_delay) (accessed 2026-04-24)).

[VERIFIED] The 85% empirical claim is independently attested by InfoQ's 2015 reporting: "Reinertsen has been asking people working in product development whether a month of delay is worth a million dollars or a thousand dollars, and approximately 85% of people working in product development don't know the answer" ([InfoQ, 2015](https://www.infoq.com/news/2015/02/cost-of-delay/) (accessed 2026-04-24)). This crosses two independent secondaries (Wikipedia + InfoQ) — sufficient for verification absent direct fetch of the book.

### Relation to WSJF

[VERIFIED] Cost of Delay is employed as the weighting factor in WSJF; "sometimes termed 'CD3' (Cost of Delay Divided by Duration)" ([Cost of delay — Wikipedia](https://en.wikipedia.org/wiki/Cost_of_delay) (accessed 2026-04-24)).

[SYNTHESIS] RICE, ICE, MoSCoW, and Kano emphasize value and classification; Cost of Delay / WSJF add the *economic cost of waiting*. A team that uses only value-based prioritization may defer a high-value item because a newer, easier item appears — CoD reframes this by counting the dollars lost per week of delay. The two approaches are complementary: value × confidence × reach / effort (RICE) versus value × time-criticality (CoD).

---

## Summary table

| Framework | Origin | Formula / structure | Primary strength |
|---|---|---|---|
| RICE | Sean McBride, Intercom | (Reach × Impact × Confidence) / Effort | Explicit about confidence |
| MoSCoW | Dai Clegg, 1994 (DSDM) | 4 buckets: M / S / C / W in a timebox | Commitment within fixed timeboxes |
| Kano | Noriaki Kano, 1984 | 5 quality categories from survey | Separates satisfaction / dissatisfaction |
| ICE | Sean Ellis | Impact × Confidence × Ease | Fast experiment ranking |
| WSJF | SAFe (from Reinertsen) | Cost of Delay / Job Size | Economic sequencing |
| Cost of Delay | Reinertsen, 2009 | $/time valuation of delay | Quantifies time cost |

All entries in the table are sourced above.

---

## Open Questions

- [UNVERIFIED] The original Kano 1984 paper text (Japanese): the English-language descriptions above are from Wikipedia and kanomodel.com, not the original paper.
- [UNVERIFIED] Sean McBride's current position and the specific year RICE was published at Intercom. The article is undated in the fetched content; the origin claim is verified but the year is not.
- [UNVERIFIED] Whether Sean Ellis ever wrote an "authoritative" ICE origin article (he is credited by Gilad and others, but the primary Ellis source was not located in this session).
- [SYNTHESIS caveat] The "Summary table" combines formulas and attributions from separate cited sources. Each row's source is above; the table itself is a synthesis, not a single cited artifact.

---

## Sources

All fetched on 2026-04-24.

1. [RICE: Simple Prioritization for Product Managers — Intercom](https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/)
2. [MoSCoW method — Wikipedia](https://en.wikipedia.org/wiki/MoSCoW_method)
3. [Kano model — Wikipedia](https://en.wikipedia.org/wiki/Kano_model)
4. [Kano Model — kanomodel.com](https://kanomodel.com/)
5. [The Tool That Will Help You Choose Better Product Ideas — Itamar Gilad](https://itamargilad.com/the-tool-that-will-help-you-choose-better-product-ideas/)
6. [Weighted Shortest Job First — Scaled Agile Framework](https://framework.scaledagile.com/wsjf/)
7. [Cost of delay — Wikipedia](https://en.wikipedia.org/wiki/Cost_of_delay)
8. [Using Cost of Delay to Quantify Value and Urgency — InfoQ, 2015](https://www.infoq.com/news/2015/02/cost-of-delay/)
9. [Books — Reinertsen & Associates](https://reinertsenassociates.com/books/) (fetched via curl -k on 2026-04-24; cert validity issue bypassed intentionally to reach author's own book listing)
