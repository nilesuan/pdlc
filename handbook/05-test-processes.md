# Phase 05 — Test: Process Breakdown

Companion to [`05-test.md`](05-test.md). The chapter describes *what* and *why*; this document details *how* — the discrete processes, their owners, their inputs and outputs, the cadence, and the exit gates.

**Last updated:** 2026-04-24.

## How to read this

- Testing is continuous, not time-boxed. The chapter's 7 "levels of testing" + non-functional + production testing + exploratory themes decompose into 14 processes below. Many are per-PR or per-release; several are one-time setup or quarterly rituals.
- Each process has: **purpose, RACI, triggers, inputs, activities, outputs, tools, cadence, exit gate, pitfalls.**
- RACI convention: **R**esponsible · **A**ccountable · **C**onsulted · **I**nformed.
- Defaults assume the **team-of-5** scale. Solo and team-of-50+ variations called out where they change the process meaningfully.

## Process inventory

| # | Process | When | Owner (R) | Primary output |
|---|---|---|---|---|
| 1 | Testing Strategy Selection | Phase kickoff; revisit annually | Engineering lead + SDET (if present) | Chosen shape (pyramid or trophy), coverage floor, level scope |
| 2 | Unit Test Authorship | Per feature, per bug fix | Feature engineer | Fast, isolated, deterministic tests |
| 3 | Integration Test Authorship | Per cross-boundary feature | Feature engineer | testcontainers-backed integration tests |
| 4 | Contract Test Authorship | Per consumer-provider pairing | Consumer engineer | Pact contract published + provider verification |
| 5 | E2E Smoke Authorship | Per golden path | QA/SDET or senior engineer | 3–10 Playwright tests on critical journeys |
| 6 | ATDD/BDD Authorship | When business co-authors scenarios | PM + engineer | Given/When/Then acceptance tests |
| 7 | Performance Test Authorship & Baseline | Phase kickoff; per critical-path change | SRE or platform engineer | k6 scripts + baseline + regression threshold |
| 8 | Security Testing Setup | Phase kickoff | Platform/security engineer | SAST + DAST + SCA + secrets scanning in CI |
| 9 | Accessibility Testing | Per UI feature; pre-release | Design + engineer | axe-core clean + manual keyboard + screen reader pass |
| 10 | Flaky Test Quarantine & Cleanup | Continuous | On-call engineer + SDET | Quarantined tests fixed or deleted ≤2 weeks |
| 11 | Test Data Management | Continuous | Engineer per fixture | Versioned fixtures + synthetic data generators |
| 12 | CI Pipeline Orchestration | Phase kickoff; on slowdown | Platform engineer | <30 min pipeline, <10 min commit build |
| 13 | Exploratory Testing Session | Pre-release; on new area | Engineer or tester | Session report + logged issues |
| 14 | Production Testing (Canary / Dark Launch / A/B) | Per rollout | Feature engineer + SRE | Promote / rollback decision |

Phase 05 runs alongside and continuously with Phase 04 and Phase 06.

## Default RACI across the phase

| Role | Scope of accountability |
|---|---|
| **Engineers** | Author unit, integration, most E2E tests; own tests for their code. Everyone tests. |
| **SDET / test-platform engineer (if present, typically at 30–50 eng)** | Test infrastructure, fixture library, flaky-test dashboard, teaching. A multiplier, not a bug-catcher. |
| **Product / Design** | Acceptance criteria → ATDD/BDD scenarios. Participate in exploratory sessions. |
| **SRE / platform** | Performance baselines, security scanning infrastructure, chaos experiments. |
| **QA lead (if any)** | Coaches the whole team's testing skill. Does not gate. |

Shift-left is the organizing principle: testing starts at the earliest commit and is authored by the engineers who wrote the code.

---

## Process 1 — Testing Strategy Selection

**Purpose.** Pick the shape (pyramid or trophy), set the coverage floor, and decide which levels apply — so every engineer knows where a new test belongs.

**RACI.** R: Engineering lead + SDET (if present) · A: Engineering lead · C: whole team, PM, SRE · I: exec.

**Triggers.** Phase kickoff. Revisit annually or on major architectural shift (new service, new frontend paradigm, move to event-driven).

