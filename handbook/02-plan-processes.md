# Phase 02 — Plan: Process Breakdown

Companion to [`02-plan.md`](02-plan.md). The chapter describes *what* and *why*; this document details *how* — the discrete processes, their owners, their inputs and outputs, the cadence, and the exit gates.

**Last updated:** 2026-04-24.

## How to read this

- The 8 steps in the chapter map to 12 processes below. Some chapter steps split (prioritization is separated from sizing because their cadences and participants differ); some are ongoing rituals (backlog refinement, CFR check-in) rather than one-shot deliverables.
- Each process has: **purpose, RACI, triggers, inputs, activities, outputs, tools, cadence, exit gate, pitfalls.**
- RACI convention: **R**esponsible (does the work), **A**ccountable (one person — owns the outcome), **C**onsulted (two-way input), **I**nformed (one-way notification).
- Defaults assume the **team-of-5** scale. Solo-founder and team-of-50+ variations are called out where they change the process meaningfully.

## Process inventory

| # | Process | When | Owner (R) | Primary output |
|---|---|---|---|---|
| 1 | Product Strategy Drafting | Phase start; re-run quarterly | PM | One-page strategy (Rumelt kernel + vision) |
| 2 | MVP Scope Definition | After strategy; re-visit weekly during MVP cycle | PM | MVP scope doc with explicit NOT-in-scope |
| 3 | OKR Setting | Quarterly | PM + exec | 1–3 Objectives × 3–5 KRs, committed/aspirational labeled |
| 4 | Roadmap Construction & Maintenance | Initial build; refreshed monthly | PM | Now/Next/Later roadmap, theme-based, OKR-linked |
| 5 | Backlog Prioritization | Rolling; full re-score quarterly | PM | Top 10–20 items with RICE scores |
| 6 | Story Sizing | Weekly (refinement) + sprint planning | Whole team | Fibonacci-sized backlog items |
| 7 | Iteration Cadence Setup | Once, at phase start | PM + Eng lead | Documented sprint shape + ceremony calendar |
| 8 | Backlog Refinement | Weekly, ~1 hour | PM facilitates | 1.5–2 sprints of Ready work at top |
| 9 | Sprint Planning | Every 2 weeks | PM + whole team | Sprint Goal + Sprint Backlog |
| 10 | Sprint Review & Retrospective | End of every sprint | Whole team | Demoed increment + retro actions |
| 11 | CFR Check-in | Weekly or biweekly | PM | Progress log + corrections against KRs |
| 12 | Phase Exit & Handoff | End of initial planning | PM | Handoff package to Phase 03 |

## Default RACI across the phase

| Role | Scope of accountability |
|---|---|
| **Product (PM/founder-PM)** | Overall phase accountability. Strategy, MVP scope, OKRs, roadmap, backlog order. |
| **Engineering lead** | Sizing realism, iteration cadence, technical-risk callouts that reshape scope. Veto on "can we actually build this in that shape." |
| **Design lead** | UX risk callouts, co-owns MVP scope (what experience is non-negotiable vs. crude). |
| **Stakeholders (exec, early customers, sales)** | Consulted on strategy; informed on roadmap. Do not vote on backlog. |
| **Whole team** | Participates in sizing, planning, review, retro. |

One person **drives the phase** end-to-end (the PM). Planning-by-committee produces mush the same way discovery-by-committee does.

---

## Process 1 — Product Strategy Drafting

**Purpose.** Produce a one-page product strategy that names the challenge, the guiding policy, and the coherent near-term actions — so every downstream planning decision traces to it.

**RACI.** R: PM · A: PM · C: founders/exec, design lead, engineering lead · I: whole team.

**Triggers.** Phase 02 kickoff. Re-run quarterly. Trigger early if Phase 01 produced a pivot that invalidates the prior diagnosis.

**Inputs.**
- Phase 01 handoff package: problem statement, top opportunity, assumption map, evidence log.
- Current company-level vision (5–10 year) if one exists.
- Market context the team has observed (competitive moves, adjacent shifts).
- Team capacity and constraints (budget, headcount, runway).

