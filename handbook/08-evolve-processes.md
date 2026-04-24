# Phase 08 — Evolve: Processes

**Companion to:** [`08-evolve.md`](08-evolve.md)
**Last updated:** 2026-04-24

This document decomposes Phase 08 into discrete, repeatable processes. `08-evolve.md` tells you *what evolving a running product is* and *why the industry converged on these practices*; this file tells you *who runs each process, when, with what inputs, and how you know it's done*.

---

## How to read this

Each process below follows the same ten-field pattern:

- **Purpose** — the one sentence that explains why this process exists.
- **RACI** — Responsible / Accountable / Consulted / Informed.
- **Triggers** — the events that start the process.
- **Inputs** — the artifacts / information required to run it.
- **Activities** — the concrete steps.
- **Outputs** — the artifacts / decisions that result.
- **Tools / templates** — what actually supports the work.
- **Cadence / duration** — how often it runs and how long it takes.
- **Exit gate** — the objective test that says "done."
- **Pitfalls** — the specific ways this process fails in practice.

Phase 08 is continuous; these processes run forever at different cadences. None of them truly "exits." The gate says when this cycle is done.

---

## Process inventory

| # | Process | Typical cadence | Primary owner |
|---|---|---|---|
| 1 | Quantitative Feedback Capture (North Star + analytics + NPS/CSAT/CES) | Continuous; weekly read | Product + data |
| 2 | Qualitative Feedback Synthesis (interviews + support + community) | Weekly | Product / PM |
| 3 | Weekly Metrics Review | Weekly | Product + eng lead |
| 4 | A/B Experiment Design & Execution | Per experiment | Product + eng |
| 5 | Tech Debt Logging & Quadrant Classification | Continuous; captured at PR time | Engineer who adds it |
| 6 | Hotspot Analysis | Monthly or quarterly | Eng lead + platform |
| 7 | Debt Paydown Allocation | Every sprint | Eng lead |
| 8 | Bug Triage & SLA Management | Daily or weekly triage; continuous closing | Rotating triage owner |
| 9 | Security Vulnerability Scoring & Patching | Per CVE; SLA-driven | Security lead |
| 10 | Dependency Update Rhythm | Continuous auto PRs; weekly review | Service author + platform |
| 11 | Deprecation & Sunset Execution | Per deprecated capability | Product + eng lead |
| 12 | Legacy Modernization (Strangler Fig) | Per legacy subsystem | Tech lead |
| 13 | Retrospective Facilitation | Every 2 weeks or per event | Team / rotating facilitator |
| 14 | Continuous Improvement (PDCA / Toyota Kata) | Continuous; per improvement | Eng lead / team |
| 15 | Quarterly Roadmap & OKR Evolution | Quarterly | Product + leadership |

---

## Default RACI

Convention: **R** = does the work; **A** = signs off; **C** = consulted before commit; **I** = notified after.

| Process | PM | Eng lead | Engineer | Designer | Security | Support / CS | Leadership |
|---|---|---|---|---|---|---|---|
| Quant feedback | R, A | C | C (instrumentation) | I | — | I | I |
| Qual feedback | R, A | C | I | C | — | R (shared) | I |
| Weekly metrics review | R, A | R | I | C | — | C | I |
| A/B experiment | R, A | C | R (implementation) | C | — | I | I |
| Tech debt logging | I | A | R | — | — | — | — |
| Hotspot analysis | C | R, A | C | — | — | — | I |
| Debt paydown | C | R, A | C | — | — | — | I |
| Bug triage & SLA | C | A | R (rotating) | C (UI bugs) | C (sec bugs) | C | I |
| Security patching | I | C | C (deployer) | — | R, A | — | I |
| Dependency updates | — | A | R | — | C | — | — |
| Deprecation / sunset | R, A | R | C | C | — | R (comms) | I |
| Legacy modernization | C | R, A | R | C | C | — | I |
| Retrospective | C | C | R (rotating facilitator) | C | — | — | I |
| Continuous improvement | C | R, A | R | — | — | — | I |
| Quarterly roadmap / OKRs | R, A | C | C | C | C | C | C |

---

## 1) Quantitative Feedback Capture

**Purpose.** Run a small, focused instrument panel that tells the team what users are actually doing, how they feel about it, and how the business is responding — without drowning in dashboards.

**RACI.** R, A: PM. C: eng lead (instrumentation), data team. I: leadership, design, support.

**Triggers.**
- New service / feature reaches production.
- Quarterly metric review.
- Major strategy pivot that changes the North Star.

**Inputs.**
- Product analytics tool (PostHog / Amplitude / Mixpanel, optionally with Segment as data plane).
- Survey tool (Delighted / Wootric / Qualtrics / SurveyMonkey / in-product).
- Business data source (billing / CRM / warehouse).
- Phase 07 observability (for error and support trends).
- A Phase 02 strategy document identifying value (so the North Star maps to value, not vanity).

**Activities.**
1. Pick **one North Star metric** that captures the value the product creates for users (weekly active teams, documents created, minutes saved, whatever fits the domain). Not a vanity count (sign-ups, page views).
2. Pick **3–5 input metrics** that the team believes drive the North Star — leading indicators.
3. Instrument events as features ship (not in a deferred "analytics sprint" that never runs). Add the event in the same PR as the feature; review event schema in code review.
4. Configure the surveys:
   - **NPS** (Reichheld 2003) — 0–10 scale, "How likely … recommend …?" + open-ended "Why?". Quarterly.
   - **CSAT** — 1–5 scale transactional, after specific events (ticket close, onboarding done).
   - **CES** — pick CES 1 (1–5 effort) or CES 2.0 (1–7 agreement). Do not switch variants between quarters.
5. Pull business metrics (MRR/ARR, expansion, churn, LTV, CAC) from the source of truth; do not reconstruct them in analytics.
6. Pull support / error trends from Phase 07 (ticket volume by category, error rate per feature).
7. Assemble a single dashboard: North Star, input metrics, survey scores, business metrics, support/error trends. Under ten tiles.
8. Keep the *survey verbatim text stream* searchable — that is where the signal lives. A numeric NPS without the verbatim is noise.

**Outputs.**
- Instrumented events deployed.
- Configured surveys running.
- One dashboard the team reads weekly.
- Verbatim-text archive (spreadsheet / Notion / tool).

**Tools / templates.**
- PostHog / Amplitude / Mixpanel / Heap / Matomo.
- Segment (or RudderStack) if routing to multiple destinations.
- Delighted / Wootric / in-product survey widgets.
- A Looker / Metabase / Hex dashboard pulling from warehouse + billing.
- An event-schema registry.

**Cadence / duration.** Instrumentation: ongoing, per feature. Dashboard: reviewed weekly. Survey run cadence: NPS quarterly; CSAT / CES continuous transactional.

**Exit gate.**
- North Star + 3–5 input metrics live.
- At least one survey (NPS/CSAT/CES) running with verbatims captured.
- Business metrics pulled, not reconstructed.
- Dashboard under 10 tiles, read weekly.

