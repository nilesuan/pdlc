# TEAM_SCALING.md — Team shape, roles, and scaling thresholds

**Authoritative sources:** [`../../../handbook/00-team-lean.md`](../../../handbook/00-team-lean.md); [`../../../handbook/00-team-full.md`](../../../handbook/00-team-full.md).

## What this standard is for

Defines the team shape a product engineering organization should adopt at each size band, the role split that goes with it, and the inflection points that trigger a transition from one shape to the next. Hire to solve a specific bottleneck; do not hire to spend headcount budget.

## Hard rules

1. **Three non-negotiable functions: Product, Design, Engineering.** Every product team — at any size — has a named accountable owner for each. Below that, the team is fragile.
2. **Lean baseline = 4 people.** 3 is a stretch that breaks the moment paying customers arrive; 2 is a pre-launch sprint, not a team.
3. **Every production system has ≥ 2 people who can touch it.** Bus factor of 1 on any critical path is a structural defect, not a staffing question.
4. **At least one senior engineer; ideally two so no one is single-threaded.** This is the qualifier from handbook Foundations §1.
5. **No phase has shared accountability at lean scale.** Each handbook phase has exactly one Responsible owner and at least one Contributor. Shared accountability means no accountability.
6. **At full scale, decisions are made at the squad level by default.** Leadership sets strategy and constraints; squads make tactical calls inside them.
7. **Scale the shape only when the bottleneck is real.** Specifically named failure modes (PRs sitting > 24h, on-call waking engineers > 1×/week, customer-interview rhythm collapsed) trigger the next hire — not headcount budget.

## Lean shape (2–20 people)

The lean configuration is a **four-seat team**. Each seat owns specific phases and wears multiple hats; below four the team cannot cover all eight handbook phases sustainably.

### The four seats

| Seat | Role | Primary phases | Notes |
|---|---|---|---|
| 1 | Founder / Product Lead | Discover, Plan, Evolve | Also: tier-1 customer support, first-ten-customers sales, copy, stakeholders. |
| 2 | Design Engineer | Design (UX), Build (frontend) | Single seat by design — designer-who-throws-Figma-over-the-wall is worse at this scale than one person who designs *and* implements. |
| 3 | Staff Engineer (platform-leaning) | Design (architecture), Ship, Run | Owns "does it work in production at 3 a.m.?" — ADRs, CI/CD, SLOs, on-call primary. |
| 4 | Senior Full-stack Engineer (product-leaning) | Build, Test | Counterweight to Seat 3's platform focus — measured on shipped customer-facing features and test-suite durability. |

### Why exactly four (not three, not five)

- **Three breaks on-call.** A single engineer covering incidents 24/7 burns out within a month. Code review has no peer. Bus factor is 1 on every critical system.
- **Five adds coordination overhead without commensurate value.** The marginal fifth person adds less than a specialist would later. Hire #5 when you know which specific bottleneck you are solving.

### Phase ownership at lean scale

Every phase has exactly one **R** (Responsible) and at least one **C** (Contributor). See handbook §3 for the full RACI matrix; key allocations:

- Discover, Plan, Evolve → R: Seat 1
- Design (UX), Build (frontend) → R: Seat 2
- Design (architecture), Ship, Run → R: Seat 3
- Build (backend), Test → R: Seat 3 / Seat 4 split

### Hat-switching rules (non-negotiable at lean scale)

These rules exist so the team can operate across all eight phases without the weakest-covered function silently rotting:

1. **Everyone does discovery.** All four seats sit in on customer interviews at least monthly.
2. **Engineers co-own Test and Run.** No QA. No SRE.
3. **Seat 1 reads logs and writes SQL.** They are first line of customer support; they cannot do that job if they cannot investigate.
4. **The PM does not code the product.** Founders may write scripts and prototypes, but feature code is Seats 2/3/4.
5. **On-call rotates 50/50 between Seat 3 and Seat 4.** Seat 1 handles tier-1 customer-facing alerts (status page, comms, triage).
6. **ADRs are written by the person proposing the change.** Not by Seat 3 every time.

