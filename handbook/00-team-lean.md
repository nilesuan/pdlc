# The Lean Product Team

**Goal:** Assemble the smallest team that can credibly run all eight phases of the handbook — from discovery to evolution — without any single function going uncovered and without anyone being single-threaded on a critical path.

**Size:** 4 people is the recommended lean baseline. 3 is a stretch that breaks the moment paying customers arrive. 2 is a pre-launch sprint, not a team.

**Applies when:** You are building a modern web-based software product (SaaS, web app, API-first) in a team of 2–20 people. Scale notes at the end cover 6 → 20. For a fully-staffed product organization (30–200+), see [`00-team-full.md`](00-team-full.md).

**Done well means:** Every phase of the handbook has a named accountable owner. Every piece of production infrastructure has at least two people who can touch it. No one is working > 50 hours/week as a sustained pattern. Customers get a response within one business day on every channel.

---

## 1. Why this team shape

The handbook's [`README.md`](README.md) Foundations section names three non-negotiable functions — **Product, Design, Engineering** — and adds the rule of thumb: "at minimum one senior engineer; ideally two so no one is single-threaded." This chapter turns that baseline into a concrete four-seat team, with each seat's hats, cadence, time allocation, and hiring ladder fleshed out.

Why four and not three:

- **On-call is brutal with one engineer.** A single engineer covering incidents 24/7 breaks within a month. Every vacation becomes a crisis. Every illness is an incident.
- **Code review has no partner with one engineer.** Handbook Phase 04 requires peer review for every non-trivial change. A solo engineer cannot review their own work.
- **The bus factor is 1 on every critical system.** If that engineer leaves, the product is undeployable.

Why four and not five:

- **Five people need more coordination overhead.** Standups become meetings. Decisions slow down.
- **The marginal person adds less than a specialist would later.** You'd rather hire your fifth when you know what specific bottleneck you're solving (more code reviewers? dedicated designer? support generalist?) than add a generic engineer now.

The four-seat team is the point where you can cover all handbook phases, run a sustainable on-call rotation, have peer code review, and still move fast. Below four is fragile. Above four needs a reason.

---

## 2. The four seats

Each seat is described in the same shape: **role**, **phase ownership** (primary, secondary), **daily/weekly cadence**, **skills profile** (required, not required), **anti-patterns**, **weekly time allocation**, and **what "done well" looks like**.

---

### Seat 1 — Founder / Product Lead

**Role.** One person accountable for discovery, planning, and commercial outcomes. They answer the question: "Are we building the right thing for the right people for a sustainable reason?"

