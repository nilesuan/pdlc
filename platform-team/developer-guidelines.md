---
name: developer guidelines
description: Guidelines the platform team publishes to developers consuming the platform — naming, AWS limits, tagging, Terraform, observability, security
type: operational
---

# Platform → Developer Guidelines

**Audience:** Product engineers building services that run on the platform.
**Stack:** AWS, ECS on EC2, Terraform.
**Status:** Living document. Owned by the platform team. Breaking changes follow the deprecation policy in §14.
**Last updated:** 2026-04-24.

## How to use this document

This is the contract between the platform team and the teams that consume the platform. When you build a new service, scan this from top to bottom — everything here is either a hard rule (the platform will reject non-compliant resources) or a strong default (deviate consciously, document the deviation in an ADR).

AWS character limits cited below are from AWS documentation and are stable, but verify against current AWS docs for any edge case. If a limit has changed, file a platform ticket.

---

## 1. The master naming schema

Every platform-managed resource follows one pattern:

```
<env>-<service>-<component>[-<qualifier>]
```

- `env` — one of `prod`, `stage`, `dev`, `sandbox`. No variations (no `production`, no `staging`).
- `service` — the service name in kebab-case. Max 20 characters. Must match the repo name minus the org prefix.
- `component` — the resource's role within the service. Examples: `api`, `worker`, `queue`, `db`, `cache`, `bucket`.
- `qualifier` — optional; used when a service has multiple instances of the same component. Example: `-us` / `-eu` for region, `-read` / `-write` for replica roles.

**Examples:**

```
prod-billing-api           # ALB target group
prod-billing-worker        # ECS service
prod-billing-events        # SQS queue
stage-billing-db           # RDS instance identifier
dev-checkout-api-ephemeral # feature-branch ephemeral env
```

**Why kebab-case everywhere:** works under every AWS service's character set (hyphens are universally allowed; underscores and periods are not). One convention everywhere is worth more than a "correct" convention per service.

### Service name constraints

- Lowercase `a-z`, `0-9`, `-` only.
- Must start with a letter.
- **≤ 20 characters.** This is the binding constraint — an ALB name is capped at 32 chars, a target group at 32 chars, and we need room for `<env>-<service>-<component>`. With `prod-` (5) + `-component` (up to 7) = 12 chars reserved, service gets ≤ 20.
- Must not collide with an existing service (namespace is flat across the org).

---

## 2. AWS resource naming & character limits

Binding limits you must stay within. The master schema was designed so that a service with a 20-char name fits every limit below.

| Resource | Max name length | Allowed chars | Notes |
|---|---|---|---|
| S3 bucket | **3–63** | `a-z 0-9 -` | **Globally unique across all AWS.** No uppercase, no underscores, must not look like an IP. Use `<org>-<env>-<service>-<purpose>` e.g. `acme-prod-billing-invoices`. |
| ECR repository | 2–256 | `a-z 0-9 - _ . /` | Use `<service>/<component>`, e.g. `billing/api`. |
| ECS cluster | ≤ 255 | `A-Z a-z 0-9 - _` | One cluster per environment by default (`prod-apps`, `stage-apps`). |
| ECS service | ≤ 255 | `A-Z a-z 0-9 - _` | `<env>-<service>-<component>`. |
| ECS task definition family | ≤ 255 | `A-Z a-z 0-9 - _` | Same as ECS service name. |
| ALB / NLB | **1–32** | `A-Z a-z 0-9 -` | Tightest common limit. Must not start/end with hyphen. |
| Target group | **1–32** | `A-Z a-z 0-9 -` | Same. |
| Security group name | ≤ 255 | broad | Use Name tag for human readability; the actual `group-name` is set once at creation. |
| IAM role | ≤ 64 | `A-Z a-z 0-9 + = , . @ _ -` | `<env>-<service>-<component>-role`. |
| IAM policy | ≤ 128 | same as role | `<env>-<service>-<component>-policy`. |
| IAM instance profile | ≤ 128 | same | Typically one per role, same name as role. |
| Lambda function | 1–64 | `A-Z a-z 0-9 - _` | Rare in our platform; when used, follow master schema. |
| DynamoDB table | 3–255 | `A-Z a-z 0-9 - _ .` | `<env>-<service>-<entity>`. |
| SQS queue | 1–80 | `A-Z a-z 0-9 - _` | Add `.fifo` suffix for FIFO queues (counts toward limit). |
| SNS topic | 1–256 | `A-Z a-z 0-9 - _` | |
| CloudWatch log group | 1–512 | broad (`A-Z a-z 0-9 _ - / . #`) | Standard path: `/ecs/<env>/<service>/<component>`. |
| Secrets Manager secret | 1–512 | `A-Z a-z 0-9 / _ + = . @ -` | Standard path: `/<env>/<service>/<name>`. |
| SSM Parameter Store | 1–2048 | `A-Z a-z 0-9 _ . - /` | Same path convention as secrets. Non-secret config goes here. |
| KMS alias | 1–256 | `A-Z a-z 0-9 / _ -` | Prefixed with `alias/`. `alias/<env>-<service>`. |
| RDS DB instance identifier | 1–63 | `A-Z a-z 0-9 -` | Must start with a letter, cannot end with hyphen, no consecutive hyphens. |
| ElastiCache cluster ID | 1–40 | `A-Z a-z 0-9 -` | Tighter limit — `<env>-<service>-cache`. |
| Launch template | 3–128 | broad | Typically one per service. |
| Auto Scaling group | ≤ 255 | broad | Typically one per ECS cluster, managed by platform. |
| Route53 record | ≤ 253 (DNS rule) | DNS-valid | `<service>.<env>.<domain>`, e.g. `billing.prod.internal.acme.com`. |