**Inputs.**
- Architecture shape (monolith, modular monolith, services) from Phase 03.
- Team skill map.
- Current pain points (slow feedback, flaky tests, missed regressions).
- DORA metrics baseline (Phase 06).

**Activities.**
1. **Pick the shape.** Pyramid by default. Trophy if the product is a heavy frontend SPA and unit tests aren't catching integration-shaped bugs.
2. **Set the coverage floor.** 70–80% on business logic. No hard ceiling.
3. **Scope each level:**
   - Unit: fast, isolated, deterministic. Milliseconds each.
   - Integration: real dependencies via testcontainers. Seconds each.
   - Contract: only if 2+ independently-deployed services.
   - E2E: 3–10 golden paths.
   - ATDD/BDD: only if business co-authors.
4. **Write the strategy doc.** One page pinned in team wiki.
5. **Calibrate examples:** name 3–5 reference tests per level so engineers have an anchor.
6. **Set flakiness policy** (Process 10): quarantine on first flake, 2-week fix-or-delete.

**Outputs.**
- One-page test strategy doc.
- Reference tests per level.
- Flakiness policy.

**Tools / templates.**
- Team wiki.
- Strategy one-pager template.

**Cadence / duration.**
- Initial: half-day. Annual review: 90 min.

**Exit gate.**
- Every engineer can state the shape + coverage floor + level scope from memory within a week.
- Reference tests published per level.

**Pitfalls.**
- 100% coverage as the goal. Smells of tests written to satisfy the number.
- Pyramid as ideology instead of heuristic. Pick the trophy if context warrants.
- No coverage floor at all. The team will drift.
- Skipping the calibration examples. Engineers will default to whatever level is easiest for them personally.

---

## Process 2 — Unit Test Authorship

**Purpose.** Author fast, isolated, deterministic tests of single behaviors alongside the code.

**RACI.** R: feature engineer · A: engineer · C: reviewer · I: —.

**Triggers.** New function / class / module (per Phase 04 Process 2). Bug fix (always — write the failing regression test first).

**Inputs.**
- Feature acceptance criteria or bug repro.
- Existing unit test patterns (reference tests from Process 1).
- Meszaros test double taxonomy (dummy / fake / stub / spy / mock).

**Activities.**
1. **TDD when it fits** (non-trivial logic, tricky algorithms, bug fixes). Red → Green → Refactor.
2. **Arrange-Act-Assert** (or Given-When-Then) structure.
3. **Name the behavior:** `it("returns null when the user has no subscription")`.
4. **Assert behavior, not implementation.** No "it called `db.save` once" unless the interaction itself is the contract.
5. **Prefer sociable tests** (real collaborators). Use doubles only when collaborations are awkward (remote services, external resources).
6. **Prefer fakes over mocks** when a double is needed. `InMemoryUserRepository` beats a mock that freezes shape.
7. **Keep each test under milliseconds.** A slow unit test is a miscategorized integration test.
8. **One behavior per test.** Multiple asserts on the same behavior are fine; asserting two different behaviors is two tests.

**Outputs.**
- Passing unit tests committed with the code change.
- Coverage contribution on new code.

**Tools / templates.**
- Language test runner (pytest, vitest, jest, go test, rspec).
- Test double library (optional; fakes often hand-written).
- Coverage tool (coverage.py, c8, go test -cover).

**Cadence / duration.**
- Per feature / fix. Typically 25–50% of feature time.

**Exit gate (per PR).**
- Every new behavior has a test.
- Every fixed bug has a regression test.
- All unit tests pass in <60s locally.
- New code coverage ≥ the floor (70–80%).

**Pitfalls.**
- Mocking everything. Tests pass while the system is broken.
- Change-detector tests mirroring implementation. Break on every refactor.
- Tests that call a network or a real DB. Not unit tests — move to integration.
- Interleaved setup and assertions. Hard to read.
- Testing the framework. Delete those.

---

## Process 3 — Integration Test Authorship

**Purpose.** Verify real components — code + database, code + cache, two internal modules — actually collaborate.

**RACI.** R: feature engineer · A: engineer · C: reviewer · I: —.

**Triggers.** Feature crosses an integration boundary (DB, queue, cache, another internal module, external API via stub).

**Inputs.**
- Testcontainers or equivalent for real Postgres/Redis/Kafka.
- Seed data in version control.
- Stubs for external APIs (recorded fixtures or local stub servers).

