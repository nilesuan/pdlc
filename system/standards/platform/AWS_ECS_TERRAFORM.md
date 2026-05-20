# AWS_ECS_TERRAFORM.md — Production stack patterns

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §1–3 (Naming / AWS limits / Tags), §4 (Terraform and infrastructure repository model), §5 (Secrets and configuration), §7 (Networking), §8 (Container images), §10 (Security baseline); [`../../../NOTES.md`](../../../NOTES.md) (production stack: AWS + ECS on EC2 + Terraform).

## The stack (one-line summary)

**AWS** as cloud, **ECS on EC2** as compute, **Terraform** as IaC, **GitLab** as repo + CI, **OIDC** for cloud access, **single shared CI runner** with role-assumption per repo.

Per the user's NOTES.md and developer-guidelines.md. Other choices (Fargate, EKS, ECS Anywhere) need an ADR explaining why this stack does not fit.

## ECS on EC2 — hard rules

1. **One service = one task definition family.** Different services do not share family names.
2. **Task definitions reference images by digest** (`@sha256:...`), not tags. See [`../release/CONTAINER_TAGGING.md`](../release/CONTAINER_TAGGING.md).
3. **Capacity providers, not raw ASGs in the cluster definition.** Use ECS capacity providers (managed scaling) with managed termination protection.
4. **awsvpc network mode** for production services (per-task ENI, security group per task). `bridge` mode reserved for legacy.
5. **No `host` network mode.**
6. **Healthcheck on every task definition.** Either container-level `HEALTHCHECK` or ALB target group health check; preferably both.
7. **Capacity provider strategy diversified** (mix of on-demand + spot where workload tolerates spot interruption).
8. **Graceful shutdown.** `stopTimeout` on the container ≥ shutdown drain time. Apps trap `SIGTERM` and finish in-flight requests.
9. **Container resource limits set** (CPU, memory). Memory hard limit; CPU as reservation.

## ALB / target group rules

1. **One target group per service.** Target group binds to ECS service.
2. **Target group naming respects 32-char limit.** Per [`AWS_NAMING.md`](AWS_NAMING.md).
3. **Health check path is a real endpoint** (returns dependency status), not just `/`. Default `/health` or `/ready`.
4. **Slow-start enabled** for services with cold caches.
5. **Deregistration delay tuned to in-flight request lifetime** (30s default; longer for streaming).

## IAM rules

1. **Roles, not users.** Long-lived IAM users for service-to-service access are forbidden. Use task roles.
2. **Task role and task execution role distinct.** Execution role = pull image, write logs. Task role = what the app calls.
3. **Least privilege on every policy.** No `*:*`. Resource ARNs scoped where possible.
4. **OIDC trust for CI access.** GitLab CI assumes a role via OIDC; no long-lived AWS keys in CI variables. Per developer-guidelines §10 (Security baseline) and §4 (Terraform repository model — single CI runner with role-assumption).
5. **Service-control policies (SCPs) at org level** for guardrails (e.g., region restrictions, no public S3 buckets without explicit allow).
6. **Permission boundaries on roles created by application code.**

## Networking

1. **Private subnets for compute; public subnets only for ALB/NAT.** No EC2/ECS instances in public subnets.
2. **Security groups by service, not by environment.** A "prod-allow-all" SG is a blocker.
3. **VPC endpoints for AWS APIs** (S3, ECR, DynamoDB, Secrets Manager) so traffic does not traverse the internet gateway.
4. **No `0.0.0.0/0` ingress on application security groups.** Only ALBs and bastions accept public ingress.
5. **NACLs are coarse; security groups are fine.** Don't try to manage app-level rules in NACLs.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Long-lived IAM access keys for service-to-service calls | Blocker |
| `*:*` IAM policy | Blocker |
| EC2 / ECS task in a public subnet | Major |
| `0.0.0.0/0` ingress on app SG | Blocker |
| Image referenced by tag (not digest) in task definition | Blocker |
| `host` network mode | Major (not allowed) |
| No healthcheck on task definition + target group | Major |
| Container resource limits absent | Major |
| Log group missing (no CloudWatch logs from container) | Major |
| Public S3 bucket without explicit ADR | Blocker |
| RDS / EBS not encrypted at rest | Major |
| Secret in `environment` block of task definition (vs Secrets Manager / SSM) | Blocker |

## Logs and metrics

- `awslogs` driver → CloudWatch Logs. Log group per service. Retention set explicitly (default no-retention is a cost trap).
- Metrics: ECS Container Insights enabled.
- Trace: OpenTelemetry sidecar or in-process exporter to OTLP collector. See [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).

## Anti-patterns to flag

- "We'll start with ECS Fargate then move to EC2 later" — pick one. Migrating ECS launch types after the fact has gotchas around networking and IAM that bite.
- Long-running EC2 in the cluster that is treated as a pet (SSH keys, manual config). Treat container hosts as cattle; image bakes via golden AMI.
- Cross-account IAM via `*` resource. Scope by account ID.
- Mixing app and DB on the same task. Run RDS / Aurora / DynamoDB; do not run a database in an ECS task for production.

## Sources

- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §1–8, §10 (covers naming, tags, Terraform model, secrets, observability, networking, container images, and security baseline).
- AWS ECS Best Practices Guide (docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/).
- AWS Well-Architected Framework — Operational Excellence and Security pillars.
- AWS Security Reference Architecture (docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/).
