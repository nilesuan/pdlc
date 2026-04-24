# The Full Product Team

**Goal:** Organize a fully-staffed product organization — typically 30 to 200+ people contributing directly to building the product — so it can run all eight phases of the handbook at multi-product or multi-surface scale, ship independently across many streams, and keep quality and sustainability intact as the company grows.

**Size:** 30–200+ people in the product, design, and engineering functions combined. Past ~300 people, additional structural layers (divisions, business units) appear that this chapter does not cover.

**Applies when:** You have product-market fit, have outgrown the lean team (see [`00-team-lean.md`](00-team-lean.md)), and the coordination cost of adding another generalist has become higher than the cost of hiring a specialist.

**Done well means:** Stream-aligned squads ship independently most of the time. Platform, SRE, security, data, and docs are forces that *accelerate* product teams, not bottlenecks. Leadership sets direction without gating execution. Every role has a ladder. No function is a single point of failure.

---

## 1. When to scale into this shape

The [lean team](00-team-lean.md) (4 seats, each wearing many hats) works up to about 20 people. Past that, three things break in sequence:

- **Coordination starts dominating execution.** When everyone needs to know everything, nobody focuses. Meetings expand; PRs stall.
- **Specialization starts paying off.** A dedicated SRE, data engineer, security engineer, or content designer each produces more value than their generalist equivalent — because the work is now deep enough to reward depth.
- **One team cannot hold the surface area.** Multiple product surfaces, multiple customer segments, multiple platforms — a single PM or two cannot cover them with meaningful attention.

Signs you've hit the wall with the lean shape: PRs sitting unreviewed for days, SLO violations nobody has time to investigate, customer-interview rhythm collapsed, postmortems producing no follow-ups, "we'd ship faster if only" conversations dominating retros. Scale the shape only when the bottleneck is real — not because the headcount budget allows it.

---

## 2. Organizing principle: stream-aligned + platform + enabling + complicated-subsystem

The modern default structure for product engineering at scale is the four-team-type model from **Team Topologies** (Skelton & Pais, 2019), referenced in [`../research/07-operations/sre.md`](../research/07-operations/sre.md) and [`../research/07-operations/README.md`](../research/07-operations/README.md).

The four team types:

1. **Stream-aligned teams** (the majority of the org) — own a slice of the product end-to-end. E.g., "Billing," "Onboarding," "Search," "Admin." Cross-functional: PM + designer + 4–7 engineers. Responsible for continuous flow of value to a specific set of users.
2. **Platform teams** — own internal products used by stream-aligned teams: CI/CD, auth, observability, internal developer portal, shared libraries. Their "customer" is other engineers. Measured on paved-path adoption and on the time-to-first-deploy for new hires.
3. **Enabling teams** — short-lived, help stream-aligned teams adopt a capability. E.g., "a team of 3 engineers who help every squad migrate to OpenTelemetry this quarter." Disband when the capability is adopted.
4. **Complicated-subsystem teams** — own a slice of the system that requires deep specialist knowledge. E.g., real-time video encoding, payment-gateway integration, ML inference infrastructure. Rare; used only when specialization pays off more than cross-functional ownership.

**Most of the org is stream-aligned.** Platform, enabling, and complicated-subsystem teams together are typically 20–30% of engineering headcount. If platform > stream-aligned in headcount, the org is inverted — something has gone wrong.

This is the modern consensus pattern. Alternatives (matrix, pure functional hierarchy) are covered in the research but not recommended for modern product engineering at scale.

---

## 3. The leadership layer

At full-team scale, leadership is a layer, not a founder in five hats. Each leader owns a function end-to-end.

### 3.1 Executive

- **CEO / Founder.** Sets company strategy, owns investor and board relationships, closes key enterprise deals, hires the rest of the executive team. Typically the scaled-up version of the Seat 1 founder from the lean team.
- **CTO.** Owns the technology organization at the strategic level — architecture, technology choices, engineering brand. At early full-team scale (30–60 people), often hands-on: writes ADRs, runs the hardest architecture conversations. At larger scale, more strategic; a VP Engineering handles delivery.
- **CPO (Chief Product Officer).** Owns the product organization. Sets product strategy. Manages the PM org. Partners with CTO on roadmap-vs-capacity.
- **Head of Design.** Owns the design organization. Reports to CEO or CPO depending on company.

At the early end of "full team" (30–50 people), some of these consolidate — no CPO yet, just a Head of Product; no separate VP Eng, the CTO is still operational. Scale into the titles as the org size warrants.

### 3.2 VPs and function heads

Below executive, each major function has a senior leader:

