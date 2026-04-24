# Phase 06 — Ship: Processes

**Companion to:** [`06-ship.md`](06-ship.md)
**Last updated:** 2026-04-24

This document decomposes Phase 06 into discrete, repeatable processes. `06-ship.md` tells you *what shipping is* and *why the industry converged on this shape*; this file tells you *who runs each process, when, with what inputs, and how you know it's done*.

---

## How to read this

Each process below follows the same ten-field pattern:

- **Purpose** — the one sentence that explains why this process exists.
- **RACI** — Responsible / Accountable / Consulted / Informed.
- **Triggers** — the events that start the process.
- **Inputs** — the artifacts / information required to run it.
- **Activities** — the concrete steps.
- **Outputs** — the artifacts / decisions that result.
- **Tools / templates** — what actually supports the work.
- **Cadence / duration** — how often it runs and how long it takes.
- **Exit gate** — the objective test that says "done."
- **Pitfalls** — the specific ways this process fails in practice.

These processes are prescriptive synthesis: the ordering, owners, and exit gates are a working recipe consistent with the practices cited in `06-ship.md`. Adapt to your context; do not skip the exit gates.

---

## Process inventory

| # | Process | Typical cadence | Primary owner |
|---|---|---|---|
| 1 | Pipeline-as-Code Setup & Maintenance | Once at service spin-up; edited per change | Platform eng / service author |
| 2 | Artifact Build, Sign & SBOM Generation | Every merge to main | CI pipeline (author verifies) |
| 3 | Environment Provisioning (Dev / Preview / Staging / Prod) | Per service / per PR / quarterly review | Platform eng |
| 4 | Deployment Strategy Selection | Per service or per risky change | Service tech lead |
| 5 | Feature Flag Lifecycle Management | Per user-visible change; weekly inventory review | Feature author (SRE for ops flags) |
| 6 | Progressive Rollout Execution | Per user-visible change | Change author |
| 7 | Canary Monitoring & Auto-Abort | Every production deploy | CI pipeline (change author on-call) |
| 8 | Database Migration (Expand / Contract) | Per schema change | Change author + service tech lead |
| 9 | Versioning & Changelog Authoring | Every release (libraries); per merge (services) | Change author / release bot |
| 10 | Release Notes & Customer Comms | Per customer-visible feature | Product + author |
| 11 | Rollback Execution | On SLI regression or incident | Change author or on-call |
| 12 | DORA Metrics Measurement & Review | Weekly dashboard; monthly review | Platform eng / delivery lead |
| 13 | Phase Exit & Handoff to Phase 07 | Per release | Change author |

---

## Default RACI

Convention: **R** = does the work; **A** = signs off (single name); **C** = consulted before commit; **I** = notified after.

| Process | Change author | Reviewer | Service tech lead | Platform / SRE | Product | On-call |
|---|---|---|---|---|---|---|
| Pipeline setup | R | C | A | C | I | I |
| Artifact build / sign / SBOM | R (verify) | — | A | C | — | — |
| Environment provisioning | C | — | A | R | I | I |
| Deployment strategy | R | C | A | C | I | C |
| Feature flag lifecycle | R, A | C | C | C | I | I |
| Progressive rollout | R, A | — | C | I | I | I |
| Canary monitor / auto-abort | A (reacts) | — | C | R (platform) | — | I |
| DB migration expand/contract | R | C | A | C | — | I |
| Versioning / changelog | R | — | A | — | I | — |
| Release notes | C | — | I | — | R, A | — |
| Rollback | R | — | A | C | I | I |
| DORA measurement & review | C | — | C | R | I | I |
| Phase exit / handoff | R, A | — | C | I | I | I |

"Change author" is the engineer who merged the PR. This is non-negotiable: the person who wrote the code is the person who ships and watches it. If shipping requires a specific other person's presence, shipping is broken.

---

## 1) Pipeline-as-Code Setup & Maintenance

**Purpose.** Encode the build / test / deploy sequence in a repository file so the pipeline is reviewable, diffable, and portable — not a GUI configuration that disappears when the tool changes.

**RACI.** R: service author (first time) / any engineer (edits). A: service tech lead. C: platform eng. I: team.

**Triggers.**
- New service reaches the point of first deploy.
- A pipeline stage needs to change (new scan, new environment, new approval rule).
- The underlying CI platform changes (e.g., GitHub Actions → GitLab CI migration).

**Inputs.**
- Service language, runtime, and build system.
- The canonical stage order: build → unit → integration → static / SAST → image + SBOM → sign → staging → smoke → canary → monitor → promote.
- The organisation's template pipeline (if one exists) or the reference in `06-ship.md`.
- Access to the CI platform, artifact registry, and signing identity (OIDC / cosign).

**Activities.**
1. Create the pipeline file in the repo (`.github/workflows/deploy.yml`, `.gitlab-ci.yml`, `Jenkinsfile`, etc.). No GUI-only configuration.
2. Adopt the "scripts to rule them all" pattern: the pipeline should call `script/bootstrap`, `script/test`, `script/lint`, `script/deploy` — not embed logic inline. The same scripts must work locally and in CI.
3. Order stages so fast checks abort before slow ones: lint / unit first (< 5 min), then integration, then image build + SBOM, then staging + smoke, then canary + monitor, then promote.
4. Add concurrency control so simultaneous merges to main don't race (`concurrency: group: ${{ github.workflow }}-${{ github.ref }}`).
5. Wire OIDC-bound credentials into the build job (no long-lived secrets in CI).
6. Configure `environment: production` (or equivalent) with protection rules, branch restrictions, and scoped secrets.
7. Validate locally with `act` / `gitlab-runner exec` or a feature-branch run before merging.

