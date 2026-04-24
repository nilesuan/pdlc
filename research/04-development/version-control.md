# Version Control and Branching Strategies

**Question:** What is Git, what are the major branching strategies (Git Flow, GitHub Flow, GitLab Flow, Trunk-Based Development), and what does DORA research say about branching?

**Status:** Draft

**Last updated:** 2026-04-24

## 1. Git — the tool

Git is a distributed version control system. The canonical reference is the **Pro Git** book by Scott Chacon and Ben Straub, second edition, published by Apress in 2014 under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 license [VERIFIED]. The book is freely available at [git-scm.com/book/en/v2](https://git-scm.com/book/en/v2) and is structured in 10 chapters covering Getting Started, Git Basics, Git Branching, Git on the Server, Distributed Git, GitHub, Git Tools, Customizing Git, Git and Other Systems, and Git Internals, plus three appendices (Git in Other Environments, Embedding Git in Applications, Git Commands Reference). [Pro Git — Chacon & Straub, 2014](https://git-scm.com/book/en/v2) (accessed 2026-04-24).

The Pro Git chapter on branching workflows describes two main workflow families [VERIFIED]:

1. **Long-running branches** — a "progressive-stability workflow" where a `master` branch holds only stable code, a `develop` or `next` branch is used for testing and integration, and topic branches feed into the integration branch. Larger projects may add `proposed` or `pu` branches.
2. **Topic branches** — short-lived branches created for a specific feature or fix, merged and deleted, potentially many times per day.

The book observes that "all branching and merging happens locally" with no server communication required, and explicitly recommends reading the Distributed Git chapter before picking a workflow. [Pro Git — Branching Workflows](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows) (accessed 2026-04-24).

## 2. Git Flow (Vincent Driessen, 2010)

Vincent Driessen published "A successful Git branching model" on 5 January 2010 [VERIFIED]. [A successful Git branching model — Vincent Driessen](https://nvie.com/posts/a-successful-git-branching-model/) (accessed 2026-04-24).

The model defines two permanent branches and three kinds of supporting branches:

- **`master`** — production-ready code; every commit represents a release.
- **`develop`** — integration branch holding the latest development changes for the next release.
- **Feature branches** — branch from `develop`, merge back to `develop`.
- **Release branches** — branch from `develop`, merge into both `develop` and `master`. Enable last-minute bug fixes and version-number preparation while `develop` stays open for the next release's features.
- **Hotfix branches** — branch from `master`, merge into both `master` and `develop`. Handle critical production bugs without disrupting active development.

**Important 2020 caveat.** On 5 March 2020, Driessen added a "Reflections" note at the top of his original post clarifying that the model was designed for "explicitly versioned software," often requiring multiple supported versions in production. For teams practicing continuous delivery of a single product (typical of web/SaaS software), he recommends simpler workflows such as GitHub Flow. He closes: "Always remember that panaceas don't exist. Consider your own context. Don't be hating. Decide for yourself." [VERIFIED — re-verified 2026-04-24]. [A successful Git branching model — Vincent Driessen, 2020 update](https://nvie.com/posts/a-successful-git-branching-model/) (accessed 2026-04-24).

## 3. GitHub Flow

GitHub Flow is documented by GitHub as "a lightweight, branch-based workflow" [VERIFIED]. The six-step workflow is [About GitHub Flow — docs.github.com](https://docs.github.com/en/get-started/using-github/github-flow) (accessed 2026-04-24):

1. Create a branch (descriptive name, e.g. `increase-test-timeout`).
2. Make changes with descriptive commit messages.
3. Create a pull request.
4. Address review comments.
5. Merge the pull request into the default branch.
6. Delete the branch.

The model uses only a default branch plus short-lived feature branches per change. There is no separate `develop`, no release branches, and no hotfix branches. GitHub's own documentation pitches the flow as usable "for documentation, policy, and project management" beyond code.

### Shared repository vs fork-and-pull

GitHub describes two collaboration models under the same pull-request workflow [VERIFIED]:

- **Shared repository model** — collaborators have direct push access to a single repository; topic branches are created for changes.
- **Fork-and-pull model** — contributors fork the repository to their own namespace and propose changes via pull requests. GitHub notes: "You do not need permission from the upstream repository to push to a fork of it you created."

[About collaborative development models — docs.github.com](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models) (accessed 2026-04-24).

## 4. Trunk-Based Development (Paul Hammant)

Trunk-Based Development (TBD) is documented at [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/), created and maintained by Paul Hammant with community contributions [VERIFIED]. The site was built with Hugo and launched in the 2017-2020 timeframe per the fetched content. [Trunk-Based Development — Paul Hammant](https://trunkbaseddevelopment.com/) (accessed 2026-04-24).

Core principles as stated on the site:

- Developers collaborate primarily on a single branch ("trunk," "main," or "master").
- All developers commit to the main branch, with short-lived branches used only for code review before merging back.
- Long-lived branches are discouraged; release branches, if used, are deleted after release.
- Google's monorepo is cited as an existence proof that TBD can scale. [VERIFIED — as content on trunkbaseddevelopment.com] The site states directly: "Google does Trunk-Based Development and have 35000 developers and QA automators in that single [monorepo] trunk" ([Trunk-Based Development — trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/) (accessed 2026-04-24)); no primary citation is provided on the page itself.
- [CONTESTED] Cross-reference with Potvin & Levenberg (CACM 2016, *Communications of the ACM* 59(7), pp. 78–87) gives "more than 25 thousand" engineers, ~1 billion lines of code, 35 million commits, ~15 million LOC changed weekly — verified via [research.google abstract](https://research.google/pubs/why-google-stores-billions-of-lines-of-code-in-a-single-repository/) and [AcaWiki summary](https://acawiki.org/Why_Google_Stores_Billions_of_Lines_of_Code_in_a_Single_Repository) (both accessed 2026-04-24). The CACM fulltext returned HTTP 403 on direct fetch. The difference (35,000 vs 25,000) most likely reflects (a) a later snapshot used by trunkbaseddevelopment.com, and (b) broader inclusion ("developers and QA automators") versus the paper's "engineers." Both numbers should be reported with their source/year.

### Short-lived feature branches

A specific sub-page spells out the rules for short-lived feature branches [VERIFIED]:

- Branch lifetime: "the branch should only last a couple of days." Longer risks becoming a long-lived branch.
- For teams up to 15 developers, committing directly to trunk is more efficient; short-lived branches become advantageous at 16+.
- Developer count per branch: one, or two if pair programming.
- Workflow: developers pull updates from trunk into the feature branch, then merge back to trunk before deletion.

[Short-Lived Feature Branches — trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/short-lived-feature-branches/) (accessed 2026-04-24).

## 5. GitLab Flow

GitLab describes GitLab Flow as "a simplified Git branching strategy that integrates feature-driven development with issue tracking and continuous delivery" [VERIFIED]. Branches used:

- **Main branch** — where all features and fixes flow.
- **Production branch** — for deployed code.
- **Pre-production branches** — optional; e.g. `main → test → acceptance → production`.
- **Release branches** — optional, for maintaining multiple software versions.

GitLab contrasts the model with Git Flow: "GitFlow establishes a develop branch as the default, whereas GitLab Flow works with the main branch right away." The guide pitches reduced overhead in releases and the ability to maintain several versions in different environments.

[What is GitLab Flow? — about.gitlab.com](https://about.gitlab.com/topics/version-control/what-is-gitlab-flow/) (accessed 2026-04-24).

> **Note on source availability:** Attempts to fetch `docs.gitlab.com/topics/gitlab_flow.html` in this session returned an authentication-redirect response (302 to projects.gitlab.io/auth). The `about.gitlab.com/topics/...` page is GitLab's own hosted explanation and was fetched successfully.

## 6. DORA research on branching

DORA (DevOps Research and Assessment), now part of Google Cloud, maintains a capabilities catalog at [dora.dev/capabilities/](https://dora.dev/capabilities/) (accessed 2026-04-24) that includes "trunk-based development" as a named capability [VERIFIED]. Per the catalog, DORA's 34 practices are organized across core, AI, and general categories; "trunk-based development" is in the core set.

The dedicated capability page states, based on DORA analysis from 2016-2017, that teams with superior software delivery performance [VERIFIED]:

- "Have three or fewer active branches in the application's code repository."
- "Merge branches to trunk at least once a day."
- "Don't have code freezes and don't have integration phases."

[Trunk-Based Development capability — dora.dev](https://dora.dev/capabilities/trunk-based-development/) (accessed 2026-04-24).

Implementation tips called out on the same page include small batch development, synchronous code reviews at merge time rather than asynchronous reviews, automated testing before every commit, fast builds, and leadership support. Common obstacles are heavyweight review processes and insufficient automated testing.

> **Caveat on DORA.** The DORA organization has moved its content between domains over the years (`cloud.google.com/architecture/devops`, `dora.dev`). The specific "three or fewer active branches" finding is attributed by the fetched dora.dev page to 2016-2017 analysis. Whether the most recent *State of DevOps* report still repeats this specific number is not verified in this session — [OUT OF DATE] risk is present for the exact quote, though the directional finding (fewer branches = better performance) is consistently repeated across DORA capabilities.

### DORA metrics — the four key measures

DORA measures software delivery performance via four metrics [VERIFIED] (listed in the 2025 DORA report fetched via `cloud.google.com/devops/state-of-devops`):

1. **Deployment Frequency** — how often code is deployed to production.
2. **Lead Time for Changes** — time from code commit to production deployment.
3. **Change Failure Rate** — percentage of deployments causing failures.
4. **Mean Time to Recovery (MTTR)** — time to restore service after a failure.

[State of DevOps — cloud.google.com/devops/state-of-devops](https://cloud.google.com/devops/state-of-devops) (accessed 2026-04-24).

The fetched page reports performance tiers (Elite / High / Medium / Low) for deployment frequency and change failure rate. Deeper analysis of these specific numbers is deferred to stage 06 (Release).

## 7. Continuous integration and feature branches — Fowler

Martin Fowler provides a widely-cited critique of long-lived feature branches. In "Continuous Integration," Fowler defines CI as merging changes into a shared codebase at least daily, with each integration verified by automated build and test [VERIFIED]. He distinguishes three integration styles [Continuous Integration — Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24):

- Pre-Release Integration (once before release).
- Feature Branching (integration when each feature completes).
- Continuous Integration (daily mainline integration by all developers).

Fowler's list of CI practices includes self-testing builds, daily mainline commits, immediate fixing of broken builds, fast builds (target ten minutes), and using feature flags / branch by abstraction to hide work-in-progress rather than hiding it on a long branch.

In a separate short piece, Fowler writes that feature branches "prevent early detection of problems" and "discourages refactoring," and that the impact depends on how quickly features are completed: teams finishing in a day or two avoid the worst problems; teams taking weeks or months face greater difficulties [VERIFIED]. [Feature Branch — Fowler](https://martinfowler.com/bliki/FeatureBranch.html) (accessed 2026-04-24).

## 8. Summary comparison [SYNTHESIS]

Based on the sources fetched above:

| Strategy | Branches | Merge cadence | Fits |
|---|---|---|---|
| Git Flow | `master`, `develop`, feature, release, hotfix | Release-paced | Versioned software, multi-version support (per Driessen 2020 note) |
| GitHub Flow | default + feature | Per PR; continuous | Web/SaaS with continuous delivery |
| GitLab Flow | main + environment branches (+ optional release branches) | Continuous to main; promoted through environments | Teams wanting CI flow with staged environments |
| Trunk-Based | trunk + very short-lived branches | Daily (or sub-daily) to trunk | CI/CD, high-performing teams per DORA |

The table synthesizes claims made in each of the cited sources above; it is not a recommendation.

## Sources

- [Pro Git (2nd edition) — Scott Chacon & Ben Straub, 2014](https://git-scm.com/book/en/v2) (accessed 2026-04-24)
- [Pro Git — Branching Workflows](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows) (accessed 2026-04-24)
- [A successful Git branching model — Vincent Driessen, 2010 (with 2020 update)](https://nvie.com/posts/a-successful-git-branching-model/) (accessed 2026-04-24)
- [GitHub Flow — docs.github.com](https://docs.github.com/en/get-started/using-github/github-flow) (accessed 2026-04-24)
- [About collaborative development models — docs.github.com](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/about-collaborative-development-models) (accessed 2026-04-24)
- [Trunk-Based Development — Paul Hammant](https://trunkbaseddevelopment.com/) (accessed 2026-04-24)
- [Short-Lived Feature Branches — trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/short-lived-feature-branches/) (accessed 2026-04-24)
- [What is GitLab Flow? — about.gitlab.com](https://about.gitlab.com/topics/version-control/what-is-gitlab-flow/) (accessed 2026-04-24)
- [DORA capabilities catalog](https://dora.dev/capabilities/) (accessed 2026-04-24)
- [DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) (accessed 2026-04-24)
- [DORA — Code Maintainability capability](https://dora.dev/capabilities/code-maintainability/) (accessed 2026-04-24)
- [State of DevOps — cloud.google.com/devops/state-of-devops](https://cloud.google.com/devops/state-of-devops) (accessed 2026-04-24)
- [Continuous Integration — Martin Fowler](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [Feature Branch — Martin Fowler](https://martinfowler.com/bliki/FeatureBranch.html) (accessed 2026-04-24)
- [Why Google Stores Billions of Lines of Code in a Single Repository — Potvin & Levenberg, CACM 59(7) 2016 (research.google abstract)](https://research.google/pubs/why-google-stores-billions-of-lines-of-code-in-a-single-repository/) (accessed 2026-04-24)
- [Why Google Stores Billions of Lines of Code in a Single Repository — AcaWiki summary](https://acawiki.org/Why_Google_Stores_Billions_of_Lines_of_Code_in_a_Single_Repository) (accessed 2026-04-24)

## Open questions

- The primary `docs.gitlab.com/topics/gitlab_flow.html` URL redirected to an auth gateway in this session; the `about.gitlab.com` page was used instead. Is there a publicly fetchable canonical URL?
- DORA's "three or fewer active branches" finding dates to 2016-2017 analysis per the fetched dora.dev page. Is this still the published figure in the 2024 or 2025 *State of DevOps* reports? Needs checking in stage 06.
- **Corrected:** trunkbaseddevelopment.com's "35,000-developer" phrasing is not the number in the Potvin & Levenberg 2016 CACM paper. The paper reports approximately **25,000 developers** at the January 2015 snapshot. The figure now cited in §4 is the 25,000 number sourced from two independent summaries of the paper; the CACM fulltext URL returned 403 in this session.
- Bacchelli & Bird 2013 is now partially verified — the Microsoft Research landing page abstract was fetched ([microsoft.com/en-us/research/publication/...](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/) accessed 2026-04-24); the full PDF text could not be parsed because WebFetch returned binary PDF bytes. Core findings (reviews deliver knowledge-transfer more than defect-finding; understanding is the bottleneck) are verified from the abstract.