**Activities.**
1. **Spin up real dependencies** via testcontainers (local + CI).
2. **Narrow scope:** one integration point per test.
3. **Seed data inside the test** so failures reproduce.
4. **Do not mock internal boundaries.** If module A calls module B in the same deployable, let them.
5. **Do mock external boundaries.** Third-party APIs, payment processors, email providers.
6. **Tear down test state.** Transactions rolled back or fresh container per suite.
7. **Accept seconds-per-test duration.** That's the trade.

**Outputs.**
- Passing integration tests committed with the change.
- Seed fixtures / factories in repo.
- External API stubs documented.

**Tools / templates.**
- Testcontainers (JVM, .NET, Go, Python, Node).
- Docker Compose for local full-stack.
- WireMock / MSW / Nock for external API stubs.

**Cadence / duration.**
- Per cross-boundary feature. Runs in CI secondary build (not every commit blocks on them).

**Exit gate (per PR).**
- Integration tests pass against real dependencies.
- No SQLite standing in for Postgres.
- No mocked ORMs.

**Pitfalls.**
- Mocking your own database. Silent drift between test and prod.
- Integration tests that talk to a shared staging DB. Flakes from shared state.
- Not seeding data in the test. Tests fail non-reproducibly on CI.
- Running all integration tests on every commit. Split the pipeline (Process 12).

---

## Process 4 — Contract Test Authorship

**Purpose.** Prevent drift between independently-deployed services with consumer-driven contracts.

**RACI.** R: consumer engineer authors contract · A: consumer team · C: provider team (verifies) · I: both teams.

**Triggers.** When (and only when) there are 2+ independently-deployed services. Skip entirely for a monolith.

**Inputs.**
- Consumer's integration usage (the actual request/response pairs it relies on).
- Pact (or similar) toolchain.
- Provider's API.

**Activities.**
1. **Consumer writes the contract test.** Exercises the client code against a mock provider; captures request/response pairs.
2. **Pact generates the contract file.** JSON-ish description of interactions.
3. **Contract published to Pact Broker** (or equivalent).
4. **Provider's CI verifies the contract.** Replays recorded requests against the actual provider, asserts responses still match.
5. **On failure, investigate and communicate.** Don't auto-block provider's build — follow "the rhythm of changes to the external service."
6. **Only consumer-used behavior is checked.** Provider can change unused surfaces freely.

**Outputs.**
- Published contract per consumer-provider pair.
- Provider's CI includes verification stage.
- Contract-broker dashboard of pair states.

**Tools / templates.**
- Pact (pact-foundation).
- Pact Broker / PactFlow for hosting.
- Spring Cloud Contract (Java) as alternative.

**Cadence / duration.**
- Per integration point, per change. Provider verification runs on its own rhythm, not every deploy.

**Exit gate.**
- Every consumer-provider pair has a published contract.
- Provider CI verifies contracts.
- Contract failures trigger investigation, not automatic build breaks.

**Pitfalls.**
- Contract tests for a monolith. Overhead with no benefit.
- Exhaustive provider-driven specification. Defeats the selective coverage benefit.
- Auto-blocking provider builds on consumer contract failures. Creates cross-team friction and often the consumer is wrong.
- Contracts that drift from real usage. Consumer must author tests against real client code.

---

## Process 5 — E2E Smoke Authorship

**Purpose.** Verify golden paths — signup + first success, core revenue flow, critical admin — actually work through the full stack.

**RACI.** R: senior engineer or SDET · A: Engineering lead · C: PM (what counts as golden), Design · I: team.

**Triggers.** New golden path identified. Quarterly review of existing smoke suite.

**Inputs.**
- Phase 01 user flows for which paths matter.
- MVP scope / active release.
- Staging environment with test accounts.

**Activities.**
1. **Identify 3–10 golden paths.** Not every edge case.
2. **Author in Playwright** (default) — TypeScript/JS/Python.
3. **Use auto-waiting primitives** to reduce flakiness.
4. **Seed test accounts and data** in staging reproducibly.
5. **Run on staging in CI** after integration stage.
6. **On failure: replicate as a unit test first** (per Fowler), then fix.
7. **Quarterly: prune.** Tests that don't earn confidence per unit of maintenance get deleted.

