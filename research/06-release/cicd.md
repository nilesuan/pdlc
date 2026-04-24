# CI/CD — Continuous Integration, Delivery, and Deployment

**Question:** What do CI, Continuous Delivery, and Continuous Deployment actually mean; how do they differ; and what do industrial pipelines look like?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Continuous Integration

### Definition

`[VERIFIED]` Martin Fowler's canonical definition, in the revised 2024 version of his article (originally published 2000):

> "Continuous Integration is a software development practice where each member of a team merges their changes into a codebase together with their colleagues' changes at least daily."

([Continuous Integration — Martin Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)).

### Core practices

`[VERIFIED]` Fowler enumerates eleven practices in that article ([Continuous Integration — Fowler, 2024](https://martinfowler.com/articles/continuousIntegration.html)):

- Put everything in version-controlled mainline
- Automate the build
- Make builds self-testing
- Team members push commits daily
- Automated builds trigger on mainline pushes
- Fix broken builds immediately
- Keep builds fast
- Hide work-in-progress (e.g., behind flags)
- Test in production-environment clones
- Ensure visibility of system state
- Automate deployment

### Origin of the term

`[VERIFIED]` Fowler himself addresses the Grady Booch attribution directly: Booch "only used the phrase as an offhand description in a single sentence in his object-oriented design book. He did not treat it as a defined practice." ([Continuous Integration — Fowler, 2024](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)). Fowler attributes the practice-as-we-know-it to Kent Beck, who developed Continuous Integration within Extreme Programming during the 1990s (same source, accessed 2026-04-24).

### What this implies for a modern team

`[SYNTHESIS]` If the team cannot merge to mainline at least daily — because branches live for weeks, because code review is slow, or because the build is flaky — they are not doing CI in Fowler's sense regardless of whether they run a CI server. CI is a behaviour, not a tool. The tool enables the behaviour.

---

## 2. Continuous Delivery vs. Continuous Deployment

### Continuous Delivery

`[VERIFIED]` From continuousdelivery.com (the site maintained by Jez Humble, co-author with David Farley of the 2010 book *Continuous Delivery*):

> "Continuous Delivery is the ability to get changes of all types — including new features, configuration changes, bug fixes and experiments — into production, or into the hands of users, safely and quickly in a sustainable way."

The overarching objective is to make software deployments "predictable, routine affairs that can be performed on demand" ([Continuous Delivery — continuousdelivery.com](https://continuousdelivery.com/) (accessed 2026-04-24)).

### Continuous Deployment

`[VERIFIED]` Wikipedia's article on continuous deployment (used here for the distinction, not for a primary authoritative definition) states:

> "Continuous deployment (CD) is a software engineering approach in which software functionalities are delivered frequently and through automated deployments."

And on the distinction: continuous deployment "can be viewed as a more complete form of automation than continuous delivery" ([Continuous deployment — Wikipedia](https://en.wikipedia.org/wiki/Continuous_deployment) (accessed 2026-04-24)).

### The clean distinction

`[SYNTHESIS]` Combining the two sources above:
- **Continuous Delivery** = every commit is *ready to deploy to production*, but the decision to push is still gated (often by a human button-press).
- **Continuous Deployment** = every commit that passes the pipeline *is* pushed to production, no human gate.

Continuous Delivery is the prerequisite; Continuous Deployment is an optional extension on top. Humble's emphasis on deployments being performed "on demand" (rather than automatically on every commit) is consistent with this reading ([Continuous Delivery — continuousdelivery.com](https://continuousdelivery.com/)).

---

## 3. Deployment pipelines

### Definition

`[VERIFIED]` Fowler defines the deployment pipeline as a way to structure automated builds across stages, resolving a tension he names explicitly:

> "you want your build to be fast, so that you can get fast feedback, but comprehensive tests take a long time to run."

He also frames its collaborative role:

> "A deployment pipeline should enable collaboration between the various groups involved in delivering software and provide everyone visibility about the flow of changes in the system."

([Deployment Pipeline — Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)).

### Typical stage progression

`[SYNTHESIS]` Based on the Fowler article above and the pipeline models in GitHub Actions / GitLab CI / Jenkins documentation (fetched separately), a typical pipeline runs roughly:

1. **Build** — compile, package, produce artifacts.
2. **Unit + fast test** — fast feedback (Fowler's explicit goal above).
3. **Static analysis / lint / security scan** — e.g., dependency CVE scan, secrets scan, SAST.
4. **Integration / contract test** — against test doubles or a test environment.
5. **Package artifact** — container image, language package, or binary (see `dora-metrics.md` on artifact management and SLSA).
6. **Deploy to staging** — an environment close to production.
7. **End-to-end / acceptance test** — slower tests run here.
8. **Deploy to production** — often strategy-dependent (blue-green / canary / rolling — see `deployment-strategies.md`).

The order of steps 3–4 varies by team; what matters is that fast checks come first.

### Pipeline-as-code

`[VERIFIED]` All three reference implementations treat the pipeline as versioned code in the repository, not a GUI configuration:

- **GitHub Actions.** "A workflow is a configurable automated process made up of one or more jobs. You must create a YAML file to define your workflow configuration." Workflows live in `.github/workflows/` ([About workflows — GitHub Docs](https://docs.github.com/en/actions/writing-workflows/about-workflows) (accessed 2026-04-24)). A workflow has events (`on` key), jobs, and steps; steps either run a script or use an action.
- **GitLab CI.** Configuration starts with a `.gitlab-ci.yml` at the project root which "specifies the stages, jobs, and scripts to be executed during your CI/CD pipeline" ([GitLab CI/CD — GitLab Docs](https://docs.gitlab.com/ee/ci/) (accessed 2026-04-24)). "Stages define the order of execution. Typical stages might be `build`, `test`, and `deploy`. Jobs specify the tasks to be performed in each stage."
- **Jenkins.** A `Jenkinsfile` is the text file checked into source control that contains the pipeline. "Pipeline-as-code" provides "automatic Pipeline creation for branches, code review capability, audit trails, and a single source of truth for the delivery process." Declarative Pipeline is "designed to make writing and reading Pipeline code easier." A "stage block defines a conceptually distinct subset of tasks performed through the entire Pipeline (e.g. 'Build', 'Test' and 'Deploy' stages)." ([Jenkins Pipeline — jenkins.io](https://www.jenkins.io/doc/book/pipeline/) (accessed 2026-04-24)).

### What Jenkins is, concretely

`[VERIFIED]` "Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software." ([Jenkins — jenkins.io/doc](https://www.jenkins.io/doc/) (accessed 2026-04-24)).

---

## 4. Scripts-to-rule-them-all (normalised entry points)

`[VERIFIED]` A complementary practice from GitHub's engineering culture: a standard set of executable scripts (`script/setup`, `script/bootstrap`, `script/test`, `script/cibuild`, `script/update`, etc.) so a contributor can work on any project without knowing its internals. From the project README:

> "If your scripts are normalized by name across all of your projects, your contributors only need to know the pattern, not a deep knowledge of the application."

`script/cibuild` is "used for your continuous integration server" and `script/test` "should be called from `script/cibuild`" ([scripts-to-rule-them-all — GitHub](https://github.com/github/scripts-to-rule-them-all) (accessed 2026-04-24)).

`[SYNTHESIS]` The practical value: your CI YAML becomes thin, and the same commands work locally, in CI, and in containers. It's an orthogonal pattern to pipeline-as-code — the pipeline *calls* the scripts rather than embedding the logic.

---

## 5. Release cadence — continuous vs. time-based vs. on-demand

`[SYNTHESIS]` The fetched sources describe three broad cadence patterns. Each has a defensible place:

- **Continuous** (each commit that passes can be released). Matches Continuous Deployment as defined above. Requires Continuous Delivery plus a strategy that tolerates fast iteration (canary, feature flag).
- **On-demand** (release button is pressed when the change is "ready"). This is Humble's default — "predictable, routine affairs that can be performed on demand" ([Continuous Delivery — continuousdelivery.com](https://continuousdelivery.com/)). Compatible with any deployment strategy.
- **Time-based** (e.g., weekly train, monthly release). Not explicitly endorsed by any source fetched; commonly used where release *coordination* with humans (marketing, support, regulators) dominates technical velocity. Left `[UNVERIFIED]` as a prescriptive claim — the fetched sources document continuous and on-demand cadences but do not present time-based cadence as a first-class industry pattern.

`[SYNTHESIS]` The important property is not "how often we deploy" but "how small the change is per deploy." DORA's deployment-frequency metric conflates the two, but the underlying rationale (small changes are lower risk) is what matters.

---

## Open questions

- **Monorepo vs. multi-repo CI.** Not covered by the primary sources fetched in this session. Pipeline orchestration at scale (Bazel remote cache, merge queues, workflow reuse) is a distinct topic.
- **Pipeline security (runner trust, secrets, OIDC federation).** GitHub Actions docs reference these but the fetched page did not cover them; flagged for a follow-up fetch.
- **Merge queues.** A widely adopted CI-adjacent pattern (GitHub Merge Queue, GitLab merge trains, Bors) — not covered by any fetched source here.

## Sources

- [Continuous Integration — Martin Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [Continuous Delivery — continuousdelivery.com](https://continuousdelivery.com/) (accessed 2026-04-24)
- [Continuous deployment — Wikipedia](https://en.wikipedia.org/wiki/Continuous_deployment) (accessed 2026-04-24)
- [Deployment Pipeline — Martin Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)
- [About workflows — GitHub Docs](https://docs.github.com/en/actions/writing-workflows/about-workflows) (accessed 2026-04-24)
- [GitHub Actions overview — GitHub Docs](https://docs.github.com/en/actions) (accessed 2026-04-24)
- [GitLab CI/CD — GitLab Docs](https://docs.gitlab.com/ee/ci/) (accessed 2026-04-24)
- [Jenkins — jenkins.io/doc](https://www.jenkins.io/doc/) (accessed 2026-04-24)
- [Jenkins Pipeline — jenkins.io](https://www.jenkins.io/doc/book/pipeline/) (accessed 2026-04-24)
- [scripts-to-rule-them-all — GitHub](https://github.com/github/scripts-to-rule-them-all) (accessed 2026-04-24)