**Outputs.**
- Pipeline definition file committed to the service repo.
- Green run on a feature branch demonstrating every stage reached.
- Platform-level protection rules configured (branch, approvers, secrets scope).

**Tools / templates.**
- GitHub Actions / GitLab CI / CircleCI / Jenkins / Buildkite.
- A reusable pipeline template repo at the org level (if > 5 services).
- `act` (GitHub) or `gitlab-runner exec` for local validation.
- Renovate / Dependabot to keep runner and action pins current.

**Cadence / duration.** First-time setup: 1–3 days. Edits: minutes to hours per change.

**Exit gate.** The pipeline runs end-to-end on a feature branch, all stages green, an artifact is produced, and the staged deploy works. The file has been code-reviewed.

**Pitfalls.**
- **Logic inline in the YAML.** Fifty-line `run:` blocks become untestable, unreadable, and diverge from local behaviour. Move to scripts.
- **Unbounded pipeline time.** Without an explicit commit-to-ready-to-deploy budget (target: < 30 min), stages grow until the pipeline is the bottleneck.
- **GUI drift.** Enabling features in the web UI that aren't captured in the YAML. Next clone or migration loses them silently.
- **No concurrency control.** Two merges arrive in the same minute and deploy out of order.
- **Long-lived CI secrets.** Static API keys in CI env are a prime exfiltration target; prefer OIDC to cloud providers where possible.

---

## 2) Artifact Build, Sign & SBOM Generation

**Purpose.** Turn a commit into a deployable artifact whose contents and provenance are both knowable — so that later stages can verify trust without trusting the CI runner it came from.

**RACI.** R: CI pipeline (change author verifies). A: service tech lead. C: platform eng. I: security.

**Triggers.** Merge to main (or tag push for library releases).

**Inputs.**
- The commit SHA and the full source tree.
- Language-native build tooling (Go, Node, Python, JVM, …).
- Container build environment (buildx / Kaniko / Docker) if containerised.
- OIDC identity for the pipeline (short-lived, ambient, bound to the workflow).
- Registry credentials (GHCR / ECR / Artifact Registry / Harbor).

**Activities.**
1. Produce a reproducible build. Same commit → same artifact byte-for-byte (or at least hash-equivalent). Pin base images by digest, not tag; pin toolchain versions.
2. Generate a Software Bill of Materials alongside the image. Use `docker buildx build --sbom=true`, `syft`, or equivalent. Attach it as a registry attestation.
3. Emit SLSA provenance. GitHub Actions: `provenance: true` on `docker/build-push-action`. This records how the artifact was built and binds that record to the signing identity — SLSA Level 2.
4. Sign the image with cosign using the short-lived OIDC identity: `cosign sign --yes <image>@<digest>`. No long-lived signing keys.
5. Push to the artifact registry by digest (not by mutable tag).
6. Emit the digest as a pipeline output; every downstream stage deploys by digest.

**Outputs.**
- Container image in the registry, pinned by digest.
- SBOM attestation attached to the image.
- SLSA provenance attestation attached to the image.
- Cosign signature in the transparency log.

**Tools / templates.**
- Docker buildx with `provenance: true`, `sbom: true`.
- `syft` / `cyclonedx-cli` for SBOM generation.
- `cosign` (sigstore) for signing and verification.
- Registry: GHCR, ECR, Google Artifact Registry, Harbor, JFrog Artifactory.

**Cadence / duration.** Every merge. 2–10 min typically; budget aggressively.

**Exit gate.** `cosign verify <image>@<digest> --certificate-identity <pipeline-oidc>` passes. SBOM is present. Image is pinned by digest in downstream stages.

**Pitfalls.**
- **Deploying by mutable tag.** `:latest` (or `:main`) is not an artifact identity. Always deploy by `@sha256:...` digest.
- **SBOM generated but not attached.** A text file in a build log is not an SBOM attestation. Attach to the registry.
- **Long-lived signing keys.** A key that lives in a KMS and is accessible to any pipeline step is the attack surface SLSA is trying to eliminate. Use keyless / OIDC.
- **Skipped on hotfix branches.** The fastest way to ship an unsigned, unscanned artifact is an emergency "just this once."

---

## 3) Environment Provisioning (Dev / Preview / Staging / Prod)

**Purpose.** Give every stage of the pipeline a fit-for-purpose environment to run against, with increasing fidelity and shrinking blast radius — so problems are caught on the cheap environments, not discovered in production.

**RACI.** R: platform eng. A: service tech lead. C: change authors. I: team.

**Triggers.**
- New service being stood up.
- PR opened (ephemeral preview spun up automatically).
- Staging drift detected (data, schema, or config divergence from prod).
- Quarterly environment review.

**Inputs.**
- Infrastructure-as-code source of truth (Terraform / Pulumi / CDK).
- Synthetic data generator (or plan to build one).
- Environment cost budget.

**Activities.**
1. Define the four environment classes explicitly in IaC: **dev** (per-engineer local), **preview** (one per PR, ephemeral), **staging** (long-lived, shared, production-like), **production**.
2. Wire preview environments to PR open / close events. Vercel / Netlify / Render / Railway / Coolify do this natively; Kubernetes via ArgoCD `ApplicationSet` with PR generator does it manually.
3. Enforce synthetic-data-only in non-prod. Real customer data never leaves production. Build (or adopt) a seeder that generates realistic but fake records.
4. Keep staging schema within one expand/contract window of production — not drifted.
5. Scope secrets per environment. CI secrets scoped to `environment: production` do not bleed into staging.
6. Define TTL on preview environments (e.g., auto-destroy 3 days after PR merge or close).
7. Monitor cost of ephemeral environments; cap per repo if it grows.

**Outputs.**
- Four environment classes described in IaC and reproducible.
- Preview environment URL appearing in every PR.
- Synthetic-data seeder in the repo.
- Cost dashboard for non-prod environments.