**Outputs.**
- 3–10 E2E tests covering golden paths.
- Playwright config + CI integration.
- Staging test account fixtures.

**Tools / templates.**
- Playwright (default).
- Cypress (viable if already on it).
- Selenium (legacy).

**Cadence / duration.**
- New smoke test: 2–4 hours. Quarterly prune: 60 min.

**Exit gate.**
- 3–10 smokes cover golden paths.
- E2E suite green on every PR to main.
- Flake rate under 5% (quarantine policy below).

**Pitfalls.**
- 30+ E2E tests. Flakiness compounds; signal drowns.
- Every edge case as E2E. Push down the pyramid.
- No quarantine policy. First flake erodes trust.
- Relying on shared staging that drifts. Seed data per run.

---

## Process 6 — ATDD/BDD Authorship

**Purpose.** Express acceptance criteria as Given/When/Then scenarios that run as tests — when and only when business stakeholders co-author them.

**RACI.** R: PM + engineer (co-author) · A: PM · C: Design · I: whole team.

**Triggers.** PM and engineers agree business will co-author scenarios. Otherwise **use plain test code with descriptive names instead.**

**Inputs.**
- Acceptance criteria from Phase 02.
- Business stakeholder willingness to write / review Gherkin.
- Cucumber / SpecFlow / Behave tooling.

**Activities.**
1. **Write scenarios as Given/When/Then.** Business-readable language.
2. **Implement step definitions** (glue code engineers maintain).
3. **Run alongside unit/integration suites.**
4. **PM reviews scenarios in sprint planning** for new features.
5. **Prune when business stops reading them.** If only engineers read Gherkin, switch to plain test code.

**Outputs.**
- `.feature` files with Given/When/Then.
- Step definitions in code.
- Business-readable traceability from criteria → tests.

**Tools / templates.**
- Cucumber (JVM, Ruby), behave (Python), SpecFlow (.NET), Cucumber.js (JS).

**Cadence / duration.**
- Per feature that business co-authors. Typically a fraction of product work.

**Exit gate.**
- Business stakeholders read the scenarios in review.
- Scenarios run in CI.

**Pitfalls.**
- BDD without business co-authorship. Pure overhead; engineers maintain a translation layer for themselves.
- Engineers writing Gherkin nobody reads. Delete.
- Overly detailed scenarios. Unmaintainable.

---

## Process 7 — Performance Test Authorship & Baseline

**Purpose.** Establish performance baselines on critical paths and catch regressions before they reach users.

**RACI.** R: SRE or platform engineer · A: SRE · C: feature engineer, Engineering lead · I: team.

**Triggers.** Phase kickoff (establish baseline). Per change to a critical path. Nightly CI.

**Inputs.**
- Top 3–5 critical user paths (login, search, checkout, main API endpoints).
- Stable build for baseline.
- k6 (default) or equivalent.
- Staging environment approximating prod.

**Activities.**
1. **Pick the test type** from k6's six:
   - **Smoke** — minimal load, verify it works at all.
   - **Average-load** — expected workload.
   - **Stress** — beyond expected, find breaking points.
   - **Soak** — extended duration, surface memory leaks.
   - **Spike** — sudden sharp load change.
   - **Breakpoint** — progressive increase until failure.
2. **Script in k6** (JavaScript).
3. **Establish baseline** on a stable build. Capture p50, p95, p99, error rate, throughput.
4. **Define regression threshold.** Default: p95 latency +15% fails the build.
5. **Run nightly against staging** (not on every PR).
6. **Investigate every regression before release.**

**Outputs.**
- k6 scripts in-repo per critical path.
- Baseline numbers pinned in team wiki.
- Nightly performance CI job.
- Regression alerts routed to the on-call channel.

**Tools / templates.**
- k6 (default) + Grafana k6 Cloud (managed).
- JMeter (protocol-level, not a browser).
- Gatling (Scala/Kotlin, high concurrency).

**Cadence / duration.**
- Script authoring per path: 1–2 days. Baseline refresh quarterly.

**Exit gate.**
- Baselines exist for top 3–5 paths.
- Nightly job runs and alerts on regression.
- Threshold documented.