**Activities.**
1. **Draft the vision (30–60 min, solo PM).** 1–2 sentences on the 5–10 year destination.
2. **Diagnosis (60–90 min).** Name the specific challenge using Phase 01 evidence. Rumelt's warning: weak diagnosis is the most common cause of bad strategy. Cite the evidence.
3. **Guiding policy (30–60 min).** The approach — a signpost, not a feature list. 2–4 sentences.
4. **Coherent actions (30 min).** 3 quarter-scoped actions tied to user/market problems. Not tasks; directions.
5. **How we win + how we'll know (30 min).** Name the defensible edge (1–2 sentences) + north-star metric + 2–3 leading indicators.
6. **Team redline (60–90 min).** Design lead, engineering lead, founders read and challenge the draft. Sharpen. Do not dilute.
7. **Pin it.** Canonical location: team wiki front page. Recite-able by the whole team within a week.

**Outputs.**
- One-page strategy doc (Rumelt kernel + vision + how-we-win + metrics).
- A named review date 1 quarter out.

**Tools / templates.**
- Strategy template (chapter Step 1).
- Team wiki (Notion, Confluence, or a pinned markdown file in the repo).

**Cadence / duration.**
- Initial: 1–2 working days spread over a week. Quarterly review: half-day workshop.

**Exit gate.**
- Whole team can state the diagnosis and the guiding policy from memory a week after publication.
- Every coherent action names a user/market problem, not an internal project.

**Pitfalls.**
- Skipping diagnosis and writing aspirational prose. "Bad strategy" per Rumelt.
- Letting the strategy spill to two pages — hard choices haven't been made yet.
- Strategy lives in the PM's head only. Undocumented strategy decays to whatever-the-PM-said-last-week.
- Writing "how we win" as table-stakes ("great UX"). If a competitor could write the same sentence, it's not a defensible edge.

---

## Process 2 — MVP Scope Definition

**Purpose.** Produce a scope document whose in-scope items are the minimum required to test the single riskiest remaining assumption — with explicit NOT-in-scope and accepted crudeness.

**RACI.** R: PM + Design lead (co-owners) · A: PM · C: Engineering lead (feasibility), founders (viability) · I: whole team.

**Triggers.** Strategy drafted (Process 1). Phase 01 assumption map hands off the ranked risks.

**Inputs.**
- Product strategy (Process 1 output).
- Phase 01 assumption map + top 3 risks tested.
- Target ship date or window (±2 weeks acceptable).
- Team capacity estimate.

**Activities.**
1. **Pick the riskiest assumption (30–60 min).** One sentence. The MVP exists to test this, nothing more.
2. **Define success (30 min).** Concrete, measurable, dated. Behavior change or business signal — not "launch a great product."
3. **Draft thin slice (90 min, with design + eng).** List the minimum capabilities to test the assumption. Slice vertically.
4. **Write NOT-in-scope (60 min).** Name 3–10 things a reasonable person would expect but you are deliberately not building, with one-line reasons.
5. **Name accepted crudeness.** Where you'll tolerate manual ops, ugly UI, hardcoded limits — with a follow-up plan after signal.
6. **Weekly re-read during MVP cycle.** Put the doc on the Sprint Review agenda every sprint. Edit the NOT list as new requests land.

**Outputs.**
- MVP scope doc (template in chapter Step 2).
- Named success criteria with a measurement plan.
- NOT-in-scope list.

**Tools / templates.**
- MVP scope template (chapter Step 2).

**Cadence / duration.**
- Initial draft: 1 day. Team redline: half-day. Weekly 15-min re-read during MVP cycle.

**Exit gate.**
- Riskiest assumption is named and owned.
- Success criteria are measurable and dated.
- NOT-in-scope list has ≥3 items with reasons.

**Pitfalls.**
- Defining MVP as "version one with the fewest features" instead of "smallest thing that tests the riskiest assumption."
- Skipping the NOT list — without it, scope creep is invisible.
- Accepted crudeness used as a permanent excuse. It's a permit for v1, not the shape of v2.

---

## Process 3 — OKR Setting

**Purpose.** Translate strategy into 1–3 Objectives × 3–5 outcome-based Key Results per quarter, labeled committed or aspirational, decoupled from compensation.

