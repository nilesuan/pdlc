---
name: team composition
description: Roles, responsibilities, and headcount shape for the platform team — AWS + ECS-on-EC2 + Terraform stack
type: operational
---

# Team composition & responsibilities

**Last updated:** 2026-04-24.
**Status:** Advisory/prescriptive. Treat specific headcounts as judgment calls, not research findings.

## Lean shape: 4 people

```
Platform Head (you)
├── Senior Platform Engineer — Cloud & IaC
├── Senior Platform Engineer — CI/CD & DevEx
└── SRE / Observability Engineer
```

### Why 4 is the floor

Three technical seats + a leader is the minimum that covers the production surface of an AWS + ECS-on-EC2 + Terraform platform without one person holding critical single-points-of-knowledge across unrelated domains. At 3, you collapse CI/CD or observability into someone's side-of-desk work and it shows up as outages.

### Why 4 is not sustainable long-term

You are one-deep on every axis. A vacation, illness, or departure stalls a roadmap lane immediately. On-call rotation at 4 people means ~1 week in 3 as primary, which is hot. Promoting to 6–7 buys a healthy pager rotation and parallel roadmap execution.

---

## Role 1 — Platform Head (you)

**Scope:** leadership, architecture, stakeholder interface, budget.

**Responsibilities:**

- **Roadmap & prioritization** — quarterly roadmap, trade-off calls between platform improvements and product-team-requested work
- **Stakeholder management** — interface with product engineering leads, security, finance, compliance, executive leadership
- **Architecture authority** — sign-off on significant Terraform module changes, AWS account structure, ECS cluster boundaries, networking topology
- **Build vs. buy** — vendor decisions (observability platform, CI provider, feature flags, error tracking)
- **Budget owner** — AWS spend, SaaS contracts, headcount approval
- **Hiring & career** — sourcing, interviewing, growth plans, calibration
- **Escalation point** — Sev 0 / Sev 1 incident commander by default until delegated; regulatory or exec escalation path
- **North-star metrics** — owns definition of platform success metrics (DORA four keys, SLOs, cost-per-product-team, developer NPS)

**Time allocation (typical):** ~30% leadership/people, ~30% stakeholder/strategy, ~20% architecture review and decisions, ~20% hands-on when needed. Expect the hands-on portion to shrink as the team grows past 6.

---

## Role 2 — Senior Platform Engineer — Cloud & IaC

**Scope:** everything below the container boundary. The AWS plane and the Terraform that describes it.

**Responsibilities:**

- **Networking** — VPC design, subnets, route tables, Transit Gateway (if multi-VPC), ALB/NLB configuration, Route53, VPC endpoints
- **IAM** — role design, permission boundaries, SCPs if using AWS Organizations, instance profiles, IRSA-equivalent patterns for ECS tasks
- **ECS control plane** — cluster configuration, capacity providers, service definitions, task definitions, autoscaling policies
- **EC2 capacity plane** — AMI pipeline (Packer or EC2 Image Builder), Auto Scaling Groups, launch templates, spot/on-demand mix, instance refresh strategy
- **Secrets & config** — SSM Parameter Store and/or Secrets Manager, rotation, KMS key hierarchy
- **Terraform discipline** — module library, versioning, state backend (S3 + DynamoDB lock), workspace strategy, drift detection, plan review gates
- **Certificates & DNS** — ACM lifecycle, wildcard vs. per-service cert strategy, Route53 automation
- **Disaster recovery** — backup strategy for stateful components, cross-region patterns if required

**Knows deeply:** AWS IAM, VPC networking, ECS task lifecycles, Terraform state management.

**Pairs with:** SRE on capacity and cost; CI/CD engineer on deploy-time Terraform application patterns.

---

## Role 3 — Senior Platform Engineer — CI/CD & DevEx

**Scope:** everything above the container boundary and everything a product engineer touches to ship.

**Responsibilities:**

- **CI/CD pipelines** — GitHub Actions / GitLab CI / CodePipeline (or equivalent), reusable workflows, approval gates, rollback mechanics
- **Container build pipeline** — Dockerfile standards, build caching, multi-arch builds if needed, ECR lifecycle rules, vulnerability scanning integration
- **Deploy orchestration on ECS** — rolling vs. blue/green (CodeDeploy), canary patterns, pre-deploy/post-deploy hooks
- **Developer self-service** — a catalog / portal (Backstage, OpsLevel, or lightweight in-house), service templates, paved roads
- **Service templates** — new-service scaffolds that ship with CI, Terraform, observability wiring, and compliance defaults baked in
- **Feature flag platform** — integration with LaunchDarkly / Unleash / in-house; patterns for safe progressive delivery
- **Supply chain** — artifact signing (cosign / sigstore), SBOM generation, provenance attestation
- **Local dev experience** — standardized dev environments, secret injection for local, docker-compose or devcontainer patterns