- **VP Engineering.** Owns engineering delivery, hiring, compensation, performance management. The operational backbone of engineering. Distinct from CTO — CTO is about technology direction; VP Eng is about people, process, and delivery cadence.
- **Head of Product.** If a CPO exists, Head of Product runs day-to-day product execution. If not, Head of Product is the top product role.
- **Head of Design.** See above.
- **Head of Platform / Infrastructure.** Owns the platform engineering organization (section 6.2). Usually reports into CTO or VP Engineering.
- **Head of Security / CISO.** Owns application and infrastructure security plus compliance. Appears around 50–75 people. Reports to CTO or directly to CEO at enterprise scale.
- **Head of Data.** Owns data engineering, analytics, and (if applicable) ML. Appears when data becomes a product surface or when analytics has outgrown "a few PMs writing SQL in Mode."

### 3.3 Directors

Between VPs and ICs, directors lead sub-organizations:

- **Director, Product Engineering.** Manages multiple Engineering Managers running stream-aligned squads.
- **Director, Platform Engineering** and **Director, SRE.** Lead their respective platform functions.
- **Director, Product Management.** Manages multiple Group PMs / senior PMs.
- **Design Directors.** One or more, organized by product area.
- **Director, Security.** At enterprise scale, owns the security org under a CISO.

At 30–50 people, you might have zero directors (VPs manage managers directly). At 100+, you have 3–6. At 200+, directors are essential — you cannot span an org of that size without the layer.

---

## 4. Product management organization

Product management becomes a hierarchy at full-team scale:

- **CPO / Head of Product.** Strategy, executive partnership, portfolio-level roadmap.
- **Director of Product Management.** Runs the PM function. Hires and grows PMs. Owns the PM career ladder.
- **Group Product Manager (GPM).** Leads multiple PMs owning related product areas. E.g., "GPM for Growth" leads PMs on acquisition, activation, and retention. Appears when you have 6+ PMs.
- **Senior / Lead Product Manager.** Owns a major product surface, typically one stream-aligned squad. Often the most senior IC PM for that area.
- **Product Manager.** Owns a smaller product surface, or is a generalist embedded in a squad.
- **Associate Product Manager (APM).** Early-career PM, usually paired with a senior PM as mentor. Optional; some orgs prefer to hire at PM level minimum.

**Ratio rule of thumb:** 1 PM per stream-aligned squad of 5–9 people.

**What PMs own at full-team scale** (drawing on handbook [`01-discover.md`](01-discover.md), [`02-plan.md`](02-plan.md), [`08-evolve.md`](08-evolve.md)):
- Opportunity Solution Tree for their product area.
- RICE / WSJF prioritization for their backlog.
- OKRs for their squad.
- Weekly customer-interview rhythm for their area (not just the CPO — every PM talks to users every week).
- Cross-squad dependency management with the GPM.
- Launch coordination with Product Ops and TPMs.

**Product Operations.** One hire around 50–75 people in the product org. Owns:
- Tooling — the analytics stack, the roadmap software, the customer-research repository.
- Process — how sprint planning runs, how OKRs are set, how customer signal flows to squads.
- Enablement — onboarding PMs, surfacing best practice across squads.

Product Ops scales into a small team (2–4) past 100 people.

---

## 5. Design organization

Design specializes into multiple roles at full-team scale:

- **Head of Design / VP Design.** Runs the org.
- **Design Director.** Leads design for a product area (multiple squads).
- **Design Manager.** Manages a team of 4–8 designers.
- **Principal / Staff Product Designer.** Senior IC; owns cross-cutting design problems, mentors ICs.
- **Senior Product Designer.** Owns design for a single squad or major surface.
- **Product Designer.** Mid-level; embedded in a squad.

Specialist design roles that emerge at scale:

- **UX Research Lead / Senior UX Researcher.** Runs the research practice. At 50–75 people, one UXR covers the org; past 100, area-specific UXRs appear.
- **UX Researcher.** Runs generative and evaluative studies. Partners with PMs for continuous-discovery habit.
- **Content Designer / UX Writer.** Owns voice, tone, in-product copy, error messages, empty states. Under-hired at most companies; force multiplier on text-heavy products.
- **Design System Lead.** Owns the component library, tokens, cross-product consistency. Partners with a design-systems engineer (section 6.2).
- **Design Engineer.** The lean team's Seat 2 evolved into its own role: frontend engineer with design fluency, owns production components and design-system code. Scarce but high-leverage.
- **Brand Designer / Marketing Designer.** Ships marketing surface. Sometimes lives in marketing instead of product design.

**Ratio rule of thumb:** 1 designer per stream-aligned squad. 1 UXR per 5–10 designers. 1 content designer per 3–5 squads (or 1 per product area).

**Designers report into design**, not into product or engineering. Dotted line to the squad PM; solid line to the Design Manager. This matters — design careers depend on design leadership.

---

## 6. Engineering organization

Engineering splits into several functions at full-team scale, each with its own roles, ladders, and management lines.

### 6.1 Product engineering (stream-aligned teams)

The majority of engineering headcount. Each squad has:

