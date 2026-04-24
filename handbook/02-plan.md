# Phase 02 — Plan

**Goal:** Turn validated opportunities into a concrete plan for the first release, with a measurement framework.
**Duration:** 1–3 weeks for initial planning; ongoing weekly thereafter.
**You are done when:** You have a product strategy, MVP scope, prioritized backlog, and a shared understanding of how you'll measure success.

---

## What this phase is about

Phase 01 gave you a validated problem and one or more opportunities. Phase 02 is where you answer four linked questions: *what are we building first, for whom, why now, and how will we know it worked?* If Phase 01 is about discovering a worthy destination, Phase 02 is about picking the next port of call and provisioning the ship for it.

The core tension in this phase is between **scope and speed**. Every team under-estimates how much scope a "first release" can carry and over-estimates how fast it can ship. The handbook's position is that speed is more valuable than scope here, because you are still learning. Learning velocity compounds. Scope that ships late teaches you less than scope that ships early — even if the later, bigger thing is "better" on paper. The planning artifacts below exist to make the scope/speed tradeoff visible and explicit, not to hide it.

A second tension is between **plan and reality**. You will be wrong about things. Good planning at this stage is not a prediction; it is a *guiding policy* (to borrow Rumelt's word) — a direction, plus a few concrete near-term actions, plus a measurement framework so you can tell whether the policy is working. If your plan assumes you know more than you do, it will brittle. If it assumes you know less than you do, you will drift. The target is a plan that is firm about direction and loose about details beyond the next release.

---

## Who does what

Phase 02 is primarily led by the **Product Manager** (or whoever is accountable for what to build and why). In a small team, this is often a founder. But the planning artifacts below are cross-functional; if the PM writes them alone, they'll be wrong.

- **PM / Product lead** — owns the product strategy, MVP scope, OKRs, and roadmap. Writes the first drafts. Facilitates prioritization. The Scrum Guide's "Product Owner" accountability applies: "Ordering Product Backlog items... ensuring that the Product Backlog is transparent, visible and understood" (see [research/02-planning/README.md](../research/02-planning/README.md) §3).
- **Engineering lead** — co-owns the estimate of effort, surfaces technical risks that change scope, owns iteration cadence. Veto power on "can we actually build this in that shape."
- **Design lead** — surfaces user experience risks, contributes to scope (what experience is non-negotiable vs. what can be crude in the MVP). Co-owns the MVP scope document.
- **Stakeholders** (executives, investors, early customers, sales) — consulted, not consenting. Their input shapes the strategy; they do not vote on the backlog. Name them explicitly and plan how you'll update them (see the Now/Next/Later roadmap below — it's the main artifact they see).

If no one person owns "what is the product and why" after Phase 02, you will get scope drift within two sprints. Fix this before you move on.

---

## Inputs

From Phase 01, you should have:

- A sharp **problem statement** — one or two sentences naming a specific user, context, and unmet need.
- A list of **validated opportunities** — discovery work that tested demand (user interviews, signal analysis, prototype responses).
- **Assumption test results** — which hypotheses about the problem survived, which were invalidated, and what remains risky.
- Baseline **customer evidence** — quotes, observations, quantitative signals.

If you are missing any of these, go back. Planning built on unvalidated opportunities ships features nobody asked for. The research repeatedly frames this as the failure mode to avoid: "the real value of starting with an outcome is it helps us focus on value creation rather than just output creation" (Torres, via [research/02-planning/okrs.md](../research/02-planning/okrs.md) §4).

---

## The steps

Recommended sequence — do these roughly in order, though steps 5–8 overlap once the strategy is written.

### Step 1 — Write a product strategy (one page)

Do this first. Do this before you open a roadmap tool or a prioritization spreadsheet. Everything else traces to this page.

Richard Rumelt's framing is the one to use: strategy is a **kernel** of three parts — a **diagnosis** of the challenge, a **guiding policy** for dealing with it, and **coherent actions** that carry out the policy. "Weak diagnosis" is what Rumelt calls "the most common cause of bad strategy" (see [research/02-planning/README.md](../research/02-planning/README.md) §1.2). Cagan adds a separation between **vision** (5–10 year destination) and **strategy** (how we get there, quarterly revisited).

Combine the two into a one-page strategy. Template:

```
## Product strategy — [Product name]
Updated: [Date]. Next review: [Date + 1 quarter].

### Vision (5–10 years)
[1–2 sentences on the destination. Whose life is better, and how?]

### Diagnosis
[2–4 sentences naming the specific challenge/obstacle. What's broken for
whom, and why is it worth solving now? Cite evidence from Phase 01.]

### Guiding policy
[The approach we're taking, at the level of "signpost, marking the direction
forward but not defining the details." Not a feature list. 2–4 sentences.]

### Coherent actions (this quarter)
1. [Action tied to a user/market problem]
2. [Action tied to a user/market problem]
3. [Action tied to a user/market problem]

### How we win
[Why this works when others don't / what's our defensible edge. 1–2 sentences.]

### How we'll know (top metric + leading indicators)
- North-star metric: [1 metric that proxies the vision]
- Leading indicators: [2–3 faster-moving signals that tell us if we're on track]
```

Keep it on one page. If it spills to two, you haven't made the hard choices yet. Revisit it quarterly, per Cagan ("strategy is a living thing... we are explicitly revisiting it every quarter" — [research/02-planning/README.md](../research/02-planning/README.md) §1.1). Pin it somewhere the whole team sees daily.

### Step 2 — Define MVP scope (with explicit "not in scope")

The MVP is not "version one of the product." It is **the smallest thing you can ship that tests the riskiest assumption still standing after Phase 01**. Reframe from "what should the first version do?" to "what does our first release need to prove?"

List your riskiest remaining assumptions, ranked. Pick the top 1–2. The MVP exists to test those. Everything else is deferred.

Use this template:

```
## MVP scope — [Release name]
Updated: [Date]. Target ship: [~Date, ±2 weeks].

### Riskiest assumption being tested
[One sentence. E.g., "Small-business accountants will pay $49/mo for a
tool that reconciles Stripe transactions to QuickBooks in under 60 seconds."]

### Success looks like
[Concrete, measurable. "10 paying customers in 60 days" /
"40% of signups complete the reconcile flow in week 1" — not "launch a great product."]

### In scope (the thin slice)
- [Capability 1 — the minimum needed to test the assumption]
- [Capability 2]
- [Capability 3]

### Explicitly NOT in scope
- [Thing users will ask for that we are not building yet, and why]
- [Thing a reasonable competitor has that we don't need to prove the assumption]
- [Thing we'd build if we had 3× the time]

### Known crudeness we accept
- [Where we'll tolerate manual ops / ugly UI / hardcoded limits in v1]
```

The "explicitly NOT in scope" section is non-optional. If you skip it you will drift — new requests will land without a visible trade against something. Name 3–10 things you are consciously not building, and why. Revisit this list weekly during the MVP cycle.

"Known crudeness" is permission to be embarrassing. Hardcode a single currency. Use an internal-only admin UI instead of a customer-facing settings page. Email receipts manually. Ship the test, not the finished product.

### Step 3 — Set OKRs (outcome-based Objective + 3–5 Key Results)

OKRs make your strategy measurable. Use the structure John Doerr and What Matters describe: **one Objective + 3–5 Key Results** (see [research/02-planning/okrs.md](../research/02-planning/okrs.md) §1.1). At a 2–20 person company, set **1–3 company-level Objectives**, each with 3–5 KRs. Keep them on one or two pages total. "Less is more."

Critical distinctions, from the research:

- **Objective** — "what is to be achieved, no more and no less." Qualitative, inspirational, directional.
- **Key Results** — "specific, time-bound, and measurable." Must describe **outcomes, not activities** ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §3). "Ship feature X" is not a KR. "Reduce onboarding drop-off from 68% to 40%" is.
- **Cadence** — **quarterly** by default. Grove's original innovation was quarterly cycles replacing annual ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §5).
- **Committed vs. aspirational** — Google's convention: committed OKRs are expected to hit 1.0; aspirational OKRs target 0.7 with "high variance" ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §3). Name which kind each OKR is.
- **Decouple from compensation.** Grove's second innovation was separating OKRs from pay. If you tie bonuses to aspirational OKRs, you incentivize sandbagging — setting easy OKRs to guarantee payout ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §6).

Template:

```
## OKRs — Q[N] [Year]
Status: [Aspirational / Committed]

### Objective 1: [One qualitative, directional sentence]
- KR1: [Metric] from [baseline] to [target] by [date]
- KR2: [Metric] from [baseline] to [target] by [date]
- KR3: [Metric] from [baseline] to [target] by [date]

### Objective 2: ...
```