## Inflection points and the lean → full transition

Each hire is triggered by a specific failure mode in the current team — not by "we have budget."

### Hire 5 — second product-leaning engineer (full-stack)

**Trigger signals (need ≥ 2):**
- On-call waking engineers > 1×/week for weeks in a row.
- PRs sitting unmerged > 24 hours because reviewers are unavailable.
- Shipping stalls during incidents because the people who can fix it are also the people who ship features.
- Seat 4 routinely > 50 hours/week.

**Effect.** On-call becomes 33/33/33. Review throughput doubles. Two engineers can pair on a hard feature while the third handles BAU.

**Anti-confusion:** This is *not* a frontend specialist. Seat 2 covers frontend.

### Hire 6 — dedicated designer **or** customer-facing generalist

Pick whichever bottleneck is worse:

- **Designer trigger:** Seat 2 is 100% on frontend with no time for research, design-system work, or net-new UX.
- **Customer-facing generalist trigger:** Seat 1 is > 40% on support and the weekly customer-interview rhythm has collapsed.

**Pre-PMF → hire the generalist (accelerates learning). Post-PMF → hire the designer (accelerates experience quality).**

### Hire 7 — whichever role you didn't pick at #6

### Hire 8 — Platform / SRE engineer

**Trigger signals:** SLO violations recurring quarterly; incident rate > 2/month with Seat 3 as IC every time; MTTR climbing; deploy freezes; cloud spend growth > product growth.

**Effect.** Frees Seat 3 for higher-leverage architectural moves. Makes the on-call rotation 3-wide in primary slots.

### Hire 9 — dedicated Product Manager

**Trigger signals:** Founder cannot cover roadmap + customer calls + stakeholder management + hiring + fundraising in one week. PM-shaped responsibilities are being dropped (interviews missed, OKRs stale, sprint planning ad-hoc).

### Size-band changes

| People | What changes |
|---|---|
| 6 | Async standup gets longer; consider 10-min daily video standup. Code-review assignments need rotation rules. |
| 8 | Weekly 30-min "engineering sync" for senior engineers. Real applicant tracking system — informal hiring breaks here. |
| 12 | Two squads emerge naturally (typically product + platform, or growth + core). First Head of Engineering hire (a manager, not just a senior IC). |
| 20 | At least 3 functional leaders: Head of Engineering, Head of Product, Head of Design. Formal compensation bands and a promotion process. The team is a *company*, not a startup. |

## Full shape (30–200+ people)

Past ~20 people, three things break in sequence: coordination starts dominating execution, specialization starts paying off, and one team cannot hold the surface area. The full shape addresses all three.

### Organizing principle: the four-team-type model

The default structure for product engineering at scale is the **four-team-type model from Team Topologies (Skelton & Pais, 2019)**, the only team-shape model the handbook adopts as authoritative:

1. **Stream-aligned teams** (the majority) — own a slice of the product end-to-end (e.g., Billing, Onboarding, Search). Cross-functional: PM + designer + 4–7 engineers.
2. **Platform teams** — own internal products used by stream-aligned teams (CI/CD, auth, observability, internal developer portal). Their customer is other engineers.
3. **Enabling teams** — short-lived; help stream-aligned teams adopt a capability, then disband.
4. **Complicated-subsystem teams** — own a slice requiring deep specialist knowledge (real-time video, payment-gateway, ML inference). Rare.

**Most of the org is stream-aligned.** Platform + enabling + complicated-subsystem combined are typically 20–30% of engineering headcount. **If platform > stream-aligned, the org is inverted — something has gone wrong.**

### Squad template (stream-aligned)

A typical stream-aligned squad at full-team scale:

- 1 Product Manager
- 1 Product Designer
- 0–1 UX Researcher (often shared across 2–3 squads)
- 1 Engineering Manager (may lead 2 squads in smaller configurations)
- 1 Tech Lead / Staff Engineer
- 3–5 Engineers (senior, mid, junior mix)
- 0–1 Embedded SRE (at larger scale or for infra-heavy squads)
- 0–1 Embedded Data / Analytics Engineer (for data-heavy squads)
- 0–1 Content Designer (for text-heavy surfaces)