- **1 Engineering Manager** or **Tech Lead Manager** (TLM — hybrid role; less common at scale).
- **1 Tech Lead / Staff Engineer** (IC path).
- **2–5 Senior Engineers.**
- **0–2 Mid-level Engineers.**
- **0–2 Junior Engineers** (carefully; juniors need mentorship bandwidth).

**Typical squad size:** 5–9 engineers, plus PM, plus designer. Squads smaller than 4 engineers waste coordination overhead; squads larger than 10 lose cohesion and should split.

**IC ladder (common titles):**
- Engineer I / Junior Engineer
- Engineer II / Engineer
- Engineer III / Senior Engineer
- Staff Engineer
- Senior Staff Engineer
- Principal Engineer
- Distinguished Engineer / Fellow (rare, at very large scale)

**Management ladder:**
- Engineering Manager (EM) — manages 4–8 direct reports.
- Senior Engineering Manager — manages 8–15, often across 2 squads.
- Director of Engineering — manages 2–5 EMs.
- Senior Director / VP Engineering — manages multiple directors.

**Tech Lead vs. Engineering Manager.** At full-team scale, keep these distinct:
- **Tech Lead / Staff Engineer** sets technical direction. Writes ADRs, reviews architecture, unblocks hard technical problems, mentors engineers on craft.
- **Engineering Manager** sets people direction. Runs 1:1s, career development, hiring, performance, cross-team coordination.
- One person *can* do both (a Tech Lead Manager), but the roles are different hats. Most orgs split them at 8+ engineers per squad.

### 6.2 Platform engineering

The team whose customer is other engineers. Owns the paved path.

**Responsibilities:**
- CI/CD infrastructure and pipelines.
- Developer environments (local setup, preview environments, cloud IDEs).
- Internal developer portal — service catalog, ownership, runbooks, golden paths.
- Shared libraries, frameworks, SDKs for internal use.
- Auth / permissions / identity foundations shared across the product.
- Design-system code infrastructure (the framework, the build pipeline, the documentation site — not the components themselves, which belong to Design).

**Roles:**
- **Head of Platform / Director of Platform Engineering.**
- **Platform Engineering Manager.**
- **Staff Platform Engineer.**
- **Senior Platform Engineer.**
- **Platform Engineer.**
- **Developer Experience (DX) Engineer.** Sometimes a specialized role; owns "time-to-first-ship" for new hires, paved-path adoption, internal engineering docs. Distinct from customer-facing DX engineering (section 7).

**Sizing:** ~10–20% of engineering headcount at full-team scale. First platform hires appear around 25–40 engineers. Becomes a team (not individuals) around 40+.

**Platform teams need PMs too.** Large platform orgs have a Platform PM who treats internal engineers as customers, runs roadmap and prioritization the same way a product PM would. Without this, platform teams optimize for what they personally find interesting — not for what unblocks other teams.

### 6.3 Site Reliability Engineering (SRE)

Owns production reliability as both a practice and an infrastructure surface. Heavily informed by handbook [`07-run.md`](07-run.md) and the Google SRE book, cited in [`../research/07-operations/sre.md`](../research/07-operations/sre.md).

**Responsibilities:**
- Observability infrastructure (metrics, traces, logs — handbook Phase 07 standardizes on OpenTelemetry).
- SLO definition and monitoring. Error-budget management.
- On-call tooling, paging policies, escalation rules, runbooks.
- Incident response process — the practice, the tooling, the postmortem discipline.
- Capacity planning and performance engineering.
- Chaos engineering and load testing programs (handbook Phase 05).
- Security incident response partnership with security engineering.

**Roles:**
- **Director of SRE** (at scale).
- **SRE Manager.**
- **Staff SRE / Principal SRE.** Architects the observability stack, incident process, capacity models.
- **Senior SRE.** Partners with stream-aligned teams; owns reliability for a product area.
- **SRE.** Operates monitoring, writes runbooks, contributes to on-call.

**Central vs. embedded SRE:**
- **Central model.** SREs sit together; act as a consulting force for stream-aligned teams. Good at smaller full-team scale (30–60).
- **Embedded model.** One SRE per stream-aligned squad. Best at larger scale (80+) where reliability concerns are deeply intertwined with specific product surfaces.
- **Hybrid model.** Central SRE team owns shared infrastructure (observability, incident tooling, SLO platform); each major squad has an embedded SRE. The common choice at 100+.

**Sizing:** ~5–10% of engineering at full-team scale. First dedicated SRE hire at ~25–40 engineers. Becomes a team at 50+.

**SRE is a discipline, not just a role.** Handbook Phase 07 is explicit: every engineer is partly an SRE — writes monitors, owns on-call, reads postmortems. A central SRE team augments that; it does not replace it. The anti-pattern: stream-aligned engineers stop caring about reliability because "SRE owns it." That is how you get paged at 3 a.m. without a runbook.

### 6.4 Security engineering

Starts as the Head of Security plus 1–2 engineers; grows into a team.