Concrete example (aspirational):

> **Objective:** Make new users activate in their first session.
>
> - KR1: Increase day-1 activation rate from 24% to 45% by end of Q3.
> - KR2: Reduce median time-to-first-value from 11 min to under 5 min.
> - KR3: Increase week-1 return rate from 31% to 50%.

All three KRs describe **customer behavior changes** (product outcomes in Teresa Torres's taxonomy), not feature deliveries. Torres's key framing: "Business outcomes measure the health of the business. Product outcomes measure a change in customer behavior. Product teams do have the ability to directly influence product outcomes" ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §4). Write KRs your team can actually move.

Pair OKRs with **CFRs** (Conversations, Feedback, Recognition) — a weekly or biweekly check-in rhythm where the team discusses progress toward KRs and adjusts ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §7). Without CFRs, aspirational OKRs fail because course-correction only happens at cycle boundaries.

### Step 4 — Build a Now / Next / Later roadmap

Use Janna Bastow's Now/Next/Later format. It was invented in 2012 precisely because "timeline roadmaps aren't effective, simple as that" ([research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §1). The three columns escalate in definition as they get closer:

- **Now** — what's in flight this sprint / this month. Clearly defined, detailed, spec'd.
- **Next** — what's likely after Now. Less detail, known shape.
- **Later** — big themes on the horizon. "Boulder blocks you can see in the distance but don't need to break down yet."

Make the rows **themes** (problems/outcomes) rather than features. Jared Spool's framing, quoted by ProdPad: themes are "a promise to solve problems, not build features" ([research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §2). For each initiative on the roadmap, answer three questions: *What are we doing? Why are we doing it? How does it connect to our OKRs?*

Example for an early-stage SaaS:

```
## Now / Next / Later — [Product]
Updated: [Date]

THEME: Onboarding activation
  Now:   Reduce signup→first-value friction (ship Q3, tied to O1 KR2)
  Next:  Personalize first-session based on stated use case
  Later: Onboarding for team accounts

THEME: Reliability of the core workflow
  Now:   Fix the top 3 drop-off points in Stripe reconcile flow
  Next:  Auto-reconcile for the top 5 transaction types
  Later: Multi-currency and multi-entity

THEME: Customer reach
  Now:   (none — deliberate)
  Next:  Self-serve trial sign-up
  Later: Referral program
```

Rules:

- **No hard dates on Next or Later.** Dates belong in the MVP scope doc and in sprint plans, not on speculative items. Bastow: "Fixed dates represent 'an illusion'" ([research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §1).
- **Each row is a theme, not a feature.** "Reduce onboarding drop-off" is a theme. "Add social login" is a candidate solution inside that theme — it belongs in the backlog, not on the roadmap.
- **Link every row to an OKR.** If you can't, either the OKR is wrong or the row shouldn't be on the roadmap.
- **Keep it to one page.** If you need more rows than fit, collapse similar themes or move speculative items off the page entirely.
- **Refresh monthly** (see Scale notes).

### Step 5 — Prioritize the backlog (pick one framework)

The backlog is the Scrum Guide's "emergent, ordered list of what is needed to improve the product. It is the single source of work undertaken by the Scrum Team" ([research/02-planning/README.md](../research/02-planning/README.md) §3.1). Order matters — the top of the backlog should be more detailed, near-ready-to-start items; the bottom can be coarser.

**Default recommendation: use RICE.** Go deep on framework selection in the [Prioritization](#prioritization-which-framework-to-pick) section below. Apply one framework consistently; do not run RICE and WSJF and MoSCoW in parallel.

Prioritization output:

- Top 10–20 items with RICE scores (or whichever framework you picked).
- Score inputs visible so the team can challenge them.
- Items re-scored when the underlying estimates change (new user evidence, changed effort estimate).

### Step 6 — Size items (relative, not hours)

Use **relative sizing** — story points or t-shirt sizes. Not hours. Mike Cohn's running-trail analogy ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §1): two runners of different speeds both agree the trail is 5 miles; they won't agree on how long it takes them. Story points strip individual speed out of the estimate.

Concrete ritual:

- Use **Fibonacci points**: 1, 2, 3, 5, 8, 13, 21. The widening gaps "match[] the observation that estimate uncertainty grows with size" ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §2).
- Or use **t-shirt sizes** (XS, S, M, L, XL) if your team finds numbers intimidating or argues about 3 vs. 5. Same idea, coarser.
- **Anything above 13 (or L) is too big to start.** Split it.
- Run **Planning Poker**: everyone estimates simultaneously on hidden cards, reveal at once. This prevents anchoring — "the first number spoken aloud sets a precedent for subsequent estimates" ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §2). When estimates diverge, the highest and lowest estimators explain their reasoning, then re-vote.
- For backlog refinement of many items, use **Magic Estimation** (silent sort of cards into relative buckets on a wall) — faster than Planning Poker for scale.

