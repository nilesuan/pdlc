# Phase 03 — Design: Process Breakdown

Companion to [`03-design.md`](03-design.md). The chapter describes *what* and *why*; this document details *how* — the discrete processes, their owners, their inputs and outputs, the cadence, and the exit gates.

**Last updated:** 2026-04-24.

## How to read this

- The 10 steps in the chapter map to 12 processes below. Some steps split because they have different owners at different cadences (ADR authorship happens per decision; design-doc authorship happens per project; both are reviewed under one async-review rhythm). Some processes support the others continuously (architecture diagrams, backlog of open decisions).
- Each process has: **purpose, RACI, triggers, inputs, activities, outputs, tools, cadence, exit gate, pitfalls.**
- RACI convention: **R**esponsible · **A**ccountable · **C**onsulted · **I**nformed.
- Defaults assume the **team-of-5** scale. Solo-founder and team-of-50+ variations called out where they change the process meaningfully.

## Process inventory

| # | Process | When | Owner (R) | Primary output |
|---|---|---|---|---|
| 1 | User Flow Mapping | Phase start; per new feature | PM + Design | 3–5 labelled flows, 5–10 steps each |
| 2 | System Architecture Sketching | Phase start; on structural change | Engineering lead | C4 context + container diagrams |
| 3 | ADR Authorship | At every load-bearing decision | Deciding engineer(s) | Numbered ADR in `/docs/adr/` |
| 4 | Data Model Design | Phase start; on new major entity | Engineering | ER diagram + entity lifecycle notes |
| 5 | API Contract Definition | Before any client work starts | Engineering | OpenAPI / schema + error shape + versioning |
| 6 | UX Sketching → Prototype → Hi-fi | Phase start; per feature | Design | Wireframes, prototype, hi-fi mocks (happy path) |
| 7 | Accessibility & Heuristic Review | Before hi-fi freeze | Design + 1 peer | Reviewed screens against Nielsen 10 + WCAG 2.2 AA |
| 8 | Threat Modelling | Per major feature | Engineering + Security | One-page STRIDE worksheet |
| 9 | Non-Functional Target Setting | Phase start; revisit quarterly | Eng lead + PM | NFR sheet (availability, latency, durability, security, scalability, observability) |
| 10 | Design Doc / RFC Authorship | Per non-trivial project | Author engineer | Approved design doc |
| 11 | Async Design Review | On every ADR / design doc | Author facilitates | Resolved comments, dated approval |
| 12 | Phase Exit & Handoff | End of phase | Eng lead + PM | Load-bearing artefact set handed to Phase 04 |

## Default RACI across the phase

| Role | Scope of accountability |
|---|---|
| **Product (PM)** | User-flow narrative, MVP scope boundary, "does this solve the Phase 01 problem?" acceptance. |
| **Design (UX)** | Wireframes, prototype, hi-fi, accessibility, heuristic review. |
| **Engineering (lead + ICs)** | Architecture, data model, API contracts, threat model, NFRs, ADRs. |
| **Security (shared or named)** | Reviews anything touching auth, PII, external integration, secrets. |
| **Stakeholders** | Consulted on scope; informed on design. Do not approve load-bearing technical decisions. |

One person **authors** each artefact; reviewers advise; the team commits. Fuzzy accountability is the main way design ceremonies degrade into theatre.

---

## Process 1 — User Flow Mapping

**Purpose.** Draw the 3–5 core user journeys end-to-end before any technical decisions are made, so every downstream artefact serves the user's path rather than the system's grain.

**RACI.** R: PM + Design (co-author) · A: PM · C: Engineering lead (feasibility check) · I: whole team.

**Triggers.** Phase 03 kickoff. New flow added when the roadmap opens a new theme or when a Phase 01 pivot reframes the user path.

**Inputs.**
- Validated problem statement (Phase 01).
- MVP scope + riskiest assumption (Phase 02).
- Evidence log quotes about current user tasks.

