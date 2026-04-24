# Coding Practices — TDD, BDD, Refactoring, Clean Code, Static Analysis, Style Guides

**Question:** What are the primary-source definitions of TDD, BDD, refactoring, Clean Code, static analysis tooling, and coding style guides, and what are the documented critiques?

**Status:** Draft

**Last updated:** 2026-04-24

## 1. Test-Driven Development (TDD)

TDD is associated with Kent Beck, who developed it in the late 1990s as part of Extreme Programming [VERIFIED].

### Martin Fowler's summary

Fowler summarizes the cycle as three steps [VERIFIED]:

1. "Write a test for the next bit of functionality you want to add."
2. "Write the functional code until the test passes."
3. "Refactor both new and old code to make it well structured."

These are "often summarized as _Red - Green - Refactor_." [TestDrivenDevelopment — Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html) (accessed 2026-04-24).

Fowler lists two primary benefits: **self-testing code** (you only write functional code in response to a failing test) and **interface-first design** (writing tests first forces thinking about how a class will be used). He warns that "the most common way that I hear to screw up TDD is neglecting the third step" — the refactor — leading to messy (but tested) code.

### Agile Alliance — timeline and origin

The Agile Alliance glossary gives a timeline [VERIFIED]:

- 1994 — Beck created the SUnit testing framework for Smalltalk.
- 1998 — Extreme Programming documentation mentioned writing tests first.
- 1998-2002 — "Test First" evolved into "Test Driven" methodology.
- 2003 — Beck published *Test Driven Development: By Example*, establishing TDD as a formal practice.