**RACI.** R: PM drafts · A: PM (team-level) or exec (company-level) · C: engineering lead, design lead, founders · I: whole team.

**Triggers.** Start of quarter. Trigger early if strategy pivots mid-quarter.

**Inputs.**
- Product strategy (Process 1).
- Current north-star metric and baseline values.
- Prior-quarter OKR scores and lessons (for subsequent quarters).

**Activities.**
1. **Draft Objectives (solo PM, 60 min).** 1–3 qualitative, directional sentences. "What is to be achieved, no more and no less."
2. **Draft KRs (solo PM, 90 min).** 3–5 per Objective. Each KR: `[metric] from [baseline] to [target] by [date]`. Outcomes, not activities.
3. **Label each OKR committed or aspirational.** Committed targets 1.0; aspirational targets 0.7 with high variance.
4. **Team redline (60–90 min).** Challenge: is this a behavior change the team can move? Is the baseline real? Is the target calibrated?
5. **Exec sign-off (30 min).** Company-level OKRs roll up; team OKRs align.
6. **Pin and publicize.** Next to strategy on the team wiki. Reference in every sprint planning and CFR check-in.
7. **Explicitly decouple from compensation.** Written statement that OKR scores do not drive bonuses or performance reviews.

**Outputs.**
- OKR document (1–3 Objs × 3–5 KRs, committed/aspirational labeled).
- Measurement plan per KR (source, owner, cadence).
- Scoring convention (0.7 aspirational target, 1.0 committed target).

**Tools / templates.**
- OKR template (chapter Step 3).
- OKR tracker (spreadsheet, Lattice, Perdoo, or simple wiki page).

**Cadence / duration.**
- Quarterly. Initial set: 1–2 days. Mid-quarter revisits in CFR check-ins (Process 11).

**Exit gate.**
- Every KR is outcome-based (behavior or business change, not feature shipped).
- Every KR has a baseline number, a target number, and a date.
- Every KR has a named data source and owner.
- Committed/aspirational labels are set.

**Pitfalls.**
- KRs written as tasks ("ship onboarding video"). Rewrite as "increase day-1 activation from X% to Y%."
- Tying bonuses to aspirational OKRs → sandbagging (setting easy OKRs to guarantee payout).
- Too many OKRs. More than 3 Objectives per team fragments focus.
- Not revisiting until end of quarter. Without mid-quarter CFRs, aspirational OKRs fail because correction arrives too late.

---

## Process 4 — Roadmap Construction & Maintenance

**Purpose.** Maintain a theme-based Now/Next/Later roadmap that aligns to OKRs and carries no false dates on speculative work.

**RACI.** R: PM · A: PM · C: engineering lead, design lead, exec, customer-facing teams (sales/CS) · I: whole team, stakeholders.

**Triggers.** Initial build after OKRs are set. Monthly refresh thereafter.

**Inputs.**
- Strategy + OKRs (Processes 1, 3).
- Current backlog and in-flight work.
- Customer and exec requests in the queue.
- Team capacity forecast.

**Activities.**
1. **List themes (60 min).** Problems or outcomes, not features. Derived from OKRs and Phase 01 opportunities.
2. **Place initiatives across Now / Next / Later (60 min).** Now = detailed and in-flight; Next = known shape; Later = coarse boulders on the horizon.
3. **For each row, answer three questions:** What? Why? Which OKR does it connect to? If no OKR link, challenge the row.
4. **Strip dates from Next and Later.** Dates belong in the MVP scope doc and in sprint plans.
5. **Share with stakeholders.** Now/Next/Later is the main artifact exec and sales see. Pin it.
6. **Monthly refresh (90 min).** Move items left (Later → Next → Now) as evidence accumulates. Kill rows that lost their evidence.

**Outputs.**
- One-page Now/Next/Later roadmap.
- OKR link per row.
- Monthly change log (what moved, what was killed, why).

**Tools / templates.**
- Roadmap tool (ProdPad, Productboard, or a three-column markdown table).
- Roadmap template (chapter Step 4).

**Cadence / duration.**
- Initial build: half-day. Monthly refresh: 90 min.

**Exit gate.**
- Every row has a theme (not a feature) and an OKR link.
- No hard dates on Next or Later.
- Roadmap fits on one page.