**Pitfalls.**
- **"Analytics later" sprint.** Instrumentation slips forever; cohort comparisons become impossible retroactively.
- **Dashboard with 60 tiles.** Nobody reads it.
- **Vanity North Star.** Sign-ups / page views — moves without user value moving.
- **NPS number without verbatims.** Manufactures confidence.
- **Switching CES variants mid-year.** Trends become incomparable.
- **Business metrics reconstructed from events.** Billing truth is billing, not analytics.
- **No event-schema review.** Names diverge; old events break.

---

## 2) Qualitative Feedback Synthesis

**Purpose.** Hear customers' actual words every week, from multiple channels, so quantitative signal has the context that makes it actionable — rather than a team guessing what the numbers mean.

**RACI.** R, A: PM. C: designer, eng lead, support. I: team, leadership.

**Triggers.**
- Weekly synthesis cadence.
- Feedback surge after a release or incident.
- Quarterly theme extraction.

**Inputs.**
- Continuous customer interviews (Torres-style continuous discovery — see Phase 01 process 2).
- Support tickets (last 7 days).
- Sales call notes, CS call notes.
- Community channels (Slack / Discord / GitHub Discussions / forums).
- In-product feedback widget.
- Survey verbatims (from process 1).

**Activities.**
1. Maintain a **minimum of one customer interview per week, every week, forever**. If none happened, that's a red flag. Do not let it slide two weeks in a row.
2. Rotate a **voice-of-customer duty**: one engineer per week reads the last 7 days of support tickets and summarises patterns for the team. Shares the workload; makes "customer-facing" a team attribute, not a role.
3. PM attends **≥ 1 sales call and ≥ 1 CS call per month**. Not to pitch; to listen.
4. Lurk community channels; resist brand-policing.
5. Weekly synthesis:
   - Thematic tagging (opportunity, complaint, praise, request, bug, confusion).
   - Link themes to the opportunity tree maintained from Phase 01.
   - Flag anything that contradicts or reinforces the current North Star / OKR narrative.
6. Monthly or quarterly: aggregate themes into a short narrative. Top 3 pain themes, top 3 praise themes, emerging themes.
7. Feed themes into the roadmap evolution process (process 15) and the discovery pipeline (back into Phase 01 process 2).

**Outputs.**
- Interview notes archive (audio + summary).
- Support-pattern digest (weekly, shared in a team channel).
- Monthly / quarterly themes document.
- Updates to the opportunity tree.

**Tools / templates.**
- Interview-management platforms (Dovetail, Condens, Notably) for larger teams; spreadsheet / Notion for smaller ones.
- Support platform (Zendesk, Intercom, Help Scout, Plain).
- Recording tools (Grain, Gong, Otter) with consent.
- A weekly voice-of-customer rotation roster.

**Cadence / duration.** Weekly: 1–2 hours synthesis. Monthly: 1 hour theme roll-up. Quarterly: 2 hours narrative.

**Exit gate.**
- ≥ 1 interview per week over the last quarter, documented.
- Weekly VoC digest posted.
- Monthly themes document delivered.
- At least one opportunity-tree update per month traceable to a customer conversation.

**Pitfalls.**
- **Month with no interviews.** The first symptom of drift; tolerated becomes the new normal.
- **Only the PM talks to customers.** Engineers build without context.
- **Unstructured notes.** No theme extraction is possible; conversations evaporate.
- **Community as brand-police target.** Engagement collapses; honest signal dries up.
- **Qualitative decoupled from quantitative.** The two are complements; read together, not separately.

---

## 3) Weekly Metrics Review

**Purpose.** Create a fixed, short, habit-forming moment where the team looks at what changed and decides what to do next — so signal becomes decisions, not aesthetic dashboards.

**RACI.** R, A: PM. R: eng lead. C: designer. I: team.

**Triggers.** Every Monday (or fixed day). No skip.

**Inputs.**
- The dashboard from process 1.
- Weekly VoC digest from process 2.
- Production incidents from Phase 07.
- Last-week's changes (deploys, experiments, releases).

**Activities.**
1. 30-minute fixed slot. Small room / video call.
2. Walk the dashboard top-down:
   - North Star: what did it do? Expected?
   - Input metrics: which moved? Why?
   - Survey scores / verbatims: any new theme?
   - Business metrics: any surprise?
   - Incidents / errors: any cluster?
3. For each anomaly, pick one of: **investigate more**, **act this week**, **note and move on**. Decisions, not narration.
4. Scribe captures decisions in a shared log.
5. Anything marked "investigate more" gets an owner and a due date.
6. Anything marked "act this week" creates a ticket / updates the sprint.
7. At the start of next week, re-read last week's decisions before looking at this week's numbers.

**Outputs.**
- Decision log entries.
- Tickets for "act this week" items.
- Investigations scheduled.

**Tools / templates.**
- Team chat channel for the log, or a Notion / Linear / Jira doc.
- The metrics dashboard (process 1).
- A fixed agenda template to prevent meetings sliding into narration.

**Cadence / duration.** Weekly, 30 minutes.

**Exit gate.**
- Meeting happened.
- Decision log written.
- Last week's decisions closed or re-planned.

**Pitfalls.**
- **Narrating what the numbers say.** Decision-free. Dashboards get read, nothing changes.
- **Skipping when nothing looks interesting.** Rhythm breaks; team loses the habit.
- **Attendees drift to 20 people.** It becomes a status meeting; decisions slow.
- **No pre-reading.** Attendees see the numbers fresh and have no time to think.
- **Decisions not reviewed next week.** Ritual dies; nobody trusts the log.

---

## 4) A/B Experiment Design & Execution

**Purpose.** Decide by evidence when the answer is genuinely uncertain and the change is user-facing — and to *not* A/B when it's not worth the machinery.

**RACI.** R, A: PM. R: engineer (implementation). C: designer, eng lead, data. I: team.

**Triggers.**
- A landing / onboarding / pricing / search / ranking variant to evaluate.
- A feature variant where one might be materially better and the team does not know.
- Hypothesis emerges from Phase 01 discovery or Phase 08 qualitative synthesis.

**Inputs.**
- Hypothesis + expected effect size.
- Phase 06 feature-flag system.
- Experimentation platform (GrowthBook / Optimizely / PostHog Experiments / LaunchDarkly / Statsig).
- Baseline traffic at the test surface.

**Activities.**
1. Filter first. **When to A/B test:**
   - Landing / onboarding variants.
   - Pricing experiments (carefully; cohort effects).
   - Feature variants where impact is genuinely unknown.
   - Algorithmic changes (search / ranking / recommendations) with measurable behaviour.
2. **When NOT to A/B test:**
   - Obvious bug fixes — ship.
   - UI copy tweaks on low-traffic surfaces.
   - Strategic pivots — commit and adjust, don't hedge.
   - Security / compliance changes.
   - Any situation where running two variants costs more than the answer is worth.