**Responsibilities:**
- **Application security (AppSec).** Secure coding reviews, threat modeling, penetration testing, bug bounty, SAST/DAST tooling.
- **Infrastructure security.** Cloud hardening, network, secrets management, identity, endpoint security.
- **Security operations (SecOps) / Detection & Response.** Monitoring for intrusions, incident response for security events.
- **Governance, Risk, and Compliance (GRC).** SOC 2, ISO 27001, HIPAA, PCI-DSS, industry-specific regimes. Evidence collection, audit liaison, policy.

**Roles:**
- **Head of Security / CISO.** CISO title appears at enterprise scale or when regulated.
- **Director of Security Engineering / Security Engineering Manager.**
- **Application Security Engineer.**
- **Infrastructure Security Engineer.**
- **Detection & Response Engineer** (SecOps-focused).
- **GRC Analyst / Compliance Manager.**
- **Security Program Manager** (at scale) — runs compliance programs, audit cycles.

**Sizing:** first security engineer at ~30–50 engineers. ~3–5% of engineering at full-team scale; significantly higher in regulated industries (healthcare, finance, defense).

**Security as shift-left, not a gate.** Handbook Phase 07 and [`../research/07-operations/security-ops.md`](../research/07-operations/security-ops.md) are clear: if security reviews are a one-way bottleneck that stream-aligned teams route around, security is broken. The modern model embeds security expertise (via enabling teams, embedded champions, paved-path controls) so that teams ship securely by default.

### 6.5 Data engineering and analytics

Appears when data becomes a product surface, or when internal analytics has outgrown informal patterns.

**Responsibilities:**
- Data pipelines — ingestion, transformation, serving.
- Data warehouse / lake architecture.
- Analytics data models (dbt-style).
- Internal analytics tooling (BI dashboards, self-serve query).
- Experimentation infrastructure (A/B testing platform).
- Machine learning infrastructure (if ML is in the product).
- Data governance and privacy (PII handling, data retention, access controls).

**Roles:**
- **Head of Data.**
- **Data Engineering Manager.**
- **Data Engineer** — builds pipelines, warehouses, data products.
- **Analytics Engineer** — models data for analysis; sits between data engineering and analytics. Often dbt-centric.
- **Data Scientist** — analysis, experimentation, modeling.
- **Machine Learning Engineer** — ships ML features into production.
- **Data Analyst / BI Analyst** — SQL-forward analyst who serves PMs and execs.
- **Data Platform Engineer** — specialized engineer who owns data infrastructure (warehouse, pipelines, orchestration).

**Sizing:** first data engineer at ~25–50 engineers, or earlier if data is product-critical. Scales up substantially if ML is a first-class product feature.

### 6.6 Quality engineering (optional, narrow)

Handbook [`05-test.md`](05-test.md) argues that most testing is developer-owned — the test suite is a first-class engineering artifact written by the engineers shipping the feature. A dedicated QA function at full-team scale is *optional* and should be narrow, not general.

Where specialist QA pays off:

- **Test Automation Engineers.** Maintain complex end-to-end suites and cross-product regression tests.
- **Performance Engineers.** Own load and stress testing (k6, Gatling, JMeter — handbook Phase 05).
- **Release Engineers.** In orgs with complex release trains (mobile, desktop, enterprise on-prem, regulated).

If you hire QA, hire as a specialist function — not as "manual testers" who unblock developers from writing their own tests. The latter pattern is a regression to 2005.

### 6.7 Developer Relations (if applicable)

For products with an API or developer audience (infrastructure SaaS, developer tools, platforms).

**Roles:**
- **Head of Developer Relations.**
- **Developer Advocate.** Community, content, conference talks, external-facing technical writing.
- **Developer Educator.** Docs, tutorials, sample applications.
- **External DX Engineer.** Builds the SDKs, sample code, and API DX. Distinct from internal DX in platform (section 6.2).

**Sizing:** first hire when API adoption is a strategic pillar, not before. Grows with developer community size.

### 6.8 Technical writing and docs

Under-invested at most companies. Appears at full-team scale as:

- **Lead Technical Writer.**
- **Technical Writer.** Owns docs for a product area.
- **Documentation Engineer.** If docs tooling (generators, static sites, API reference pipelines, versioning) is complex.

**Sizing:** first technical writer at ~30–50 engineers. ~1 TW per 20–30 engineers is a healthy ratio for products with meaningful docs surfaces (APIs, SDKs, enterprise onboarding docs, multi-tenant admin flows).

---

## 7. Customer-facing technical roles

These sit adjacent to product engineering — typically in GTM or Customer orgs — but they're part of how the product reaches and retains customers, so a full team map includes them.

