---
name: ship
description: Phase 06 — make deployment boring. Reviews the CI/CD pipeline, deployment strategy, container tagging discipline, feature flags, and rollback plan. Targets merged-to-prod within 30 min, rollback < 5 min.
argument-hint: [service-or-repo]
---

# /ship

## Goal

Audit (or design) the deploy path to be automatic, fast, and reversible. Continuous Delivery: every commit is *ready* to deploy; humans gate prod for risky surfaces.

## Done when

- CI is green: tests + scans + image build (once) + sign + push.
- Pipeline order: build → lint → test → security scan → image build → sign → deploy dev (auto) → smoke → manual gate → deploy preprod → smoke → manual gate → deploy prod (canary) → monitor → promote or rollback.
- Pipeline-as-code: `.gitlab-ci.yml` versioned in repo; no GUI configuration drift.
- Container image is built ONCE and promoted by digest. Dev/preprod/prod use the same image, retagged. **Never rebuild between environments.**
- Main auto-deploys to dev. Preprod and prod are manual.
- Canary stage exists for any user-facing change (1–5% traffic; metrics monitored).
- Feature flags configured per [`../standards/release/`](../standards/release/) (Pete Hodgson's four-category taxonomy); release toggles removed within 2–4 weeks of 100%.
- Rollback plan: `< 5 minutes`. Tested in last 90 days.
- Database changes use expand/contract pattern.
- Release cadence: small changes per deploy, many times daily, no release windows.
- Every authored Markdown artifact passes through `scripts/verify-artifact.sh` (the pre-output gate, layer 6 of the anti-hallucination protocol — see [`../standards/ANTI_HALLUCINATION.md`](../standards/ANTI_HALLUCINATION.md)) before the pass-runner reports completion. Broken relative links auto-block; unverified-tag ratio > 0.3 auto-majors.

## Phase

06 — Ship

## Pre-flight

- Repo has a CI config (`.gitlab-ci.yml`, `.github/workflows/`, etc.) — or this command will help create one.
- Container registry (ECR by default for the user's stack) is configured.
- Cloud target identified (default: AWS ECS-on-EC2 per the user's stack).

## Dependency Gate

| Artifact | Path | Required by |
|---|---|---|
| CI config | `.gitlab-ci.yml` / `.github/workflows/*.yml` | Pass 1 |
| Container registry | ECR repository (Terraform module or AWS console) | Pass 1 |
| Cloud target named | NOTES.md or service repo `infra/` | Pass 1 |
| Terraform state backend | remote backend configured (S3 + DynamoDB lock by default) | Pass 1 |
| Manual approval gates | `.gitlab-ci.yml` `when: manual` on preprod/prod | Pass 1 |
| OIDC trust to AWS | IAM identity provider + role | Pass 2 |
| Image signing | cosign keys / ECR signed manifests | Pass 2 |
| Rollback runbook | `docs/runbooks/rollback.md` (or equivalent) tested in last 90 days | Pass 3 |
| (If feature-flagged) Flag registry entry | `flags/<name>.md` with cleanup ticket | Pass 3 (FEATURE_FLAGS framework) |

## Run Config

```json
{
  "score_threshold": 85,
  "short_circuit_threshold": 93,
  "max_passes": 3,
  "escalated_max_passes": 5,
  "agents": {
    "platform-engineer": {
      "model": "opus",
      "model_reviewing_existing": "sonnet",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/release/CONTINUOUS_DELIVERY.md",
        "standards/release/DEPLOYMENT_PIPELINE.md",
        "standards/release/CONTAINER_TAGGING.md",
        "standards/release/VERSIONING.md",
        "standards/platform/AWS_ECS_TERRAFORM.md",
        "standards/platform/TERRAFORM_DISCIPLINE.md",
        "standards/platform/AUTO_MERGE.md",
        "standards/platform/AWS_NAMING.md",
        "standards/platform/GITLAB_SECURITY.md"
      ]
    },
    "security-reviewer": {
      "model": "opus",
      "standards": [
        "standards/AGENT_PREAMBLE.md",
        "standards/EVIDENCE.md",
        "standards/security/OWASP.md",
        "standards/platform/GITLAB_SECURITY.md"
      ]
    }
  }
}
```

## Pass focus

| Pass | Focus | Question |
|---|---|---|
| 1 | Correctness | Is the pipeline order correct (build → lint → test → scan → image build → sign → deploy), is the image built ONCE and promoted by digest, and is main→dev auto with preprod/prod manual? |
| 2 | Proof & Safety | Is OIDC used (no long-lived AWS keys in CI), are images signed (cosign / ECR signed manifests) with SBOM archived, and is there a canary stage with metric monitoring for user-facing changes? |
| 3 | Ship Readiness | Is rollback documented, automated, and tested within the last 90 days at `< 5 min`, do migrations follow expand/contract, and do feature flags carry cleanup tickets with deadlines (release toggles ≤ 30 days post-100%)? |

## Standards to load

```yaml
standards:
  - standards/AGENT_PREAMBLE.md
  - standards/EVIDENCE.md
  - standards/QUALITY.md
  - standards/release/CONTINUOUS_DELIVERY.md
  - standards/release/DEPLOYMENT_PIPELINE.md
  - standards/release/CONTAINER_TAGGING.md
  - standards/release/VERSIONING.md
  - standards/platform/AWS_ECS_TERRAFORM.md
  - standards/platform/TERRAFORM_DISCIPLINE.md
  - standards/platform/AUTO_MERGE.md
  - standards/platform/AWS_NAMING.md
  - standards/platform/GITLAB_SECURITY.md
  - standards/security/OWASP.md
```

## Sub-agents

```yaml
sub_agents:
  - platform-engineer    # primary (opus for design pass; sonnet for review pass)
  - security-reviewer    # CI hardening, OIDC, image signing, SBOM (opus)
```

## Pass-loop dispatch

Pass-runner produces a **ship-readiness report**. Per pass:

1. **Pipeline order.** Confirm stage ordering. Flag fast checks running after expensive ones.
2. **Build-once discipline.** Confirm there's only ONE `docker build` in the entire promotion path. Any `build:preprod` or `build:prod` stage is a blocker.
3. **Tag promotion.** Confirm preprod / prod stages use `docker tag` + `docker push` referencing the dev digest, not a fresh build.
4. **Auto vs manual gates.** Main → dev auto. Preprod / prod manual. Inverse is blocker.
5. **`terraform plan` vs `apply`.** Plan on MR. Apply on merge to main. Both running on the same trigger is blocker.
6. **Pipeline-as-code.** No GUI variables that aren't in `.gitlab-ci.yml`. (Secret values are in the secret manager, referenced by name.)
7. **OIDC.** Runner authenticates to AWS via OIDC + assumeRole. Long-lived AWS keys in CI variables: blocker.
8. **Image signing.** Cosign / notation / ECR signed manifests for prod images.
9. **SBOM.** Generated and archived per release.
10. **Canary.** User-facing changes have a 1–5% canary stage with metric monitoring.
11. **Rollback.** Documented; tested within 90 days; takes < 5 min.
12. **Feature flags.** If used: taxonomy correct, release toggles have a removal date, ops toggles separately tracked.
13. **Migrations.** Expand/contract for any schema change. The "drop old column" stage is a separate deploy.

## Hard blockers (per the user's policy)

These come from NOTES.md and [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md):

- Pipeline rebuilds image for promotion: blocker.
- `terraform apply --auto-approve` from a developer machine: blocker.
- Direct push to main on a service repo: blocker.
- Production deploy from a `latest` tag (mutable): blocker.
- Long-lived secrets in CI variables: blocker.

## Output

Artifact at `cdocs/ship-audit-<timestamp>.md` with the per-rule checklist, blockers, recommendations, and a one-page "to make this prod-ready" punch list.

## Sources

- Handbook: [`../../handbook/06-ship.md`](../../handbook/06-ship.md)
- Research:
  - [`../../research/06-release/cicd.md`](../../research/06-release/cicd.md) — Fowler CI 11 practices; Humble *Continuous Delivery*
  - [`../../research/06-release/deployment-strategies.md`](../../research/06-release/deployment-strategies.md) — Fowler blue-green, dark launch; Sato canary
  - [`../../research/06-release/feature-flags.md`](../../research/06-release/feature-flags.md) — Hodgson four categories; progressive delivery
  - [`../../research/06-release/dora-metrics.md`](../../research/06-release/dora-metrics.md) — DORA four keys; 2024 Elite/High/Medium/Low
- User policy: [`../../NOTES.md`](../../NOTES.md) — auto-deploy main→dev; manual to preprod/prod; build-once tagging; Terraform plan-on-MR / apply-on-merge.
- Platform policy: [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md).