**Pitfalls.**
- Load-testing every endpoint. Waste. Top 3–5 only.
- No baseline. Regressions invisible.
- Running in prod without coordination. Accidental real DoS.
- JMeter for full-browser scenarios. Not a browser — misses JS.
- One-off numbers with no trend. Track over time.

---

## Process 8 — Security Testing Setup

**Purpose.** Shift security left with SAST, DAST, SCA, and secrets scanning running continuously.

**RACI.** R: Platform/security engineer · A: Engineering lead · C: whole team · I: exec (on findings of severity).

**Triggers.** Phase kickoff. Per new language/framework. Per CVE alert.

**Inputs.**
- OWASP DevSecOps taxonomy (SAST / DAST / IAST / SCA).
- Repo language(s).
- Staging environment (for DAST).

**Activities.**
1. **SAST in CI on every PR.** CodeQL (GitHub), Semgrep (multi-language), Bandit (Python), Brakeman (Ruby/Rails). Fail on high-severity; surface medium/low.
2. **DAST nightly against staging.** OWASP ZAP.
3. **SCA (dependency scanning).** Dependabot, Renovate, Snyk. Alert on known CVEs.
4. **Secrets scanning.** gitleaks, trufflehog, GitHub secret scanning. Pre-commit + CI + git history.
5. **Treat SAST false-positive rate honestly.** Filter, don't gate blindly.
6. **Pre-public-launch OWASP Top 10 walkthrough** with an engineer who didn't write the code.

**Outputs.**
- CI pipeline stages: SAST, SCA, secrets.
- Nightly DAST job.
- OWASP Top 10 checklist completed before any public launch.
- Finding-triage workflow (who reviews, who fixes).

**Tools / templates.**
- CodeQL, Semgrep, Bandit, Brakeman.
- OWASP ZAP.
- Dependabot, Renovate, Snyk.
- gitleaks, trufflehog.
- OWASP Web Security Testing Guide.

**Cadence / duration.**
- Initial setup: 2–3 days. Ongoing triage: part of on-call rotation.

**Exit gate.**
- SAST + SCA + secrets run on every PR.
- DAST runs nightly.
- Findings have owners and SLAs.

**Pitfalls.**
- SAST as gatekeeper with no false-positive tolerance. Blocks everything.
- DAST on production. Accidental abuse signature.
- Ignoring SCA alerts until a CVE hits the news. Log4Shell lesson.
- Secrets in git history not cleaned. Rotation needed, not just removal.
- Skipping Top 10 review. Launch with the bug class you already know about.

---

## Process 9 — Accessibility Testing

**Purpose.** Ensure UI meets WCAG 2.2 AA via automation + manual verification, before any release.

**RACI.** R: Design + engineer · A: Design lead · C: accessibility-aware reviewer · I: PM.

**Triggers.** Per UI feature. Pre-release sanity pass.

**Inputs.**
- WCAG 2.2 AA success criteria.
- POUR principles (Perceivable, Operable, Understandable, Robust).
- axe-core library.
- Lighthouse CI.

**Activities.**
1. **Automated axe-core on every page rendered in integration / E2E tests.**
2. **Lighthouse CI on critical pages per PR.**
3. **Manual keyboard-only walk through the critical flows.** No mouse.
4. **Manual screen-reader check** on signup + checkout at minimum. VoiceOver, NVDA, TalkBack.
5. **Color-contrast check** (4.5:1 body, 3:1 large).
6. **Fix critical violations before release.** Log non-critical for follow-up.
7. **Quarterly audit** with a broader pass.

**Outputs.**
- axe-core results per PR.
- Lighthouse CI scores per PR.
- Manual pass report pre-release.
- Accessibility violations triaged into backlog.

**Tools / templates.**
- axe-core (Deque).
- Lighthouse CI.
- Screen readers: VoiceOver (macOS/iOS), NVDA (Windows), TalkBack (Android).
- Color-contrast checkers.

**Cadence / duration.**
- Automated: every PR. Manual: pre-release, quarterly deep audit.

**Exit gate (per release).**
- axe-core clean on new UI.
- Lighthouse accessibility score ≥95.
- Manual keyboard pass completed.
- Manual screen reader pass on critical paths.

**Pitfalls.**
- Automation only. Catches ~30–40% of real issues.
- Accessibility review at launch. Fixes are 10× cheaper in Figma than in prod.
- Colour-only state indicators. Colourblind users can't see them.
- Treating AA as a stretch. It's the baseline.