**Pitfalls.**
- Feature rows instead of theme rows. "Add social login" is a candidate solution; the theme is "reduce signup friction."
- Hard dates on Later items. Bastow's "illusion."
- Over-detailing Later — invalidated by what you learn before you build it.
- Treating the roadmap as a commitment artifact instead of a guidance artifact.

---

## Process 5 — Backlog Prioritization

**Purpose.** Maintain a defensible ordering of the top 10–20 backlog items using one consistent framework (RICE by default).

**RACI.** R: PM · A: PM · C: engineering lead, design lead · I: whole team.

**Triggers.** Rolling — re-score any item when underlying inputs change (new customer evidence, revised effort estimate, changed reach). Full re-score quarterly.

**Inputs.**
- Current backlog.
- User evidence (Phase 01 evidence log, support signals, analytics).
- Effort estimates (from Process 6).
- Active OKRs (Process 3) — items that don't tie to an OKR need explicit justification.

**Activities.**
1. **Pick one framework and stick to it.** RICE by default. Deviate only with a written reason (hard deadline → MoSCoW layer; growth-squad single surface → ICE).
2. **Score top 10–20 items on RICE:** Reach × Impact × Confidence / Effort.
   - Reach: people affected over a defined period.
   - Impact: fixed scale (3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal).
   - Confidence: 100% / 80% / 50%. Be honest.
   - Effort: person-months.
3. **Expose score inputs.** Every score is visible and challengeable — not a single opaque number.
4. **Resolve ties with OKR linkage.** Item that moves a committed KR beats item that moves no KR.
5. **Archive the long tail.** Items outside the top 20 stay titled but unpriced; don't spend time scoring what you won't touch this quarter.
6. **Re-score triggers:** new evidence from ongoing discovery, changed effort estimate, changed reach (new segment, contract signed).

**Outputs.**
- Top 10–20 items with RICE scores and visible input numbers.
- Scoring convention doc (one-pager stating which framework, which scales).

**Tools / templates.**
- Issue tracker with custom fields for Reach/Impact/Confidence/Effort (Linear, Jira, GitHub Projects).
- Backup spreadsheet with formulas for score re-computation.

**Cadence / duration.**
- Rolling. Quarterly deep re-score: half-day.

**Exit gate (rolling).**
- Top 10–20 items have current RICE scores.
- No parallel frameworks in use.
- Ties are broken with OKR linkage, not politics.

**Pitfalls.**
- Running RICE and WSJF and MoSCoW in parallel. The framework becomes a blocker.
- Inflating Impact on pet projects. Force spread by benchmarking against a past shipped item.
- Scoring everything. Only the top 10–20 need scores; below that, title + rough size is enough.
- Letting exec pet items override scoring. If the override happens, document the reason.

---

## Process 6 — Story Sizing

**Purpose.** Produce Fibonacci-point estimates that are relative, portable across team members, and an honest reflection of effort + complexity + uncertainty.

**RACI.** R: whole engineering team · A: engineering lead · C: PM (clarifies scope), design (clarifies UX) · I: —.

**Triggers.** Refinement (Process 8) or mid-sprint when new items appear.

**Inputs.**
- Backlog items with titles, brief descriptions, and acceptance criteria.
- Team-calibrated reference stories (past items at 1, 2, 3, 5, 8, 13 points).

**Activities.**
1. **Planning Poker ritual (for 5–15 items/hour):**
   - PM reads the story aloud.
   - Team discusses ~2 min: what's unclear? What are the risks?
   - Everyone picks a Fibonacci card privately (1, 2, 3, 5, 8, 13, 21).
   - All reveal simultaneously.
   - Estimates within 1 step → take the mode.
   - Divergence → highest and lowest explain, re-vote (up to twice).
   - Still diverging → split the story.
2. **Magic Estimation (for 30–50 items/hour refinement):**
   - Write each story on a card.
   - Team silently places cards in Fibonacci-labeled zones on a wall.
   - Silent re-sorting allowed.
   - Discuss only disagreements when motion stops.
3. **Split anything >13 (or >L).** Too big to start.
4. **Do not separate dev time from test time.** Points are unified effort.
5. **Do not convert to hours.** Velocity will emerge from points-completed-per-sprint.

