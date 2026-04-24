# Phase 03 — Design

**Goal:** Make the few decisions that are expensive to change later — architecture, core data model, user flows — and document them so the team can build in parallel.

**Duration:** 1–3 weeks for MVP; ongoing for new features.

**You are done when:** Anyone on the team can read the design docs and start implementing without re-asking basic questions.

---

## What this phase is about

Design is not a one-time event. It is a running activity across the lifetime of the product. What changes is *which* decisions you are making: some are structural and expensive to reverse; most are local and cheap. The trick is telling them apart.

Michael Nygard frames an architecturally significant decision as one that "affect[s] the structure, non-functional characteristics, dependencies, interfaces, or construction techniques" of the system. Those deserve deliberate thought. Everything else — helper functions, settings dialogs, retry policies — can be changed next Tuesday without much cost.

Three traps to avoid at the boundary between Phase 02 and Phase 04:

- **Premature architecture.** Designing for a scale, team size, or feature set you do not have yet. Microservices on day one is the canonical example. Martin Fowler's "MonolithFirst" observes that "refactoring of functionality between services is much harder than it is in a monolith," and "MicroservicePremium" is blunter: "don't even consider microservices unless you have a system that's too complex to manage as a monolith."
- **Zero design.** "We'll figure it out as we code" works for one person and one day. For a team of three or more over months, it produces incompatible assumptions, redundant data models, and an architecture no one can describe. You pay for design eventually — in deliberate hours up-front, or in mangled migrations later.
- **Design theatre.** A 60-page document that nobody reads, signed off in a meeting, then quietly ignored. The artefact must be *load-bearing*: someone picks it up when they have a question, and leaves with an answer.

"Enough" design for an MVP: one context diagram, one container diagram, one data model sketch, one or two user-flow wireframes, a handful of ADRs for the load-bearing decisions, and one design doc for anything non-trivial. You are not specifying the system; you are making sure the team will not discover on day 30 that the halves they built cannot be connected.

---

## Who does what

The three functions named in the handbook intro — Product, Design, Engineering — each own part of Phase 03:

- **Product** owns the user-flow narrative, the MVP scope boundary, and acceptance for "does this solve the problem we identified in Phase 01?"
- **Design (UX)** owns the wireframes, prototypes, accessibility review, and heuristic evaluation.
- **Engineering** owns the system architecture, data model, API contracts, threat model, and ADRs.

One person wears multiple hats in a small team; that's fine. What is not fine is the *accountability* being fuzzy. For every artefact in this chapter, one named person is the author. Reviewers advise; authors decide; the team commits.

A loose rhythm that works at 2–20 people:

- **Week 1:** user flows, system architecture sketch, major ADRs.
- **Week 2:** data model, API contracts, UX wireframes, threat model.
- **Week 3:** design docs for anything non-trivial, team review, freeze and start building.

If you are past week three and still designing, you are either designing too much or discovering the scope is too big for an MVP.

---

## Inputs

Before you start, confirm:

- A sharp, validated problem statement (Phase 01).
- A product strategy and MVP scope (Phase 02).
- OKRs or some definition of success (Phase 02).
- A rough headcount and skill map of who will build it.

If any are missing or fuzzy, stop and go back. Designing for an undefined problem is how teams burn quarters.

---

## The steps

### 1. Start with the user flow

Before any box-and-line architecture diagram, draw the three to five core user journeys end-to-end. Low fidelity. Paper, whiteboard, Figma, anything. For each journey: where does the user start, what do they do, what does the system do in response, what does the user see next, when is the journey complete?

This grounds every subsequent technical decision. The data model serves the journeys; the API serves the data model; the architecture serves the API. If you design bottom-up from "we'll need a database," you end up with a system that stores things rather than one that helps users do things. NNG's design-thinking framing — empathise, define, ideate, prototype, test, implement — is explicitly iterative: "these phases are iterative and cyclical." Expect to loop between user flow and technical sketch several times in week 1.

Output: a single page with 3–5 labelled flows, each 5–10 steps long. Not pretty, just readable.

### 2. Make the "bet the company" architecture decisions

These decisions shape the next two years. Each deserves explicit thought and an ADR. The short list for a new SaaS product:

- **Deployment shape:** monolith, modular monolith, microservices, or serverless.
- **Synchrony:** synchronous request/response, asynchronous events, or both.
- **Auth:** build yourself or use a provider.
- **Multi-tenancy:** shared schema, schema-per-tenant, or database-per-tenant.
- **Primary data store:** what kind, and how many.
- **Runtime:** where the code actually runs.

