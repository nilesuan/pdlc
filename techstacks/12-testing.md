---
name: testing stack
description: Industry-standard testing tools and practices across unit, integration, E2E, contract, and load testing
type: research
---

# Testing

**Question:** What are the current industry-standard tools and practices for software testing in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Unit, integration, end-to-end (E2E), component, contract, visual, and load/performance testing. Security testing (SAST/DAST/SCA) is in `13-security.md`. CI wiring is in `07-ci-cd.md`.

## Shape of the decision

The testing stack a team assembles depends on the language/runtime and on the product shape (web, API, mobile, data pipeline). Decisions split across levels:

1. **Unit test runner** — per-language: pytest (Python), Vitest or Jest (JS/TS), JUnit (Java), Go `testing` (Go), XCTest (Swift), RSpec/Minitest (Ruby), NUnit / xUnit (.NET), etc.
2. **Integration / component tests** — Testcontainers (with real databases/message queues), Testing Library (React), Supertest (HTTP).
3. **E2E / browser** — Playwright is now the clear leader for web E2E; Cypress second; Selenium in legacy and broad-compatibility contexts.
4. **Contract tests** — Pact dominates consumer-driven contract testing.
5. **Load / performance** — k6 (now Grafana k6), JMeter, Gatling, Locust.
6. **Visual regression / snapshot** — Chromatic, Percy, Playwright snapshots, Storybook test runner.

Governance concepts:

- **Test pyramid** — widely cited mental model: many unit tests, fewer service tests, fewer still end-to-end tests. From Mike Cohn's *Succeeding with Agile*; modernized by Ham Vocke [[The Practical Test Pyramid — Ham Vocke / Thoughtworks, 2018](https://martinfowler.com/articles/practical-test-pyramid.html)] (accessed 2026-04-24) [VERIFIED].
- **Testing Trophy** — Kent C. Dodds's alternative emphasizing integration tests (React Testing Library era). [UNVERIFIED in this session; widely referenced.]

## Evidence base