3. Write the hypothesis: "For <audience>, variant <B> will change <metric> by <effect> compared to <A>."
4. Compute minimum sample size before starting. Rule of thumb: ~1000 conversions per variant to detect 1–3% effects reliably. If traffic is too low: run longer, pick bigger changes, or ship-then-measure.
5. Pre-register sample size and stopping rule. **Don't peek.** Early stopping inflates false positives.
6. Build the variant behind a flag that the experimentation platform controls.
7. Launch; monitor for instrumentation sanity (not outcome) in the first hours.
8. Let it run to the pre-registered stopping condition.
9. Analyse outcome. Decision = ship A / ship B / no-decision + next experiment.
10. **Holdout groups (at scale).** Hold 5% back for 30–90 days to detect long-term regressions short-window tests miss.
11. Log the experiment in the experiment log: hypothesis, variants, metric, outcome, decision.

**Outputs.**
- Experiment spec (hypothesis, variants, metric, sample plan).
- Running experiment in the platform.
- Outcome analysis + decision.
- Experiment log entry.

**Tools / templates.**
- GrowthBook (open source), Optimizely, PostHog Experiments, LaunchDarkly, Statsig, AB Tasty.
- Sample-size calculator (platform-provided).
- Experiment log (shared spreadsheet or platform-native).
- Feature-flag platform (Phase 06 process 5).

**Cadence / duration.** Per experiment. Setup: hours. Run: days to weeks. Analysis: hours.

**Exit gate.**
- Hypothesis pre-registered.
- Sample size / stopping rule set before starting.
- Outcome analysed at the stopping condition (not earlier).
- Decision made and logged.

**Pitfalls.**
- **Peeking.** Early stops chase noise; false positives explode.
- **No minimum sample size.** Noise indistinguishable from signal.
- **A/B testing a bug fix.** Just ship.
- **A/B testing strategy.** Strategy is commitment; not suitable for variant split.
- **Underpowered experiment declared "no effect."** Absence of evidence ≠ evidence of absence.
- **Treating the platform's default dashboard as ground truth.** Know what the stats actually do; sample-ratio mismatch, novelty effects, seasonality.
- **No experiment log.** Same test run three times across years.

---

## 5) Tech Debt Logging & Quadrant Classification

**Purpose.** Capture debt as it's created — at the moment the engineer knows it's there — so the ledger reflects reality, and classify it so the team treats prudent and reckless debt differently.

**RACI.** R: engineer who adds the debt. A: eng lead. C: reviewer. I: team.

**Triggers.**
- Shipping code that knowingly takes on debt.
- Code review noticing debt and tagging it.
- Postmortem finding that names a debt contributor.
- Static analysis flag.

**Inputs.**
- Cunningham's debt definition (deliberate tradeoff for learning) and 2009 clarification (gap between what you knew and what you know now).
- Fowler's quadrant: deliberate vs. inadvertent × prudent vs. reckless.
- In-code tag convention: `// TODO(debt):` or `// FIXME(debt):`.
- Optional: ADR template for load-bearing debt.

**Activities.**
1. When a PR knowingly adds debt, the PR description names it in one sentence: what it is, why we're taking it, what paying it down would look like.
2. Add a `// TODO(debt):` tag in code with a 1-line description + ticket / ADR reference.
3. Classify using Fowler's quadrant:
   - **Deliberate–Prudent** ("must ship now, will pay back") — fine; ticket with paydown condition.
   - **Deliberate–Reckless** ("no time for design") — reviewer blocks; fix the process.
   - **Inadvertent–Reckless** ("what's layering?") — training / pairing / better review fixes it, not a ticket.
   - **Inadvertent–Prudent** ("we know better now") — the dominant category in any real system; schedule paydown.
4. Reviewer challenges the classification in code review. Debt without a quadrant is untagged.
5. Do *not* build a 500-item "debt backlog." Tags in code + a hotspot report (process 6) beat a list nobody reads.
6. For load-bearing debt affecting more than one module, write a short ADR (Phase 03) naming the trade and the exit condition.

**Outputs.**
- In-code `// TODO(debt):` tags.
- PR description entries for taken-on debt.
- Quadrant classification (in the tag or the ticket).
- ADR entries for load-bearing debt.

**Tools / templates.**
- `grep` / ripgrep for `TODO(debt):` to count and surface.
- Static-analysis rules (SonarQube, Semgrep) to flag tagged debt and unannotated complexity.
- A short PR template field: "debt taken on (if any)."

**Cadence / duration.** Continuous; at PR time.

**Exit gate.**
- Every knowingly-added debt item has a tag + 1-line reason.
- PR description names debt taken on.
- Reviewer has challenged the quadrant.

**Pitfalls.**
- **500-item backlog.** Archaeology within 6 months; nobody touches it.
- **Untagged debt.** Not findable; compounds silently.
- **"We'll refactor later" without a condition.** Later never arrives.
- **Reckless debt not pushed back on in review.** The process fails at the point it's supposed to catch it.
- **Quadrant used as a judgement tool.** It's a diagnostic. Don't shame the engineer for inadvertent–reckless; change the training.

---

## 6) Hotspot Analysis

**Purpose.** Find the files where interest is actually being paid — high change frequency overlapping with high defect / incident frequency — so debt paydown targets what hurts, not what's aesthetically ugly.

**RACI.** R: eng lead or platform. A: eng lead. C: service tech leads. I: team.

**Triggers.**
- Monthly or quarterly cadence.
- PR cycle time doubles in a specific module.
- A cluster of incidents traces to the same area.
- Before a major debt paydown allocation decision.

**Inputs.**
- Git log (commit history, authors, timestamps).
- Incident tracker / bug tracker data (defects per file).
- Ownership metadata (CODEOWNERS).
- Optional: CodeScene or similar tooling.

**Activities.**
1. Compute **change frequency per file** over the last 3–12 months:
   - `git log --pretty=format: --name-only --since='6 months ago' | sort | uniq -c | sort -rg | head -50`.
2. Compute **defect / incident density per file**:
   - Link bugs / incidents to files (via fix commits or postmortem references).
   - Count per file; rank.
3. Overlay both: files high on *both* axes are hotspots. This is where interest is actually being paid per Fowler's rule ("interest is triggered by modification activity, not time").
4. Inspect the top 10 hotspots:
   - Complexity metric (cyclomatic, cognitive).
   - Ownership: one owner, multiple owners, or orphaned?
   - PR cycle time for changes here vs. team baseline.
5. Prioritise paydown candidates — the hotspot with high change, high defects, and high complexity is the one to fix.
6. Write a short hotspot report: top 10 files, their metrics, proposed actions.
7. Feed into process 7 (Debt Paydown Allocation).

**Outputs.**
- Hotspot report (markdown, wiki, or platform dashboard).
- Prioritised paydown candidates.
- Ownership gaps identified.

**Tools / templates.**
- `git log` + `awk` scripts (sufficient for small teams).
- CodeScene, CodeClimate, SonarQube for continuous hotspot monitoring.
- Jira / Linear query filter linking tickets to files.
- A hotspot report template.

**Cadence / duration.** Monthly report: 1–2 hours with scripts. Quarterly deeper review: half a day.

