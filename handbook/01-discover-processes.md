# Phase 01 — Discover: Process Breakdown

Companion to [`01-discover.md`](01-discover.md). The chapter describes *what* and *why*; this document details *how* — the discrete processes, their owners, their inputs and outputs, the cadence, and the exit gates.

**Last updated:** 2026-04-24.

## How to read this

- The 6 steps in the chapter map to 11 processes below. Some chapter steps split into multiple processes (recruiting is separated from interviewing because their mechanics, owners, and cadences differ); some processes are supporting rather than sequential (evidence-log maintenance is continuous).
- Each process has: **purpose, RACI, triggers, inputs, activities, outputs, tools, cadence, exit gate, pitfalls.**
- The RACI convention: **R**esponsible (does the work), **A**ccountable (one person — owns the outcome), **C**onsulted (two-way input), **I**nformed (one-way notification).
- Defaults assume the **team-of-5** scale the chapter is written for. Solo-founder and team-of-50+ variations are called out where they change the process meaningfully.

## Process inventory

| # | Process | When | Owner (R) | Primary output |
|---|---|---|---|---|
| 1 | Segment Definition | Phase start | PM | One-sentence segment definition |
| 2 | Participant Recruiting | Starts day 1; runs continuously | PM | Scheduled interview calendar |
| 3 | Interview Execution | Weekly, 3–5/week | PM + note-taker | Recorded + transcribed interviews |
| 4 | Post-Interview Debrief | Within 24h of each interview | PM | Updated evidence log entries |
| 5 | Synthesis Workshop | Every 3–5 interviews | PM facilitates | Updated OST / JTBD canvas |
| 6 | Evidence Log & OST Maintenance | Continuous | PM | Living artifacts |
| 7 | Assumption Mapping | After first synthesis (~interview 5–7) | PM + Design + Eng | Ranked assumption map |
| 8 | Assumption Testing | Rolling, once assumptions ranked | Depends on risk domain | Test results tied to assumptions |
| 9 | Problem Statement Drafting & Validation | After ~10 interviews | PM | Validated problem statement |
| 10 | Opportunity Prioritization | Same window as Process 9 | PM | Ranked opportunity list with top-1 focus |
| 11 | Phase Exit Decision | End of phase | PM (final call) | Written decision (proceed/pivot/kill) |

## Default RACI across the phase

| Role | Scope of accountability |
|---|---|
| **Product (PM/founder-PM)** | Overall phase accountability. Value and business-viability risks. |
| **Design** | Usability risk. Co-leads interviews. Owns persona/journey-map/OST visualization. |
| **Engineering (lead or senior)** | Feasibility risk. Attends at least half the interviews. Owns feasibility spikes. |
| **Founders / Exec** | Consulted on strategic fit and business viability. Informed on phase progress. |
| **Customers** | The source of truth. Interviewed, quoted, validated against. |

One person **drives the phase** end-to-end (typically the PM). Discovery-by-committee produces mush.

---

## Process 1 — Segment Definition

**Purpose.** Name the specific group of people being built for, narrow enough that a stranger could identify belonging from the description alone.

**RACI.** R: PM · A: PM · C: founders, design, any sales/CS if present · I: team.

**Triggers.** Phase 01 kickoff. Also re-run whenever interview findings suggest the segment was wrong (pivot).

**Inputs.**
- Rough idea or hypothesis from Phase 0 ("we think X struggles with Y").
- Any existing market or customer data the team has (prior user lists, waitlist signups, past research).
- Access constraints — who can the team actually reach?

**Activities.**
1. Brainstorm candidate segments (10–15 minutes, whole team).
2. Apply the segment-definition template: `[role/title] at [org/life context] who [current primary activity] and who [qualifying constraint]`.
3. Pressure-test: can a stranger identify someone in this segment? If not, narrow further.
4. Write the definition in one sentence and post it visibly (team channel pinned message, first line of the research doc).
5. List 3–5 disqualifying criteria to speed recruiting screeners.

**Outputs.**
- One-sentence segment definition (canonical location: top of the research doc; pinned in team channel).
- Disqualifying-criteria list (feeds screener in Process 2).

**Tools / templates.**
- Segment-definition template (chapter Step 1).
- Whiteboard or Miro/FigJam for the brainstorm.

**Cadence / duration.**
- One session, 30–90 minutes. Re-visit only on pivot.

**Exit gate.**
- Three people from outside the core team can read the definition and correctly identify two people in their network who belong.