**Tools / templates.**
- Terraform / Pulumi / CDK for environment definition.
- GitHub Actions / GitLab CI environment integrations.
- Vercel / Netlify / Render / Fly.io / Railway / Coolify for PaaS preview envs.
- ArgoCD / Flux for Kubernetes-native preview environments.
- Synthetic data: Faker, Mockaroo, or a custom seeder.

**Cadence / duration.** Initial stand-up: 1–5 days. Per-PR preview: minutes, automatic. Quarterly review: 1–2 hours.

**Exit gate.** Every PR gets a preview URL without manual action; staging and production are IaC-described; no real customer data exists in any non-prod environment.

**Pitfalls.**
- **Production data in preview / staging.** Security incident waiting to happen, especially under GDPR / CPRA.
- **Staging drift.** Staging with a month-old schema is not "like production" — it's a trap. Redeploy continuously, same as prod.
- **Preview environments that never die.** Cost balloons; stale URLs get linked from docs and go stale.
- **Manual provisioning for "just this one service."** It grows into six services with no IaC.
- **Staging used as a dev playground.** Half-finished features in staging mean staging is not a reliable pre-prod check. Half-finished work belongs on previews, not staging.

---

## 4) Deployment Strategy Selection

**Purpose.** Pick the right deployment mechanism for the risk profile of the change — so the *how* matches the *what*, instead of treating every change identically.

**RACI.** R: service tech lead (baseline) / change author (per-change deviation). A: service tech lead. C: platform eng, on-call. I: team.

**Triggers.**
- Service is being stood up (baseline strategy).
- A change is materially higher-risk than the baseline (payments rewrite, authn change, data format change, shared-infra change).

**Inputs.**
- Service criticality tier (user-facing / internal / experimental).
- State model (stateless / stateful / has long-lived connections).
- Traffic pattern (steady / bursty / scheduled).
- Risk profile of the specific change.

**Activities.**
1. Set the baseline strategy per service. Default: **rolling + canary + feature flags** for most services. Blue-green if instant rollback is critical and double capacity is affordable. Shadow / mirror only for replacing a critical subsystem.
2. Pick the canary size. Start small (1–5% of traffic) for user-visible services; more generous for internal.
3. Define the dark-launch criteria explicitly: which changes should exercise the new behaviour silently in production before being user-visible (scale validation, real-data realism).
4. Per change, check against the "does this need a deviation from baseline?" list:
   - Multi-service change? → coordinate canary across services or gate behind a single feature flag.
   - Schema change? → expand/contract is mandatory (process 8), canary cannot rescue a bad migration.
   - Authn / authz change? → dark launch + shadow first; canary second.
   - Destructive? (delete, truncate, retention) → dark launch + soak; never canary-then-hope.
5. Document the choice in the PR description or design doc. One sentence.

**Outputs.**
- A baseline strategy in the service README or `SHIP.md`.
- Per-change deviation noted in the PR when it differs.

**Tools / templates.**
- Argo Rollouts / Flagger / Spinnaker for canary orchestration on Kubernetes.
- Service meshes (Istio, Linkerd) for traffic splitting.
- Cloud-native: AWS CodeDeploy, GCP Cloud Deploy, Azure Deployment Slots.

**Cadence / duration.** Baseline: set once, revisit quarterly. Per-change deviation: minutes.

**Exit gate.** The baseline is documented. If the current change deviates, the deviation is written in the PR and approved by the service tech lead.

**Pitfalls.**
- **One strategy for the whole org.** Payments and the marketing CMS don't need the same mechanism.
- **Blue-green for everything.** Double infrastructure cost. Usually unnecessary; rolling + canary is cheaper and sufficient.
- **Canary as a substitute for a migration plan.** A canary cannot rescue a destructive schema change — the migration already ran.
- **Undocumented deviations.** Reviewer has no way to know this change is different; surprises appear in the canary.

---

## 5) Feature Flag Lifecycle Management

**Purpose.** Decouple deployment from release so code can ship in a dormant state and be exposed to users in controlled steps — while containing the debt flags add to the codebase.

**RACI.** R: flag author (release / experiment flags) or SRE (ops flags) or product (permissioning flags). A: flag author. C: service tech lead. I: team.

**Triggers.**
- New feature being built (release flag).
- A/B test being designed (experiment flag).
- Operational risk identified (ops flag / kill switch).
- Tier / cohort gating required (permissioning flag).
- Weekly flag-inventory review.

**Inputs.**
- The four Hodgson categories: release, experiment, ops, permissioning.
- Managed flag service (LaunchDarkly, Unleash, PostHog, ConfigCat, Flagsmith, Statsig) — not a home-grown Redis key.
- Flag naming convention: `<category>_<feature>` prefix, owner and target removal date in description.
- Organisation's flag register / inventory.

**Activities.**
1. Classify the flag before creating it. Release vs. ops vs. experiment vs. permissioning — each has different owners, different cleanup rules, different lifetime expectations.
2. Create the flag in the managed service, not in code-level config, and record: category, owner, purpose, target removal date (release flags: 2–4 weeks post-100%; ops flags: may be permanent; experiment: experiment duration; permissioning: tier lifetime).
3. Wire the flag into the code with a *single* evaluation helper that reports to telemetry every hit. Flags invisible to observability cannot be measured or decommissioned.
4. Add the flag to the inventory register. Any flag not in the register is debt by default.
5. Operate the flag through the rollout (process 6).
6. On reaching 100% (release / experiment flags), schedule the removal PR: remove the off-path and the flag check; delete the flag from the service after the PR ships.
7. Review the flag inventory weekly: any release flag older than its target removal date is escalated to the owner.

**Outputs.**
- Flag created in the managed service with metadata.
- Entry in the flag register.
- Telemetry showing flag evaluations.
- Removal PR merged after 100% (for release / experiment flags).

