# Phase 01 — Discover

**Goal:** Find a problem worth solving for a specific group of customers, and gather enough evidence that it is real, painful, and addressable to justify building something.

**Duration:** 2–8 weeks for a new product. For a new feature inside an existing product, 1–3 weeks. Continuous thereafter — discovery is never "finished."

**You are done when:**
- You have interviewed at least 10–15 customers in a sharply defined target segment.
- You can state the problem in one sentence and back it up with direct customer quotes.
- You have identified the riskiest assumption and how you will test it next.
- You have a prioritized list of opportunities (unmet needs, pains, desires) — not a list of features.
- The team agrees on the outcome you are trying to change, and has evidence it matters to customers.

---

## What this phase is about

Most failed products do not fail because the team could not build the thing. They fail because the team built the wrong thing. Discovery is the disciplined work of figuring out what is worth building before you spend the calendar and the payroll to build it.

Discovery requires a mindset shift. In solution-first thinking, you start with a feature idea ("let's build a dashboard"), then hunt for customers who might like it. In problem-first thinking, you start with a sharply defined customer and a problem they actually experience, and the solution emerges last. The same team, working on the same idea, produces radically different products depending on which way they face. Face the customer.

Discovery is also not a phase you finish and then abandon. Teresa Torres's framing — product discovery is "the work that we do to make decisions about what to build" — reframes it as a continuous habit, not a project. The first run through Phase 01 is the most intensive because you start cold; after that, a weekly rhythm of customer contact sustains every subsequent phase, including running the system in production. Treat this chapter's prescriptions as the foundation for an ongoing practice.

The output of this phase is not a spec. It is a sharp problem statement, a short list of the customer opportunities that matter most, and honest evidence about which of the four big risks will kill you first. If you leave Phase 01 with a feature list, you skipped it.

---

## Who does what

At team size 2–20, people wear multiple hats. What matters is that every responsibility below has a named owner.

- **Product (PM or founder-PM)** — Owns the phase. Accountable for whether the team is solving a valuable problem for a real customer. Drives interview recruiting, synthesis, and the problem statement. Owns the value and business viability risks.
- **Design (designer or design-aware PM)** — Co-leads interviews, draws journey maps, builds the first artifacts (personas, opportunity solution tree). Owns the usability risk. Designers make discovery findings legible — do not cut them from this phase to save them for later.
- **Engineering (lead or senior engineer)** — Participates in interviews (at least some), weighs in on feasibility early, asks the dumb questions that founders and PMs skip. Owns the feasibility risk. Engineers who never meet customers build the wrong abstractions; put at least one engineer in the room.
- **Customers** — The actual experts. Discovery fails when teams substitute their internal knowledge for real customer contact.

One person drives the phase end-to-end. Discovery by committee produces mush. Pick a driver.

---

## Inputs

Before you start, have the following in hand:

- **A rough idea or hypothesis.** A one-line statement of what you think might be true: "We think [customer segment] struggles with [problem] because [insight]." This is not a commitment; it is a starting point to falsify.
- **A target customer hypothesis.** Who you think the customer is, specifically enough to know who to call. "Small businesses" is not specific enough. "Two-to-ten person dental practices that bill insurance and manage their own schedule" is.
- **Access to potential users.** At least a path to reach 20+ people in the target segment. If you have zero access, your first job is to build access — LinkedIn outreach, existing network, niche communities, paid recruiting (UserInterviews.com, Respondent.io), or a small waitlist landing page.
- **A budget for research.** Incentives for interview participants ($50–$150 gift cards for consumer research; $150–$500 for specialist B2B) plus tooling (a recording tool, a notes doc, a simple research tracker).
- **Two focused weeks on the calendar.** If the team is firefighting other work, discovery gets diluted into nothing. Block the time.
- **Foundations from Phase 0.** A team with product, design, and engineering coverage, the operating principles and baseline tooling listed in the handbook README.

If any of these are missing, fix that before you start interviewing. Running discovery without a customer hypothesis produces confusion; without access, produces delay.

---

## The steps

These are sequential, but they overlap in practice. Expect to revisit earlier steps as you learn.

### Step 1 — Pick a customer segment sharp enough to matter

**What to do.** Name a specific group of people, narrow enough that a stranger hearing the description could identify whether someone belongs. Write it down in one sentence. Resist the temptation to broaden it for the sake of market size — a sharp niche with an acute problem beats a broad market with a vague one.

**How.** Use the following template for a segment definition:

```
We are building for [role/title] at [type of organization OR life context],
who [current primary activity relevant to the problem],
and who [qualifying constraint — tooling, size, regulation, stage].
```

Examples:
- "Solo freelance designers working on 3+ client projects concurrently, who currently invoice via a mix of email and PDFs."
- "Operations managers at US Series A–B SaaS companies with 20–100 employees, who are responsible for onboarding new hires and currently use Notion and Google Forms."

If your segment is "everyone who uses spreadsheets," you have not picked a segment.

**Output.** A one-sentence segment definition, posted visibly so the team refers to it when recruiting and interviewing.

### Step 2 — Get in front of real customers, weekly

**What to do.** Run 10–15 customer interviews in your target segment over 2–4 weeks for a new product. Commit to a standing cadence — 3 to 5 interviews per week, every week — and keep it going past this phase into regular operations. Torres's benchmark is "at least weekly" customer contact forever. Hit that cadence during discovery and do not let it lapse.

**How.** Use semi-structured **user interviews** following the NN/g practice: define research goals, prepare an interview guide with open-ended questions, pilot the guide once or twice before using it in anger, start with easy rapport-building questions, probe with "tell me more about that."

Anchor interviews on stories, not opinions. Ask "tell me about the last time you [did the thing]" and follow the specifics. Do not ask "would you use a product that does X?" — people are bad at predicting their future behavior and too polite to tell you your idea is bad. Torres calls these **story-based interviews**, and they are the unit of discovery input.

Logistics:
- 30–45 minutes each, recorded (with consent) and transcribed.
- At least two people on the team side: one interviewer, one note-taker. Rotate so everyone attends some.
- Offer an incentive appropriate to the segment. Skipping this halves your response rate.
- Take notes in a shared template: who, when, their context, the stories they told (verbatim quotes are gold), emergent pains/desires, open questions.

**Output.** 10–15 interview transcripts or notes. An **evidence log** — a running list of verbatim quotes, tagged by theme, with a pointer back to the source interview.

### Step 3 — Synthesize into jobs, opportunities, and a solution tree

**What to do.** Turn raw interview notes into structure. Two compatible framings, pick one as the primary and borrow from the other as needed.

- **Jobs-to-be-Done (JTBD).** Frame each customer story as a "job" — the progress the person was trying to make, the circumstances that surrounded the decision, and the functional, social, and emotional dimensions. Christensen's framing: "People don't simply buy or pick products or services; they pull them into their lives to make progress." The JTBD lens helps the team see competition correctly — the milkshake competes with bananas and bagels, not other shakes. Use it when the problem cuts across roles and the "job" is what unifies your customers.

- **Opportunity Solution Tree (OST, Torres).** Pick the product **outcome** you want to change (a customer behavior or sentiment, not a revenue number). Branch into **opportunities** — unmet needs, pain points, desires you heard in interviews. Under each opportunity, list candidate **solutions**. Under solutions, list **assumption tests**. Use it when you have a clear target outcome and want a shared visual for prioritization.

A minimal OST template:

```
Outcome
  (one product outcome — e.g., "New users complete first invoice within 10 minutes")
  |
  ├── Opportunity: "I can never find last month's template fast enough"
  │     ├── Solution A: Pinned recent templates
  │     │     └── Assumption test: prototype + 5-user test
  │     └── Solution B: Smart search
  │           └── Assumption test: log current search behavior
  ├── Opportunity: "I re-enter client info every time"
  │     └── Solution C: Persistent client book
  │           └── Assumption test: desirability probe in next 3 interviews
  └── Opportunity: "I don't know if clients opened the invoice"
        └── Solution D: Read receipts
              └── Assumption test: willingness-to-pay survey
```

Torres recommends drawing the first tree after 3–4 story-based interviews and updating it as you learn.

**How.** Block 2–3 hours with the core team after every 3–5 interviews. Put quotes on sticky notes (physical or Miro/FigJam). Cluster into themes. Name opportunities in the customer's voice, not yours: "I waste an hour on Monday reconciling timesheets" is an opportunity. "Timesheet reconciliation feature" is a solution and does not belong at that level.

**Output.** An Opportunity Solution Tree (or a JTBD canvas) with opportunities backed by evidence from the log. A working list of solutions linked to opportunities, not floating in the air.

### Step 4 — Test the four big risks

**What to do.** Before you commit to building anything, stress-test the strongest candidate solutions against Marty Cagan's four big risks:

- **Value risk** — Will customers actually use or buy this? Will it matter to them?
- **Usability risk** — Can users figure out how to use it?
- **Feasibility risk** — Can we build it with the team, time, and technology we have?
- **Business viability risk** — Does it fit our business — sales, marketing, legal, support, economics?

Treat these as distinct, addressable risks. Do not let "value" quietly swallow "business viability" — Cagan's own reason for splitting them out was that bundled "valuable" obscured too much.

**How.** Match each risk to the cheapest test that actually produces evidence:

| Risk | Typical tests |
|---|---|
| Value | Story-based interviews; landing-page tests with a sign-up; Wizard-of-Oz prototype; pre-sales conversations |
| Usability | Paper or clickable prototype + qualitative usability test with 5 users (iterate, do not stop at 5 — Nielsen recommends three rounds of 5 over one round of 15) |
| Feasibility | Engineer-led spike; proof-of-concept for the riskiest integration or algorithm; vendor/API evaluation |
| Business viability | Pricing sanity-check with finance/founders; channel math with marketing/sales; legal/compliance check for regulated segments |

Name the single **riskiest assumption** first, and test that one before the others. If value is unclear, do not debug the database. If usability is fine but value is not proven, do not polish the design. Order matters.

Include an **ethics check** when your product touches sensitive data, vulnerable users, or automated decisions. Torres adds "ethical" as a fifth risk category for a reason — asking "who could this harm, and how would we know?" is cheap to do now and expensive to retrofit later.

**Output.** An **assumption map**: top 5–10 assumptions ranked by (a) how critical they are if wrong and (b) how much evidence you currently have. A plan for testing the top three in the next 1–2 weeks.

### Step 5 — Distill into a problem statement and a prioritized opportunity list

**What to do.** Write the problem statement. It is a single, specific sentence. Everyone on the team should be able to recite it from memory.