**Primary phase ownership.**
- [**Phase 01 Discover**](01-discover.md). Runs the weekly customer-interview rhythm (Torres's continuous-discovery habit). Maintains the Opportunity Solution Tree. Drafts problem statements.
- [**Phase 02 Plan**](02-plan.md). Owns the roadmap (Now/Next/Later). Runs RICE prioritization. Writes and reviews OKRs. Leads sprint planning.
- [**Phase 08 Evolve**](08-evolve.md). Synthesizes feedback signal across channels (interviews, NPS, support tickets, usage analytics). Decides what to double down on, what to deprecate.

**Secondary hats.**
- **Customer support, tier-1.** Reads every inbound support message. Replies personally to the first few thousand customers. This is the fastest feedback loop the team has — do not outsource it until the founder is > 40% on support.
- **First-ten-customers sales.** Gets on calls, closes deals, negotiates pricing. Hands off to a sales specialist only when the motion is repeatable.
- **Marketing copy and landing pages.** Writes the first draft of launch posts, docs intros, changelog entries, pricing page copy. Design Engineer lays them out.
- **Stakeholder management.** Investors, advisors, major partners, press. One person, one voice.
- **Light UX work.** Rough wireframes, flow sketches, user journey drafts. These feed into the Design Engineer's polished artifacts.
- **Analytics & funnel review.** Pulls activation, retention, and funnel data weekly. Writes the weekly metrics note.
- **Hiring funnel.** Sources talent, does first-round screens, owns the interview loop.

**Skills profile required.**
- **Customer-listening skill at a high level.** Torres-style story-based interviews, resisting leading questions, synthesizing patterns from small samples. Reads research/01-ideation/discovery.md §1 without rolling eyes.
- **Product sense.** Jobs-to-be-Done thinking. Comfortable saying no to a feature that has stakeholders excited. Comfortable saying yes to a small, ugly thing that ships Friday.
- **Commercial sense.** Can talk pricing, channel, payback period, unit economics without a spreadsheet in front of them. Understands why retention matters more than acquisition at early scale.
- **Writing.** Problem statements, product specs, ADRs as reviewer, launch announcements, investor updates. Everything the team does is downstream of written clarity.
- **Numeracy.** Comfortable with SQL for product analytics, funnel math, spreadsheet modeling. They don't need to be a data scientist but they cannot be scared of a query.

**Skills NOT required.**
- **Coding.** Nice-to-have, not required. If the founder codes, they should resist using that skill for the product — their lever is customer truth and strategic clarity, not pull requests. At lean scale, an extra engineer is cheaper than a distracted founder.
- **Visual design.** Seat 2 covers this.
- **Deep technical architecture.** Seat 3 covers this. The founder should understand architecture at a level where they can ask "why is this taking three weeks?" and interpret the answer.

**Anti-patterns to avoid.**
- Treats product as a backlog of loudest-voice stakeholder requests rather than a model of validated customer jobs.
- Skips customer interviews when sprint planning gets busy. Discovery is the first thing to get cut and the first thing that should never be cut.
- Writes specs without ever being on-call for customer support. Distance from customers rots product sense.
- Becomes an "ideas person" who offloads execution. The best small-team PMs ship themselves — draft specs, land docs, close deals.

**Weekly cadence.**
- **Daily:** 1–2 customer/user conversations (call, interview, or Slack/Intercom thread), async standup post, inbound support triage, product analytics check.
- **Weekly:** ≥ 5 customer-touch conversations (per handbook Phase 01 rhythm), roadmap update, sprint check-in, weekly metrics note, stakeholder update.
- **Bi-weekly:** Sprint planning, retrospective, design review pairing with Seat 2.
- **Monthly:** OKR check-in, top-line funnel & retention review, pricing/packaging review, hiring funnel review.
- **Quarterly:** OKR setting, strategic review, board/investor update, one full week of concentrated customer interviews.

**Weekly time allocation (approximate, 40-hour baseline).**

| Activity | Hours |
|---|---|
| Customer discovery (interviews, synthesis, OST updates) | 12 |
| Writing (specs, posts, updates) | 8 |
| Customer support | 6 |
| Planning & prioritization | 6 |
| Stakeholder & sales calls | 4 |
| Hiring, admin, reviews | 4 |
| **Total** | **40** |

**What "done well" looks like.**
- Every engineer can cite which customer said which thing that made this feature P0.
- The roadmap has a Now / Next / Later shape that survives contact with a surprise — because priorities are principle-driven, not feature-driven.
- No inbound customer message sits unanswered for > 4 business hours during launch weeks.
- The founder could take two weeks off and the team would ship without them — but they'd come back to a backlog of customer signal to process.

---

### Seat 2 — Design Engineer

**Role.** Owns the end-user experience end-to-end: research input, UX design, design system, and the shipped frontend code. This is a single seat, not two collaborating seats, because at this scale the designer-who-throws-Figma-over-the-wall is worse than one person who designs *and* implements.

**Primary phase ownership.**
- [**Phase 03 Design (UX)**](03-design.md). Flows, wireframes, component-level specs, design system, accessibility (WCAG 2.2 AA).
- [**Phase 04 Build (frontend)**](04-build.md). Ships the actual React/Vue/Svelte/etc. components, pages, and interactions. Owns design-system drift.

**Secondary hats.**
- **User research facilitation.** Moderates usability tests (Nielsen's 5-user rule per handbook Phase 01). Synthesizes findings with the Founder.
- **Design-system owner.** Component library, tokens (color, spacing, typography), dark mode, motion primitives.
- **Accessibility owner.** WCAG 2.2 AA compliance for shipped work. Screen-reader testing. Keyboard navigation. Color-contrast audits.
- **Marketing site & landing pages.** From hero to pricing to docs index.
- **Onboarding flow owner.** The most leverage-heavy surface in the product; Seat 2 iterates on it with activation metrics feedback from Seat 1.
- **Launch visuals.** Announcement graphics, demo videos, release-note screenshots.
- **Copy review.** Partners with the Founder on tone and voice.

**Skills profile required.**
- **Figma fluency + frontend code.** Can go from blank Figma file to shipped production component in a day.
- **Modern frontend stack.** React or equivalent framework, TypeScript, a CSS approach (Tailwind / CSS modules / CSS-in-JS — pick one and be fluent).
- **Design-system mindset.** Builds components to be reused, not one-off. Fights the "just this one exception" pull.
- **Typography, spacing, color discipline.** The product feels designed, not templated.
- **UX research literacy.** Can run, facilitate, and synthesize a usability test. Knows the 5-user rule and why "three studies of five users" beats "one study of fifteen."
- **Accessibility fundamentals.** WCAG 2.2 AA, ARIA roles, focus management, keyboard nav.

**Skills NOT required.**
- **Backend / infrastructure.** Seat 3 covers this. Design Engineer should know enough to call APIs and debug network issues, not to provision infra.
- **Data engineering.** Not this seat.
- **Brand identity design.** A freelance brand designer does logo / wordmark / initial brand system at launch. Seat 2 maintains and extends it.

**Anti-patterns to avoid.**
- Designs in isolation, ships Figma, expects the "frontend engineer" to implement. At lean scale there is no frontend engineer — Seat 2 *is* the frontend engineer.
- Writes frontend code without caring whether the experience is usable. The whole point of fusing design and frontend in one seat is that these aren't separate concerns.
- Treats accessibility as "a later concern." Retrofitting WCAG is ~5x the cost of building to it.
- Perfects the design system while Phase 04 feature work slips. The system exists to accelerate features, not replace them.

**Weekly cadence.**
- **Daily:** Frontend feature PRs, design exploration time, short design-review syncs with Seat 1 or Seat 4.
- **Weekly:** 1 usability test or user-research session (alternating weeks okay), design-system pass, accessibility audit of new work.
- **Bi-weekly:** Sprint planning, demo, retro. Pairs with Senior Full-stack (Seat 4) on cross-cutting features.
- **Monthly:** Design-system cleanup day. Onboarding-flow metrics review with Seat 1.

**Weekly time allocation (approximate, 40-hour baseline).**

| Activity | Hours |
|---|---|
| Frontend coding (feature delivery) | 16 |
| Design work (Figma, flows, prototypes) | 10 |
| User research (moderating tests, synthesis) | 5 |
| Design system maintenance | 3 |
| Code/design reviews | 4 |
| Other (marketing assets, misc) | 2 |
| **Total** | **40** |

**What "done well" looks like.**
- The product looks designed, not templated — and it looks the same across every surface.
- Accessibility is a default, not a retrofit.
- No "design debt backlog" grows uncontrolled — Seat 2 does small maintenance passes continuously.
- User research insights land directly in shipped work within 1–2 sprints.

---

### Seat 3 — Staff Engineer (platform-leaning)

**Role.** The senior engineer accountable for "does it work in production at 3 a.m.?" — and for the architectural decisions today that let the team ship without stalling six months from now.

**Primary phase ownership.**
- [**Phase 03 Design (architecture)**](03-design.md). Architecture Decision Records. System boundaries. Data model. API design. Tech-stack picks.
- [**Phase 06 Ship**](06-ship.md). CI/CD pipeline. Deployment strategy (rolling / blue-green / canary — handbook picks the default). Release tooling. DORA metric instrumentation.
- [**Phase 07 Run**](07-run.md). SLOs. Observability (OpenTelemetry-based per handbook Phase 07). On-call rotation tooling. Incident commander on SEV1/SEV2.

**Secondary hats.**
- **Incident commander.** Runs SEV1/SEV2 incidents. Writes the postmortem.
- **Security baseline.** OWASP Top 10 hygiene. Dependency scanning. Secrets management. Auth/authz reviews. Partners with external security audit when one is needed.
- **Infra cost ownership.** The person who sees the cloud bill. Light FinOps — right-sizing, reserved capacity decisions, alarming on cost spikes.
- **Developer experience.** Local dev setup. Build/test speed. The scripts and the README that let a new hire ship code on day two.
- **On-call tooling.** Alerts, runbooks, paging policy, escalation rules.
- **Vendor & SaaS evaluation.** Cloud provider, monitoring stack, auth, email, queues. Writes the decision, holds the vendor relationship.
- **Dependency management** (co-owned with Seat 4). Handbook Phase 08 security-patching SLA.

**Skills profile required.**
- **Deep backend.** One language they can write in their sleep, plus the ecosystem's testing and packaging conventions.
- **Systems fundamentals.** Databases (Postgres at minimum), queues, caching, networking, HTTP semantics.
- **Cloud infrastructure.** AWS or GCP primitives, infrastructure-as-code (Terraform / Pulumi / CDK), container orchestration at the level they'll actually use (most lean teams: ECS, Cloud Run, or a managed container platform — not a self-hosted Kubernetes cluster).
- **CI/CD.** GitHub Actions or equivalent. Can build a pipeline from scratch and optimize it.
- **Observability.** Metrics, traces, logs. Prefers OpenTelemetry vendor-neutral setup (handbook Phase 07).
- **Incident response.** Has actually been on-call. Has actually written a postmortem. Knows what "blameless" means in practice.
- **Database migration discipline.** Expand/contract pattern (handbook Phase 06). Zero-downtime deploys. Online index builds.
- **Security fundamentals.** OWASP Top 10, secrets hygiene, auth flows, CSRF/CORS/XSS basics.

**Skills NOT required.**
- **Frontend framework deep expertise.** Seat 2 covers this. Seat 3 should be able to read React and debug a Safari bug, not architect the design system.
- **Heavy data engineering / ML.** Not this seat.
- **Mobile-native expertise.** Unless the product is mobile-first, in which case the seat shape changes.

**Anti-patterns to avoid.**
- **Gold-plates architecture.** Microservices on day one. Kafka when Postgres would work. Kubernetes when Cloud Run would work. Handbook Phase 03 default: modular monolith + Postgres + Redis. Upgrade when pain is real, not hypothetical.
- **Refuses to ship until "it's right."** Perfect is the enemy of learning. Ship small, reversible, observable.
- **Owns too much, becomes the bottleneck.** Every ADR waiting for Seat 3 is a week lost. Delegates review authority where possible.
- **Skips ADRs because "the team knows what we decided."** The team knows now; the hire in six months will not. Write it down.
- **Builds the platform for scale they don't have.** A 100-user product does not need a multi-region active-active architecture.

**Weekly cadence.**
- **Daily:** Feature/infra code, code review (partners with Seat 4 on backend, Seat 2 on cross-stack work), incident triage.
- **Weekly:** On-call handoff, SLO review, CI/CD health check, dependency/security-patch review (Phase 08 weekly rhythm).
- **Monthly:** Security review. Infra cost review. Capacity planning look-ahead. Architecture health check.
- **Quarterly:** ADR backlog scrub. Dependency major-version audit. Cloud-spend review. Tech-debt prioritization pass.

**Weekly time allocation (approximate, 40-hour baseline).**

| Activity | Hours |
|---|---|
| Feature / backend code | 16 |
| Infra, CI/CD, ops work | 8 |
| Code review | 4 |
| Architecture, ADRs, design docs | 3 |
| On-call & incidents (budget — varies) | 5 |
| Security, vendors, DX | 4 |
| **Total** | **40** |

**What "done well" looks like.**
- DORA metrics (handbook Phase 06) land in the Elite or High tier: deploys daily+, lead time < 1 day, change-fail rate < 15%, MTTR < 1 hour.
- SLOs are set, instrumented, and mostly met. When violated, someone knows quickly and responds.
- Postmortems are written, circulated, and result in ≥ 1 actionable change within a sprint.
- The cloud bill is not a mystery. Every line item is understood.
- A new engineer can ship to production on day 2 or 3.

---

### Seat 4 — Senior Full-stack Engineer (product-leaning)

**Role.** The senior engineer who ships product features alongside Seat 2 (the frontend half) and Seat 3 (the backend/platform half). Counterweight to Seat 3's platform focus — Seat 4 is measured on shipped customer-facing features and on the durability of the test suite behind them.

**Primary phase ownership.**
- [**Phase 04 Build**](04-build.md). Feature delivery across the stack. Pull-request cadence, not ticket cadence.
- [**Phase 05 Test**](05-test.md). Test-pyramid discipline. Test-authoring practices. The test suite is not a pile of scripts — it is a first-class engineering artifact.

**Secondary hats.**
- **Code review partner.** Reviews both Seat 2 (frontend-leaning) and Seat 3 (backend/infra-leaning) work. This is the other half of the "bus factor ≥ 2" commitment.
- **Database / migration co-owner.** Writes the migrations that Seat 3 reviews. Expand/contract fluent (handbook Phase 06).
- **Second on-call.** 50/50 rotation with Seat 3.
- **Feature-flag hygiene** (handbook Phase 05 + 06). Cleans up flags after rollouts. Does not let the flag count grow unbounded.
- **QA-minded thinker.** No dedicated QA at this scale. Seat 4 holds the standard — tests, dogfooding, exploratory testing before release.
- **Backend-feature architecture at the module level.** The tactical design docs inside the strategic architecture Seat 3 owns.

**Skills profile required.**
- **Full-stack.** Competent in the same backend language as Seat 3, plus enough frontend (React/Vue/Svelte) to pair-program with Seat 2 on cross-stack features.
- **Testing practice.** Unit, integration, end-to-end. Fluent in the team's test framework(s). Understands the pyramid (handbook Phase 05).
- **DB schema design and SQL.** Can design a schema from scratch. Can write a query that's actually indexed.
- **API design.** REST or GraphQL fluent. Understands versioning, deprecation (Phase 08 RFC 8594), contract testing.
- **Pragmatism.** Ships over polishes. Knows when to reach for a quick fix and when to do it right.

**Skills NOT required.**
- **Deep infra / SRE skills.** Seat 3 covers this.
- **Deep visual design chops.** Seat 2 covers this.
- **Product strategy.** Seat 1 covers this.

**Anti-patterns to avoid.**
- Avoids tests, ships features without coverage. The whole reason Seat 5 is not "QA engineer" is that Seat 4 owns test discipline.
- Drifts into "frontend-only" or "backend-only" — defeats the full-stack rationale at this size and creates a silo Seat 2 or Seat 3 can't easily cover.
- Pushes every ops-adjacent thing to Seat 3. Seat 4 should be able to run their code in production, read their own logs, handle their own on-call shift.
- Treats code review as gatekeeping rather than collaboration. Reviews are the highest-leverage teaching moment at lean scale.

**Weekly cadence.**
- **Daily:** Feature code, test authoring, code review.
- **Weekly:** Sprint rhythm (planning, demo, retro on 2-week cadence). On-call handoff. Flag-cleanup sweep.
- **Monthly:** Test-suite health check (slow tests, flaky tests, coverage of critical paths). Database-performance review.

**Weekly time allocation (approximate, 40-hour baseline).**

| Activity | Hours |
|---|---|
| Feature code (frontend + backend) | 22 |
| Writing & maintaining tests | 6 |
| Code review | 4 |
| On-call & incidents (budget — varies) | 4 |
| Planning, retros, reviews | 4 |
| **Total** | **40** |

**What "done well" looks like.**
- Features land behind flags, with tests, on trunk, multiple times per week.
- The test suite stays fast (< 10 min for the full build) and trustworthy (< 1% flake rate).
- Code review turnaround is measured in hours, not days.
- When Seat 3 is on vacation, Seat 4 runs incidents without escalation drama.

---

## 3. Phase ownership matrix

The four seats map to all eight handbook phases as follows. "**R**" = Responsible (owns it), "**C**" = Contributes substantively, "**I**" = Informed / reviews.

| Phase | Founder / PM (1) | Design Eng (2) | Staff Eng (3) | Senior FS Eng (4) |
|---|---|---|---|---|
| [01 Discover](01-discover.md) | **R** | C (usability & research) | C (feasibility spikes) | C (feasibility spikes) |
| [02 Plan](02-plan.md) | **R** | C (design effort sizing) | C (tech effort sizing) | C (tech effort sizing) |
| [03 Design — UX](03-design.md) | C (flows, problem framing) | **R** | I | I |
| [03 Design — architecture](03-design.md) | I | I | **R** | C (module design) |
| [04 Build — frontend](04-build.md) | I | **R** | I | C |
| [04 Build — backend](04-build.md) | I | I | **R / C** | **R / C** |
| [05 Test](05-test.md) | I | C (frontend tests) | C (test infra) | **R** |
| [06 Ship](06-ship.md) | I | C (release comms) | **R** | C |
| [07 Run](07-run.md) | I (customer-facing status) | I | **R** | C (second on-call) |
| [08 Evolve](08-evolve.md) | **R** (product signal) | C (UX debt) | C (tech debt, deprecation) | C (tech debt, deprecation) |

Two things to notice:

1. **Every phase has exactly one R.** No shared accountability. Shared accountability means no accountability at lean scale.
2. **Every R has at least one C.** No single point of failure on any phase.

---

## 4. How the team operates

### 4.1 Daily cadence

- **Async standup** (written, e.g., in a Slack channel) — not a meeting. Format: "Yesterday / Today / Blockers." Takes 2 minutes to write, 1 minute to read. No video call required.
- **No recurring daily meetings** unless actively debugging an incident. Defend deep work time aggressively.
- **Customer-support triage** by Seat 1 (primary) and whoever is not in deep feature work (secondary). Target: first response < 4 business hours.

### 4.2 Weekly cadence

- **Monday** — weekly planning sync (30 min). What's the one thing each person is shipping this week? Any cross-cutting dependencies?
- **Wednesday** — mid-week customer-signal review (Seat 1 leads, 20 min). What did customers say? Does it change anything?
- **Friday** — demo + metrics review (45 min). What shipped? What moved? What didn't?
- **On-call handoff** at end of Friday (Seats 3 and 4). Written handoff, not verbal.

### 4.3 Sprint cadence (bi-weekly)

Follows handbook [Phase 02](02-plan.md):
- **Sprint planning** — 60–90 min at start of sprint. Seat 1 presents the shortlist; engineers estimate, pick scope.
- **Sprint demo** — 30 min at end of sprint. What we learned, not just what we built.
- **Retro** — 45 min after demo. Keep / drop / try format. Seat 1 facilitates.

### 4.4 Monthly cadence

- **OKR check-in** (90 min, whole team). Status per key result. Honest red/yellow/green.
- **Architecture health check** (Seats 3 + 4, 60 min). ADR backlog review. Debt prioritization.
- **Metrics deep-dive** (Seat 1, async note + 30 min discussion). Activation, retention, NPS/CES, DORA trend.
- **Security patch review** (Seats 3 + 4, 30 min). Handbook Phase 08 SLA review.

### 4.5 Quarterly cadence

- **OKR setting** (whole team, full afternoon). Derived from the annual strategy.
- **Customer-interview intensive** (Seat 1 does 15–20 interviews in one week). Refreshes the OST.
- **Stack / vendor review** (Seat 3). Anything to deprecate? Anything to evaluate?
- **Hiring plan review.** Is the ladder (section 8) still accurate?

### 4.6 On-call rotation

- **Primary / secondary model.** Seat 3 and Seat 4 alternate weeks as primary. The other is secondary (escalation, sanity check).
- **Seat 1 as "customer-facing incident lead."** For SEV1s that affect customers, Seat 1 owns the status page, customer comms, and stakeholder updates — freeing the on-call engineer to actually fix the thing.
- **Handoff discipline.** Written handoff at end of every shift: open alerts, recent incidents, anything brittle to watch.
- **Compensation.** On-call is paid or time-off-in-lieu. If it's "just part of the job," people burn out and leave.

---

## 5. Hat-switching rules (non-negotiable at lean scale)

These rules exist so that the team can actually operate across all eight phases without the weakest-covered function silently rotting.

1. **Everyone does discovery.** All four seats sit in on customer interviews at least monthly. Seat 1 runs them; engineers listen more than talk. Why: the hardest failure mode at lean scale is engineers building what stakeholders request instead of what customers need.
2. **Engineers co-own Phase 05 Test and Phase 07 Run.** No QA person. No SRE. Seats 3 and 4 split the responsibility.
3. **Seat 1 reads logs and writes SQL.** Not as a hobby — as a job. They are the first line of customer support; they cannot do that job if they can't investigate.
4. **The PM does not code the product.** They may write scripts, pull data, build prototypes — but feature code is Seat 2, 3, 4. If the founder codes features, either the team is wrong or the founder is procrastinating on discovery.
5. **On-call rotates 50/50 between Seat 3 and Seat 4.** If Seat 1 can handle tier-1 alerts (status page, customer comms, initial triage), the rotation becomes 33/33/33 and nobody burns out.
6. **Design reviews are a peer conversation, not a sign-off.** Seat 2 presents; Seats 1, 3, 4 react. Seat 2 decides.
7. **Architecture Decision Records are written by the person proposing the change.** Not by Seat 3 every time. Seat 3 reviews; whoever owns the decision authors it.
8. **Every production system has ≥ 2 people who can touch it.** Seat 3 runs the rotation, but Seat 4 has deployed prod at least once. Seat 2 has shipped a frontend hotfix. Seat 1 has run the customer-comms play during an incident.

---

## 6. Decision rights

At lean scale, most decisions should be made by the accountable person in minutes, not consensus-driven by the team over days. This table codifies that:

| Decision class | Who decides | Who is consulted | Reversibility |
|---|---|---|---|
| Roadmap priorities (Now / Next / Later) | Seat 1 | All | Reversible |
| Individual feature scope cuts mid-sprint | Seat 1 + relevant engineer | — | Reversible |
| Architecture: pick the language / DB / cloud | Seat 3 | Seat 4 | Irreversible — handle with ADR |
| Architecture: module boundaries within that stack | Seat 3 or Seat 4 (whoever owns the module) | The other senior | Reversible with effort |
| Hiring a new engineer | Whole team (unanimous no-veto) | — | Hard to reverse |
| Design system changes | Seat 2 | Seat 4 | Reversible |
| Vendor / SaaS picks (auth, monitoring, etc.) | Seat 3 | Seat 1 (cost), Seat 4 | Reversible with migration effort |
| Pricing / packaging | Seat 1 | All | Reversible |
| Incident response actions (during incident) | Incident commander (usually Seat 3) | — | Reversible |
| Postmortem action items | Incident commander → whole team | — | Reversible |
| Deprecation / sunset | Seat 1 (product) + Seat 3 (tech impact) | All | Irreversible at execution |

The pattern: **reversible decisions get made fast by one person; irreversible ones get written down (ADR) and reviewed.** Handbook operating principle: "Reversible decisions cheaply, irreversible decisions carefully." (See [`README.md`](README.md) Foundations.)

---

## 7. Scaling: the hiring ladder

When you grow past four, the order of hires matters. Each hire should be triggered by a specific failure mode in the current team, not by "we have budget."

### The first 5 hires, in order

#### Hire 5: Second product-leaning engineer (usually backend/full-stack)

**Trigger signals (need ≥ 2):**
- On-call is waking engineers up > 1x / week for weeks in a row.
- Code-review bottleneck: PRs sit unmerged > 24 hours because reviewers are unavailable.
- Shipping stalls for days during incidents because the people who can fix it are also the people who ship features.
- Seat 4 is routinely working > 50 hours / week.

**What this person adds:** Third engineer in the rotation → on-call becomes 33/33/33 with Seat 3. Review throughput doubles. Two of them can pair on a hard feature while the third handles BAU.

**What not to confuse this hire with:** This is not "a frontend engineer." You don't need a frontend specialist yet — Seat 2 covers frontend. This is a full-stack engineer who extends the backend-capable bench.

#### Hire 6: Dedicated designer (non-engineer) or Customer-facing generalist — whichever bottleneck is worse

Pick based on which of these is happening:

**Designer trigger:**
- Seat 2 is 100% on frontend feature work with no time for research, design-system work, or net-new UX.
- UX quality is slipping — new features ship without usability testing, the design system is fraying.
- You're entering a phase (e.g., mobile app, brand refresh, new product surface) that needs concentrated design attention.

**Customer-facing generalist (support → success → ops) trigger:**
- Seat 1 is > 40% on customer support and losing discovery time. Weekly customer-interview rhythm has collapsed.
- Inbound support response time > 8 business hours consistently.
- Post-signup activation handholding is falling on engineers.

**Which one first?** If the product is still pre-PMF, hire the customer-facing generalist — they accelerate learning. If the product has PMF and is scaling, hire the designer — they accelerate experience quality.

#### Hire 7: Whichever of the two you didn't hire at #6

Now you have: Founder/PM + Design Engineer + Dedicated Designer + Staff Eng + Senior FS Eng + Senior FS Eng + CS/Support generalist. Seven people. Phase coverage is no longer fragile.

#### Hire 8: Platform / SRE Engineer

**Trigger signals:**
- SLO violations recurring quarterly.
- Incident rate > 2 / month with Seat 3 as incident commander every time.
- MTTR climbing as the system gets more complex.
- Deploy freezes happening because the deploy pipeline isn't trustworthy.
- Cloud spend growth > product growth — no one has time to look.

**What this person adds:** Frees Seat 3 to work on higher-leverage architectural moves. Picks up on-call primary, making the rotation 3-wide in primary slots.

#### Hire 9: Dedicated Product Manager

**Trigger signals:**
- Founder cannot cover roadmap + customer calls + stakeholder management + hiring + fundraising in one week anymore.
- Multiple PM-shaped responsibilities are dropped (interviews missed, OKRs stale, sprint planning ad-hoc).
- Team has grown to the point where two product "lanes" exist (e.g., growth vs. core product, or two product surfaces).

**What this person adds:** The founder becomes CEO / strategy / external-facing; the PM owns day-to-day product. If there are two lanes, one PM per lane.

### What changes at 6 people

- Async standup gets longer — consider a 10-min daily video standup.
- Code review assignments need rotation rules (round-robin or "one of these three reviewers").
- Decision rights need to be re-documented — what used to fit in one person's head now needs to be explicit.

### What changes at 8 people

- Introduce a weekly 30-min "engineering sync" for Seats 3, 4, 5, 8 to align on architecture and ops without bogging down the whole team.
- Sprint planning becomes heavier — consider a 15-min "backlog grooming" mid-sprint.
- You probably need a real applicant tracking system. Informal hiring breaks at this size.

### What changes at 12 people

- Two squads emerge naturally — typically product + platform, or growth + core. Each squad has a PM-ish lead (one of whom is still the founder), a designer-or-design-eng, 2–3 engineers.
- The founder steps away from most day-to-day product execution. They're now setting strategy, managing investor / partner relationships, hiring at senior levels, handling the board.
- You need a first Head of Engineering (a manager, not just a senior IC) around here.

### What changes at 20 people

- At least 3 functional leaders: Head of Engineering, Head of Product, Head of Design.
- Formal compensation bands and a promotion process.
- Dedicated hiring function (recruiter or in-house sourcing) — the hiring ladder you used for hires 5–9 doesn't scale past this.
- The team is a *company*, not a startup. Rituals and roles become load-bearing in a way they weren't before.

---

## 8. Anti-patterns at lean scale

Avoid these. Each one has a specific cost and a better alternative.

- **Hiring a generalist "first engineer" with no backend or no frontend.** Seat 2 *must* code frontend. Seats 3 and 4 *must* code backend. A "polyglot generalist" who does a bit of each without real depth is the worst hire at lean scale — you end up with four parts of a stack nobody owns.
- **Hiring a "VP of Engineering" before 8 people.** At lean scale, engineering leadership is two senior ICs running incidents and reviewing code. A VP without a team to manage becomes a meetings-generator.
- **Hiring a dedicated QA engineer at < 10 people.** Tests should be written by the engineers who wrote the code. A QA function at lean scale removes that responsibility and produces a flaky E2E suite maintained by the wrong person.
- **Hiring a dedicated DevOps engineer at < 10 people.** Seat 3 covers this. A dedicated DevOps hire at this scale either becomes Seat 3 (in which case you should have hired them as Seat 3) or becomes a silo.
- **Hiring a "Chief of Staff" or "Founder's Associate" before hiring a PM.** The founder's highest-leverage task is discovery. Delegating discovery to a junior role is delegating the most important thing.
- **Over-relying on contractors for core surfaces.** Contractors are fine for time-boxed work (brand identity, a one-off integration, a data-pipeline spike). They are not fine for the auth flow, the billing system, or anything with ongoing maintenance cost.
- **Splitting "product" from "design" at 4 people.** A dedicated designer + a dedicated PM + 2 engineers is a worse team shape than the four seats above — the designer has nobody to pair-code with, the PM has no engineering partner for architecture conversations.
- **No on-call rotation "because we haven't had an incident yet."** You will have one on the day you can least afford it. Set up paging before you need it.
- **No writing culture.** "We're small, we can just talk." You can. Then you hire #5, and they have no context. Write things down from day one.

---

## 9. Red flags: signs the team is broken

Watch for these patterns. Each one is a signal to change team shape, cadence, or leadership — not to "try harder."

- **The same person is always in incidents.** Single-point-of-failure on ops. Partner them with someone else, document runbooks, rotate.
- **The sprint always slips.** Either the founder is over-committing scope, or estimates are not being respected, or one engineer is blocked and nobody has said so.
- **Customer-interview rhythm has collapsed.** Weekly 5-customer minimum is gone. The roadmap is drifting toward stakeholder voice. Fix urgently — rebuild the rhythm or hire help.
- **PRs sit unreviewed for > 1 day, routinely.** Either the team is too small (time to hire), or review discipline has slipped (time to rebuild the norm).
- **Postmortems aren't producing action items.** Either incidents are being swept under the rug, or the team is exhausted and can't absorb follow-up work. Both are serious.
- **"We don't have time for tests / docs / ADRs."** You do — you're just spending that time on rework three sprints later. Handbook Phase 05 research is clear on the ROI.
- **Seat 1 is coding features.** Seat 1's highest lever is customer truth. If they're in PRs, the team is misallocated or the founder is avoiding discovery.
- **Anyone is working > 50 hours / week as a steady state.** This is not heroic — it's a hiring problem or a prioritization problem. Fix the root cause.
- **Hiring process has stalled > 8 weeks.** Either the ladder is wrong (hiring for the wrong seat), or the funnel is broken (sourcing or comp).
- **The same discussion keeps happening.** Decisions aren't being written down. Use ADRs (architecture), product specs (product), or decision memos (everything else).

---

## 10. Compensation & equity shape (not numbers)

Numbers are market-specific and date quickly — the shape is more durable.

- **All four seats are senior-equivalent.** This is a lean team. Every seat is accountable for a phase of the handbook. No juniors in the first four. Pay accordingly.
- **Seat 3 (Staff Engineer) is typically the highest-paid IC.** Reflects scope: architecture, ops, incidents, security, infra cost. Compensation should signal that the "3 a.m. accountability" is real.
- **Seat 1 (Founder / PM) compensation scales with the company stage.** Founders with equity; hired PMs with salary + equity appropriate to the stage.
- **Equity for the first 4 hires should be meaningful** — typically 0.5% to 2% at seed, lower post-Series A. The point: the first four are building the company, not "joining it."
- **On-call compensation is separate and real** — either a per-shift stipend or time-off-in-lieu. "It's part of the job" is the fastest way to lose Seat 3.
- **Avoid below-market cash "because equity."** The first four hires should be at or near market on cash. Equity is the upside, not the trade.

---

## 11. Interviewing for each seat

### Seat 1 (Founder / PM)

If this is a co-founder or the founding PM hire:

- **Assess customer listening.** Have them do a live customer interview (with a volunteer friend playing the customer) on a made-up product. Watch for leading questions, premature solutioning, story-seeking.
- **Assess writing.** Ask for a sample product spec, launch announcement, or investor update. Read it with a red pen.
- **Assess prioritization.** Give them 10 candidate features with fake data; ask them to rank and defend. Look for principle-driven reasoning, not pet theories.
- **Avoid hiring on charisma.** Founder-type confidence is orthogonal to product judgment.

### Seat 2 (Design Engineer)

- **Figma + code portfolio.** Both must be strong. Weak at either disqualifies at this seat.
- **Live design exercise.** Give a loose brief; ask them to wireframe, then talk through how they'd build it in the team's stack. Watch for trade-off articulation, not visual polish.
- **Accessibility screen.** Ask how they'd audit an existing flow for WCAG 2.2 AA. If they can't name concrete things to check, they're not a design engineer yet.
- **Avoid hiring the aesthete who can't code.** At this scale, design-without-ship is not a hire.

### Seat 3 (Staff Engineer, platform-leaning)

- **System-design exercise.** Ask them to design a simplified version of your product's core flow, end-to-end. Watch for ADR thinking, pragmatism ("we'd start with Postgres, evaluate when…"), and appropriate scope.
- **Incident storytelling.** "Walk me through the worst production incident you've led." Look for: blameless framing, concrete root-cause analysis, what they changed afterward. Handbook Phase 07 tone.
- **Code review on a real PR.** Show them a real PR from your codebase (or an open-source project). What do they notice? What do they ignore?
- **On-call scar check.** Have they actually been on-call? For what scale? What did they hate? What did they fix?
- **Avoid the architect who hasn't shipped in years.** At this scale, Seat 3 codes daily.

### Seat 4 (Senior Full-stack Engineer, product-leaning)

- **Full-stack feature exercise.** Give them a small feature spec; ask them to sketch the data model, API, frontend, and test plan. Watch for coverage across the stack and test-discipline signal.
- **Test-strategy conversation.** "Walk me through how you'd test this." Listen for pyramid thinking, not "I'd write some tests."
- **Pragmatism check.** "What would you cut to ship this one week earlier?" Watch for real trade-offs, not "we shouldn't cut anything."
- **Avoid the specialist who only does one side.** Seat 4's value is crossing the stack.

---

## 12. Onboarding the first four hires

The first four hires set the culture. Onboarding matters disproportionately.

- **Day 1 — paperwork + tooling.** Access, repos, docs, Slack. The checklist is written. Seat 3 owns it.
- **Day 2 — ship something small.** A docs fix, a copy change, a flag tidy. The goal is proof the path-to-prod is real.
- **Week 1 — 3 customer interviews.** Every hire, not just Seat 1. Watch at least 2, run at least 1 (with a teammate on the call).
- **Week 2 — read the whole handbook + research.** All eight phases. Mark disagreements; discuss with Seat 1 or Seat 3.
- **Week 4 — own a phase exit checklist.** Pick a current project; by week 4 they should be able to mark off items on the handbook exit checklist for their primary phase.
- **Week 8 — on-call shadow.** Every engineer does at least one shadow rotation before going primary. Applies to Seat 2 too — they won't be primary on backend issues, but they need to know what "on-call" feels like.

---

## 13. Why this works

Every prescription in this chapter traces back to the handbook's foundations and to the research corpus underneath it.

- **Four seats as the baseline.** See [`README.md`](README.md) Foundations §1 ("Team — the minimum viable team") for the three-function rule and the "one senior engineer, ideally two" qualifier. This chapter turns that rule into a specific four-seat configuration with phase ownership.

- **Phase ownership mapping.** Each phase reference in the matrix (section 3) and in the seat descriptions (section 2) points to the handbook's phase chapter. Those chapters in turn cite the research (`../research/`) that justifies every specific recommendation — Torres and Cagan for discovery, RICE and OKRs for planning, ADRs and modular monolith defaults for design, trunk-based dev and Google code-review practice for build, pyramid and progressive rollout for test, CI/CD and DORA for ship, SRE and OpenTelemetry for run, Lehman and CVSS for evolve.

- **"Everyone does discovery" rule.** Handbook [`01-discover.md`](01-discover.md) emphasizes continuous customer contact as a team practice, not a PM practice. The rule in section 5 above codifies that at the team-design level.

- **Hat-switching around testing and ops.** The no-QA-no-SRE stance comes from handbook [`05-test.md`](05-test.md) ("tests are the developer's job") and [`07-run.md`](07-run.md) (SRE as a practice shared by the team, not a siloed role).

- **On-call rotation math.** Two engineers is the practical minimum for a sustainable on-call rotation. Three is the point where one absence doesn't break the rotation. This is the core operational reason for four seats over three.

- **Hiring ladder order.** The triggers for hires 5–9 (section 8) are derived from the failure modes each hire addresses, cross-referenced to handbook phase owners. Hire to solve a specific bottleneck, not to spend budget — a principle consistent with handbook [`02-plan.md`](02-plan.md) (outcomes over output) and [`08-evolve.md`](08-evolve.md) (sustainable delivery).

- **Anti-patterns.** Each anti-pattern in section 9 is the negative image of a specific handbook recommendation — skipping tests, gold-plating architecture, over-hiring management, splitting product from design too early.

If a specific prescription above feels wrong for your context, follow the links, read the handbook chapter, then the research under it, and adjust. The team shape in this chapter is a default for a 2–20 person modern web-product team. Pick differently if your context is different — but do not pick without reading the evidence first.