**Tools / templates.**
- Managed flag service (see list above).
- A flag register: CSV, spreadsheet, Notion DB, or managed-service native.
- PR template field for "flag(s) introduced / removed by this PR."

**Cadence / duration.** Per feature, 10–30 minutes to set up. Weekly inventory review: 15–30 minutes.

**Exit gate.**
- Flag exists in managed service with category and owner.
- Code path guarded and telemetry emitting.
- Removal date recorded.
- (For release flags at 100%) removal PR merged within 2–4 weeks.

**Pitfalls.**
- **Home-grown flag file.** Environment variables or a config file with no audit log, no targeting, no dynamism. Short-term fast, long-term painful.
- **Flag debt accumulation.** Hodgson's warning — flags are inventory with carrying cost. Release flags left forever become dead conditionals and confuse readers.
- **Flag + if-branches everywhere.** A single flag should guard one well-defined change, not scatter across ten files.
- **Flags without telemetry.** You cannot know whether the flag is ever evaluated, on which paths, by whom.
- **Ops flags treated as release flags.** Kill switches that get "cleaned up" after a quarter leave you without a rescue lever during an incident.

---

## 6) Progressive Rollout Execution

**Purpose.** Expose a feature to users in controlled percentages so regressions show up at 1% — not 100% — with time to halt.

**RACI.** R, A: change author. C: service tech lead, product. I: on-call, team.

**Triggers.** A flagged user-visible change is ready to begin exposure.

**Inputs.**
- The rollout ladder: internal-only → 1% → 10% → 50% → 100% → flag removal.
- SLI thresholds (error rate, latency p99, business metric) that must hold through the ramp.
- Product / analytics dashboard for the feature.
- An estimate of time to stay at each step (hours for low-risk, days for higher-risk, up to weeks for payments-scale).

**Activities.**
1. Turn the flag on for internal accounts only. Sanity check: the feature works at all in production. Usually an hour or less.
2. Ramp to 1%. Self-selected beta cohort or a random user percentage. Watch:
   - Error rate for the cohort specifically.
   - Latency p99 for the cohort.
   - Product metric (conversion, activation, engagement).
   - Support volume for the feature.
   Hold for the configured time (hours for low risk; days for elevated).
3. Step to 10%. Same observation protocol. Broader signal, still recoverable.
4. Step to 50%. Past the risk threshold for most regressions. Some risk categories (regulated flows, payments) may want extra dwell time.
5. Step to 100%. Observe for a day. Announce in #shipped.
6. Schedule the flag-removal PR (process 5, step 6).
7. If any SLI breaches at any step, halt immediately. Do not proceed to the next step until the regression is understood, fixed, or the feature is reverted.

**Outputs.**
- Rollout log: timestamps and percentages recorded (ideally by the flag service).
- SLI and product-metric snapshots at each step.
- Flag at 100% with a removal PR scheduled.

**Tools / templates.**
- Managed flag service with percentage rollout (targets by user ID hash).
- Observability (Grafana / Datadog / Honeycomb) dashboard scoped to the flag cohort.
- Product analytics (Amplitude / Mixpanel / PostHog).

**Cadence / duration.** Low-risk ramps: hours to a day per step. Elevated risk: days. Payments-scale: up to weeks at the first one or two steps.

**Exit gate.** Flag at 100%; no SLI or product-metric regression observed for at least one steady-state day; removal PR scheduled.

**Pitfalls.**
- **Straight to 100%.** "It's a small feature." The step ladder is the insurance.
- **Skipping internal-only.** The 1% cohort becomes the canary for basic functionality; that belongs on internal accounts.
- **No cohort-scoped observability.** You can see aggregate metrics but can't tell whether the 1% actually affected them.
- **Ramping over a weekend / on-call handoff.** Low traffic hides regressions; handoff risks the dashboard going unwatched.
- **"Just leave it at 50% for a while."** That's a flag at 50% indefinitely — neither released nor rolled back. Pick a direction.

---

## 7) Canary Monitoring & Auto-Abort

**Purpose.** Let the pipeline decide whether a new version is healthy based on metrics, not human glances — so regressions are caught in minutes and reversal is automatic.

**RACI.** R: CI pipeline / deployment tool. A: change author (reacts to abort). C: service tech lead. I: on-call.

**Triggers.** New version deployed to the canary subset (1–5% of pods / traffic).

**Inputs.**
- SLIs defined for the service: error rate, latency p99, saturation, and any change-specific business SLI.
- Abort thresholds per SLI (e.g., error rate > baseline + 2x, p99 > baseline + 30%).
- Baseline window (typically the last 10–30 minutes of steady-state traffic or the same time of day last week).
- Canary duration (typically 5–15 minutes for user-visible changes; longer for database / schema changes).

**Activities.**
1. Pipeline deploys the new version to the canary subset.
2. Canary controller / pipeline queries the metrics store (Prometheus / Datadog / Cloudwatch) on a short cadence (e.g., every 30 seconds).
3. Each SLI compared to its threshold. Any breach → auto-abort.
4. Business / custom SLIs checked too, not just generic error rate. A canary can be "green" on 5xx and still break a purchase flow.
5. On abort: pipeline halts promotion and routes traffic back to the old version. Author is paged or notified.
6. On success over the full window: pipeline promotes to 100%.
7. Continue observing for at least 30 minutes after full promotion. Some regressions only appear at scale.

**Outputs.**
- Canary decision logged: promote / abort with reason.
- Metric snapshots at decision time.
- Incident created automatically on abort (ties to process 11).

**Tools / templates.**
- Argo Rollouts, Flagger, Spinnaker for canary orchestration.
- Prometheus / Datadog / Honeycomb / New Relic / Cloudwatch as the metric source.
- A canary-analysis spec in the service repo (metrics, thresholds, windows).