---

## Process 10 — Flaky Test Quarantine & Cleanup

**Purpose.** Prevent trust erosion by quarantining flaky tests immediately and deleting within two weeks if unfixed.

**RACI.** R: on-call engineer (first responder) + SDET (if present) · A: Engineering lead · C: test author · I: team.

**Triggers.** A test that fails non-deterministically — different outcomes on same commit.

**Inputs.**
- Flaky-test detector (CI plugin or custom script).
- Quarantine suite (separate CI job, non-blocking).

**Activities.**
1. **On first flake:** move the test to the quarantine suite **same day**. Not end-of-week.
2. **Log the flake** with commit SHA, CI run, suspected cause.
3. **Investigate within the sprint.** Common causes: environmental dependency, async/state, UI timing, shared state.
4. **Fix or delete within 2 weeks.** Quarantine is not a landfill.
5. **No automatic retries on the blocking suite.** Retries hide flakes. Retries only in quarantine during investigation.
6. **Track flakiness rate** as a quality metric. Climbing rate → leading indicator of suite losing trust.

**Outputs.**
- Quarantine suite (separate, non-blocking CI job).
- Flakiness dashboard.
- Weekly triage summary.

**Tools / templates.**
- CI flaky-test plugin (GitHub Actions, CircleCI, Buildkite native).
- Custom script scanning for tests that fail on same SHA across runs.
- Quarantine tag convention in test framework.

**Cadence / duration.**
- Continuous. Weekly 30-min triage.

**Exit gate (rolling).**
- No test sits in quarantine >2 weeks.
- Flakiness rate trending down or stable.
- Blocking suite has no known flakes.

**Pitfalls.**
- Retrying the test and moving on. Hides the root cause.
- Quarantine as landfill. Tests accumulate, coverage false.
- Deleting the test without understanding why it flaked. Loses the regression.
- No flakiness metric. Team discovers the suite is untrustworthy via missed bug.

---

## Process 11 — Test Data Management

**Purpose.** Provide seed fixtures in version control, synthetic data for volume, and anonymization for any production data used in test.

**RACI.** R: engineer authoring fixture · A: Engineering lead · C: security (PII review), DPO if present · I: team.

**Triggers.** New entity in data model; need for volume in performance testing; bug-repro requires production-shaped data.

**Inputs.**
- Data model (Phase 03).
- PII classification.
- Synthetic data generation tools.

**Activities.**
1. **Seed data in version control.** Fixture files, factories (factory-bot, factoryboy, faker), seed scripts.
2. **Synthetic data for volume.** Generate, don't copy.
3. **Never raw production PII in test.** Anonymize first.
4. **Documented, reviewed anonymization process** for prod → test. Mask consistently (foreign keys stay referentially intact).
5. **GDPR/CPRA treat test use of PII like prod use.** Compliance includes test environments.
6. **Versioned fixture changes.** Migrations apply to test data too.

**Outputs.**
- Committed fixtures / factories / seed scripts.
- Synthetic data generator for load testing.
- Anonymization playbook with examples.

**Tools / templates.**
- factory-bot (Ruby), factory_boy (Python), Fishery (TS).
- Faker libraries.
- Anonymization tools (SDM, pg_anonymizer, custom scripts).

**Cadence / duration.**
- Continuous. New fixture: 30–60 min.

**Exit gate (rolling).**
- Every test either uses committed fixtures or seeds inline.
- No raw production PII in any non-prod environment.
- Referential integrity preserved under masking.

**Pitfalls.**
- "It's fine, we anonymized." Without review, anonymization often leaks.
- Copy-paste production backup into staging. GDPR exposure.
- Broken referential integrity after masking. Synthetic data useless.
- Fixture drift from schema. Tests break on next migration.

---

## Process 12 — CI Pipeline Orchestration

**Purpose.** Orchestrate the per-PR pipeline so it completes in <30 min with a <10-min commit build, giving engineers fast feedback.

**RACI.** R: Platform engineer · A: Engineering lead · C: whole team · I: —.

**Triggers.** Phase kickoff. On slowdown (>30 min pipeline, >10 min commit build).