**Knows deeply:** CI/CD pipeline design, container packaging, developer workflow ergonomics.

**Pairs with:** Cloud engineer on deploy-time infra changes; product engineering on golden-path adoption.

---

## Role 4 — SRE / Observability Engineer

**Scope:** production health visibility, reliability practice, cost awareness.

**Responsibilities:**

- **Metrics** — CloudWatch + Prometheus/Grafana or Datadog/New Relic; dashboards for cluster, service, and business KPIs; metric naming conventions
- **Logs** — CloudWatch Logs + OpenSearch, or vendor equivalent; log retention policy; structured logging standards product teams adopt
- **Traces** — OpenTelemetry instrumentation standards, X-Ray or vendor trace backend, service-map health
- **Alerting** — rule authorship, alert routing, suppression during deploys, symptom-based vs. cause-based alert discipline
- **SLOs** — define per-service SLOs with product teams, error budget policy, quarterly SLO review
- **On-call tooling** — PagerDuty or Opsgenie configuration, rotation management, escalation policies
- **Incident response** — incident commander during Sev 1+, coordinates technical response, runs incident channel
- **Postmortem process** — facilitates blameless postmortems, tracks action items, feeds learnings back into runbooks and alerts
- **Cost observability** — Cost Explorer hygiene, CUR (Cost and Usage Report) pipeline into the data warehouse if one exists, per-team/per-service cost allocation, right-sizing recommendations
- **Capacity forecasting** — ahead-of-need scaling plans, saved-plan/reserved-instance strategy

**Knows deeply:** observability tooling, production debugging, incident command, SRE fundamentals.

**Pairs with:** Cloud engineer on capacity & cost; CI/CD engineer on deploy-time safety (canary metric gates, rollback triggers).

---

## Shared responsibilities (distributed across the 3 ICs)

These do not map cleanly to one seat at 4 people; they rotate or are co-owned.

- **Security** — patching cadence, CVE triage, IAM audit, secret rotation review. Promote to a named half-FTE role when compliance work starts (SOC 2 Type II, PCI, HIPAA).
- **Documentation** — every engineer writes; Platform Head enforces a rule that no feature lands without the runbook/usage doc.
- **Runbook authorship** — the engineer who shipped the alert writes the runbook. No orphan alerts.
- **Quarterly DR test** — rotating ownership; scripted drill against a staging region/cluster.
- **Onboarding product teams onto the platform** — lead varies by what they need most (Cloud & IaC if infra-heavy, CI/CD if shipping-heavy).

---

## Expansion path: 4 → 6–7

When to grow the next seat and why:

| Trigger | Add | Rationale |
|---|---|---|
| Pager rotation hurts (attrition risk, frequent interrupts) | 2nd SRE | 4-person rotation → 5-person; night coverage becomes viable |
| Terraform backlog persistently 1 quarter behind | 2nd Cloud & IaC engineer | One focuses on foundational (networking, IAM, ECS), other on self-service/modules |
| Product teams complain about onboarding, docs, templates | Dedicated DevEx engineer (pulled out of CI/CD seat) | Paved roads and portal need sustained ownership; CI/CD engineer returns to pure pipeline work |
| Compliance audit in flight (SOC 2 / PCI / HIPAA) | Dedicated Security/Platform engineer | Evidence collection, control mapping, audit interface is a named job |
| Data or ML workloads become a first-class platform concern | Data Platform engineer (separate from app platform) | Different tooling (EMR / Glue / Airflow / dbt / warehouse), different SLOs, different cost profile |

**Do not merge data-platform work into the 4-person app-platform team.** The cognitive load is different and the on-call shape is different; forcing the merge burns out the team.

---

## Anti-patterns to avoid

- **"Full-stack platform engineer" at scale** — works at 4 people because everyone must generalize. Past 6 it becomes a dodge for underinvesting in specialization.
- **Security as everyone's job and no one's job** — at 4, the Platform Head must actively own the security calendar (patch cadence, IAM review, secret rotation) until a named role exists.
- **DevEx as a side-of-desk task** — if product teams are the customer, there must be sustained investment in their experience. Treating it as "what we do when there's time" means it never gets done.
- **Platform team that treats product teams as tickets** — the relationship should be consultative. Office hours, embedded rotations, paved-road design partnerships — not a request queue.