**Activities.**
1. **List the candidate flows (30 min).** Name every flow the user takes to achieve the MVP outcome.
2. **Pick the top 3–5.** Only flows on the MVP happy path; not every empty state or edge case.
3. **Sketch each flow (30 min per flow).** Paper, whiteboard, FigJam. Low fidelity. For each step: user action → system response → what the user sees next.
4. **Use the template (chapter §Templates):** user goal, entry point, success condition, failure modes, 5–10 numbered steps.
5. **Run Nielsen-heuristic spot check inline.** Visibility of status, error prevention, emergency exit. Note gaps for later Process 7 review.
6. **PM + Design sign jointly.** Pin flows in team wiki; link from design docs.

**Outputs.**
- One page per flow using the chapter template.
- Flow index on the team wiki linking all flows.

**Tools / templates.**
- UX flow sketch template (chapter §Templates).
- Paper, whiteboard, FigJam, Miro.

**Cadence / duration.**
- Phase start: half-day for 3–5 flows. Per new feature: 1–2 hours.

**Exit gate.**
- 3–5 flows on the MVP path are drawn, named, and owned.
- Each flow has a success condition and named failure modes.
- Engineering lead has read each flow and flagged no feasibility blockers.

**Pitfalls.**
- Starting in Figma with pixel-perfect mocks. Low fidelity first; pretty follows.
- Designing for a hypothetical expert user. The flow must work for the user described in the Phase 01 segment definition.
- Too many flows. If you draw 10, you haven't picked an MVP.

---

## Process 2 — System Architecture Sketching