**Default recommendation: modular monolith + single primary relational database + managed platform runtime.**

Why:

- Fowler's "MonolithFirst": successful microservice systems "were almost all built as monoliths first, and later broken up." Green-field microservice builds "frequently encountered serious problems."
- Fowler's "MicroservicePremium": microservices force investment in "automated deployment, monitoring, dealing with failure, eventual consistency, and other factors that a distributed system introduces." At 2–20 people you cannot afford that tax and don't need what it buys.
- Microsoft's microservices guidance agrees: they "require a mature DevOps culture," with explicit complexity, latency, and eventual-consistency trade-offs.
- A single primary Postgres takes you to significant scale before pressure to split.

**When to deviate:**

- For fundamentally event-driven products (workflow automation, IoT, analytics), a broker-style event-driven architecture is a legitimate start. Microsoft's guidance names the costs: "guaranteed delivery, eventual consistency … in-order / exactly-once processing, message coordination … error handling, data loss, observability across decoupled components."
- For regulatory tenant separation (health, defence), database-per-tenant may be required from day one.
- If one function dominates traffic 100× (media transcoding, ML inference), serverless for that function is fine — rest stays monolithic.

Make each choice explicit, not by omission.

### 3. Write ADRs for each major decision

An ADR (Architecture Decision Record) is a short, dated document capturing one decision: the forces at play, what you decided, and the consequences. Nygard's 2011 post "Documenting Architecture Decisions" is the canonical reference. The adr.github.io community defines an Architectural Decision as "a justified design choice that addresses a functional or non-functional requirement that is architecturally significant."

**What deserves an ADR:**

- Monolith vs microservices vs serverless.
- Primary database choice.
- Auth strategy.
- Multi-tenancy model.
- Synchronous vs asynchronous integration with a given external system.
- Choice of primary programming language / framework.
- Public API style (REST vs GraphQL vs gRPC).
- Significant library or vendor commitments (search engine, payment processor).

**What does not:**

- Internal refactoring, renaming, folder structure.
- UI polish, component choices within a design system.
- Choice of which linter rule to enable.
- Bug fixes and individual feature implementations.

Rule of thumb from Nygard: if reversing the decision later would cost more than writing the ADR costs now, write the ADR.

**Where to store them:** alongside the code, at `/docs/adr/NNN-short-name.md`, numbered sequentially without reuse. Superseding a decision means writing a new ADR that links back; never edit the old one in place.

**ADR template (Nygard format):**

```markdown
# ADR NNN: <short noun phrase>

## Status
proposed | accepted | deprecated | superseded by ADR-MMM

## Context
What forces are at play? Describe them in value-neutral language —
technological, political, social, and project-local constraints. No
justification of the decision yet; just the situation.

## Decision
We will <verb> <object> <because/so that>.
State in full sentences, active voice.

## Consequences
- Positive: what becomes easier or better.
- Negative: what becomes harder or worse.
- Neutral / follow-ups: what has to change as a result; what is now blocked
  or enabled; what we will revisit when.
```

**Worked example:**

```markdown
# ADR 003: Use a Modular Monolith for the MVP

## Status
accepted — 2026-05-02

## Context
We are five engineers building an MVP of a B2B SaaS product. Target
launch in three months. Expected traffic at launch: < 100 concurrent
users. Team has strong Rails and TypeScript experience, no production
experience running Kubernetes or service meshes. Two external integrations
planned (Stripe, SendGrid), both synchronous. No regulatory requirement
to isolate tenants at the database level.

## Decision
We will build a single deployable Rails application organised into
internal modules (Billing, Identity, Workspaces, Reporting). Each module
owns its tables and exposes a Ruby module boundary; no internal HTTP. A
single Postgres database backs all modules. All tenants share a schema,
with a `workspace_id` column on every tenant-scoped table enforced by a
database-level default and app-level query guard.

## Consequences
- Positive: one deploy pipeline, one runtime, one database. Local dev
  runs on a laptop. Refactoring across module boundaries stays cheap
  while the boundaries are still wrong.
- Positive: preserves optionality. We can extract a module into its own
  service when a clear reason appears (e.g., Reporting needs a dedicated
  read replica, or a separate team owns it).
- Negative: a single database is a single failure domain. Outage there
  takes everything down. We will mitigate with managed Postgres, PITR
  backups, and a read replica.
- Negative: the team must enforce module boundaries in code review;
  Ruby will not enforce them for us. We will add a lint rule to detect
  cross-module DB access.
- Follow-up: revisit when we hit any of: >25 engineers, >50k active
  workspaces, or a module with fundamentally different availability or
  compliance requirements.
```

