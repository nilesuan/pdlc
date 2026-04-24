# Quality Engineering — Shift-Left, QA vs QE, Continuous Testing

**Question:** How has the testing role evolved from classical QA to quality engineering, what does shift-left actually mean, and what does DORA research say about testing capabilities?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Shift-left testing

### Origin

[VERIFIED] The term originates in Larry Smith's *Dr. Dobb's Journal* article "Shift-Left Testing," September 2001. Smith's opening definition, quoted verbatim from a mirror of the original DDJ article ([Sep01: Shift-Left Testing — Larry Smith, Dr. Dobb's Journal, September 2001 (mirror)](https://jacobfilipp.com/DrDobbs/articles/DDJ/2001/0109/0109e/0109e.htm) (accessed 2026-04-24)):

> "Shift-left testing is how I refer to a better way of integrating the quality assurance (QA) and development parts of a software project."

Smith developed the concept from his experience at Digital/Compaq working on Tru-64 UNIX, integrating QA into the development cycle from the earliest stages. The ACM Digital Library index record confirms the canonical metadata ([Shift-left testing — Dr. Dobb's Journal, DOI 10.5555/500399.500404](https://dl.acm.org/doi/10.5555/500399.500404) — direct fetch returned 403 on 2026-04-24, but the paper is indexed as *DDJ* Vol. 26 Issue 9, September 2001, by Larry Smith per Wikipedia and the mirror).

Wikipedia's definition of the generalized concept: "Shift-left testing is an approach to software testing and system testing in which testing is performed earlier in the lifecycle (i.e. moved left on the project timeline)." [VERIFIED] [Shift-left testing — Wikipedia](https://en.wikipedia.org/wiki/Shift-left_testing) (accessed 2026-04-24).

### The four types

Wikipedia distinguishes four variants of shift-left testing:

1. **Traditional shift-left testing** — moves emphasis from acceptance/system-level testing to unit and integration testing; uses API testing and modern test tools rather than GUI record-and-playback.
2. **Incremental shift-left testing** — decomposes development into multiple increments (smaller V models); shifts testing leftward across these shorter cycles; popular for large, complex systems including hardware.
3. **Agile/DevOps shift-left testing** — uses numerous short-duration sprints; may incorporate test-first and TDD; Agile focuses on developmental testing, DevOps adds operational testing post-deployment.
4. **Model-based shift-left testing** — tests requirements, architecture, and design models before software implementation; "still in early adoption stages." [VERIFIED] [Shift-left testing — Wikipedia](https://en.wikipedia.org/wiki/Shift-left_testing) (accessed 2026-04-24).

### Motivation

The Wikipedia entry catalogues the harms of late testing: insufficient testing resources, undiscovered defects in requirements and design, debugging difficulties as systems grow, reduced code coverage, and accumulating technical debt that can jeopardize projects. [VERIFIED] [Shift-left testing — Wikipedia](https://en.wikipedia.org/wiki/Shift-left_testing) (accessed 2026-04-24).

### Shift-left security

OWASP's DevSecOps Guideline applies the same principle to security — detecting "security issues (by design or application vulnerability) as fast as possible" by integrating SAST, DAST, IAST, and SCA into the delivery pipeline. [VERIFIED] [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/latest/) (accessed 2026-04-24).

---

## QA vs Quality Engineering — what has actually changed

[SYNTHESIS from the DORA and Fowler sources below] The role of testers in modern delivery has shifted in two observable ways in the primary sources I fetched:

1. **Developers now own test authorship.** DORA's test automation capability page: "Developers primarily own test creation and maintenance, with testers collaborating throughout." [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

2. **Programmers write the unit tests.** Fowler's entry on UnitTest cites programmer-written tests as one of the three defining features of the modern unit-testing practice, noting this is "a shift from earlier practices where specialized testers handled this." [VERIFIED] [UnitTest — Martin Fowler](https://martinfowler.com/bliki/UnitTest.html) (accessed 2026-04-24).

The phrases "Quality Engineering" and "SDET" (Software Development Engineer in Test) are widely used in industry but I did not fetch a canonical primary source defining them in this session. I therefore do not assert formal definitions here. k6's documentation does name "SDETs" as part of its target audience alongside engineers, QA specialists, and SREs — evidence that the term is in active professional use but not a definition. [VERIFIED] [Grafana k6 Docs](https://grafana.com/docs/k6/latest/) (accessed 2026-04-24).

[UNVERIFIED] Further, the terms "embedded tester" and formal Quality Engineering role definitions used by large tech firms are not covered by a primary source I fetched and are omitted rather than described speculatively.

---

## Continuous testing

### DORA's test automation capability

DORA identifies test automation as essential for building quality into software delivery. Its summary: "the key to building quality into software is getting fast feedback on the impact of changes throughout the software delivery lifecycle." [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

DORA enumerates testing types high-performing teams use across layers:

- Unit tests validating individual methods/classes/functions using TDD.
- Acceptance tests verifying higher-level functionality against running systems.
- Manual testing including exploratory, usability, and acceptance activities run throughout delivery.

The framing: teams should "perform all types of testing continuously throughout the software delivery lifecycle" rather than relegating testing to post-development phases. [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

### Characteristics of high-performing teams (per DORA)

- Developers primarily own test creation and maintenance; testers collaborate throughout.
- Test suites remain fast, providing "feedback from automated tests in less than ten minutes."
- Teams continuously review and improve test suites to control complexity and cost.
- Tests follow a pyramid structure, emphasizing unit tests that catch errors earliest. [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

### Reported correlations with delivery performance

DORA's findings tie test automation to four outcomes:

- Improved software stability and reduced defects reaching production.
- Shortened feedback cycles, enabling developers to fix issues immediately.
- Reduced team burnout.
- Lower deployment pain via earlier defect detection. [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

The page asserts that automation enables teams to achieve higher deployment frequency and shorter lead times — both core DORA metrics. [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24).

### Fowler on tests as the CI gate

Fowler's view, already referenced in `test-automation.md`: "The test of such a test suite is that we should be confident that if the tests are green, then no significant bugs are in the product." Tests must be comprehensive enough that build green means ready-to-ship. [VERIFIED] [Continuous Integration — Martin Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24).

### Two-stage pipeline structure

Fowler recommends a two-stage structure:

- **Commit build** — unit tests with mocked external dependencies; completes in under ten minutes.
- **Secondary build** — slower integration tests against real databases and services. [VERIFIED] [Continuous Integration — Martin Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24).

---

## DORA's continuous testing capability (open question)

The dedicated `/capabilities/continuous-testing/` URL under `dora.dev` returned 404 during this session. The nearest primary source I obtained for the continuous-testing framing is the test-automation capability page above, which already states the principle: "perform all types of testing continuously throughout the software delivery lifecycle." [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24). Until the continuous-testing page is relocated and fetched, I do not cite it.

---

## Sources

- [Sep01: Shift-Left Testing — Larry Smith, Dr. Dobb's Journal, September 2001 (mirror at jacobfilipp.com)](https://jacobfilipp.com/DrDobbs/articles/DDJ/2001/0109/0109e/0109e.htm) (accessed 2026-04-24)
- [Shift-left testing — DDJ index, ACM DL DOI 10.5555/500399.500404](https://dl.acm.org/doi/10.5555/500399.500404) (index metadata; direct fetch returned 403 on 2026-04-24)
- [Shift-left testing — Wikipedia](https://en.wikipedia.org/wiki/Shift-left_testing) (accessed 2026-04-24)
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/latest/) (accessed 2026-04-24)
- [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24)
- [UnitTest — Martin Fowler](https://martinfowler.com/bliki/UnitTest.html) (accessed 2026-04-24)
- [Grafana k6 Docs](https://grafana.com/docs/k6/latest/) (accessed 2026-04-24)
- [Continuous Integration — Martin Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)

---

## Open questions

- DORA's dedicated "continuous testing" page returned 404; when relocated it should be added.
- A formal vendor-neutral primary definition for "Quality Engineering" and "SDET" was not located here. Industry surveys (e.g., the State of Testing reports) may be appropriate next fetches.
- The ACM Digital Library record for Smith's 2001 DDJ article returned HTTP 403 on direct fetch; the article text is verified via the jacobfilipp.com DDJ mirror. Publisher-side access would close a minor durability gap.
