# CONTINUOUS_DELIVERY.md — Every commit on main is releasable

**Authoritative source:** [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3; [`../../handbook/06-ship.md`](../../handbook/06-ship.md).

## The premise

Continuous Delivery (Humble & Farley): software is **always in a releasable state**. Releases are a business decision, not an engineering project.

This is distinct from Continuous Deployment (every commit auto-promotes to prod). CD-the-discipline is required; auto-promotion to prod is a per-service decision.

## Hard rules

1. **Every commit to main produces a deployable artifact.** Build → test → package → publish runs on every push.
2. **Build once; promote the same artifact through environments.** No rebuilding per environment. Same image SHA in dev → preprod → prod.
3. **Main auto-deploys to dev.** No human in the loop between merge-to-main and dev.
4. **Higher environments behind a manual gate.** Preprod and prod require a deliberate trigger (button, approval, or scheduled window). Per [`../../NOTES.md`](../../NOTES.md).
5. **Rollback path verified per release.** A release is not "shipped" until rollback has been demonstrated to work in this pipeline.
6. **Rollback < 5 minutes.** From decision to restored state. If rollback takes longer, fix the rollback path before shipping more.
7. **Database migrations are expand/contract.** Code and schema decouple. Old code must run against new schema; new code must run against old schema during rollout.
8. **A prod-deployability gate runs on every commit to main, and a red gate is stop-the-line.** "Always releasable" is a claim; this is the test that proves it. See the section below.
9. **Every feature is behind a flag defaulting to off**, so what main deploys is always the current prod behavior plus inert code. Policy §3.4; full mandate in [`../frameworks/FEATURE_FLAGS.md`](../frameworks/FEATURE_FLAGS.md) §"Baseline mandate".

## The deployment pipeline (canonical order)

```
commit → build → unit test → static analysis →
package (image build, signed) → SBOM →
deploy to dev (auto) → smoke test in dev →
manual gate → deploy to preprod → integration + perf →
manual gate → deploy to prod (canary) → soak → full rollout
```

Each stage gates the next. A red stage blocks promotion. No path to prod that skips earlier stages.

## The prod-deployability gate

Rule 1 says main produces a deployable artifact. Rule 8 is how you know. The gate is a **named, required job that runs post-merge on `main`** and fails when the commit could not go to production as it stands. Five assertions, all automated (policy §3.5):

| # | Assertion | Fails when |
|---|---|---|
| 1 | **Artifact identity** - the release artifact builds and is byte-identical to what prod would run (same digest, no per-environment rebuild). | Build breaks, or the prod path rebuilds rather than promotes. |
| 2 | **Prod config dry-run** - task definition / manifest renders against **prod** config; `terraform plan` on the prod workspace succeeds; every config value and secret reference resolves. | A new env var, SSM parameter, secret, or IAM permission exists in dev but was never added to prod. |
| 3 | **Flags-off smoke test** - the artifact passes smoke tests in a prod-equivalent environment with **every new flag off**, which is the exact state a prod deploy lands in per hard rule 9. | The code only works with the new flag on, i.e. the off path was never exercised. |
| 4 | **Migration compatibility** - schema changes apply forward against a prod-shaped schema, and the **previous** code revision still runs against the migrated schema. | Expand/contract was skipped; the migration and the code must ship together. |
| 5 | **Rollback rehearsal** - the previous artifact can be redeployed and passes the same smoke test. | Rollback is theoretical. Rule 5 says a release is not shipped until rollback is demonstrated; this demonstrates it per commit rather than per release. |

Rules for the gate itself:

- **Required, never advisory.** No `allow_failure: true`, no `continue-on-error`, no manual skip, no "the gate is flaky so we muted it" (fix the flake; a muted gate is an unproven trunk).
- **Stop-the-line on red.** Same handling as a broken build (policy §2.3): merges pause, fixing it is the team's top priority. A revert is a legitimate fix.
- **Runs post-merge on main**, and on the MR pipeline where the change touches deploy config, migrations, or flags. Post-merge is the binding run: pre-merge runs are pre-integration checks, not CI (policy §2.1).
- **Same 10-minute budget** as the rest of the post-merge pipeline (policy §2.4). If the full gate cannot fit, run assertions 1-3 inline and 4-5 as a bounded follow-on job that still blocks promotion.
- **Not a substitute for the deploy.** A green gate says main *could* ship; it does not say it *did*. Promotion still follows [`DEPLOYMENT_PIPELINE.md`](DEPLOYMENT_PIPELINE.md).

`[SYNTHESIS]` The five assertions are this system's codification (policy §3.5), derived from Humble's "on demand" standard and Fowler's self-testing-build practice. No cited source enumerates this list.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Image rebuild between environments | Blocker (violates build-once) |
| Pipeline lacks rollback verification step | Major |
| Migration mixes schema change + code change in one deploy | Major (no expand/contract) |
| Manual step in dev deploy path | Minor (defeats the auto-deploy intent) |
| Prod deploy path has no manual gate | Major (per NOTES.md policy) |
| Pipeline does not produce SBOM | Major |
| Container image is not signed | Major |
| No prod-deployability gate on main | Blocker |
| Deployability gate exists but is `allow_failure` / skipped / muted | Blocker |
| Merge to main while the deployability gate is red | Blocker |
| Gate omits the prod-config dry-run (assertion 2) | Major |
| Smoke test runs with new flags on rather than off (assertion 3) | Major |
| Gate omits the rollback rehearsal (assertion 5) | Major |
| Feature merged on an unflagged code path, or flag defaults on | Blocker |

## What "releasable" means concretely

- All tests green (unit, integration, smoke).
- Static analysis and security scans green at policy thresholds.
- Migrations are forward-compatible with prior code.
- Every feature is behind a flag and the flag defaults **off**; new code is dark on arrival and the off path has a test (policy §3.4).
- The prod-deployability gate is green on this commit (policy §3.5). Without it, "releasable" is [UNVERIFIED].
- Logs / metrics / traces wired before merge, not after.

## Anti-patterns to flag

- "Release branch" that diverges from main for days. Defeats CD. Use feature flags instead.
- Manual edits to images or configs between environments. Configuration drift is a footgun.
- Deploy windows on Fridays or end-of-quarter freezes that have replaced "we don't trust our pipeline" with policy. Fix the pipeline.
- "Hotfix" branches that bypass the pipeline. Hotfixes go through the same pipeline, just expedited.
- "Main is releasable" asserted from the fact that tests pass. Unit tests do not know whether the prod IAM role has the new permission. That is assertion 2's job.
- A deployability gate that only deploys to dev. Dev config is not prod config; the whole point is the delta.
- Muting the gate to unblock a release. That inverts it: the gate is red precisely when you should not be releasing.

## Sources

- Humble & Farley, *Continuous Delivery* (2010); Fowler "ContinuousDelivery" — see [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3 for URLs.
- DORA *State of DevOps* — deployment frequency / lead time / MTTR / change-fail rate as the four CD metrics.
- Research: [`../../research/06-release/`](../../research/06-release/).
- Handbook: [`../../handbook/06-ship.md`](../../handbook/06-ship.md).
- Policy §3.4 (flag-by-default) and §3.5 (deployability test) are the binding text for rules 8 and 9; both are marked `[SYNTHESIS]` there.