**Exit gate.**
- Top 10 hotspots identified.
- Each has metrics + owner + proposed action.
- Fed into paydown allocation (process 7).

**Pitfalls.**
- **Hotspots ≠ ugly code.** A clean file touched weekly for features is not automatically a paydown target; debt is about mismatch, not aesthetic.
- **Refactor targets picked by seniority / taste.** Process 7 needs hotspot data; senior taste is input, not oracle.
- **Cleanup of stable modules.** Fowler: cleanup that targets stable unchanged modules is wasted effort.
- **No link from bug tracker to files.** Defect density unknown; half the signal missing.
- **One-off analysis, never repeated.** Hotspots move; stale snapshot misleads.

---

## 7) Debt Paydown Allocation

**Purpose.** Spend a continuous, predictable fraction of engineering capacity on paying debt down — so the system stays shippable year over year instead of slowing to a crawl.

**RACI.** R, A: eng lead. C: PM, service tech leads. I: team, leadership.

**Triggers.**
- Every sprint / iteration planning.
- Quarterly capacity review.
- Velocity regression or on-call load rise.

**Inputs.**
- Hotspot report (process 6).
- In-code debt tags (process 5).
- Postmortem action items (Phase 07 process 9).
- Velocity / cycle-time trends.
- Engineering headcount and sprint capacity.

**Activities.**
1. Allocate **15–20% of engineering capacity** to debt paydown **continuously**, every sprint. Not "after the launch." There's always another launch.
2. Pick paydown candidates from hotspots + postmortem actions + tagged debt, in that priority order.
3. Prefer **small PRs alongside feature work** (boy scout rule: leave the code better than you found it). The PR that adds a feature to a module also cleans up that module's obvious messes.
4. Avoid **big-bang refactoring sprints**. They fail for the same reasons rewrites fail: massive batch, delayed integration, no user value shipped along the way.
5. At end-of-sprint retro, name **one thing the team made materially better**. If you can't, the 15–20% was not actually spent on debt.
6. Track the capacity spend — story points or cycle time — so "we did debt this sprint" becomes evidence, not a feeling.
7. When a major refactor is unavoidable, use the Strangler Fig pattern (process 12), not a rewrite.

**Outputs.**
- Sprint plan showing debt capacity allocation.
- End-of-sprint "what got better" statement.
- Quarterly paydown rollup.

**Tools / templates.**
- Sprint planning tool (Jira / Linear / Shortcut).
- Capacity allocation policy (written down; team-visible).
- Retrospective template field for paydown wins.

**Cadence / duration.** Every sprint. Planning: included in sprint planning; review: 10 min at retro.

**Exit gate.**
- 15–20% of sprint capacity allocated to debt.
- End-of-sprint has a concrete "this got better."
- Quarterly trend shows allocation being spent.

**Pitfalls.**
- **"After the launch."** Forever excuse; debt compounds.
- **100% feature sprints.** Velocity falls over 2–4 quarters; recovery is 10× harder than prevention.
- **Debt sprint every 6 months.** Massive batch; doesn't ship; demotivates.
- **Feature work labelled as debt.** 20% capacity theatre.
- **Paydown on non-hotspot modules.** Cleanup without impact.
- **Senior-taste priorities.** Ignores hotspot data; fixes what's aesthetic, not what hurts.

---

## 8) Bug Triage & SLA Management

**Purpose.** Keep the bug backlog small enough to be a work queue, not an archive — by triaging predictably, closing explicitly, and holding ourselves to severity-based SLAs.

**RACI.** R: rotating triage owner. A: eng lead. C: PM, designer (UI bugs), security (security bugs), support. I: team.

**Triggers.**
- New bug filed (inflow).
- Daily / weekly triage slot.
- SLA breach alert.
- Customer escalation.

**Inputs.**
- Bug tracker (Jira / Linear / GitHub Issues / Shortcut).
- Severity / priority definitions (distinct fields).
- Team SLAs per severity.
- Support-ticket flow (Phase 07 + process 2).

