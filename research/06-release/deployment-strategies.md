# Deployment Strategies and Environments

**Question:** How are changes rolled out to production, and what environments precede production?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Blue-green deployment

### Definition

`[VERIFIED]` From Fowler's 2010 bliki entry:

> "At any time one of them, let's say blue for the example, is live. As you prepare a new release of your software you do your final stage of testing in the green environment."

Once the new version is ready, traffic switches from blue to green via router reconfiguration, leaving blue idle and available as an immediate rollback target ([Blue-Green Deployment — Martin Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html) (accessed 2026-04-24)).

### Properties per Fowler

`[VERIFIED]` Fowler's article calls out four properties:
1. **Rapid rollback.** "if anything goes wrong you switch the router back to your blue environment."
2. **Minimised downtime** during the cut-over phase.
3. **Disaster-recovery testing for free.** "It's the same basic mechanism as you need to get a hot-standby working. Hence this allows you to test your disaster-recovery procedure on every release."
4. **Role cycling.** Both environments regularly alternate between live, backup, and staging roles.

### Database constraint

`[VERIFIED]` Schema changes must be separated from application upgrades. Fowler's article states you should "apply database refactoring first to support both old and new versions, then deploy the application update" ([Blue-Green Deployment — Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html)). This is the expand/contract pattern in practice (see `dora-metrics.md` for the database-migration detail).

---

## 2. Canary release

### Definition

`[VERIFIED]` Danilo Sato's canonical entry:

> "Canary release is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure."

([Canary Release — Danilo Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24)).

### Mechanics

`[VERIFIED]` Sato describes three stages (verbatim intent; paraphrased):
1. **Initial deployment** to a portion of infrastructure with no user traffic.
2. **Gradual user migration** via selection strategies (random sample, internal staff first, demographic or geographic cohorts).
3. **Full rollout** across more servers and users while monitoring metrics.

### Canary vs. A/B test

`[VERIFIED]` Sato explicitly separates the two: canary releases "detect regressions" while A/B testing "validates hypotheses," and they operate on different timescales — "minutes/hours versus days" ([Canary Release — Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)).

### Database constraint

`[VERIFIED]` "Database changes need parallel support for both versions" during canary — same constraint as blue-green ([Canary Release — Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)).

---

## 3. Rolling deployment

### Definition

`[VERIFIED]` Kubernetes' `Deployment` resource is the widely used reference implementation of rolling deployment:

> "A _Deployment_ provides declarative updates for Pods and ReplicaSets. You describe a _desired state_ in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate."