**Outputs.**
- Every Ready item has a Fibonacci point estimate.
- Team velocity trend (points completed per sprint, last 3 sprints).

**Tools / templates.**
- Planning Poker tool (Pointing Poker, Scrum Poker Online, or physical cards).
- Whiteboard or Miro/FigJam for Magic Estimation.

**Cadence / duration.**
- Weekly in refinement (Process 8). Any Planning Poker specifically during refinement + sprint planning.

**Exit gate (rolling).**
- Every item at the top of the backlog (~1.5–2 sprints) has a point estimate.
- No items >13 points at top of backlog.

**Pitfalls.**
- Anchoring — one person announcing an estimate first. Planning Poker exists precisely to prevent this.
- Converting points to hours for stakeholder reporting. Velocity turns from a forecast tool into a commitment tool overnight.
- Cross-team velocity comparisons. Points are calibrated within a team; the scales differ.
- Pointing items nobody will build this quarter. Wasted ceremony.
- Treating velocity as a KPI tied to compensation. Gaming becomes inevitable.

---

## Process 7 — Iteration Cadence Setup

**Purpose.** Pick and document a cadence (2-week Scrum by default; Kanban with WIP limits if justified) so the team stops arguing about meta and starts shipping.

**RACI.** R: PM + engineering lead (co-decide) · A: PM · C: design, whole team · I: stakeholders.

**Triggers.** Once, at phase start. Revisit only if retros repeatedly surface cadence problems.

**Inputs.**
- Team size and shape.
- Work-arrival pattern (steady product work vs. incident-driven support).
- Stakeholder reporting expectations.

**Activities.**
1. **Pick the default unless there's a reason not to.** 2-week Scrum sprints fit most 2–20 person product teams.
2. **Choose Kanban when:**
   - Work arrives at unpredictable rates (support-heavy, incident-driven).
   - Items are roughly uniform in size.
   - Team is 2–4 and planning overhead > sprint benefit.
3. **Document the shape in the team wiki.** Specific times, recurring calendar invites:
   - Sprint Planning — Mon 10am, 2 hours.
   - Daily standup — Daily 9:30am, 15 min.
   - Backlog refinement — Wed 2pm, 1 hour.
   - Sprint Review — alternate Fri 2pm, 1 hour.
   - Retro — alternate Fri 3pm, 1 hour.
4. **If Kanban:** set explicit WIP limits per stage. Add the four flow metrics to the team dashboard: WIP, Throughput, Work Item Age, Cycle Time.
5. **Commit.** Don't oscillate between Scrum and Kanban. Deviate consciously after 2 quarters if retros demand it.

**Outputs.**
- Documented cadence decision in team wiki.
- Recurring calendar invites for all ceremonies.
- (If Kanban) WIP limits published on board.

**Tools / templates.**
- Calendar.
- Issue tracker configured for the chosen cadence (sprints on or off).
- Team wiki page with ceremony times.

**Cadence / duration.**
- One decision session, 60–90 min.

**Exit gate.**
- Cadence is documented and on the calendar.
- Team can name the next Planning, Review, and Retro dates from memory.

**Pitfalls.**
- Oscillating Scrum ↔ Kanban every few sprints. Loses the benefits of either.
- Running "Kanban" without WIP limits. It's a to-do list, not Kanban.
- 1-week sprints — ceremony overhead too high.
- 4-week sprints — feedback loop too slow.
- Starting with Scrumban. Learn one cadence first; combine consciously.

---

## Process 8 — Backlog Refinement

**Purpose.** Maintain 1.5–2 sprints of Ready work at the top of the backlog — estimated, understood, acceptance-criteria'd — so sprint planning is fast and predictable.

**RACI.** R: PM facilitates · A: PM · C: engineering lead (always in), design lead (always in), rotating engineers/designers · I: whole team.

**Triggers.** Weekly, mid-sprint.

**Inputs.**
- Candidate items from the top of the backlog.
- Open questions on items surfaced since last refinement.
- Recent customer evidence that might reshape items.