**Activities.**
1. Field distinction, **non-negotiable**:
   - **Severity** — property of the bug (impact: users, data, revenue, compliance).
   - **Priority** — property of the schedule (when we'll fix it).
   They usually correlate but not always. Track as two fields; do not conflate.
2. Triage cadence:
   - **Daily triage** for high-inflow teams: 15 minutes, one person on rotation.
   - **Weekly triage** for low-inflow: 30 minutes, whole team, walks new tickets.
3. Every bug gets: severity, priority, owner, target resolution date, reproduction note. Missing fields → send back to reporter.
4. Apply the team's severity SLAs (example defaults; adjust to contracts):
   - **SEV1** — outage / data loss / security — fix now (page on-call, process 8 Phase 07).
   - **SEV2** — major feature broken, no workaround — fix within 1 business day.
   - **SEV3** — annoying, not blocking — fix within 2 weeks.
   - **SEV4** — cosmetic / edge case — backlog, revisit quarterly.
5. Close "can't reproduce" / "won't fix" **explicitly**. An unresolved open bug is a question the team committed to answering.
6. Track SLA compliance. Target ≥ 90% by severity. A 40%-breach SLA is worse than no SLA — signals that policy is vibes.
7. Escalate SEV1 / SEV2 into the Phase 07 incident process immediately if user impact is active.
8. Security bugs → route to process 9 (different scoring, different SLA).

**Outputs.**
- Triaged bugs with severity, priority, owner, due date.
- SLA compliance report (weekly).
- Closed "won't fix" / "can't reproduce" items explicit.

**Tools / templates.**
- Bug tracker filters / saved queries.
- SLA dashboard (bugs open by severity × age).
- Triage rotation roster.

**Cadence / duration.** Daily: 15 min. Weekly: 30 min.

**Exit gate.**
- Triage happened on schedule.
- All new bugs have severity, priority, owner, date, repro.
- SLA compliance > 90% per severity.
- Backlog inflow ≤ outflow week over week.

**Pitfalls.**
- **Severity = priority.** Conflated fields produce mis-scheduled work.
- **Ignored SLA.** Signals that policy is decorative; team stops trusting it.
- **Open tickets forever.** Backlog archaeology.
- **No rotation.** Triage burden on one person; burnout.
- **"Can't reproduce" without the reporter asked for details.** Closed incorrectly; real bug comes back as a bigger one.
- **Security bugs in the general queue.** Visible to everyone including the wrong people.

---

## 9) Security Vulnerability Scoring & Patching

**Purpose.** Respond to CVEs with a standardised scoring and patching lifecycle that fits your pipeline — so critical fixes ship within an agreed SLA and none of them gets lost in the general queue.

**RACI.** R, A: security lead. C: eng lead, service tech lead, compliance. I: leadership.

**Triggers.**
- CVE published against a dependency / runtime / platform the team uses.
- Vendor security advisory.
- External researcher report to `security@`.
- Internal discovery (SAST / DAST / code review).
- Threat-intelligence feed.

**Inputs.**
- CVE/NVD feeds (automated ingest).
- SBOM per release (Phase 06 process 2).
- Dependency manifest.
- CVSS v4.0 scoring reference (FIRST.Org).
- NIST SP 800-40 Rev. 4 four-phase risk response.
- Patch SLAs per severity band.

**Activities.**
1. **Identify.** Automated CVE feed → SBOM lookup → does this vulnerability affect a dependency we actually deploy?
2. **Assess / score.** Use **CVSS v4.0** (FIRST.Org, Nov 2023). Four metric groups: Base, Threat, Environmental, Supplemental. Use **environmental** metrics to translate a score into *your* risk (NIST: "CVSS is not a measure of risk").
   - Map to **NIST NVD bands**:
     - None 0.0 / Low 0.1–3.9 / Medium 4.0–6.9 / High 7.0–8.9 / Critical 9.0–10.0.
3. **Decide SLA** per band (example defaults; adjust to contracts):
   - Critical: patch within 24 hours.
   - High: 7 days.
   - Medium: 30 days.
   - Low: 90 days.
4. **NIST SP 800-40 Rev. 4 four-phase risk response:**
   - **Prepare** — acquire, validate, test patches; coordinate with change mgmt.
   - **Implement** — deploy the patch through the standard pipeline (Phase 06).
   - **Verify** — confirm install, confirm effectiveness.
   - **Continuously monitor** — sustain oversight that the response stays in place.
5. **No bypassing canary.** Patches ship through the standard pipeline. Speed comes from the pipeline being fast, not from skipping it.
6. **Coordinated disclosure**, if you are the vendor of the vulnerable software:
   - Publish `security.txt` / `security@` inbox.
   - Triage SLA (e.g., acknowledge within 1 business day).
   - Embargo window per severity — draw on Google Project Zero (90-day) / ZDI (120-day) norms.
   - Advisory + CVE ID + changelog entry on fix release.
7. **Verify everywhere.** Prod, staging, dev, demo environments. A patched prod and an unpatched demo is a disclosed entry point.
8. **Communicate.** Changelog, advisory, in-product notice if users must act.

**Outputs.**
- Scored CVE entry (CVSS v4.0 + NVD band + environmental adjustment).
- Patched deployment (verified across envs).
- Advisory published (if vendor).
- Patch-SLA dashboard updated.

**Tools / templates.**
- CVE / NVD feed ingestion (GitHub Advisory Database, OSV, NVD API).
- Snyk / GitHub Advanced Security / Trivy / Grype for CVE-to-SBOM matching.
- A patch SLA dashboard.
- A coordinated-disclosure playbook.

**Cadence / duration.** Continuous (inflow). Per CVE: minutes to hours to score; hours to days to patch; SLA-bounded.

**Exit gate.**
- CVE scored (CVSS v4 + environmental).
- Patch deployed within SLA.
- All environments verified.
- Advisory / changelog published (if applicable).
- SLA dashboard reflects the outcome.

**Pitfalls.**
- **Treating CVSS base as risk.** Environmental metrics exist for a reason.
- **Skipping canary for "just a patch."** Patches break things too.
- **Prod patched, staging forgotten.** Leaked entry point.
- **No coordinated disclosure policy.** Researcher goes public; you're caught flat-footed.
- **SLA missed silently.** Patch debt accumulates; next CVE worsens exposure.
- **SBOM stale at the moment a CVE drops.** Answering "do we use it?" takes days instead of minutes.

---

## 10) Dependency Update Rhythm

**Purpose.** Keep the transitive dependency tree current by default — so security patches ship within hours, not weeks, and major-version migrations are regular rather than emergency work.

**RACI.** R: service author (or on-duty engineer). A: eng lead. C: security, platform. I: team.

**Triggers.**
- Dependabot / Renovate PR opened.
- Weekly / monthly batch review.
- Major version released upstream.
- CVE announced affecting a dependency (routes to process 9).

**Inputs.**
- Committed lockfiles (`package-lock.json`, `yarn.lock`, `Cargo.lock`, `Gemfile.lock`, `go.sum`, pinned `requirements.txt`).
- Dependabot or Renovate configured.
- CI (tests + security scans).
- SemVer 2.0.0 contract (patch / minor / major implications).

**Activities.**
1. **Commit lockfiles** — non-negotiable. CI and prod must reproduce from the pinned tree.
2. Configure automated update PRs:
   - **Dependabot** (GitHub) or **Renovate** (Mend, open source).
   - Schedule: patch PRs daily, minor PRs weekly or grouped, major PRs manually evaluated.
   - Auto-merge **patch PRs** when CI is green (tests + security scan).
   - **Minor PRs** reviewed weekly, batched into 1–2 merges.
   - **Major PRs** scheduled deliberately (process 15 roadmap), not triggered by CVE.
3. **Security updates** (Dependabot / Renovate tag them) route to process 9 SLA, not general cadence.
4. Mirror critical dependencies through a **private proxy** (Artifactory, Nexus, GitHub Packages, Verdaccio). Prevents upstream unpublish from breaking builds (cf. left-pad incident, 2016).
5. Pin container base images by digest, not by tag (e.g. `alpine@sha256:...`).
6. Verify signatures where possible (cosign for container images, sigstore for OSS).
7. Minimise transitive depth when possible — a direct replacement of a heavy dependency with a lighter one is a legitimate paydown target.
8. Monthly (minor) / quarterly (major) review: confirm update SLA being met; close orphan PRs from tools; update tool config.

**Outputs.**
- Green auto-merged patch PRs.
- Weekly batched minor PRs.
- Scheduled major PR evaluations.
- Private registry proxy configured.
- Mirrored critical deps.

**Tools / templates.**
- Dependabot / Renovate configuration file (`.github/dependabot.yml` or `renovate.json`).
- CI tests + SAST / SCA scan gating auto-merge.
- Private package registry (Artifactory, Nexus, GitHub Packages).
- `cosign verify` integration.

**Cadence / duration.** Continuous inflow. Weekly 30-min review. Monthly / quarterly checkpoint.

**Exit gate.**
- Lockfiles committed for every service.
- Automated update tool running.
- Patch auto-merge enabled (behind green CI).
- Private proxy configured for critical deps.
- No update PR open > 30 days without triage.

**Pitfalls.**
- **No lockfile committed.** CI and prod diverge; debugging nightmare.
- **Dependabot on but nobody reviews.** PRs rot.
- **No auto-merge for patches.** Security-patch velocity is limited by human review; you can't hit 24h Critical SLA.
- **Major updates only when forced by CVE.** Emergency weekend work.
- **No private mirror.** Upstream unpublish (left-pad pattern) breaks CI.
- **Base image pinned by mutable tag.** Silent drift between builds.
- **Dep scanning only in production.** Misses window to fix in CI.

---

## 11) Deprecation & Sunset Execution

**Purpose.** Remove capability deliberately — with communication, migration paths, and a clear clock — so the product doesn't accumulate forever-maintained features that drain capacity from new work.

**RACI.** R, A: PM. R: eng lead. C: designer, support, security, affected customers. I: team.

**Triggers.**
- Usage drops below a pre-decided meaningful threshold.
- A superior replacement has shipped and adoption passed a threshold.
- Feature has outsized maintenance cost per active user.
- API version has been replaced.
- Feature conflicts with strategic direction.

**Inputs.**
- Usage data (from process 1).
- List of affected customers (from CRM / CS).
- Replacement capability (if any).
- Deprecation policy (public-facing, stable).
- RFC 8594 Sunset header spec.

**Activities.**
1. **Decide, don't drift.** Set a pre-decided usage threshold so the deprecation debate is about data, not arguments.
2. Write the **deprecation case**: what, why, replacement, affected cohort, timeline, rollback if adoption of replacement stalls.
3. Public APIs: emit the **`Sunset` HTTP response header** (RFC 8594): `Sunset: Sat, 31 Dec 2027 23:59:59 GMT`. Add the `Deprecation` header where tooling supports it.
4. Pick a **lead time** appropriate to the audience:
   - Public APIs with paying customers: 6–12 months.
   - Internal APIs: 1–3 months.
   - Product features for end-users: 1–3 months with in-product banner.
5. Publish a **migration guide** with real before/after code / screenshots.
6. **Communicate through multiple channels**, not one:
   - In-product banner.
   - Email to affected users.
   - Changelog entry.
   - Status-page or release-notes note.
   - Direct CS outreach for top customers.
7. **Freeze → retire → remove.** No new users on it; existing users migrated; code deleted. Each step has a date in the plan.
8. **Monitor adoption of the replacement** before the sunset date. If adoption is < 80% of the affected cohort with 4 weeks left, decide: extend, or force-migrate, or do proactive outreach.
9. **Humane holdouts.** A small cohort always misses deadlines. Individual outreach if numbers allow.
10. Data-export path if the feature held user-owned data.
11. Delete the code and strip the feature flag after removal; do not leave a dead code path (ties to Phase 06 flag lifecycle).

**Outputs.**
- Deprecation decision document.
- `Sunset` / `Deprecation` headers deployed.
- Migration guide published.
- Communications sent across channels.
- Adoption-of-replacement dashboard.
- Deprecation / removal release notes.
- Code deleted after removal.

**Tools / templates.**
- Deprecation policy document in the public docs.
- Migration guide template.
- `Sunset` header middleware.
- Monitoring of deprecated endpoint traffic (tagged).
- Communication templates (email, in-product, changelog).

**Cadence / duration.** Per deprecation. Initial plan: days. Execution: weeks to months. Lead-time policy: 6–12 months for public APIs.

**Exit gate.**
- Deprecation announced through all agreed channels.
- Migration guide available.
- `Sunset` header live.
- Replacement adoption ≥ threshold at sunset date, or explicit exception approved.
- Code removed after sunset.

**Pitfalls.**
- **Silent removal.** Customers discover a missing feature in production; trust breaks.
- **Deprecation without migration path.** Users are asked to change workflow with no help.
- **Sunset date slips repeatedly.** Team loses the ability to enforce deadlines.
- **One-channel communication.** "We posted it in the changelog." Nobody read it.
- **Code path left behind after removal.** Dead code confuses future readers.
- **Missing `Sunset` header.** Machine clients cannot detect the deprecation.
- **No usage threshold defined in advance.** Every deprecation becomes a values debate.

---

## 12) Legacy Modernization (Strangler Fig)

**Purpose.** Replace a legacy subsystem incrementally — growing the new alongside the old and retiring the old slice by slice — because rewrites almost always fail and strangling almost always works.

**RACI.** R, A: tech lead. R: engineers on the modernization. C: PM, security, designer, platform. I: team, leadership.

**Triggers.**
- A subsystem becomes hard to change (PR cycle time blows up, defect density rises).
- Framework / runtime goes end-of-life.
- Database schema has calcified to the point of blocking the business.
- Team decides a rewrite — push back to Strangler Fig first.

**Inputs.**
- The legacy subsystem and its current behaviour (documented as known).
- Test coverage of the legacy (measure; accept the gap as the starting state).
- Phase 03 design artifacts for the replacement (C4 + ADR).
- Feathers' seams (preprocessing, link, object).
- Fowler's Strangler Fig pattern description.

**Activities.**
1. **Clear outcome first.** Write down why the modernization exists and what success looks like (speed, reliability, feature enablement, cost). Without this, the project becomes a rewrite in disguise.
2. **Identify the seams.** Michael Feathers' definition: "a place where you can alter behavior in your program without editing in that place." Prefer **object seams** in OO languages; otherwise link or preprocessing.
3. **Stand up the new system alongside the legacy.** Same inputs, same protocol, initially zero traffic routed to it.
4. **Route one slice** — one endpoint, one entity type, one small tenant, one geography. Smallest knife slice that proves the pattern works.
5. **Verify parity** before promoting:
   - **Shadow / mirror** (Phase 06) — send a copy of traffic to the new path; discard responses but diff against the old.
   - Canary percentage starting at 1%.
   - Dedicated diff tool comparing outputs on the same input.
6. **Promote** — real traffic moves from old to new for that slice.
7. **Retire** the old path for that slice once new is stable (matched canary criteria in Phase 06).
8. **Repeat** until the old system is empty, then delete it.
9. **Feature freeze on the legacy** once modernization starts; otherwise the two diverge and the migration never ends.
10. **Organisational support** — Fowler explicitly names "organizational changes to sustain the approach" as one of the four activities. Capacity must be allocated, not opportunistic.
11. Consider a rewrite **only if all** of:
    - Legacy actively blocks the business in a way incremental change cannot fix.
    - Team can run both in parallel until handoff (double capacity or reduced feature work).
    - Domain is well-understood.
    - Executive commitment exists to ship, not just start.
    - If any of these is missing, strangle.

**Outputs.**
- Clear outcome document.
- Seam map (what can be replaced at which boundary).
- Parallel new subsystem with traffic routing.
- Slice-by-slice migration log.
- Legacy deleted at end of migration.

**Tools / templates.**
- Service mesh / API gateway for traffic routing.
- Shadow-traffic / diff tooling (e.g., Twitter's Diffy-pattern internal tools).
- Phase 06 canary machinery.
- Feature-flag platform for controlled slice promotion.
- ADR per major replacement decision (Phase 03 process 3).

**Cadence / duration.** Per legacy subsystem. Months to years for large migrations, but ships value incrementally throughout — no multi-year stall.

**Exit gate.**
- Outcome document signed off.
- At least one slice migrated, parity verified, traffic promoted.
- Legacy feature-frozen.
- Migration plan updated with next slice.
- Eventually: old system deleted.

**Pitfalls.**
- **Rewrites disguised as strangles.** "Strangler" that ships nothing for 18 months is a rewrite.
- **Legacy not feature-frozen.** New and old diverge; migration never finishes.
- **No parity verification.** New system ships wrong behaviour at scale.
- **Slicing at the wrong seam.** Cross-cutting changes become impossible; slice-by-slice grinds to halt.
- **No organisational commitment.** Project is everyone's "when I have time"; dies.
- **Skipping shadow / diff.** Silent regressions in business logic.
- **Big-bang final cutover at end.** Defeats the point; risk concentrates at the worst moment.

---

## 13) Retrospective Facilitation

**Purpose.** Give the team a fixed, safe space every iteration to inspect how it works and change one thing — so process stays adapted rather than calcified.

**RACI.** R: rotating facilitator. A: eng lead (ensures it happens). C: PM, designer. I: team.

**Triggers.**
- Every 2 weeks at sprint boundary (default).
- After any significant event — launch, incident, release cut, reorg.
- Quarterly deeper retro on process.

**Inputs.**
- Last retro's action items (to review at the start).
- Sprint events and outcomes.
- Any incidents or surprises.
- Kerth's Prime Directive (read aloud at start).
- Chosen format (start/stop/continue, mad/sad/glad, 4 Ls, sailboat). Fixed across retros so the team doesn't re-learn the ceremony.

**Activities.**
1. **Start with the Prime Directive** (Kerth): "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand." Read aloud. Not decorative — it's the operating assumption.
2. **Review last retro's action items** first. If they disappeared, the ritual dies; call it out before anything else.
3. **Fixed format**; rotate facilitator, not format. Mad/sad/glad, start/stop/continue, 4 Ls (liked / learned / lacked / longed for), sailboat — pick one and stick.
4. **Gather data silently first** (5–10 min) to prevent dominant voices setting the frame.
5. **Cluster and discuss.** 30–40 min.
6. **Decide** — pick 1–3 concrete action items. Each with owner + target date. Not "be more communicative"; "PR descriptions must name the customer impact, starting next sprint."
7. **Write the actions down** in a team-visible place, not private notes.
8. **60–90 minutes total.** Longer → theatre. Shorter → misses context.
9. Don't skip. Skipping once is forgivable; skipping twice in a row is a process emergency.
10. Quarterly process-level retro on the retro itself — is the format working?

**Outputs.**
- Retro notes + action items in a team-visible place.
- Updated roster for next facilitator.
- Follow-through on last retro's actions documented.

**Tools / templates.**
- Retro-hosting tool (Miro / Mural / EasyRetro / Parabol / Metro Retro) or a shared doc.
- A fixed template per format.
- Action-item tracker (same tool the team uses for work).

**Cadence / duration.** Every 2 weeks, 60–90 min.

**Exit gate.**
- Retro happened.
- Prime Directive read.
- Last actions reviewed.
- 1–3 new actions written with owners + dates.

**Pitfalls.**
- **Skipping when "too busy."** First sign of process decay.
- **Facilitator permanently the eng lead.** Same voice; stale.
- **No action items.** Therapy session, not process.
- **Actions vague.** Not measurable; next retro can't review.
- **Last retro's actions never reviewed.** Team loses trust in the ritual.
- **Blame framing.** Prime Directive exists to block this — enforce.
- **Format changes every retro.** Team re-learns ceremony instead of doing work.

---

## 14) Continuous Improvement (PDCA / Toyota Kata)

**Purpose.** Structure the *how* of improvement — turn retrospective ideas and process hypotheses into small, measured experiments — so the team improves by running rigorous cycles rather than arguing about tactics.

**RACI.** R, A: eng lead. R: team. C: PM, platform. I: leadership.

**Triggers.**
- Retrospective produces a hypothesis worth running.
- DORA trend regression (deploy frequency, lead time, change fail rate, time to restore).
- On-call health degrading.
- Cycle time regressing.
- Quarterly improvement kata re-set.

**Inputs.**
- Retrospective action items (process 13).
- DORA metrics (Phase 06 process 12).
- On-call / operational health (Phase 07 process 15).
- Cycle time data.
- eNPS or team-health pulse data.
- Shewhart / Deming's PDCA description.
- Mike Rother's Toyota Kata (Improvement + Coaching).

**Activities.**
1. **Set a target condition** (Improvement Kata). Not a wish ("be better at testing"); a condition ("PR merge → prod median < 30 minutes, by end of quarter").
2. **Grasp current condition** — measure baseline with data, not stories.
3. **Pick one improvement experiment**. Do not run four at once; you will not learn from any.
4. Run **PDCA**:
   - **Plan** — objective, expected result, smallest test.
   - **Do** — execute for a bounded period.
   - **Check / Study** — evaluate outcome vs. expectation (Deming preferred "Study" because "Check" invites pass/fail thinking; learning requires comparison).
   - **Act** — standardise what worked (write it down, add to onboarding); reset what didn't (new hypothesis, next cycle).
5. Use a **Coaching Kata** pair — one person coaches, another executes — to instil the discipline. Prevents the improvement loop from becoming a retro item that dies.
6. Track **DORA four keys + on-call health + cycle time + eNPS** as the outer loop. Sustained regression → Improvement Kata cycle targeting that axis.
7. Publish the target condition and current baseline in a team-visible place. Update weekly.
8. Celebrate standardised changes — "the cycle time experiment worked; new PR template now mandatory" — so the team sees the loop paying off.

**Outputs.**
- Written target condition.
- Running PDCA experiment.
- Check/Study outcome captured.
- Standardised change (if worked) or next-cycle hypothesis (if didn't).
- Outer-loop metrics dashboard.

**Tools / templates.**
- Target-condition board (physical or digital).
- A short PDCA log (one row per cycle).
- DORA metrics dashboard (Phase 06).
- On-call health metrics (Phase 07).

**Cadence / duration.** Continuous. One PDCA cycle = 1–4 weeks typical. Target condition re-set quarterly.

**Exit gate.**
- Target condition written.
- Baseline measured.
- One experiment running (not four).
- Outcome evaluated against expectation.
- Either standardised or reset with next hypothesis.

**Pitfalls.**
- **Vague target condition.** "Improve testing." No way to tell success.
- **Many experiments at once.** Learning confounded.
- **Retrospective ideas with no experiment structure.** Wish list.
- **Celebrate plans, not outcomes.** Back-pat without measurement.
- **Act without Check.** Standardise based on opinion; drift.
- **Improvement Kata used as annual theatre.** Only meaningful if continuous.

---

## 15) Quarterly Roadmap & OKR Evolution

**Purpose.** Keep the roadmap and OKRs honest — shaped by what the last quarter taught, not what the last quarter promised — so the team ships against current reality rather than out-of-date ambition.

**RACI.** R, A: PM. C: eng lead, designer, security, support. I: leadership, customers (through release notes).

**Triggers.**
- Quarter-end.
- Major strategy shift (market, competition, funding).
- Phase 07 error-budget freeze signal.
- Customer-theme surge from processes 1 and 2.

**Inputs.**
- Quarter's OKR progress (committed vs. aspirational).
- Now / Next / Later roadmap (Phase 02).
- Customer themes (process 2 monthly roll-ups).
- Quant trends (process 1).
- Tech-debt hotspot report (process 6).
- Phase 07 health of operations.
- Experiment outcomes (process 4 log).
- Deprecation backlog (process 11).

**Activities.**
1. **Honest OKR review.** For each Objective: hit, missed, partially met. Call it. No reframing misses as wins.
2. **Drop OKRs that didn't land** and weren't going to. Keep ones that still matter. Promote new ones from the quarter's signal.
3. **Committed vs. aspirational split** remains (Doerr, Phase 02): committed OKRs delivered ≥ 100%; aspirational 0.7+ is celebrated.
4. **Revisit the roadmap.**
   - Items move: Next → Now when capacity frees; Later → Next when time is close.
   - **Retire things that didn't work**, openly: "we tried X, it didn't move Y, we're stopping."
   - Incorporate customer themes: "We moved X up because customers A, B, C asked for it this month."
5. Be willing to **kill features** (route to process 11 for execution) rather than add alternatives.
6. Re-balance the 15–20% debt allocation if hotspots / incident themes say so.
7. Reconcile with Phase 07: SLO reality, error-budget status, cost trend → shapes what is feasible.
8. Update Phase 02 artifacts (OKR doc, roadmap) and publish.
9. Communicate the changes to the team, and the externally-visible parts to customers via release notes / roadmap page.
10. Share with leadership before broadcasting broadly; align on any funding / hiring implications.

**Outputs.**
- Updated OKRs.
- Updated Now / Next / Later roadmap.
- Retired items list (with explanation).
- Customer-comms update where relevant.
- Reconciled Phase 02 artifacts.

**Tools / templates.**
- OKR tool (Lattice / 15Five / Perdoo / plain doc).
- Roadmap tool (ProductBoard / Aha / Linear roadmap / Notion).
- Retirement log.
- Leadership briefing template.

**Cadence / duration.** Quarterly. 2–4 hours review + 1–2 hours updating artifacts + comms.

**Exit gate.**
- OKRs honestly scored.
- New OKRs set.
- Roadmap updated and published.
- Retired items documented.
- Team and leadership briefed.
- Customer-facing updates sent.

**Pitfalls.**
- **Reframing misses as wins.** Credibility erodes.
- **Keeping every OKR "just in case."** Dilutes focus; signals nothing is priority.
- **Adding features as response to customer asks without retiring alternatives.** Product bloat.
- **Not connecting Phase 07 signal to Phase 02 commitments.** Promising reliability that the budget says you cannot afford.
- **Quarterly roadmap that never changes.** You're not listening to signal.
- **No customer communication.** Roadmap changes exist; customers don't know.
- **Skipping the retirement step.** Features accumulate; maintenance compounds.

---

## Weekly / monthly / quarterly rhythm

Phase 08 is the slowest-clock phase in the handbook — but it has the largest set of overlapping rhythms. A representative "normal cycle":

| Cadence | Activity | Owners |
|---|---|---|
| Daily | Error tracker + production dashboards + support queue scan | On-call + PM + rotating VoC engineer |
| Weekly | Metrics review (30 min) | PM + eng lead |
| Weekly | ≥ 1 customer interview | PM |
| Weekly | Voice-of-customer digest (rotating engineer) | Rotating engineer |
| Weekly | Dependency-update review (minor PRs batched) | Service author / platform |
| Weekly | Bug triage | Rotating triage owner |
| Every 2 weeks | Retrospective (60–90 min) | Rotating facilitator |
| Monthly | Cohort analysis, NPS read, churn review | PM + data |
| Monthly | Hotspot analysis refresh | Eng lead |
| Monthly | Operations health review (from Phase 07 → informs Phase 08) | Platform + eng lead |
| Monthly | Support / sales / CS call attendance | PM |
| Quarterly | NPS survey run | PM |
| Quarterly | OKR + roadmap refresh (process 15) | PM + leadership |
| Quarterly | Hotspot report + deeper debt allocation review | Eng lead |
| Quarterly | Game day / DR drill / runbook sweep (Phase 07 processes) | Platform |
| Quarterly | Deprecation backlog review | PM |
| Continuous | CVE patching (SLA-driven) | Security + service author |
| Continuous | PDCA / Improvement Kata cycle (one at a time) | Eng lead + team |

Anti-patterns that mean the rhythm is broken:

- A week with zero customer interviews.
- Debt capacity going to zero.
- Open retrospective actions stale.
- CVE SLA misses accumulating.
- Roadmap unchanged for two quarters.
- Dashboard grows from 10 → 40 tiles without anything being retired.

---

## Scale notes

**Solo founder / 1 engineer.**
- Product analytics + 1 interview/week + 15% debt capacity + Dependabot auto-merging security patches + weekly 30-min metrics review.
- Skip formal A/B testing until traffic supports it.
- PDCA cycles informal; written target condition even so.
- NPS only when you have enough responders for the number to mean anything.

**Team of 5 (default).**
- Full rhythm above. Simple A/B via feature flags (GrowthBook / PostHog Experiments).
- Deprecation discipline — write the policy down even if short.
- Retrospective every 2 weeks; action items tracked.
- Tech-debt capacity measured in sprint points.
- Patching SLAs published.

**Team of 20–50.**
- Dedicated platform team owning dependencies across services.
- Written deprecation policy enforced at code review.
- Tech debt capacity tracked per sprint; hotspot dashboards live.
- Formal CVE watchlist with owner.
- Retrospective notes archived; improvement kata run by eng lead.
- A/B experiments run continuously with a platform; experiment log mandatory.
- Customer-advisory cohort for major changes.

**Team of 500+.**
- Full experimentation and personalization platform.
- Platform team owning dependencies at org level; per-language SLAs.
- Formal API deprecation lifecycle with customer-communication SLA.
- Separate security response team with published SLA + `security.txt`.
- Customer research org embedded in product.
- PDCA / Kata practiced in every team, coached by a continuous improvement function.
- Deprecation policy enforced by automated scanning; Sunset headers emitted by framework middleware everywhere.

The three invariants at every scale: **someone talks to customers weekly; debt capacity is allocated and spent; security patches land within SLA.**

---

## Handoff — back into the loop

Phase 08 does not hand off; it feeds. What it sends back into the rest of the lifecycle every quarter:

1. **Into Phase 01 (Discover):** updated opportunity tree, new customer pain themes, new hypothesis candidates, abandoned hypotheses.
2. **Into Phase 02 (Plan):** honest OKR scoring, updated roadmap, retired strategy items, revised capacity assumptions (debt + reliability + security + feature).
3. **Into Phase 03 (Design):** ADR prompts from hotspot and modernization work, new NFR targets from Phase 07 signals.
4. **Into Phase 04 (Build):** refactoring priorities, style updates from PDCA cycles, onboarding improvements.
5. **Into Phase 05 (Test):** flaky-test findings, security testing additions from CVE patterns, accessibility regressions.
6. **Into Phase 06 (Ship):** deprecation releases, versioning decisions, changelog discipline updates.
7. **Into Phase 07 (Run):** updated SLOs based on user expectations, new runbook items from incident themes, new alerts, retired alerts.

The lifecycle is a loop, and Phase 08 is what closes it. Miss any of these handoffs and Lehman's Second Law (Increasing Complexity) and Seventh Law (Declining Quality) come for you — not because the team is lazy, but because the feedback loops that keep the system fit fell silent.

Run the loops deliberately, or have them run you.