Estimate components ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §1): work + complexity + uncertainty, unified as **effort**. Do not try to estimate duration; do not separate "dev time" from "testing time."

**Velocity is a forecast tool, not a commitment.** If last sprint the team completed 22 points and the sprint before it was 18 and 26, the forecast range for next sprint is roughly 18–26. Use it to size how much work to pull in — not to promise stakeholders a number. The 2020 Scrum Guide does not even mention velocity ([research/02-planning/README.md](../research/02-planning/README.md) §6.3). Treating velocity as a productivity KPI for cross-team comparison or headcount decisions diverges from the framework that produced it and quickly degrades into gaming.

**When #NoEstimates makes sense:** small teams, small and uniform stories, high-trust. Vasco Duarte's argument: "you can easily decide which stories to take into a sprint without sizing those stories" if you slice work finely enough ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §4). For a team of 3–6 engineers shipping continuously with vertical slices under one day each, counting throughput (stories completed per sprint) is often sharper than pointing. Try it if pointing feels performative. Keep pointing if your stakeholders need a forecast or if story sizes vary wildly.

See the [Estimation](#estimation-what-actually-works) section below for more.

### Step 7 — Set up iteration cadence

Pick one. Commit. Don't oscillate.

**Default recommendation: 2-week sprints (Scrum).** Why 2 weeks and not 1 or 4:

- 1-week sprints: Planning, review, retro overhead eats too much of the cycle; not enough time to build a meaningful increment.
- 4-week sprints: Feedback loop too slow; mid-sprint reality changes cannot be incorporated without derailing plans.
- 2-week sprints: Enough time to ship a real slice, short enough to correct course often.

A 2-week Scrum sprint includes:

- **Sprint Planning** (2–4 hours): Why is this sprint valuable? What can be done? How? Output is a Sprint Goal and a Sprint Backlog ([research/02-planning/README.md](../research/02-planning/README.md) §4.1).
- **Daily standup** (≤15 min): Not status; alignment. "What's in my way?"
- **Backlog refinement** (1 hour/week): See Step 8.
- **Sprint Review** (1–2 hours): Show increment, gather feedback.
- **Retrospective** (1 hour): What to change about how we work.

**Alternative: continuous flow (Kanban) with WIP limits.** Use this when:

- Work arrives at unpredictable rates (support-heavy, incident-driven).
- Items are roughly uniform in size, so timeboxing adds little.
- The team is small (2–4) and planning overhead outweighs sprint benefits.

If you go Kanban, you still need: a visualized workflow, explicit WIP limits at each stage, and the four flow metrics — WIP, Throughput, Work Item Age, Cycle Time ([research/02-planning/README.md](../research/02-planning/README.md) §4.2). Without WIP limits, it's not Kanban; it's a to-do list.

Some teams combine ("Scrumban"). That's fine once you're fluent. Don't start there. Pick one, learn it, deviate consciously.

### Step 8 — Establish backlog refinement (weekly)

The Scrum Guide describes refinement as "the act of breaking down and further defining Product Backlog items into smaller more precise items... an ongoing activity" ([research/02-planning/README.md](../research/02-planning/README.md) §3.1).

Concrete weekly ritual (1 hour, mid-sprint):

- **PM prepares** 5–10 candidate items beforehand (brief, acceptance criteria, open questions).
- **Team reviews** each item: does it make sense? What's unclear? What are the risks?
- **Team estimates** items that are clear enough (Planning Poker).
- **Team splits** items that are too big (>13 points / > L).
- **PM updates** the backlog order based on refined understanding.
- **Items at the top of the backlog should be "Ready"** — estimated, understood, with acceptance criteria — before they enter Sprint Planning.

Attendance: PM is always in. Eng lead and design lead are always in. Rotate other engineers/designers in so context spreads. Whole-team refinement of every item wastes time.

**Rule of thumb: at any given moment, have 1.5–2 sprints' worth of Ready work at the top of the backlog.** Less, and you risk dry sprints. More, and you're over-planning things that will change before you build them.

---

## Artifacts you'll produce

By the end of Phase 02, these exist, are visible to the whole team, and are referenceable by anyone.

1. **One-page product strategy** (template above). Pinned in the team wiki. Reviewed quarterly.
2. **MVP scope document** (template above) with explicit "not in scope" section. Living — expect edits as you learn.
3. **OKR document** for the current quarter. 1–3 Objectives, 3–5 KRs each. Maximum two pages.
4. **Now / Next / Later roadmap.** One page. Theme-based, outcome-linked. Refreshed monthly.
5. **Prioritized backlog** in your issue tracker. Top 10–20 items scored; all items at least titled and rough-sized.
6. **Sprint cadence decision** — documented in the team wiki. "We run 2-week Scrum sprints starting Monday, Sprint Planning at 10am, Retro at 4pm Friday two weeks later." Boring, but it eliminates a class of future arguments.

Do not skip writing these down. The research on strategy is unanimous that undocumented strategy decays to "bad strategy" (Rumelt's term) within a cycle or two.

---

## Prioritization: which framework to pick

Several industry-standard frameworks exist. The research covers six: RICE, MoSCoW, Kano, ICE, WSJF, and Cost of Delay ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md)). You should pick **one** primary framework and stick with it. Running two or three in parallel produces competing scores and decision fatigue — the framework becomes a blocker instead of an accelerator.