**Cadence / duration.** Every prod deploy. 5–15 minutes of canary observation typical.

**Exit gate.** Canary promoted to 100% with automatic evaluation passing; or canary aborted and rollback complete with an incident recorded.

**Pitfalls.**
- **Human "gut check" canary.** Someone glances at a dashboard and says "looks fine." Not a gate; rotate on-call and the knowledge decays.
- **Generic SLIs only.** Error rate and latency miss business regressions. Include a change-specific SLI when the change is material (checkout success, search relevance, payment authorisation).
- **Baseline set once, never updated.** Traffic patterns change; an ancient baseline gives false positives or misses slow drift.
- **Canary window too short.** 60 seconds can't reveal a cache-warm regression or a cron-job failure. Match window to the signal cadence.
- **Unwatched post-promote window.** Author promotes and walks away; a 30-minute-later regression goes to on-call as a cold surprise.

---

## 8) Database Migration (Expand / Contract)

**Purpose.** Change a schema in production without taking an outage and without closing off rollback — so a bad deploy can still be reverted to an older app version.

**RACI.** R: change author. A: service tech lead. C: platform eng / DBA (at scale). I: on-call.

**Triggers.** Any schema change: add column, drop column, rename, change type, add constraint, add / drop index on a large table.

**Inputs.**
- Current schema and the intended final schema.
- Table size and write volume (changes the tool choice).
- Migration tool: flyway / liquibase / sqitch / golang-migrate / Django / Rails / Prisma migrations / Alembic.
- For MySQL at scale: `pt-online-schema-change` or `gh-ost`. For Postgres: `pg_repack` and `CREATE INDEX CONCURRENTLY`.