**Rule of thumb:** if a resource's name is near its limit, the name is wrong. Shorten the service name or the qualifier before shortening the `env` or `component`.

---

## 3. Required tags

Every platform-managed AWS resource **must** carry these tags. The platform Terraform modules apply them automatically; if you create a resource outside the modules, you own the tagging.

| Tag key | Allowed values | Purpose |
|---|---|---|
| `Environment` | `prod` \| `stage` \| `dev` \| `sandbox` | Must match the `env` in the resource name. |
| `Service` | service name (kebab-case, ≤ 20 chars) | Must match the `service` in the resource name. |
| `Component` | e.g. `api`, `worker`, `db`, `queue` | Must match the `component` in the resource name. |
| `Team` | team slug (kebab-case), e.g. `billing`, `growth` | The team that owns the service, not the person. |
| `Owner` | email or Slack channel | Primary contact. `#team-billing` or `billing-eng@acme.com`. |
| `CostCenter` | accounting code | Provided by finance. Drives chargeback. |
| `ManagedBy` | `terraform` \| `manual` | `manual` is allowed only for emergency interventions and must be reconciled back to Terraform within 1 week. |
| `DataClassification` | `public` \| `internal` \| `confidential` \| `restricted` | Applies to any resource that stores data. Defaults to `internal` if unspecified. |

**Optional but encouraged:**

- `Version` — Git SHA or semver of the code running in the resource.
- `ExpiresAt` — ISO 8601 date. Resources with this tag past their date are candidates for cleanup. Useful for `sandbox`/`dev` ephemeral stacks.

**Rules:**

- Tag values are case-sensitive. The platform's cost and compliance queries assume exact match.
- Never include PII or secrets in tag values; tags are widely readable.
- `prod` resources without `Owner` and `CostCenter` will be flagged by the platform's daily tag-drift scan.

---

## 4. Terraform and the infrastructure repository model

IaC lives **outside** the service repositories. Each stream owns a dedicated infrastructure repository, and only one GitLab runner has AWS credentials. Together these enforce a hard boundary between application code and cloud mutation.

### 4.1 Repository topology

IaC repos are split along two axes: **system** (the functional domain — `iam`, `billing`, `checkout`) and **lifecycle** (shared foundations vs. workload-specific). Each system gets a `-core` repo for long-lived shared resources and one `-<component>` repo per deployable component.

```
<org> (GitLab)
└── infrastructure/                      # GitLab group
    │
    ├── tf-modules/                      # standalone modules repo (see §4.7)
    │                                    # reusable Terraform modules; consumed
    │                                    # by every -core and -<component> repo
    │
    ├── iam-core/                        # foundations for the iam system
    ├── iam-permify/                     # Permify-specific resources
    ├── iam-<other-component>/
    │
    ├── billing-core/
    ├── billing-api/
    ├── billing-worker/
    │
    ├── checkout-core/
    └── checkout-api/
```

There are three repo categories and they do not blur:

- **`tf-modules`** — **one standalone repo.** Contains reusable Terraform modules only. No environment-specific code, no resource instances, no consumer logic. Owned by the platform team (see §4.7).
- **`<system>-core`** — consumes modules; provisions shared foundations.
- **`<system>-<component>`** — consumes modules; provisions workload-specific resources; reads `-core`'s published SSM outputs.

**What goes in `<system>-core`:** shared, long-lived, rarely changed — resources that outlive any single component revision. Provisioned once; carefully evolved.

- Data stores shared across components: RDS clusters, ElastiCache clusters, shared DynamoDB tables
- ECR repositories (cross-env, cross-component by nature)
- KMS keys (system-scoped)
- Cognito user pools, IAM Identity Center assignments
- VPC primitives if the system has its own VPC (otherwise this lives in a platform-level `network-core` repo)
- Shared SSM parameter hierarchy that components read from
- Base IAM roles and policies reused across components
- Core observability: shared dashboards, cross-component alarms, log-group retention policies

