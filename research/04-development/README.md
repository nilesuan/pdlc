# Stage 04: Development Practices

**Question:** What development practices (version control, branching, code review, coding practices, documentation, tooling) constitute industry-grade software development, and what primary sources define them?

**Status:** Draft

**Last updated:** 2026-04-24

This directory covers the development phase of the PDLC: the day-to-day practices developers and teams use to produce, review, and evolve software after a plan and design exist (stages 02-03) and before formal testing and release (stages 05-06). It is split into four documents:

- `version-control.md` — Git, branching strategies (Git Flow, GitHub Flow, GitLab Flow, Trunk-Based Development), and the DORA research on branching.
- `code-review.md` — Code review standards, pair and mob programming.
- `coding-practices.md` — TDD, BDD, refactoring, Clean Code and its critics, static analysis, style guides.
- `documentation.md` — Code as documentation, API docs (OpenAPI), Diátaxis framework, developer tooling (dev containers).

Each document follows the CLAUDE.md format: question, status, body with inline citations, Sources, and Open questions. Every cited URL in this directory was fetched in this session; where a fetch failed, the claim is either omitted or tagged `[UNVERIFIED]`.

## Cross-cutting observations [SYNTHESIS]

1. **Primary authorities for this stage are a small set of named individuals and organizations.** For version control: Scott Chacon and Ben Straub (Pro Git), Vincent Driessen (Git Flow), Paul Hammant (Trunk-Based Development), Martin Fowler (Continuous Integration, Refactoring, CodeAsDocumentation), and the DORA team at Google Cloud. For coding practices: Kent Beck (TDD, XP, pair programming), Daniel Terhorst-North (BDD), Aslak Hellesøy (Cucumber). For documentation: Daniele Procida (Diátaxis). This is a synthesis based on the sources fetched in this session; it is not a claim that these are the only or most authoritative voices.

2. **Sources disagree about long-lived branches.** Driessen's 2010 Git Flow model [prescribes long-lived `develop` and `master` branches](https://nvie.com/posts/a-successful-git-branching-model/); Fowler, Hammant, and DORA all argue against long-lived branches in favor of integrating to trunk at least daily. Driessen himself, in a 2020 reflection at the top of his original post, recommends simpler workflows such as GitHub Flow for teams practicing continuous delivery. [CONTESTED]

3. **"Best practice" claims need anchoring.** Where this directory uses evaluative language ("small CLs are better"), the claim is attributed to its source (e.g. Google's engineering practices guide) rather than asserted as universal.

## Sources (this README only — full lists are inside each doc)

- [Pro Git — Chacon & Straub, 2014](https://git-scm.com/book/en/v2) (accessed 2026-04-24)
- [A successful Git branching model — Vincent Driessen, 2010; updated note 2020](https://nvie.com/posts/a-successful-git-branching-model/) (accessed 2026-04-24)
- [Trunk-Based Development — Paul Hammant](https://trunkbaseddevelopment.com/) (accessed 2026-04-24)
- [DORA capabilities catalog](https://dora.dev/capabilities/) (accessed 2026-04-24)

## Open questions

- What is the actual, current DORA capability URL structure (dora.dev has moved content across the years)? Cross-reference when doing stage 06 (Release).
- Does the Pro Git book have a 3rd edition? The version fetched here lists "2nd Edition, 2014."
- Is there a more recent Driessen post expanding on the 2020 caveat? Not found in this session.