**Pitfalls.**
- Defining the segment as "everyone who uses spreadsheets" — not a segment.
- Broadening the segment to feel market-sized; the chapter is explicit that a sharp niche beats a broad vague market.

---

## Process 2 — Participant Recruiting

**Purpose.** Maintain a continuously refilled pipeline of scheduled interviews with people who match the segment definition.

**RACI.** R: PM (or research/ops if staffed) · A: PM · C: marketing/sales for warm intros, existing customers for referrals · I: team.

**Triggers.** Day 1 of the phase. Then continuously — recruiting must lead interviewing by 1–2 weeks.

**Inputs.**
- Segment definition and disqualifiers (Process 1).
- Incentive budget ($50–$150/consumer; $150–$500/B2B specialist).
- Outreach channels: existing waitlist, LinkedIn, Slack/Discord communities, niche forums, paid panels (UserInterviews.com, Respondent.io), partner referrals.
- A simple screener (5–8 questions) to confirm segment fit before booking.

**Activities.**
1. Draft outreach messages per channel (short, specific, mentions incentive if any).
2. Maintain a recruiting tracker (name, source, screener response, scheduled time, status).
3. Aim to schedule 2x the interview count (attrition is real: 30–40% no-show/reschedule is typical).
4. Send calendar invites with recording consent and a privacy note.
5. Day-before reminder + day-of reminder reduces no-shows by ~15–20 percentage points (SYNTHESIS — common practice; exact figure depends on segment).

**Outputs.**
- Recruiting tracker kept current.
- Calendar of confirmed interviews (3–5/week minimum).
- Consent records (recording + participant compensation).

**Tools / templates.**
- Recruiting tracker (spreadsheet or Notion table).
- Screener survey (Typeform, Tally, or embedded form).
- Calendly / Google Calendar for scheduling.
- Payment tooling (Tremendous, Rybbon, or manual Amazon gift cards).

**Cadence / duration.**
- Continuous. Budget ~20–40% of the PM's phase time on recruiting in weeks 1–2, dropping to ~10–15% once the pipeline is warm.

**Exit gate (rolling).**
- Interview slots booked 1 week ahead at all times.
- Show-rate >60% for the last 5 scheduled sessions. If lower, incentive/channel changes needed.

**Pitfalls.**
- Recruiting only from existing happy customers (biased: you hear what they already like).
- Not paying an incentive → response rate craters and selection skews to the under-employed.
- Starting recruiting the week you want to interview — recruiting lead time is always longer than you expect.

---

## Process 3 — Interview Execution

**Purpose.** Collect 10–15 story-based interviews that surface real customer experiences, not opinions.

**RACI.** R: PM (interviewer) + one note-taker (rotates: design, engineering, PM) · A: PM · I: team receives weekly summary.

**Triggers.** A scheduled interview slot from Process 2.

**Inputs.**
- Interview guide (piloted once or twice before real use).
- Notes template (shared doc or tool).
- Recording consent and recording tool running.
- Segment definition (to frame screening prompts).

**Activities.**
1. **Pre-interview (5 min before):** re-read participant's screener responses, confirm recording and note-taking setup.
2. **Opening (3–5 min):** confirm consent on-record, explain purpose, build rapport with easy questions.
3. **Main (20–30 min):** semi-structured interview anchored on stories. Use "tell me about the last time you [did X]." Probe with "tell me more about that" and "what happened next?" Avoid hypothetical or leading questions.
4. **Closing (3–5 min):** ask "is there anything I should have asked that I didn't?" and "is there someone else you'd recommend I talk to?"
5. **Immediate (within 10 min of end):** note-taker flags top 3 quotes and emergent themes while memory is fresh.

**Outputs.**
- Recording (consented, stored in research repo).
- Transcript (automated via Otter.ai, Rev, or similar; edited for clarity).
- Structured notes (who, when, context, stories told verbatim, emergent pains/desires, open questions).
- Referral names (if offered).

**Tools / templates.**
- Interview guide (chapter Step 2).
- Notes template with required sections.
- Recording tool (Zoom, Google Meet, Riverside, Loom).
- Transcription (Otter.ai, Descript, Rev).
- Research repo (Dovetail, Aurelius, Notion — even a /research folder works).

**Cadence / duration.**
- 3–5 interviews per week for 2–4 weeks in new-product discovery.
- 30–45 minutes each + 15 min buffer.

**Exit gate (per interview).**
- Transcript and structured notes published within 24h.
- At least 2 verbatim quotes tagged into the evidence log (Process 6).