**Inputs.**
- CI provider (GitHub Actions, GitLab CI, CircleCI, Buildkite).
- Test suite duration breakdowns.
- Current stage sequencing.

**Activities.**
1. **Define the stages (per-PR):**
   1. Lint + format check (<1 min).
   2. Type check (<2 min).
   3. Unit tests (<5 min).
   4. Integration tests (<15 min).
   5. E2E smoke (<15 min).
   6. Security scanning (SAST + dep scan) (<5 min).
   7. Build artifact (<5 min).
2. **Parallelize aggressively.** Fan stages across runners.
3. **Commit-build = 1+2+3 (<10 min total).** Fast gate; engineer waits.
4. **Secondary stages (4–6) run in parallel after commit-build.**
5. **Nightly jobs for slower work:** full E2E matrix, performance, DAST, soak tests.
6. **Monitor stage durations.** Alert when any stage drifts >20% over baseline.
7. **Cache dependencies, build layers, test containers.**

**Outputs.**
- CI config in-repo.
- Stage timing dashboard.
- Green-build rate metric.

**Tools / templates.**
- GitHub Actions / GitLab CI / CircleCI / Buildkite.
- Test splitters (knapsack, jest --shard, pytest-xdist).
- Cache layers (actions/cache, buildx, dep caches).

**Cadence / duration.**
- Initial: 2–3 days. Ongoing: 10% of platform engineer capacity.

**Exit gate (rolling).**
- Commit build <10 min.
- Full PR pipeline <30 min.
- Green rate >95% (excluding flakes, which are quarantined).
- DORA lead-time signal trending flat or down.

**Pitfalls.**
- One sequential pipeline. Slow and no parallelism.
- Running every test on every PR including slow nightly stuff. Wastes time.
- No caching. Reinstall deps every run.
- Ignoring drift until 60-min pipeline is "normal." Engineers context-switch.

---

## Process 13 — Exploratory Testing Session

**Purpose.** Find the things the automation didn't think of — usability snags, edge-case bugs, missed acceptance criteria — before release.

**RACI.** R: engineer or tester · A: Engineering lead · C: PM (charter), Design · I: team.

**Triggers.** Pre-release. On any major new area of the product.

**Inputs.**
- Charter (e.g., "explore the checkout flow on mobile Safari").
- Time box (default 2 hours).
- Staging or feature-flagged prod environment.
- Notes template (session-based test management).

**Activities.**
1. **Charter up front.** Scope + purpose. One sentence.
2. **Time-box the session** (60–120 min typical).
3. **One tester per session.** Solo focus; pair for knowledge transfer only.
4. **Structured informality.** Learn → design → execute, simultaneously (Bach).
5. **Notes during.** What was tested, what was found, follow-up questions.
6. **Debrief at end (15 min).** Report findings, file bugs, update charter list for next session.
7. **Schedule regularly.** One per sprint minimum; more pre-release.

**Outputs.**
- Session report (charter, duration, findings, follow-ups).
- Filed bugs with repro steps.
- Updated charter backlog.

**Tools / templates.**
- Session notes template.
- Screen-record tool (QuickTime, OBS).
- Bug tracker.

**Cadence / duration.**
- Per sprint: 1 session. Pre-release: 2–3 sessions. 60–120 min each.

**Exit gate (per session).**
- Charter satisfied or extended with reason.
- Findings filed as bugs.
- Follow-up charters logged.

**Pitfalls.**
- Unstructured "ad hoc" testing. No accountability, no learning capture.
- Automation replacement. Exploratory tests *in addition to*, not *instead of*.
- Too-broad charter. Session dilutes. Narrower beats broader.
- Skipping the debrief. Learnings lost.

---

## Process 14 — Production Testing (Canary / Dark Launch / A/B)

**Purpose.** Use production traffic to validate the build (canary), test back-end load invisibly (dark launch), and validate user hypotheses (A/B).

**RACI.** R: feature engineer + SRE · A: Engineering lead · C: PM (A/B hypotheses), Design · I: stakeholders.

**Triggers.** New rollout. Canary for any user-visible change. Dark launch for back-end-heavy changes. A/B for hypothesis validation.

**Inputs.**
- Feature flag infrastructure (Phase 06).
- Baseline metrics (error rate, latency, KPIs).
- Rollback trigger definitions.
- Sample-size calculator for A/B.

