# 06-ship-exit.md — Phase 06 (Ship) exit checklist

**Authoritative source:** [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md); [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md), [`../release/DEPLOYMENT_PIPELINE.md`](../release/DEPLOYMENT_PIPELINE.md), [`../release/CONTAINER_TAGGING.md`](../release/CONTAINER_TAGGING.md).

This checklist is run before each promotion (dev → preprod → prod) and as a final gate before declaring a release done.

## Done-when (per release)

- [ ] **Pipeline order canonical** — build → test → scan → sign → SBOM → publish → deploy. No skipped stages.
- [ ] **Image referenced by digest** in task definition, not by tag. See [`../release/CONTAINER_TAGGING.md`](../release/CONTAINER_TAGGING.md).
- [ ] **Same digest across environments.** Dev's bytes are preprod's bytes are prod's bytes.
- [ ] **Image signed (cosign)** before promotion to preprod.
- [ ] **SBOM emitted and stored** with the artifact.
- [ ] **Container CVE scan** clean (no Critical) before promotion to prod.
- [ ] **Manual gate enforced** for preprod → prod promotion.
- [ ] **Canary / progressive rollout** configured for prod. Auto-rollback on canary failure thresholds.
- [ ] **Rollback path verified** in this pipeline run; rollback < 5 min from decision.
- [ ] **Migration is expand/contract** (if schema change). Old code runs against new schema; new code runs against old schema during rollout.
- [ ] **Feature flag default off** for new user-visible behavior. Documented who has access to flip it.
- [ ] **Release notes / changelog** generated from Conventional Commits.
- [ ] **OIDC used for cloud access** in pipeline (no long-lived AWS keys). See [`../platform/AWS_ECS_TERRAFORM.md`](../platform/AWS_ECS_TERRAFORM.md).
- [ ] **Branch protection respected** — merge through MR, required approvals, no force-push.
- [ ] **Smoke test in dev passed** before promotion to preprod.
- [ ] **Synthetic transaction in preprod passed** before prod.

## Auto-rejection

| Trigger | Severity |
|---|---|
| Image rebuilt between environments | Blocker |
| Task definition pins image by tag, not digest | Blocker |
| `:latest` referenced anywhere in deployment config | Blocker |
| No manual gate before prod | Major |
| No canary / progressive rollout in prod | Major |
| No auto-rollback wiring | Major |
| Migration + code change in same deploy without expand/contract | Major |
| Long-lived AWS keys in CI (vs. OIDC) | Blocker |
| Pipeline allows merge without security scans green | Major |
| Image not signed before prod | Major |
| SBOM missing | Major |
| Direct push to prod environment skipping pipeline | Blocker |

## What good looks like

- Pipeline is boring: same shape every release, no surprises, no manual heroics.
- Rollback is exercised regularly (e.g., as part of game-day or by deliberate canary failures), not only in incidents.
- Release cadence matches DORA Elite (multiple deploys per day for active services).
- Time from PR-merged to in-prod measured and visible (lead time for changes — DORA).

## DORA targets (Elite, 2024)

| Metric | Elite |
|---|---|
| Deployment frequency | On-demand (multiple per day) |
| Lead time for changes | Less than one day |
| Change failure rate | 5% – 15% |
| Time to restore service | Less than one hour |
| Reliability (5th metric) | Meets or exceeds SLO targets |

The above are the published Elite thresholds in DORA's *Accelerate State of DevOps* reports. Target Elite over time; track quartile movement, don't just chase the absolute number.

## Sources

- Jez Humble & David Farley, *Continuous Delivery* (2010).
- *Accelerate State of DevOps* (DORA, annual) — dora.dev.
- AWS ECS Best Practices Guide on deployments.
- Sigstore / cosign documentation; SLSA framework (slsa.dev).
- Handbook: [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md).
