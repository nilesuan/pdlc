# Stage 06 — Release & Deployment

**Question:** What does industry-grade release and deployment look like for modern software, from CI through production rollout and artifact management?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Scope and reading order

This stage covers everything from the moment code is merged to the moment users see it in production, including the pipelines, deployment patterns, metrics, and artifact provenance that support it. The material is split across four companion documents for readability. This README is an index plus a short synthesis.

- [cicd.md](./cicd.md) — Continuous Integration, Continuous Delivery vs. Continuous Deployment, deployment pipelines, GitHub Actions / GitLab CI / Jenkins.
- [deployment-strategies.md](./deployment-strategies.md) — blue-green, canary, rolling, shadow/dark launch, environment strategy.
- [feature-flags.md](./feature-flags.md) — feature toggles, progressive delivery, release management, versioning and changelogs.
- [dora-metrics.md](./dora-metrics.md) — the DORA four keys, performance levels, database migrations, rollback, artifact/supply chain (SLSA, SBOM).

All definitions below are tagged `[VERIFIED]` (directly supported by a fetched source), `[SYNTHESIS]` (inference combining cited sources, with reasoning shown), or `[UNVERIFIED]`.

---

## One-paragraph synthesis of Stage 06

`[SYNTHESIS]` Release and deployment in a modern software organisation is built from three layers, each with its own literature. The innermost layer is **Continuous Integration**: every change is merged to mainline at least daily and the mainline is kept always green via an automated, self-testing build ([Continuous Integration — Fowler, 2024](https://martinfowler.com/articles/continuousIntegration.html)). The middle layer is **Continuous Delivery**: the output of CI is pushed through a deployment pipeline that keeps every commit in a releasable state, so deployment becomes "a predictable, routine affair that can be performed on demand" ([Continuous Delivery — Humble, n.d.](https://continuousdelivery.com/)). The outermost layer is **release strategy**: once a change is technically deployable, the organisation still chooses *how* to expose it to users — blue-green, canary, rolling, dark launch, feature flag, progressive rollout — and decouples deploy from release ([Feature Toggles — Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html); [Canary Release — Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)). DORA's four key metrics (deployment frequency, change lead time, change failure rate, time to restore) measure whether that stack is working ([Four Keys — Google Cloud blog, n.d.](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)); SLSA and SBOM practices measure whether the artifacts that flow through it are trustworthy ([SLSA — slsa.dev, n.d.](https://slsa.dev/)).

---

## The shape of a modern release pipeline

`[VERIFIED]` Fowler defines a **deployment pipeline** as a strategy for managing automated builds by dividing the process into stages. He identifies its key design tension: "you want your build to be fast, so that you can get fast feedback, but comprehensive tests take a long time to run" ([Deployment Pipeline — Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)). Stages typically progress from fast compile-and-unit-test, through slower integration and security checks, to production deployment.

`[VERIFIED]` Both GitHub Actions and GitLab CI implement this pattern as **pipeline-as-code**: pipelines are defined in YAML files stored in the repository. GitHub Actions workflows live in `.github/workflows`: "A workflow is a configurable automated process made up of one or more jobs. You must create a YAML file to define your workflow configuration" ([About workflows — GitHub Docs, n.d.](https://docs.github.com/en/actions/writing-workflows/about-workflows) (accessed 2026-04-24)). GitLab's `.gitlab-ci.yml` expresses the same model: "Stages define the order of execution. Typical stages might be `build`, `test`, and `deploy`. Jobs specify the tasks to be performed in each stage" ([GitLab CI/CD — GitLab Docs, n.d.](https://docs.gitlab.com/ee/ci/) (accessed 2026-04-24)). Jenkins uses a `Jenkinsfile` with the same idea: "Pipeline-as-code" means pipeline definitions become "versionable application code" that can be code-reviewed and audited ([Jenkins Pipeline — jenkins.io, n.d.](https://www.jenkins.io/doc/book/pipeline/) (accessed 2026-04-24)).

`[SYNTHESIS]` Across these three systems the abstractions line up: workflow / pipeline, jobs / stages, steps. The material differences are scheduling semantics (e.g. GitHub's event model vs. GitLab's stage dependency model) and where runners live. The shared idea — pipeline expressed as versioned YAML alongside the code — is consistent.

---

## The four levels of release decoupling

`[SYNTHESIS]` Reading Fowler, Humble/Farley, Hodgson, and Governor together, the industry has progressively decoupled four concepts that were originally one:

1. **Merge** — code goes to mainline. Gated by CI ([Continuous Integration — Fowler, 2024](https://martinfowler.com/articles/continuousIntegration.html)).
2. **Deploy** — the artifact runs in a production-like environment. Gated by the deployment pipeline ([Deployment Pipeline — Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html)).
3. **Release** — the change becomes reachable by real user traffic. Gated by deployment strategy (blue-green, canary, rolling) ([Blue-Green Deployment — Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html); [Canary Release — Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)).
4. **Expose** — the change is *visible* to a particular user cohort. Gated by feature flags and progressive delivery ([Feature Toggles — Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html); [Towards Progressive Delivery — Governor, 2018 (search-verified)](https://redmonk.com/jgovernor/2018/08/06/towards-progressive-delivery/)).

The payoff of this decoupling is that a production incident no longer requires a redeploy; a flag flip or a router change is enough. That is what makes modern mean-time-to-restore numbers possible (see `dora-metrics.md`).

---

## What changed in DORA since the original four keys

`[VERIFIED]` The canonical four keys are: Deployment Frequency, Lead Time for Changes, Change Failure Rate, and Time to Restore Service — two velocity metrics and two stability metrics ([Four Keys — Google Cloud blog, n.d.](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)).

`[VERIFIED]` `[OUT OF DATE]` The public DORA guide at dora.dev now frames five metrics, splitting "stability" into Change Fail Rate and Deployment Rework Rate, and renaming Time to Restore to "Failed Deployment Recovery Time": "The time it takes to recover from a deployment that fails and requires immediate intervention" ([DORA's software delivery metrics: the four keys — dora.dev, n.d.](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)). Teams citing "the four keys" should be aware of this evolution, and should pick a definition and stick to it for trend data to remain comparable.

`[CONTESTED]` Performance tiers. The 2023 State of DevOps Report announced the return of the **Elite** performance level: "Our analysis revealed four performance levels, including the return of the Elite performance level, which we did not detect in last year's cohort" ([2023 State of DevOps — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)). The 2022 report had detected only three clusters (High, Medium, Low) per the Google Cloud Four Keys blog editor's note ([Four Keys — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)). So "Elite/High/Medium/Low" is the dominant framing but not stable year-on-year.

Full detail is in [dora-metrics.md](./dora-metrics.md).

---

## Supply chain and artifacts

`[VERIFIED]` **SLSA** ("Supply-chain Levels for Software Artifacts", pronounced "salsa") is "a security framework, a checklist of standards and controls to prevent tampering, improve integrity, and secure packages and infrastructure." It defines graduated build levels (L1: provenance exists; L2: hosted build platform with signed provenance; L3: hardened builds that prevent tampering during the build) ([SLSA — slsa.dev, n.d.](https://slsa.dev/) (accessed 2026-04-24); [SLSA Build Levels — slsa.dev, n.d.](https://slsa.dev/spec/v1.0/levels) (accessed 2026-04-24)).

`[VERIFIED]` An **SBOM** is "a nested inventory for software, a list of ingredients that make up software components" ([Software Bill of Materials — NTIA, n.d.](https://www.ntia.gov/page/software-bill-materials) (accessed 2026-04-24)). SBOMs were formalised by NTIA and are now coordinated by CISA under Executive Order 14028; a 2025 CISA document updates NTIA's 2021 "Minimum Elements" baseline ([SBOM search result summary — CISA, 2025](https://www.cisa.gov/sbom) (not directly fetched; 403 on direct fetch — see Open questions)).

Full detail is in [dora-metrics.md#artifact-management-slsa-sbom](./dora-metrics.md).

---

## Open questions and gaps carried forward

- **Mobile and embedded differ materially.** All sources fetched for this stage treat deployment as push-to-server. Store review cycles (App Store, Play), firmware OTA, and long-lived client versions invalidate parts of the CD model. `[UNVERIFIED]` — not yet researched.
- **Rollback vs. roll-forward culture.** The fetched sources describe the mechanisms (blue-green router switch; canary abort) but do not quantify when one is preferred over the other. This is flagged and revisited in `deployment-strategies.md`.
- **CISA page unreachable.** A direct `WebFetch` of `https://www.cisa.gov/sbom` returned HTTP 403 on 2026-04-24. We rely on NTIA's definition and a search-result summary for the CISA role; a re-fetch through an alternate path is the cleanest fix.
- **"Meta/Facebook originated dark launch."** Commonly asserted in practitioner writing, but Fowler's own `DarkLaunching` page does not attribute an origin company, and the search results surfaced do not include a primary Facebook Engineering post verifying this. Claim left `[UNVERIFIED]` in `deployment-strategies.md`.
- **"Progressive delivery was coined by James Governor."** Attributed in the web search result summary and reflected in Governor's own RedMonk posts, but a direct fetch of the canonical 2018 RedMonk article returned 404 on 2026-04-24. Treated as `[SYNTHESIS]` based on the search result corroboration plus RedMonk's own "the book is here" page title.
- **Accelerate book citations.** The book by Forsgren/Humble/Kim (2018) that underpins DORA is referenced indirectly through Google Cloud and dora.dev content; a direct primary citation is not fetched and is not included here.

---

## Sources (this file)

- [Continuous Integration — Martin Fowler, 2024 (rev.)](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [Continuous Delivery — continuousdelivery.com, n.d.](https://continuousdelivery.com/) (accessed 2026-04-24)
- [Deployment Pipeline — Martin Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)
- [Blue-Green Deployment — Martin Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html) (accessed 2026-04-24)
- [Canary Release — Danilo Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24)
- [Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24)
- [About workflows — GitHub Docs](https://docs.github.com/en/actions/writing-workflows/about-workflows) (accessed 2026-04-24)
- [GitLab CI/CD — GitLab Docs](https://docs.gitlab.com/ee/ci/) (accessed 2026-04-24)
- [Jenkins Pipeline — jenkins.io](https://www.jenkins.io/doc/book/pipeline/) (accessed 2026-04-24)
- [Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)
- [DORA's software delivery metrics: the four keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)
- [Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)
- [SLSA — slsa.dev](https://slsa.dev/) (accessed 2026-04-24)
- [SLSA Build Levels — slsa.dev](https://slsa.dev/spec/v1.0/levels) (accessed 2026-04-24)
- [Software Bill of Materials — NTIA](https://www.ntia.gov/page/software-bill-materials) (accessed 2026-04-24)
