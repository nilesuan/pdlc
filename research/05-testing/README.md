# Stage 05 — Testing & Quality

**Question:** What are the verified practices, models, and methods that constitute modern software testing and quality engineering, from unit testing through production experimentation and chaos engineering?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope

This stage covers the full testing discipline as it is practiced in contemporary software delivery:

- Test models (pyramid, trophy)
- Levels of testing (unit, integration, contract, E2E, acceptance)
- Test automation and its failure modes (flakiness, maintenance)
- Non-functional testing (performance, security, accessibility, usability)
- Shift-left testing
- Quality Assurance vs Quality Engineering (the role shift)
- Continuous testing in CI/CD
- Chaos engineering
- Production testing (canary, dark launch, A/B)
- Code coverage — what it does and does not measure
- Exploratory testing and context-driven testing
- Test data management and environments

The detailed content is split across the following files so each topic has enough space to cite primary sources without padding.

---

## Files in this stage

- `README.md` — this overview (scope, reading order, sources index).
- `test-models.md` — testing pyramid (Cohn / Fowler), testing trophy (Dodds), critiques.
- `test-levels.md` — unit, integration, contract, end-to-end, acceptance testing.
- `test-automation.md` — automation principles, flakiness, maintenance, coverage.
- `non-functional-testing.md` — performance, security (SAST/DAST/IAST/SCA), accessibility, usability.
- `quality-engineering.md` — shift-left, QA vs QE, continuous testing, DORA's capability framing.
- `chaos-and-production-testing.md` — chaos engineering, canary, dark launch, A/B testing.
- `exploratory-and-context-driven.md` — exploratory testing, context-driven school.
- `test-data-and-environments.md` — test data management, synthetic data, PII handling.

---

## Cross-stage links

- Stage 04 (development): TDD / BDD practices intersect with unit testing and ATDD.
- Stage 06 (release): canary releases, feature flags, and deployment pipelines consume the test artifacts defined here.
- Stage 07 (operations): chaos engineering operates on running production systems.
- Stage 01 (ideation): acceptance criteria and usability testing trace back to problem validation.

---

## Primary sources index

Every source in the per-topic files is fetched during research and listed with its access date. The top-level primary sources across this stage are:

- Martin Fowler, *TestPyramid* — [https://martinfowler.com/bliki/TestPyramid.html](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)
- Ham Vocke, *The Practical Test Pyramid* — [https://martinfowler.com/articles/practical-test-pyramid.html](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24)
- Kent C. Dodds, *The Testing Trophy and Testing Classifications* — [https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24)
- Principles of Chaos Engineering — [https://principlesofchaos.org/](https://principlesofchaos.org/) (accessed 2026-04-24)
- Pact, *Getting Started* — [https://docs.pact.io/getting_started](https://docs.pact.io/getting_started) (accessed 2026-04-24)
- Martin Fowler, *ContractTest* — [https://martinfowler.com/bliki/ContractTest.html](https://martinfowler.com/bliki/ContractTest.html) (accessed 2026-04-24)
- OWASP Web Security Testing Guide — [https://owasp.org/www-project-web-security-testing-guide/](https://owasp.org/www-project-web-security-testing-guide/) (accessed 2026-04-24)
- OWASP DevSecOps Guideline — [https://owasp.org/www-project-devsecops-guideline/latest/](https://owasp.org/www-project-devsecops-guideline/latest/) (accessed 2026-04-24)
- W3C WCAG overview — [https://www.w3.org/WAI/standards-guidelines/wcag/](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24)
- DORA, *Test Automation* capability — [https://dora.dev/capabilities/test-automation/](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24)
- Context-Driven Testing — [https://context-driven-testing.com/](https://context-driven-testing.com/) (accessed 2026-04-24)
- James Bach, *Satisfice* — [https://www.satisfice.com/exploratory-testing](https://www.satisfice.com/exploratory-testing) (accessed 2026-04-24)

---

## Open questions for the stage

- Netflix's original 2011 tech blog post on the Simian Army at `netflixtechblog.com` returned a certificate error during this session; history is reconstructed from the Wikipedia *Chaos engineering* and *Chaos Monkey* entries plus the Netflix GitHub repository instead. A re-fetch of the original post is pending.
- DORA's *continuous testing* capability page returned 404 during this session; the *test automation* capability page is fetched instead, and the continuous-testing framing is described only with the sources that did resolve.
- The Google Testing Blog post on flaky tests is fetched, but Google has not published public rates of flakiness for their monorepo at the URL used here; any prevalence figures in external summaries are not covered by the source I fetched and are omitted as `[UNVERIFIED]`.
- Larry Smith's 2001 article in *Dr. Dobb's Journal* coining the term "shift-left testing" is referenced via the Wikipedia article on shift-left testing; the original article URL was not fetched in this session.
