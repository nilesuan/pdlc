---
name: version control and collaboration
description: Industry-standard version control, code hosting, and code review tools and practices
type: research
---

# Version Control and Collaboration

**Question:** What are the current industry-standard tools and practices for version control and code collaboration in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** The version control system itself (Git), code-hosting / forge platforms, code-review tooling, and branching strategies. CI/CD that sits alongside the forge is in `07-ci-cd.md`; GitOps deployment in `06-orchestration.md`.

## Shape of the decision

1. **Version control system.** Effectively a single choice in 2026: **Git**. Other systems (Mercurial, Subversion, Perforce, Fossil) still exist in specific niches but are not the default.
2. **Forge / code-hosting platform.** GitHub, GitLab, Bitbucket (Atlassian), Azure DevOps Repos, self-hosted Gitea / Forgejo. Also Gerrit (review-centric) in some engineering-heavy orgs.
3. **Branching strategy.** Trunk-based development (short-lived branches, merge to main at least daily) vs. Git Flow / GitHub Flow / release branches.
4. **Review model.** Pull/merge-request with inline review (the forge-native default), or patch-email / Gerrit-style change-per-commit (used at Linux kernel, Google, some large C/C++ shops).

## Evidence base

- **Git history — primary.** [[git-scm — A Short History of Git](https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git)] (accessed 2026-04-24) [VERIFIED]: Git was created in 2005 by Linus Torvalds after the Linux kernel project's BitKeeper license was revoked. Design goals: speed, simple design, strong support for non-linear development (thousands of parallel branches), fully distributed, efficient handling of large projects.
- **GitHub scale — primary.** [[GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] (accessed 2026-04-24) [VERIFIED]: "Over 100 million total developers," "518 million projects across GitHub (25% year-over-year growth)," "108 million new repositories created in 2024," "5.6 billion contributions."
- **Git adoption — secondary.** Multiple secondary sources summarize Stack Overflow Developer Survey data as **"88.4% of professional developers use Git"** [UNVERIFIED — the Stack Overflow 2024 version-control category is in the Tools / "Other Tools" tab of the public survey; I could not extract the exact figure via the fetch endpoint in this session. Secondary reporting consistent.] [CONTESTED/imprecise — another widely repeated figure is 93.87%, suggesting different survey years or sub-populations.]
- **DORA trunk-based development finding — primary.** [[DORA Capability: Trunk-based development](https://dora.dev/capabilities/trunk-based-development/)] (accessed 2026-04-24) [VERIFIED]: "teams achieve higher levels of software delivery and operational performance if they have three or fewer active branches in the application's code repository, merge branches to trunk at least once a day, and don't have code freezes or integration phases."
- **JetBrains / GitKraken State of Git Collaboration 2024 — secondary.** Sample size reported as "over 150,000 developers" [[JetBrains blog summary](https://blog.jetbrains.com/team/2024/03/05/are-dev-teams-surviving-or-thriving-in-2024-insights-from-jetbrains-and-gitkraken-s-state-of-git-collaboration-report/)] (accessed 2026-04-24) [VERIFIED summary]; the underlying numeric breakdowns by platform are gated in the PDF and were not extracted here. "GitHub leading the charge for both company and personal projects" [VERIFIED as a qualitative statement].

## Git: the de-facto version control system

Git is the near-universal choice in 2026. A few characteristics explain that dominance:

- **Distributed by design.** Every clone contains the full history. No dependency on a central server for most operations.
- **Branching is cheap.** Git branches are pointers to commits; creating one is O(1). This makes short-lived branches practical, which in turn enables trunk-based development and PR-style workflows.
- **Content-addressed storage.** SHA-1 (transitioning to SHA-256) hashes over content create a Merkle DAG, giving strong integrity guarantees.
- **Massive ecosystem.** Every major forge, IDE, CI system, code-review tool, and language package manager assumes Git.

### Alternatives still used

- **Subversion (SVN).** Centralized. Still in use in some long-lived enterprises, older open-source projects (Apache some, formerly), and regulated environments that prefer centralized history control.
- **Mercurial (Hg).** Distributed VCS, design-comparable to Git. Adopted by Facebook early on; Facebook/Meta's Sapling (and eden/mononoke) is a Mercurial-compatible system [UNVERIFIED specifics here].
- **Perforce / Helix.** Centralized VCS long used in games, film, and monorepo-heavy C++ shops; handles very large binary assets well.
- **Fossil.** Small VCS bundled with SQLite's project.
- **Piper / g4** (Google-internal). Monorepo VCS specific to Google; not available publicly.

The shift away from these systems is decisive: any organization choosing a VCS greenfield in 2026 is choosing Git.

## Forge platforms

### GitHub

- **Acquired by Microsoft in 2018.**
- **Scale (2024):** 100M+ users, 518M projects, 108M new repos that year, 5.6B contributions [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] [VERIFIED].
- **Capabilities:** repos, issues, pull requests, GitHub Actions (CI), GitHub Packages, GitHub Container Registry (GHCR), Codespaces (cloud IDE), Dependabot, GitHub Advanced Security (secret scanning, code scanning with CodeQL), Copilot.
- **Position:** dominant for open-source projects and for new commercial projects. The combined network effect of the hosted repo, the PR workflow, and the identity graph (followers, stars, contributions) is a significant moat.

### GitLab

- **Single-application platform:** repos, merge requests, GitLab CI/CD, registry, security scanning, issues, wiki, monitoring — all in one product.
- **Business model:** open-core — the core is open source (MIT/Community Edition equivalent), Enterprise Edition is commercial.
- **Self-hosting is a first-class story**, which has historically been a differentiator from GitHub.com. (GitHub Enterprise Server also self-hosts but is less emphasized.)
- Popular in regulated / sovereignty-sensitive and heavily-self-hosted environments.

### Bitbucket (Atlassian)

- Part of the Atlassian suite (Jira, Confluence, Bitbucket). Strongest in organizations already committed to Atlassian tooling.
- Atlassian has shifted Bitbucket toward cloud; Bitbucket Server (self-hosted) was rebranded as Bitbucket Data Center and has a smaller footprint post-2022 [UNVERIFIED specifics].
- Secondary-source numbers suggest Bitbucket has lost share to GitHub and GitLab over 2022–2025 [UNVERIFIED — cited by JetBrains/GitKraken summaries but specific percentages not primary-fetched].

### Azure DevOps Repos

- Microsoft's other Git hosting (separate product from GitHub). Still used in .NET-heavy / Microsoft enterprise accounts with Azure DevOps Pipelines and Boards. Microsoft's own messaging increasingly steers net-new customers to GitHub; Azure DevOps is on long-term maintenance.

### Gitea / Forgejo

- Open-source, self-hostable Git forges. Lightweight; used for self-sovereign / air-gapped environments, homelabs, and some corporate internal forges. **Forgejo** is a Codeberg-led fork of Gitea.

### Gerrit

- Change-per-commit review model (rather than PR / branch). Used at Google, ChromiumOS, Android, and in some telecom / embedded shops. Optimized for many-reviewer-per-change, fine-grained comment workflows.

### Others

- **SourceHut** (sr.ht) — email-workflow-first, minimal; popular among some kernel-adjacent projects.
- **Codeberg** — nonprofit Forgejo instance focused on free software.
- **AWS CodeCommit** — AWS's hosted Git. AWS announced CodeCommit limiting new-customer access in July 2024 [UNVERIFIED specific date].

## Branching strategies and their trade-offs

### Trunk-based development (TBD)

- Short-lived branches (hours to a day); merge to main at least daily.
- Associated with **higher DORA scores** [[DORA: Trunk-based development](https://dora.dev/capabilities/trunk-based-development/)] [VERIFIED]: teams with ≤3 active branches and daily-or-more merges outperform.
- Works best when paired with: feature flags (to hide unfinished work behind runtime toggles), strong CI, automated tests.

### GitHub Flow

- Simpler branch-and-PR model: feature branches off `main`, PR into `main`, deploy from `main`.
- Good fit for continuously deployed web apps. Common in SaaS.

### Git Flow (Driessen 2010)

- Multiple long-lived branches: `develop`, `main`, `release/*`, `hotfix/*`, feature branches.
- Originally designed for versioned software with scheduled releases. Still common in mobile, enterprise software, and OS distributions but widely considered overkill for web / SaaS. The original author has since said it is "not a good fit" for continuously delivered apps [UNVERIFIED specific quote; Driessen has published a note to this effect].

### Release branches

- A single long-lived `main` plus short-lived `release/X.Y` branches cut at release time for stabilization / hot fixes. Common in large products with support obligations across multiple versions (databases, major browsers, OS vendors).

### Stacked diffs / stacked PRs

- Treat changes as a stack of small commits that each reviewable as a unit. Native at Meta (Sapling), Google (Gerrit / Critique), and supported by tools like **Graphite** and **git-spice** on top of GitHub.
- Adoption is growing in 2024–2026 among high-velocity engineering orgs. No primary survey [UNVERIFIED].

## Code review

- **Pull / merge requests** — dominant model on GitHub, GitLab, Bitbucket, Azure Repos. Reviews happen on a branch-level unit.
- **Change-based review** (Gerrit / Critique / Phabricator) — each commit is the unit of review, revised in place.
- **Patch-email** (Linux kernel, Git, Postgres) — patches sent via `git format-patch` / `git send-email` to mailing lists. Still used by the oldest / most distributed OSS projects.

Common review expectations in modern teams:

- At least one human reviewer before merge.
- CI green before merge; many repos enforce this via branch protection rules.
- Automated code-quality checks (linters, type checkers, format checkers) gate merge.
- Security scanning (SAST, SCA, secret scanning) as PR checks — see `13-security.md`.

## Conventional commits, semantic versioning, release automation

- **Semantic Versioning (SemVer)** [[semver.org](https://semver.org)] [UNVERIFIED in this session — widely known spec v2.0.0]. Format: `MAJOR.MINOR.PATCH` with pre-release/build metadata.
- **Conventional Commits** [[conventionalcommits.org](https://www.conventionalcommits.org)] [UNVERIFIED in this session — widely used convention]. Message prefix tells tooling what kind of change it is (`feat:`, `fix:`, `chore:`, `BREAKING CHANGE:` footer).
- **Release automation tools:** semantic-release, Changesets (JS/TS), release-please (Google), goreleaser (Go).

These are common in open-source libraries and in many commercial monorepos but are not universally required.

## Repository architectures

- **Polyrepo** — each service / library in its own repo. The default on GitHub for loosely-coupled teams.
- **Monorepo** — all code in one repo. Used at Google, Meta, Microsoft (Windows), Airbnb (partial), Stripe (partial). Tooling: Bazel, Buck2, Pants, Nx, Turborepo.
- Trade-offs: monorepos simplify atomic cross-service changes and dependency alignment; polyrepos simplify independent release cadences and access control.

## Putting the stack together (typical 2026 defaults)

- **OSS / greenfield startup:** GitHub + GitHub Flow or trunk-based + GitHub Actions + Dependabot + CodeQL. Releases via semantic-release / Changesets.
- **Regulated enterprise:** Self-hosted GitLab EE or GitHub Enterprise Server + merge-request workflow + protected branches + SAST/SCA scanning + signed commits.
- **Atlassian-centric enterprise:** Bitbucket + Jira + Bamboo or Bitbucket Pipelines. Often has a migration-to-GitHub project in-flight.
- **Very large engineering orgs:** Monorepo on Git (with LFS or custom backends like Meta's Sapling / Google's Piper) + Gerrit-style change-based review or custom tooling + Bazel/Buck2 builds.
- **Kernel-style / open-source:** patch-email workflow on mailing lists with `git send-email`; maintainer pulls patches; `b4` tooling and kernel.org.

## Sources (accessed 2026-04-24)

- [git-scm — A Short History of Git](https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git)
- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
- [DORA Capability: Trunk-based development](https://dora.dev/capabilities/trunk-based-development/)
- [JetBrains / GitKraken State of Git Collaboration 2024 — summary](https://blog.jetbrains.com/team/2024/03/05/are-dev-teams-surviving-or-thriving-in-2024-insights-from-jetbrains-and-gitkraken-s-state-of-git-collaboration-report/)
- [Stack Overflow Developer Survey 2024](https://survey.stackoverflow.co/2024/)

## Open questions

- **Exact Stack Overflow 2024 Git adoption %.** Widely cited as 88.4% or 93.87% depending on year / sub-population. Not extracted as primary in this session.
- **GitHub vs GitLab vs Bitbucket market split in 2026.** JetBrains / GitKraken reports exist but the precise numeric breakdown was not primary-fetched here.
- **Self-hosted vs cloud split.** Anecdotally shifted toward cloud; no primary figure extracted.
- **Azure DevOps and AWS CodeCommit deprecation timelines** — widely reported as being phased down; specific schedule dates were not primary-fetched.
- **Stacked-PR tooling adoption** — growing qualitatively; no survey data.
- **Monorepo adoption share** — no primary survey located.