### RICE — the default recommendation

**Formula:** `(Reach × Impact × Confidence) ÷ Effort`

Components, from Intercom's original post ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §1):

- **Reach** — how many people, over a defined period.
- **Impact** — how much each person is affected (Intercom uses a fixed scale, e.g., 3 = massive, 2 = high, 1 = medium, 0.5 = low, 0.25 = minimal).
- **Confidence** — how sure you are in the estimates (100%, 80%, 50%; be honest).
- **Effort** — person-months.

The resulting score "measures 'total impact per time worked.'"

**Use RICE when:** you have a mix of item sizes, a mix of surfaces (different user populations affected), and need to compare apples to oranges. It's the generalist framework. Modern SaaS teams of 2–20 almost always want this.

**Why it's the default:** It explicitly forces you to name **Reach** (otherwise a high-impact, low-reach item wins falsely) and **Confidence** (otherwise unverified assumptions score as if they were certainties). ICE, a close cousin, drops Reach — which is fine for within-surface comparisons on a growth team but risks over-weighting small-population, high-intensity wins.

### MoSCoW — use when you have a hard deadline

**Structure:** Four buckets — Must, Should, Could, Won't — all relative to a specific timebox ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §2).

**Use MoSCoW when:** the delivery is date-constrained (a launch event, a contractual deadline, a demo day) and the question is "what fits in this timebox?" rather than "what's highest value?" Its weakness is that two "Musts" cannot be ordered against each other; you'll still need a tiebreaker.

For MVP scoping, MoSCoW can complement the scope document in Step 2 — but within a MoSCoW tier, use RICE or effort estimates to order.

### Kano — use when planning delight / differentiation

**Structure:** Five quality categories — Must-be, One-dimensional, Attractive, Indifferent, Reverse ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §3). Attractive features produce delight when present but no dissatisfaction when absent; Must-be features produce dissatisfaction when missing but no delight when present.

**Use Kano when:** you're past MVP and deciding what to polish or differentiate on. Kano is a *mental model* for understanding feature value, often applied alongside RICE rather than instead of it. Don't drown an MVP backlog in Kano surveys; use it at the theme level when you're deciding *what to invest extra in* within a theme.

### WSJF — use for SAFe teams or large-org sequencing

**Formula:** `Cost of Delay / Job Size` ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §5). Cost of Delay is composed of user/business value, time criticality, and risk reduction / opportunity enablement.

**Use WSJF when:** you are in a SAFe environment or a larger organization coordinating multiple teams on a shared queue. The framework's strength is sequencing — picking the next item from a prioritized backlog of many — rather than deciding whether to build an item at all.

**Don't use WSJF in a 2–20 person team.** The overhead of estimating four relative factors (value, time-criticality, risk/opportunity, job size) for each item is not repaid by a small team's volume. RICE's four factors are lighter-weight.