**Activities.**

**Canary (Fowler):**
1. Route 1–5% traffic to new version.
2. Compare error rate, latency, KPIs against rest.
3. Promote stepwise: 1% → 10% → 50% → 100%.
4. Auto-rollback on degradation beyond threshold.

**Dark launch (Fowler):**
1. Run new back-end path on real traffic.
2. Compute everything, don't display.
3. Measure load, latency, correctness.
4. Switch on display when confident.

**A/B:**
1. Define hypothesis (preference / conversion / retention).
2. Compute required sample size.
3. Feature-flag split traffic.
4. Run until significance (or null).
5. Decision: ship winner, kill, iterate.
6. Don't conflate with canary — canary detects problems; A/B validates hypotheses.

**Outputs.**
- Canary metrics dashboard.
- Dark launch metrics (internal-only).
- A/B experiment results + decision.
- Promote / rollback decision recorded.

**Tools / templates.**
- Feature flag platform (LaunchDarkly, Unleash, in-house).
- Traffic-splitting infra (service mesh, load balancer rules).
- Analytics / experiment platform (Statsig, Eppo, GrowthBook, Amplitude Experiment).

**Cadence / duration.**
- Per rollout. Canary: hours–days. Dark launch: days. A/B: days–weeks.

**Exit gate.**
- Canary promoted or rolled back on measured signal.
- Dark launch measured before switch.
- A/B decision recorded with significance evidence.

**Pitfalls.**
- Conflating canary with A/B. Fowler's explicit warning.
- A/B without enough traffic for significance. Noise, not signal.
- Canary with no auto-rollback trigger. Manual rollback arrives late.
- Skipping baseline. Can't tell degradation from normal variance.

---

## Release-gate exit checklist (per release)

Every release gates on this. Copy to release template:

- [ ] Unit + integration tests green on release-candidate commit.
- [ ] E2E smoke green on staging.
- [ ] Security scans green (SAST, SCA, secrets).
- [ ] Accessibility check complete on any new UI (axe-core + manual keyboard + screen reader on critical paths).
- [ ] Performance regression check — p95 within threshold.
- [ ] Exploratory session completed; findings addressed or accepted.
- [ ] Observability added for new code paths (logs / metrics / traces).
- [ ] Feature flags configured for gradual rollout.
- [ ] Rollback plan written down and understood.

---

## Scale notes

- **Solo builder.** Processes 2 (unit on business logic), 5 (one E2E smoke), 8 (SCA + secrets), 13 (manual exploratory pre-release). Skip 4 (contracts), 6 (BDD), 14's A/B (no traffic).
- **Team of 5.** This document's default. Full pyramid. Shift-left security. Quarterly accessibility audit.
- **Team of 50.** Add Process 4 (contracts) if >1 deployable service. Dedicated test infrastructure. Flakiness dashboard. Regular performance regression runs. Quarterly game days (Phase 07 owns). SDET as multiplier.
- **Team of 500+.** Multiple SDETs. Formal test-platform team. Automated chaos practice. Embedded security specialists. Accessibility program with dedicated auditors. DORA metrics per team.

---

## Weekly rhythm

Testing is not a discrete week. Rough rhythm:

| Cadence | Activities |
|---|---|
| Per PR | Processes 2, 3, 6 (if applicable), 8 (SAST+SCA), 9 (axe automated), 12 (CI runs). Reviewer checks tests |
| Daily | Process 10 triage (on-call sweeps flaky reports) |
| Weekly | Flakiness triage (30 min); exploratory session (60–120 min) |
| Nightly | Processes 7 (performance), 8 (DAST), full E2E matrix |
| Pre-release | Process 13 (exploratory deep), 9 (manual accessibility), release checklist |
| Quarterly | Process 1 revisit (strategy), Process 5 prune (E2E), Process 9 deep audit (accessibility), game day |

---

## Handoff

Phase 05 feeds Phase 06 (Ship) on every green build. The handoff is the release candidate commit:

1. All release-gate checklist items ticked.
2. Observability signals wired for every new code path.
3. Rollback plan documented.
4. Feature flags configured.

Phase 06 takes over pipeline mechanics, progressive delivery, and the actual traffic shifts. Phase 07 (Run) takes over once traffic is on.