**Activities.**
1. Decompose the desired change into the expand → backfill → contract sequence (Sato's Parallel Change):
   - **Expand** — add the new structure (new column, new table, new index). Dual-write from the app.
   - **Backfill** — copy old → new in a separate batch job, chunked to avoid locks.
   - **Contract 1** — app reads from the new structure; writes still go to both (defensive).
   - **Contract 2** — app reads and writes only the new structure.
   - **Drop** — separate, later deploy that removes the old structure.
2. Each of those is a *separate deploy*. Never bundle "drop the old column" with "start reading the new one."
3. For large tables (roughly > 1M rows or write-heavy), use an online schema change tool:
   - **pt-online-schema-change** (MySQL). Triggers on the original; atomic `RENAME TABLE` at the end.
   - **gh-ost** (MySQL). Binlog-based, triggerless, pausable — easier to control under load.
   - **pg_repack** / `CREATE INDEX CONCURRENTLY` (Postgres).
4. Plan the backfill as idempotent and chunked. Must be safe to rerun.
5. Confirm rollback: can we revert the app one version back while leaving the current schema? If not, you're still mid-expand/contract — do not proceed.
6. Deploy each step behind canary and standard monitoring.
7. Verify drop never happens while any running code (including the rollback target version) still references the old structure.

**Outputs.**
- Migration files, one per step, versioned in source control.
- Backfill job code + metrics dashboard.
- Deploy sequence documented in the PR.

**Tools / templates.**
- Framework-native migration tools (Rails, Django, Alembic, Prisma, Diesel, Knex, Liquibase, Flyway, sqitch).
- `pt-online-schema-change` / `gh-ost` / `pg_repack`.
- A migration checklist PR template.

**Cadence / duration.** Per schema change. Expand → drop spans days or weeks.

**Exit gate.**
- Every step deployed through the standard pipeline with canary.
- Old structure dropped only after no running version references it.
- Rollback plan confirmed feasible at every intermediate state.

**Pitfalls.**
- **Rename a column in one step.** The classic way to cause a correlated outage. Always expand/contract.
- **Drop still-referenced column.** App code on the rollback target breaks. The drop must wait until the rollback horizon has closed.
- **Unchunked backfill.** Single long transaction locks writes; canary and monitoring can't save you.
- **Destructive migration reversible only by restore.** A 4 a.m. backup restore is a disaster recovery plan, not a rollback plan.
- **"Migration as side effect of deploy."** Bundling schema + code in one pipeline step conflates two different reversibility profiles.
- **Skipping online schema change on a 100M-row table.** Blocking `ALTER TABLE` locks writes for minutes; monitors will alert before it finishes.

---

## 9) Versioning & Changelog Authoring

**Purpose.** Signal to consumers (humans and machines) what changed in this release — and commit to the compatibility contract that goes with it.

**RACI.** R: change author (libraries) / release bot (services). A: service tech lead. I: consumers.

**Triggers.**
- Merge to main on a published library.
- Release cut for internal services (if using release tags).
- Consumer-visible changes on a product (see process 10 for comms).

**Inputs.**
- The change type (fix / addition / breaking change).
- The project's versioning scheme:
  - **SemVer 2.0.0** for public APIs and libraries: `MAJOR.MINOR.PATCH`. Patch for backward-compatible fixes, minor for additions, major for breaking changes. `0.y.z` if not yet committing to a stable API.
  - **Calendar versioning** (e.g., `2026.4.1`) or continuous / commit-hash for internal services.
  - **Build ID / commit SHA** for SaaS products (SemVer does not apply — there's one live version).
- Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, `feat!:` / `BREAKING CHANGE`).
- Keep a Changelog 1.1.0 format: `Added` / `Changed` / `Deprecated` / `Removed` / `Fixed` / `Security`.

**Activities.**
1. Classify the change via the commit message (Conventional Commits) or PR label.
2. Compute the version bump:
   - `fix:` → PATCH.
   - `feat:` or backward-compatible `change:` → MINOR.
   - `feat!:` / `BREAKING CHANGE` → MAJOR.
3. Update `CHANGELOG.md` under the right category, newest first, with the release date. One human-readable line per entry; link to PR / issue.
4. Tag the release (`v1.4.0`) if using Git tags.
5. Automate where possible: release-please, semantic-release, changesets generate the changelog entry and version bump from commit messages.
6. If this is a breaking change on a public API, confirm the deprecation window was honoured (see Phase 08 sunset process).

**Outputs.**
- Updated `CHANGELOG.md`.
- Version tag (libraries).
- Published release (GitHub / GitLab / registry).

**Tools / templates.**
- release-please (Google), semantic-release, changesets (pnpm ecosystem).
- Conventional Commits linter (commitlint + husky, or the equivalent).
- `CHANGELOG.md` with Keep a Changelog 1.1.0 structure.

**Cadence / duration.** Per release. 5–15 min when automated; longer if hand-written.

**Exit gate.**
- Version bump matches the change classification (SemVer for libraries).
- Changelog entry exists, under the correct category, with a date.
- Breaking changes explicitly called out.

**Pitfalls.**
- **SemVer for SaaS products.** `2.3.0` of a web app means nothing to a user; pick calendar or build-ID versioning.
- **Changelog = `git log`.** A commit log is noise; a changelog is curated for humans.
- **Silent breaking change.** A `feat:` commit that breaks a consumer should have been `feat!:`. SemVer only works if the classification is honest.
- **Stuck on `0.y.z` forever.** At some point you're committing to a contract whether you like it or not. Move to `1.0.0` when that's true.
- **Bundled / "omnibus" release.** Six features and four fixes in one version entry; no consumer can tell what affects them.

---

## 10) Release Notes & Customer Comms

**Purpose.** Tell customers what changed in *their* language — so shipped work becomes visible, usable, and adoptable.

**RACI.** R: product + change author. A: product. C: support, marketing. I: customers, sales, CS.

**Triggers.**
- Customer-visible feature reaches 100% rollout.
- Group of small customer-visible changes reaches a publishable batch.
- Regulatory / contractual disclosure required.

**Inputs.**
- The changelog entry (engineering-side).
- The feature's positioning / user outcome.
- The affected customer segments.
- Comms channel policy: in-product changelog, email digest, release-notes page, in-app modal, support docs.

**Activities.**
1. Translate the engineering changelog entry into customer-facing wording. No internal jargon, no ticket IDs, no "we refactored X."
2. Pair each item with the user outcome: "You can now …" / "We fixed … so that …" / "We removed …".
3. Decide the channel(s) and timing:
   - In-product release-notes page: always.
   - In-app modal: only for features worth interrupting for (rare).
   - Email / digest: monthly roll-up for small changes; immediate for high-value or breaking changes.
   - Support / docs updates: before the feature is announced.
4. For deprecations / removals: include the sunset date and migration guidance (see Phase 08 for the longer RFC 8594 mechanism).
5. Ensure support and CS know what's shipping *before* customers see it, so inbound questions have answers ready.
6. Publish. Archive the notes in a versioned list.

**Outputs.**
- Release-notes entry published.
- Internal enablement note for support / CS / sales.
- Affected doc pages updated.

**Tools / templates.**
- Changelog pages (Headway, Beamer, Canny, ProductFlare, or hand-rolled).
- In-app announcement tooling (Appcues, Pendo, Intercom).
- A release-notes writing guide in the handbook.

**Cadence / duration.** Per customer-visible release. 15–60 minutes.

**Exit gate.**
- Customer-facing wording drafted and reviewed by product.
- Published to the agreed channels.
- Support enabled.

**Pitfalls.**
- **Engineering-voice release notes.** "Migrated storage layer to Postgres 16" helps no customer.
- **Omitting deprecations.** Customers discover a missing feature in production.
- **Support finds out from customers.** Always brief support first.
- **Every release announced in-app.** Modal fatigue; users ignore them all.
- **No deprecation timeline.** A "removed" item without sunset date / migration path breaks trust.

---

## 11) Rollback Execution

**Purpose.** Reverse a production change quickly and safely when a regression is detected — without requiring novel thinking in the middle of an incident.

**RACI.** R: change author (during business hours) or on-call (off hours). A: service tech lead. C: platform / SRE. I: team, product.

**Triggers.**
- Canary auto-abort fires.
- SLI regression detected manually.
- Customer-reported regression confirmed as caused by recent deploy.
- On-call judgement call during an incident.

**Inputs.**
- Deploy history and the previous known-good version.
- The rollback mechanism for this service (chosen per Phase 06 strategy):
  - Kubernetes: `kubectl rollout undo deployment/<name>`.
  - Blue-green: flip router back to blue.
  - Canary: halt promotion, route back to baseline.
  - Feature flag: flip off (no redeploy required).
- The schema-compatibility horizon (is the previous code version still compatible with the current schema?).

**Activities.**
1. Decide: roll back or forward-fix? Small cosmetic issue with an obvious one-line fix → forward-fix. Data corruption, memory leak, security regression, unknown scope → roll back first, investigate second.
2. Execute the rollback:
   - If the cause is a feature flag: flip it off. Seconds. Preferred when applicable.
   - Otherwise: roll back the deploy via the mechanism for this service.
3. Confirm the SLIs return to baseline.
4. Announce in the incident channel / #deploys: "rolled back <service> from <sha> to <sha>; issue was X; next step is Y."
5. File (or continue) the incident.
6. Freeze further deploys of this service until root cause is understood and a forward fix is in CI.
7. Post-incident: fix root cause, add a regression test, ship through normal pipeline. Do not skip canary to "get the fix in."

**Outputs.**
- Production reverted to the last good version.
- Incident record with cause, timestamps, and actions.
- Regression test merged before the forward fix.

**Tools / templates.**
- `kubectl rollout undo` / Argo Rollouts abort.
- Feature-flag kill switches.
- Incident tracker / status page.
- A "how we roll back <service>" one-page runbook in each service repo.

**Cadence / duration.** Ideally rare; when it happens, target < 5 minutes from decision to restored service.

**Exit gate.**
- SLIs back to baseline.
- Incident created / updated.
- Deploys frozen pending root cause.

**Pitfalls.**
- **"Roll forward" as default policy.** Hope, not a plan. Works until it doesn't, and then causes the second incident.
- **Rollback never drilled.** If you've never done one, you don't have one. Run a quarterly drill (see Phase 07 DR drill).
- **Schema left migrated, code rolled back.** The reason expand/contract (process 8) is mandatory.
- **Skipping canary on the forward fix.** The fastest way to cause a second incident on top of the first.
- **Rollback requires a specific person's key / access.** Bus factor of 1 during an incident.
- **Announced silently.** Others keep merging, next deploy lands on a rolled-back state.

---

## 12) DORA Metrics Measurement & Review

**Purpose.** Measure delivery performance on the two axes the industry research identifies as predictive — throughput and stability — so improvement efforts are grounded rather than aesthetic.

**RACI.** R: platform eng / delivery lead. A: platform eng lead. C: service tech leads. I: engineering leadership, teams.

**Triggers.**
- Service onboarded to production.
- Weekly metrics refresh.
- Monthly / quarterly review.
- Unusual incident or deploy pattern.

**Inputs.**
- Git (for lead time per PR).
- CI / deployment webhooks (for deployment frequency).
- Incident tracker (for change failure rate and failed deployment recovery time).
- Survey instrument for rework rate (the 2024 fifth metric).

**Activities.**
1. Instrument each of the four keys (Google Cloud framing):
   - **Deployment Frequency** — count of successful prod deploys per service per unit time.
   - **Change Lead Time** — median(deploy timestamp − first commit timestamp) per merged PR.
   - **Change Failure Rate** — (deploys that caused a rollback / hotfix / incident) / (total deploys).
   - **Failed Deployment Recovery Time** — median(incident resolved timestamp − incident opened timestamp) for deploy-caused incidents.
2. Add the **rework rate** (2024 fifth metric): periodic survey asking "how many deploys in the last six months addressed a user-facing bug rather than planned work?" Correlate with change failure rate.
3. Aggregate per service and per org.
4. Place each service on the 2024 tier thresholds table (Elite / High / Medium / Low).
5. Review weekly on the platform dashboard; monthly with tech leads; quarterly with engineering leadership.
6. Pick *one* metric to improve per quarter per team, not all four. Throughput and stability must be balanced — gains on one should not come at the other's expense.
7. Look at movement over time, not absolute position. The tier model is not stable year-on-year (2022 had three clusters; 2023 added elite back).

**Outputs.**
- Dashboard with the four keys + rework rate per service.
- Monthly report summarising trend and top constraint.
- One improvement target per team per quarter.

**Tools / templates.**
- GitHub / GitLab / Bitbucket APIs for commit and PR data.
- CI webhooks or deploy events for deployment frequency.
- Incident tracker exports (PagerDuty, Incident.io, FireHydrant, Statuspage).
- Spreadsheet or a lightweight BI stack (Metabase, Superset) — no need for a DORA SaaS on day one.
- "Four Keys" Google Cloud reference implementation as a starting template.

**Cadence / duration.** Weekly refresh (automated). Monthly review: 30–60 minutes. Quarterly review: 60–90 minutes.

**Exit gate.**
- Four keys + rework rate instrumented and visible.
- Each service tiered.
- One improvement target chosen per team per quarter.

**Pitfalls.**
- **Gaming the metrics.** Trivial deploys to inflate frequency; reclassifying rollbacks as "not incidents." Undermines the feedback loop.
- **Individual-level reporting.** These are system metrics, not performance reviews. Attaching them to people distorts behaviour and loses their signal.
- **Single-metric optimisation.** Velocity without stability (or vice versa) is not what the research points to.
- **Stopping at tier labels.** "We're High" is not an improvement. Trend and bottleneck matter more than the label.
- **Conflating failed deployment recovery time with MTTR.** Failed deployment recovery time is deploy-caused-only; MTTR includes other incidents. Do not silently switch definitions.
- **Comparing year-on-year without noting the tier model changed.** The 2022 report had three clusters; 2023 reintroduced Elite. Pick a definition and be consistent.

---

## 13) Phase Exit & Handoff to Phase 07 (Run)

**Purpose.** Close the release loop explicitly — so Phase 07 (Run) inherits a known-good running change with observability and a human who owns it in production.

**RACI.** R, A: change author. C: service tech lead. I: on-call, product, platform.

**Triggers.** Production rollout reaches 100% and has been stable for at least 30 minutes.

**Inputs.**
- Rollout log (from process 6).
- Canary result (from process 7).
- Migration completion status (from process 8, if applicable).
- Changelog / release notes (from processes 9 and 10).
- Observability dashboard for the service.

**Activities.**
1. Confirm all per-release exit items from `06-ship.md`:
   - [ ] CI green — all tests passing, all scans clean.
   - [ ] Canary deployed and healthy for the configured duration.
   - [ ] Metrics unchanged or improved — error rate, latency p99, business SLIs.
   - [ ] Feature flag gated if user-visible.
   - [ ] Rollback plan documented and feasible.
   - [ ] On-call aware.
2. Confirm per-feature exit items (if the release completes a feature):
   - [ ] Flag ramped through the full 1% → 10% → 50% → 100% ladder.
   - [ ] Flag removal PR scheduled within 2–4 weeks.
   - [ ] Any database expand/contract migration completed through the drop step.
   - [ ] Release notes published if customer-visible.
3. Package for Phase 07 (Run):
   - Pointer to the service's SLOs and observability dashboard.
   - Pointer to the runbook (including rollback — process 11).
   - Pointer to on-call rotation and escalation.
   - Any flag still outstanding and when it is due to be removed.
4. Post the #shipped announcement: one line stating what changed, who shipped it, and the rollback mechanism.
5. Notify Phase 08 inputs: product analytics, feedback channels, and anyone watching adoption.

**Outputs.**
- Signed exit checklist.
- Handoff note to Phase 07 with pointers to the run-time artifacts.
- #shipped announcement.

**Tools / templates.**
- A one-page release close-out in the PR / epic.
- The #shipped channel or equivalent.
- Links to runbook, dashboard, on-call, flag register.

**Cadence / duration.** Per release. 10–20 minutes.

**Exit gate.** All per-release checkboxes complete; per-feature checkboxes complete if applicable; handoff note posted.

**Pitfalls.**
- **"Shipped" means merged, not in production.** Stop calling things shipped until they're at 100% and stable.
- **No on-call awareness.** Author walks away; an incident 90 minutes later goes cold to rotation.
- **Flag left at 100% forever.** Debt that compounds.
- **Migration stuck mid-expand-contract.** "Old column still there after six months." Track the drop step.
- **No dashboard pointer in the handoff.** Phase 07 inherits a change it cannot observe.

---

## Release rhythm

A mature Phase 06 is almost invisible — most processes run automatically. A representative "normal week" on a service:

| Day | Cadence |
|---|---|
| Mon–Fri | Multiple merges per engineer → each triggers the full pipeline → production within 30 minutes; canary monitor decides promote or abort; change author watches for 30 minutes post-promote. |
| Mon or Fri | Weekly flag-inventory review: any flag past its target removal date is escalated. |
| Weekly | DORA dashboard refreshed automatically; platform eng reviews top-line numbers. |
| Monthly | DORA review with tech leads; pick or update the per-team improvement target. |
| Quarterly | Environment review; rollback drill; DORA review with leadership; SLSA / SBOM scan of inventory; flag inventory audit. |

Anti-pattern symptoms that mean this rhythm is broken:

- "Release day" or "release captain" → batching risk; deploy more often.
- "No Friday deploys" as a rule → your pipeline isn't trusted; fix it, don't schedule around it.
- "We're waiting for the deploy window" → you have a deploy window; remove it.
- "Just this once, skip the canary" → the fastest way to cause the second incident.

---

## Scale notes

These are the same scale tiers used through the handbook. Everything above is written at the "team of 5" default.

**Solo founder / 1 engineer.**
- Pipeline: GitHub Actions with build + test + deploy on merge to main.
- Canary: "deploy to staging, wait an hour, deploy to prod" is acceptable initially. Aim to automate canary inside the first year.
- Feature flags: env vars or a row in the database — but adopt a managed provider (LaunchDarkly, ConfigCat free tier, Flagsmith self-hosted) as soon as you have real users.
- DORA: just track deploy count and last-incident date in a notes file. The real point is directional.
- Rollback: keep the previous image tag deployable; test it by rolling back once before you need to.
- Goal: get the *shape* right (pipeline, artifact signing, flags, expand/contract) so you add sophistication without rewiring.

**Team of 5 (default).**
- Full pipeline as described in process 1. SLSA L2 via GitHub Actions defaults + cosign.
- Automated canary to staging; manual promote to prod acceptable for a few months, automated within the first year.
- Managed feature-flag provider mandatory.
- Preview environments per PR (Vercel / Netlify / Render / Coolify).
- DORA metrics in a spreadsheet or a lightweight dashboard.
- Rollback drilled once per quarter.

**Team of 20–50.**
- Automated canary to production with automated abort on SLI regression.
- Progressive delivery is the default for user-visible changes; straight-to-100 % is an explicit exception.
- DORA on a real dashboard, per-service tiering, monthly review.
- Platform-level pipeline template; per-service pipelines inherit from it.
- Online schema-change tooling adopted (gh-ost / pg_repack) for tables where `ALTER TABLE` locks matter.
- Flag inventory reviewed weekly; a named owner per flag.

**Team of 500+.**
- Internal Developer Platform owned by a platform team. Per-team pipelines with shared templates; deployment SLOs; self-service canary and rollback.
- SLSA Level 3 for critical services (hardened runners, isolated builds).
- Dedicated release engineering function — but their job is making other teams' deploys safer, not pressing deploy buttons.
- Feature-flag platform is managed service at scale (LaunchDarkly / Statsig / Unleash Enterprise).
- DORA per service, per team, per business unit; the *trend*, not the tier label, is what matters.
- Expand/contract and online migration mandatory on all shared-database changes; DBA consulted as C.

The principle across tiers: the mechanisms are the same, the sophistication scales with blast radius.

---

## Handoff to Phase 07

By the time a release closes, you should be able to hand Phase 07 (Run) a numbered package:

1. The running change, at 100%, with a known deploy identity (image digest + commit SHA).
2. The SLI / SLO definitions for the service (canary used them; Run will continue to).
3. The observability dashboard (metrics, logs, traces) for the service and the change.
4. The rollback mechanism (which primitive, who triggers it, under what SLI conditions).
5. The runbook for the service — including any feature-specific procedures introduced by this change.
6. The on-call rotation and escalation policy that now owns it.
7. Any outstanding feature flags with their target removal date and owner.
8. Any mid-sequence expand/contract migrations still open, with the remaining steps noted.
9. A short close-out note: what shipped, how it rolled out, what was learned.

That package is what Phase 07 inherits. Phase 07's job is to keep that change healthy, reliable, and observable in production — and to feed what it learns back into Phase 02 (planning) and Phase 08 (evolve).
