# Exploratory Testing and Context-Driven Testing

**Question:** What is exploratory testing, how does it differ from scripted testing, and what is the context-driven school's stance on testing practice?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Exploratory testing

### Definition

Wikipedia's *Exploratory testing* entry characterizes the practice as "simultaneous learning, test design and test execution." It emphasizes the tester's cognitive engagement and treats test-related activities as "mutually supportive processes running in parallel." [VERIFIED] [Exploratory testing — Wikipedia](https://en.wikipedia.org/wiki/Exploratory_testing) (accessed 2026-04-24).

### James Bach's definition

From Satisfice's exploratory-testing page: "performing tests while learning things that may influence the testing. This is a scientific process." Bach emphasizes that this is fundamentally different from mere demonstration — "it involves genuine discovery and adaptation based on findings." [VERIFIED] [Exploratory Testing — James Bach, Satisfice](https://www.satisfice.com/exploratory-testing) (accessed 2026-04-24).

### Origin and key figures

Wikipedia attributes the term to Cem Kaner, who coined it in 1984. Bach and Kaner collaboratively developed the concept through the early 1990s "to distinguish rigorous, thoughtful testing from the sloppiness often associated with ad hoc testing methods." James Marcus Bach is "a prominent co-developer of exploratory testing theory." [VERIFIED] [Exploratory testing — Wikipedia](https://en.wikipedia.org/wiki/Exploratory_testing) (accessed 2026-04-24).

### Main elements (Bach's framing)

Three elements are drawn from Bach's satisfice.com writing:

- **Agency and accountability** — exploratory testing requires "someone who possesses agency and is therefore accountable for that work." This distinguishes it from automated or purely algorithmic processes.
- **Learning and mental models** — the tester continuously builds understanding of the product through interaction.
- **Structured informality** — although it appears unstructured to outsiders, exploratory testing maintains "a pattern that persists," shaped by goals, tools, skills, and product elements. [VERIFIED] [Exploratory Testing — James Bach, Satisfice](https://www.satisfice.com/exploratory-testing) (accessed 2026-04-24).

### Scripted vs exploratory — the degree-of-freedom axis

Per Wikipedia:

- **Scripted testing** — test cases designed in advance with predetermined steps and expected results; testers mechanically compare actual outcomes against predictions.
- **Exploratory testing** — expectations remain open; testers configure, operate, and critically observe the software's behavior in real-time, adapting their approach based on discoveries; this approach generates new tests dynamically rather than executing predetermined sequences. [VERIFIED] [Exploratory testing — Wikipedia](https://en.wikipedia.org/wiki/Exploratory_testing) (accessed 2026-04-24).

Bach puts this as a continuum: "all testing contains both elements. The critical difference is the degree of freedom testers exercise to adjust their approach based on emerging discoveries — something impossible in purely scripted approaches where predetermined procedures must be followed regardless of new findings." [VERIFIED] [Exploratory Testing — James Bach, Satisfice](https://www.satisfice.com/exploratory-testing) (accessed 2026-04-24).

### Where it fits in the modern pipeline

DORA's test automation capability page lists exploratory testing explicitly among "manual testing including exploratory, usability, and acceptance activities run throughout delivery." [VERIFIED] [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24). This corroborates the view that automated testing does not replace exploratory testing; they are complementary.

---

## The context-driven school

### The seven basic principles

Verbatim from context-driven-testing.com:

1. The value of any practice depends on its context.
2. There are good practices in context, but there are no best practices.
3. People, working together, are the most important part of any project's context.
4. Projects unfold over time in ways that are often not predictable.
5. The product is a solution. If the problem isn't solved, the product doesn't work.
6. Good software testing is a challenging intellectual process.
7. Only through judgment and skill, exercised cooperatively throughout the entire project, are we able to do the right things at the right times to effectively test our products. [VERIFIED] [Context-Driven Testing](https://context-driven-testing.com/) (accessed 2026-04-24).

### Founders

The site lists:

- Cem Kaner, J.D., Ph.D.
- James Bach
- Bret Pettichord (referenced in the foundational text *Lessons Learned in Software Testing*) [VERIFIED] [Context-Driven Testing](https://context-driven-testing.com/) (accessed 2026-04-24).

### Stance

From the site: "Context-driven testers choose their testing objectives, techniques, and deliverables by looking first to the details of the specific situation." And: "Context-driven testing is about doing the best we can with what we get. Rather than trying to apply 'best practices,' we accept that very different practices will work best under different circumstances." [VERIFIED] [Context-Driven Testing](https://context-driven-testing.com/) (accessed 2026-04-24).

---

## Why this matters for a PDLC

[SYNTHESIS]

The context-driven school's rejection of "best practices" directly constrains how any prescriptive PDLC document (this one included) can be written. The 7 principles are not a methodology; they are an epistemic stance — "the value of any practice depends on its context." A well-formed PDLC should therefore describe practices, their trade-offs, and the contexts in which they hold, rather than prescribe universals.

The same stance underlies Fowler's recurring caveats ("If my high level tests are fast, reliable, and cheap to modify — then lower-level tests aren't needed" [VERIFIED] [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)) and Dodds' framing of testing as a return-on-investment problem where "return is confidence and investment is time" [VERIFIED] [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24). All three traditions — Fowler's bliki, Dodds' JavaScript-community writing, and the context-driven school — converge on the point that testing decisions are investments sensitive to context.

---

## Sources

- [Exploratory testing — Wikipedia](https://en.wikipedia.org/wiki/Exploratory_testing) (accessed 2026-04-24)
- [Exploratory Testing — James Bach, Satisfice](https://www.satisfice.com/exploratory-testing) (accessed 2026-04-24)
- [Context-Driven Testing](https://context-driven-testing.com/) (accessed 2026-04-24)
- [Test Automation — DORA](https://dora.dev/capabilities/test-automation/) (accessed 2026-04-24)
- [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)
- [The Testing Trophy and Testing Classifications — Kent C. Dodds](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) (accessed 2026-04-24)

---

## Open questions

- The book *Lessons Learned in Software Testing* (Kaner, Bach, Pettichord) is referenced by the context-driven-testing.com page but was not fetched as a primary source in this session.
- Bach's more detailed *Rapid Software Testing* (RST) methodology is named in his blog navigation but its dedicated page was not fetched in depth.
- The relationship between exploratory testing and *session-based test management* (a practice often attributed to Jonathan Bach) was not separately verified here.
