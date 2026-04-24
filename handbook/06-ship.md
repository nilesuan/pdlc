# Phase 06 — Ship

**Goal:** Make deployment boring — automatic, fast, reversible — so shipping happens many times a day without drama.

**Duration:** Continuous (you ship constantly).

**You are done when:** A merged PR reaches production automatically within 30 minutes with no human intervention; rollback takes < 5 minutes.

---

## What this phase is about

Shipping well is what unlocks the iteration speed that makes everything else worthwhile. If shipping is painful, all the other practices get slower: tests get skipped because "we need to cut the release," refactors get postponed because "the next deploy is risky," experiments don't run because "we can't ship quickly enough." A weak deploy pipeline is an invisible tax on every other phase.

DORA's research quantifies the payoff. The 2024 Accelerate State of DevOps Report compared elite performers to low performers: "127x faster lead time; 182x more deployments per year; 8x lower change failure rate; 2293x faster failed deployment recovery times." That is a different operating regime. Teams that can ship safely many times a day change what kinds of product bets they can take.

The mindset: **releases should be unremarkable**. If your team talks about "release day," nominates a "release captain," runs a "release checklist," or holds deploys for a weekly window, those are symptoms of infrequent releases. The cure is not better rituals — it is deploying more often, until each deploy is small enough that the ritual is pointless.

---

## Who does what

**Everyone ships.** The developer who wrote the code is responsible for deploying it and watching it to production. There is no separate "ops hand-off"; there is no release manager who takes other people's code across the line.

