---
name: engineering policy
description: Binding engineering practice policy — Trunk-Based Development, Continuous Integration, Continuous Delivery, TDD, test pyramid, SOLID, Clean Architecture, code review, Conventional Commits, refactoring, DORA. Hard rule by default; deviations require an ADR.
type: policy
---

# Engineering Policy — Development Practices (Phase 1)

**Audience:** All engineers who ship code on the platform (product engineering + platform engineering).
**Status:** Binding. Every clause is a hard rule unless explicitly marked "Default." Deviations require a recorded ADR per §12.
**Scope:** software engineering practices — branching, integration, delivery, testing, design, architecture, code review, commits, refactoring, measurement. Platform delivery machinery (GitLab repo configuration, Terraform workflow, container tagging, deploy gates, auto-merge rules) is **out of scope** for Phase 1 and will be published as a Phase 2 companion document (see `NOTES.md`).
**Last updated:** 2026-04-24.

---

## 0. How this document works

1. Every clause is either a **Hard rule** (default) or a **Default** (strong default, deviate with recorded reasoning). Hard rules are CI-enforced or review-enforced wherever mechanically possible.
2. Every clause links back to the **primary source** that justifies it. If you disagree with a clause, read the source and bring the disagreement to an ADR.
3. **Deviation path:** open an ADR in the affected repository (format per `research/03-design/adrs.md`) stating (a) which clause is being overridden, (b) why, (c) the scope (single repo / single service / time-boxed), and (d) the expiry or review date. Platform team approves or rejects.
4. **Methodology.** Every source cited here was fetched and read during this project's verification passes on 2026-04-24 and is recorded in `research/04-development/` and `research/06-release/`. The Conventional Commits v1.0.0 spec was re-fetched during the drafting of this policy. Every claim is marked `[VERIFIED]` (direct quote/fact from the fetched source) or `[SYNTHESIS]` (inference combining verified sources — reasoning shown).

---

## 1. Branching — Trunk-Based Development

**Hard rule 1.1.** The default and production branch is `main` (one trunk). No long-lived `develop`, no `release/*`, no version branches, no environment branches.
`[VERIFIED]` Paul Hammant's canonical definition: developers collaborate "primarily on a single branch ('trunk', 'main', or 'master')" with short-lived branches for code review only ([Trunk-Based Development — Paul Hammant](https://trunkbaseddevelopment.com/) accessed 2026-04-24).

