# DEPLOYMENT_PIPELINE.md — Pipeline shape and gates

**Authoritative source:** [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) §9; [`../../NOTES.md`](../../NOTES.md) (deployment policy).

## Pipeline order (canonical)

```
1. Validate     — lint, format, commit-message check
2. Build        — compile, package, container image build
3. Test         — unit, integration, contract
4. Scan         — SAST, SCA, secrets, container CVE
5. Sign + SBOM  — image signing (cosign), SBOM emission
6. Publish      — push image to ECR with digest, attach SBOM, sign
7. Deploy dev   — auto, on every main merge
8. Smoke test   — health checks, synthetic transactions in dev
8b. Deployability gate - prod-config dry-run, flags-off smoke, migration compat, rollback rehearsal (blocking; see CONTINUOUS_DELIVERY.md)
9. Manual gate  — preprod
10. Deploy prep — same digest, preprod env config
11. Validate    — integration tests against preprod
12. Manual gate — prod
13. Deploy prod — same digest, prod env config, canary first
14. Soak        — error rate, latency, golden-signal watch
15. Full rollout or rollback
```

A red stage stops the pipeline. No bypass paths.

## Hard rules (from NOTES.md + developer-guidelines §9)

1. **Main auto-deploys to dev.** No human between merge and dev.
2. **Preprod and prod require a manual trigger.** A button click, an approval, or an explicit chat command.
3. **Same image digest across environments.** The hash that ran in dev is the hash that runs in prod. No rebuilds.
4. **Environment differs only by config.** Env vars / SSM parameters / secrets manager refs change; the artifact does not.
5. **Canary first in prod.** A subset of traffic / instances takes the new version; metrics observed before full rollout.
6. **Auto-rollback on canary failure.** Defined error/latency thresholds trigger rollback without human action.
7. **GitLab MR pipeline runs `terraform plan`; merge to main runs `terraform apply`.** (Single-runner OIDC model — see [`../platform/TERRAFORM_DISCIPLINE.md`](../platform/TERRAFORM_DISCIPLINE.md).)
8. **Pipeline definition lives in repo.** `.gitlab-ci.yml` (or equivalent) is reviewed alongside code. No "click-to-edit" pipeline state.
9. **The prod-deployability gate is a required job on `main`.** It runs after the dev smoke test and before any promotion is offered, and it asserts the five items in [`CONTINUOUS_DELIVERY.md`](CONTINUOUS_DELIVERY.md) §"The prod-deployability gate": artifact identity, prod-config dry-run, flags-off smoke, migration compatibility, rollback rehearsal. Red gate = stop-the-line; no `allow_failure`, no skip. Assertion 2's prod dry-run is **read-only**: it is a `terraform plan` against the prod workspace under a plan-scoped OIDC role, and it neither performs nor authorizes an apply. It does not replace rule 7's apply-on-merge flow for the infrastructure repo - it is a check that a *service* commit would render and resolve against prod config (see [`../platform/TERRAFORM_DISCIPLINE.md`](../platform/TERRAFORM_DISCIPLINE.md)).
10. **Deploys land with new flags off.** A promotion never changes flag state. Enabling a feature is a separate flag action, taken after the deploy is healthy (see [`../frameworks/FEATURE_FLAGS.md`](../frameworks/FEATURE_FLAGS.md) §"Baseline mandate").

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Image rebuilt for preprod or prod | Blocker |
| Manual deploy step in dev path | Minor |
| No manual gate before prod | Major |
| No canary or progressive rollout in prod | Major |
| No auto-rollback on canary failure thresholds | Major |
| Pipeline defined outside the repo (UI-edited) | Major |
| Secrets passed as plain env vars in pipeline definition | Blocker |
| `terraform apply --auto-approve` from a non-pipeline runner | Blocker |
| No prod-deployability gate on the main pipeline | Blocker |
| Deployability gate is `allow_failure` / skippable / not required | Blocker |
| Promotion offered while the deployability gate is red | Blocker |
| Deploy job flips feature flags on as part of the deploy | Major |
| Gate's prod dry-run uses a role that can apply, not just plan | Blocker |

## Environment promotion model

```
dev      ← auto on every merge to main
preprod  ← manual trigger; same digest as the dev that passed smoke
prod     ← manual trigger; same digest as the preprod that passed validation
```

Promotions skip stages → blocker. (You cannot promote a digest to prod that has not run in preprod.)

The deployability gate sits on the `main` pipeline itself, not on a promotion: it answers "could this commit go to prod?" on every commit, including the ones nobody intends to promote today. That is what keeps the answer honest on the day someone needs it.

## Anti-patterns to flag

- "It works in dev" → ship to prod. Without preprod soak, you have no signal.
- Different Dockerfile per env. Build once means one Dockerfile, env-injected config.
- Pipeline scripts that `curl | bash` external installers. Pin and vendor.
- Long-lived pipeline credentials. Use OIDC short-lived tokens (see [`../platform/AWS_ECS_TERRAFORM.md`](../platform/AWS_ECS_TERRAFORM.md)).

## Sources

- [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) §9 (Deployment).
- [`../../NOTES.md`](../../NOTES.md) — explicit user policy on environment auto/manual gating.
- [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §3.5 - binding text for the deployability gate (marked `[SYNTHESIS]` there); §3.4 for flags-off deploys.
- Humble & Farley, *Continuous Delivery* — pipeline-as-code, build-once-promote.
- Research: [`../../research/06-release/`](../../research/06-release/).
