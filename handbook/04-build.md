# Phase 04 — Build

**Goal:** Write code that works today and is still easy to change six months from now.
**Duration:** Continuous.
**You are done when:** Trick question — you're never done. Define a per-increment definition of done, apply it to every change, and use it as the only gate on "merged." The DoD checklist is at the end of this chapter.

---

## What this phase is about

Phase 04 is the phase teams spend most of their professional lives inside. Once the problem is sharp (Phase 01), the strategy is set (Phase 02), and the architecture has a shape (Phase 03), the daily reality of a software product is a loop of small changes to a shared codebase. This chapter is about how that loop works.

"Good code" in a product context does not mean elegant code, clever code, or code that wins style arguments. It means code that compounds. The codebase you have in twelve months is the sum of every small decision made in every pull request between now and then. A codebase that resists change — because branches are long, reviews are slow, tests are missing, or style is negotiable — will grind every future initiative down to a halt. A codebase that welcomes change — small PRs, fast reviews, automated tests, machine-formatted style — is how teams ship features next year without rewriting what they shipped this year.

This is not a minor branch of craftsmanship. The speed at which you can safely change the system is the speed at which your product can learn. DORA's research finds that high-performing teams ship more frequently *and* have lower change failure rates — both at once, not at a trade-off. The practices in this chapter are how that dual outcome is achieved.

This phase does not cover testing strategy (Phase 05), CI/CD pipelines and deploys (Phase 06), or production operations (Phase 07). Everything here is about the act of writing and merging code.

---

## Who does what

- **Engineers** — own the daily loop: branch, code, test, PR, review, merge. Everyone who writes code reviews code.
- **Tech lead / senior engineer** — owns codebase standards, the review culture, and the CODEOWNERS map once it exists. Unblocks stalled reviews.
- **Engineering manager** — owns throughput and health metrics (PR cycle time, review latency, CI duration). Intervenes when the loop is jammed, not when individuals are slow.
- **Platform / DevEx engineer (if you have one)** — owns the dev environment, the linter config, the pre-commit hooks, the CI pipeline templates, the "one-command setup." At small scale this is shared; at scale it becomes a team.
- **Product / design** — consumers and reviewers of the output, not gatekeepers of the process. They review PRs that affect UX, read changelog entries, and file issues like anyone else.

---

## Inputs

From Phase 03 you carry forward:

- System architecture and major component boundaries.
- ADRs for decisions that are expensive to reverse.
- API contracts (OpenAPI or equivalent).
- Data model and storage decisions.
- UX flows and the accepted-for-build set of designs.

From Phase 02 you carry forward the prioritized backlog and the success metrics the work is serving. If an engineer does not know which OKR or KPI their current PR is connected to, Phase 02 failed or Phase 04 is about to waste effort.

---

## The daily loop

Every change follows the same rhythm. It is boring on purpose — boring is what lets the team do it fifty times a week without friction.

1. **Pick a task** from the prioritized backlog. If it does not fit in a day or two, split it first.
2. **Branch from `main`** with a descriptive name (`fix-stripe-idempotency`, `add-webhook-retries`).
3. **Write tests and code together.** For non-trivial logic, write the test first. For UI polish and spikes, write whichever is faster.
4. **Run locally.** Tests, linter, type checker, pre-commit hooks. If unit tests take over 60 seconds, fix that before anything else.
5. **Open a pull request.** Small, scoped, with a description that explains *why* and a short test plan. Self-review before asking anyone else to.
6. **Get review within one business day.** The reviewer's job is to respond — question, request, or approve — not necessarily finish in one sitting.
7. **Merge to `main`** once tests are green and at least one peer has approved. Pick squash or rebase and keep history linear.
8. **Deploy via the automated pipeline** (Phase 06). Merging to `main` triggers a deploy with no manual step in between.

The rest of this chapter is about making that loop boring.

---

## Version control: how you work with Git

