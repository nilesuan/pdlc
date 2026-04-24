# Levels of Testing — Unit, Integration, Contract, End-to-End, Acceptance

**Question:** What distinguishes the canonical test levels from each other, and what is the verified definition of each?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Unit testing

### Definition

The Wikipedia *Unit testing* entry defines unit testing as "a form of software testing where isolated source code is tested to validate expected behavior." [VERIFIED] [Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing) (accessed 2026-04-24).

A unit is "a single behaviour exhibited by the system under test (SUT), usually corresponding to a requirement." Units map to functions, modules, methods, or classes depending on paradigm. [VERIFIED] [Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing) (accessed 2026-04-24).

### The "what is a unit" question

Fowler notes that the term "unit testing" is poorly defined across the industry but identifies three common elements: low-level focus on small software components; programmer-written (as distinct from separate test specialists); and significantly faster to execute than other test types. The concept of "a unit" is situational — "it might be a single class, function, or related group of classes, depending on team needs." [VERIFIED] [UnitTest — Martin Fowler](https://martinfowler.com/bliki/UnitTest.html) (accessed 2026-04-24).

### Solitary vs sociable

Fowler distinguishes two styles:

- **Solitary tests** use test doubles (mocks) to replace collaborating classes, isolating the unit.
- **Sociable tests** use real collaborators and assume everything else functions correctly.

Fowler identifies the two schools as "mockists" (solitary) and "classicists" (sociable) and says he "personally favors sociable tests" and uses test doubles pragmatically — "primarily when collaborations are awkward, like remote services or external resources." [VERIFIED] [UnitTest — Martin Fowler](https://martinfowler.com/bliki/UnitTest.html) (accessed 2026-04-24).

### Test doubles (Meszaros's vocabulary)

Fowler summarizes Gerard Meszaros's categorization: "Test Double" is an umbrella term "for any case where you replace a production object for testing purposes." The five types:

1. **Dummy** — "objects are passed around but never actually used. Usually they are just used to fill parameter lists."
2. **Fake** — "objects actually have working implementations, but usually take some shortcut which makes them not suitable for production."
3. **Stub** — "provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in."
4. **Spy** — stubs with recording capabilities to track how they were called.
5. **Mock** — "pre-programmed with expectations which form a specification of the calls they are expected to receive. They can throw an exception if they receive a call they don't expect." [VERIFIED] [TestDouble — Martin Fowler](https://martinfowler.com/bliki/TestDouble.html) (accessed 2026-04-24).

### History

Unit testing's foundations trace back to 1956 (H.D. Benington, SAGE project, "parameter testing"). Kent Beck created SUnit for Smalltalk in 1989; JUnit was released in 1997 by Beck and Erich Gamma for Java. [VERIFIED] [Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing) (accessed 2026-04-24).

### Benefits

Wikipedia summarizes six commonly cited benefits: early problem detection, cost reduction (defects caught early cost less to fix), refactoring safety, support for frequent releases, design contract verification, and living documentation. [VERIFIED] [Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing) (accessed 2026-04-24).

---

## Integration testing

### Definition

Wikipedia: "Integration testing is a form of software testing in which multiple software components, modules, or services are tested together to verify they work as expected when combined." [VERIFIED] [Integration testing — Wikipedia](https://en.wikipedia.org/wiki/Integration_testing) (accessed 2026-04-24).

Integration testing sits "at an intermediate level — after unit testing but before system testing." It takes modules that have already passed unit tests, combines them into larger aggregates, and applies integration-level test plans. [VERIFIED] [Integration testing — Wikipedia](https://en.wikipedia.org/wiki/Integration_testing) (accessed 2026-04-24).

### Approaches

Four classical approaches described in the Wikipedia entry:

- **Big-bang** — most modules coupled together; tested as a whole. Saves time but can obscure failures.
- **Bottom-up** — lower-level components tested first, then used to facilitate testing of higher-level components.
- **Top-down** — "the top integrated modules are tested first and the branch of the module is tested step by step until the end."
- **Sandwich (mixed)** — combines top-down and bottom-up simultaneously; may not catch conditions outside specified integrations. [VERIFIED] [Integration testing — Wikipedia](https://en.wikipedia.org/wiki/Integration_testing) (accessed 2026-04-24).

### Narrow vs broad integration tests

Vocke recommends "narrow integration tests" that test one integration point at a time, using local instances of dependencies where possible rather than relying on production systems. His specific example: testing database persistence by starting a local database, writing data, and verifying retrieval. [VERIFIED] [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24).

---

## Contract testing

### Definition

Pact's documentation: contract testing is "a technique for testing an integration point by checking each application in isolation to ensure the messages it sends or receives conform to a shared understanding that is documented in a 'contract'." [VERIFIED] [Pact Docs](https://docs.pact.io/) (accessed 2026-04-24).

### Fowler's framing

Fowler's original framing titles the concept "Integration Contract Test": contract tests "check that all the calls against your test doubles return the same results as a call to the external service would." They address the gap between testing against mock objects and verifying those mocks match real external behavior. [VERIFIED] [ContractTest — Martin Fowler](https://martinfowler.com/bliki/ContractTest.html) (accessed 2026-04-24).

### How Pact works (consumer-driven contracts)

Pact is "a code-first tool for testing HTTP and message integrations using contract tests." Its distinctive mechanism is that "the contract is generated during the execution of the automated consumer tests" — developers write test cases that specify actual request/response pairs ("contract by example") rather than using static specifications. [VERIFIED] [Pact — Getting Started](https://docs.pact.io/getting_started) (accessed 2026-04-24).

Core terminology: **Consumer** (the application requesting data) and **Provider** (the application supplying the data). These replace client/server because microservice communication often happens over asynchronous channels like message queues. [VERIFIED] [Pact — Getting Started](https://docs.pact.io/getting_started) (accessed 2026-04-24).

Two key properties:

- **Selective coverage**: "only parts of the communication that are actually used by the consumer(s) get tested," allowing providers to change unused behavior freely.
- **Concrete examples**: each test describes a specific request/response pair, not all possible states. [VERIFIED] [Pact — Getting Started](https://docs.pact.io/getting_started) (accessed 2026-04-24) and [Pact Docs](https://docs.pact.io/) (accessed 2026-04-24).

### Contract testing vs integration testing

Per PactFlow:

| Aspect | Contract Testing | Integration Testing |
|---|---|---|
| Scope | Single API consumer-provider pair | Multiple components/systems |
| Speed | Fast; no environment needed | Slower; requires test setup |
| Feedback | Early (pre-commit/build) | Later (post-commit/deployment) |
| Side effects | Not checked | Verified |
| Dependencies | Isolated, independent | Requires coordination |

[VERIFIED] [Contract Testing vs Integration Testing — PactFlow](https://pactflow.io/blog/contract-testing-vs-integration-testing/) (accessed 2026-04-24).

### Fowler's cadence and build-failure note

Contract tests need not run on every deployment; they should follow "the rhythm of changes to the external service." A contract test failure "shouldn't necessarily break the build in the same way that a normal test failure would" — it should trigger investigation and communication with the external service team. [VERIFIED] [ContractTest — Martin Fowler](https://martinfowler.com/bliki/ContractTest.html) (accessed 2026-04-24).

---

## End-to-end (system) testing

### Definition

Wikipedia's *Software testing* entry identifies system testing (also called end-to-end testing) as the evaluation of "the complete software system as a unified whole." [VERIFIED] [Software testing — Wikipedia](https://en.wikipedia.org/wiki/Software_testing) (accessed 2026-04-24).

### Cautions

Vocke's article explicitly warns that end-to-end tests are "notoriously flaky" and recommends "minimizing them to critical user journeys." [VERIFIED] [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24). The same risk is why Fowler describes high-level tests as a "second line of test defense" rather than the primary one. [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24).

---

## Acceptance testing (ATDD)

### Definition

Wikipedia defines ATDD as "a development methodology based on communication between the business customers, the developers, and the testers." It emphasizes writing acceptance tests before developers begin coding and focuses on "external behavior of systems rather than internal implementation." [VERIFIED] [Acceptance test–driven development — Wikipedia](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development) (accessed 2026-04-24).

### Format

ATDD tests typically follow a Given/When/Then pattern:

- **Given** a specified system state
- **When** an action or event occurs
- **Then** the system state changes or produces output. [VERIFIED] [Acceptance test–driven development — Wikipedia](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development) (accessed 2026-04-24).

### Relationship to TDD and BDD

ATDD "encompasses practices similar to specification by example (SBE), behavior-driven development (BDD), and example-driven development (EDD)." It is "closely related to test-driven development (TDD)" but distinguishes itself through emphasizing "developer-tester-business customer collaboration." [VERIFIED] [Acceptance test–driven development — Wikipedia](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development) (accessed 2026-04-24).

---

## Sources

- [Unit testing — Wikipedia](https://en.wikipedia.org/wiki/Unit_testing) (accessed 2026-04-24)
- [UnitTest — Martin Fowler](https://martinfowler.com/bliki/UnitTest.html) (accessed 2026-04-24)
- [TestDouble — Martin Fowler](https://martinfowler.com/bliki/TestDouble.html) (accessed 2026-04-24)
- [Integration testing — Wikipedia](https://en.wikipedia.org/wiki/Integration_testing) (accessed 2026-04-24)
- [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24)
- [Pact Docs](https://docs.pact.io/) (accessed 2026-04-24)
- [Pact — Getting Started](https://docs.pact.io/getting_started) (accessed 2026-04-24)
- [ContractTest — Martin Fowler](https://martinfowler.com/bliki/ContractTest.html) (accessed 2026-04-24)
- [Contract Testing vs Integration Testing — PactFlow](https://pactflow.io/blog/contract-testing-vs-integration-testing/) (accessed 2026-04-24)
- [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)
- [Software testing — Wikipedia](https://en.wikipedia.org/wiki/Software_testing) (accessed 2026-04-24)
- [Acceptance test–driven development — Wikipedia](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development) (accessed 2026-04-24)

---

## Open questions

- The definition of "component testing" used by Toby Clemson for microservices was present in the article fetched but without enough structural detail in the excerpt returned; a deeper re-read of [https://martinfowler.com/articles/microservice-testing/](https://martinfowler.com/articles/microservice-testing/) is needed before writing it up.
- The Cem Kaner / James Bach distinction between acceptance testing and "customer testing" in the context-driven school was not separately verified here and is left out.