**When to revisit:** explicitly. Every ADR should name the conditions under which the decision becomes suspect ("if we hit X, revisit"). When those conditions arrive, write the new ADR.

### 4. Design the core data model

Identify the ten to thirty entities that matter, their relationships, and their lifecycle. Draw it. An entity-relationship diagram in Figma or dbdiagram.io beats a paragraph of prose for most readers.

Use the vocabulary of Domain-Driven Design where it helps, not as ceremony. Two concepts carry their weight even on small teams:

- **Ubiquitous language.** Every entity and attribute should be named the way the business names it. If customers and support call it "account" but the data model calls it "organisation," the mismatch will cost you clarity in every conversation. Align the code to the domain, not the other way round. Evans, via Fowler: "using the model-based language pervasively and not being satisfied until it flows, we approach a model that is complete and comprehensible."
- **Bounded context.** Even within a monolith, you will have sub-areas where the same word means different things (a "User" in Billing vs in Identity vs in Reporting). Name them distinctly in each context. Fowler: DDD "recognises that total unification of the domain model for a large system will not be feasible or cost-effective."

For each major entity, answer:

- What creates it?
- What updates it, and who is allowed to?
- What ends its life (soft delete, hard delete, archive)?
- Who can read it, and under what filter (tenant, role, ownership)?
- Is it append-only, or does it mutate?

This is also where you decide on **identifiers** (UUIDs vs incremental integers; prefer UUIDs for anything visible externally), **timestamps** (`created_at`, `updated_at`, and usually `deleted_at`), and **tenant scoping** (every row gets a `workspace_id` or equivalent from day one, even if you only have one tenant — retrofitting is painful).

### 5. Define your API contracts

If the system has any clients you don't own (a web frontend, a mobile app, third-party developers), you have an API. Decide its style explicitly.

**Default: REST/JSON over HTTPS for external APIs; asynchronous events on a durable log between internal services once you have them.**

Why:

- REST's constraints — client-server, stateless, cacheable, uniform interface, layered — match the web's grain. Every HTTP client and debugging tool speaks it.
- GraphQL is legitimate when you have many heterogeneous clients querying an overlapping data graph and over/under-fetching is a pain point. The GraphQL spec describes "a query language and execution engine tied to any backend service" where "clients declaratively specify exactly which data they need." Overkill for a single frontend.
- gRPC is legitimate for service-to-service RPC where Protocol Buffers, HTTP/2, and streaming earn their weight. grpc.io: "A high performance, open source universal RPC framework." Overkill for most SaaS backends with one frontend.
- For internal integration once you have multiple services, asynchronous events on a broker decouple deploy cycles and buffer load — with the eventual-consistency tax Microsoft's event-driven guidance spells out.

**REST API rules for the MVP:**

- Resource-oriented URLs: `/workspaces`, `/workspaces/{id}/members`, not `/getWorkspaceMembers`.
- Standard verbs: GET, POST, PUT/PATCH, DELETE. GET is safe and idempotent; POST creates; PUT replaces; PATCH partial-updates; DELETE removes.
- Standard status codes: 200/201/204 for success; 400 for client error; 401 unauthenticated; 403 forbidden; 404 missing; 409 conflict; 422 unprocessable; 429 rate-limited; 5xx server error.
- Versioning from day one. Put `/v1/` in the path. You will regret it if you don't.
- Pagination by cursor, not page number, for anything that might grow.
- All mutating endpoints accept an idempotency key. You will need it for retries.
- One error shape, everywhere: `{"error": {"code": "...", "message": "...", "details": {...}}}`.
- No PII in URLs. They end up in logs, proxies, and browser histories.

Google's API Design Guide ("a living document" used inside Google since 2014) is a good extended reference: resource-oriented design, standard methods, naming, errors, versioning. Microsoft's current guidance lives per-product in `microsoft/api-guidelines` (Azure, Graph branches) after the top-level `Guidelines.md` was deprecated.

### 6. Sketch the key UX flows