**What goes in `<system>-<component>`:** workload-specific — tied to one deployable unit and expected to change at deploy cadence.

- ECS services, task definitions, container definitions
- Component-specific IAM roles (task role, execution role)
- Component-scoped SQS queues, SNS topics, EventBridge rules
- ALB target groups, listener rules, Route53 records for this component
- Component-specific SSM parameters and Secrets Manager entries
- Component-specific CloudWatch alarms tied to its SLOs
- Auto-scaling policies keyed to this component's load

**The lifecycle test:** if the resource is likely to survive a full rewrite of a component, it belongs in `-core`. If it ceases to exist when the component is deprecated, it belongs in `-<component>`.

**Why split this way:**

- **Blast radius.** A bad MR in `iam-permify` cannot drop the shared RDS — different repo, different state, different approvers.
- **State scope.** Smaller states → faster `plan` → less lock contention on the shared runner.
- **Review cadence.** `-core` is quiet and careful; `-<component>` is busy and fast. Different reviewer pools naturally.
- **Reusability.** `<system>-<component>` is effectively a blueprint; spinning up a second region or tenant is parameterize-and-fork.
- **Cognitive load.** Engineers working on one component see only that component's world.

**Tradeoffs to accept:**

- **More repos.** A system with 4 components has 5 infra repos. Runner-pipeline concurrency and repo-management overhead both go up — mitigate with sensible pipeline caching and with a pool of `infra-aws` runner agents, not a single agent.
- **Cross-repo references.** `-<component>` must read outputs from `-core`. Rules for this in §4.3.
- **Migration between repos is privileged.** Moving a resource from `-<component>` to `-core` (or vice versa) requires `terraform state mv` across states, which is a CI-only platform-ticket operation. Get the split right at creation time.

### 4.2 The single-runner model (AWS access isolation)

**Exactly one GitLab runner has AWS write access.** This runner:

- Is registered at the GitLab group level, scoped to `infrastructure/*`.
- Is tagged `infra-aws`.
- Federates to AWS via GitLab → AWS IAM OIDC. The IAM trust policy pins the OIDC subject to this runner's group/project scope — no other GitLab project can assume the role.
- Holds **two distinct IAM roles**, selected by pipeline stage via OIDC claim:
  - `infra-readonly` for `plan` and drift detection
  - `infra-write` for `apply`

**No other runner, no personal laptop, no application-CI pipeline ever holds AWS write credentials.** This is the invariant the model protects.

Consequences developers should expect:

- IaC pipelines are queued on the `infra-aws` runner and may wait behind other streams' pipelines. Capacity is monitored by the platform team; see §13 if wait times become a problem.
- Running `terraform apply` on a laptop against `prod`/`stage` is rejected at the IAM layer. This is intentional.

### 4.3 Per-repo layout

Both `<system>-core` and `<system>-<component>` repos use the same shape:

```
<system>-<core|component>/
├── environments/
│   ├── prod/
│   │   ├── main.tf        # module invocations
│   │   ├── backend.tf     # platform-generated
│   │   ├── variables.tf
│   │   └── outputs.tf     # publish outputs consumers will read
│   ├── stage/
│   └── dev/
├── .gitlab-ci.yml         # includes the platform's shared IaC pipeline template
├── CODEOWNERS             # owners + platform engineer
├── README.md              # what this repo owns; which other repos consume its outputs
└── docs/
    └── architecture.md    # ADRs for significant infra choices
```

**State backend:**

- S3 + DynamoDB lock, platform-managed.
- Key: `infra/<system>/<core|component>/<env>/terraform.tfstate`. Example: `infra/iam/core/prod/terraform.tfstate`, `infra/iam/permify/prod/terraform.tfstate`.
- One state file per env per repo. Never share state across repos.

**CI template:** every repo's `.gitlab-ci.yml` must `include:` the platform-provided IaC template. Local definitions that bypass the template fail the MR policy check — the template is what enforces the single-runner model and the approval gates.

### 4.4 Cross-repo references: how `-<component>` reads `-core`

Components need outputs from their `-core` repo (RDS endpoint, ECR repo URL, KMS key ARN, shared subnet IDs). The platform provides one blessed mechanism for this and forbids the fragile ones.

**Required pattern — SSM Parameter Store as the contract:**

1. `<system>-core` **writes** its outputs to SSM under a published path:

   ```
   /infra/<system>/core/<env>/<output-name>
   ```

   Example: `/infra/iam/core/prod/rds-endpoint`, `/infra/iam/core/prod/kms-key-arn`.