**Pitfalls.**
- Leading questions ("would you use a feature that…"). Discovery poison.
- Pitching the product mid-interview. You are researching, not selling.
- Solo interviewing with no note-taker: the interviewer cannot simultaneously listen and record faithfully.
- Batching interviews into one overloaded day — quality drops after the third interview in a row.

---

## Process 4 — Post-Interview Debrief

**Purpose.** Capture freshest observations and update the evidence log before memory decays.

**RACI.** R: PM + note-taker · A: PM · I: synthesis-workshop attendees.

**Triggers.** Completion of each interview.

**Inputs.**
- Raw notes and (ideally) transcript.
- Running evidence log.
- Running OST / JTBD canvas (even if still thin).

**Activities.**
1. 15–20 minute sync between interviewer and note-taker within 24h.
2. Identify 3–8 noteworthy quotes (verbatim) and tag them against existing opportunity themes or create new ones.
3. Add rows to the evidence log with: quote, speaker pseudonym + role, date, theme, source link.
4. Note emergent surprises or contradictions against prior interviews.
5. Flag any recruiting-quality issues (participant was off-segment; screener needs tightening).

**Outputs.**
- Updated evidence log.
- Flagged surprises list (feeds next synthesis workshop).

**Tools / templates.**
- Evidence log (spreadsheet with required columns: quote, speaker, date, theme, source link).

**Cadence / duration.**
- Every interview. 15–20 minutes.

**Exit gate.**
- At least 2 log entries per interview. Fewer → either interview was weak or debrief was lazy; both are addressable.

**Pitfalls.**
- Skipping the debrief "to save time." By the third interview without it, you've forgotten the specifics from the first two and the log suffers.
- Paraphrasing instead of quoting verbatim. Paraphrases drift toward what the team wants to hear.

---

## Process 5 — Synthesis Workshop

**Purpose.** Turn interview notes into structure — themes, opportunities, and a candidate solution tree.

**RACI.** R: PM facilitates · A: PM · C: design (co-leads visualization), engineering (attends half at minimum) · I: exec via summary.

**Triggers.** Every 3–5 interviews completed (roughly weekly during heavy interview periods).

**Inputs.**
- Evidence log (all entries since last workshop).
- Prior OST / JTBD canvas.
- Current assumption map (from Process 7).

**Activities.**
1. **Read-in (15 min):** attendees review recent evidence log entries individually.
2. **Clustering (30–45 min):** quotes on sticky notes (Miro/FigJam if remote). Cluster by theme in customer's voice — not the team's.
3. **Opportunity naming (15 min):** name each cluster as an opportunity, phrased as a customer pain or unmet need ("I can never find last month's template fast enough" — not "search feature").
4. **Tree update (15–30 min):** place each opportunity on the OST under the target outcome. Attach candidate solutions below opportunities.
5. **Divergence log (5 min):** note where interviews contradict each other or prior assumptions — these are the highest-value follow-ups.

**Outputs.**
- Updated Opportunity Solution Tree (or JTBD canvas).
- List of opportunities with ≥2 evidence pointers each.
- Updated candidate-solution list tied to opportunities.
- List of contradictions to probe in upcoming interviews.

**Tools / templates.**
- Miro/FigJam (remote) or physical stickies (co-located).
- OST template (chapter Step 3).

**Cadence / duration.**
- Every 3–5 interviews. 2–3 hours.

**Exit gate.**
- OST is current as of the latest interview.
- Every top-tier opportunity has ≥2 evidence pointers.

**Pitfalls.**
- Naming opportunities in the team's voice ("we should add…") instead of the customer's voice.
- Jumping from quote to solution, skipping the opportunity layer. The OST's value is the opportunity→solution separation; collapsing it is skipping the reasoning.
- Letting the workshop turn into a pitch for pre-existing feature ideas. Put the evidence in front of people; the shape follows.

---

## Process 6 — Evidence Log & OST Maintenance

**Purpose.** Keep the two load-bearing artifacts (evidence log, OST) current and trustworthy between workshops.

**RACI.** R: PM · A: PM · C: design for visual updates to OST · I: team.

**Triggers.** Continuous; touched on every debrief and workshop.

**Inputs.**
- New evidence from every interview.
- Any external signal (support tickets, sales notes, analytics — if relevant to segment).

**Activities.**
1. After every debrief (Process 4), add log entries.
2. Weekly, spot-check: does every claim in the current problem-statement draft still have ≥2 supporting log entries?
3. Archive superseded OST versions (monthly) with a one-line note on what changed.
4. Prune stale or off-segment entries with a strikethrough + reason (do not delete — the record matters).