Design progresses from sketch to wireframe to interactive prototype to high-fidelity mock. Go in that order; do not start in Figma with pixel-perfect mocks before you know whether the flow works.

**Recommended sequence:**

1. **Paper or whiteboard sketches** for the 3–5 core flows. 30 minutes per flow, maximum. NNG on paper prototyping: "you can user test early design ideas at an extremely low cost."
2. **Low-fi wireframes** in Figma or similar. Grey boxes, lorem ipsum, no colour.
3. **Interactive prototype** for the MVP happy path only. Clickable, enough to test with 3–5 users.
4. **Hi-fi mocks** for the MVP happy path. Error states, empty states, and edge cases get mocked only if they are non-obvious.

Evaluate every screen against Nielsen's 10 usability heuristics as a review checklist:

1. Visibility of system status.
2. Match between the system and the real world.
3. User control and freedom (an "emergency exit" from every flow).
4. Consistency and standards.
5. Error prevention (preferred over error recovery).
6. Recognition rather than recall.
7. Flexibility and efficiency of use.
8. Aesthetic and minimalist design.
9. Help users recognise, diagnose, and recover from errors.
10. Help and documentation.

Accessibility baseline: **WCAG 2.2 Level AA**. W3C: "Content that conforms to WCAG 2.2 also conforms to WCAG 2.1 and WCAG 2.0." AA is the level widely referenced in US ADA enforcement and the European Accessibility Act. POUR — perceivable, operable, understandable, robust — is the organising principle. Concretely this means: colour contrast ratios (4.5:1 for body text), keyboard operability for every interactive element, visible focus indicators, semantic HTML, alt text on meaningful images, form labels, skip links, and sensible heading hierarchy. Test with a screen reader before launch; do not rely solely on automated checkers.

Do not build a design system yet. Adopt one. **Default:** shadcn/ui for React products; Material for mobile-heavy or Android-first products; your framework's default (e.g., Rails/Tailwind) otherwise. NNG defines a design system as "a complete set of standards intended to manage design at scale using reusable components and patterns" — you do not have scale yet. Build your own only when you have three or more product surfaces that must stay consistent.

### 7. Do a lightweight threat model

OWASP frames threat modelling around four questions:

1. What are we working on?
2. What can go wrong?
3. What are we going to do about it?
4. Did we do a good job?

Run STRIDE against your container diagram, one hour per major feature. STRIDE is Microsoft's mnemonic for six threat categories:

- **Spoofing** — "illegally accessing and then using another user's authentication information."
- **Tampering** — "malicious modification of data," in transit or at rest.
- **Repudiation** — a user denying an action you cannot prove.
- **Information disclosure** — "exposure of information to individuals who are not supposed to have access to it."
- **Denial of service** — attackers making the system unavailable.
- **Elevation of privilege** — "an unprivileged user gains privileged access."

For each element in your diagram (each actor, data store, process, data flow, trust boundary), walk STRIDE. For each threat found, pick a response per OWASP: **accept**, **eliminate**, **mitigate**, or **transfer**.

Identify the top 3–5 risks for the MVP. A typical small SaaS set:

1. Auth bypass (spoofing + elevation) — use an identity provider, MFA, short-lived tokens, server-side authz on every request.
2. Tenant data leakage (information disclosure) — mandatory `workspace_id` filtering and row-level security.
3. Injection (tampering) — parameterised queries, input validation, auto-escaping templates.
4. Secret leakage (information disclosure) — never in code, never in logs, always in a manager, rotated.
5. DoS — CDN, rate limits, connection limits at the edge.

Output: a one-page worksheet attached to the architecture diagram, listing each threat, category, and response. Revisit per feature.

OWASP Top 10 and OWASP ASVS are worth a skim. The Top 10 is "a standard awareness document." ASVS (current version 5.0.0) is "a basis for testing web application technical security controls." Treat the Top 10 as a minimum checklist; ASVS Level 1 as a stretch goal.

### 8. Plan for non-functional requirements

Decide targets now, even ones you will miss in the short term. ISO/IEC 25010:2023 names nine product-quality characteristics: functional suitability, performance efficiency, compatibility, interaction capability, reliability, security, maintainability, flexibility, and safety. You do not need to write a paragraph on each. You do need numbers for the load-bearing few.

A defensible MVP target sheet:

- **Availability:** 99.5% monthly in year one (~3.5 hours of allowed downtime). 99.9% is the SaaS norm; 99.5% is honest for a single-region MVP.
- **Latency:** P95 server response < 500 ms for interactive endpoints; P95 < 2 s for page loads.
- **Durability:** zero lost committed writes under single-node failure; RPO ≤ 5 minutes, RTO ≤ 1 hour.
- **Security:** WCAG 2.2 AA; OWASP Top 10 addressed; secrets in a manager.
- **Scalability:** 10× MVP traffic without redesign; 100× can require redesign.
- **Observability:** structured logs, RED metrics per endpoint, distributed tracing on critical paths, from day one. OpenTelemetry is the interoperable default.

Azure Well-Architected Framework pillars — Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency — are a useful cross-check. Use 25010 for product quality, WAF for workload review.

Miss targets on purpose if that's the right call; don't miss them by accident.

### 9. Write a design doc / RFC for anything non-trivial

An ADR records one decision. A design doc describes a whole project or change: the problem, the goal, the proposed design, alternatives considered, trade-offs, cross-cutting concerns.

**When to require a design doc:**

- The change crosses service or module boundaries.
- It introduces a new data store or significantly changes an existing schema.
- It defines or changes a public API.
- It is security-sensitive (auth, authz, PII handling, secrets).
- It will be hard to undo.
- Three or more engineers will work on it in parallel.

**When not to:**

- Bug fixes.
- Internal refactoring within a module.
- A single engineer on a contained feature smaller than a week.

**Design doc template:**

```markdown
# <Project Title>

Author: <name>
Reviewers: <names>
Status: draft | in review | approved | rejected | superseded
Last updated: <YYYY-MM-DD>

## Context and scope
What is this, and why now? What user problem or system constraint drives it?
Link to the relevant Phase 01/02 artefacts (problem statement, MVP scope,
OKRs).

## Goals
The outcomes this work must achieve, concretely. Measurable if possible.

## Non-goals
What this work explicitly does NOT do. Protects the scope.

## Proposed design
The approach. Diagrams where they help (C4 context/container, sequence,
data model). Enough detail that an engineer can start building.

## Alternatives considered
Two or three real alternatives, with why each was rejected. If there are
no alternatives, that's a smell — you haven't looked.

## Cross-cutting concerns
- Security / threat model summary
- Privacy / data classification
- Observability (what will we log, meter, trace?)
- Reliability (failure modes, degradation, rollback)
- Performance (expected load, capacity)
- Cost
- Migration (if replacing something)

## Open questions
Things the author is unsure about and wants reviewer input on. This is
the section that makes the doc worth writing.

## Rollout plan
Flag strategy, migration sequence, rollback plan, who owns operations
after launch.
```

Ubl's "Design Docs at Google" describes the artefact as "informal documents created by the software engineer or engineers about to embark on a coding project," supporting "early identification of design issues when making changes is still cheap." Ubl notes 10–20 pages for larger projects, with "mini design docs" for incremental work. For 2–20-person teams, target 2–5 pages; 10+ only for genuinely big projects.

Frazelle's "RFD 1" at Oxide offers a compatible alternative: Requests for Discussion, biased toward rough thinking — "ideas should be timely rather than polished." The six-state workflow is more ceremony than most small teams need, but the writing-rough-ideas-down philosophy is worth adopting.

### 10. Review with the team

Async review is the default. The author circulates the design doc, reviewers leave comments inline, the author resolves them. Reviewers include: at least one other engineer; design (if UX is involved); security (if PII, auth, or external integration); product (to confirm scope alignment).

Schedule a single 30–60 minute synchronous session at the end to close the residual open questions. Do not use the sync to re-read the doc — attendees read beforehand. The meeting exists to resolve the few points where writing failed.

A design is "approved" when:

- The author believes the approach will work.
- Reviewers have no blocking objections.
- The open-questions section is either empty or contains only items deferred to implementation.

Record the approval and the date in the doc itself. That timestamp is what distinguishes a committed design from a running draft.

---

## Architectural defaults for small teams

Concrete, defensible defaults. Deviate on purpose, not by inertia.