2. `<system>-<component>` **reads** those params at plan time via `data "aws_ssm_parameter"`:

   ```hcl
   data "aws_ssm_parameter" "rds_endpoint" {
     name = "/infra/iam/core/${var.env}/rds-endpoint"
   }
   ```

3. The `<system>-core` repo's `README.md` documents every parameter it publishes — name, type, consumers. This is the contract.

**Why SSM parameters and not `terraform_remote_state`:**

- `terraform_remote_state` couples two states at plan time. Refactors in `-core` can silently break `-<component>` plans.
- SSM parameters are a stable, named contract. Renaming an internal resource in `-core` without changing the published parameter name costs nothing downstream.
- Parameter changes are observable in CloudTrail and can drive alarms ("someone changed the RDS endpoint param outside of CI").
- Components can run `plan` without any permission to read other repos' state buckets.

**Forbidden patterns:**

- **`terraform_remote_state` across repos.** The only permitted use is within a single repo across its own environments (rare and still discouraged).
- **Hardcoding values from `-core` into `-<component>`.** The moment `-core` rotates something, `-<component>` drifts silently.
- **Data lookups by tag or name convention** (`data "aws_db_instance" { ... }`). Works but is brittle — a name collision or a tag drift breaks it. Use the published SSM contract.

### 4.5 CI pipeline contract

| Stage | Runner | Trigger | AWS role |
|---|---|---|---|
| `fmt` / `validate` / `tflint` | any shared runner | every push | none |
| `plan` | **`infra-aws`** | every MR + main | `infra-readonly` |
| `apply (dev)` | **`infra-aws`** | merge to `main` | `infra-write` (auto) |
| `apply (stage)` | **`infra-aws`** | merge to `main` + manual trigger | `infra-write` |
| `apply (prod)` | **`infra-aws`** | merge to `main` + manual trigger + approvals | `infra-write` |
| `drift-detect` | **`infra-aws`** | scheduled daily | `infra-readonly` |

MR approval requirements for `apply` to reach `main`:

- **`dev`:** 1 reviewer from CODEOWNERS.
- **`stage`:** one CODEOWNER.
- **`prod`:** one CODEOWNER **and** a platform engineer. Approval thresholds are stricter for `-core` repos: any `prod` MR there requires a platform engineer regardless of change size, because the blast radius touches multiple components.

### 4.6 Developer local workflow

- **Local `terraform plan` is supported** using read-only AWS credentials from your SSO profile. Every engineer can plan; no engineer can apply to `prod`/`stage`.
- **Local `terraform apply` against `prod`/`stage` is rejected** at the IAM layer by design.
- `dev` local apply is permitted for sandbox-scale exploration but discouraged for anything that will persist — prefer the CI path so the state stays authoritative.
- State manipulation (`terraform state rm`, `terraform import`, `terraform taint`) is **CI-only on the privileged runner** and requires a platform-team ticket. This applies doubly to cross-repo state moves (migrating a resource between `-core` and `-<component>`).

### 4.7 The `tf-modules` repository

A **standalone repository** — `<org>/infrastructure/tf-modules`. Contains reusable Terraform modules only; no environment-specific code, no resource instances, no consumer logic. Owned by the platform team; PRs accepted from any engineer subject to platform review.

#### Repo layout

```
tf-modules/
├── README.md                    # module catalog; one-line description per module
├── modules/
│   ├── ecs-service/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf          # required_providers, required_version
│   │   ├── README.md            # generated by terraform-docs
│   │   ├── CHANGELOG.md         # module-specific changelog
│   │   └── examples/
│   │       └── basic/           # a compiling, validating minimal example
│   ├── rds-postgres/
│   ├── alb/
│   ├── sqs-queue/
│   ├── ecr-repo/
│   └── ...
├── tests/                       # Terratest / terraform test suites
└── .gitlab-ci.yml               # lint, validate, examples, tests
```

One module per directory under `modules/`. Cross-module composition happens in consumer repos, not inside the modules repo.

#### Authoring rules

- **Module README.md** is generated by `terraform-docs` and covers inputs, outputs, required providers, and a minimal usage example. Regenerated on every PR; the PR pipeline fails if it is out of date.
- **Every module has at least one `examples/<name>/`** directory that compiles and passes `terraform validate`. CI runs every example on every PR. A module without an example is not a module — it's draft code.
- **No `provider` blocks inside modules.** Providers are configured by consumer repos. Modules declare `required_providers` in `versions.tf`.
- **No hardcoded env/account/region values.** All context flows in via variables.
- **No data sources that reach outside the module's explicit inputs.** A module must not read an SSM parameter by a guessed path — the consumer passes in what is needed.
- **Required variables have no defaults.** Optional variables have safe defaults and are documented.
- **Outputs are explicit.** No "everything the module created"; only what consumers will legitimately read.