- **Solutions Engineer (SE) / Sales Engineer.** Pre-sales technical role. Demos, technical discovery calls, RFP responses. Partners with Sales to close deals.
- **Implementation Engineer / Onboarding Engineer.** Post-sale, helps customers integrate, deploy, migrate. Common at enterprise SaaS with complex integrations.
- **Customer Engineer.** Hybrid at some orgs; a blend of SE and technical CS. Sometimes synonym for SE.
- **Technical Support Engineer.** Tier 2–3 support; reads code, reproduces bugs, escalates to product engineering. Partners closely with platform teams on tooling.
- **Customer Success Engineer.** Technical CS, usually paired with strategic enterprise accounts.

**Reporting.** These roles sit in GTM / Customer orgs (report to a VP of Sales, VP of Customer Success, or similar), not in product engineering. They partner with product engineering via TPMs and PMs.

---

## 8. Product operations and program management

Cross-cutting functions that keep the scaled org working.

- **Product Operations.** Tooling, process, enablement for the PM org. See section 4.
- **Engineering Operations.** VP Engineering's operational partner. Owns hiring process, performance cycles, compensation calibration, OKR tracking inside engineering.
- **Technical Program Manager (TPM).** Owns cross-squad initiatives, quarterly planning, major launches, migrations, compliance programs. Ship-running when the ship touches many squads.
- **Chief of Staff (Engineering or Product).** Exec-facing operational partner. Appears at large scale (100+); optional.

**Ratios:**
- 1 TPM per 30–50 engineers is a working ratio.
- Product Ops: 1 hire at 50–75 in product org; small team of 2–4 past 100.
- Chief of Staff: 1 per exec who needs one. Not every VP.

---

## 9. The squad template

A typical stream-aligned squad at full-team scale:

- **1 Product Manager.**
- **1 Product Designer.**
- **0–1 UX Researcher** (more often shared across 2–3 squads than fully embedded).
- **1 Engineering Manager** (may lead 2 squads in smaller configurations).
- **1 Tech Lead / Staff Engineer.**
- **3–5 Engineers** (senior, mid, junior mix).
- **0–1 Embedded SRE** (at larger scale or for infra-heavy squads).
- **0–1 Embedded Data or Analytics Engineer** (for data-heavy squads).
- **0–1 Content Designer / UX Writer** (for text-heavy surfaces).
- **0–1 Embedded Security Engineer / Security Champion** (for regulated or sensitive surfaces).

**Total:** 7–11 people. The squad operates with substantial autonomy — owns its backlog, its OKRs, its deploy cadence, and on-call for its services.

**Squads above 10 people lose cohesion** — standups stretch, decisions slow, code review gets assigned rather than adopted. Split before you break.

---

## 10. Reporting structure at full-team scale

Simplified org chart for a ~100-person product organization:

```
CEO
├── CTO
│   ├── VP Engineering
│   │   ├── Director, Product Engineering
│   │   │   ├── EM — Squad A (Onboarding)
│   │   │   ├── EM — Squad B (Billing)
│   │   │   ├── EM — Squad C (Core Product)
│   │   │   └── EM — Squad D (Admin)
│   │   ├── Director, Platform Engineering
│   │   │   ├── Platform EM (CI/CD, DevEx)
│   │   │   ├── SRE Manager
│   │   │   └── DX Lead
│   │   └── Engineering Operations Lead
│   └── Head of Security
│       ├── Security Engineering Manager
│       └── GRC Manager
├── CPO
│   ├── Director of Product Management
│   │   ├── GPM (Growth)
│   │   │   ├── Senior PM — Squad A
│   │   │   └── PM — Squad B
│   │   └── GPM (Core Product)
│   │       ├── Senior PM — Squad C
│   │       └── PM — Squad D
│   └── Product Operations Lead
├── Head of Design
│   ├── Design Manager (Product Area 1)
│   ├── Design Manager (Product Area 2)
│   ├── UX Research Lead
│   ├── Design System Lead
│   └── Content Design Lead
└── Head of Data
    ├── Data Engineering Manager
    └── Analytics Lead
```

Key features:

- **Product engineers report into engineering**, not into product. Dotted-line partnership with the PM; solid line to the EM.
- **Designers report into design.** Dotted-line to PM; solid-line to Design Manager.
- **Platform, SRE, security, and data each have their own management lines.** Specialists need specialist leaders for career growth, and separate lines resist the "platform is a dumping ground" failure mode.
- **TPMs report into Engineering Operations** (or equivalent) — not into any one squad — so they can broker between squads neutrally.

---

## 11. Ratios and heuristics

Approximate and context-dependent; adjust for product type.

| Ratio | Typical value |
|---|---|
| Engineers : PM | 5–7 : 1 |
| Engineers : Designer | 5–8 : 1 |
| Engineers : UX Researcher | 20–40 : 1 |
| Engineers : Technical Writer | 20–30 : 1 |
| Stream-aligned engineers : Platform engineers | 5–8 : 1 (platform = ~12–20% of eng) |
| Stream-aligned engineers : SRE | 10–20 : 1 (SRE = ~5–10% of eng) |
| Stream-aligned engineers : Security engineers | 20–30 : 1 (security = ~3–5%; higher in regulated) |
| Engineers : Engineering Manager (direct reports) | 5–8 : 1 |
| EMs : Director | 3–5 : 1 |
| TPMs : engineers | 1 : 30–50 |
| Content designers : squads | 1 : 3–5 |