**Outputs.**
- Always-current evidence log.
- Always-current OST.
- Version history showing how the tree evolved.

**Tools / templates.**
- Same as Processes 4 and 5.
- A simple changelog at the top of the OST doc noting what changed each week.

**Cadence / duration.**
- Continuous. ~30 min/week overhead when the rhythm is established.

**Exit gate (rolling).**
- Every log entry has a source link. Every OST opportunity has ≥2 evidence pointers. The evidence log supports every claim made anywhere downstream.

**Pitfalls.**
- The log becomes write-only — entries go in, nobody reads them. Mitigation: start synthesis workshops with a 15-min read-in of new entries.
- Silent deletions. Stale entries should be struck through with a reason, not removed; future-you will want to understand the pivot.

---

## Process 7 — Assumption Mapping

**Purpose.** Identify the top 5–10 assumptions the current candidate solutions rely on, ranked by criticality and current evidence.

**RACI.** R: PM + Design + Engineering together (each owns their risk domain) · A: PM · C: founders for viability reality-check · I: team.

**Triggers.** After the first real synthesis workshop (roughly interviews 5–7). Re-run every 2 weeks, or after a major new learning.

**Inputs.**
- Current OST with candidate solutions.
- Cagan's four-risk framing (value, usability, feasibility, business viability) and Torres's ethics check.
- Current evidence log.

**Activities.**
1. **List assumptions (30 min):** for each candidate solution in the OST, write every assumption it relies on — one sticky per assumption. Split by risk domain.
2. **Criticality score (15 min):** on a 1–3 scale, how bad is it if this assumption is wrong? 3 = kills the product; 1 = inconvenience.
3. **Evidence score (15 min):** on a 1–3 scale, how much evidence do we currently have? 3 = multiple direct observations; 1 = we think so.
4. **Plot (10 min):** 2x2 of criticality (y) vs. evidence (x). Top-left quadrant (high criticality, low evidence) is what you test next.
5. **Pick top 3 to test.** Assign an owner and a test type for each.

**Outputs.**
- Ranked assumption map (2x2 or ordered list).
- Top 3 assumptions with an owner and planned test per assumption.
- Feeds Process 8 (Assumption Testing).

**Tools / templates.**
- Miro/FigJam 2x2.
- Risk-register spreadsheet alternative: criticality, evidence, owner, planned test, due date, result.

**Cadence / duration.**
- Initial: 60–90 minutes. Re-run every 2 weeks or on major learning.

**Exit gate.**
- Top 3 risks have named owners and a test scheduled within 1 week.

