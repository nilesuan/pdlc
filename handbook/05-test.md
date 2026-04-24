# Phase 05 — Test

**Goal:** Build durable confidence that the product behaves correctly, so you can ship often without fear.

**Duration:** Continuous — testing is a practice, not a phase.

**You are done when:** Trick question — you're never done. But concretely: you have a test suite you trust, running on every commit, that catches regressions before users do. Engineers ship on Friday afternoons without flinching.

---

## What this phase is about

Testing is the mechanism that lets you ship often and sleep at night. It is not a gate a QA team stands at before release.

If testing happens at the end, two things go wrong. Defects discovered late are far more expensive to fix — they have propagated into other code and downstream integrations. And a late testing phase pressures itself: shipping dates don't move, so testing time compresses, and you ship weaker software. The Wikipedia entry on shift-left testing catalogues this: late testing produces "insufficient testing resources, undiscovered defects in requirements and design, debugging difficulties as systems grow, reduced code coverage, and accumulating technical debt that can jeopardize projects" ([Shift-left testing — Wikipedia](https://en.wikipedia.org/wiki/Shift-left_testing), verified 2026-04-24).

The alternative, which this phase prescribes, is **shift-left**: testing begins with the earliest commit, runs continuously, and is authored by the engineers who wrote the code. Larry Smith coined the term in *Dr. Dobb's Journal* in September 2001, framing it as "a better way of integrating the quality assurance (QA) and development parts of a software project" ([Smith, DDJ 2001](https://jacobfilipp.com/DrDobbs/articles/DDJ/2001/0109/0109e/0109e.htm), verified 2026-04-24). Twenty-five years on, shift-left is the majority practice in high-performing teams: DORA's research records that "developers primarily own test creation and maintenance, with testers collaborating throughout" ([DORA — Test Automation](https://dora.dev/capabilities/test-automation/), verified 2026-04-24).

Testing is also not a single activity. It spans fast in-process unit tests, integration tests that talk to real databases, contract tests between services, end-to-end user-journey tests, performance tests under load, security scans, accessibility audits, exploratory sessions, and controlled experiments in production. This chapter prescribes what to do at each level, which tools to reach for, and — critically — what to skip.

One more frame before you read further. Kent C. Dodds puts testing as an ROI problem: "return is confidence and investment is time" ([Dodds — Testing Trophy](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications), verified 2026-04-24). Every test you write costs time to author and maintain; you are investing that time to buy confidence. When a test no longer earns confidence per unit of maintenance, delete it.

---

## Who does what

Everyone tests. You do not need a dedicated QA role on a team of five, or twenty, and we will argue you don't need one on a team of two hundred either. Quality is engineering's responsibility.

- **Engineers** write unit, integration, and most E2E tests — alongside the feature, not after.
- **Product and design** co-author acceptance criteria and participate in exploratory sessions.
- **SRE / platform** owns performance baselines, security scanning infrastructure, and chaos experiments.
- **A dedicated SDET** (Software Development Engineer in Test) starts to make sense around 30–50 engineers, as a multiplier — not a bug-catcher. An SDET builds the test infrastructure, fixes flaky tests, maintains the fixture library, and teaches. k6's documentation names SDETs as part of its audience alongside engineers, QA specialists, and SREs ([Grafana k6](https://grafana.com/docs/k6/latest/), verified 2026-04-24).

If your instinct is "we need a QA team to catch our bugs," retrain it. QA teams at the end of the pipeline produce slow feedback loops, low-trust relationships, and a culture where engineers shrug because "someone else will find it."

---

## Inputs

- Code from Phase 04 — with self-testing as a baseline expectation.
- Design decisions from Phase 03 — architecture dictates where the test boundaries fall.
- Acceptance criteria from Phase 02 — these become ATDD or BDD scenarios where stakeholder collaboration warrants it.
- Discovery insights from Phase 01 — what user journeys must work become the E2E smoke suite.

---

## Your testing strategy

### Start with the shape

The default shape for your test suite is the **testing pyramid**: many fast unit tests at the base, fewer integration tests in the middle, very few end-to-end tests at the top.

Mike Cohn popularized this in *Succeeding with Agile* (2009); Martin Fowler and Ham Vocke refined it. The essential claim, in Fowler's words, is that "you should have many more low-level UnitTests than high level BroadStackTests running through a GUI" ([Fowler — TestPyramid](https://martinfowler.com/bliki/TestPyramid.html), verified 2026-04-24). His reasoning is not ideological — it is operational. UI-driven testing is "brittle, expensive to write, and time consuming to run"; tests through graphical interfaces suffer from "non-determinism problems, which can undermine trust in them."

Two principles from Vocke's *Practical Test Pyramid* become your operating rules ([Vocke — Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), verified 2026-04-24):

1. **Write tests with different granularity.**
2. **The more high-level you get, the fewer tests you should have.**

And two more that are easier to remember as slogans:

- **Push tests down the pyramid** — keep a test at the lowest level where it still gives you confidence.
- **Treat test code with the same rigor as production code.**

**When to use the Testing Trophy instead.** For frontend-heavy web applications, Kent C. Dodds' **testing trophy** is a legitimate alternative. Its four layers from top to bottom: E2E, integration, unit, static (types + linting). Dodds argues that in modern JavaScript apps, integration tests rendering real components with mocked network calls give more confidence per unit of maintenance than a broader base of unit tests ([Dodds — Testing Trophy](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications), verified 2026-04-24). His widely-quoted thesis: "The more your tests resemble the way your software is used, the more confidence they can give you."

**Pick the pyramid as your default.** Switch to the trophy if you're building a frontend-heavy single-page application and find unit tests aren't catching integration-shaped bugs. Both are heuristics about speed, reliability, and cost — not rules about counts. Fowler's own caveat: "If my high level tests are fast, reliable, and cheap to modify — then lower-level tests aren't needed."

### Coverage target

Do not set a hard coverage target. Set a floor, and use it as a signal, not a scoreboard.

- **Useful floor:** 70–80% line coverage on business logic.
- **Acceptable:** less on glue code, framework wiring, generated code, and trivial getters/setters.
- **Suspect:** anything approaching 100%. Fowler himself: "I would be suspicious of anything like 100% — it would smell of someone writing tests to make the coverage numbers happy" ([Code coverage — Wikipedia](https://en.wikipedia.org/wiki/Code_coverage), verified 2026-04-24).

Why the skepticism? Coverage measures *what code was executed by a test run*, not *whether that execution verified correctness*. A test that calls a function without asserting anything still raises coverage. Coverage "can mask real-time defects like race conditions" — it tells you nothing about concurrency, timing, or ordering ([Code coverage — Wikipedia](https://en.wikipedia.org/wiki/Code_coverage), verified 2026-04-24).

Use coverage as a **PR gate** ("can't merge below 70% on new code") and as a **trend alarm** ("coverage dropped 5 points this week — why?"). Not as a scoreboard, and don't chase the last 20%.

---

## The levels of testing

### Unit tests

**Purpose:** verify a single unit of behaviour in isolation, very fast, deterministically.

Wikipedia defines unit testing as "a form of software testing where isolated source code is tested to validate expected behavior" ([Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing), verified 2026-04-24). A "unit" is situational — a function, a class, a small cluster of classes. Fowler characterizes it as "a single behaviour exhibited by the system under test" ([Fowler — UnitTest](https://martinfowler.com/bliki/UnitTest.html), verified 2026-04-24). Don't argue about the precise definition; write tests that are small, fast, and focused.

**What makes a good unit test:**

- **Fast** — milliseconds each. If a unit test calls a network, it isn't a unit test.
- **Isolated** — runs in any order; does not depend on other tests or shared state.
- **Deterministic** — same input, same output, every run.
- **Focused on behavior, not implementation** — asserts observable outputs, not internal calls.

**Test doubles — when you need to stub something out.** Gerard Meszaros' taxonomy (summarized by Fowler) defines five types ([Fowler — TestDouble](https://martinfowler.com/bliki/TestDouble.html), verified 2026-04-24):

- **Dummy** — passed around but never used; fills a parameter.
- **Fake** — a working implementation that takes a shortcut (in-memory DB instead of Postgres).
- **Stub** — returns canned answers to calls made during the test.
- **Spy** — a stub that also records how it was called.
- **Mock** — pre-programmed with expectations; fails if it receives a call it doesn't expect.

**Prefer fakes over mocks when possible.** Mocks freeze the shape of a collaborator at the moment you write the test; refactor the collaborator and every mock breaks. Fakes give you a real behavioral contract — the `InMemoryUserRepository` either implements the repository interface correctly or it doesn't. Fowler makes the point sharply: he "personally favors sociable tests" — tests with real collaborators — and uses doubles "primarily when collaborations are awkward, like remote services or external resources" ([Fowler — UnitTest](https://martinfowler.com/bliki/UnitTest.html), verified 2026-04-24).

**Naming convention:** describe the behavior being tested. `it("returns null when the user has no subscription")` beats `testGetSubscription3()`. Use the pattern your framework suggests (`describe`/`it` in JS; `should_return_null_when_no_subscription` in Java/C#).

**Structure:** arrange-act-assert (or given-when-then). Don't interleave setup and assertions.

### Integration tests

**Purpose:** verify that real components — your code and a database, your code and a cache, two modules talking to each other — actually collaborate.

Wikipedia: "multiple software components, modules, or services are tested together to verify they work as expected when combined" ([Integration testing — Wikipedia](https://en.wikipedia.org/wiki/Integration_testing), verified 2026-04-24). The operative word is "real."

**Do:**

- Use **testcontainers** or equivalent to spin up real Postgres, Redis, Kafka locally and in CI. No mocked ORMs, no SQLite-standing-in-for-Postgres.
- Keep them **narrow** — test one integration point at a time. Vocke's example: test database persistence by starting a local database, writing data, and verifying retrieval ([Vocke — Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), verified 2026-04-24).
- Seed data inside the test so failures are reproducible.

**Don't:**

- **Don't mock your own internal boundaries.** If `OrderService` calls `InventoryService`, and they ship in the same deployable, let them call each other in the test. Mocking internal collaborators produces tests that pass while the system is broken.
- **Do mock external boundaries** — third-party APIs, payment processors, email providers. Use recorded fixtures or a local stub server for those.

Integration tests are slower than unit tests (seconds, not milliseconds). That's the trade. Fowler's two-stage CI structure ([Fowler — Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html), verified 2026-04-24) separates fast unit tests (commit build, under 10 minutes) from slower integration tests against real services (secondary build). Adopt the same split.

### Contract tests

**Purpose:** prevent drift between independently-deployed services — consumer and provider agree on what messages look like.

If you have a single deployable (a monolith, a small modular monolith), **you do not need contract tests.** Skip this section.

If you have two or more services deployed independently, contract tests matter. Pact's definition: "a technique for testing an integration point by checking each application in isolation to ensure the messages it sends or receives conform to a shared understanding that is documented in a 'contract'" ([Pact Docs](https://docs.pact.io/), verified 2026-04-24). Fowler's framing is tighter: contract tests "check that all the calls against your test doubles return the same results as a call to the external service would" ([Fowler — ContractTest](https://martinfowler.com/bliki/ContractTest.html), verified 2026-04-24).

**Use Pact (or similar) for consumer-driven contracts.** The consumer writes a test describing exactly the request/response pairs it uses; Pact generates a contract file; the provider's CI verifies the contract against its current API. Two valuable properties ([Pact — Getting Started](https://docs.pact.io/getting_started), verified 2026-04-24):

- **Selective coverage** — only what the consumer actually uses is checked; the provider can change unused behavior freely.
- **Concrete examples** — the contract is by example, not by exhaustive specification.

**Cadence note from Fowler:** contract tests need not run on every deployment; they should follow "the rhythm of changes to the external service." A contract test failure "shouldn't necessarily break the build in the same way that a normal test failure would" — it should trigger investigation and communication.

### End-to-end tests

**Purpose:** verify that the complete system — UI, backend, database, third parties — works for a real user journey.

Keep them few. Vocke describes them as "notoriously flaky" and recommends "minimizing them to critical user journeys" ([Vocke — Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), verified 2026-04-24). Fowler treats high-level tests as "a second line of test defense" — when a failure occurs there, "before fixing a bug exposed by a high level test, you should replicate the bug with a unit test" ([Fowler — TestPyramid](https://martinfowler.com/bliki/TestPyramid.html), verified 2026-04-24).

**Test the golden paths, not every edge case:**

- Signup + first successful action (whatever that means for your product).
- The core revenue flow (checkout, subscription, payment).
- The critical admin path (if it goes down, support stops).

Three to ten E2E tests is a reasonable count for a small product. Thirty is probably too many.

**Tooling:** **Playwright** is the default recommendation in 2026. It's fast, cross-browser, scriptable in TypeScript/JS/Python, and has strong auto-waiting primitives that reduce flakiness. Cypress remains viable for teams already on it. Selenium is the old standard, still supported, but Playwright is a better first choice today.

**Expect flakiness and plan for it.** Build a retry + quarantine policy (see the next section).

### Acceptance testing (ATDD / BDD)

**Purpose:** express acceptance criteria in a form that product, design, and engineers can all read — and that also executes as a test.

Acceptance test-driven development (ATDD) writes these tests *before* implementation and follows a Given/When/Then pattern ([ATDD — Wikipedia](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development), verified 2026-04-24):

- **Given** a specified system state
- **When** an action or event occurs
- **Then** the system produces an expected output

**Behavior-driven development (BDD)** — Cucumber, Gherkin, SpecFlow — wraps ATDD in a natural-language feature file format. Use it **only** when business stakeholders will co-author the scenarios. Otherwise the Gherkin layer is a ceremony your engineers maintain for no audience, and you pay a translation tax between feature files and code.

**Rule of thumb:** if product writes the scenarios, adopt BDD. If engineering writes them based on acceptance criteria from product, use plain test code with descriptive names instead — you'll get the same clarity without the tooling overhead.

---

## Non-functional testing

### Performance / load testing

You need to know how your system behaves under load *before* users find out.

**Default tool: k6 (Grafana).** k6 is "an open-source, developer-friendly load testing tool" with tests written as JavaScript, easy to wire into CI, and with a managed cloud option ([Grafana k6](https://grafana.com/docs/k6/latest/), verified 2026-04-24). Its documentation identifies six test types, which become your menu:

- **Smoke** — minimal load, verifies the system works at all.
- **Average-load** — simulates expected workload.
- **Stress** — pushes beyond expected load to find breaking points.
- **Soak** — extended duration at average load, surfaces memory leaks.
- **Spike** — sudden, sharp load change.
- **Breakpoint** — progressive increase until failure.

**Alternatives:**

- **Apache JMeter** — mature, Java-based, protocol-level testing. Important caveat from JMeter's own docs: "JMeter is not a browser" — it does not execute JavaScript ([Apache JMeter](https://jmeter.apache.org/), verified 2026-04-24). Good for pure-API load, not for full-browser scenarios.
- **Gatling** — Scala/Kotlin-based, strong for very high concurrency; markets itself as "Continuous Performance Intelligence" ([Gatling](https://gatling.io/), verified 2026-04-24).

**What to load-test:** the top 3–5 critical paths — login, search, checkout, the main API endpoints. Not every endpoint.

**Process:**

1. Establish a **baseline** on a stable build.
2. Add load tests to CI against a staging environment on a schedule (nightly is fine — not every PR).
3. Define a **regression threshold** (p95 latency increases >15% fails the build).
4. Investigate every regression before release.

### Security testing

Shift security left with the same logic you shift testing left. OWASP's DevSecOps Guideline frames the goal as detecting "security issues (by design or application vulnerability) as fast as possible" ([OWASP DevSecOps](https://owasp.org/www-project-devsecops-guideline/latest/), verified 2026-04-24).

OWASP's taxonomy of automated security testing:

- **SAST** — analyzes source code without running it.
- **DAST** — tests the running application.
- **IAST** — instruments the running app; combines static and dynamic analysis.
- **SCA** — scans third-party dependencies.

**A minimum CI setup:**

- **SAST in CI** — **CodeQL** (GitHub), **Semgrep** (open source, multi-language), **Bandit** (Python-specific), **Brakeman** (Ruby/Rails). Named in OWASP's source-code analysis tool directory ([OWASP — Source Code Analysis Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools), verified 2026-04-24).
- **DAST against staging** — **OWASP ZAP** is the standard open-source option. Run it nightly.
- **Dependency scanning** — **Dependabot**, **Renovate**, **Snyk**. Alerts on known CVEs in your `package.json`, `go.sum`, `requirements.txt`.
- **Secrets scanning** — **gitleaks**, **trufflehog** as pre-commit hooks *and* in CI. A leaked API key in git history is expensive to remove and cheap to prevent.

**Be honest about SAST limits.** OWASP notes SAST has "high numbers of false positives" and struggles with authentication, access control, and cryptographic vulnerabilities ([OWASP — Source Code Analysis Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools), verified 2026-04-24). Use it as a filter, not a gatekeeper.

**Before any public launch:** walk the **OWASP Top 10** checklist with an engineer who didn't write the code. The OWASP Web Security Testing Guide is the reference ([OWASP WSTG](https://owasp.org/www-project-web-security-testing-guide/), verified 2026-04-24).

### Accessibility testing

Accessibility is not optional. The **WCAG 2.2 AA** target is the 2026 industry baseline ([W3C WAI — WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/), verified 2026-04-24).

WCAG is organized around the **POUR** principles — content must be Perceivable, Operable, Understandable, Robust — and three conformance levels (A, AA, AAA). AA is what most regulators and buyers expect; AAA is usually overkill.

**Automated:**

- **axe-core** — open-source rules engine from Deque, shipped as browser extensions and as libraries for Jest, Playwright, Cypress. Run axe on every page rendered in your integration and E2E tests. Deque describes axe-core as "the global standard in accessibility testing" ([Axe — Deque](https://www.deque.com/axe/), verified 2026-04-24).
- **Lighthouse CI** — Google's Lighthouse, wired into CI. Run on critical pages on every PR.

**Caveat on automation coverage:** Deque claims automation can "find and fix up to 80% of issues" ([Axe — Deque](https://www.deque.com/axe/), verified 2026-04-24). That is a vendor claim, and it's widely acknowledged in the field that automated tools catch only a subset — contrast and ARIA role issues, yes; semantic correctness of interactions, no. Automation is necessary and not sufficient.

**Manual, before release:**

- Complete the critical user flows using **keyboard only** — no mouse.
- Test with a screen reader (VoiceOver on macOS, NVDA on Windows) on at least the signup and checkout pages.

### Usability testing

Usability testing is predominantly a Phase 01 / Phase 08 concern — Discover and Evolve. In Phase 05 you're verifying the implemented product still matches the intent that testing validated earlier.

Wikipedia's definition: "a technique in user-centered interaction design that evaluates products by observing real users" ([Usability testing — Wikipedia](https://en.wikipedia.org/wiki/Usability_testing), verified 2026-04-24). It's an observation of actual use, not a comment on a prototype.

**Quick prescription for this phase:**

- Run a **moderated session with 5 users** before any material UI release. Nielsen's widely-cited rule of thumb is that 5 users surface ~85% of usability issues in a given design. (Nielsen's result is industry folklore by now; the verified Wikipedia entry on usability testing lists moderated and remote sessions as primary methods but does not give a specific percentage — treat the "85%" as a heuristic to plan against, not a guaranteed yield.)
- Keep sessions to 30 minutes with concrete tasks.
- Fix the three biggest issues before shipping.

---

## Test automation principles

### What to automate

- **Anything you'll run more than ~5 times.** The author's effort is paid back quickly.
- **Regression suites** — the tests that prove last week's bug is still fixed.
- **Deployment gates** — if it blocks a release, it must run automatically. Manual deployment gates rot.

Fowler's line, worth tattooing: "Imperfect tests, run frequently, are much better than perfect tests that are never written at all" ([Fowler — Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html), verified 2026-04-24).

### What not to automate

- **One-off exploratory checks** — cheaper to do by hand.
- **Visual judgment calls** — "does this feel right?" is not automation's job.
- **Tests where flakiness cost exceeds the value.** If a test fails 1 in 20 runs for environmental reasons and the scenario only matters once a quarter, delete it.

### Flakiness

A flaky test is one whose outcome changes without a change to the code under test. Flaky tests are corrosive — they train engineers to ignore red builds, and once that habit forms, your test suite is worth very little.

Google's 2016 post *Flaky Tests at Google and How We Mitigate Them* catalogues the primary causes ([Google Testing Blog, 2016](https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html), verified 2026-04-24):

- **Environmental dependencies** — external systems, timing, network.
- **Test design problems** — poor handling of async and state.
- **UI automation** — Selenium-style tests, especially susceptible to timing and synchronization.
- **Shared state** — globals, test interdependencies.

**Policy for your team:**

1. **Quarantine on first flake.** A test that fails non-deterministically is pulled from the blocking suite the day it's noticed. Google's practice, adapted: flaky tests "separated from the critical CI path" while teams investigate ([Google Testing Blog, 2016](https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html), verified 2026-04-24).
2. **Fix within a sprint or delete.** Quarantine is not a landfill. A quarantined test that isn't fixed within two weeks is deleted. If deleting feels risky, you know what to do — fix it.
3. **Track flakiness rate.** It's a quality metric. A flakiness rate climbing is a leading indicator of a test suite losing trust.
4. **No automatic retries on the blocking suite.** Retries hide flakes. Retries belong only in the quarantine suite while you investigate.

### Test data

Three rules:

1. **Seed data lives in version control.** Fixtures, factories, seed scripts — all in the repo. Don't rely on "what's in staging right now."
2. **Synthetic data for volume.** For load tests and edge-case exploration, generate data — don't copy it. Wikipedia's TDM entry names synthetic data generation alongside subsetting and masking ([Test data management — Wikipedia](https://en.wikipedia.org/wiki/Test_data_management), verified 2026-04-24).
3. **Never use raw production PII in test.** If you must use production data (sometimes necessary to reproduce a bug), anonymize it first with a documented, reviewed process. The regulatory context is explicit — GDPR and CPRA treat test use of PII the same as production use ([Test data management — Wikipedia](https://en.wikipedia.org/wiki/Test_data_management), verified 2026-04-24).

Watch out for **referential integrity** when subsetting or masking — if you mask customer IDs, the order table had better get the same masking. Broken foreign keys make synthetic data useless.

---

## Continuous testing — what runs in CI

Your CI pipeline on every PR runs, in roughly this order:

1. **Lint + format check** (< 1 min)
2. **Type check** (< 2 min)
3. **Unit tests** (< 5 min)
4. **Integration tests** (< 15 min)
5. **E2E smoke suite** — 3–10 golden-path tests (< 15 min)
6. **Security scanning** — SAST + dependency scan (< 5 min)
7. **Build artifact** (< 5 min)

Phase 06 covers the deployment pipeline mechanics; Phase 05 only specifies what runs.

**Target: the whole PR pipeline completes in under 30 minutes.** If it's longer, parallelize (fan out across runners), split (nightly for the slow suite), or trim (delete tests that no longer earn their keep).

Fowler's specific guidance is a **commit build of under 10 minutes** — fast enough that engineers wait for it ([Fowler — Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html), verified 2026-04-24). DORA corroborates: high-performing teams "provide feedback from automated tests in less than ten minutes" ([DORA — Test Automation](https://dora.dev/capabilities/test-automation/), verified 2026-04-24). Make 10 minutes your budget for unit + fast integration; let the heavier E2E and security scans run in parallel or in a secondary stage.

The green build is a contract. Fowler, again: "The test of such a test suite is that we should be confident that if the tests are green, then no significant bugs are in the product" ([Fowler — Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html), verified 2026-04-24). When green doesn't mean ready-to-ship, fix your test suite, not your deployment process.

---

## Production testing

The tests that run before a release tell you the system passed a suite. The tests that run *in production* tell you it works for real users. You want both.

### Canary analysis

Route 1–5% of traffic to the new version. Compare its error rate, latency, and key business KPIs against the rest. If the canary degrades, roll back automatically.

Fowler: canary release is "a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure" ([Fowler — CanaryRelease](https://martinfowler.com/bliki/CanaryRelease.html), verified 2026-04-24). It enables "capacity testing in realistic production conditions with safe rollback" and provides "early warning of problems before they affect the whole user base."

Phase 06 covers canary mechanics (traffic splitting, rollback triggers); Phase 05 is where you decide *what to measure* — which baselines determine promote-vs-rollback.

### Feature flags for gradual rollout

Launch behind a flag. Ramp traffic: 1% → 10% → 50% → 100% over a day or a week. Keep the kill switch ready.

Feature flags also enable **dark launching**, which Fowler defines as "taking a new or changed back-end behavior and calling it from existing users without the users being able to tell it's being called" ([Fowler — DarkLaunching](https://martinfowler.com/bliki/DarkLaunching.html), verified 2026-04-24). The canonical example: the new recommendation engine runs in production on real traffic, computes everything, but doesn't display results — so you can measure load and latency impact with zero user-visible risk.

Use dark launching for back-end enhancements where users don't need to choose. Use canary for anything users see.

### A/B testing

For validating hypotheses about what users prefer — not for validating that the build works. Fowler is explicit: "canary releases detect problems, while A/B testing validates hypotheses — and should not be conflated" ([Fowler — CanaryRelease](https://martinfowler.com/bliki/CanaryRelease.html), verified 2026-04-24).

A/B testing needs enough traffic for statistical significance, which small products often don't have. Use it for experiments that matter (the signup flow, pricing pages), not for every feature. Cross-reference with Phase 08 — Evolve — where continuous experimentation as a discipline lives.

### Chaos engineering

**Chaos engineering** is "the discipline of experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions in production" ([Principles of Chaos](https://principlesofchaos.org/), verified 2026-04-24). The Principles of Chaos document defines four experimental steps:

1. Define 'steady state' as measurable system output indicating normal behavior.
2. Hypothesize that steady state continues in control and experimental groups.
3. Introduce variables reflecting real-world events (server crashes, network failures, etc.).
4. Attempt to disprove the hypothesis by observing differences between groups.

And five advanced principles, the most important being **minimize blast radius** — contain the damage when an experiment goes wrong.

**Not for day one.** Chaos engineering assumes you have a production system with meaningful traffic and redundant components. On day one, you'll introduce chaos by accident, and practicing it deliberately won't teach you anything new.

**Game days > automated chaos for small teams.** A game day is a scheduled exercise where the team deliberately breaks something in a staging or production environment and responds as if it were real. You learn where runbooks are wrong, where monitoring is blind, and where ownership is unclear. This is much higher-leverage than running Chaos Monkey against a system nobody has practiced failing on.

**For reference:** Netflix's Simian Army (2011) is the canonical ancestor — Chaos Monkey, Latency Monkey, Chaos Gorilla, etc. ([The Netflix Simian Army, 2011](https://netflixtechblog.com/the-netflix-simian-army-16e57fbab116), verified 2026-04-24). The book *Chaos Engineering* (O'Reilly, 2020) by Nora Jones and Casey Rosenthal is the standard deep dive.

---

## Exploratory testing

Automation tells you whether the things you already thought of still work. Exploratory testing finds the things you didn't think of.

Cem Kaner coined the term in 1984; Kaner and James Bach developed it through the 1990s ([Exploratory testing — Wikipedia](https://en.wikipedia.org/wiki/Exploratory_testing), verified 2026-04-24). Bach's definition: "performing tests while learning things that may influence the testing. This is a scientific process" ([Satisfice — Bach](https://www.satisfice.com/exploratory-testing), verified 2026-04-24). Wikipedia frames it as "simultaneous learning, test design, and test execution."

Three elements from Bach's framing to recognize:

- **Agency and accountability** — a tester makes choices as they go.
- **Learning and mental models** — continuous understanding-building.
- **Structured informality** — there's a pattern, even if it looks ad hoc.

**Prescription for your team:**

- **Time-boxed sessions, especially before releases.** Two hours, one engineer or tester, one charter ("explore the checkout flow on mobile Safari").
- **Use session-based test management** — a charter up front, notes during, a quick debrief after. This is James Bach's session-based approach — it's what makes exploratory testing accountable rather than "ad hoc."
- **Do it alongside automation, not instead of.** DORA's test automation capability page explicitly lists exploratory testing among "manual testing including exploratory, usability, and acceptance activities run throughout delivery" ([DORA — Test Automation](https://dora.dev/capabilities/test-automation/), verified 2026-04-24).

A good exploratory session before a release will usually find bugs the suite missed, usability snags the designer didn't see, and edge cases the spec didn't cover. Schedule the time.

---

## Environments strategy

You need the following, and probably no more:

- **Local dev** — every engineer runs the full stack (or an approximation) on their laptop.
- **CI** — ephemeral, spun up per run.
- **Staging** — production-like, shared, used for integration and E2E tests and for pre-release validation.
- **Preview environments per PR** — recommended; tools like Vercel, Netlify, Railway, Render, or bespoke k8s tooling make this cheap. Reviewing UI changes in a live preview beats reading screenshots.
- **Production.**

**Data flow rule:**

- **Synthetic data in all non-prod environments.** Seed fixtures, factories, generators.
- **Real data only in prod.**
- **If you must reproduce a prod bug in staging**, pull the minimum data needed, anonymize PII first, and document the transfer.

Fowler notes that canary releases can "serve as an alternative to maintaining separate testing environments" — because production itself, with traffic shaped by feature flags, is now a testing environment ([Fowler — CanaryRelease](https://martinfowler.com/bliki/CanaryRelease.html), verified 2026-04-24). This is the modern move: fewer, cheaper pre-production environments plus more rigorous production-based techniques (canary, dark launch, feature flags). Resist the temptation to maintain many static pre-prod environments — they drift, they get expensive, and they rarely catch more than a good staging plus a careful canary.

---

## Quality Engineering vs QA

The role has shifted. DORA captures it plainly: "developers primarily own test creation and maintenance, with testers collaborating throughout" ([DORA — Test Automation](https://dora.dev/capabilities/test-automation/), verified 2026-04-24). Fowler lists programmer-authored tests as one of the three defining features of the modern unit-testing practice ([Fowler — UnitTest](https://martinfowler.com/bliki/UnitTest.html), verified 2026-04-24).

**What this means operationally:**

- **No bug-finder team at the end of the pipeline.** The engineers who write the feature write the tests.
- **SDETs and test-platform engineers are multipliers.** They build the test infrastructure, maintain fixture libraries, own the flaky-test dashboard, and teach practices. They do not hand-test features.
- **A QA lead, when you have one, coaches — they don't gate.** Their job is to raise the whole team's testing skill.

If you're hiring a QA team to catch bugs at the end, stop. Use that headcount for an SDET, a platform engineer, or another product engineer who tests their own work.

---

## Anti-patterns

- **"We'll add tests later."** Tests added later rarely get added at all, and never match the structure of a codebase designed without them.
- **Tests tightly coupled to implementation (change-detector tests).** A test that breaks every time you refactor — even though the behavior is unchanged — is a liability. Fix it or delete it.
- **Mocking everything, including your own boundaries.** Mocked internal collaborators produce green suites over broken systems.
- **Flaky E2E tests that everyone ignores.** Quarantine on day one. Delete within two weeks.
- **100% coverage as the goal.** Fowler: "I would be suspicious of anything like 100%" ([Code coverage — Wikipedia](https://en.wikipedia.org/wiki/Code_coverage), verified 2026-04-24).
- **Testing the framework.** A test that verifies React's `useState` updates a value, or that Rails' ORM returns rows, is testing the framework. Delete it.
- **Giant test suites that take an hour to run.** Engineers wait, then stop waiting, then stop running them. Keep the PR pipeline under 30 minutes.
- **"Best practices" without context.** The context-driven school's first principle: "The value of any practice depends on its context" ([Context-Driven Testing](https://context-driven-testing.com/), verified 2026-04-24). Borrow from this handbook, don't copy it verbatim — adjust for your domain, risk profile, and team skill.

---

## Scale notes

- **Solo builder:** unit tests for core business logic; one E2E smoke test for the critical path; manual exploratory pass before each release; dependency scanning in CI. Skip contract tests, skip chaos, skip BDD.
- **Team of 5:** full pyramid as described above; CI pipeline green-required on merge; preview environments per PR; shift-left security (SAST, SCA); quarterly accessibility audit.
- **Team of 50:** contract tests between services; dedicated test infrastructure; flakiness dashboard; regular performance regression runs; quarterly game days; dedicated SDET or test-platform engineer.
- **Team of 500+:** multiple SDETs; formal test-platform team; automated chaos practice; continuous delivery with high-bar automated gates; embedded security specialists; accessibility program with dedicated auditors.

---

## Exit checklist (per release)

- [ ] Unit + integration tests green on the release candidate commit.
- [ ] E2E smoke suite green on staging.
- [ ] Security scans green (SAST, dependency scan, secrets scan).
- [ ] Accessibility check complete on any new UI (axe-core + manual keyboard test).
- [ ] Performance regression check on critical paths — p95 latency within threshold of baseline.
- [ ] Exploratory session completed on new functionality; findings addressed or accepted.
- [ ] Observability added for new code paths (logs, metrics, traces — see Phase 07).
- [ ] Feature flags configured and tested for gradual rollout.
- [ ] Rollback plan written down and understood.

---

## Why this works

The recommendations above trace back to specific research documents and primary sources. If you disagree with a recommendation, read the linked research and pick differently.

- **Start with the pyramid, treat the trophy as an alternative** — see [`../research/05-testing/test-models.md`](../research/05-testing/test-models.md), which covers Cohn/Fowler/Vocke on the pyramid and Dodds on the trophy. Both authors are explicit that the model is a heuristic; both are context-dependent.
- **Push tests down the pyramid; narrow integration tests; treat test code like production code** — [`../research/05-testing/test-levels.md`](../research/05-testing/test-levels.md) covers the Meszaros test-double taxonomy, Fowler's solitary/sociable framing, contract testing via Pact, and the Wikipedia definitions of each level.
- **70–80% coverage floor, not 100%; treat coverage as a signal** — [`../research/05-testing/test-automation.md`](../research/05-testing/test-automation.md) quotes Fowler's skepticism, the Wikipedia coverage entry's limits (infeasible paths, masked race conditions), and explains why coverage doesn't prove correctness.
- **Quarantine flaky tests immediately** — [`../research/05-testing/test-automation.md`](../research/05-testing/test-automation.md) documents Google's 2016 mitigation practice (quarantine, reruns, statistical tracking).
- **k6 for performance; OWASP DevSecOps taxonomy for security; WCAG 2.2 AA with axe-core for accessibility** — [`../research/05-testing/non-functional-testing.md`](../research/05-testing/non-functional-testing.md) covers k6's six test types, OWASP's SAST/DAST/IAST/SCA framing, and the WCAG POUR principles.
- **Shift-left, developer-owned testing, SDET as multiplier** — [`../research/05-testing/quality-engineering.md`](../research/05-testing/quality-engineering.md) records Larry Smith's 2001 origin of shift-left, DORA's capability framing, and Fowler's two-stage CI structure (under-10-minute commit build).
- **Canary detects problems, A/B validates hypotheses, dark launch tests load invisibly, chaos experiments in prod with bounded blast radius** — [`../research/05-testing/chaos-and-production-testing.md`](../research/05-testing/chaos-and-production-testing.md) has Fowler's verbatim definitions and the Principles of Chaos four-step method.
- **Exploratory testing alongside automation; session-based test management** — [`../research/05-testing/exploratory-and-context-driven.md`](../research/05-testing/exploratory-and-context-driven.md) covers Kaner and Bach on exploratory testing and the seven principles of the context-driven school. The context-driven stance also explains why every recommendation here is conditional on context rather than universal.
- **Synthetic data in non-prod; anonymize before any use of production data; environments favor fewer-plus-canary over many-static** — [`../research/05-testing/test-data-and-environments.md`](../research/05-testing/test-data-and-environments.md) covers test data management, GDPR/CPRA obligations, and the Fowler-implied trade-off between static pre-prod environments and production-based testing.

The bet of this phase is simple. If your tests are fast, trusted, and authored by the people who wrote the code, you will ship small changes often, catch regressions early, and spend Fridays building instead of firefighting. Nothing about software delivery in 2026 rewards a culture that treats testing as somebody else's job.
