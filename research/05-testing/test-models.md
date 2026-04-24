# Test Models — Pyramid, Trophy, and Their Critiques

**Question:** What are the named models for how to distribute tests across levels, where did they originate, and what are the substantive critiques of each?

**Status:** Draft

**Last updated:** 2026-04-24

---

## The Testing Pyramid

### Origin

The pyramid was popularized by Mike Cohn in his 2009 book *Succeeding with Agile*. Martin Fowler's summary records that Cohn "originally drew it in conversation with Lisa Crispin in 2003-4" and presented it at a scrum gathering in 2004, with Jason Huggins independently developing the same idea around 2006. [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24).

### The three layers

Fowler's bliki entry describes the pyramid as three layers: a wide base of unit tests, a middle layer of service or integration tests (tests "acting through a service layer of an application" or "through an API layer"), and a narrow top of UI tests using tools like Selenium. [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24).

### The central argument

The essential claim is that "you should have many more low-level UnitTests than high level BroadStackTests running through a GUI." Fowler's reasoning: UI-driven testing is "brittle, expensive to write, and time consuming to run," and tests through graphical interfaces suffer from "non-determinism problems, which can undermine trust in them." [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24).

Fowler recommends treating high-level tests as "a second line of test defense" — when a failure occurs there, "before fixing a bug exposed by a high level test, you should replicate the bug with a unit test." [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24).

### Important caveat from Fowler

Fowler acknowledges an explicit exception: "If my high level tests are fast, reliable, and cheap to modify — then lower-level tests aren't needed." [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24). The pyramid is a heuristic about speed, reliability, and cost, not a rule about counts per se.

### Ham Vocke's practical elaboration

Ham Vocke's article on martinfowler.com expands the pyramid with concrete layers and tools. He frames the pyramid around two principles: "Write tests with different granularity" and "The more high-level you get the fewer tests you should have." [VERIFIED] [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24).

Vocke's layers as described in the article are:

- **Unit tests** — test individual units; the definition of a "unit" varies by language (functions in functional, classes/methods in object-oriented). Test observable behavior, not implementation details; skip trivial code like simple getters and setters.
- **Integration tests** — "narrow integration tests" that test one integration point at a time, using local instances of dependencies.
- **Contract tests** — Consumer-Driven Contract tests; Pact is named as the representative tool.
- **UI tests** — validate UI behavior, with modern single-page frameworks enabling unit-level UI testing.
- **End-to-end tests** — test complete workflows through deployed systems. Vocke warns these are "notoriously flaky" and recommends minimizing them to critical user journeys. [VERIFIED] [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24).

Vocke's operational rules:

- "Push tests down the pyramid" — keep tests at the lowest level where they give confidence.
- "If a higher-level test spots an error and there's no lower-level test failing, you need to write a lower-level test."
- Use arrange-act-assert (or given-when-then) structure.
- "Treat test code with the same rigor as production code." [VERIFIED] [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24).

---

## The Testing Trophy (Kent C. Dodds)

### The four layers, top to bottom

Kent C. Dodds' testing trophy reorganizes the classification into four tiers:

1. **End-to-End** — full application testing with minimal mocking.
2. **Integration** — multiple units working together.
3. **Unit** — individual functions, classes, or objects (with dependencies mocked).
4. **Static** — type checking and linting. [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24).

### Why the trophy, not the pyramid

Dodds positions the trophy as a model for frontend JavaScript applications and for contemporary development where static analysis (types, linting) is a meaningful tier:

- The pyramid "was designed for backend systems, not frontend JavaScript applications."
- "Static testing wasn't emphasized in earlier frameworks, but deserves inclusion in JavaScript development."
- The Trophy "emphasizes return on investment by widening the integration layer rather than maximizing unit tests." [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24).

### Dodds' core quote

Dodds' widely repeated thesis: "The more your tests resemble the way your software is used, the more confidence they can give you." [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24).

His framing of priorities: "it's all about getting a good return on your investment where 'return' is 'confidence' and 'investment' is 'time.'" [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24).

---

## Pyramid vs Trophy — how they disagree

[SYNTHESIS based on the two sources above]

The two models share a common shape: fewer expensive, high-level tests; more cheaper, low-level tests. They differ in the middle of the stack:

- The pyramid (Cohn/Fowler/Vocke) emphasizes a broad base of unit tests.
- The trophy (Dodds) emphasizes a broad layer of integration tests and adds a static tier at the bottom.

Both authors are explicit that the model is a heuristic, not a prescription. Fowler: "If my high level tests are fast, reliable, and cheap to modify — then lower-level tests aren't needed" [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24). Dodds: returns depend on context — "I had to choose something that made sense for me and as an educator, I had to choose something that would make the most sense" [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24).

---

## The honeycomb model

`[UNVERIFIED]` The "testing honeycomb" is widely attributed to Spotify's engineering writing on microservice testing, but I did not fetch a primary Spotify source for it during this session. Until a primary source is confirmed, this document does not describe it. The general shape of what others describe is preserved here only as an open question.

---

## Sources

- [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)
- [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24)
- [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24)

---

## Open questions

- A primary source for the "testing honeycomb" (commonly attributed to Spotify) was not located in this session. The term is used in engineering writing but without a verifiable primary source fetched here, so it is not described above.
- Mike Cohn's *Succeeding with Agile* (2009) is the cited origin of the pyramid but is a book and was not directly fetched; Fowler's bliki entry is used as the secondary record of its content.
- Toby Clemson's martinfowler.com article on microservice testing was fetched but returned only high-level terms; a targeted re-read is needed before citing specific component-testing definitions.