**Pitfalls.**
- Conflating value with business viability (Cagan's explicit reason for splitting them). Force the split.
- Treating the map as a document instead of a tool. The map is only useful if it drives the next test.
- Skipping the ethics check when the product touches sensitive data or vulnerable users.

---

## Process 8 — Assumption Testing

**Purpose.** Produce evidence (confirming or disconfirming) for the ranked assumptions, starting with the riskiest.

**RACI.** Varies by risk domain:

| Risk | R | A | C |
|---|---|---|---|
| Value | PM | PM | Design |
| Usability | Design | PM | Engineering |
| Feasibility | Engineering lead | PM | Engineering team |
| Business viability | PM + founders | PM | Finance/legal if relevant |
| Ethics | PM | PM | Legal, impacted-user representative |

**Triggers.** A ranked assumption from Process 7.

**Inputs.**
- Specific assumption to test.
- Cheapest test that produces real evidence (chapter Step 4 table).
- Budget and time box for the test.

**Activities (per test).**
1. **Define success criteria** *before* running the test. "What result would change our mind?"
2. **Design the test** using the cheapest credible method:
   - Value → story-based interview probe, landing page + signup, Wizard-of-Oz, pre-sales conversation.
   - Usability → paper or clickable prototype, qualitative usability test with 5 users, iterate.
   - Feasibility → engineer spike, PoC for riskiest integration, vendor/API evaluation.
   - Business viability → pricing sanity-check, channel math, legal/compliance review.
3. **Run the test** in a defined time box (typically ≤1 week for early tests).
4. **Write up the result** against pre-defined success criteria — confirmed / disconfirmed / inconclusive + what it changes.
5. **Update the assumption map and OST** to reflect the new evidence.

**Outputs.**
- Test write-up (purpose, method, pre-defined success criteria, result, implication).
- Updated assumption map.
- Updated OST branches (solutions may be killed, promoted, or forked based on result).

**Tools / templates.**
- Usability: Maze, UserTesting, in-person moderated sessions.
- Value: landing-page builders (Carrd, Webflow), fake-door tests, pre-sales calls.
- Feasibility: time-boxed spike in a branch; proof-of-concept repo.
- Viability: pricing models (Google Sheets), channel math, compliance checklists.

**Cadence / duration.**
- Rolling. Each test 3 days to 2 weeks depending on type. Parallelize tests owned by different people.

**Exit gate (per test).**
- Result documented with evidence strong enough to act on. Inconclusive is a valid result — state that and plan the stronger next test.

**Pitfalls.**
- Defining success criteria after seeing the result (motivated reasoning).
- Running usability before value. Polishing a prototype nobody wants is expensive.
- Never killing an assumption because the team is "almost done" testing it. Infinite tests burn the phase.

---

## Process 9 — Problem Statement Drafting & Validation

**Purpose.** Produce a single-sentence problem statement that captures what was learned and is corroborated by customers directly.

**RACI.** R: PM · A: PM · C: design, engineering, **3 customers** (for validation) · I: team.

**Triggers.** ~10 interviews completed, synthesis workshops up to date, top-3 assumptions have at least one test result each.

**Inputs.**
- Evidence log (filtered for strongest quotes).
- Current OST.
- Assumption test results.
- Problem statement template: `[Segment] needs a way to [job / progress], because [insight about context], but [current obstacle].`

**Activities.**
1. **Draft (60–90 min, solo):** PM writes a first draft, picking the top opportunity on the OST as the anchor.
2. **Team redline (30–45 min):** team reads and sharpens language. Challenge: can every claim be tied to ≥2 log entries?
3. **Customer validation (3 short sessions):** read the statement to 3 customers who were previously interviewed. Ask "does this describe your experience?" Capture their response verbatim.
4. **Revise until customers nod.** If even one customer pushes back materially, revise and re-validate.
5. **Freeze the statement** and post it visibly. The team should be able to recite it from memory.

**Outputs.**
- Validated one-sentence problem statement.
- Customer-validation notes (which 3 customers, what they said, any revisions made).

**Tools / templates.**
- Problem statement template (chapter Step 5).

**Cadence / duration.**
- Draft + redline: 1 day. Customer validation: 1 week (scheduling slows it).

**Exit gate.**
- Three customers independently confirm the statement describes their experience. Every claim in the statement has ≥2 evidence log entries behind it.

**Pitfalls.**
- Writing the statement in product-manager language instead of customer language.
- Skipping the customer-validation step because "we already interviewed them." The validation is a distinct check: does *this sentence* describe their world?
- Statements that try to cover multiple segments. One segment per statement.

---

## Process 10 — Opportunity Prioritization

**Purpose.** Pick the one opportunity the team will attack first (and rank the next 2–6 behind it).

**RACI.** R: PM · A: PM · C: design, engineering · I: team, exec.

**Triggers.** Problem statement drafted (Process 9) and assumption tests have run.

**Inputs.**
- OST with opportunities and candidate solutions.
- Assumption test results.
- Current-state team capacity (from Phase 0 / Foundations).

**Activities.**
1. **Score each opportunity** on three axes (1–5):
   - **Impact on outcome** — if solved, how much does the target outcome move?
   - **Evidence strength** — how many customers independently described this pain?
   - **Confidence we can address it** — feasibility + business-fit, coarse.
2. **Rank.** Simple sum or weighted — document the weighting if used.
3. **Pick the top 1 as the focus.** Parallel attacks dilute; Torres's guidance is deliberate single focus during continuous discovery.
4. **Call out the next 2–6.** These are not being killed — they are sequenced.
5. **Agree and record.** Team alignment on the top pick is non-negotiable before Process 11.

**Outputs.**
- Ranked opportunity list (3–7 items) with the top-1 focus flagged.
- Scoring rubric and per-opportunity scores for auditability.

**Tools / templates.**
- Scoring spreadsheet (axis columns + notes column).

**Cadence / duration.**
- One working session, 90–120 minutes.

**Exit gate.**
- Whole team can name the top opportunity and the rationale.

**Pitfalls.**
- Scoring everything as "high impact" (no useful signal). Force spread.
- Letting executive pet opportunities override evidence scoring. Document the override and its reason if it happens.

---

## Process 11 — Phase Exit Decision

**Purpose.** Commit to **proceed, pivot, or kill**, with the evidence that drove the decision written down.

**RACI.** R: PM (final call) · A: PM · C: design, engineering, founders/exec · I: broader org.

**Triggers.** All exit-checklist items (chapter §Exit checklist) have a yes or an acknowledged gap. Processes 1–10 have produced their outputs.

**Inputs.**
- Problem statement (Process 9).
- Ranked opportunity list with top-1 (Process 10).
- Assumption test results (Process 8).
- Outstanding risks and open questions.
- Team capacity and willingness.

**Activities.**
1. **Pre-read (async, 48h before):** all attendees read the artifact set — problem statement, OST, assumption map + results, opportunity ranking, exit checklist.
2. **Meeting (60–90 min):**
   - PM walks through artifacts (20 min).
   - Each role voices their risk domain: PM on value/viability, Design on usability, Engineering on feasibility (20 min).
   - Discussion of unresolved risks (20 min).
   - Decision (10 min): proceed / pivot / kill. PM has final call after hearing the room.
3. **Write the decision record.** Mirror ADR format: context, decision, evidence, consequences, open risks carried forward, attendees.
4. **Communicate** — team-wide note + exec update if exec was not in the room.

**Outputs.**
- Written decision record: proceed / pivot / kill + rationale + open risks.
- If **proceed:** handoff package to Phase 02 (Plan) including problem statement, top opportunity, assumption map with current state, evidence log, OST.
- If **pivot:** statement of what's changing (segment / problem / solution class) and what's being re-tested.
- If **kill:** learnings summary, stored for future reference.

**Tools / templates.**
- Decision-record template (ADR-style).

**Cadence / duration.**
- One meeting. Budget 2 days for write-up and communication after.

**Exit gate (phase).**
- Decision record written and distributed.
- If proceeding, Phase 02 has the handoff package in hand.
- Standing weekly customer-contact cadence is scheduled into Phase 02 and beyond.

**Pitfalls.**
- Drifting into a fourth option — "we'll keep exploring for another 2 weeks." If the decision cannot be made, state that explicitly and define what evidence would unstick it, with a dated re-convene.
- Killing a strong signal because enthusiasm has flagged. Enthusiasm is not data; the record is.
- Proceeding on thin evidence because stakeholders have already started building internal narratives. Re-read the exit checklist line by line.

---

## Weekly rhythm (how these processes stack)

A typical week in full-intensity discovery for a team-of-5:

| Day | Activities | Owner |
|---|---|---|
| Mon | 1 interview + debrief; recruiting outreach; check in on open assumption tests | PM, rotating note-taker |
| Tue | 1–2 interviews + debriefs; design continues prototype work for active usability test | PM, Design |
| Wed | **Synthesis workshop** (after 3–5 cumulative interviews); mid-week recruiting push | Whole team |
| Thu | 1–2 interviews + debriefs; engineering feasibility spike progresses | PM, Eng |
| Fri | Evidence log audit; **assumption-test results review**; next-week interview confirmations; weekly 15-min team sync on OST changes | PM, whole team (sync) |

Peak load is ~15–20 hours/week for the PM, 6–10 hours/week each for design and engineering. Solo-founder version: condense to ~3 interviews + 1 synthesis pass per week, shed the redundant ceremonies, keep the evidence log and OST religiously.

---

## Scale notes

- **Solo founder.** You are every role. Drop Process 5's formal workshop; do it solo with a recorder running and a notes doc. Combine Processes 7 and 10 into one weekly reflection. Keep Processes 1, 3, 4, 6, 9, 11 intact — they are the load-bearing ones.
- **Team of 5.** This document's default.
- **Team of 50+.** Processes 1–10 run per squad; Process 11 runs per squad AND rolls up to a quarterly cross-squad synthesis to catch themes. A central research function (Dovetail-style) supports tooling and recruiting, but the squad PM still owns the work. Patton's dual-track warning applies: do not turn discovery into a separate team that hands specs to delivery.

---

## Handoff to Phase 02

If Process 11 lands on **proceed**, the following package goes to Phase 02:

1. Problem statement (Process 9 output).
2. Top opportunity + 2–6 ranked alternates (Process 10).
3. Assumption map with current evidence state and open tests (Process 7/8).
4. OST, current snapshot (Process 5/6).
5. Evidence log filtered to opportunities being taken forward.
6. Decision record (Process 11).
7. Standing weekly customer-contact cadence committed in the team's calendar.

Phase 02 (Plan) should not accept a handoff missing item 1, 2, or 7.