#### Versioning

- **Per-module tags, per-module semver.** Tag format: `<module-name>-v<major>.<minor>.<patch>` (e.g., `ecs-service-v1.4.0`).
- **Major** = breaking change (removed inputs, renamed outputs, behavior shift requiring state migration).
- **Minor** = new optional inputs/outputs, additive features.
- **Patch** = bug fixes, no interface change.
- Each module also maintains its own `CHANGELOG.md`. Tags are created by the release pipeline, not by hand.

#### Consumer pinning

```hcl
module "api" {
  source = "git::https://gitlab.acme.com/infrastructure/tf-modules.git//modules/ecs-service?ref=ecs-service-v1.4.0"
  # ...
}
```

- **Always pin to a tag.** Never `ref=main`. Never a branch. The MR policy check in consumer repos rejects unpinned or branch-ref sources.
- The platform publishes a quarterly **recommended versions** bulletin listing the current stable minor for each module. Consumers track within one minor of current within 90 days; older pins are flagged on the platform dashboard.

#### Testing

- **Every PR** runs `terraform fmt -check`, `terraform validate`, `tflint`, and `tfsec` (or `checkov`) on every module.
- **Every example** is compiled and validated.
- **Critical modules** (the ones hosting stateful or network-boundary resources — `rds-postgres`, `ecs-service`, `alb`, `kms-key`) additionally have Terratest integration tests that provision real resources in a dedicated `sandbox` AWS account and assert behavior. These run on MR and nightly on main.
- Security findings from `tfsec`/`checkov` block merge unless explicitly exempted in the PR with a comment citing the reason and a platform-engineer approval.

#### Breaking change policy

- Major version bumps are announced **2 weeks before release** in `#platform-announcements`, with a migration guide in the module's `CHANGELOG.md`.
- The previous major stays tagged and available. It receives **security patches for 6 months** after the new major ships; after that it is considered end-of-life and consumers still on it get escalation on the dashboard.
- Consumers migrating to a new major get platform office-hours support.

#### What belongs in a module vs. in a consumer repo

- **In a module:** patterns instantiated across **2+ consumer repos** with substantially the same shape. An `ecs-service` module that 30 components use is obviously a module.
- **Not in a module:** one-off configurations, thin wrappers around a single resource, anything used by exactly one consumer. Premature modularization costs more than it saves — it creates a coupling point where none is justified.
- **The test:** before abstracting a pattern into a module, write the second consumer. If the second consumer's requirements diverge meaningfully, it probably wasn't the same pattern.

#### Why modules live in a single repo, not per-module repos

- **Atomic cross-module changes.** A change to a shared helper (or a provider version bump that affects every module) is one PR, not N coordinated PRs across N repos.
- **Uniform tooling.** One CI config, one test harness, one lint rule set. Per-module repos make this drift.
- **Discoverability.** One place to browse the module catalog. Engineers don't have to know module names in advance.

**Do not fork `tf-modules`.** Forks diverge immediately; the platform cannot patch CVEs across forks. If a module doesn't fit your use case, open an issue or a PR against `tf-modules` itself.

### 4.8 Variable and output naming

- Variables: `snake_case`, required variables have no default.
- Outputs: `snake_case`, prefix with the module role (`api_url`, `db_endpoint`).
- Never output secrets directly. Output Secrets Manager ARNs and let consumers read the secret at runtime.
- `-core` repos must also **publish outputs to SSM** per §4.4 for cross-repo consumption. A `-core` output that isn't in SSM isn't part of the contract.

### 4.9 Plan discipline

- Every change goes through MR review; see §4.5 for approval thresholds.
- A plan that shows **replacement** on a stateful resource (RDS, ElastiCache, S3, EBS) requires explicit sign-off from a CODEOWNER **and** a platform engineer, recorded in the MR. In `-core` repos this is automatic — all stateful resources there are shared.
- Any plan that adds or modifies IAM policies or roles requires a platform engineer's approval regardless of resource type.
- `terraform destroy` is never part of a normal pipeline. Removal flows through delete-resource MRs that let Terraform remove specific resources on the next `apply`.
- Changes to SSM parameters under `/infra/<system>/core/<env>/*` are contract changes. Treat them as breaking changes — bump the consumer repos' MRs in lockstep or use additive-then-deprecate (publish the new param, migrate consumers, remove the old) rather than rename-in-place.

### 4.10 Break-glass

For genuine emergencies (the `infra-aws` runner is unhealthy during an active incident, a critical prod change cannot wait):