- The **author** writes the code, merges it, watches the pipeline, watches the canary, and watches production metrics for at least 30 minutes after full rollout.
- The **reviewer** already signed off in Phase 04 — a second pair of eyes, not a gate that requires a meeting.
- **Platform / SRE** (if you have them) own the pipeline infrastructure, not individual releases. Their job is to make everyone else's deploys safer, not to press deploy buttons.
- **Product / Design** are informed (release notes, #shipped channel, product analytics), not gatekeepers.

If shipping requires any specific person's presence, shipping is broken.

---

## Inputs

From Phases 04–05, you arrive at this phase with:

- A merged PR on the main branch
- All tests passing in CI
- Code reviewed and approved
- An artifact (container image or package) built and available

From here, Phase 06 answers: *how does this become a running change visible to real users, safely?*

---

## The CI/CD pipeline

### Continuous Integration

Fowler defines CI as "a software development practice where each member of a team merges their changes into a codebase together with their colleagues' changes at least daily." It is a behaviour, not a tool — a CI server on a team that merges weekly is not doing CI.

Minimum rules:

- Every commit triggers the build.
- Every PR runs the full test suite.
- Main is always green; a broken main blocks all other work until fixed.
- Merges to main require green CI plus peer review.
- Branches live hours to a day or two, not weeks.

Fowler's eleven CI practices: put everything in version-controlled mainline, automate the build, make builds self-testing, push commits daily, trigger builds on mainline pushes, fix broken builds immediately, keep builds fast, hide work-in-progress behind flags, test in production-environment clones, ensure visibility of system state, automate deployment. Use this as your audit list; any missing practice is your weakest link.

### Continuous Delivery vs. Continuous Deployment

These words are often used interchangeably. They are not the same, and the distinction matters.

- **Continuous Delivery** (Humble): "the ability to get changes of all types — including new features, configuration changes, bug fixes and experiments — into production, or into the hands of users, safely and quickly in a sustainable way." Every commit is *ready to deploy*; a human still presses the button. Humble's framing: deployments should be "predictable, routine affairs that can be performed on demand."
- **Continuous Deployment**: every commit that passes the pipeline *is* deployed to production automatically, no human gate. Continuous Delivery is the prerequisite; Continuous Deployment is an extension.

**Prescription:** Continuous Deployment for low-risk services (stateless APIs, frontend assets, internal tools). Continuous Delivery with a manual production gate for high-risk paths — payment flows, identity, destructive database migrations, regulated surfaces. Most services should reach continuous deployment within months of standing up CI/CD; a handful of dangerous ones may stay on continuous delivery indefinitely. Do not put the whole product behind a manual gate "just to be safe" — that is not safety, it is delay. Safety comes from canary, feature flags, and fast rollback.

### The canonical pipeline

Fowler defines a deployment pipeline as a way to structure automated builds across stages, resolving a tension he names explicitly: "you want your build to be fast, so that you can get fast feedback, but comprehensive tests take a long time to run." The solution is to order stages so fast checks run first and failures abort before slow stages burn time.

A canonical pipeline:

1. **Build** — compile, package, produce artifacts. Must be deterministic and reproducible: the same commit produces the same artifact byte-for-byte (or at least hash-equivalent).
2. **Unit tests** — fast feedback. Under 5 minutes for this stage is the target.
3. **Integration tests** — against test doubles or a short-lived test environment.
4. **Static analysis + security scan** — linters, type checkers, dependency CVE scan, secrets scan, SAST.
5. **Build container image + SBOM** — produce the artifact that will actually ship, with a software bill of materials generated alongside it.
6. **Sign the artifact** — cosign / SLSA provenance so later stages can verify the binary came from this pipeline.
7. **Deploy to staging** — production-like, long-lived, shared. The smoke-test harness lives here.
8. **E2E smoke tests** — the small handful of tests that exercise the critical user journeys end-to-end. Slow tests go here, not in step 2.
9. **Deploy to production (canary)** — route 1–5% of traffic to the new version.
10. **Monitor canary** — automated evaluation of error rate, latency, custom SLIs, business metrics. This is a hard gate, not a human glance.
11. **Promote to 100% or rollback** — automatic, based on the canary signal.

The ordering matters: fast checks first, expensive checks later, user-facing effects last. A failure in step 2 should abort in minutes, not after consuming an hour of slow pipeline time.

### Pipeline-as-code

The pipeline definition lives in your repository, in YAML, versioned alongside the code it ships. GitHub Actions workflows live in `.github/workflows`; GitLab pipelines in `.gitlab-ci.yml`; Jenkins in a `Jenkinsfile`. This is non-negotiable. A pipeline configured through a GUI is not reviewable, auditable, or portable.

Here is a minimal but realistic GitHub Actions pipeline that covers the stages above:

```yaml
# .github/workflows/deploy.yml
name: Build, Test, Deploy

on:
  push:
    branches: [main]
  pull_request:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: script/bootstrap
      - run: script/test        # unit + integration
      - run: script/lint
      - run: script/security-scan

  build-image:
    needs: build-and-test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write         # OIDC for cosign
    outputs:
      digest: ${{ steps.push.outputs.digest }}
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - id: push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          provenance: true    # SLSA build provenance
          sbom: true          # SBOM attestation
      - uses: sigstore/cosign-installer@v3
      - run: cosign sign --yes ghcr.io/${{ github.repository }}@${{ steps.push.outputs.digest }}

  deploy-staging:
    needs: build-image
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - run: script/deploy staging ${{ needs.build-image.outputs.digest }}
      - run: script/smoke-test staging

  deploy-prod-canary:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - run: script/deploy prod canary ${{ needs.build-image.outputs.digest }}
      - run: script/monitor-canary --duration 10m --abort-on-regression

  deploy-prod-full:
    needs: deploy-prod-canary
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: script/promote prod ${{ needs.build-image.outputs.digest }}
```

Notice: the pipeline calls `script/...` entry points rather than embedding logic inline — the "scripts to rule them all" pattern, so the same commands work locally, in CI, and in containers. The `concurrency` block prevents simultaneous deploys from racing. `environment: production` is a GitHub Actions protection gate where you can require approvals, restrict to branches, and scope secrets. GitLab CI expresses the same shape with `stages:` and `rules:`; Jenkins with declarative `pipeline { stages { ... } }`.

---

## Deployment strategies

### Your default: rolling + canary + feature flags

For most changes, the right combination is:

- **Rolling deployment** as the baseline. Kubernetes' `Deployment` resource is the canonical reference: "You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate." Two knobs matter: `maxSurge` (how many extra pods you can create during rollout) and `maxUnavailable` (how many existing pods can be gone during rollout). Rolling is the cheapest strategy — one fleet, no doubled capacity — and it is the right default.
- **Canary** for anything with user impact. Route 1–5% of traffic to the new version first, watch the SLIs, and only then ramp up. Sato's definition: "Canary release is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure." Sato distinguishes this from A/B testing: canary is about *detecting regressions* on a timescale of "minutes/hours versus days"; A/B testing is about *validating hypotheses*.
- **Feature flags** to decouple deployment from release. The code is deployed (running in production) but the feature is not released (not yet reachable by users, or only by some). See the next section.

### Alternatives and when to use them

- **Blue-green** — maintain two complete production environments; one serves traffic, the other is warm. Deploy to the idle one, smoke-test, switch the router. Fowler's main property: "if anything goes wrong you switch the router back to your blue environment." Use when you need instant rollback and can afford double capacity — stateful services, critical APIs, fleets that cannot tolerate mixed-version traffic. Downside: cost, since you run two of everything during cutover.
- **Shadow / mirror** — route a copy of live traffic to the new version while continuing to serve users from the old one. The new version's responses are discarded or logged. Use for *replacing a subsystem*: a rewrite of a critical service, a new search implementation, a new billing calculator. Run for days or weeks until responses match.
- **Dark launch** — run the new backend behaviour in production but do not render the result to users. Fowler: "Dark launching a feature means taking a new or changed back-end behavior and calling it from existing users without the users being able to tell it's being called." The canonical example is Facebook Chat in 2008 (Letuchy, Engineering at Meta), where "Facebook pages would make connections to the chat servers, query for presence information and simulate message sends" with no UI — letting the infrastructure warm up at 70 million users' scale before flipping the UI on. Use for production-scale load or realism validation.

### Rollback strategy

Every deploy must have a rollback mechanism — documented, tested, and fast.

Each strategy supplies its own rollback primitive: blue-green flips the router; canary halts promotion and routes traffic back to the old version; Kubernetes `kubectl rollout undo` to the previous Deployment revision; feature flag flips the kill switch off, no redeploy needed.

Rules:

- **Rollback is automated on SLI regression.** Error rate, latency p99, or a change-specific SLI crossing threshold triggers an automatic halt and revert. Do not require a human to decide during an incident.
- **Rollback is tested.** Run a drill at least once a quarter. If you have never rolled back, you do not have rollback.
- **Prefer forward-fix for small issues but always have rollback ready.** A one-line copy typo is faster to forward-fix. A memory leak, data corruption, or security regression — roll back first, investigate second.
- **The database is always the constraint.** Rolling the app back while leaving a migrated schema in place can corrupt data. Expand/contract (below) is a *precondition* for safe rollback, not a nice-to-have.

---

## Feature flags

### What they are and why

Hodgson: "Feature Toggles (often also referred to as Feature Flags) are a powerful technique, allowing teams to modify system behavior without changing code."

The value is the decoupling, not the flag. Without flags, deploy = release: the moment code runs, it is reachable. With flags, deploy and release are separate events. Deploy Monday, turn on for internal users Tuesday, 10% Wednesday, 100% Friday, remove the flag next week. Each step is reversible in seconds.

### Categories (Pete Hodgson taxonomy)

Hodgson identifies four categories of flag, each with distinct dynamism and lifetime:

| Category | Purpose | Lifetime | Dynamism |
|---|---|---|---|
| **Release toggles** | Let incomplete code ship as dormant functionality; support trunk-based development. | Short-lived | Low |
| **Experiment toggles** | Place users into A/B or multivariate test cohorts. | Short-lived (experiment duration) | Per-request |
| **Ops toggles** | Control operational aspects; allow graceful degradation; kill switches. | Varies; some permanent | Varies |
| **Permissioning toggles** | Restrict features to user groups (premium, beta, internal). | Can be "very-long lived compared to other categories." | Per-request |

Different categories have different owners and different cleanup rules. Release toggles belong to the engineer shipping the feature and must be removed after rollout. Ops toggles belong to the SRE / on-call team and may live forever. Permissioning toggles belong to product and may live as long as the tier system exists. Do not treat all flags the same.

### Recommended setup

- **Use a managed service**, not a home-grown flag file. LaunchDarkly, Unleash, PostHog, ConfigCat, Flagsmith, Statsig — pick one. Flag evaluation must be fast, reliable, observable, and the targeting matrix (user ID, cohort, geography, plan, random percentage) is unpleasant to reimplement. Home-grown flags usually end up in a Redis key with no audit log or rollout controls.
- **Naming convention.** Prefix by category: `release_`, `ops_`, `experiment_`, `perm_`. Include owner and target removal date in the description.
- **Kill switches for critical features.** Anything that can fail expensively (payment retries, email, webhook delivery, third-party APIs) needs an ops toggle so you can disable without a deploy when the provider degrades.
- **Clean up release flags within 2–4 weeks of full rollout.** Hodgson's warning: teams should "view their Feature Toggles as inventory which comes with a carrying cost, and work to keep that inventory as low as possible." Flag debt is real. Schedule removal on the same PR template as the rollout plan.

### Progressive delivery

Progressive delivery is the default for any user-visible change. The term is associated with James Governor of RedMonk (co-defined with Adam Zimman of LaunchDarkly in mid-2018); it combines continuous delivery with per-cohort control. Where continuous delivery asks "can we ship safely?", progressive delivery asks "who sees it and when?"

The concrete rollout ladder:

1. **Behind flag for internal users only.** Merged, deployed, off for everyone except internal accounts. The "does it work at all in production" check.
2. **1% beta users.** Self-selected or random sample. Watch error rate, latency, conversion for this cohort specifically. Hours, not days.
3. **10%.** Broader signal.
4. **50%.** Past the risk window for most regressions.
5. **100%.** Watch for a day.
6. **Remove the flag.** New PR, remove the code path and the flag from the service. Mandatory.

The ladder expands or contracts with risk. A typo fix may go straight to 100%. A new payments flow may spend two weeks at 1%. Shape is the same; timescale varies.

---

## Release management

### Versioning

Pick the right versioning scheme for what you are shipping.

- **SemVer for public APIs and libraries.** Semantic Versioning 2.0.0 (Preston-Werner): `MAJOR.MINOR.PATCH`, where "Patch version Z MUST be incremented if only backward compatible bug fixes are introduced"; "Minor version Y MUST be incremented if new, backward compatible functionality is introduced"; "Major version X MUST be incremented if any backward incompatible changes are introduced." The version number is a *contract* with consumers. If you are not ready to commit to a stable API, stay on `0.y.z`; once you are, move to `1.0.0`.
- **Calendar versioning (2026.4.1) or continuous for internal services.** Services nobody else imports do not need the SemVer contract; date-based or build-number versions are cleaner.
- **Do NOT use SemVer for SaaS products.** A SaaS product does not expose a version to users — there is one live version. "Version 2.3.0 of our web app" is meaningless to the customer. Use a commit hash, build ID, or date for internal tracking.

### Release notes and changelogs

Two audiences, two artifacts:

- **`CHANGELOG.md` for libraries.** Follow Keep a Changelog 1.1.0 (Lacan). Principle 1: "Changelogs are for humans, not machines." Principle 2: "There should be an entry for every single version." Categories: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Latest version first, with release date. A changelog is not `git log`; Lacan contrasts it with commit logs which are "full of noise."
- **Customer-visible release notes for products.** In-product changelog page, drip email, modal, or announcement — pick one and be consistent. Plain user language, not engineering language.

Automate. Conventional Commits (`feat:`, `fix:`, `chore:`) feed tools like release-please, changesets, or semantic-release to generate the `CHANGELOG.md` and version bump. The mapping follows SemVer and Keep a Changelog: `Fixed` → PATCH, `Added` or backward-compatible `Changed` → MINOR, incompatible `Changed` / `Removed` → MAJOR.

### Release cadence

Humble's baseline: deployment should be "predictable, routine affairs that can be performed on demand." The research describes three cadence patterns — continuous (every commit), on-demand (button-press when ready), and time-based (weekly train). Only the first two are endorsed by primary sources.

**Prescription:**

- Every merge to main → production within 30 minutes for most services.
- Avoid time-based release windows. "Tuesday 2 p.m. releases" is an anti-pattern for modern SaaS — it batches risk, inflates the change size per deploy, creates a human ritual.
- Exception: customer-facing version upgrades with retraining cost (desktop clients with major UI changes, installed enterprise software, mobile apps subject to store review). Web services have no such reason to batch.

The important property is not "how often we deploy" but "how small the change is per deploy." Small changes are what makes the frequency safe.

---

## Database migrations — the hardest part

The pipeline above handles code. The database is where most deploys actually break. Schema changes are not reversible the way code is; a dropped column cannot be un-dropped by flipping a router.

### Expand/contract pattern

Sato's canonical 2014 "Parallel Change" article: "'parallel change,' also known as 'expand and contract,' is a pattern for safely implementing backward-incompatible interface changes through three distinct phases: expand, migrate, and contract." Sato: "This approach is particularly useful when practicing Continuous Delivery because it allows your code to be released in any of these three phases."

Worked example — renaming `customer_name` to `full_name`:

1. **Expand.** Add `full_name`. Deploy code that dual-writes to both columns; reads still from `customer_name`.
2. **Backfill.** Migration copies `customer_name` → `full_name` for existing rows, as a separate batch job.
3. **Contract — part 1.** Deploy code that reads from `full_name`; writes still go to both (defensive).
4. **Contract — part 2.** Deploy code that reads and writes only `full_name`.
5. **Drop.** Separate later deploy drops `customer_name`.

Five deploys, each individually reversible. This is the cost of safety: a destructive schema change atomic with a code deploy *cannot* be rolled back safely. Expand/contract keeps rollback as an option.

Branch by abstraction (Fowler 2014) is the same pattern for code structure: abstraction layer, migrate clients, build new implementation behind the abstraction, swap, remove the old supplier. Use it for cross-cutting changes too big for one PR.

### Online schema change tools

For databases large enough that `ALTER TABLE` locks matter:

- **pt-online-schema-change** (Percona Toolkit, MySQL). "Creates an empty copy of the table to alter, modifying it as desired, and then copying rows from the original table into the new table." Captures concurrent writes via MySQL triggers, then performs an atomic `RENAME TABLE`.
- **gh-ost** (GitHub, MySQL). Triggerless: "gh-ost uses the binary log stream to capture table changes, and asynchronously applies them onto the ghost table." Triggers run inside the write transaction and complicate replication; binlog capture is asynchronous and pausable. gh-ost gives "greater control over the migration process; can truly suspend it."
- **pg_repack** (Postgres), plus `CREATE INDEX CONCURRENTLY` for most schema operations.

Either is substantially safer than a lock-blocking `ALTER TABLE`.

### What to never do

- Rename a column in one step. Use expand/contract.
- Drop a column still referenced by running code (including canary, including the rollback target).
- Take long-running locks in production.
- Make destructive migrations reversible only by restoring from backup. A 4 a.m. restore is not a rollback plan; it's a disaster recovery plan.

Sadalage and Fowler's Evolutionary Database Design: "one full-time DBA plus part-time developer support sufficed for teams of 100+ people, demonstrating that 'automation' is the true enabler." Treat database changes like code: versioned migrations, CI validation, expand/contract by default.

---

## Environment strategy

Four environment classes:

- **Dev.** Local, per-developer. Stubbed external dependencies, synthetic data, fast restart. Goal: tight inner-loop feedback.
- **Preview / ephemeral.** One per PR, spun up automatically when the PR opens, torn down when it merges or closes. GitLab calls these "review apps": "temporary testing environments that are created automatically for each branch or merge request" that "preview and validate changes without needing to set up a local development environment." Vercel / Netlify / Render / Railway do this natively. The effect: code review includes clicking through the running change, not just reading the diff; no long-lived "staging queue" for branches to collide in.
- **Staging.** Production-like, long-lived, shared. One per service. Last integration check before production; where your smoke-test suite lives. Not a playground for half-finished features — those belong on preview environments.
- **Production.** What customers use.

**Data:** synthetic in all non-production environments. Real customer data belongs only in production. Preview environments with a copy of the production database is a security incident waiting to happen. Build a synthetic-data generator early.

Fowler's CI practices include "Test in production-environment clones." The principle — environments of increasing fidelity — is primary-sourced; the exact tier names are conventional. Adjust to fit, but keep the sequencing: cheap environments catch issues before you commit expensive resources.

---

## Artifact management and supply chain

The artifacts flowing through your pipeline need to be traceable, signed, and inventoried.

- **Registry.** Store container images in a registry: GitHub Container Registry, AWS ECR, Google Artifact Registry, Azure Container Registry, or self-hosted Harbor / JFrog Artifactory. Language packages (npm, PyPI, Maven) go in equivalent registries.
- **Sign images.** Use cosign (sigstore) with short-lived OIDC-bound keys. Signature verification becomes a deploy-time gate: only images signed by the pipeline's OIDC identity are deployable.
- **SBOM at build time.** Per NTIA, a Software Bill of Materials is "a nested inventory for software, a list of ingredients that make up software components." Generate an SBOM for every image and attach it as an attestation. Tools: syft, docker buildx's `--sbom` flag, cyclonedx-cli.
- **Dependency provenance tracked.** Lockfiles pinned in version control; updates gated by Dependabot / Renovate with CI.
- **SLSA compliance.** SLSA (Supply-chain Levels for Software Artifacts, pronounced "salsa") is "a security framework, a checklist of standards and controls to prevent tampering, improve integrity, and secure packages and infrastructure." Build-track levels:
    - **L1 — Provenance exists.** "Package has provenance showing how it was built. Can be used to prevent mistakes but is trivial to bypass or forge."
    - **L2 — Hosted build platform.** "Build platform runs on dedicated infrastructure, not an individual's workstation, and the provenance is tied to that infrastructure through a digital signature." Prevents tampering after the build.
    - **L3 — Hardened builds.** Platform "prevent[s] runs from influencing one another, even within the same project" and keeps signing keys inaccessible to user-defined build steps.

**Prescription:** Target SLSA Level 2 for small teams. GitHub Actions with `provenance: true` / `sbom: true` on `docker/build-push-action` plus cosign signing gets you there. Target Level 3 for regulated industries, high-stakes infrastructure, or when customers ask — L3 requires hardened runners and isolated builds.

SBOM answers *what is in my artifact*; SLSA answers *how was my artifact built, and can I trust the build*.

---

## DORA: measure how well you ship

The DORA metrics are the canonical way to measure delivery performance. They are outcome metrics — the machinery in this chapter exists to move them in the right direction.

### The four key metrics

From the Google Cloud "Use Four Keys metrics" article:

1. **Deployment Frequency** — "How often an organization successfully releases to production."
2. **Lead Time for Changes** — "The amount of time it takes a commit to get into production."
3. **Change Failure Rate** — "The percentage of deployments causing a failure in production."
4. **Time to Restore Service** — "How long it takes an organization to recover from a failure in production." (Renamed by dora.dev to **Failed Deployment Recovery Time**: "The time it takes to recover from a deployment that fails and requires immediate intervention.")

"Deployment Frequency and Lead Time for Changes measure velocity, while Change Failure Rate and Time to Restore Service measure stability." The two-axis split is deliberate: you should not buy velocity with stability or vice versa.

### 2024 tier thresholds (verbatim)

The 2024 Accelerate State of DevOps Report gives these thresholds on the original four metrics (p. 13):

| Performance level | Change lead time | Deployment frequency | Change fail rate | Failed deployment recovery time | % respondents |
|---|---|---|---|---|---|
| **Elite** | Less than one day | On demand (multiple deploys per day) | 5% | Less than one hour | 19% (18–20%) |
| **High** | Between one day and one week | Between once per day and once per week | 20% | Less than one day | 22% (21–23%) |
| **Medium** | Between one week and one month | Between once per week and once per month | 10% | Less than one day | 35% (33–36%) |
| **Low** | Between one month and six months | Between once per month and once every six months | 40% | Between one week and one month | 25% (23–26%) |

The 2024 finding on the medium tier: "the medium performance cluster, for example, may benefit from shipping changes more frequently" — medium has *lower* change failure rate than high, meaning the tiers do not collapse along a single quality axis.

The tier model is not stable year-on-year: the 2022 report detected only three clusters (High, Medium, Low); the 2023 report announced the return of Elite. Pick a definition and stick with it for trend comparability.

### The fifth metric

The 2024 Accelerate State of DevOps Report introduces a fifth metric, **rework rate**. Verbatim: "We have a longstanding hypothesis that the change failure rate metric works as a proxy for the amount of rework a team is asked to do." The report added a new survey question: "For the primary application or service you work on, approximately how many deployments in the last six months were not planned but were performed to address a user-facing bug in the application?" Analysis confirmed: "rework rate and change failure rate are related. Together, these two metrics create a reliable factor of software delivery stability."

The 2024 model therefore:
- **Throughput** = change lead time + deployment frequency + failed deployment recovery time
- **Stability** = change failure rate + rework rate

### Measure these from day one

You do not need a DORA dashboard SaaS product. Use existing systems:

- **Deployment frequency** = count of production deploys from CI / deploy webhooks.
- **Lead time** = median(deploy timestamp − first commit timestamp) per merged PR, from Git.
- **Change failure rate** = (deploys triggering a rollback, hotfix, or incident) / total deploys.
- **Failed deployment recovery time** = median time from incident opened to resolved for deploy-caused incidents.

A spreadsheet or SQL query against your GitHub / CI / PagerDuty exports is enough to start.

---

## Anti-patterns

- **Release day / release captain / release window.** Symptoms of batching risk. Cure: deploy more often.
- **Manual deployment steps.** "Run this migration, then this command, then restart these services" is a landmine, not a deployment. Anything done more than once belongs in the pipeline.
- **Deploying on Friday as fear-based practice.** If you're scared of Friday, your pipeline is broken — fix it, don't schedule around it. "No Friday deploys" institutionalises low confidence in your own system.
- **"Big bang" releases.** Multi-week branches merged in one push. Maximum change size, minimum feedback — exactly backwards.
- **Deployment locked to a single person.** Bus factor of 1 on the most critical engineering capability.
- **Hotfix process that skips CI.** The fastest way to cause your second incident.
- **No rollback plan.** "We'll roll forward if there's a problem" is hope, not a plan.
- **Feature branches that live weeks before merge.** You are not doing CI in Fowler's sense regardless of CI server.
- **Long-lived feature flags.** Hodgson's inventory warning: flag debt compounds. A flag at 100% for three months is debt, not infrastructure.

---

## Scale notes

- **Solo / 1 engineer.** GitHub Actions + push-button deploy. Feature flags can be env vars or a row in the database. Canary = "deploy to staging, wait an hour, deploy to prod." Goal: get the *shape* right so you can add mechanisms later without rewiring.
- **Team of 5.** Full pipeline as in the example, automated canary to staging, manual promote to prod for a few months. Pick a managed feature-flag provider. Track the four keys in a spreadsheet.
- **Team of 50.** Automated canary to production with automated abort. Progressive delivery default for user-facing changes. Managed feature-flag platform mandatory. DORA metrics on a dashboard.
- **Team of 500.** Internal developer platform owned by a platform team: per-team pipelines with shared templates, deployment SLOs, self-service canary and rollback. SLSA L3, SBOM, signed artifacts. Dedicated release engineering, but their job is making other teams' deploys safer, not pressing buttons.

---

## Exit checklist (per release)

Before you close the loop on a deploy:

- [ ] CI green — all tests passing, all scans clean
- [ ] Canary deployed and healthy for the configured duration
- [ ] Metrics unchanged or improved — error rate, latency p99, business SLIs
- [ ] Feature flag gated if user-facing
- [ ] Rollback plan documented (which mechanism, who triggers it, under what conditions)
- [ ] On-call aware — see Phase 07

Before you close the loop on a *feature* (not just a deploy):

- [ ] Flag ramped through 1% → 10% → 50% → 100%
- [ ] Flag removed from code within 2–4 weeks of 100%
- [ ] Any database expand/contract migration completed (all four phases, including the drop)
- [ ] Release notes published if customer-visible

---

## Why this works

Each recommendation maps back to research:

- **Pipeline shape, stage ordering, fast-feedback principle** — Fowler's Deployment Pipeline (2013) and the GitHub Actions / GitLab CI / Jenkins docs, summarised in [`research/06-release/cicd.md`](../research/06-release/cicd.md).
- **CI as a daily-merge behaviour, eleven practices** — Fowler's Continuous Integration (2024 rev.), in [`research/06-release/cicd.md`](../research/06-release/cicd.md).
- **Continuous Delivery vs. Continuous Deployment distinction** — continuousdelivery.com (Humble) and the Wikipedia article, in [`research/06-release/cicd.md`](../research/06-release/cicd.md).
- **Rolling, blue-green, canary, dark launch** — Kubernetes Deployments docs, Fowler's Blue-Green Deployment (2010), Sato's Canary Release (2014), Fowler's Dark Launching (2020), and Letuchy's 2008 Facebook Chat origin, in [`research/06-release/deployment-strategies.md`](../research/06-release/deployment-strategies.md).
- **Feature flag categories and inventory warning** — Hodgson's Feature Toggles (2017), in [`research/06-release/feature-flags.md`](../research/06-release/feature-flags.md).
- **Progressive delivery** — Governor's RedMonk coinage (2018) and IT Revolution Four A's framework, in [`research/06-release/feature-flags.md`](../research/06-release/feature-flags.md).
- **SemVer and Keep a Changelog** — semver.org and keepachangelog.com, in [`research/06-release/feature-flags.md`](../research/06-release/feature-flags.md).
- **Expand/contract for database changes** — Sato's Parallel Change (2014), Sadalage & Fowler's Evolutionary Database Design, pt-osc / gh-ost docs, in [`research/06-release/dora-metrics.md`](../research/06-release/dora-metrics.md).
- **DORA four keys, 2024 thresholds, fifth metric (rework rate)** — Google Cloud Four Keys blog, dora.dev, and the 2024 Accelerate State of DevOps Report (pp. 10–14), in [`research/06-release/dora-metrics.md`](../research/06-release/dora-metrics.md).
- **SLSA build levels and SBOM** — slsa.dev and NTIA's SBOM page, in [`research/06-release/dora-metrics.md`](../research/06-release/dora-metrics.md).

The unifying idea: the industry has spent twenty-five years progressively decoupling **merge**, **deploy**, **release**, and **expose**, so that a production problem no longer requires a redeploy to fix. A flag flip, a router change, or a canary halt is enough. That decoupling is what makes the DORA elite tier possible — and what lets a team of any size ship many times a day without a release captain, a release window, or a release-day ritual.