By 2006, derivative approaches like ATDD and BDD had emerged. [Test-Driven Development — Agile Alliance Glossary](https://www.agilealliance.org/glossary/tdd/) (accessed 2026-04-24).

### Beck's own recent framing — Canon TDD (2023)

Kent Beck published his own description of the TDD cycle on his Substack (tidyfirst.substack.com). He describes the workflow as [VERIFIED]:

1. "Write a list of the test scenarios you want to cover"
2. "Turn exactly one item on the list into an actual, concrete, runnable test"
3. "Change the code to make the test (& all previous tests) pass"
4. "Optionally refactor to improve the implementation design"
5. "Until the list is empty, go back to #2"

Beck emphasizes interface-first thinking: when writing tests developers "begin making design decisions, but they are primarily interface decisions." This confirms the design-as-practice framing associated with TDD (design, not just testing). [Canon TDD — Kent Beck, Tidy First? Substack](https://tidyfirst.substack.com/p/canon-tdd) (accessed 2026-04-24).

### Red-Green-Refactor, "Fake It," and "Triangulation" — from TDD By Example (2003)

Kent Beck's *Test Driven Development: By Example* (Addison-Wesley, 2003) introduces three implementation strategies inside the Red-Green-Refactor cycle. The book itself was not fetched directly, but two independent summaries of the book (one with direct quotations) corroborate the same content:

- **Red:** "Write a little test that doesn't work, and perhaps doesn't even compile at first."
- **Green:** "Make the test work quickly, committing whatever sins necessary in process."
- **Refactor:** "Eliminate all of the duplication created in merely getting the test to work."

Three techniques for getting to Green:

- **Fake It (till you make it)** — "Return a constant and gradually replace constants with variables until you have the real code."
- **Obvious Implementation** — "Type in the real implementation."
- **Triangulation** — "Abstract only when you have two or more examples." (By analogy to radar triangulation.)

[VERIFIED via two independent summaries with direct quotation from the book] [Notes on "Test-Driven Development by Example" by Kent Beck — Stanislaw Pankevich, 2016](https://stanislaw.github.io/2016-01-25-notes-on-test-driven-development-by-example-by-kent-beck.html) (accessed 2026-04-24). The book's existence, publication details, and canonical status are also confirmed by the Agile Alliance glossary cited above.

> Note: the book *Test Driven Development: By Example* (Beck, Addison-Wesley, 2003) was still not fetched directly in this session; direct quotations above come from a reader's annotated notes that quote the book verbatim. Kent Beck's own Substack (cited above) corroborates the design-practice framing and the five-step canonical cycle.

## 2. Behavior-Driven Development (BDD)

BDD was originated by Daniel Terhorst-North (commonly "Dan North"). His foundational article "Introducing BDD" was published in **March 2006** in *Better Software* magazine and is posted at [dannorth.net/blog/introducing-bdd/](https://dannorth.net/blog/introducing-bdd/) [VERIFIED]. [Introducing BDD — Dan North, 2006](https://dannorth.net/blog/introducing-bdd/) (accessed 2026-04-24).

Key principles as stated in North's article:

- Test names should read as plain-language sentences of expected behaviour (the "should" template — e.g. "The class _should_ do something").
- Focus on behaviour over testing — on what the system should do, not just on validation.
- Ubiquitous language across analysts, developers, testers, and stakeholders, using a **Given-When-Then** scenario format.
- Executable acceptance criteria that map scenario fragments to test code.

North was inspired by **agiledox**, a tool that converted test method names into readable sentences, and by Domain-Driven Design and user-story conventions.

### JBehave

North released **JBehave** in 2003 as a JUnit alternative using behaviour-focused vocabulary [VERIFIED, per his article]. It enables executable acceptance criteria by mapping scenario fragments to Java classes representing givens, events, and outcomes.

### Cucumber history

The Cucumber docs trace the history [VERIFIED]: RSpec followed JBehave in 2005, bringing BDD to Ruby. Aslak Hellesøy, while contributing to RSpec, launched a project called "Stories" to improve RSpec's Story Runner, later renamed **Cucumber** at his fiancée's suggestion. [History of BDD — Cucumber](https://cucumber.io/docs/bdd/history/) (accessed 2026-04-24).

Liz Keogh is named on the same page as another influential voice, promoting BDD concepts from 2004 onward.

### Gherkin syntax

Cucumber's reference page documents Gherkin keywords [VERIFIED]. [Gherkin Reference — Cucumber](https://cucumber.io/docs/gherkin/reference/) (accessed 2026-04-24).

Step keywords:

- `Given` — sets up initial context; "put the system in a known state" before interactions.
- `When` — describes an event or action.
- `Then` — specifies expected outcomes, using assertions.
- `And` / `But` — continue successive steps for readability.
- `*` — an asterisk can replace any step keyword for bullet-point-style lists.

Structure keywords: `Feature`, `Scenario` (or `Example`), `Background` (repeated `Given` steps run before each scenario), `Scenario Outline`, `Examples`.

Syntax details: comments begin with `#`; indentation uses spaces or tabs (two spaces recommended); doc strings use triple quotes or backticks; data tables use `|`. Keywords are translated to 70+ languages via `# language:` headers.

## 3. Refactoring — Martin Fowler

Martin Fowler's canonical definitions at [refactoring.com](https://refactoring.com/) [VERIFIED]:

- **Noun:** "a change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior."
- **Verb:** "to restructure software by applying a series of refactorings without changing its observable behavior."

[Refactoring — Martin Fowler](https://refactoring.com/) (accessed 2026-04-24).

### The book

The fetched page states the book is now in its **second edition**; the original was published 1997-1999 and the updated version came out approximately 18 years later. The second edition uses JavaScript examples; the refactorings apply across languages. A web edition is available to book owners with additional refactorings not in the print version. [VERIFIED].

### Workflows of refactoring

Fowler's "Workflows of Refactoring" infodeck lists seven workflows [VERIFIED]:

1. Two Hats
2. TDD Refactoring
3. Litter-Pickup Refactoring
4. Comprehension Refactoring
5. Preparatory Refactoring
6. Planned Refactoring
7. Long Term Refactoring

[Workflows of Refactoring — Fowler](https://martinfowler.com/articles/workflowsOfRefactoring/) (accessed 2026-04-24).

### Preparatory refactoring and the Beck quote

In the preparatory-refactoring article, Fowler cites Kent Beck's aphorism [VERIFIED]:

> "make the change easy, then make the easy change."

[Preparatory Refactoring Example — Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html) (accessed 2026-04-24).

The "Two Hats" principle from the same article: programmers operate either in refactoring mode (preserve behaviour, tests stay green) or feature-addition mode (riskier); by doing preparatory refactoring first, more time is spent in the safer mode.

## 4. Clean Code — Robert C. Martin, plus critiques

The task brief names Robert C. Martin ("Uncle Bob") for Clean Code and asks for a balanced view including critiques.

### What was verifiable this session

Martin's own site hosted the "Clean Architecture" post, which was fetched [VERIFIED]. [The Clean Architecture — Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) (accessed 2026-04-24). This post defines the Dependency Rule ("source code dependencies can only point inwards"), the four layers (Entities, Use Cases, Interface Adapters, Frameworks & Drivers), and the aim of framework/UI/database independence. It is **about clean architecture**, not the separate *Clean Code* book.

### SRP and SOLID — attribution verified to Martin's own site, not *Clean Code*

The SOLID principles are frequently misattributed to the *Clean Code* book. Martin's own 2014 and 2020 blog posts on cleancoder.com attribute them to his earlier writings and to the principles body of work (not to *Clean Code* specifically):

- **SRP (Single Responsibility Principle):** "Each software module should have one and only one reason to change." Equivalent formulation: "Gather together the things that change for the same reasons. Separate those things that change for different reasons." [VERIFIED]. Martin writes he consolidated SRP "in the late 1990s" and is unsure whether he adopted the name from Bertrand Meyer. The principle connects back to Parnas (1972) on module decomposition and Dijkstra (1974) on Separation of Concerns. [The Single Responsibility Principle — Robert C. Martin, blog.cleancoder.com 2014](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) (accessed 2026-04-24).
- **All five SOLID principles** restated in Martin's 2020 blog post [VERIFIED]: SRP as above; **OCP** "A Module should be open for extension but closed for modification"; **LSP** "A program that uses an interface must not be confused by an implementation of that interface"; **ISP** "Keep interfaces small so that users don't end up depending on things they don't need"; **DIP** "Depend in the direction of abstraction. High level modules should not depend upon low level details." [Solid Relevance — Robert C. Martin, blog.cleancoder.com 2020](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html) (accessed 2026-04-24).

**Attribution note [VERIFIED]:** neither cleancoder post attributes SOLID to the *Clean Code* book. Martin's own acronym and treatment of SOLID pre-date *Clean Code* and are more commonly associated with his later *Clean Architecture* book (2017) and earlier *Agile Software Development: Principles, Patterns, and Practices* (2002). Claims elsewhere in this research that attribute SOLID to *Clean Code* should be corrected.

The *Clean Code* book itself (Prentice Hall, 2008) was **not fetched** as a primary source in this session. Claims such as function-length rules and the "comments as failure" stance from that book remain [UNVERIFIED] here, pending a publisher excerpt or author-owned URL.

### Critique — Dan Abramov, "Goodbye, Clean Code" (2020)

Dan Abramov's "Goodbye, Clean Code" (overreacted.io) provides a named critique of the clean-code mindset (though it does not cite Martin's book directly). Key points [VERIFIED]:

- "Clean code is not a goal. It's an attempt to make some sense out of the immense complexity of systems."
- Removing duplication via abstraction can harm maintainability when requirements change — "not a good trade."
- Rewriting teammates' code without discussion "is a huge blow to your ability to effectively collaborate on a codebase together."
- Identifies an identity-attachment trap: tying professional identity to metrics like duplication can lead to zealotry.
- Closing message: "Let clean code guide you. Then let it go."

[Goodbye, Clean Code — Dan Abramov, overreacted.io 2020](https://overreacted.io/goodbye-clean-code/) (accessed 2026-04-24). The critique does not reference Robert C. Martin's book directly; it targets the general mindset of pursuing cleanliness as an abstract virtue.

### Fowler on code as documentation

A partial, verifiable position on the "clean code" theme is Fowler's *CodeAsDocumentation* [VERIFIED]. Fowler argues code should be the primary documentation of a system, but notes:

- Code is "the only one that is sufficiently detailed and precise to act in that role" — but this "doesn't mean code is the *only* documentation needed."
- "Most code bases aren't very good documentation," but this reflects effort, not inherent limits.
- Clarity requires peer review and team-level standards.

The fetched article does not discuss code comments specifically. [CodeAsDocumentation — Fowler](https://martinfowler.com/bliki/CodeAsDocumentation.html) (accessed 2026-04-24).

## 5. Static analysis and linting

### SonarQube

SonarQube is documented by SonarSource as "an industry-leading platform for automated code quality and security analysis" [VERIFIED]. It operates as a verification layer with three deployment options: SonarQube Cloud (SaaS), SonarQube Server (self-managed), and SonarQube for IDE (free IDE extension). The platform claims support for 40+ programming languages and is used by "over 7 million developers." [SonarQube — SonarSource](https://www.sonarsource.com/products/sonarqube/) (accessed 2026-04-24).

Features listed on the product page: quality metrics (maintainability/reliability/technical debt), security analysis, SAST across 40+ languages, taint analysis for injection vulnerabilities, secrets detection, IaC scanning (Terraform/CloudFormation/Kubernetes), SCA for open-source-dependency vulnerabilities, and AI CodeFix for automated remediation. These are vendor claims from the vendor page, so: [VERIFIED that SonarSource markets these capabilities]; independent validation of effectiveness is outside this session's fetches.

### DORA on test automation and code maintainability

DORA's capabilities catalog includes "test automation" and "code maintainability" as core capabilities [VERIFIED]. The code-maintainability capability describes three indicators [VERIFIED]:

1. "It's easy for the team to find examples in the codebase, reuse other people's code, and change code maintained by other teams if necessary."
2. Dependency management: adding and migrating dependencies is easy; dependencies rarely break.
3. Organization-wide coordination on searchability and changeability.

[DORA — Code Maintainability capability](https://dora.dev/capabilities/code-maintainability/) (accessed 2026-04-24).

DORA does **not**, in the pages fetched here, publish a specific effect-size claim for "adopting static analysis tool X yields Y% change in delivery performance." Any such number would require a specific cited source.

## 6. Style guides

### Google

Google publishes style guides at [google.github.io/styleguide/](https://google.github.io/styleguide/) [VERIFIED]. Languages and formats listed on the fetched page: AngularJS, C++, C#, Common Lisp, Go, HTML/CSS, Java, JavaScript, JSON, Kotlin, Markdown, Objective-C, Python, R, Shell, Swift, TypeScript, Vim script, Dart, XML. Licensed under CC-By 3.0. External contributions are not accepted because the guides mirror Google's internal standards. Stated purpose: "It is much easier to understand a large codebase when all the code in it is in a consistent style." [Google Style Guides](https://google.github.io/styleguide/) (accessed 2026-04-24).

### Airbnb JavaScript style guide

Airbnb's guide at github.com/airbnb/javascript describes itself as "*A mostly reasonable approach to JavaScript*" [VERIFIED]. Topics covered per the repository landing: variable declarations, object/array manipulation, destructuring, strings and functions, arrow functions, classes, module systems, iterators, control flow, commenting, naming, type casting, performance, testing. The repository had "over 148,000 stars and 26,700 forks" at fetch time. The guide assumes Babel transpilation. [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) (accessed 2026-04-24).

### PEP 8 (Python)

PEP 8 is Python's official style guide for code "in the standard library in the main Python distribution" [VERIFIED]. Authors listed: Guido van Rossum, Barry Warsaw, Alyssa Coghlan. Created 5 July 2001 with updates posted 1 August 2013; latest modification listed on the fetched page as 4 April 2025. [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/) (accessed 2026-04-24).

Coverage: code layout (indentation, line length, imports), string quote conventions, whitespace, comments and docstrings, naming conventions, programming recommendations.

## Sources

- [TestDrivenDevelopment — Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html) (accessed 2026-04-24)
- [Test-Driven Development — Agile Alliance Glossary](https://www.agilealliance.org/glossary/tdd/) (accessed 2026-04-24)
- [Canon TDD — Kent Beck, Tidy First? Substack](https://tidyfirst.substack.com/p/canon-tdd) (accessed 2026-04-24)
- [Notes on "Test-Driven Development by Example" by Kent Beck — Stanislaw Pankevich, 2016](https://stanislaw.github.io/2016-01-25-notes-on-test-driven-development-by-example-by-kent-beck.html) (accessed 2026-04-24)
- [Introducing BDD — Dan North, 2006](https://dannorth.net/blog/introducing-bdd/) (accessed 2026-04-24)
- [History of BDD — Cucumber](https://cucumber.io/docs/bdd/history/) (accessed 2026-04-24)
- [Gherkin Reference — Cucumber](https://cucumber.io/docs/gherkin/reference/) (accessed 2026-04-24)
- [Refactoring — Martin Fowler](https://refactoring.com/) (accessed 2026-04-24)
- [Workflows of Refactoring — Fowler](https://martinfowler.com/articles/workflowsOfRefactoring/) (accessed 2026-04-24)
- [Preparatory Refactoring Example — Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html) (accessed 2026-04-24)
- [The Clean Architecture — Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) (accessed 2026-04-24)
- [The Single Responsibility Principle — Robert C. Martin, blog.cleancoder.com 2014](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) (accessed 2026-04-24)
- [Solid Relevance — Robert C. Martin, blog.cleancoder.com 2020](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html) (accessed 2026-04-24)
- [Goodbye, Clean Code — Dan Abramov, overreacted.io 2020](https://overreacted.io/goodbye-clean-code/) (accessed 2026-04-24)
- [CodeAsDocumentation — Fowler](https://martinfowler.com/bliki/CodeAsDocumentation.html) (accessed 2026-04-24)
- [SonarQube — SonarSource](https://www.sonarsource.com/products/sonarqube/) (accessed 2026-04-24)
- [DORA — Code Maintainability capability](https://dora.dev/capabilities/code-maintainability/) (accessed 2026-04-24)
- [Google Style Guides](https://google.github.io/styleguide/) (accessed 2026-04-24)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript) (accessed 2026-04-24)
- [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/) (accessed 2026-04-24)

## Open questions

- *Clean Code* book itself (Martin, 2008) was still not fetched directly. SOLID and SRP are now [VERIFIED] from Martin's own cleancoder.com blog posts (2014, 2020), which attribute them to Martin's broader principles work rather than to *Clean Code* specifically. Function-length rules and the "comments are failure" stance from the book body remain [UNVERIFIED].
- Beck's *TDD By Example* (2003) is still not fetched directly, but the Red-Green-Refactor cycle, "Fake It (till you make it)", "Obvious Implementation," and "Triangulation" are now [VERIFIED] via two independent summaries that quote the book verbatim, and Beck's own 2023 Substack corroborates the design-as-practice framing and the canonical cycle.
- Named critique of Clean Code (Dan Abramov's "Goodbye, Clean Code") is now [VERIFIED] and cited, though Abramov's post does not reference Martin's book by name.
- Primary Cucumber docs for Gherkin were reached, but the exact first-release date of Cucumber itself was not pinned down in this session.
- Independent quantitative evidence for static-analysis impact on defect rates (beyond vendor claims) was not fetched.