**Purpose.** Produce a C4 context diagram and container diagram (Simon Brown's C4 model is the reference frame) so the whole team shares a mental model of the system at two levels of resolution.

**RACI.** R: Engineering lead · A: Engineering lead · C: senior engineers, PM (scope), Design (surfaces) · I: whole team.

**Triggers.** Phase 03 kickoff. Re-run on any structural change (new container, new data store, new external dependency).

**Inputs.**
- User flows (Process 1).
- Product strategy + MVP scope (Phase 02).
- Architectural defaults table (chapter §Architectural defaults for small teams).
- Team skill map (runtime, language, framework experience).

**Activities.**
1. **Context diagram first (60 min).** One box = the system. Surround it with users and external systems. Name the integrations.
2. **Container diagram next (90–120 min).** Open the system box into deployable units: web app, API, worker, database, cache, queue. Name the protocol on each arrow.
3. **Apply the defaults** (modular monolith + single Postgres + managed runtime + queue + managed auth provider + managed secrets manager). Deviate only with a named reason.
4. **Identify the "bet the company" decisions (per chapter Step 2).** Each gets an ADR in Process 3: deployment shape, primary data store, auth, multi-tenancy, synchrony, runtime.
5. **Annotate trust boundaries** (internet → edge, edge → app, app → DB, tenant isolation). Feeds Process 8.
6. **Store diagrams in-repo** alongside the code (Structurizr, Mermaid, or committed PNGs with source files).

**Outputs.**
- C4 context diagram.
- C4 container diagram.
- List of "bet the company" decisions requiring ADRs (feeds Process 3).
- Annotated trust boundaries (feeds Process 8).

**Tools / templates.**
- C4 model reference ([c4model.com](https://c4model.com)).
- Structurizr, Mermaid, draw.io, or Excalidraw.

**Cadence / duration.**
- Initial: 1 day. On change: 30–60 min to update.

**Exit gate.**
- Context + container diagrams committed in-repo.
- Every deployable container is named, with a runtime and a protocol.
- Every bet-the-company decision has a queued ADR task.

**Pitfalls.**
- Premature microservices. Fowler's "MicroservicePremium" — don't pay the tax without the scale.
- Diagrams in a wiki instead of the repo. They drift.
- Hand-waving trust boundaries. If boundaries are fuzzy, Process 8 will miss real threats.

---

## Process 3 — ADR Authorship

**Purpose.** Capture each load-bearing decision as a dated ADR in Nygard format, so the reasoning survives the team that made it.

**RACI.** R: deciding engineer(s) · A: Engineering lead · C: peers on affected surfaces, Security (if security-relevant) · I: whole team.

**Triggers.** Any decision matching the chapter's "What deserves an ADR" list. Specifically: architecture shape, primary data store, auth strategy, multi-tenancy, synchrony, language/framework, API style, significant vendor commitment.

**Inputs.**
- The decision at hand, phrased as a noun-phrase.
- Current forces (team size, compliance, traffic forecast, skill map).
- Alternatives considered and why rejected.
- Context and container diagrams from Process 2.

**Activities.**
1. **Draft (60–90 min, author).** Use the chapter's Nygard template: Status, Context, Decision, Consequences.
2. **Context in value-neutral language.** Describe the forces; no justification yet.
3. **Decision as full sentence, active voice.** "We will X so that Y."
4. **Consequences split into Positive, Negative, Neutral/Follow-ups.** Name the trigger conditions under which the decision becomes suspect.
5. **Number sequentially.** `/docs/adr/NNN-short-name.md`. Never reuse a number.
6. **Submit for Async Review (Process 11).** Do not publish without review.
7. **On supersession:** write a new ADR with `Status: superseded by ADR-MMM`. Link forward from the old ADR. Never edit the old in place.

**Outputs.**
- Numbered ADR committed to `/docs/adr/`.
- Status lifecycle: proposed → accepted / deprecated / superseded.
- Linked revisit trigger (when reality will invalidate this).

**Tools / templates.**
- Nygard ADR template (chapter Step 3).
- `adr-tools` CLI (optional) or plain markdown.

**Cadence / duration.**
- As needed. 60–120 min per ADR including review resolution.

**Exit gate (per ADR).**
- ADR is numbered, dated, and committed.
- At least one reviewer other than the author has signed off (Process 11).
- Status is `accepted` before downstream work depends on it.

**Pitfalls.**
- Writing ADRs after the fact. The Context evaporates; retrofitting loses the reasoning.
- Writing "Decision" as a title only. State what was decided in a sentence.
- Skipping revisit triggers. An ADR with no "when this is wrong" clause is a commitment, not a decision.
- Re-using ADR numbers or editing accepted ADRs in place. Breaks the log.
- Writing an ADR for a non-architectural choice (linter rules, folder structure). Dilutes the channel.

---

## Process 4 — Data Model Design

**Purpose.** Identify the 10–30 entities that matter, draw relationships, and define each entity's lifecycle and access pattern.

**RACI.** R: senior engineer or engineering lead · A: Engineering lead · C: PM (domain language), Design (UI data shape) · I: whole team.

**Triggers.** Phase 03 kickoff. On every new major entity or schema change.

**Inputs.**
- User flows (Process 1).
- API contract sketches (Process 5, iterative).
- Ubiquitous domain language from Phase 01 evidence log.
- Multi-tenancy decision from Process 3.

**Activities.**
1. **List entities (30 min).** Roughly 10–30 for an MVP; fewer if truly small.
2. **Draw ER diagram** in dbdiagram.io, Figma, or committed Mermaid.
3. **For each major entity, answer:** what creates it; what updates it and who's allowed; what ends its life (soft delete, hard delete, archive); who can read it under what filter (tenant/role/ownership); append-only or mutable?
4. **Name in the domain's language.** If customers say "account" but the schema says "organisation," fix the schema.
5. **Identify bounded contexts.** If a "User" means different things in Billing vs Identity vs Reporting, name them distinctly.
6. **Default identifier shape.** UUIDs for externally visible IDs; incremental integers are acceptable internally.
7. **Default timestamps on every row.** `created_at`, `updated_at`, `deleted_at` if soft-delete is used.
8. **Default tenant scoping.** Every tenant-scoped row gets `workspace_id` (or equivalent) from day one, even with one tenant.
9. **Label PII columns.** `pii: true` in schema comment or a central classification doc. Feeds Process 8 threat model.

**Outputs.**
- ER diagram committed to repo.
- Per-entity lifecycle notes.
- PII classification mapping.

**Tools / templates.**
- dbdiagram.io, Mermaid, Figma.
- Framework ORM migrations as the source of truth for the shipping schema.

**Cadence / duration.**
- Initial: 1–2 days. Per change: 30–60 min.

**Exit gate.**
- ER diagram covers every entity referenced in the MVP user flows.
- Every tenant-scoped row has a tenancy column.
- PII is labelled.

**Pitfalls.**
- Bottom-up modelling (starting from "we'll need a database"). The schema ends up storing things, not serving flows.
- Adding tenancy later. Retrofitting is painful; add `workspace_id` on day one even with one tenant.
- Ignoring soft-delete vs hard-delete. Audit and recovery requirements will force a choice later; decide now.
- Skipping the ubiquitous-language check. A schema that disagrees with the business dialect costs clarity in every meeting.

---

## Process 5 — API Contract Definition

**Purpose.** Decide API style and publish a contract the frontend / clients can build against.

**RACI.** R: senior engineer (contract author) · A: Engineering lead · C: Design (client needs), PM (scope) · I: whole team.

**Triggers.** Before any client code is written. Re-run before any breaking change.

**Inputs.**
- User flows (Process 1).
- Data model (Process 4).
- API-style ADR (Process 3: REST vs GraphQL vs gRPC).
- Error shape decision.

**Activities.**
1. **Confirm the style.** REST/JSON over HTTPS by default. Deviate only with ADR justifying GraphQL or gRPC.
2. **Write the OpenAPI / schema file** and commit it. For REST: OpenAPI 3.1. For GraphQL: schema.graphql. For gRPC: .proto files.
3. **Apply chapter rules for REST:**
   - Resource-oriented URLs (`/workspaces/{id}/members`, not `/getWorkspaceMembers`).
   - Standard verbs and status codes (200/201/204 success; 400/401/403/404/409/422/429; 5xx).
   - Versioning from day one: `/v1/` in path.
   - Cursor pagination for anything that grows.
   - Idempotency keys on mutating endpoints.
   - One error shape: `{"error": {"code", "message", "details"}}`.
   - No PII in URLs.
4. **Generate client / server stubs** from the schema (openapi-generator, graphql-codegen, protoc).
5. **Publish the contract** to the team wiki with a `CHANGELOG` on breaking vs non-breaking changes.
6. **Contract tests scaffolded (spec only now; implementation in Phase 05).**

**Outputs.**
- Schema file committed to repo (OpenAPI, GraphQL schema, or .proto).
- Error-shape documentation.
- Versioning + deprecation policy in-repo.

**Tools / templates.**
- OpenAPI 3.1, Swagger / Redoc, or Stoplight.
- Google API Design Guide; Microsoft Graph / Azure API Guidelines.

**Cadence / duration.**
- Initial contract: 1–2 days. Per change: 60–120 min + review.

**Exit gate.**
- Schema committed and renders.
- Versioning and error shape decided and documented.
- At least one client surface has started implementing against it.

**Pitfalls.**
- No versioning. Every API becomes a versioning problem eventually — add `/v1/` now.
- Multiple error shapes. Client code pays the tax on every new endpoint.
- GraphQL for a single frontend. Overkill until there are heterogeneous clients.
- gRPC for external APIs. REST is the web's grain; gRPC earns its weight internally.
- PII in URL paths. Logs, proxies, browser histories all see them.

---

## Process 6 — UX Sketching → Prototype → Hi-fi

**Purpose.** Progress UX artefacts from cheap (sketch) to expensive (hi-fi) only for flows that have survived user contact.

**RACI.** R: Design · A: Design lead · C: PM (scope), Engineering (feasibility), 3–5 users (for prototype test) · I: whole team.

**Triggers.** Per flow identified in Process 1.

**Inputs.**
- User flow sketches (Process 1).
- MVP scope doc (Phase 02).
- Design system (adopted, not built — shadcn/ui for React, Material for mobile, framework default otherwise).

**Activities.**
1. **Paper or whiteboard sketches (30 min per flow).** NNG: "you can user test early design ideas at an extremely low cost."
2. **Low-fi wireframes in Figma.** Grey boxes, lorem ipsum, no colour.
3. **Interactive prototype for the MVP happy path only.** Clickable enough to test with 3–5 users.
4. **User-test the prototype** (5 moderated sessions, ~30 min each). Fix what breaks. Iterate.
5. **Hi-fi mocks for MVP happy path only.** Error states, empty states, edge cases get mocks only when non-obvious.
6. **Spec with engineering.** Annotate breakpoints, states, interaction details that aren't in the design system.

**Outputs.**
- Paper sketches.
- Lo-fi wireframes in Figma.
- Interactive prototype.
- Hi-fi mocks for MVP happy path.
- User-test notes (5 sessions).

**Tools / templates.**
- Figma (or Sketch, Penpot).
- Prototype tooling (Figma prototypes, Maze, UserTesting).

**Cadence / duration.**
- Per flow: 3–5 days spread across the phase.

**Exit gate (per flow).**
- Hi-fi exists only for user-tested happy path.
- No pixel-perfect mocks for untested flows.

**Pitfalls.**
- Starting in hi-fi. Ugly-that-works beats pretty-that-doesn't.
- Skipping user tests because "the team knows the user." You don't, yet.
- Building a design system before 3+ product surfaces exist. Adopt one; don't build.
- Mocking every error state. Only mock the non-obvious ones.

---

## Process 7 — Accessibility & Heuristic Review

**Purpose.** Ensure the UX meets WCAG 2.2 AA and passes Nielsen's 10 heuristics before hi-fi is frozen.

**RACI.** R: Design · A: Design lead · C: 1 peer designer or engineer, accessibility-aware reviewer · I: whole team.

**Triggers.** Before hi-fi freeze on any new flow. Re-run when a flow changes materially.

**Inputs.**
- Hi-fi mocks (Process 6).
- Nielsen's 10 heuristics checklist.
- WCAG 2.2 AA success criteria.

**Activities.**
1. **Heuristic evaluation (60 min per flow).** Walk each Nielsen heuristic against each screen. Log violations.
2. **WCAG 2.2 AA checklist:**
   - Contrast ratios (4.5:1 body text, 3:1 large text).
   - Keyboard operability on every interactive element.
   - Visible focus indicators.
   - Semantic HTML (headings, landmarks, form labels).
   - Alt text on meaningful images.
   - Skip links.
   - Heading hierarchy.
3. **Manual screen-reader test.** VoiceOver (macOS/iOS), NVDA (Windows), TalkBack (Android). Do not rely on automated checkers alone.
4. **Fix critical violations before hi-fi freeze.** Log non-critical for Phase 04 follow-up.
5. **Accessibility notes in the design doc** (Process 10).

**Outputs.**
- Heuristic + WCAG review notes per flow.
- Fixed violations captured in the design source of truth.
- Accessibility section in the design doc.

**Tools / templates.**
- axe-core (automated scan, feeds Phase 05).
- Color-contrast checkers (WebAIM).
- Screen readers: VoiceOver, NVDA, TalkBack.

**Cadence / duration.**
- Per flow: 90–120 min review + fix time.

**Exit gate (per flow).**
- No WCAG 2.2 AA violations outstanding on the MVP happy path.
- Nielsen heuristic violations either fixed or logged with a reason to defer.

**Pitfalls.**
- Relying on automated checkers only. They catch 30–40% of real issues.
- Reviewing at the last minute. Fixes are cheaper in Figma than in code.
- Treating accessibility as a launch-blocker checklist instead of a design quality baseline.
- Colour-only state indicators. Always add icon or text for colourblind users.

---

## Process 8 — Threat Modelling

**Purpose.** Apply STRIDE against the container diagram and produce a list of top risks with chosen responses (accept / eliminate / mitigate / transfer).

**RACI.** R: senior engineer + Security (if staffed) · A: Engineering lead · C: PM, external security if available · I: whole team.

**Triggers.** Per major feature or surface. Re-run annually for the whole system. Re-run on any change that modifies trust boundaries.

**Inputs.**
- C4 container diagram (Process 2).
- Annotated trust boundaries.
- Data model with PII classification (Process 4).
- Current OWASP Top 10 and ASVS.

**Activities.**
1. **OWASP's four questions (one hour per feature):**
   - What are we working on?
   - What can go wrong?
   - What are we going to do about it?
   - Did we do a good job?
2. **Walk STRIDE against every element in the diagram.** Actors, data stores, processes, data flows, trust boundaries.
   - **S**poofing: auth-bypass paths.
   - **T**ampering: data-in-transit and data-at-rest modification.
   - **R**epudiation: actions that need audit trails.
   - **I**nformation disclosure: tenant leakage, PII exposure, verbose errors.
   - **D**enial of service: rate limits, resource exhaustion.
   - **E**levation of privilege: authz gaps.
3. **For each threat, pick a response:** accept / eliminate / mitigate / transfer. Assign owner.
4. **Identify top 3–5 risks.** Surface to the team.
5. **Log in the STRIDE worksheet template** (chapter §Templates) and attach to the architecture diagram.
6. **Feed mitigations** into design docs (Process 10) and into the backlog.

**Outputs.**
- One-page STRIDE worksheet per feature.
- Top 3–5 risk list with owners and responses.
- Backlog items for each mitigation.

**Tools / templates.**
- STRIDE worksheet template (chapter §Templates).
- Microsoft Threat Modeling Tool, OWASP Threat Dragon, or whiteboard.
- OWASP Top 10, OWASP ASVS.

**Cadence / duration.**
- Per feature: 60–90 min + write-up. Annual: half-day.

**Exit gate (per feature).**
- Worksheet exists and is attached to the diagram.
- Top 3–5 risks have owners and responses.
- Mitigation backlog items are created.

**Pitfalls.**
- Skipping because "we're small." Attackers don't care how small you are; cost of a leak is the company.
- Generic threat lists with no responses. A threat without a response is just anxiety.
- Modelling the wrong thing. STRIDE against a feature people don't use is wasted effort; focus on auth, data, external integrations, admin paths.
- Custom auth. Almost never mitigated adequately by a small team. Use an IdP.

---

## Process 9 — Non-Functional Target Setting

**Purpose.** Decide concrete targets for availability, latency, durability, security, scalability, and observability — even targets you will miss.

**RACI.** R: Engineering lead + PM (co-author) · A: Engineering lead · C: founders (viability), SRE if staffed · I: whole team, exec.

**Triggers.** Phase 03 kickoff. Revisit quarterly or after any outage that reshapes expectations.

**Inputs.**
- MVP traffic forecast (Phase 02).
- Compliance or regulatory context (if any).
- ISO/IEC 25010 characteristic list.
- Azure WAF pillars (Reliability, Security, Cost, Operational Excellence, Performance).
- OpenTelemetry as the observability interoperable layer.

**Activities.**
1. **Pick defaults:**
   - Availability: 99.5% monthly (year one), 99.9% as stretch.
   - Latency: P95 < 500 ms interactive endpoints; P95 < 2 s page loads.
   - Durability: zero lost committed writes; RPO ≤ 5 min, RTO ≤ 1 hour.
   - Security: WCAG 2.2 AA; OWASP Top 10 addressed; secrets in a manager.
   - Scalability: 10× MVP traffic without redesign; 100× may require redesign.
   - Observability: structured logs, RED metrics per endpoint, distributed tracing on critical paths, from day one.
2. **Deviate with justification.** Tighter targets require tighter controls; looser targets must be stated to stakeholders.
3. **Publish the NFR sheet.** One-page, pinned alongside strategy and architecture diagrams.
4. **Wire measurement now, not at launch.** Observability scaffolding committed during Phase 04 enables the NFRs to be verified.
5. **Cross-check against Azure WAF pillars.**

**Outputs.**
- One-page NFR target sheet pinned in team wiki.
- Observability plan referencing OpenTelemetry wiring.
- Named quarterly review date.

**Tools / templates.**
- ISO/IEC 25010:2023 characteristic list.
- Azure Well-Architected Framework review.
- OpenTelemetry specification.

**Cadence / duration.**
- Initial: half-day. Quarterly: 60–90 min.

**Exit gate.**
- Every NFR has a number and a measurement plan.
- Observability plan names the minimum signals (logs, RED metrics, traces).
- Targets are reviewable in Phase 07 (Run) against actual measurements.

**Pitfalls.**
- Unfalsifiable targets ("we should be reliable"). Put numbers on them or drop them.
- Copying 99.99% availability without the controls to back it. Honest 99.5% beats aspirational 99.99%.
- Skipping observability wiring until after launch. You cannot retrofit signal into a running outage.

---

## Process 10 — Design Doc / RFC Authorship

**Purpose.** For any non-trivial project, author a design doc that names the problem, proposed design, alternatives, and cross-cutting concerns — sized 2–5 pages for small teams.

**RACI.** R: author engineer(s) · A: Engineering lead · C: peers on affected surfaces, Design, Security, PM · I: whole team.

**Triggers.** When at least one of these is true:
- Change crosses module or service boundaries.
- New data store or significant schema change.
- New or changed public API.
- Security-sensitive (auth, authz, PII, secrets).
- Hard to undo.
- 3+ engineers working in parallel.

**Inputs.**
- Problem statement, relevant Phase 01/02 artefacts.
- User flows (Process 1).
- Relevant ADRs (Process 3).
- Data model (Process 4), API contract (Process 5), threat model (Process 8), NFRs (Process 9).

**Activities.**
1. **Draft using the chapter template (Step 9).** Context, Goals, Non-goals, Proposed design (with diagrams), Alternatives considered, Cross-cutting concerns, Open questions, Rollout plan.
2. **Non-goals are non-optional.** Without them, reviewers re-litigate scope.
3. **Alternatives: 2–3 real ones, with rejection reasons.** If there are none, you haven't looked.
4. **Cross-cutting concerns section:** security / threat model summary, privacy, observability, reliability, performance, cost, migration.
5. **Open questions section is the point.** That's where reviewer input is most useful.
6. **Submit for Async Review (Process 11).**
7. **Mark approved + dated** when Process 11 closes.

**Outputs.**
- Design doc (2–5 pages typical; up to 10 for larger projects).
- Status lifecycle: draft → in review → approved / rejected / superseded.
- Dated approval.

**Tools / templates.**
- Chapter design-doc template (Step 9).
- Ubl "Design Docs at Google" for reference at scale.
- Oxide "RFD 1" as an alternative lightweight process.

**Cadence / duration.**
- Per project: 1–2 days drafting + review cycle (3–5 days total).

**Exit gate (per doc).**
- Template fields all filled (or explicitly N/A).
- Open questions resolved or deferred with a reason.
- Dated approval recorded in the doc itself.
- Reviewers with no blocking objections.

**Pitfalls.**
- One giant doc covering everything. Nobody reads it. Split by decision (ADR) and by project (design doc).
- Skipping Alternatives. Signals the author didn't explore.
- Skipping Non-goals. Invites scope creep during review.
- Sign-off as theatre. If reviewers have no comments, they haven't read.
- Doc for a bug fix or a refactor inside one module. Overkill.

---

## Process 11 — Async Design Review

**Purpose.** Resolve design-doc and ADR comments asynchronously, with a short synchronous session only to close residual questions.

**RACI.** R: author facilitates · A: author · C: named reviewers (engineer, design, security, product as relevant) · I: whole team.

**Triggers.** Author ships a draft ADR or design doc.

**Inputs.**
- Draft ADR or design doc.
- Named reviewers (minimum one peer engineer; add design if UX is involved; security if PII/auth/integration; product for scope alignment).
- Review SLA (default: 2 business days to first-pass comments).

**Activities.**
1. **Author circulates.** Post link in the team channel, ping named reviewers.
2. **Async commenting (2 business days default).** Reviewers leave inline comments with severity: blocking / non-blocking / nit.
3. **Author resolves comments.** Either fix the doc or reply with a rationale.
4. **Synchronous close (30–60 min).** Only if residual blocking comments remain. Not a re-read — attendees have already read.
5. **Dated approval recorded in the doc** once: (a) author believes the approach will work, (b) no blocking objections, (c) open-questions section is empty or contains deferred items.
6. **Archive.** The doc stays in-repo, dated, unchanged except for supersession.

**Outputs.**
- Resolved comment thread.
- Dated approval line in the doc.
- Linked forward from the next superseding doc (if eventually superseded).

**Tools / templates.**
- Whatever hosts the doc: Google Docs, Notion, GitHub PR comments, Linear docs.
- Review SLA documented in team wiki.

**Cadence / duration.**
- Async: 2 business days. Sync close (if needed): 30–60 min.

**Exit gate (per review).**
- Every blocking comment resolved.
- Date of approval in the doc.
- Author and at least one peer reviewer on-record.

**Pitfalls.**
- Sync review used to re-read the doc. Dead weight. Read beforehand.
- Sign-off without comments. Nobody has read. Push back.
- Missing security review on security-sensitive docs. Hard block until a security-aware reviewer has signed.
- Review dragged out for weeks. If the SLA is chronically missed, the team has other issues.

---

## Process 12 — Phase Exit & Handoff to Phase 04

**Purpose.** Verify the design artefacts are complete, consistent, and load-bearing — then hand off so Phase 04 (Build) can start without backfilling.

**RACI.** R: Engineering lead + PM · A: Engineering lead · C: Design lead, founders · I: whole team.

**Triggers.** Chapter exit checklist can be ticked (or gaps have named owners + dates).

**Inputs.**
- All Phase 03 artefacts: user flows, C4 diagrams, ADRs, data model, API contract, threat model, NFRs, design docs, UX hi-fi + accessibility review.
- Phase 02 handoff package.

**Activities.**
1. **Pre-read (async, 48h).** Whole team skims the artefact set.
2. **Exit review meeting (60–90 min):**
   - Engineering lead walks diagrams + ADRs (20 min).
   - Design lead walks UX + accessibility review (15 min).
   - Security walks threat model (10 min).
   - PM walks user-flow-to-scope coverage (10 min).
   - Open gaps discussion (15 min).
   - Decision: proceed / not yet (10 min).
3. **Write decision record** (ADR-style): context, decision, open risks carried into Phase 04.
4. **Hand the Phase 04 team the package.**

**Outputs.**
- Signed decision record.
- Handoff package:
  1. User flows (Process 1).
  2. C4 context + container diagrams (Process 2).
  3. ADRs for all load-bearing decisions (Process 3).
  4. Data model (Process 4).
  5. API contract (Process 5).
  6. UX hi-fi + accessibility review notes (Processes 6, 7).
  7. Threat model (Process 8).
  8. NFR target sheet (Process 9).
  9. Design docs for all non-trivial projects (Process 10).

**Tools / templates.**
- Decision-record template (ADR-style).

**Cadence / duration.**
- One meeting + 1–2 days write-up.

**Exit gate (phase).**
- Every chapter-exit-checklist item is yes or has a named owner + close date.
- Engineering lead and Design lead both sign off.
- Any carried risks are logged in the Phase 04 backlog.

**Pitfalls.**
- Proceeding with ADRs missing on load-bearing decisions. Build discovers them as arguments.
- Proceeding without a threat model. Security emerges as a crisis in Phase 07.
- Handing off hi-fi for flows that were never user-tested. Build ships the wrong thing faster.
- Letting "we'll document after build" become the plan. Retrofitting artefacts after code is written is how design theatre happens.

---

## Weekly rhythm (how these processes stack)

A condensed 3-week Phase 03 for a team-of-5:

| Week | Focus | Processes |
|---|---|---|
| **Week 1** | User flows + architecture skeleton | 1, 2; start 3 for biggest decisions |
| **Week 2** | Data model, API contract, UX wireframes, threat model | 4, 5, 6 (lo-fi), 8 |
| **Week 3** | Hi-fi, accessibility review, design docs, async review, exit | 6 (hi-fi), 7, 9, 10, 11, 12 |

Process 3 (ADRs) and Process 11 (async review) are continuous across all three weeks. Process 9 (NFRs) is decided in Week 1 and revisited at exit.

---

## Scale notes

- **Solo founder.** Collapse to one-page design notes per project. Skip the formal RFC process; pair review by writing your own ADR and reading it with fresh eyes the next day. Keep Processes 1, 2, 3 (3–5 ADRs in year one), 4, 8 (abbreviated), 9.
- **Team of 5.** This document's default.
- **Team of 20+.** Process 10 becomes a formal RFC with template, review SLA, status lifecycle. Security review mandatory on PII/auth/external surfaces. A small architecture guild owns cross-cutting ADRs. A design-system team emerges. C4 diagrams kept in-repo with CI that rejects PRs that break the diagram source.
- **Team of 100+.** Platform/architecture team owns cross-cutting decisions. Mandatory ADRs for anything cross-team. Dedicated design-system team. Published engineering playbook with API and data-model standards.

---

## Handoff to Phase 04

On proceed from Process 12, Phase 04 (Build) should receive:

1. User flows (Process 1).
2. C4 context + container diagrams (Process 2).
3. All accepted ADRs (Process 3).
4. Data model + PII classification (Process 4).
5. API contract committed in-repo (Process 5).
6. Hi-fi mocks with annotated states (Process 6).
7. Accessibility review notes with any deferred items (Process 7).
8. Threat model worksheet with top risks (Process 8).
9. NFR target sheet (Process 9).
10. Approved design docs for non-trivial projects (Process 10).

Phase 04 should not accept a handoff missing items 2, 3 (for load-bearing decisions), 5, or 9.