**Hard rule 1.2.** Feature branches are short-lived. **Maximum lifetime: 2 working days** from branch creation to merge.
`[VERIFIED]` trunkbaseddevelopment.com: "the branch should only last a couple of days" ([Short-Lived Feature Branches](https://trunkbaseddevelopment.com/short-lived-feature-branches/) accessed 2026-04-24).

**Hard rule 1.3.** No more than **three active branches** per repository at any one time (feature branches that have not yet merged to trunk).
`[VERIFIED]` DORA's Trunk-Based Development capability page — high performers "have three or fewer active branches in the application's code repository" ([DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) accessed 2026-04-24).

**Hard rule 1.4.** Every engineer merges to trunk **at least once per working day**.
`[VERIFIED]` DORA's TBD capability: high performers "merge branches to trunk at least once a day" (same source, accessed 2026-04-24). Reinforced by Fowler: CI requires each engineer to "merge their changes into a codebase together with their colleagues' changes at least daily" ([Continuous Integration — Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) accessed 2026-04-24).

**Hard rule 1.5.** Incomplete work is hidden behind **feature flags** or **branch-by-abstraction**, not behind long-lived branches. If work cannot be shipped behind a flag, split it smaller.
`[VERIFIED]` Fowler lists "hide work-in-progress" (e.g., behind flags) as one of the eleven CI practices (same source).

**Hard rule 1.6.** No code freezes, no integration phases.
`[VERIFIED]` DORA TBD capability: high performers "don't have code freezes and don't have integration phases" ([DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) accessed 2026-04-24).

**Default 1.7.** For teams of 15 or fewer active committers on a repo, committing directly to trunk (with post-commit review where regulation permits) is acceptable. At 16+, short-lived feature branches are the default.
`[VERIFIED]` trunkbaseddevelopment.com: "up to about 15 developers, committing directly to trunk … is going to be more efficient," with short-lived branches becoming advantageous at 16+ ([Short-Lived Feature Branches](https://trunkbaseddevelopment.com/short-lived-feature-branches/) accessed 2026-04-24).

---

## 2. Continuous Integration (the practice, not the server)

**Hard rule 2.1.** Continuous Integration means **every engineer merges to mainline at least once a working day**. Jobs that run on a merge request but have not yet merged are **not** CI — they are pre-integration checks.
`[VERIFIED]` Fowler: "Continuous Integration is a software development practice where each member of a team merges their changes into a codebase together with their colleagues' changes at least daily" ([Continuous Integration — Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) accessed 2026-04-24).

**Hard rule 2.2.** Each of Fowler's eleven practices applies in full. These are not aspirational:
`[VERIFIED]` ([same source](https://martinfowler.com/articles/continuousIntegration.html) accessed 2026-04-24):

1. Put everything in a version-controlled mainline.
2. Automate the build.
3. Make the build self-testing.
4. Every team member pushes commits to mainline every day.
5. Automated builds run on every mainline push.
6. A broken build is fixed **immediately** — it is the team's top priority.
7. Keep the build fast. Target **≤ 10 minutes** to the main feedback signal.
8. Hide work-in-progress (see §1.5).
9. Tests run in a production-equivalent environment.
10. System state (build, deploy, test health) is visible.
11. Deployment is automated.

**Hard rule 2.3.** A broken mainline build is a **stop-the-line** event. New work merges pause until mainline is green. No exceptions — "we'll fix it later" is how CI rots.
`[VERIFIED]` Fowler, practice 6 (same source).

**Default 2.4.** Build-to-feedback target is **10 minutes** on the post-merge pipeline. Slower pipelines are tolerated only while the team invests in making them faster.
`[VERIFIED]` Fowler lists "keep builds fast" and explicitly references the ten-minute target (same source).

---

## 3. Continuous Delivery

**Hard rule 3.1.** Mainline is **always in a releasable state**. Every merge leaves the system deployable to production without further coding work.
`[VERIFIED]` Jez Humble's canonical definition: Continuous Delivery is "the ability to get changes of all types — including new features, configuration changes, bug fixes and experiments — into production, or into the hands of users, safely and quickly in a sustainable way," aiming to make deployments "predictable, routine affairs that can be performed on demand" ([Continuous Delivery — continuousdelivery.com](https://continuousdelivery.com/) accessed 2026-04-24).

**Hard rule 3.2.** "Always releasable" is the test. If the trunk cannot be deployed right now with a button press, Continuous Delivery is not in effect — regardless of what the pipeline looks like.
`[SYNTHESIS]` Directly follows from the continuousdelivery.com "on demand" framing above. Reinforced by `research/06-release/cicd.md` §2.

**Default 3.3.** Continuous **Deployment** (every passing trunk commit automatically deploys to production) is an optional extension on top of Continuous Delivery. Adopt only when canary strategy, feature flags, and observability are strong enough that the loss of the human gate does not raise the change failure rate (§11).
`[VERIFIED]` Distinction documented in `research/06-release/cicd.md` §2, citing continuousdelivery.com (on-demand, gated) and [Continuous deployment — Wikipedia](https://en.wikipedia.org/wiki/Continuous_deployment) (accessed 2026-04-24) ("a more complete form of automation than continuous delivery").

---

## 4. Test-Driven Development

**Hard rule 4.1.** New functionality is developed using TDD. The canonical cycle — **Red, Green, Refactor** — is the default workflow.
`[VERIFIED]` Fowler summarises TDD as "Write a test for the next bit of functionality you want to add. Write the functional code until the test passes. Refactor both new and old code to make it well structured," often summarised as "Red – Green – Refactor" ([TestDrivenDevelopment — Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html) accessed 2026-04-24).

**Hard rule 4.2.** Canon TDD — Kent Beck's five-step cycle — is the authoritative reference when Fowler's summary is ambiguous:
`[VERIFIED]` ([Canon TDD — Kent Beck, Tidy First? Substack](https://tidyfirst.substack.com/p/canon-tdd) accessed 2026-04-24):

1. Write a list of the test scenarios you want to cover.
2. Turn exactly one item on the list into an actual, concrete, runnable test.
3. Change the code to make the test (and all previous tests) pass.
4. Optionally refactor to improve the implementation design.
5. Until the list is empty, go back to step 2.

**Hard rule 4.3.** **Never skip the refactor step.** Fowler identifies skipping the refactor as "the most common way … to screw up TDD," producing tested-but-messy code ([TestDrivenDevelopment — Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html) accessed 2026-04-24).

**Default 4.4.** TDD is not required for exploratory spikes that are thrown away, nor for pure throw-away prototypes. Any spike whose code survives into trunk is backfilled with tests before merge.
`[SYNTHESIS]` This narrows the rule to where TDD's discipline pays off; the source (Fowler/Beck) is silent on spikes. Marked as a synthesis so readers can audit.

---

## 5. Test distribution — the Test Pyramid

**Hard rule 5.1.** Tests are distributed according to the pyramid: **many unit tests, fewer integration tests, far fewer end-to-end tests.**
`[VERIFIED]` Fowler: "you should have many more low-level UnitTests than high level BroadStackTests running through a GUI" ([TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) accessed 2026-04-24).

**Hard rule 5.2.** When a failure is first caught by a higher-level test, a **lower-level test reproducing the same failure is written before the fix merges**.
`[VERIFIED]` Fowler: "before fixing a bug exposed by a high level test, you should replicate the bug with a unit test" (same source). Vocke operational rule: "If a higher-level test spots an error and there's no lower-level test failing, you need to write a lower-level test" ([The Practical Test Pyramid — Ham Vocke](https://martinfowler.com/articles/practical-test-pyramid.html) accessed 2026-04-24).

**Hard rule 5.3.** Tests follow **Arrange–Act–Assert** (or Given–When–Then) structure.
`[VERIFIED]` Vocke (same source).

**Hard rule 5.4.** Test code is held to the same quality standard as production code — reviewed, refactored, and kept maintainable.
`[VERIFIED]` Vocke: "Treat test code with the same rigor as production code" (same source).

**Default 5.5.** End-to-end tests are limited to **critical user journeys**. Any E2E test introduced is justified by the journey it protects.
`[VERIFIED]` Vocke warns E2E tests are "notoriously flaky" and recommends minimising them to critical user journeys (same source).

---

## 6. Design principles — SOLID

**Hard rule 6.1.** New code follows the five SOLID principles, stated verbatim from Robert C. Martin's 2020 restatement:
`[VERIFIED]` ([Solid Relevance — Robert C. Martin, blog.cleancoder.com 2020](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html) accessed 2026-04-24):

- **SRP — Single Responsibility Principle.** "Each software module should have one and only one reason to change." Equivalent formulation: "Gather together the things that change for the same reasons. Separate those things that change for different reasons." ([The Single Responsibility Principle — Martin, 2014](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) accessed 2026-04-24.)
- **OCP — Open/Closed Principle.** "A Module should be open for extension but closed for modification."
- **LSP — Liskov Substitution Principle.** "A program that uses an interface must not be confused by an implementation of that interface."
- **ISP — Interface Segregation Principle.** "Keep interfaces small so that users don't end up depending on things they don't need."
- **DIP — Dependency Inversion Principle.** "Depend in the direction of abstraction. High level modules should not depend upon low level details."

**Default 6.2.** SOLID violations in existing ("legacy") code are not bugs. New work touching legacy code applies the principles to the new edges; sweeping legacy rewrites to satisfy SOLID require an ADR and a business reason.
`[SYNTHESIS]` SOLID is a design discipline, not a retroactive quality gate. Marked as synthesis — the cited Martin posts do not prescribe a legacy-cleanup cadence.

---

## 7. Architecture — the Dependency Rule

**Hard rule 7.1.** Architectural dependencies flow inward. **Source-code dependencies can only point inwards** toward higher-level policy; inner layers know nothing about outer layers.
`[VERIFIED]` Robert C. Martin's Clean Architecture: the Dependency Rule is that "source code dependencies can only point inwards," and inner circles contain higher-level policy ([The Clean Architecture — Robert C. Martin, 2012](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) accessed 2026-04-24).

**Hard rule 7.2.** Business rules (Entities, Use Cases) do **not depend on** frameworks, databases, UI, or any external agency. Frameworks are plugins; they are chosen to serve the business rules, not the other way round.
`[VERIFIED]` Clean Architecture names four concentric layers — Entities, Use Cases, Interface Adapters, Frameworks & Drivers — with independence from frameworks, UI, database, and external agency as explicit design goals (same source).

**Default 7.3.** Where stricter variants apply (Hexagonal / Ports-and-Adapters, Onion), they are compatible with 7.1 and 7.2 and may be adopted by a service without an ADR. Replacing the Dependency Rule with an inward-outward mixed model requires an ADR.
`[SYNTHESIS]` Inference from the cited Clean Architecture post, which lists Hexagonal/Onion/DCI/BCE as variants sharing the same goal. Marked as synthesis.

---

## 8. Code Review

### 8.1 What reviews are for

**Hard rule 8.1.1.** The reviewer's job is to approve a change once it **improves the overall health of the codebase**, even if it is not perfect.
`[VERIFIED]` Google Engineering Practices: "Reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn't perfect" ([Code Review Standard — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/standard.html) accessed 2026-04-24).

**Hard rule 8.1.2.** The review covers eight dimensions: **design, functionality, complexity, testing, naming, comments, style, documentation**.
`[VERIFIED]` ([Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) accessed 2026-04-24).

**Hard rule 8.1.3.** Automated checks (lint, static analysis, security scan, formatter, CI test suite) are **required to pass before human review**. Human review time is spent on the eight dimensions above, not on enforcing things a machine can enforce.
`[SYNTHESIS]` Follows from §8.1.1 plus the Fowler CI practice that builds are self-testing ([Continuous Integration — Fowler](https://martinfowler.com/articles/continuousIntegration.html) accessed 2026-04-24). The separation is also consistent with Bacchelli & Bird's finding that modern code review in practice delivers more value as knowledge-transfer and understanding than as defect-finding, meaning human time is best invested where machines cannot help ([Expectations, Outcomes, and Challenges of Modern Code Review — Bacchelli & Bird, ICSE 2013](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/) accessed 2026-04-24).

### 8.2 Size

**Hard rule 8.2.1.** A change is a **single self-contained thing**. One CL does one thing.
`[VERIFIED]` Google: a small CL is "one self-contained change" addressing just one thing ([Small CLs — Google Engineering Practices](https://google.github.io/eng-practices/review/developer/small-cls.html) accessed 2026-04-24).

**Hard rule 8.2.2.** Target size is **≈100 lines changed**. A CL of **≈1000+ lines is oversized** and reviewers may reject it on size alone.
`[VERIFIED]` Google: "~100 lines is typically reasonable; ~1000 lines is usually too large … Reviewers can reject a CL solely for being oversized" (same source).

### 8.3 Speed

**Hard rule 8.3.1.** A reviewer responds within **one business day** of the review being requested. "Respond" means either review or hand off with a clear ETA — silence is not acceptable.
`[VERIFIED]` Google: the maximum acceptable response time is "one business day," ideally by the next morning; reviewers in focused work wait for a natural break rather than context-switching immediately ([Speed of Code Reviews — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/speed.html) accessed 2026-04-24).

### 8.4 Comment discipline

**Hard rule 8.4.1.** Comments label severity: `Nit:` (optional polish, non-blocking), `Optional:` / `FYI:` (informational), otherwise blocking. Minor stylistic concerns are `Nit:` and do not block approval.
`[VERIFIED]` Google on comment tone and severity labels ([How to Write Code Review Comments — Google](https://google.github.io/eng-practices/review/reviewer/comments.html) accessed 2026-04-24) and [Code Review Standard](https://google.github.io/eng-practices/review/reviewer/standard.html) on non-blocking nits.

**Hard rule 8.4.2.** When multiple valid approaches exist and the author has justified their choice, the reviewer defers to the author. Review comments address the code, not the author, and explain reasoning.
`[VERIFIED]` Google Code Review Standard (same source) and [How to Write Code Review Comments](https://google.github.io/eng-practices/review/reviewer/comments.html) (accessed 2026-04-24).

---

## 9. Commits

**Hard rule 9.1.** Commit messages follow **Conventional Commits v1.0.0**.
`[VERIFIED]` ([Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) accessed 2026-04-24).

**Hard rule 9.2.** Permitted type prefixes: `feat`, `fix`, `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`. Scope is optional and lives in parentheses: `feat(billing): add invoice export`.
`[VERIFIED]` The v1.0.0 spec mandates `feat` and `fix` and lists the additional types above as permitted ([same source](https://www.conventionalcommits.org/en/v1.0.0/)).

**Hard rule 9.3.** Breaking changes are indicated by **either** `!` immediately before the colon (`feat!:` or `feat(api)!:`) **or** a `BREAKING CHANGE: <description>` footer. If `!` is used, the footer may be omitted.
`[VERIFIED]` (same source).

**Hard rule 9.4.** Releases follow Semantic Versioning based on the commit stream: `fix` → PATCH, `feat` → MINOR, any `BREAKING CHANGE` (via footer or `!`) → MAJOR.
`[VERIFIED]` Conventional Commits v1.0.0 (same source).

**Default 9.5.** Squash-on-merge is the default merge strategy; the squashed commit message follows Conventional Commits and carries through to the release tooling.
`[SYNTHESIS]` Conventional Commits is silent on squash vs merge-commit strategy; this default aligns the commit stream on trunk with the spec without forcing every WIP commit to be conventional. Teams that prefer merge commits with a conventional title are permitted under ADR 9.5.

---

## 10. Refactoring

**Hard rule 10.1.** Refactoring is defined as Fowler defines it, and the definition is load-bearing:

- **Noun:** "a change made to the internal structure of software to make it easier to understand and cheaper to modify **without changing its observable behavior**."
- **Verb:** "to restructure software by applying a series of refactorings **without changing its observable behavior**."

`[VERIFIED]` ([Refactoring — Martin Fowler](https://refactoring.com/) accessed 2026-04-24). A change that alters observable behaviour is not a refactor — it is a feature change, a bug fix, or a breaking change, and must be labelled as such (§9).

**Hard rule 10.2.** **Two Hats.** At any moment you are either in **refactoring mode** (behaviour preserved, tests stay green) or **feature-addition mode**. Do not mix the two in a single commit or CL.
`[VERIFIED]` ([Preparatory Refactoring Example — Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html) accessed 2026-04-24).

**Default 10.3.** **Preparatory refactoring.** Before a feature change in unfamiliar or awkward code, first refactor to make the feature change easy — then make the easy change. Kent Beck: "make the change easy, then make the easy change."
`[VERIFIED]` (same source).

---

## 11. Measurement — DORA metrics

**Hard rule 11.1.** Software delivery is measured on the **DORA metrics**. Each service publishes the four keys at minimum:
`[VERIFIED]` ([Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) accessed 2026-04-24):

1. **Deployment Frequency** — how often we successfully release to production.
2. **Change Lead Time** — time from commit to production.
3. **Change Failure Rate** — percentage of deployments causing a failure in production.
4. **Failed Deployment Recovery Time** — time to recover from a deployment that requires immediate intervention (replaces "MTTR / Time to Restore Service").

`[VERIFIED]` The rename and the evolution to five metrics are canonical per ([DORA's software delivery metrics: the four keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) accessed 2026-04-24).

**Default 11.2.** A fifth metric — **Deployment Rework Rate** (ratio of deployments that were unplanned and performed to address a user-facing bug) — is published where the team has the instrumentation.
`[VERIFIED]` The 2024 Accelerate State of DevOps Report formalises rework rate as the fifth metric, paired with change failure rate for stability ([2024 Accelerate State of DevOps Report, pp. 10–12](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) accessed 2026-04-24).

**Default 11.3.** Teams target the 2024 **Elite** thresholds:
`[VERIFIED]` (same report, p. 13):

| Metric | Elite target |
|---|---|
| Change lead time | Less than one day |
| Deployment frequency | On demand (multiple deploys per day) |
| Change failure rate | 5% |
| Failed deployment recovery time | Less than one hour |

**Hard rule 11.4.** Velocity and stability are reported **together**. You may not improve one by trading off the other — that is precisely the anti-pattern the four-metric split was designed to expose.
`[VERIFIED]` Google Cloud: "Deployment Frequency and Lead Time for Changes measure velocity, while Change Failure Rate and Time to Restore Service measure stability" ([Use Four Keys metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) accessed 2026-04-24).

**Caveat 11.5.** DORA's performance-tier model has shifted year on year (the 2022 report detected only three clusters; 2023 restored Elite; 2024 kept it). When reporting tier membership, cite the report year. `[VERIFIED]` per the Google Cloud blog edit note and the 2023 announcement ([Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) accessed 2026-04-24).

---

## 12. Deviations — ADR policy

**Hard rule 12.1.** Any override of a clause in this document requires an **Architecture Decision Record** in the affected repository.

**Hard rule 12.2.** The ADR MUST contain:

- **Clause** being overridden (e.g., "Engineering Policy §5.5 — E2E critical-journey limit").
- **Reason** — what local context makes the clause inappropriate.
- **Scope** — one repo / one service / whole team / time-boxed duration.
- **Review date** — when the deviation is re-examined. Indefinite deviations are not permitted.
- **Approver** — the platform team sign-off.

`[VERIFIED]` ADR format per project reference ([research/03-design/adrs.md](../research/03-design/adrs.md) — in-repo).

**Hard rule 12.3.** An ADR that overrides a clause here does **not** override a cited primary source; it explicitly records a local exception to the industry practice and accepts the consequences.

---

## Sources

- [Trunk-Based Development — Paul Hammant](https://trunkbaseddevelopment.com/) (accessed 2026-04-24)
- [Short-Lived Feature Branches — trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/short-lived-feature-branches/) (accessed 2026-04-24)
- [DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) (accessed 2026-04-24)
- [Continuous Integration — Martin Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [Continuous Delivery — continuousdelivery.com (Jez Humble)](https://continuousdelivery.com/) (accessed 2026-04-24)
- [Continuous deployment — Wikipedia](https://en.wikipedia.org/wiki/Continuous_deployment) (accessed 2026-04-24)
- [TestDrivenDevelopment — Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html) (accessed 2026-04-24)
- [Canon TDD — Kent Beck, Tidy First? Substack](https://tidyfirst.substack.com/p/canon-tdd) (accessed 2026-04-24)
- [TestPyramid — Martin Fowler](https://martinfowler.com/bliki/TestPyramid.html) (accessed 2026-04-24)
- [The Practical Test Pyramid — Ham Vocke, martinfowler.com](https://martinfowler.com/articles/practical-test-pyramid.html) (accessed 2026-04-24)
- [Solid Relevance — Robert C. Martin, blog.cleancoder.com 2020](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html) (accessed 2026-04-24)
- [The Single Responsibility Principle — Robert C. Martin, blog.cleancoder.com 2014](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) (accessed 2026-04-24)
- [The Clean Architecture — Robert C. Martin, 2012](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) (accessed 2026-04-24)
- [Code Review Standard — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/standard.html) (accessed 2026-04-24)
- [Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) (accessed 2026-04-24)
- [Small CLs — Google Engineering Practices](https://google.github.io/eng-practices/review/developer/small-cls.html) (accessed 2026-04-24)
- [Speed of Code Reviews — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/speed.html) (accessed 2026-04-24)
- [How to Write Code Review Comments — Google](https://google.github.io/eng-practices/review/reviewer/comments.html) (accessed 2026-04-24)
- [Expectations, Outcomes, and Challenges of Modern Code Review — Bacchelli & Bird, ICSE 2013 (Microsoft Research)](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/) (accessed 2026-04-24; abstract)
- [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) (accessed 2026-04-24)
- [Refactoring — Martin Fowler](https://refactoring.com/) (accessed 2026-04-24)
- [Preparatory Refactoring Example — Fowler](https://martinfowler.com/articles/preparatory-refactoring-example.html) (accessed 2026-04-24)
- [Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)
- [DORA's software delivery metrics: the four keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)
- [Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)
- [2024 Accelerate State of DevOps Report (PDF)](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)

## Open questions

- **DORA "three active branches" currency.** The figure is attributed by dora.dev to 2016–2017 analysis. The 2024 report was not re-checked for a refreshed number in this pass; §1.3 uses the dora.dev capability-page figure as the binding limit. If the 2024/2025 reports publish a different threshold, §1.3 should be updated.
- **GitLab-specific enforcement.** This document states policy; enforcement via GitLab Push Rules, Merge Request approvals, Protected Branches, and merge-train configuration is deferred to the Phase 2 operational policy document (see `NOTES.md`).
- **Auto-merge rules.** The conditions under which MRs may auto-merge without human review (e.g., bot-authored dependency bumps that pass all checks) are Phase 2.
- **Terraform validation depth.** Static checks that catch JSON IAM policy errors, 32-char AWS resource names, and broken cross-resource references are platform-infrastructure policy and belong in Phase 2. The 32-char ALB/Target Group limit is already a hard rule in `platform-team/developer-guidelines.md` §2.
- **Container image tagging & promotion.** Binary-identical artifact promotion across `dev → preprod → prod` without rebuild is Phase 2.
- **Deploy gating (auto-deploy to dev, manual to preprod/prod).** Phase 2.
- **Clean Code book (Martin, 2008) and Accelerate book (Forsgren, Humble, Kim, 2018).** Neither book was fetched directly in prior passes; claims associated with them in this policy are sourced from Martin's cleancoder.com posts and from the Google Cloud / dora.dev pages rather than the books themselves.