**Activities.**
1. **PM prepares 5–10 candidates beforehand.** Brief description, first-pass acceptance criteria, list of open questions.
2. **Walk each item in the meeting:**
   - Does it make sense? What's unclear?
   - What are the risks (technical, UX, scope)?
   - Is it small enough to start? (>13 points → split.)
3. **Size items that are clear enough.** Planning Poker.
4. **Split items that are too big.** Slice vertically. Don't defer — the team won't know more next week.
5. **Re-order.** PM updates backlog sequence based on the refined understanding.
6. **Definition of Ready check.** Item leaves refinement as Ready only when: description + acceptance criteria + estimate + no open blockers.

**Outputs.**
- Top 1.5–2 sprints of items Ready.
- Updated sizes on refined items.
- Open questions logged for research or PM follow-up.

**Tools / templates.**
- Issue tracker with Ready state/label.
- Definition of Ready checklist (pinned in team wiki).

**Cadence / duration.**
- Weekly, 1 hour. Mid-sprint is ideal (gives time between refinement and the next planning).

**Exit gate (rolling).**
- Top 1.5–2 sprints' worth of items Ready before Sprint Planning.
- No items >13 points in the Ready queue.

**Pitfalls.**
- Whole team refining every item. Waste. PM + eng lead + design lead + 1–2 rotating engineers is enough.
- Refinement becomes status reporting. If that happens, cancel it and restart with a strict agenda.
- Skipping refinement "because sprint planning handles it." Then sprint planning becomes a 4-hour marathon and items get committed that were never properly understood.
- Over-refining items that won't be built this month. Work on the top 1.5–2 sprints, not the whole backlog.

---

## Process 9 — Sprint Planning

**Purpose.** Commit to a Sprint Goal and a Sprint Backlog the team believes it can complete.

**RACI.** R: PM + engineering lead co-facilitate · A: PM (scope) + engineering lead (capacity) · C: design, whole team · I: stakeholders (via Review).

**Triggers.** First day of each sprint.

**Inputs.**
- Ready items at the top of the backlog (from Process 8).
- Team capacity for the sprint (holidays, on-call, other commitments).
- Velocity trend from last 3 sprints.
- Active OKRs and in-flight MVP scope.

**Activities.**
1. **Answer three questions, in order (Scrum Guide structure):**
   - **Why is this sprint valuable?** → Draft Sprint Goal (one sentence).
   - **What can be done this sprint?** → Pull items from the top of the Ready queue whose total points fit velocity ± capacity adjustment.
   - **How will the chosen work get done?** → Team talks through approach for each item; surfaces missed dependencies.
2. **Sprint Goal as anchor.** Each pulled item should support the goal; items that don't are either killed or deferred.
3. **Forecast, don't commit to a number.** Velocity is a range (last 3 sprints). Pulling to the top of the range risks overcommitting.
4. **Leave buffer for interrupts.** For a support-heavy team, reserve 20–30% capacity unallocated.
5. **Write Sprint Goal visibly** in the team's Sprint board header.