**Problem statement template** (adapt as needed — this is a synthesis of Design Thinking's Define-mode output and JTBD framing):

```
[Segment] needs a way to [job / progress they are trying to make],
because [insight about their context or motivation],
but [current obstacle or unmet need].
```

Worked example:

> Solo freelance designers juggling 3+ client projects need a way to get paid within a week of sending an invoice, because cashflow gaps stall their own business, but chasing payment feels pushy and they often let late invoices slide for weeks.

Then prioritize opportunities. Torres suggests picking one opportunity at a time to focus on — not because the others don't matter, but because parallel attacks dilute focus. Rank opportunities on:
- **Impact on the outcome** — if solved, how much does the target product outcome move?
- **Evidence strength** — how many customers independently described this pain?
- **Confidence we can address it** — feasibility and business-fit, high level.

**How.** Draft the problem statement in one sitting after you have at least 10 interviews in hand. Share it with three customers and ask "does this describe your experience?" — if it does not, rewrite it. Keep iterating until customers nod.

**Output.** A one-sentence problem statement. A ranked list of 3–7 opportunities, with the top one called out as the focus. An evidence log that backs up every claim in the problem statement with at least two customer quotes.

### Step 6 — Decide: proceed, pivot, or kill

**What to do.** End the phase with an explicit decision meeting. Read out the problem statement, the opportunity list, the results of the assumption tests, and the outstanding risks. Pick one of three paths:

- **Proceed** to Phase 02 (Plan). The problem is real, the segment is reachable, the top opportunity is worth attacking, and the riskiest assumption survived its first test.
- **Pivot.** Ries: a pivot is "a structural course correction to test a new fundamental hypothesis about the product, strategy and engine of growth." You keep what you learned and change what you are testing — new segment, new problem frame, new solution class.
- **Kill.** The problem is not painful enough, the segment is not reachable, or the economics do not work. This is a success of discovery, not a failure. You saved months.

Write the decision down with the evidence that drove it. You will want this record in three months when someone asks "why didn't we do X?"

**How.** 60–90 minute meeting, whole team, async pre-read of the artifacts, decision in the room. The product lead has the final call, but engineering and design get a voice — if a senior engineer says "we cannot build this in under a year," that is data. The product outcome, not enthusiasm, decides.

**Output.** A written decision — proceed / pivot / kill — plus a statement of what changes if pivot, or a summary of learnings if kill.

---

## Artifacts you'll produce

You should leave this phase with these artifacts, in this order of importance. Keep them in whatever your team's long-lived docs home is (Notion, Confluence, a `/docs` folder). They are living documents.

### 1. Problem statement

One sentence. The template from Step 5:

```
[Segment] needs a way to [job / progress they are trying to make],
because [insight about their context or motivation],
but [current obstacle or unmet need].
```

### 2. Evidence log

A table — spreadsheet or doc — with one row per noteworthy customer quote. Columns: quote (verbatim), speaker (pseudonym + role), date, theme/opportunity it supports, source link (transcript). The log is the accountability layer — if you cannot link a claim in your problem statement to at least two rows in the log, the claim is weak.

### 3. Opportunity Solution Tree (or JTBD canvas)

Single-page visual. Outcome at the top; opportunities in the middle, each with 2+ evidence pointers; solutions under opportunities, each tagged with an assumption test and its status. Revisit weekly during discovery; after this phase, revisit at least monthly.

### 4. One persona or JTBD statement

Lightweight, built from interview data. NN/g's three approaches run from lightweight (a one-pager) to statistical (survey-backed). At small team sizes, pick lightweight: a one-page description of the target user — role, context, a day in the life, top jobs, current workarounds, quotes. Do **not** add demographics, gendered stock photos, or invented details. Keep it based on what you heard.

If you prefer JTBD, write a single "when [situation], I want to [motivation], so I can [expected outcome]" statement per primary job.

### 5. Assumption map

A 2x2 or ranked list showing top assumptions by criticality and current evidence. Critical-and-unevidenced assumptions are the ones you test next. Roll this into Phase 02 planning.

### 6. Decision record

A short doc: what we decided (proceed/pivot/kill), the evidence behind it, open risks carried forward, and who was in the room. Treat as you would an ADR for architecture — it is the record that future-you will need.

---

## Anti-patterns

1. **Building before you've talked to users.** Teams start prototyping because it feels productive, then search for users to validate what they already built. You will validate imaginary customers and ship to real ones who do not care. Flip the order: interview first, prototype second. Torres's whole point is that without weekly customer contact, experts drift into the *curse of knowledge* and decisions become disconnected from reality.

2. **Leading interview questions.** "Would you use a feature that helps you do X faster?" is a question for a sales pitch, not research. People are polite; they will say yes; you will believe them; you will be wrong. Ask "tell me about the last time you did X" and follow the specifics. Attitudinal questions ("would you like…") belong in marketing copy tests, not discovery interviews.

3. **Confusing opinions with evidence.** A founder saying "I know our users want X" is not evidence. A sales rep saying "customers always ask for X" is secondhand and often wrong. A product manager's intuition is a hypothesis, not a finding. Evidence is a customer, on the record, telling you about a specific experience. Operating principle from the handbook: evidence over opinion. Hold yourselves to it.

4. **Skipping discovery because "we know our users."** Teams that believe they already understand the customer skip interviews and save themselves two weeks. They spend two quarters building the wrong thing. If you cannot point to an interview from the last 30 days, you do not know your users right now. Even if you were right last year, the market moved.

5. **Over-quantifying too early.** Running a 500-person survey before you have 10 interviews looks rigorous but is backwards. You do not yet know which questions matter; you are just counting noise. NN/g is explicit: qualitative survey results "are rarely representative for the whole target audience." Use qualitative interviews to find the questions; use surveys later to measure prevalence.

6. **Treating discovery as a one-time phase.** The worst version of this chapter is the team that runs discovery once, writes a deck, and never talks to a customer again. Discovery is continuous. Torres's two weekly habits — customer interviewing and assumption testing — are the operating model, not the kickoff. If you only interview users in Phase 01 and again after launch, you are flying blind for 90% of the journey.

---

## Scale notes

- **Solo founder.** You are the PM, designer, and engineer. Do not skip interviews — do fewer, do them yourself, and record everything. Cut interview prep ceremony and synthesize as a stream-of-consciousness doc. Aim for 8–10 interviews instead of 15. Skip the formal persona; write a half-page profile instead. Keep the evidence log — you will need it when you hire and have to transfer context.

- **Team of 5.** This is the default the handbook is written for. One person drives discovery; designer and one engineer join at least half the interviews. Weekly synthesis sessions. Full artifact set, kept lightweight (single-page docs, not decks).

- **Team of 50+.** Discovery becomes a distributed practice. Every pod or squad has a discovery track running alongside delivery (Patton's **dual-track development**: "two concurrent types of work within a single agile product development process: discovery and development"). A central research function may support recruiting, synthesis tooling, and shared repos, but the pod product manager still owns the discovery work. Add: a shared research repo (Dovetail, Aurelius, Notion), standardized interview templates, cross-pod synthesis once a quarter to catch themes no single pod sees. Resist turning discovery into a separate team that hands specs to delivery — Patton explicitly warns that dual-track is about two kinds of work, not two kinds of people.

---

## Exit checklist

Use this checklist at the Step 6 decision meeting. Every box must have a yes or an explicit acknowledgement of the gap.

- [ ] We have spoken with at least 10–15 customers in the target segment in the last 4 weeks.
- [ ] We can state the problem in one sentence, and that sentence has survived being read back to at least 3 customers.
- [ ] We have an evidence log with at least 2 verbatim quotes supporting every claim in the problem statement.
- [ ] We have identified the riskiest assumption and run at least one test against it.
- [ ] We have prioritized 3–7 opportunities (unmet needs/pains), with a top-1 focus — not a list of features.
- [ ] We have an Opportunity Solution Tree (or JTBD canvas) that the whole team can read.
- [ ] Design has run (or scheduled) a usability test against the top-1 candidate solution with 5 users.
- [ ] Engineering has done (or scheduled) a feasibility spike on the riskiest technical assumption.
- [ ] We have an explicit check on business viability — pricing, channel math, economics, legal — not just "the customer will like it."
- [ ] We have a standing weekly customer-interview cadence planned for Phase 02 and beyond; discovery does not stop here.
- [ ] The decision — proceed / pivot / kill — is written down, with evidence, and the team is aligned.

---

## Why this works

Every prescription in this chapter traces to the research corpus. The research documents the full landscape of competing approaches fairly; this chapter picks a single opinionated path through it.

- **Continuous discovery, weekly customer contact, opportunity solution trees.** See [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §1 (Torres) for the continuous-discovery model and the two weekly habits; [`../research/01-ideation/requirements.md`](../research/01-ideation/requirements.md) §6 for the full OST structure and definitions. The Torres primary sources are cited in both files.

- **The four big risks — value, usability, feasibility, business viability.** See [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §2 for Cagan's framing, including his reason for splitting "valuable" into value and business viability, and for role accountability (PM owns value/viability, design owns usability, engineering owns feasibility). The "ethics check" note in Step 4 traces to Torres's five-category variant, also documented in §1 of that file.

- **Jobs-to-be-Done framing.** See [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §6 for Christensen's "progress" framing, the milkshake example, and Ulwick's Outcome-Driven Innovation. The functional/social/emotional dimensions and the milkshake-vs-bagels competition insight come from the Christensen Institute source cited there.

- **Story-based interviews and 5-user usability testing.** See [`../research/01-ideation/user-research.md`](../research/01-ideation/user-research.md) §3 (interview practice from NN/g), §4 (Nielsen's 5-users rule and the "three studies of 5 users" recommendation), §2 (NN/g's phase-matching: interviews and field studies in Discover, usability testing in Test).

- **Problem statement, persona, and journey-map artifact guidance.** See [`../research/01-ideation/requirements.md`](../research/01-ideation/requirements.md) §4–§5 and [`../research/01-ideation/user-research.md`](../research/01-ideation/user-research.md) §8–§9 for the primary-source definitions from NN/g (Kaplan on personas, Gibbons on journey maps). The problem-statement template in Step 5 is a synthesis noted in [`../research/01-ideation/requirements.md`](../research/01-ideation/requirements.md) §8, which flags that a canonical primary source was not fetched — the shape used here is consistent with the Design Thinking Define-mode output described in [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §5.

- **Build–Measure–Learn, MVP, validated learning, pivot-or-persevere.** The "decide: proceed, pivot, or kill" step in Step 6 draws directly on Ries's Lean Startup framing. See [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §3 for the cited definitions of validated learning and pivot, and §4 for Andreessen's product/market-fit signals that frame why discovery matters in the first place.

- **Dual-track development at scale.** The "Team of 50+" scale note invokes Patton's dual-track model. See [`../research/01-ideation/discovery.md`](../research/01-ideation/discovery.md) §7 for Patton's definition and his quotation of Sy's original 2007 paper, and [`../research/01-ideation/README.md`](../research/01-ideation/README.md) §9 for the integration-with-delivery summary.

- **Phase framing and discovery-as-the-front-end of the PDLC.** See [`../research/01-ideation/README.md`](../research/01-ideation/README.md) §1–§2 for the scope of the ideation stage, and §8 for the full artifact taxonomy (personas, journey maps, opportunity solution trees, user story maps, problem statements) that this chapter's artifact list draws from.

If a specific prescription above feels wrong for your context, follow the link, read the source, and adjust. The handbook picks a default; the research explains.