### ICE — use for within-surface growth experiments

**Formula:** `Impact × Confidence × Ease` ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §4). Invented by Sean Ellis for growth-hacking ranking.

**Use ICE when:** a growth or experimentation squad is ranking similar-shape experiments on one surface (e.g., 20 landing-page tests). Inside that narrow comparison, Reach is constant and can be dropped.

**Don't use ICE as your main product prioritization.** Without Reach, a deep-but-narrow win and a shallow-but-wide win score the same, which is misleading for cross-product decisions.

### Cost of Delay — use as a mindset, not a ranking

Donald Reinertsen's maxim: "If you only quantify one thing, quantify the Cost of Delay" ([research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §6). Reinertsen reports that "approximately 85% of product managers [do not] know the Cost of Delay" and intuitive estimates "differ by 50 to 1."

**Use Cost of Delay when** you're making a single big call (should we delay the launch by a month? should we pause Project A to unblock Project B?) and you want a $-denominated gut check. For backlog ranking, CoD becomes WSJF.

### Decision: pick RICE by default

For a modern SaaS team of 2–20 with a mix of item types and surfaces, **use RICE**. Deviate when:

- You have a hard launch date → layer MoSCoW on top of RICE, within the timebox.
- You're a growth squad on one surface → ICE is enough.
- You're part of a SAFe Agile Release Train → WSJF is already required.
- You're polishing a post-MVP product → use Kano as a mental model alongside RICE.

Do not run RICE and WSJF in parallel. Do not maintain two scoring columns. Pick one, commit, re-score quarterly.

---

## Estimation: what actually works

### Why hour estimates are usually wrong

Hour estimates combine two things that should stay separate: the *size* of the work (a property of the work) and the *duration* to complete it (a property of the person doing it on the day they did it). When you add up hour estimates across a team, you're adding incompatible numbers — one engineer's 4 hours is another's 10.

Hour estimates also invite false precision. "This will take 6 hours" sounds firmer than "this is a 5-point story." It isn't; you just hid the uncertainty.

### Why story points work as relative sizing

Cohn's argument ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §1): story points measure effort *relative to other stories*, not absolute time. A 5-point story is roughly 2.5× a 2-point story; whether it takes 3 days or 8 days depends on who builds it and what else is in the way. Relative sizing is portable across people; absolute duration isn't.

Components that belong in a story point estimate: work, complexity, uncertainty. Do not separate them.

### Why velocity is a forecast tool, not a commitment tool

Velocity is the number of story points a team completes per sprint. It exists *for the team*, to forecast how much to pull into the next sprint. Things to avoid:

- **Cross-team velocity comparisons.** Story points are calibrated within a team. "Team A does 40, Team B does 25, therefore A is more productive" is meaningless — their scales differ.
- **Committing a specific velocity to stakeholders.** This creates pressure to hit the number, which encourages inflation (quietly re-scoring 3s to 5s), which hides the signal velocity was supposed to provide.
- **Tying velocity to bonuses or headcount decisions.** Gaming becomes inevitable.

The 2020 Scrum Guide does not mention velocity at all ([research/02-planning/README.md](../research/02-planning/README.md) §6.3). It's a practitioner convention, not a Scrum artifact. Use it accordingly.

### When #NoEstimates makes sense

For small teams with small, uniform batches. Duarte's argument: if you slice work finely enough (roughly a day of effort per story), you can count stories instead of points, and "you can easily decide which stories to take into a sprint without sizing those stories" ([research/02-planning/estimation.md](../research/02-planning/estimation.md) §4).

Signals that #NoEstimates fits:

- Engineering team of 3–6 or fewer.
- Stories routinely split to < 1 day each.
- High trust with stakeholders who can accept "we ship X–Y stories per sprint, trending Z" instead of a dated plan.

Signals that it doesn't:

- Stakeholders demand dated forecasts (enterprise sales, investor milestones).
- Stories routinely vary from 1 day to 2 weeks — then the story count isn't predictive.
- You're coordinating across multiple teams who need to synchronize.

If you're not sure, start with story points. Graduate to #NoEstimates if pointing becomes a performative ritual that nobody reads.

### The specific estimation ritual

**Planning Poker** for sprint-planning-level estimates:

1. PM reads the story aloud.
2. Team discusses (~2 min): what's unclear? What are the risks?
3. Everyone picks a Fibonacci card privately.
4. All reveal simultaneously.
5. If estimates agree within 1 step, take the mode.
6. If they diverge, highest and lowest estimators explain. Then re-vote.
7. Repeat up to twice. If still diverging, split the story.

**Magic Estimation** for backlog refinement of many items:

1. Print or write each story on a card.
2. Put Fibonacci-labeled zones on a wall.
3. Team silently places each card in a zone.
4. Anyone can silently move cards.
5. When motion stops, discuss only the disagreements.

Both produce the same numbers. Planning Poker handles 5–15 stories an hour; Magic Estimation handles 30–50.

---

## Anti-patterns

- **Feature-based roadmaps with dates.** The format implies certainty you don't have. Bastow: "Fixed dates represent 'an illusion.'" Switch to Now/Next/Later with theme rows.
- **Using OKRs to micro-track tasks.** "KR: ship the onboarding video" is a task, not an outcome. Rewrite as "increase day-1 activation from X% to Y%."
- **Running multiple prioritization frameworks simultaneously.** The framework is supposed to resolve arguments, not create new ones. Pick one.
- **Committing velocity to stakeholders as a promise.** This is the fastest way to make velocity useless. Velocity is a forecast; frame it that way.
- **Planning Later items in too much detail.** The whole point of the Later column is coarse resolution. If Later is as detailed as Now, you're wasting planning time that will be invalidated by what you learn.
- **Skipping "what's out of scope" in MVP definition.** Without an explicit deferred list, scope creep is invisible; every new request feels like a small ask.
- **Confusing OKRs with the backlog.** OKRs are *outcomes you're trying to produce*. The backlog is *things you'll build to try to produce them*. One is a destination; the other is a route. They should reference each other, not replace each other.
- **Writing the strategy in the PM's head only.** Unwritten strategy becomes "whatever the PM said last week," which decays to the "bad strategy" Rumelt warns about.
- **Letting the backlog become a wish-list dump.** Items without owners, estimates, or scores accumulate. Weekly refinement exists to keep the top 10–20 sharp and archive the rest.
- **Skipping retros.** The feedback loop on *how you work* is what makes future sprints better. An hour every two weeks.

---

## Scale notes

**Solo founder / team of 1–2:**
- Skip formal OKRs. Keep a running one-pager that covers strategy + this-month goals.
- Skip sprint ceremonies. Do a 30-minute weekly check-in with yourself: what shipped, what's stuck, what's next.
- You still need the product strategy and MVP scope documents. Write them.
- You still need a prioritized list of work. RICE is overkill; a ranked list of 10–15 items is enough.

**Team of 5 (common early-stage shape):**
- Monthly strategy review; quarterly OKRs.
- Weekly 1-hour backlog refinement.
- 2-week sprints. One Sprint Planning, Review, Retro per sprint.
- Now/Next/Later roadmap refreshed monthly.
- RICE for top-20 backlog items; don't score everything.

**Team of 10–20:**
- Quarterly OKRs (company + team level).
- Biweekly 1-hour backlog refinement per squad.
- 2-week sprints, synced across squads.
- Now/Next/Later roadmap refreshed monthly; strategy review quarterly.
- Consider splitting the backlog by squad once you have 2+ engineering squads.

**Team of 50+:**
- Quarterly OKRs with explicit company → team cascade.
- Monthly roadmap review at the portfolio level.
- Sprint cadence per team; shared cadence where teams integrate.
- Consider SAFe's Planning Interval (8–12 weeks) and WSJF if you're coordinating many teams on a shared queue ([research/02-planning/README.md](../research/02-planning/README.md) §5.2).

---

## Exit checklist

You are done with Phase 02 when all of these are true:

- [ ] A **one-page product strategy** is written, visible, and includes vision, diagnosis, guiding policy, coherent actions, and how-we'll-know metrics.
- [ ] An **MVP scope document** exists with an explicit "not in scope" section and a named riskiest assumption the MVP will test.
- [ ] **OKRs for the current quarter** are set: 1–3 Objectives, 3–5 KRs each, all KRs outcome-based (behavior change, not feature shipped), labeled committed or aspirational, decoupled from compensation.
- [ ] A **Now / Next / Later roadmap** exists, theme-based, with each row linked to an OKR.
- [ ] The **backlog is prioritized** using one framework (RICE by default); the top 10–20 items have scores visible.
- [ ] The top of the backlog has ~1.5–2 sprints' worth of **Ready work** — estimated, acceptance criteria present, agreed by team.
- [ ] A **sprint cadence is chosen** (2-week Scrum by default; Kanban with WIP limits if justified) and documented with ceremony times.
- [ ] A **backlog refinement rhythm** is scheduled weekly with named attendees.
- [ ] A **weekly or biweekly CFR** (team check-in on OKR progress) is scheduled.
- [ ] The whole team can name the current **riskiest assumption** the MVP is testing.
- [ ] The whole team knows **who owns** the strategy, the roadmap, and the backlog.