**Outputs.**
- Sprint Goal (one sentence).
- Sprint Backlog (items pulled, total points, who-ish is picking up what).
- Team calendar constraints noted (who's out, when).

**Tools / templates.**
- Issue tracker sprint view.
- Velocity chart (last 3–6 sprints).

**Cadence / duration.**
- Every 2 weeks. 2–4 hours for a 2-week sprint.

**Exit gate.**
- Sprint Goal is written and posted.
- Sprint Backlog fits within the velocity range ± capacity adjustment.
- Every committed item is Ready.

**Pitfalls.**
- Planning without a Sprint Goal. The backlog becomes a shopping list.
- Stuffing the sprint to the top of the velocity range every time. Sets up failure on the first interrupt.
- Committing items that weren't refined. They blow up mid-sprint.
- Planning ending with "we'll see how far we get." That's not a commitment; it's avoidance.

---

## Process 10 — Sprint Review & Retrospective

**Purpose.** Show the increment to stakeholders (Review) and improve how the team works (Retro).

**RACI.** R: whole team · A: PM (Review) + engineering lead (Retro) · C: stakeholders (Review), design lead · I: exec via summary.

**Triggers.** Last day of each sprint.

**Inputs.**
- Completed increment.
- Metrics and signals from shipped work (if any).
- Sprint Goal (did we meet it?).
- Open items carried over.

**Activities.**

**Sprint Review (1–2 hours):**
1. PM frames: Sprint Goal + what we committed.
2. Engineers/designers demo completed items live.
3. Stakeholders ask questions, react, flag misalignments.
4. PM captures feedback and updates the backlog in-meeting or within 24h.
5. Unfinished items: explicitly carried over or killed. No silent carry.

**Retrospective (1 hour, team only, no stakeholders):**
1. Data (10 min): what happened? (Velocity, carry-over, interrupts, blocks.)
2. Generate (20 min): What to start? What to stop? What to continue? (Or any retro frame — "Mad/Sad/Glad," 4Ls, etc.)
3. Decide (20 min): pick 1–2 actions. Each with a name, a due date, a check at next retro.
4. Close (10 min): restate actions, ROTI (return on time invested) pulse if the team wants it.

**Outputs.**
- Review: stakeholder feedback logged + backlog updates.
- Retro: 1–2 action items with owners + due dates.
- Sprint Goal hit/miss recorded.

**Tools / templates.**
- Demo environment or recording.
- Retro tool (Metro Retro, EasyRetro, FigJam) or a whiteboard.

**Cadence / duration.**
- Every 2 weeks. Review 1–2 hr. Retro 1 hr.

**Exit gate.**
- Each sprint: review happened, retro happened, ≥1 retro action tracked for next sprint.

**Pitfalls.**
- Canceling retro when "things are fine." The loop on how-you-work is what makes future sprints better.
- Retro actions accumulated without follow-through. Prior-retro actions are the first agenda item of the next retro.
- Review turning into a demo theater instead of a conversation. Invite questions early.
- Blameful retros. Kerth's Prime Directive: assume everyone did the best they could with what they had.

---

## Process 11 — CFR Check-in

**Purpose.** Conversations, Feedback, Recognition — a weekly or biweekly ritual where the team reviews OKR progress and course-corrects between quarterly cycles.

**RACI.** R: PM · A: PM · C: whole team, exec · I: —.

**Triggers.** Weekly or biweekly.

**Inputs.**
- Current OKRs with baseline + target per KR.
- Latest metric readings per KR.
- In-flight work and blockers.

**Activities.**
1. **Refresh KR numbers (PM, 30 min before meeting).** Pull current readings.
2. **Walk each KR (15 min in meeting):** baseline → current → target. Trend. Confidence delta since last check-in.
3. **Conversation:** what's working, what's stuck, what's the next 1–2 experiments?
4. **Feedback:** peer-to-peer acknowledgement of blockers, wins, missed context.
5. **Recognition:** name specific behaviors that moved a KR.
6. **Log the check-in.** Short written note (3–5 bullets) pinned in team wiki.

**Outputs.**
- Weekly/biweekly KR progress log.
- Corrections triggered (re-score items, re-plan sprint, escalate).

**Tools / templates.**
- OKR tracker.
- Team wiki page for CFR log.

**Cadence / duration.**
- Weekly or biweekly. 30 min.

**Exit gate (rolling).**
- Every active KR has a reading in the last check-in.
- Course corrections happen within the quarter, not at its end.

**Pitfalls.**
- CFR turning into status reporting. If there's no conversation, the C is missing.
- Missing the cycle for weeks. Aspirational OKRs fail because correction arrives too late.
- Tying recognition to compensation. Recognition works only when it's not bonus-coupled.
- Reporting only green. If nothing is red, the targets weren't ambitious.

---

## Process 12 — Phase Exit & Handoff to Phase 03

**Purpose.** Verify planning artifacts are complete and handed off so Phase 03 (Design) can start without backfilling.

**RACI.** R: PM · A: PM · C: design lead, engineering lead, exec · I: whole team.

**Triggers.** Initial planning cycle complete; all exit-checklist items have yes or an acknowledged gap.

**Inputs.**
- All six Phase 02 artifacts (strategy, MVP scope, OKRs, roadmap, backlog, cadence decision).
- Open planning risks and unresolved questions.

**Activities.**
1. **Pre-read (async, 48h before):** design lead, engineering lead, founders read the artifact set.
2. **Meeting (60–90 min):**
   - PM walks through artifacts (20 min).
   - Team raises concerns per role (20 min).
   - Resolve or explicitly accept gaps (20 min).
   - Decision (10 min): proceed to Phase 03 / not yet.
3. **Write the decision record** (ADR-style): context, decision, open risks carried.
4. **Hand the Phase 03 team the package.**

**Outputs.**
- Signed decision record.
- Handoff package:
  1. Product strategy (Process 1).
  2. MVP scope doc with riskiest assumption (Process 2).
  3. OKRs (Process 3).
  4. Now/Next/Later roadmap (Process 4).
  5. Top 10–20 prioritized backlog (Process 5).
  6. Cadence decision + calendar (Process 7).
  7. CFR check-in cadence on the calendar (Process 11).

**Tools / templates.**
- Decision-record template (ADR-style; same as Phase 01 exit).

**Cadence / duration.**
- One meeting + 1–2 days for write-up.

**Exit gate (phase).**
- Every chapter-exit-checklist item is yes or has a named owner + date to close the gap.
- Design lead and engineering lead both signed off on proceeding.

**Pitfalls.**
- Proceeding with an OKR set that's all activity-based. Design will build feature-shaped scope; outcomes will be missed.
- Handing off a roadmap with hard dates on Next/Later. Design will anchor on dates that aren't real.
- Handing off a strategy that exists only in the PM's head. Design will architect against the wrong diagnosis.

---

## Weekly rhythm (how these processes stack)

A typical 2-week sprint for a team-of-5:

| Day | Activities | Owner |
|---|---|---|
| Mon W1 | **Sprint Planning** (2hr); daily standup starts | Whole team |
| Tue W1 | Standup; work; CFR check-in (30 min) | PM + team |
| Wed W1 | Standup; **Backlog Refinement** (1hr); work | PM facilitates |
| Thu W1 | Standup; work; MVP scope weekly re-read (15 min) | PM |
| Fri W1 | Standup; work; async update to stakeholders | PM |
| Mon W2 | Standup; work | Team |
| Tue W2 | Standup; work; prioritization updates as evidence lands | PM |
| Wed W2 | Standup; **Backlog Refinement** (1hr); work | PM facilitates |
| Thu W2 | Standup; work; Sprint Review prep | Team |
| Fri W2 | Standup; **Sprint Review** (1hr); **Retrospective** (1hr) | Whole team |

Monthly: roadmap refresh (90 min). Quarterly: strategy review (half-day), OKR setting (1–2 days), full backlog re-score (half-day).

---

## Scale notes

- **Solo founder.** Skip formal OKRs; keep a running one-pager of strategy + this-month goals. Skip Planning Poker; rank by feel and write the rationale. Run a weekly 30-min self-review covering Processes 4, 5, 10, 11 collapsed into one. Keep Processes 1, 2, 9, 12 intact.
- **Team of 5.** This document's default.
- **Team of 10–20.** Processes 1, 3 run at company + team level (cascading). Processes 2, 4, 5, 6, 8, 9, 10 run per squad. Process 11 runs per squad + monthly cross-squad. Consider splitting backlog when there are 2+ engineering squads.
- **Team of 50+.** Add SAFe Planning Interval (8–12 weeks) on top of quarterly OKRs if coordinating many teams on a shared queue. Use WSJF for cross-squad sequencing; RICE stays in-squad. Central roadmap rollup reviewed monthly by exec; team roadmaps reviewed in-squad monthly.

---

## Handoff to Phase 03

On proceed from Process 12, Phase 03 (Design) should receive:

1. Product strategy (Process 1).
2. MVP scope doc + named riskiest assumption (Process 2).
3. Current-quarter OKRs with KRs Phase 03 design choices must move (Process 3).
4. Now/Next/Later roadmap with OKR links (Process 4).
5. Prioritized top-10–20 backlog with RICE inputs (Process 5).
6. Velocity trend + cadence calendar (Processes 6, 7).
7. Definition of Ready (Process 8).
8. CFR cadence on the calendar (Process 11).

Phase 03 should not accept a handoff missing items 1, 2, 3, or 8.