Git is the substrate. Chacon & Straub's *Pro Git* (2nd ed., 2014) at [git-scm.com/book/en/v2](https://git-scm.com/book/en/v2) is the canonical reference for mechanics. Everyone should know Git well enough to not be afraid of it. The prescriptive part is the *workflow* on top of Git.

### Branching strategy

**Use trunk-based development.** One long-lived branch — call it `main` — and very short-lived branches (under 1 day; 2 days absolute ceiling) for the work leading to each merge. Everyone integrates to `main` at least daily.

Justification comes from DORA, the DevOps Research and Assessment group now at Google Cloud. DORA's trunk-based-development capability page, based on their 2016-2017 analysis, finds that teams with superior software delivery performance:

- Have three or fewer active branches in the application's code repository.
- Merge branches to trunk at least once a day.
- Do not have code freezes and do not have integration phases.

This is not a style preference. It correlates with the four outcome metrics DORA measures — deployment frequency, lead time for changes, change failure rate, and mean time to recovery. Heavyweight branching strategies consistently produce worse numbers on all four.

**When GitHub Flow is acceptable.** GitHub Flow — default branch plus per-change feature branches, merged via PR — is a legitimate starting point. It is essentially TBD with slightly longer-lived branches (2-3 days) and the PR as the integration gate. If you are 2-8 engineers and not yet ready for sub-daily merges, GitHub Flow is fine — just do not let branches drift past a few days.

**Why GitFlow is wrong for modern SaaS.** Vincent Driessen's "A successful Git branching model" (2010) — known as GitFlow — prescribes long-lived `master` and `develop` branches, release branches, and hotfix branches. It was designed for explicitly versioned software maintaining multiple concurrent releases in production (e.g. a desktop app with a 2.3.x line still in support alongside 3.0).