- A named platform engineer holds a break-glass IAM role requiring MFA step-up **and** a second platform engineer's approval in a dedicated Slack channel.
- Every break-glass use is logged to an append-only audit stream and reviewed at the next incident review.
- Changes made via break-glass must be reconciled back into the stream IaC repo within 48 hours, or the resources are flagged as drifted and the owning stream is paged.
- Break-glass is not a workflow shortcut. Using it for convenience rather than emergency is a Sev 2 process violation.

---

## 5. Secrets and configuration

### Where things go

| Data | Location | Notes |
|---|---|---|
| Runtime config (non-secret) | SSM Parameter Store | e.g. feature flags, service URLs, numeric tunables. |
| Secrets (credentials, tokens, keys) | Secrets Manager | Rotation required for DB creds and third-party API keys. |
| Build-time config | Environment variables set in CI | Baked into the task definition, never into the image. |
| Per-environment differences | Terraform variables | Not runtime config. If it changes without a deploy, it's runtime. |

### Paths

```
/<env>/<service>/<name>
```

Examples:
- `/prod/billing/stripe-api-key` (Secrets Manager)
- `/prod/billing/max-refund-amount` (Parameter Store)

### Access control

- An ECS task's role has read access to `/<env>/<service>/*` and nothing else by default.
- Cross-service secret access must be explicit, time-boxed, and reviewed — file a platform ticket.
- Never print secrets to logs. The platform log sink has scanners that will page on detected patterns (AWS keys, Slack tokens, PEM blocks); repeated violations trigger an automated service lockout.

### What must never happen

- Secrets in Git, even in `.env.example`. Use placeholder strings like `REPLACE_ME`.
- Secrets in Docker image layers. Fetch at runtime.
- Long-lived AWS access keys for services. Use IAM roles (IRSA-equivalent for ECS: task role).

---

## 6. Observability requirements

Services consuming the platform must emit these signals in these shapes. Non-compliant services will be visible in the platform's observability-compliance dashboard; prod deploys will be blocked after a 30-day grace period.

### Logs

- **Format:** JSON lines on stdout. One event per line. The ECS awslogs driver ships them to CloudWatch.
- **Required fields:** `timestamp` (ISO 8601 UTC), `level` (`debug`|`info`|`warn`|`error`), `service`, `env`, `trace_id`, `span_id`, `message`.
- **Do not** log PII or secrets. If user data must be referenced, use stable non-PII identifiers (hashed IDs, not email).
- Retention defaults: `prod` 90 days, `stage` 30 days, `dev` 7 days. Longer retention (e.g. audit) requires a platform ticket and a data-classification review.

### Metrics

- Emit via OpenTelemetry to the platform collector. Prometheus-scrape endpoints on `:9090/metrics` for services that prefer pull.
- **Metric naming:** `<service>_<component>_<metric>_<unit>`. Example: `billing_api_request_duration_seconds`.
- Histograms preferred over gauges for latency.
- Cardinality cap: no more than 10 labels per metric; label values must be bounded (never user IDs, never free-text).

### Traces

- **Required.** OpenTelemetry SDK, OTLP export to the platform collector endpoint.
- Propagate W3C `traceparent` headers across every HTTP call, internal or external.
- Sampling is managed at the collector. Do not hardcode sampling rates in services.

### SLOs

- Every service that is customer-facing or on the critical path defines at least one SLO: a latency SLO and an availability SLO at minimum.
- SLO definitions live in the service's repo as code (`slo.yaml` per platform template) and are consumed by the platform's SLO dashboard pipeline.

---

## 7. Networking

### Ports

| Port | Purpose |
|---|---|
| `8080` | Application HTTP |
| `8081` | Admin / ops endpoints (health, readiness) — not exposed to ALB |
| `9090` | Prometheus metrics |
| Others | Must be documented in the service README and in the task definition |

### Health checks

- `GET /healthz` — liveness. Returns 200 when the process is alive. Must not check dependencies.
- `GET /readyz` — readiness. Returns 200 only when the service can serve traffic (DB reachable, migrations complete, caches warm).
- Both endpoints on port 8081.
- ALB health check targets `/readyz`.

### Service-to-service communication

- Internal services communicate via service discovery (Cloud Map) at `<service>.<env>.internal.acme.com`.
- TLS is terminated at the ALB; internal hop is TLS where supported, plaintext within the VPC where cost matters. Platform provides `tls_from_consumer` Terraform flag.
- No direct calls across environment boundaries (`prod` → `stage` etc.). If this is needed, the answer is almost always "move the test data into `stage`."

### External exposure

- Public-facing services sit behind a platform-managed ALB + CloudFront.
- WAF rules are centrally managed; service-specific rules go through a platform ticket.
- Public DNS goes through the platform's Route53 zone, not a service-owned one.

---

## 8. Container images