**Context modifiers:**
- Consumer products weight design and research heavier.
- Enterprise products weight solutions engineering and implementation heavier.
- Regulated industries (healthcare, finance, defense) weight security, compliance, and QA heavier.
- Developer-tools products weight DevRel, docs, and DX heavier.
- ML-heavy products weight data and ML engineering heavier.

---

## 12. Handbook phase ownership at full-team scale

| Phase | Primary owner(s) | Supporting roles |
|---|---|---|
| [01 Discover](01-discover.md) | PMs per squad; UX Researchers | Product Ops (repo), CPO (strategy-level discovery), Data (quantitative signal) |
| [02 Plan](02-plan.md) | PMs + EMs per squad; CPO + VP Eng at portfolio level | GPMs, Director PM, Product Ops, TPMs (cross-squad planning) |
| [03 Design — UX](03-design.md) | Product Designers per squad; Design Directors cross-area | UX Researchers, Content Designers, Design System team |
| [03 Design — architecture](03-design.md) | Tech Leads / Staff Engineers per squad; Principal Engineers for cross-squad | Platform, Security, Data (for their domains), CTO (for strategic choices) |
| [04 Build](04-build.md) | Engineers in stream-aligned squads | Platform (paved paths), DX Engineers, Design System |
| [05 Test](05-test.md) | Engineers in stream-aligned squads | Platform (test infra), SRE (load/chaos), QA specialists if hired |
| [06 Ship](06-ship.md) | Tech Leads + Platform + SRE | Release TPMs (for coordinated releases), Product Ops (launch coordination), Security (for sensitive releases) |
| [07 Run](07-run.md) | SRE + Tech Leads + EMs | Security (for security incidents), TPMs (for incident programs), Support Engineering |
| [08 Evolve](08-evolve.md) | PMs per squad; CPO at portfolio level; Tech Leads for technical evolution | Product Ops, Data, TPMs (for deprecations and migrations) |

Two key differences from lean scale:

- **No single person owns a phase end-to-end** for a whole product. Ownership is distributed across squads; RACI matters more than personal accountability.
- **Cross-squad coordination is its own job.** TPMs, Director forums, and exec reviews exist to make cross-squad decisions efficient. Without them, anything touching more than one squad stalls.

---

## 13. Decision rights at full-team scale

The key shift from lean: **most decisions should be made at the squad level.** Leadership sets strategy and constraints; squads make tactical calls inside them.

| Decision class | Who decides | Who is consulted |
|---|---|---|
| Company strategy / annual OKRs | CEO + exec team | Board, customer-facing leaders |
| Product portfolio strategy | CPO | CEO, CTO, exec |
| Squad quarterly OKRs | Squad PM + EM | GPM / Director PM, Director Eng |
| Features this sprint | Squad PM | Squad engineers and designer |
| Architectural choices inside a squad | Squad Tech Lead | Other Tech Leads (forum), Principal Eng |
| Architectural choices crossing squads | Principal Eng community + affected Tech Leads | CTO, VP Eng, Platform, Security |
| Platform roadmap | Head of Platform + Platform PM | Stream-aligned EMs (customers of platform) |
| Hiring / firing | Hiring manager (EM, Design Mgr, GPM) | VP / Director above |
| Budget / headcount allocation | VP Eng + CPO + CFO | CEO, Heads of functions |
| Security posture and compliance scope | Head of Security | CTO, VP Eng, legal, GRC |
| Deprecation of a product surface | Squad PM + CPO | Sales, CS, affected engineering |
| Incident response (during incident) | Incident Commander (usually SRE or on-call engineer) | Squad EM, Head of Security if applicable |
| Postmortem action items | Incident Commander → affected squads | VP Eng (informed), Head of Security (informed) |

**Architecture review forums.** A common pattern at full-team scale: a weekly or bi-weekly meeting where Tech Leads and Principal Engineers review cross-squad architectural proposals, formalized in ADRs. Replaces the "just ask Seat 3" pattern from lean scale.

**Product review forums.** Equivalent for product decisions that cross squads. Led by CPO or Director of Product Management.

**Security review forums.** Weekly or bi-weekly; Head of Security + security engineers + affected teams review sensitive changes. Goal: shift-left, not gate.

---

## 14. Transition path from lean to full

The path from 4 seats to 100+ people is a series of bottlenecks-and-hires, not a single reorganization. Rough milestones:

| People | What changes |
|---|---|
| **4 → 6–7** | Second product-leaning engineer. Dedicated designer or customer-facing generalist. |
| **7 → 10–12** | Platform / SRE engineer. First dedicated PM (founder steps back from day-to-day product). |
| **12 → 20** | Two squads form. First Engineering Manager. First Security engineer. First lightweight TPM. |
| **20 → 30–40** | Engineering ladders formalized (IC and management paths). Platform becomes a team. SRE becomes a formal role. Head of Design hire. |
| **40 → 60–80** | Director layer appears. Multiple squads. Dedicated Head of Security. Data engineering function begins. Design splits into Product Design + UXR + Design System. |
| **80 → 150+** | Full executive layer (CTO, CPO, VP Eng, Head of Design, Head of Security, Head of Data). Multiple directors. Platform, SRE, Security, Data are all formal functions. TPM team. Product Ops. |

**Common mistakes during this transition:**

- **Scaling PM, design, and engineering out of sync.** Hire 5 engineers without a designer → squads ship ugly. Hire a designer without a PM partner → design drifts from product strategy.
- **Hiring specialists before there is work for them.** A dedicated Head of Security at 15 people will not have enough to do. Defer specialist hires until a specific unmet need demands them.
- **Skipping the EM layer.** Flat orgs work at 15; break at 30. Senior ICs cannot also do people management at scale — you lose both.
- **Deferring platform investment.** The later you start, the more paved-path work has piled up as ad-hoc, and migrations are expensive.
- **Promoting Seat 1 (founder) straight to CEO without hiring a CPO.** The founder loses product depth; the org loses strategic product leadership.
- **Over-rotating into management too fast.** Not every senior engineer wants to manage. Provide a Staff / Principal IC ladder with scope and compensation equivalent to the EM/Director track.

---

## 15. Anti-patterns at scale

- **Matrix management.** Dotted-line reports to two managers produce unclear priorities. Pick a primary line; make partnership explicit (RACI).
- **Platform as a dumping ground.** Platform is for paved paths, not for whatever stream-aligned teams don't want to own. Platform teams need PMs and roadmaps — they are internal products.
- **SRE as ops-only.** A pure ops-SRE team becomes the people blamed for outages, not the people preventing them. SRE at scale is an embedded discipline.
- **Security as a gate.** One-way review bottlenecks cause teams to route around security. Shift-left: paved paths with secure defaults, security champions in squads, enabling teams for new regimes.
- **Senior IC ladder missing or underused.** If the only way up is management, you lose senior ICs. Provide Staff / Principal tracks with real scope and compensation.
- **Design as a service function.** If designers are "receiving briefs" from PMs, design is broken. Designers should be in discovery, not downstream of it.
- **PMs as ticket-writers.** If PMs are writing acceptance criteria instead of running discovery and owning outcomes, they are misused.
- **Over-specializing too fast.** Not every 50-person org needs a dedicated ML engineer, DevRel team, or security director. Specialize when specific work demands it — not because a headcount budget allows it.
- **Squad bloat.** Squads over 9–10 people lose cohesion. Split before they break.
- **Under-investing in enabling functions.** No Product Ops, no TPMs, no UXR leaders → the org runs on individual heroics instead of systems. Scales badly.
- **"Reorg first, then figure out why."** Reorganization is expensive. Change structure only when the current structure is demonstrably broken — not to signal change or appease stakeholders.
- **Hiring for titles instead of scope.** A "Director" with 2 reports and unclear scope is worse than a Staff Engineer. Hire for work, not for the org chart.
- **Treating platform / SRE / security as cost centers.** They are force multipliers. Measure them on how much stream-aligned velocity they unblock, not on how many tickets they close.

---

## 16. Red flags: signs the scaled org is broken

- **Decision latency > 2 weeks on routine calls.** Architecture, hiring, launches — if these take longer than a sprint, the decision rights are unclear.
- **Cross-squad dependencies dominate sprint planning.** Squads cannot ship independently because every feature needs three other squads. The squad boundaries are wrong.
- **Platform teams over-sized relative to stream-aligned.** Inverted org shape. Something is wrong — either platform is empire-building or stream-aligned teams are under-staffed.
- **Postmortems producing no action items.** Incidents are being swept under the rug, or teams are too busy to absorb follow-up work. Both are serious.
- **OKR attainment either very high (>90%) or very low (<30%) across many squads.** OKRs are not set well (too easy or too ambitious).
- **Attrition concentrated in one function.** Something is broken in that function's management, compensation, or culture. Investigate quickly.
- **Hiring pipeline stalled > 8 weeks for senior roles.** Comp, sourcing, or employer brand is off.
- **Security / compliance only hears about work after it ships.** Shift-left has failed. Re-integrate.
- **"We don't have time for docs / ADRs / tests."** You do — you're just paying the cost later as rework and tribal knowledge. Handbook Phase 03 and Phase 05 research is clear.
- **Senior ICs leaving to take management roles elsewhere.** The IC ladder is broken. Fix scope and compensation before you lose more.

---