([Kubernetes Deployments — kubernetes.io](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (accessed 2026-04-24)).

The rolling strategy exposes two knobs:
- `maxSurge` — maximum number of pods that can be created over the desired count during the rollout.
- `maxUnavailable` — maximum number of pods that can be unavailable during the rollout.

An alternative is `Recreate` (terminate all old pods, then start new ones; causes downtime). ([Kubernetes Deployments — kubernetes.io](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (accessed 2026-04-24)).

### Rolling vs. blue-green

`[SYNTHESIS]` Rolling keeps a single fleet and replaces instances incrementally; blue-green keeps two fleets and swaps traffic. Rolling uses less capacity (no doubled cluster); blue-green gives a cleaner rollback. Both were documented in Fowler's 2010 article and in the Kubernetes docs fetched above — the two practices coexist rather than one replacing the other.

---

## 4. Shadow deployment / dark launch

### Dark launching per Fowler

`[VERIFIED]` Fowler's 2020 bliki entry:

> "Dark launching a feature means taking a new or changed back-end behavior and calling it from existing users without the users being able to tell it's being called."

The article gives an e-commerce example where a cross-selling recommendation engine runs in production without displaying results to users, allowing performance evaluation before public release ([Dark Launching — Martin Fowler, 2020](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24)).

### Distinction from canary

`[VERIFIED]` Fowler's article distinguishes dark launching from canary releases. The implementation typically uses feature flags ([Dark Launching — Fowler, 2020](https://martinfowler.com/bliki/DarkLaunching.html)).

### Shadow deployment

`[SYNTHESIS]` Shadow deployment (also called "traffic shadowing" or "mirroring") routes a copy of live production traffic to the new version while returning the old version's response to the user — used for load and correctness testing. This concept is adjacent to dark launch but not identical: in dark launch the backend is *called* from the existing flow but not rendered; in shadow, traffic is *mirrored* to a parallel stack. `[UNVERIFIED]` as a distinct primary source — Fowler's article merges the concepts under dark launching, and a dedicated Fowler/primary-source entry for "shadow deployment" as a separate term was not found in this session.

### Origin attribution

`[VERIFIED]` The term "dark launch" is introduced in the Facebook Engineering blog post on Facebook Chat, dated May 13, 2008, by Eugene Letuchy:

> "dark launch" period in which Facebook pages would make connections to the chat servers, query for presence information and simulate message sends [without a single UI element drawn on the page]

([Facebook Chat — Engineering at Meta, 2008](https://engineering.fb.com/2008/05/13/web/facebook-chat/) (accessed 2026-04-24)). The strategy: avoid deploying to 70 million users all at once; instead, have live traffic exercise the backend invisibly, debug at scale, then activate the UI.

`[CORRECTION]` The commonly repeated attribution of "dark launch" origin to Flickr's 2009 "Flipping Out" post is not supported. A direct fetch of [Flipping Out — Ross Harmes, code.flickr.net, 2 Dec 2009](https://code.flickr.net/2009/12/02/flipping-out/) (accessed 2026-04-24) confirms the post introduces "flags" and "flippers" (feature flags / per-user toggles) but does **not** use the phrase "dark launch." So Flickr is the canonical early example of **feature flags in continuous deployment**, not of dark launch. The Facebook Chat 2008 post is the primary origin for the "dark launch" term.

---

## 5. Feature flags as a deployment strategy

See `feature-flags.md` for the full treatment. In short, feature flags decouple **deployment** (code is running) from **release** (feature is reachable) and from **exposure** (specific users see it). Pete Hodgson's canonical taxonomy names release toggles, experiment toggles, ops toggles, and permissioning toggles ([Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24)).

---

## 6. Environment strategy

### Dev / staging / production

`[SYNTHESIS]` No single primary source fetched in this session defines "dev/staging/prod" as a three-tier standard. What the fetched sources *do* document is:

- Fowler's CI practices include "Test in production-environment clones" ([Continuous Integration — Fowler, 2024](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)).
- Deployment pipelines progress through stages that end in production ([Deployment Pipeline — Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)).

So the *principle* (multiple environments of increasing fidelity) is primary-sourced; the *three specific labels* are conventional rather than standardised.

### Ephemeral / preview / review environments

`[VERIFIED]` GitLab documents "review apps" as the canonical implementation of per-branch preview environments:

> "Review apps are temporary testing environments that are created automatically for each branch or merge request."

They "preview and validate changes without needing to set up a local development environment." Review apps can be configured to stop automatically when the associated merge request is merged, when the branch is deleted, or after a specified period of inactivity ([Review Apps — GitLab Docs](https://docs.gitlab.com/ee/ci/review_apps/) (accessed 2026-04-24)).

`[SYNTHESIS]` The practical effect is that code review can include *clicking through the running change*, not just reading the diff — and that there is no long-lived "staging queue" for multiple feature branches to collide in. This addresses the staging-bottleneck failure mode directly.

---

## 7. Rollback strategies — forward-fix vs. rollback

`[SYNTHESIS]` The fetched primary sources describe the **mechanisms** but do not give a prescriptive answer on "rollback vs. roll-forward." The mechanisms are:

- **Blue-green rollback:** flip the router back to the previous environment ([Blue-Green Deployment — Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html)).
- **Canary rollback:** stop promoting the new version and route all traffic back to the old ([Canary Release — Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)).
- **Kubernetes rollback:** `Deployment` keeps revision history; "Rolling back to earlier Deployment revisions" is a documented use case ([Kubernetes Deployments — kubernetes.io](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (accessed 2026-04-24)).
- **Feature flag kill switch:** flip the flag off without redeploying ([Feature Toggles — Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html); specifically the "ops toggles" category).

`[SYNTHESIS]` The database is always the constraining factor. All three mechanisms above break if the schema change is not backward-compatible, because rolling the app back while leaving the migrated schema in place can corrupt data. The expand/contract pattern (`dora-metrics.md`) exists precisely so that rollback remains safe. Forward-fix is often *preferred over rollback for database-coupled changes* — not because rollback is inferior, but because it may be impossible after a destructive migration. This is a `[SYNTHESIS]` drawing on Fowler's blue-green article's explicit database note and Sato's canary article's parallel-support note.

---

## Open questions

- **Shadow vs. dark launch.** The definitional boundary (traffic mirroring vs. backend-call-without-render) is treated as a single concept in the Fowler bliki entry but split in operational practice. Flagged as `[UNVERIFIED]` as a distinct concept.
- **Standardisation of environment tiers.** Whether ISO/IEEE/IIBA or a named body has defined "dev/staging/prod" as standard terminology is not known from the sources fetched; the tiers are documented in vendor docs and practitioner writing only.
- **Progressive delivery's canary-flag combination.** See `feature-flags.md` for the progressive delivery synthesis.

## Sources

- [Blue-Green Deployment — Martin Fowler, 2010](https://martinfowler.com/bliki/BlueGreenDeployment.html) (accessed 2026-04-24)
- [Canary Release — Danilo Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24)
- [Dark Launching — Martin Fowler, 2020](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24)
- [Facebook Chat — Eugene Letuchy, Engineering at Meta, 13 May 2008](https://engineering.fb.com/2008/05/13/web/facebook-chat/) (accessed 2026-04-24)
- [Flipping Out — Ross Harmes, code.flickr.net, 2 Dec 2009](https://code.flickr.net/2009/12/02/flipping-out/) (accessed 2026-04-24)
- [Kubernetes Deployments — kubernetes.io](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (accessed 2026-04-24)
- [Review Apps — GitLab Docs](https://docs.gitlab.com/ee/ci/review_apps/) (accessed 2026-04-24)
- [Continuous Integration — Martin Fowler, 2024 rev.](https://martinfowler.com/articles/continuousIntegration.html) (accessed 2026-04-24)
- [Deployment Pipeline — Martin Fowler, 2013](https://martinfowler.com/bliki/DeploymentPipeline.html) (accessed 2026-04-24)
- [Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24)