- **Base image:** must be one of the platform-approved bases (`platform/base-node`, `platform/base-python`, `platform/base-go`, `platform/base-java`, etc.). Non-approved bases require a security review.
- **Non-root user.** Services must run as a non-root user, UID ≥ 1000. Task definitions with `user: root` will be rejected by the platform policy check.
- **Image tagging:** `<ecr-repo>:<git-sha>` is the canonical tag. Semver tags (`v1.2.3`) may be added additionally. Never use `latest` in task definitions.
- **Image size:** soft cap 500 MB, hard cap 2 GB. Images above the soft cap trigger a review suggestion; images above the hard cap are blocked from deploy.
- **Vulnerability scanning:** ECR scan-on-push is enabled. Critical CVEs block promotion from `stage` to `prod`. High CVEs have a 14-day SLA to fix or exception.
- **SBOM:** generated on build, stored in the artifact registry alongside the image.

---

## 9. Deployment requirements

### Task definition basics

- CPU and memory: explicit `cpu` and `memory` on the container definition. "Borrow from the task" (unset container-level) is not allowed — it hides capacity problems.
- Soft memory limit (`memoryReservation`) must be ≤ hard memory limit (`memory`).
- `essential: true` on the main container; sidecars are `essential: false` unless they are truly co-fate.

### Graceful shutdown

- Services must handle `SIGTERM`, drain in-flight requests, and exit within 30 seconds.
- The ECS stop-timeout is set to 45 seconds at the platform default.
- Long-running background jobs (> 30 s) must use SQS + a worker pattern, not in-request processing.

### Rolling deploy defaults

- `maximumPercent: 200`, `minimumHealthyPercent: 100` — platform default. Services can opt into blue/green (CodeDeploy) via a Terraform flag.
- Canary patterns are available but require an SLO and an automated rollback metric (platform provides templates).

### Rollback

- Every deploy records its previous task-definition ARN. Rollback is a single command that re-points the service at the prior revision.
- Database migrations must be backward-compatible for at least one deploy cycle. No deploy may contain both a schema change and a code change that requires the new schema in the same deploy — split into two deploys.

---

## 10. Security baseline

- **IAM:** least-privilege per service. Use the platform's `make_task_role` module, which generates a role scoped to only the resources the service declares it uses.
- **No wildcards on resources** in IAM policies. `Resource: "*"` is rejected by the platform policy check except for actions that genuinely require it (e.g., `logs:CreateLogStream`).
- **TLS everywhere externally.** HTTP is auto-redirected to HTTPS at the ALB.
- **Secrets rotation:** DB credentials rotate every 90 days (automated). Third-party API keys rotate per vendor policy; services must handle credential rotation without a restart where possible.
- **Dependency hygiene:** Dependabot or equivalent required on every repo. Security advisories with a known fix follow the patching SLA (Critical: 7 days, High: 14 days, Medium: 30 days).
- **No production access from personal laptops.** All `prod` Terraform apply, `kubectl`-equivalent, and database access goes through the platform's session-recording bastion (Teleport / AWS SSM Session Manager).

---

## 11. Repository standards

**Service repos do not contain Terraform.** Per §4, IaC lives in the stream's dedicated `<stream>-infra` repo under the `infrastructure/` GitLab group. This is a hard rule — service-repo CI never holds AWS credentials, so Terraform under a service repo would either fail to apply or would need its own runner trust (which defeats the single-runner model).

Every service repo must contain:

```
<service>/
├── README.md            # what it does, how to run locally, how to deploy, who owns it, link to stream IaC repo
├── CODEOWNERS           # rule pointing to the owning team
├── Dockerfile
├── slo.yaml             # SLO definitions
├── src/
├── tests/
└── .platform/
    └── service.yaml     # platform metadata (see below)
```

### `.platform/service.yaml`

```yaml
name: permify
team: identity
system: iam                                  # functional system this service belongs to
component: permify                           # the component within the system
iac_core_repo: infrastructure/iam-core       # shared foundations for this system
iac_component_repo: infrastructure/iam-permify  # workload-specific infra for this component
owner: identity-eng@acme.com
runtime: ecs-ec2
language: go
tier: critical                               # critical | important | standard
dependencies:
  - service: billing-api
    type: sync
  - service: events
    type: async
```

- `system` and `component` are mandatory. Together they identify which IaC repos the service depends on.
- `iac_core_repo` and `iac_component_repo` are verified at build time; a service whose declared IaC repos do not exist will fail the build. A service with no component-specific infra (rare) may omit `iac_component_repo`.
- The platform's developer portal consumes this file to populate the service catalog and to wire service repos to their IaC counterparts.

### Cross-repo change workflow

A change that spans code + infra happens across two or three repos. The ordering rule is **provision first, consume second**, so rollbacks are always safe:

1. **Shared-foundation change** (new RDS parameter group, new KMS key) → MR in `<system>-core`. Merge and apply. New parameter published to SSM.
2. **Component infra change** (new SQS queue the component will consume, IAM role permission) → MR in `<system>-<component>`. Merge and apply. Resource now exists, unused.
3. **Service code change** (point code at the new resource) → MR in the service repo. Merge and deploy.

Each step's rollback is its reverse in order: revert code → revert component infra → revert core. No single MR spans repos. No reviewer has to hold context across both code and infra.

---

## 12. What the platform guarantees (and what it doesn't)

### The platform provides

- ECS cluster capacity, EC2 AMIs (patched), Auto Scaling Groups, networking, ALBs.
- CI pipeline templates (GitHub Actions / CodePipeline).
- Observability backends (metrics, logs, traces) — you instrument, we store and query.
- Secrets Manager and Parameter Store infrastructure.
- Internal DNS, service discovery.
- Platform on-call for platform-layer incidents (defined in `on-call-operations.md`).

### The platform does **not** provide

- Service-level business logic debugging. A service returning 500s because of a bug is the service team's problem.
- Feature-level performance tuning. The platform provides capacity and observability; interpreting a slow endpoint is the service team's job.
- Arbitrary cloud resources outside the paved road. Need something bespoke? File a platform ticket; the answer will be either "add to the paved road for everyone" or "here's a pattern for you to own yourself."

### What the service team owes

- Structured logs, correct tags, healthy `/readyz`, graceful shutdown, documented SLOs, runbooks for every alert the service emits.
- Response within the SLA for any platform security patch request (typically 14 days for High, 7 for Critical).
- Postmortems for service-caused Sev 0/1 incidents, published within 10 business days.
- Quarterly dependency review (fresh base image, fresh language runtime, fresh top-level deps).

---

## 13. Requesting changes to the platform

- **New resource type / capability** → RFC in the `platform-rfcs` repo. Reviewed at the monthly platform roadmap meeting.
- **Bug or regression in a platform module** → issue in the module repo, severity label.
- **Urgent production issue (on-call)** → page the platform on-call per `on-call-operations.md`.
- **Security/compliance concern** → direct Slack to platform-security channel; do not file a public ticket with details.

Office hours: Tuesdays 10:00–11:30. Drop in for design reviews, Terraform pairings, cost questions.

---

## 14. Deprecation policy

When the platform deprecates something consumers depend on:

| Tier | Notice window | Communication |
|---|---|---|
| Minor (config flag default change) | 2 weeks | Release notes, #platform-announcements |
| Standard (module parameter renamed, new required tag) | 1 quarter | Announcement, migration guide, office-hours support, migration tracking dashboard |
| Major (removing a capability, forcing a replatform) | 2 quarters | Above + per-team migration plan, explicit sign-off from every consuming team's tech lead before the removal date |

The platform will never remove a deprecated capability without a migration path and a dashboard showing every remaining consumer.

---

## Appendix: quick reference card

```
Name pattern:    <env>-<service>-<component>[-<qualifier>]
Service name:    ≤ 20 chars, kebab-case, starts with letter
Env values:      prod | stage | dev | sandbox
Tightest limit:  ALB / target group name = 32 chars total

Required tags:   Environment, Service, Component, Team, Owner,
                 CostCenter, ManagedBy, DataClassification

Modules repo:    infrastructure/tf-modules          (standalone; modules only)
                   ref format: ?ref=<module>-v<major>.<minor>.<patch>
                   never ref=main, never a branch
IaC repos:       infrastructure/<system>-core       (shared foundations)
                 infrastructure/<system>-<component> (per deployable component)
TF state key:    infra/<system>/<core|component>/<env>/terraform.tfstate
Core→component:  SSM path /infra/<system>/core/<env>/<output> is the contract
                 (never terraform_remote_state across repos)
AWS access:      single GitLab runner tagged `infra-aws` via OIDC
                 — no other runner/laptop holds write creds
Local TF:        plan only (read-only SSO); apply is CI-only

Secrets path:    /<env>/<service>/<name>   (Secrets Manager)
Config path:     /<env>/<service>/<name>   (SSM Parameter Store)
Log group:       /ecs/<env>/<service>/<component>

App port:        8080
Ops port:        8081 (/healthz, /readyz)
Metrics port:    9090 (/metrics, or OTLP push)

Image tag:       <ecr-repo>:<git-sha>     (never "latest")
Base images:     platform/base-<lang>     (approved list)
Non-root UID:    ≥ 1000

Graceful stop:   handle SIGTERM, drain ≤ 30s
Rolling deploy:  max 200%, min healthy 100%
```