If you can't check every box, don't move into Phase 03 yet. Missing planning artifacts surface as scope chaos during Build.

---

## Why this works

Each recommendation in this chapter traces to the research corpus. The key citations:

- **Product strategy as a kernel (Rumelt).** The diagnosis-policy-actions structure and the warning that "weak diagnosis" is the most common failure mode come from Richard Rumelt's *Good Strategy Bad Strategy*, summarized in [research/02-planning/README.md](../research/02-planning/README.md) §1.2. The vision/strategy separation and quarterly revisit cadence come from Marty Cagan ([research/02-planning/README.md](../research/02-planning/README.md) §1.1).
- **MVP scope as riskiest-assumption test.** This traces to the discovery frame Phase 01 established and to Torres's "start with outcome, then ask how might we get there" ([research/02-planning/okrs.md](../research/02-planning/okrs.md) §4). The explicit "not in scope" practice is anti-drift hygiene — it's not in a single source, but it's the coherent operationalization of Bastow's critique of feature-factory planning ([research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §1).
- **OKRs with 1 Objective + 3–5 KRs, quarterly, decoupled from pay.** Verified in [research/02-planning/okrs.md](../research/02-planning/okrs.md) §1.1, §2, §5, §6 — the structure and cadence are from John Doerr's companion site What Matters (summarizing *Measure What Matters*) and from Andy Grove's original practice at Intel.
- **Committed vs. aspirational OKR scoring (1.0 vs. 0.7).** [research/02-planning/okrs.md](../research/02-planning/okrs.md) §3, from Google's OKR playbook via What Matters.
- **CFRs as the operational counterpart to OKRs.** [research/02-planning/okrs.md](../research/02-planning/okrs.md) §7.
- **KRs as outcomes, not activities; product outcomes vs. business outcomes.** Teresa Torres, [research/02-planning/okrs.md](../research/02-planning/okrs.md) §4 and [research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §3.
- **Now / Next / Later format.** Janna Bastow, 2012, documented in [research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §1. Theme-based over feature-based from ProdPad and the Spool/Torres quotes in [research/02-planning/roadmaps.md](../research/02-planning/roadmaps.md) §2.
- **RICE as default prioritization framework.** Intercom origin and formula in [research/02-planning/prioritization.md](../research/02-planning/prioritization.md) §1. Comparative framing against MoSCoW, Kano, ICE, WSJF, Cost of Delay in the same document §§2–6.
- **Story points as relative effort; Planning Poker; Fibonacci scale.** Mike Cohn and James Grenning, [research/02-planning/estimation.md](../research/02-planning/estimation.md) §§1–2.
- **Velocity as forecast not commitment; Scrum Guide silence on velocity.** [research/02-planning/estimation.md](../research/02-planning/estimation.md) §5 and [research/02-planning/README.md](../research/02-planning/README.md) §6.
- **#NoEstimates as context-dependent alternative.** Duarte via InfoQ, [research/02-planning/estimation.md](../research/02-planning/estimation.md) §4.
- **Scrum 2-week sprints, Sprint Planning three-topic structure, backlog refinement as ongoing activity.** [research/02-planning/README.md](../research/02-planning/README.md) §§3.1, 3.2, 4.1.
- **Kanban as continuous-flow alternative with WIP limits and four flow metrics.** [research/02-planning/README.md](../research/02-planning/README.md) §4.2.
- **SAFe Planning Interval for large-org quarterly cadence.** [research/02-planning/README.md](../research/02-planning/README.md) §5.2.

Where the industry is contested (outcome vs. feature roadmaps, committed vs. aspirational OKR scoring, estimation vs. NoEstimates), this chapter picks one path and names when to deviate — per the handbook convention set in [README.md](./README.md).