**Total:** 7–11 people. Squads smaller than 4 engineers waste coordination overhead; squads above 9–10 lose cohesion and should split.

### Specialist functions that emerge at full scale

| Function | First hire | Sizing at full scale |
|---|---|---|
| Platform engineering | ~25–40 engineers | ~10–20% of engineering |
| SRE | ~25–40 engineers | ~5–10% of engineering |
| Security engineering | ~30–50 engineers | ~3–5% of engineering (higher if regulated) |
| Data engineering | ~25–50 engineers (or earlier if data is product-critical) | Scales with data/ML surface |
| Technical writing | ~30–50 engineers | ~1 TW per 20–30 engineers for products with meaningful docs surfaces |
| Product Operations | ~50–75 in product org | Small team of 2–4 past 100 |
| TPM | When cross-squad coordination dominates | 1 per 30–50 engineers |

### Reporting lines

- **Engineers report into engineering**, not into product. Dotted line to PM; solid line to EM.
- **Designers report into design**, not into product or engineering. Dotted line to PM; solid line to Design Manager. Design careers depend on design leadership.
- **Platform, SRE, security, and data each have their own management lines.** Specialists need specialist leaders for career growth, and separate lines resist the "platform is a dumping ground" failure mode.
- **TPMs report into Engineering Operations** (or equivalent), not into any single squad, so they can broker between squads neutrally.

### Ratio rules of thumb (full scale)

| Ratio | Typical value |
|---|---|
| Engineers : PM | 5–7 : 1 |
| Engineers : Designer | 5–8 : 1 |
| Engineers : UX Researcher | 20–40 : 1 |
| Engineers : Technical Writer | 20–30 : 1 |
| Stream-aligned : Platform engineers | 5–8 : 1 |
| Stream-aligned : SRE | 10–20 : 1 |
| Engineers : Engineering Manager | 5–8 : 1 |
| EMs : Director | 3–5 : 1 |
| TPMs : engineers | 1 : 30–50 |

**Context modifiers:** consumer products weight design and research heavier; enterprise weights solutions/implementation engineering; regulated industries weight security, compliance, QA; developer tools weight DevRel and docs; ML-heavy products weight data and ML engineering.

### Dual ladders are mandatory

IC track (Engineer → Senior → Staff → Principal → Distinguished) and Manager track (EM → Senior EM → Director → VP) must be **equivalent in scope, comp, and prestige at every level**. Without this, you lose senior ICs to management roles they don't want, and they leave for elsewhere.

Staff-plus IC levels must have real scope. If Staff is a comp title with no cross-squad initiative, the ladder is broken.

## Anti-patterns

### At lean scale

- **Hiring a polyglot generalist with no real depth in either backend or frontend.** Seat 2 must code frontend; Seats 3/4 must code backend. A generalist who does a bit of each leaves four parts of a stack nobody owns.
- **Hiring a "VP of Engineering" before 8 people.** A VP without a team to manage becomes a meetings-generator.
- **Hiring a dedicated QA engineer at < 10 people.** Tests are written by the engineers who wrote the code. A QA function at lean scale removes that responsibility and produces a flaky E2E suite.
- **Hiring a dedicated DevOps engineer at < 10 people.** Seat 3 covers this. A dedicated DevOps hire either becomes Seat 3 (in which case you should have hired them as Seat 3) or becomes a silo.
- **Hiring a Chief of Staff or Founder's Associate before hiring a PM.** The founder's highest-leverage task is discovery; delegating discovery to a junior role is delegating the most important thing.
- **Splitting "product" from "design" at 4 people.** A dedicated designer + a dedicated PM + 2 engineers is a worse shape than the four seats — the designer has nobody to pair-code with.
- **No on-call rotation "because we haven't had an incident yet."** You will have one on the day you can least afford it.
- **No writing culture.** "We're small, we can just talk." Then you hire #5 and they have no context.

### At full scale