- **Python testing (primary).** [[Python Developers Survey 2024 — JetBrains / PSF](https://lp.jetbrains.com/python-developers-survey-2024/)] (accessed 2026-04-24) [VERIFIED]: pytest **53%**, unittest **23%**, mock **11%**, doctest **6%**, tox **5%**, Hypothesis **4%**, nose **2%**, None **36%**. Survey filtered to >25,000 respondents from 30,000+ originals, collected October–November 2024.
- **JavaScript testing (primary usage count).** [[State of JavaScript 2024 — Testing](https://2024.stateofjs.com/en-US/libraries/testing/)] (accessed 2026-04-24) [VERIFIED]: at-work respondent counts: **Jest 7,262; Vitest 3,986; Playwright 3,674; Cypress 3,603; Testing Library 2,970; Storybook 4,660; Mocha 2,082; Jasmine 77**. Respondents average 3.8 testing tools used; overall happiness 3.5/5. Pain points: Mocking (284 mentions), Configuration (213), Performance (187).
- **Vitest trajectory.** State of JS 2024 frames Vitest as "displays the classic signs of a technology at the start of its lifespan: high retention and interest, but low adoption in large companies — for now" [VERIFIED].
- **Playwright > Cypress npm trend.** Playwright surpassed Cypress in weekly npm downloads in mid-2024 [[Checkly — Playwright surpasses Cypress](https://www.checklyhq.com/blog/playwright-surpasses-cypress-for-downloads/)] (accessed 2026-04-24) [VERIFIED qualitatively; exact date given as "a few weeks" before June 2024]. Exact current-week download totals are live data and should be checked on npmtrends directly before quoting.

## JavaScript / TypeScript testing

### Unit testing: Jest and Vitest

- **Jest** — long-time default. Zero-config for most projects, mocking built-in, large ecosystem. JetBrains 2024 surveys place Jest at ~63% of JS unit-testing [UNVERIFIED — secondary summary].
- **Vitest** — built to match the Jest API but powered by Vite's dev-server infrastructure. Much faster startup, HMR during tests, native ESM. Migrations from Jest to Vitest are common in Vite-based projects. State of JS 2024 places Vitest at 3,986 at-work users vs Jest's 7,262 — Jest still leads, Vitest rising fast [VERIFIED].
- **Mocha** — older; still used especially in Node-server-side projects. State of JS 2024: 2,082 at-work users [VERIFIED].
- **Jasmine** — predecessor of Jest; largely legacy. 77 respondents [VERIFIED].

### Component / integration testing

- **Testing Library family** (`@testing-library/react`, `@testing-library/vue`, etc.) — encourages testing via the DOM as a user would, instead of testing component internals. Dominant for React component tests. State of JS 2024: 2,970 at-work users [VERIFIED].
- **Supertest** — HTTP assertion library, common with Express / Fastify / Nest.
- **MSW (Mock Service Worker)** — intercepts network requests for tests and local dev. Adoption grew sharply in 2023–2025 [UNVERIFIED specific share].

### E2E: Playwright, Cypress, Selenium

- **Playwright** (Microsoft, open source) — multi-browser (Chromium/Firefox/WebKit), multi-language (TS/JS/Python/Java/.NET), auto-waiting, parallel execution. Now the most-downloaded JS E2E tool [[Checkly](https://www.checklyhq.com/blog/playwright-surpasses-cypress-for-downloads/)] [VERIFIED]. State of JS 2024: 3,674 at-work users, satisfaction the highest of the E2E tools [VERIFIED count].
- **Cypress** — popularized modern JS E2E in 2017. Retains strengths in developer experience for simple cases; adoption has plateaued per npm data. State of JS 2024: 3,603 at-work users [VERIFIED].
- **Selenium** — W3C WebDriver standard; the broad-compatibility / language-diverse choice. Still dominant in polyglot QA organizations and cloud browser-farms (BrowserStack, Sauce Labs).
- **Puppeteer** — Chrome DevTools Protocol scripting from Node. Lower-level than Playwright; shares a design heritage. Less used for E2E, more for scraping / PDF generation.

## Python testing

- **pytest** — 53% of Python devs [[Python Developers Survey 2024](https://lp.jetbrains.com/python-developers-survey-2024/)] [VERIFIED]. Simple assert-based syntax, fixtures, parametrization, huge plugin ecosystem (pytest-cov, pytest-xdist, pytest-asyncio, pytest-django, pytest-flask, pytest-mock, pytest-bdd, Hypothesis integration).
- **unittest** — Python stdlib; 23% [VERIFIED]. Still dominant in older codebases and enterprises that prefer stdlib-only.
- **Hypothesis** — property-based testing. 4% reported use [VERIFIED]. Niche but well-regarded where used.
- **tox / nox** — test-matrix runners across Python versions / environments. tox at 5% [VERIFIED].
- **mock** — stdlib mocking library (`unittest.mock`) used broadly. 11% self-identified as using "mock" as a tool [VERIFIED].
- **Playwright for Python** — Python bindings to Playwright; used for E2E in Python shops.

## Java / JVM testing

- **JUnit** — dominant for Java unit tests. **JUnit 5** (Jupiter) is the current line and the default in new projects; JUnit 4 still widespread in maintained codebases. Secondary-source surveys (Maven Repository and multiple aggregators) put JUnit at 60–63% of Java projects and TestNG at ~6% [UNVERIFIED — primary survey not fetched].
- **TestNG** — alternative runner; strong in large integration-test and enterprise / Selenium-heavy contexts.
- **Mockito** — dominant mocking library for Java.
- **AssertJ / Hamcrest / Truth** — fluent-assertion libraries.
- **Spock** — Groovy-based BDD-style testing on the JVM. Niche.

## Go / Rust / .NET testing

- **Go** — `testing` (stdlib) is the default; `testify` adds assertions and mocks; `ginkgo`/`gomega` provide BDD-style syntax.
- **Rust** — `#[test]` attribute + `cargo test` built in; `proptest` / `quickcheck` for property-based; `tokio-test` for async; `insta` for snapshots.
- **.NET** — xUnit.net (modern default), NUnit (older default), MSTest (Microsoft's, bundled in Visual Studio). Moq for mocks.

## Integration testing with Testcontainers

**Testcontainers** has emerged as the standard way to spin up real external services (databases, message queues, browsers) as Docker containers during tests, eliminating mocking of infrastructure for integration tests.

- Available in Java, .NET, Go, Node.js, Python, Rust, Ruby, and more.
- Java implementation: 8,600+ GitHub stars; .NET: 4,200+; Rust: 1,000+ [VERIFIED via GitHub numbers in this session].
- Paired with `pytest-docker`, `testcontainers-java`, etc.

Using Testcontainers shifts the test strategy away from mocks of PostgreSQL / Redis / Kafka toward ephemeral-real instances — this is the DORA-aligned pattern of testing against realistic dependencies.

## Contract testing

For testing service boundaries in microservice architectures, **consumer-driven contract testing** is the standard model.

- **Pact** — the dominant tool. Consumer defines the contract (expected requests / responses); provider verifies it in its own CI. Pact Broker (or PactFlow, the commercial hosted version) coordinates contracts between services.
- Adopted in microservice-heavy shops where full E2E tests across dozens of services are impractical.
- Complementary to, not a replacement for, OpenAPI / AsyncAPI schema validation.

## Load / performance testing

- **k6 (Grafana k6)** — JavaScript-scripted load tests, CLI-first, Prometheus/Grafana-native metrics output. Owned by Grafana Labs since 2021 [UNVERIFIED specific acquisition date].
- **JMeter** — Apache project; XML / UI-based. Strong protocol coverage (JMS, FTP, JDBC beyond HTTP). Dominant in established enterprises; heavy resource footprint vs. k6.
- **Gatling** — Scala-DSL load testing. Popular in JVM shops.
- **Locust** — Python-scripted; distributed mode.
- **Artillery** — Node-based; YAML + JS. Good for CI-style small load tests.
- **Cloud-vendor SaaS:** AWS Distributed Load Testing, Azure Load Testing, BlazeMeter (JMeter-compatible), LoadRunner (enterprise-legacy).

## Visual regression and snapshot testing

- **Chromatic** (Storybook-adjacent) — commercial visual-regression service tied to Storybook stories.
- **Percy** (BrowserStack) — visual regression as a SaaS.
- **Playwright snapshots / toMatchSnapshot** — screenshot diffs inline with Playwright.
- **jest-image-snapshot / playwright-visual-comparison** — self-hosted alternatives.

## Mocking, fakes, and test data

- **MSW** — intercepts fetch/XHR at the service-worker layer.
- **nock** — Node HTTP mocking.
- **Mock Service Worker / WireMock (Java) / wiremock.net / vcrpy (Python)** — record-replay against real services.
- **Faker (Python/JS/etc.)** — fake test data.
- **Factory-bot / factory_boy** — test-object factories.

## BDD / acceptance testing

- **Cucumber / Gherkin** — natural-language-style scenarios; used where business analysts or QAs author tests. Still widespread in large enterprises.
- **SpecFlow** (.NET Cucumber port) — being renamed/retired; active forks exist [UNVERIFIED].
- **Behave** (Python) — niche.

BDD style lost ground in application-developer-authored test suites during 2015–2020 but remains in specific domains (financial services, insurance, government).

## Mobile testing

- **XCUITest** (iOS), **Espresso** (Android native) — vendor-native E2E.
- **Appium** — WebDriver for mobile (cross-platform). Legacy / regulated environments.
- **Detox** — React Native E2E.
- **Maestro** — YAML-script-based mobile UI testing. Rising in 2024–2026 [UNVERIFIED share].
- See `04-mobile.md` for mobile framework context.

## Accessibility (a11y) testing

- **axe-core** (Deque) — the dominant JS accessibility rules engine. Wrapped by jest-axe, @axe-core/playwright, Cypress-axe.
- **pa11y** — CLI wrapping axe-core.
- **Lighthouse CI** — bundles axe plus performance / best-practice checks.

## Putting the stack together (typical 2026 defaults)

- **TS/React frontend:** Vitest (unit/component) + Testing Library + Playwright (E2E) + MSW (API mocking). Add Storybook + Chromatic if design-system-heavy.
- **Node backend:** Vitest or Jest + Supertest (HTTP assertions) + Testcontainers (real Postgres/Redis/Kafka in CI) + Pact (contracts with other services) + k6 (load).
- **Python backend:** pytest + pytest-asyncio + Testcontainers for Python + pytest-cov + Hypothesis for property-based + Locust or k6 for load.
- **Java/Kotlin backend:** JUnit 5 + Mockito + AssertJ + Testcontainers-Java + Spring Boot Test + Pact + Gatling or k6.
- **.NET backend:** xUnit.net + Moq + FluentAssertions + Testcontainers-dotnet + k6 or NBomber.
- **Mobile (React Native):** Jest + Detox or Maestro for E2E.
- **Mobile (Flutter):** `package:test` + Flutter Widget Tests + Integration Tests + patrol.

## Sources (accessed 2026-04-24)

- [Python Developers Survey 2024 — JetBrains / Python Software Foundation](https://lp.jetbrains.com/python-developers-survey-2024/)
- [State of JavaScript 2024 — Testing](https://2024.stateofjs.com/en-US/libraries/testing/)
- [Ham Vocke — The Practical Test Pyramid (Thoughtworks, 2018)](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Checkly — Playwright surpasses Cypress for downloads](https://www.checklyhq.com/blog/playwright-surpasses-cypress-for-downloads/)
- [Testcontainers org on GitHub](https://github.com/testcontainers)

## Open questions

- **Exact Playwright vs Cypress npm current counts** — live-changing; secondary sources cite 30M+/week vs 6.5M+/week mid-2025, but should be re-checked on npmtrends.
- **JUnit vs TestNG share in 2026** — widely reported 60/40-ish in new projects but no primary survey extracted.
- **Adoption of Hypothesis and property-based testing in other languages** — no primary survey for JS / Rust / Go.
- **Testcontainers adoption share** — qualitative signals strong; no primary survey.
- **Pact vs OpenAPI-schema-validation split in contract testing** — not surveyed.
- **Mobile E2E share (XCUITest vs Appium vs Maestro vs Detox)** — anecdotal.
- **Accessibility-testing adoption rate** — likely growing with legal requirements (EAA, Section 508 updates) but no primary survey pulled.
