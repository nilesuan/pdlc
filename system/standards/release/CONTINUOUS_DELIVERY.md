# CONTINUOUS_DELIVERY.md — Every commit on main is releasable

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §3; [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md).

## The premise

Continuous Delivery (Humble & Farley): software is **always in a releasable state**. Releases are a business decision, not an engineering project.

This is distinct from Continuous Deployment (every commit auto-promotes to prod). CD-the-discipline is required; auto-promotion to prod is a per-service decision.

## Hard rules

1. **Every commit to main produces a deployable artifact.** Build → test → package → publish runs on every push.
2. **Build once; promote the same artifact through environments.** No rebuilding per environment. Same image SHA in dev → preprod → prod.
3. **Main auto-deploys to dev.** No human in the loop between merge-to-main and dev.
4. **Higher environments behind a manual gate.** Preprod and prod require a deliberate trigger (button, approval, or scheduled window). Per [`../../../NOTES.md`](../../../NOTES.md).
5. **Rollback path verified per release.** A release is not "shipped" until rollback has been demonstrated to work in this pipeline.
6. **Rollback < 5 minutes.** From decision to restored state. If rollback takes longer, fix the rollback path before shipping more.
7. **Database migrations are expand/contract.** Code and schema decouple. Old code must run against new schema; new code must run against old schema during rollout.

## The deployment pipeline (canonical order)

```
commit → build → unit test → static analysis →
package (image build, signed) → SBOM →
deploy to dev (auto) → smoke test in dev →
manual gate → deploy to preprod → integration + perf →
manual gate → deploy to prod (canary) → soak → full rollout
```

Each stage gates the next. A red stage blocks promotion. No path to prod that skips earlier stages.

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

## What "releasable" means concretely

- All tests green (unit, integration, smoke).
- Static analysis and security scans green at policy thresholds.
- Migrations are forward-compatible with prior code.
- Feature flags default to current prod state (new code is dark by default).
- Logs / metrics / traces wired before merge, not after.

## Anti-patterns to flag

- "Release branch" that diverges from main for days. Defeats CD. Use feature flags instead.
- Manual edits to images or configs between environments. Configuration drift is a footgun.
- Deploy windows on Fridays or end-of-quarter freezes that have replaced "we don't trust our pipeline" with policy. Fix the pipeline.
- "Hotfix" branches that bypass the pipeline. Hotfixes go through the same pipeline, just expedited.

## Sources

- Humble & Farley, *Continuous Delivery* (2010); Fowler "ContinuousDelivery" — see [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §3 for URLs.
- DORA *State of DevOps* — deployment frequency / lead time / MTTR / change-fail rate as the four CD metrics.
- Research: [`../../../research/06-release/`](../../../research/06-release/).
- Handbook: [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md).