Driessen himself added a caveat atop his original post on 5 March 2020, verbatim from [nvie.com](https://nvie.com/posts/a-successful-git-branching-model/):

> "If your team is doing continuous delivery of software, I would suggest to adopt a much simpler workflow (like GitHub flow) instead of trying to shoehorn git-flow into your team."

Take him at his word. Modern SaaS products deploy continuously and do not maintain multiple versions in production. GitFlow adds ceremony without solving a problem your team has. Do not use it.

**Long-lived feature branches are the single biggest anti-pattern here.** Martin Fowler's "Feature Branch" bliki notes they "prevent early detection of problems" and "discourage refactoring." A branch that lives two weeks will have merge conflicts, missed refactors, and latent integration bugs. If a feature is too big for a day or two, split it and hide incomplete state behind a feature flag (Phase 06 covers flags). Ship the plumbing before you ship the product.

### Commits

Commits are how future-you reads the history. Treat them as communication.

- **Small and frequent.** A commit represents one coherent change. If the message has "and" or a bulleted list, split it.
- **Conventional Commits recommended.** Prefixes like `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:` make history scannable and enable automated changelogs. Not mandatory — but if you do not adopt a convention, the team will invent a worse one informally.
- **Subject line + body.** The subject explains *what*; the body explains *why*. A good commit message is a letter to whoever runs `git blame` a year from now on a weird line and asks, "why did we do this?"

### Pull requests

PRs are the unit of review, merge, and deploy. Keep them small.

Google's CL Author's guide at [google.github.io/eng-practices/review/developer/small-cls.html](https://google.github.io/eng-practices/review/developer/small-cls.html) sets concrete targets: a small CL is "one self-contained change"; ~100 lines is typically reasonable; ~1000 lines is usually too large; reviewers can reject a CL solely for being oversized. Benefits: faster reviews, more thorough review, reduced bug risk, easier rollback. **Target under 400 lines changed per PR**; past that, ask whether it can be split before opening it.

Rules for every PR:

- **One concern per PR.** "Refactor X and add feature Y" is two PRs. Labeled refactor commits inside a feature PR are fine; unrelated features are not.
- **Self-review before requesting.** Read the diff as the reviewer would. You will catch half the comments you would have gotten.
- **Description explains the why.** Linked issue, behavior change, risk, rollout plan if non-trivial.
- **Test plan in the description.** Even one line: "Unit tests cover X; manually verified Y in staging."
- **Link to the task / issue.** Traceability back to Phase 02's backlog.

PR templates that pre-fill these sections are worth ten minutes to set up.

---

## Code review

Every change is reviewed by at least one peer before it merges. No exceptions — even the CTO's one-line fixes get a review. The rule is about the system, not the people.

### Goals of review

The most common mistake is treating review as primarily a bug hunt. It catches some bugs, but that is not the main value. Bacchelli & Bird, "Expectations, Outcomes, and Challenges of Modern Code Review" (ICSE 2013), studied review at Microsoft and found a gap between expectation and outcome. From the [Microsoft Research abstract](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/): developers *expected* reviews to primarily find defects, but in practice reviews delivered benefits beyond defects — **knowledge transfer, team awareness, and the creation of alternative solutions**. "Code and change understanding" was the key aspect; the bottleneck was the reviewer's ability to build a mental model of the change.

So the real goals of review, in decreasing order of value:

1. **Spread knowledge.** Nobody should be the only person who knows a module. Every review is a mini-teaching session in both directions.
2. **Build shared understanding.** The reviewer ends with a mental model of why the change was made. That model is load-bearing when they are paged at 2 a.m.
3. **Maintain standards.** The codebase is a shared asset. The review is where team norms meet the code.
4. **Deliver alternative solutions.** The author picked one approach; sometimes a second pair of eyes sees a cleaner one.
5. **Catch bugs.** Yes, but expect most bugs to be caught by tests, types, and linters.

### How to review

Google's code review practices at [google.github.io/eng-practices/review](https://google.github.io/eng-practices/review/) are the clearest public guide; the rules below are based on them.

- **Review within 1 business day.** Google's explicit standard: respond "shortly after receiving them if not in focused work," with **one business day** the maximum. "Respond" means engage — question, request, approve — not necessarily finish. Multiple rounds in a day are normal.
- **Protect focus, but not at the cost of days.** Google allows developers in deep focus to wait for a natural break. What is not allowed is letting a PR sit overnight because nobody picked it up.
- **Small PRs get reviewed first.** Cheaper for the reviewer; unblocks the author.
- **Ask questions before demanding changes.** "Why is this a map instead of a list?" is better than "this should be a list." The author may already have considered it.
- **Use `nit:` for optional feedback.** Google's convention: `Nit:` means "non-blocking." `Optional:` and `FYI:` are similar. Blocking comments are unmarked.
- **Do not block on style.** If you have a linter, the linter decides. If you do not, add one before the next style disagreement.
- **Approve when the CL improves code health.** Google's standard, verbatim: "Reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn't perfect." The goal is progress, not perfection. Approve; file a follow-up issue for anything deferred.

### What to look for (checklist)

Google's reviewer guide enumerates eight dimensions: **design, functionality, complexity, testing, naming, comments, style, and documentation updates**. A practical checklist:

- **Does it do what the PR description says?** Start with the description and work to the diff.
- **Is the design sound?** Does it fit the architecture and ADRs from Phase 03?
- **Is the functionality correct?** Edge cases, error paths, concurrency if relevant.
- **Is the complexity justified?** Over-engineering is a cost.
- **Are tests present and meaningful?** Tests that exercise behavior, not tests that mirror implementation.
- **Is error handling at boundaries right?** Input validation, network failures, retries.
- **Security implications?** Input trust, secrets, auth paths.
- **Observability for new paths?** Logs, metrics, traces (Phase 07 depends on this).
- **Is naming clear?** If you had to ask what a thing is for, the name needs work.
- **Comments and docs updated?** Stale docs are worse than no docs.

### Giving and receiving feedback

Google's "How to Write Code Review Comments" guide: be kind, address the code not the developer, explain reasoning, label severity.

- **Be explicit about must vs. nit.** Label every comment. An author should not have to guess.
- **Explain the why, not just the what.** "Rename `x` to `userId`" is a direction; "rename `x` to `userId`; the type hint is far away and readers will scroll" is an argument.
- **Assume good intent.** The author had reasons. Ask before assuming they did not.
- **Positive feedback is allowed.** Ending with "nice catch on the retry loop" costs nothing and builds the team.

As an author: feedback is data, not attack. Disagree on technical grounds; concede quickly when you do not. If a reviewer's question reveals confusing code, rewrite the code — Google's guide is explicit that if code needs explanation in the review tool, make the code clearer instead.

### Synchronous reviews when stuck

DORA's TBD capability page flags "heavyweight review processes and asynchronous reviews" as obstacles to delivery performance. When a review is stuck — repeated rounds, unclear intent, big surface area — hop on a call for fifteen minutes. A synchronous session resolves in minutes what an async thread takes days to churn through. Async first; sync when stuck.

---

## Coding practices

### TDD (Test-Driven Development)

TDD is a design practice that produces tests as a byproduct. Martin Fowler summarizes the cycle at [martinfowler.com/bliki/TestDrivenDevelopment.html](https://martinfowler.com/bliki/TestDrivenDevelopment.html):

1. "Write a test for the next bit of functionality you want to add."
2. "Write the functional code until the test passes."
3. "Refactor both new and old code to make it well structured."

Summarized as **Red → Green → Refactor**. Fowler warns the most common way to screw it up is neglecting the third step and ending up with messy but tested code.

Kent Beck, who developed TDD in the late 1990s as part of XP and published *Test-Driven Development: By Example* in 2003, describes the same loop on his Substack at [tidyfirst.substack.com/p/canon-tdd](https://tidyfirst.substack.com/p/canon-tdd). He adds that writing tests first forces interface-first thinking: "design decisions, but they are primarily interface decisions." TDD is a design discipline.

**When to use it:**

- Core business logic where correctness matters and behavior is specifiable up front.
- Tricky algorithms — TDD forces the expected behavior down before the implementation gets tangled.
- Bug fixes. Always. Write the failing regression test first, then fix. The test protects against the regression forever.

**When to skip it:**

- Spikes and throwaway prototypes — the point is to learn, not to produce a durable artifact.
- UI tweaks where the behavior is visual and test-writing cost dwarfs the change.
- Exploratory code where the shape of the interface is unknown.

**TDD is not a religion.** Beck's own Green techniques — **Fake It**, **Obvious Implementation**, **Triangulation** — are pragmatic, not dogmatic. The goal is well-designed, well-tested code, not ritual compliance. Phase 05 covers testing strategy; this chapter stops at "use TDD as a design tool when it fits."

### Refactoring

Martin Fowler, at [refactoring.com](https://refactoring.com/), defines it:

- **Noun:** "a change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior."
- **Verb:** "to restructure software by applying a series of refactorings without changing its observable behavior."

"Without changing its observable behavior" is the operative phrase. Refactoring is not rewriting; it is structural change under test cover.

**Camp rule.** Leave the code cleaner than you found it. Notice a confusing name while adding a feature — rename it in the same PR. These in-PR refactors keep a codebase livable over years.

**Separate refactor commits from feature commits.** Within one PR: `refactor: extract retry logic` then `feat: use retry logic in webhook handler`. The reviewer checks each separately; a bad feature commit can be reverted without losing the refactor.

**Preparatory refactoring.** Fowler quoting Kent Beck: "make the change easy, then make the easy change." Before a substantial feature, clean up the code you will touch first, as a dedicated PR. The feature ships faster and the reviewer's cognitive load is halved.

**Two hats.** At any moment you are either refactoring (preserve behavior, tests green) or adding features (changing behavior, riskier). Do not wear both at once. Switch hats deliberately, commit by commit.

### Clean code, with nuance

Robert C. Martin's *Clean Code* (2008) and *Clean Architecture* (2017) popularized a cluster of principles — meaningful names, small functions, single responsibility, SOLID. Much is useful; some has been over-applied into anti-patterns.

**What is genuinely useful:**

- **Meaningful names.** Name things for what they do. Cheap and uncontroversial.
- **Small functions.** A function that fits on a screen is easier to read than one that scrolls for three. Heuristic, not rule.
- **Single responsibility.** Martin on his blog at [blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html): "Each software module should have one and only one reason to change." Connects to Parnas's 1972 work on module decomposition.
- **SOLID as a tool.** Martin's 2020 post at [blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html) restates the five principles. They are a tool for thinking about coupling and cohesion, not a mechanical checklist. Note SOLID is from Martin's 2000s principles work, *not* from *Clean Code* the book — claims attributing SOLID to *Clean Code* are misattributed.

**What gets over-applied:**

- **Excessive abstraction.** Every interface and factory has a cost: indirection. Abstractions pay back when there are real variants. They tax you when there is only one implementation.
- **Premature DRY.** Dan Abramov's "Goodbye, Clean Code" (2020) at [overreacted.io/goodbye-clean-code](https://overreacted.io/goodbye-clean-code/): removing duplication via abstraction can harm maintainability when requirements change. Two similar pieces today may need to evolve apart tomorrow. Abramov: "Let clean code guide you. Then let it go."
- **Fanatical line-count rules.** "No function over 20 lines" fragments logic across files; every read turns into a trace. Heuristic yes; absolute rule no.
- **Clean code as identity.** Abramov's other warning: tying identity to metrics like duplication leads to zealotry.

Synthesis: use the principles as heuristics. Always ask: does this change actually make the code easier to read and modify for the next person? If not, do not make it.

### Style

Do not argue about style. Automate it.

- **Use a language-standard style guide.** PEP 8 for Python ([peps.python.org/pep-0008](https://peps.python.org/pep-0008/)), gofmt for Go, Prettier for JS/TS, rustfmt for Rust. Where the language has a community standard, use it. Where a company has a well-known published style (Google at [google.github.io/styleguide](https://google.github.io/styleguide/), Airbnb's JS guide at [github.com/airbnb/javascript](https://github.com/airbnb/javascript)), adopt it rather than inventing your own.
- **Automate with a formatter** (`black`, `prettier`, `gofmt`, `rustfmt`). Run on save, in pre-commit, and in CI.
- **Automate with a linter** (`ruff`/`flake8`, `eslint`, `golangci-lint`, `clippy`). Fail CI on errors.
- **Enforce in CI.** If it is not enforced by CI it is not enforced.
- **The linter decides.** No style comments in PR reviews. If the linter is wrong on a case, discuss the rule — change it or add a per-line exemption.

Style is cheap when automated and corrosive when negotiated PR by PR.

### Static analysis

Beyond style, layer in tools that catch real problems:

- **Type checker.** `mypy`/`pyright` for Python, the TS compiler, Sorbet for Ruby. Strong types catch a class of bugs that would otherwise need tests. In typed languages this is the compiler.
- **Security-focused linter.** `bandit` (Python), `eslint-plugin-security` (JS), `gosec` (Go). Catch SQL injection patterns, weak crypto, hardcoded secrets.
- **SAST in CI.** Semgrep and CodeQL are the common open options; SonarQube bundles SAST with other signals. Run on every PR.
- **Dependency scanning.** `npm audit`, `pip-audit`, `govulncheck`, Dependabot.
- **Secrets scanning.** `gitleaks`, GitHub secret scanning, `trufflehog`. A committed secret is a leaked secret; block at commit time.

DORA lists "code maintainability" as a core capability; its signals include "it's easy for the team to find examples in the codebase, reuse other people's code, and change code maintained by other teams if necessary." Tooling is how you operationalize that at scale.

---

## Documentation

### What to document

Not everything. Documentation has a maintenance cost; undocumented code is sometimes better than stale code. But a minimum is non-negotiable:

- **README** for each repository. Getting-started in under 5 minutes to first successful run. If a new engineer cannot clone, set up, and run the app in their first hour, the README is broken.
- **ADRs** for expensive-to-reverse decisions (started in Phase 03). New ADRs as decisions arise.
- **Design docs / RFCs** for non-trivial features before they are built. A one-page RFC — what we are building, why, what we rejected, what the risk is — heads off half the "we should have thought about that" conversations.
- **Public API docs.** OpenAPI for HTTP APIs, GraphQL SDL for GraphQL. Generate from source. The [OpenAPI Specification](https://swagger.io/specification/) is the standard — use it and generate client SDKs from it.
- **Runbooks** for operational procedures (Phase 07). Every PR that introduces a new operational concern should at minimum note the procedure in the description.

### The Diátaxis framework

Daniele Procida's Diátaxis framework at [diataxis.fr](https://diataxis.fr/) is the clearest model for structuring documentation. Procida identifies four distinct user needs, each with a corresponding form, verbatim from the canonical site:

- **Tutorials** — learning-oriented. "A practical activity, in which the student learns by doing something meaningful, towards some achievable goal."
- **How-to guides** — task-oriented. "Directions that guide the reader through a problem or towards a result... helps the user get something done, correctly and safely."
- **Reference** — information-oriented. "Technical descriptions of the machinery and how to operate it... describe, as succinctly as possible, and in an orderly way."
- **Explanation** — understanding-oriented. "A discursive treatment of a subject, that permits reflection... deepens and broadens the reader's understanding."

Use the four modes to classify every doc. The framework's value is in preventing one document from trying to be all four at once — the most common source of unreadable documentation. A page is teaching a beginner, guiding an experienced user through a task, describing an interface precisely, or discussing why. Pick one per page. A `/docs` folder organized as `docs/tutorials/`, `docs/how-to/`, `docs/reference/`, `docs/explanation/` makes this concrete.

### Code comments

**Default: none.** The code is the documentation. Fowler's *CodeAsDocumentation* at [martinfowler.com/bliki/CodeAsDocumentation.html](https://martinfowler.com/bliki/CodeAsDocumentation.html) argues code is "the only one that is sufficiently detailed and precise to act in that role" — but only if developers actively work to make it readable.

**When comments are worth writing:**

- **To explain WHY, not what.** "This is a hash map" is noise. "We use a hash map because the payment gateway returns items nondeterministically and we need O(1) lookup during retries" is a gift.
- **To flag a non-obvious constraint.** `// DO NOT reorder; upstream API is positional.`
- **To link to an issue or spec.** `// See RFC-7231 §6.5.2` or `// Workaround: github.com/foo/bar/issues/1234`.
- **To mark known technical debt.** `// TODO(NAME): remove after we migrate to the new API — issue #456`. Include owner and pointer.

**Red flags:** comments restating the code in English, commented-out code, or comments that exist because the code is unreadable (rewrite the code).

### Onboarding docs

A new engineer should ship their first PR in their first week. That is the bar. Minimum:

- **README** that gets them running.
- **Dev container or setup script** (see below).
- **"Good first issue" list** — small, well-scoped, not on the critical path.
- **Architecture overview** — one page of diagram and text with pointers to deeper docs (Phase 03 produced this).

Track "time to first PR" as an honest indicator of onboarding quality. Longer than a week means the setup is broken, not the new hire.

---

## Developer experience

Developer experience is everything between an engineer having an idea and seeing it running. Slow feedback, broken environments, and flaky tests tax every engineer on every change; the tax compounds.

- **Dev containers or equivalent.** The Development Containers spec at [containers.dev](https://containers.dev/) lets a repo carry its environment as code. A contributor opens the repo and gets tools, language versions, and extensions pre-configured. The same container can be used in CI, closing the "works on my machine" loop.
- **One-command setup is a forcing function.** `make setup` or `./scripts/bootstrap` installs deps, sets up secrets from a template, starts services, runs tests once. New setup steps go in the script or they do not happen.
- **Fast feedback loops.** Unit tests under 60s. Linter under 10s. Type checker under 30s. If any get slower, fix it before adding features.
- **Type errors caught in the editor.** Editor integration for type checker, linter, formatter. The shortest feedback loop catches the error before you save the file.
- **Pre-commit hooks.** Formatter, linter, fast unit tests, secrets scan. Keep under a few seconds; heavier checks belong in CI.
- **Reproducible builds.** Pin dependency versions. Commit lockfiles. Laptop and CI build the same artifact.

These are not nice-to-haves — they are the leverage that lets a team of five move like a team of fifteen.

---

## Pair and mob programming

Pair programming (Agile Alliance at [agilealliance.org/glossary/pair-programming](https://www.agilealliance.org/glossary/pair-programming/)): two programmers at one workstation — driver at the keyboard, navigator on overall direction, swap every few minutes. Mob programming (Woody Zuill at [mobprogramming.org](https://mobprogramming.org/)) extends it to the whole team: "All the brilliant people working on the same thing, at the same time, in the same space, and on the same computer."

**When pairing pays off:** tricky problems, knowledge transfer (onboarding, cross-training), high-risk changes, incident response and debugging.

**When it doesn't:** routine work, deep focus tasks where one person benefits from holding the full mental model, or as a mandatory full-time practice (few teams sustain it).

**Mob programming** is more niche — architecture-setting, gnarly debugging, or building shared ownership of a new subsystem. Not a default mode.

Treat pairing and mobbing as tools you pick up when the task calls for it, not as identity practices.

---

## Anti-patterns

- **Long-lived feature branches.** Everything in this chapter argues against them. The cost is real and compounding.
- **Huge PRs (1000+ lines).** Reviewers skim, bugs slip through, rollbacks become painful. Split.
- **Review bottlenecks.** One person gates every PR. They become the critical path; they also burn out. Spread the load with CODEOWNERS and a review rotation.
- **Style fights in PRs.** If the linter does not decide, the linter is wrong. Fix the linter.
- **Comments that restate the code.** Delete them; they will go stale and lie.
- **"Clean code" as a cudgel.** When a reviewer uses principles to win an argument instead of to improve code, the reviewer is the problem.
- **Skipping tests "because we'll add them later."** You will not. If you would, you would have done it now.
- **Hand-maintained API docs that drift.** Generate from source. If the tool generates docs from an OpenAPI spec, the spec is the source of truth.
- **"Works on my machine" because there is no containerized dev env.** Fix the environment, not the individual bug report.
- **PRs opened with no description.** "Reviews are free" is a fantasy. A PR with no description costs the reviewer 10 minutes of archaeology.
- **Ignoring CI failures.** A failing CI that "everyone knows is flaky" becomes a failing CI nobody looks at. Fix flakes on sight.

---

## Scale notes

- **Solo (1 engineer).** Same rules, self-imposed. Self-review the diff before merging — you are reviewing for your future self. Keep PRs small; they are commits to future-you. Write ADRs. The difference between a solo project that survives and one that does not is often whether the author wrote anything down.
- **Team of 5.** Every PR reviewed by one person within a business day. CODEOWNERS unnecessary. One shared style guide, one linter config.
- **Team of 50.** CODEOWNERS maps modules to owners. Domain ownership emerges. Multiple reviewers for high-risk areas (security, payments, data migration). A platform team of one or two owns dev environment, CI templates, shared libraries.
- **Team of 500.** Dedicated platform team. Internal developer portal (Backstage or equivalent). Strong shared libraries. A code-health team for cross-service refactoring. Monorepo or well-governed polyrepo with shared tooling.

The principles do not change with scale. The ceremony around them does.

---

## Exit / done criteria (per increment)

Every PR must meet this Definition of Done before it merges. No exceptions. This is the gate that trunk-based development replaces a release-branch QA cycle with — and it only works if the gate is real.

- [ ] Tests written and passing (unit + relevant integration — Phase 05 sets strategy)
- [ ] Linter passing
- [ ] Type checker passing
- [ ] PR description explains WHY
- [ ] Reviewed by at least one peer
- [ ] Observability added for new code paths (logs / metrics / traces)
- [ ] Docs updated if behavior changed
- [ ] No new secrets in code

Copy this into the repo as `.github/PULL_REQUEST_TEMPLATE.md` (or the equivalent) so every PR shows the checklist by default.

---

## Why this works

Every prescription in this chapter is traceable to primary sources in `research/04-development/`:

- **Trunk-based development, daily merges, three-or-fewer active branches.** DORA's trunk-based-development capability page, based on 2016-2017 analysis, correlates these practices with high software delivery performance across the four key metrics. See `research/04-development/version-control.md` §6.
- **GitFlow is wrong for SaaS.** Vincent Driessen's own 2020 caveat atop his original 2010 post recommends simpler workflows like GitHub Flow for teams practicing continuous delivery. See `research/04-development/version-control.md` §2 for the verbatim quote.
- **Feature branches prevent early detection of problems and discourage refactoring.** Martin Fowler, "Feature Branch" bliki. See `research/04-development/version-control.md` §7.
- **Small PRs (~100 lines, ≤1000 lines, reviewer can reject for size).** Google's CL Author's Guide, "Small CLs" page. See `research/04-development/code-review.md` §1.
- **Review within 1 business day.** Google's "Speed of Code Reviews" page. See `research/04-development/code-review.md` §1.
- **Code review's main value is understanding and knowledge transfer, not defects.** Bacchelli & Bird, "Expectations, Outcomes, and Challenges of Modern Code Review" (ICSE 2013). See `research/04-development/code-review.md` §5.
- **Approve a CL that improves code health, even if imperfect.** Google's Code Review Standard, verbatim. See `research/04-development/code-review.md` §1.
- **Red → Green → Refactor; TDD as design practice.** Martin Fowler's TDD summary and Kent Beck's 2023 Canon TDD post. See `research/04-development/coding-practices.md` §1.
- **"Make the change easy, then make the easy change." Two hats.** Fowler quoting Beck; Fowler's Workflows of Refactoring. See `research/04-development/coding-practices.md` §3.
- **SOLID as a tool, not a checklist; attribution to Martin's earlier principles work, not *Clean Code* the book.** Martin's own 2014 and 2020 cleancoder.com posts. See `research/04-development/coding-practices.md` §4.
- **"Clean code is not a goal… Let clean code guide you. Then let it go."** Dan Abramov, "Goodbye, Clean Code" (2020). See `research/04-development/coding-practices.md` §4.
- **Style guide and enforcement via tooling.** PEP 8, Google Style Guides, Airbnb JavaScript. See `research/04-development/coding-practices.md` §6.
- **Diátaxis for documentation: tutorials, how-to, reference, explanation.** Daniele Procida, diataxis.fr. See `research/04-development/documentation.md` §1.
- **Code as primary documentation.** Martin Fowler, CodeAsDocumentation bliki. See `research/04-development/documentation.md` §2.
- **OpenAPI for API documentation.** OpenAPI Specification at swagger.io. See `research/04-development/documentation.md` §3.
- **Dev containers for reproducible dev environments.** Development Containers specification at containers.dev. See `research/04-development/documentation.md` §5.

The research documents each phase's citations fully, with verification tags and source URLs. When in doubt, follow the link.