## 17. Compensation and career architecture (shape, not numbers)

Numbers are market-specific; the shape is durable.

- **Dual ladders are mandatory.** IC track (Engineer → Senior → Staff → Principal → Distinguished) and Manager track (EM → Senior EM → Director → VP) must be equivalent in scope, comp, and prestige at every level. Without this, you lose senior ICs to management roles they don't want.
- **Staff-plus IC levels must have real scope.** Staff engineers lead cross-squad technical initiatives. Principals set strategy for a domain. If Staff is a comp title with no scope, the ladder is broken.
- **Managers are engineers first.** At least for the first 2–3 levels, engineering managers should come from an engineering background. A VP Engineering may be more of a pure leadership role; an EM who cannot read code will not earn the team's respect.
- **On-call compensation is paid or time-off-in-lieu.** "It's part of the job" causes burnout at scale. Formalize.
- **Compensation bands, published internally.** At scale, informal comp decisions create equity problems fast. Bands with clear criteria for each level fix this.
- **Promotion criteria, written down.** What gets someone from Senior to Staff? From EM to Senior EM? If you can't answer clearly, you have a promotion problem waiting to surface.
- **Performance management is not a surprise.** 1:1s, career-development conversations, and performance feedback should be continuous. Annual reviews are a summary, not an event.

---

## 18. Onboarding at scale

Onboarding matters more at full-team scale, not less — because institutional knowledge is fragmenting across squads.

- **Week 1 — environment and access.** Local dev running, paved-path tooling, paired with a buddy. Platform / DX teams own this experience.
- **Week 2 — squad context.** Shadow standups, read the squad's OKRs, understand the customer segment the squad serves, read the last 3 postmortems.
- **Week 3 — first PR merged.** Something small; proves the path-to-prod works. DX metric: "time to first production merge" < 10 working days.
- **Week 4 — first customer-facing exposure.** Listen to sales calls, read support tickets, attend a customer interview. Even non-PM roles.
- **First month — read handbook and relevant research.** All 8 phases. Mark disagreements with the squad's actual practice; discuss with the EM.
- **First quarter — own a phase exit checklist.** By the end of quarter 1, new engineers should be able to check off items on the handbook's exit checklists for their primary phase.
- **Month 3 — on-call readiness.** Shadow rotations before going primary. Even designers and PMs should shadow at least one incident.

---

## 19. Why this works

Every role and structural choice in this chapter maps back to the handbook and to the research corpus.

- **Stream-aligned + platform + enabling + complicated-subsystem team model.** Team Topologies (Skelton & Pais, 2019), cited in [`../research/07-operations/sre.md`](../research/07-operations/sre.md) and [`../research/07-operations/README.md`](../research/07-operations/README.md). The modern consensus pattern for scaled product engineering.

- **PMs owning continuous discovery per squad.** Handbook [`01-discover.md`](01-discover.md). Discovery is a team practice at lean scale; at full-team scale it becomes a per-squad PM practice supported by dedicated UX researchers.

- **Architecture review forums and distributed ADR ownership.** Handbook [`03-design.md`](03-design.md). At lean scale, Seat 3 writes ADRs personally; at full scale, Tech Leads write them and a Principal Engineer community reviews. Forums replace the "just ask Seat 3" pattern.

- **Platform teams treated as internal products.** Handbook [`04-build.md`](04-build.md) and [`06-ship.md`](06-ship.md). CI/CD, paved paths, internal developer portals — these are platform-team products, not overhead.

- **SRE as a function and a discipline.** Handbook [`07-run.md`](07-run.md) and the Google SRE book (cited in [`../research/07-operations/sre.md`](../research/07-operations/sre.md)). Central + embedded hybrid is the typical choice at 100+; the anti-pattern of "SRE = ops" is explicitly avoided.

- **Security as shift-left, embedded, not a gate.** Handbook [`07-run.md`](07-run.md) and [`../research/07-operations/security-ops.md`](../research/07-operations/security-ops.md). Both are clear: gated security is worked around; embedded security ships more securely.

- **Dual-ladder career architecture.** Standard industry practice; matches the career-development literature in [`../research/04-development/`](../research/04-development/). Avoids the "only-up-is-management" failure mode that hemorrhages senior ICs.

- **Hiring to solve bottlenecks, not to spend budget.** Handbook operating principles (see [`README.md`](README.md) Foundations §2). The transition timeline in section 14 is triggered by specific failure modes, not by headcount targets.

- **Product Ops, TPM, and enabling functions as force multipliers.** Handbook [`02-plan.md`](02-plan.md) (planning at scale), [`08-evolve.md`](08-evolve.md) (sustainable delivery). These roles exist to reduce coordination cost across the org — skip them and the org runs on heroics.

For the lean version of this team — what all of this scales up from — see [`00-team-lean.md`](00-team-lean.md). Start lean, scale only when real bottlenecks force it, and use this chapter as the target shape.