| Concern | Default | Why | When to deviate |
|---|---|---|---|
| Runtime | Containerised (Docker) on a managed platform: Fly.io, Railway, Render, or managed Kubernetes (EKS/GKE). | Zero infrastructure team. Deploy is a `git push`. Scales to real load. | Only if you have an SRE who *wants* to run Kubernetes, or a workload with unusual runtime constraints (GPUs, persistent TCP). |
| Primary data store | One Postgres (managed: RDS, Cloud SQL, Neon, Supabase). | Relational, transactional, JSON when you need it, full-text search, mature tooling. A single Postgres takes you surprisingly far. | Genuinely wide-column data at scale (DynamoDB/Cassandra). Document-shaped data where schema churns weekly (MongoDB). Large-scale analytics (a warehouse, later). |
| Cache | Redis (managed). | Pub/sub, queues, rate limiting, session storage — all in one. | You don't have a cache need yet; don't add it. |
| Auth | An identity provider: Auth0, Clerk, Supabase Auth, AWS Cognito, Okta. | Password hashing, MFA, SSO, SCIM, account recovery are all solved problems. Rebuilding them is a security liability and a time sink. | Only for hard multi-tenant SSO requirements your provider cannot meet. Never because it seems cheaper. |
| Secrets | A managed secrets manager (AWS Secrets Manager, GCP Secret Manager) or 1Password/Doppler. | Never in code, never in logs, rotated, audited. | Never deviate. |
| Background jobs | A queue with a worker pool. Library-based: Sidekiq (Ruby), BullMQ (Node), Celery (Python), or a managed queue (SQS, Cloud Tasks). | Offload slow and flaky work from the request path. Retries and dead-letter handling built in. | Only defer adding this until you have a reason. Don't *not* add it. |
| Frontend | Either a single-page app (React + Vite) talking to the REST API, or a server-rendered framework (Next.js, Remix, Rails, Django). | One codebase. One deploy. Enough for years. | Micro-frontends, only at 50+ engineers. |
| Mobile | Web-first, or React Native if mobile is genuinely critical. | Native iOS + Android is two codebases. Unless mobile is the product, one codebase is a better use of headcount. | Mobile-first products (consumer social, on-the-go field workflows). |
| Observability | Structured JSON logs + metrics + traces, from day one. OpenTelemetry as the interoperable layer; a managed backend (Datadog, Honeycomb, Grafana Cloud) at first. | Microsoft's own microservices guidance names centralised logging, APM, and distributed tracing as first-class. You cannot operate what you cannot see. | Only swap vendors; do not skip. |
| Analytics | PostHog, Plausible, or Amplitude — pick one. | Product analytics without building it. | Only roll your own if you have a privacy/compliance requirement no vendor can meet. |
| Search | Postgres full-text to start; a dedicated search service (Typesense, Meilisearch, Elasticsearch) when you outgrow it. | You'll outgrow it later than you think. | Immediately only if search *is* the product (classifieds, job boards). |
| CI/CD | GitHub Actions (or GitLab CI). Branch → PR → CI → merge → deploy. | Same platform your code lives on. | Only for specialised needs (self-hosted runners, heavy matrix builds). |

---

## Architecture Decision Records (ADRs)

The section above covered the mechanics. A few meta-rules:

**Write the ADR when you decide, not after.** The point of the record is the *context* — the forces you were weighing when you chose. Retrofitting loses the reasoning that made the decision defensible.

**Numbering is permanent.** Never reuse an ADR number. Superseded ADRs stay in the repo with a link forward.

**ADR hygiene at review time:** the reviewer's job on an ADR is to pressure-test the Context ("is that really what we're facing?") and the Consequences ("what did you miss?"). The Decision itself is often the easy part.

**Revisit on a trigger, not a schedule.** Don't re-read every ADR quarterly. Do re-read the ADR when reality contradicts its Context — when the forces shift, when a consequence bites, or when scale passes a threshold the ADR named.

**Who writes them:** the engineer or engineers making the decision. Not a designated architect, unless you are large enough to have one.

---

## UX design for small teams

Recap:

1. **Wireframes** before any visual design.
2. **Interactive prototype** for the MVP happy path, tested with 3–5 users.
3. **Hi-fi mocks** for the MVP happy path only.
4. **Nielsen's 10 heuristics** as a review checklist.
5. **WCAG 2.2 AA.** Test with a screen reader; do not rely on automated checkers alone.
6. **Adopt a design system.** Do not build one until you have 3+ product surfaces.