- **Matrix management.** Dotted-line reports to two managers produce unclear priorities.
- **Platform as a dumping ground.** Platform is for paved paths, not for whatever stream-aligned teams don't want to own. Platform teams need PMs and roadmaps.
- **SRE as ops-only.** A pure ops-SRE team becomes the people blamed for outages, not the people preventing them. SRE at scale is an embedded discipline.
- **Security as a gate.** One-way review bottlenecks cause teams to route around security. Shift-left.
- **Senior IC ladder missing or underused.** If the only way up is management, you lose senior ICs.
- **Design as a service function.** If designers are "receiving briefs" from PMs, design is broken.
- **PMs as ticket-writers.** If PMs write acceptance criteria instead of running discovery and owning outcomes, they are misused.
- **Over-specializing too fast.** Not every 50-person org needs a dedicated ML engineer, DevRel team, or security director. Specialize when specific work demands it.
- **Squad bloat.** Squads over 9–10 people lose cohesion. Split before they break.
- **"Reorg first, then figure out why."** Reorganization is expensive. Change structure only when the current structure is demonstrably broken — not to signal change or appease stakeholders.
- **Hiring for titles instead of scope.** A "Director" with 2 reports and unclear scope is worse than a Staff Engineer.
- **Treating platform / SRE / security as cost centers.** They are force multipliers — measure them on stream-aligned velocity unblocked, not tickets closed.

### Lean → full transition mistakes

- **Scaling PM, design, and engineering out of sync.** Hire 5 engineers without a designer → squads ship ugly. Hire a designer without a PM partner → design drifts from product strategy.
- **Hiring specialists before there is work for them.** A dedicated Head of Security at 15 people will not have enough to do.
- **Skipping the EM layer.** Flat orgs work at 15; break at 30. Senior ICs cannot also do people management at scale.
- **Deferring platform investment.** The later you start, the more paved-path work has piled up as ad-hoc; migrations are expensive.
- **Promoting Seat 1 (founder) straight to CEO without hiring a CPO.** The founder loses product depth; the org loses strategic product leadership.
- **Over-rotating into management too fast.** Not every senior engineer wants to manage. Provide a Staff / Principal IC ladder with equivalent scope and compensation.

## Red flags (signs the team is broken)

### Lean scale

- The same person is always in incidents (single-point-of-failure on ops).
- Sprint always slips — over-commitment, ignored estimates, or a silent block.
- Customer-interview rhythm has collapsed; roadmap drifting toward stakeholder voice.
- PRs sit unreviewed > 1 day, routinely.
- Postmortems aren't producing action items.
- "We don't have time for tests / docs / ADRs."
- Seat 1 is coding features instead of doing discovery.
- Anyone working > 50 hours/week as a steady state.
- Hiring stalled > 8 weeks (wrong ladder or broken funnel).

### Full scale

- Decision latency > 2 weeks on routine calls (unclear decision rights).
- Cross-squad dependencies dominate sprint planning (squad boundaries are wrong).
- Platform headcount > stream-aligned headcount (inverted org).
- Postmortems producing no action items.
- OKR attainment > 90% or < 30% across many squads (OKRs not set well).
- Attrition concentrated in one function.
- Hiring pipeline stalled > 8 weeks for senior roles.
- Security / compliance only hears about work after it ships (shift-left has failed).
- Senior ICs leaving to take management roles elsewhere (IC ladder is broken).

## Sources

- Handbook: [`../../../handbook/00-team-lean.md`](../../../handbook/00-team-lean.md) — lean (2–20 person) team shape, four-seat model, hiring ladder.
- Handbook: [`../../../handbook/00-team-full.md`](../../../handbook/00-team-full.md) — full (30–200+ person) team shape, four-team-type model, role expansion.
- Team Topologies (Skelton & Pais, 2019) — stream-aligned + platform + enabling + complicated-subsystem model. Cited by handbook full-team chapter §2 and §19; underlying research notes at [`../../../research/07-operations/sre.md`](../../../research/07-operations/sre.md) and [`../../../research/07-operations/README.md`](../../../research/07-operations/README.md).
- Related standard: [`../operations/ON_CALL.md`](../operations/ON_CALL.md) — rotation sizing rationale.