Two common failures: designing in hi-fi too early (ugly-that-works beats pretty-that-doesn't), and skipping accessibility until launch (vastly cheaper built-in than retrofitted).

---

## Security design

To recap:

- **Threat modelling with STRIDE** against the container diagram, one hour per major feature. Four OWASP questions; four OWASP responses (accept, eliminate, mitigate, transfer).
- **OWASP Top 10** as a minimum checklist. The Top 10 is "a standard awareness document for developers and web application security."
- **Secrets:** never in code, never in logs, always in a manager, rotated on a schedule.
- **Auth:** use a provider, always. Custom auth is a liability you do not want.
- **Data classification:** know what PII you touch. Label it in the data model (`pii: true` on columns, or a central classification doc). Do not log it. Encrypt it in transit and at rest (managed databases do the latter by default).

Scope your effort: one hour of threat modelling per major feature, a reviewable security section in every design doc, a quarterly re-read of the top 3–5 risks for the whole system. More than that is appropriate when you handle regulated data; less is neglect.

---

## Anti-patterns

- **Big Design Up Front with no customer contact.** You are designing for a user you have stopped talking to. Phase 01 is not a one-time ticket you clip.
- **Zero design — "we'll figure it out as we code."** Survivable for one person. Fatal for a team of five.
- **Microservices on day one.** Fowler: "the premium of microservices is a drag you should do without" until you have the scale or organisational need that justifies it.
- **Custom auth.** Every custom auth system is a CVE waiting to be filed. Use a provider.
- **Premature scaling optimisations.** Sharding before you have one tenant. Rewriting the hot path before it's hot. Caching before you measure. Each is a rational-sounding way to not ship.
- **Designing for hypothetical future users.** Enterprise features for a user base that is 100% startups. Internationalisation before you have one non-English user. Role-based access control with 12 roles when you have 3 users.
- **Skipping threat modelling because "we're small."** Attackers do not care how many customers you have. The cost of threat modelling is one hour; the cost of a data leak is the company.
- **One giant design document that covers everything.** Nobody reads it. Split by decision (ADR) and by project (design doc).
- **Design review as theatre.** Sign-off without actually reading. If nobody has comments, nobody has read the doc.
- **Making the UI pretty before the flow works.** Hi-fi before lo-fi, pixel-perfect before user-tested.

---

## Scale notes

Design ceremony should scale with team size. The same decisions, captured at different weights.

**Solo / tiny team (1–3 people):**

- One-page design notes in a shared doc, per project.
- Verbal reviews; write decisions down after.
- ADRs for 3–5 big decisions in the first year, not more.
- No RFC process; pair review is enough.

**Team of 5–20:**

- Design docs for anything crossing modules or taking more than a week.
- ADRs for every load-bearing decision.
- Async review on every design doc; synchronous only to close residual questions.
- A starting design system (adopted, not built).
- Quarterly read of existing ADRs to catch stale ones.

**Team of 20–100:**

- Formal RFC process; template, review SLA, status lifecycle.
- Mandatory security review on anything touching PII or auth.
- Design system emerges, owned by a small group.
- Architecture diagrams (C4 context + container) kept up to date in-repo.

**100+ engineers:**

- Architecture guild / platform team owns cross-cutting decisions.
- Mandatory ADRs for anything cross-team.
- Dedicated design-system team.
- Published engineering playbook with API and data-model standards.

The numbers are rough. The direction is not: as the team grows, explicit written artefacts go up, because tacit knowledge no longer fits in everyone's head.

---

## Templates included in this chapter

1. **ADR (Nygard format)** — see the "Write ADRs for each major decision" section above.
2. **Design doc / RFC** — see the "Write a design doc / RFC" section above.
3. **Threat model worksheet (STRIDE on a diagram)** — use the template below.
4. **UX flow sketch** — use the template below.

**STRIDE threat model worksheet:**

```markdown
# Threat Model: <feature or surface name>

Author: <name>
Date: <YYYY-MM-DD>
Diagram: <link to the container/context diagram this applies to>

## Assets
What are we protecting? (data, capabilities, access)

## Trust boundaries
Where does trust change? (internet → edge, edge → app, app → DB, tenant
A → tenant B)

## Threats

| # | Element | STRIDE category | Threat | Response (accept/eliminate/mitigate/transfer) | Owner | Status |
|---|---|---|---|---|---|---|
| 1 | login endpoint | Spoofing | Credential stuffing | Mitigate: rate limit + MFA + breached-password check via IdP | @eng-lead | in progress |
| 2 | workspace_id filter | Info disclosure | Missing filter in a query leaks another tenant's data | Mitigate: RLS in Postgres + query-linter rule | @backend | accepted |
| ... | | | | | | |

## Top 3–5 risks
Summarise the highest-severity rows above, one-line each.

## Follow-ups
- <action, owner, date>
```

**UX flow sketch template:**

```markdown
# Flow: <name> (e.g., "First-time user creates a project")

User goal: <one sentence>
Entry point: <where does this start?>
Success condition: <what does "done" look like?>
Failure modes: <what could go wrong, and what do we show then?>

## Steps
1. <user action> → <system response> → <what user sees>
2. ...
3. ...

## Nielsen heuristics check
- Visibility of status: <how do we keep the user informed?>
- Error prevention: <what are we preventing?>
- Recovery: <what's the emergency exit?>
- (others as relevant)

## Accessibility notes
- Keyboard path?
- Screen reader announcements?
- Colour contrast for any state that relies on colour?

## Open questions
- <thing the designer wants input on>
```

---

## Exit checklist

You are done with Phase 03 when all of these are true:

- [ ] The 3–5 core user flows are drawn and reviewed.
- [ ] A C4 context diagram and container diagram exist and are up to date.
- [ ] An ADR exists for each of: deployment shape, primary data store, auth strategy, multi-tenancy model, API style.
- [ ] The core data model (entities, relationships, tenancy) is drawn.
- [ ] The API contract style (REST/GraphQL/gRPC) is chosen, with versioning and error shape documented.
- [ ] A threat model exists for the MVP: diagram, threats list, chosen responses.
- [ ] Non-functional targets exist for availability, latency, durability, and security.
- [ ] A design doc exists for every non-trivial project in the MVP.
- [ ] Accessibility target is explicit (WCAG 2.2 AA) and the UX has been reviewed against Nielsen's 10 heuristics.
- [ ] The team agrees the above are load-bearing — someone can pick them up and implement without re-asking basic questions.

If any box is un-ticked, that is debt you are carrying into Phase 04.

---

## Why this works

Each prescription in this chapter traces back to the research documents in [`../research/03-design/`](../research/03-design/):

- **Architecture as a stream of decisions, ADRs, and monolith-first bias** → [`../research/03-design/system-architecture.md`](../research/03-design/system-architecture.md) (Nygard 2011; Fowler's MonolithFirst, MicroservicePremium; Richardson's microservices.io; Dehghani; Microsoft Azure Architecture Center).
- **ADR template and mechanics** → [`../research/03-design/adrs.md`](../research/03-design/adrs.md) (Nygard 2011; adr.github.io).
- **REST-first API guidance and when to use GraphQL or gRPC** → [`../research/03-design/api-design.md`](../research/03-design/api-design.md) (Fielding; GraphQL spec; grpc.io; Google API Design Guide; Microsoft Azure and Graph API Guidelines).
- **Wireframes → prototype → hi-fi sequence, Nielsen's 10 heuristics, WCAG 2.2 AA, design-system adoption rule** → [`../research/03-design/ux-design.md`](../research/03-design/ux-design.md) (NNG Design Thinking 101; NNG Paper Prototyping; Nielsen's 10 Usability Heuristics; NNG Design Systems 101; W3C WAI; ADA; European Accessibility Act).
- **STRIDE threat modelling, OWASP four questions, ASVS and Top 10 context** → [`../research/03-design/security-design.md`](../research/03-design/security-design.md) (OWASP Threat Modeling; OWASP Threat Modeling Process; Microsoft STRIDE reference; OWASP ASVS; OWASP Top Ten; Microsoft Azure security guidance).
- **Design doc template, RFC process, and artefact relationships** → [`../research/03-design/design-docs-rfcs.md`](../research/03-design/design-docs-rfcs.md) (Ubl, *Design Docs at Google*, 2020; Frazelle, *RFD 1*, Oxide Computer, 2020).
- **Non-functional requirements — ISO/IEC 25010, Azure Well-Architected Framework, OpenTelemetry-based observability** → [`../research/03-design/system-architecture.md`](../research/03-design/system-architecture.md) (ISO/IEC 25010:2023; Azure Well-Architected Framework; Microsoft microservices observability guidance).

Where the research documents flag something as contested or unverified (e.g., PASTA, BDUF adoption evidence, the exact application date of the EAA), this chapter has not made load-bearing claims beyond what the sources support.
