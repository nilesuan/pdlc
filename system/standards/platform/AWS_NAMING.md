# AWS_NAMING.md — Resource naming and tagging

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §1 (The master naming schema), §2 (AWS resource naming & character limits), §3 (Required tags).

## The schema

```
<env>-<service>-<component>[-<qualifier>]
```

- **`env`** — `dev`, `prep` (preprod), `prod`, `sbox` (sandbox). Always lowercase, ≤ 4 chars.
- **`service`** — kebab-case, ≤ 12 chars where possible. Stable; rename = breakage.
- **`component`** — `api`, `web`, `worker`, `db`, `cache`, `queue`, `tg` (target group), `alb`, `bucket`, `role`, `sg`. Kebab-case.
- **`qualifier`** — optional; `blue`/`green`, `a`/`b`, region, version. Use only when needed to disambiguate.

Examples:

```
prod-checkout-api
prep-checkout-tg
dev-billing-worker-blue
prod-imageops-bucket
```

## AWS character-budget table (the killer)

Different AWS resources have **different name length limits**. Plan for the tightest.

| Resource | Max length | Notes |
|---|---|---|
| ALB target group | **32** | Tightest practical limit; design schema around this |
| Security group name | 255 | But described in many places — keep readable |
| ECS cluster | 255 |  |
| ECS service | 255 |  |
| ECS task family | 255 |  |
| IAM role | 64 | Path adds to total |
| IAM policy | 128 |  |
| Lambda function | 64 |  |
| RDS instance ID | 63 |  |
| S3 bucket | 63 (DNS-compliant) | Globally unique; needs account / org prefix |
| SQS queue | 80 (FIFO: 80 incl. `.fifo`) |  |
| SNS topic | 256 |  |
| KMS alias | 256 (excl. `alias/`) |  |
| CloudWatch log group | 512 |  |
| Secrets Manager secret | 512 |  |
| SSM parameter | 1011 (full path) |  |
| CloudFormation stack | 128 |  |
| EC2 launch template | 128 |  |
| EFS file system tag `Name` | (256 like other tags) |  |

**Design rule:** if your name fits in 32 chars, it fits everywhere relevant.

A name like `prod-checkout-tg` (16 chars) fits comfortably in the 32-char target group limit with room for a qualifier (`prod-checkout-tg-blue` = 21 chars).

## Hard rules

1. **Never include account ID, region, or random suffix in the name itself.** Those go in tags.
2. **No CamelCase, no UPPER, no underscores.** Lowercase + hyphen. (`s3` bucket, the rare exception, is DNS-flat — use the same kebab-case there.)
3. **Always tag.** Even if the resource type doesn't accept name tags by convention, the required tags below apply.
4. **No "tmp", "test", "delete-me" in long-lived resources.** A `tmp-` SG that's been there 18 months is a smell.

## Required tags (per developer-guidelines.md §3)

The exact required tag set is defined in `developer-guidelines.md` §3; the table below is a working subset. Verify against the source before treating any tag value list as authoritative.

| Tag | Value | Notes |
|---|---|---|
| `Environment` | `dev` / `prep` / `prod` / `sbox` | Lowercase to match `env` segment |
| `Service` | service name (kebab-case) | Same as `service` segment |
| `Owner` | team name or email | Routing for incidents |
| `CostCenter` | finance code | For chargeback |
| `ManagedBy` | `terraform` / `manual` / `cdk` | If `manual`, requires ADR |
| `Repo` | URL or `org/repo` slug | Source of truth |
| `Component` | component segment | Optional but useful for filtering |

**A resource with `ManagedBy=manual` is a liability**: it has no plan, no review path, no rollback. Use only when bootstrapping the IaC stack itself.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Resource name violates schema | Minor → Major depending on resource criticality |
| ALB target group name > 32 chars | Blocker (will fail to create or break ECS binding) |
| Required tag missing on a Terraform-managed resource | Major |
| Resource tagged `ManagedBy=manual` without ADR justification | Major |
| `Environment` tag mismatches the env-segment in the name | Major (audit confusion) |
| Random / hash suffix in the name (instead of in tags) | Minor |
| Name uses CamelCase / underscores | Minor |

## SSM parameter / secret paths

Per developer-guidelines.md, SSM is the cross-repo contract path:

```
/<env>/<owner>/<contract-name>          # cross-repo contracts
/<env>/<service>/<key>                  # service-internal config
/<env>/<service>/secrets/<key>          # SecureString secrets
```

Service repo writes `/<env>/<this-service>/...`. Reads from `/<env>/<other-service>/...` count as a cross-repo dependency and should be documented in the design doc.

## Anti-patterns to flag

- `prod-CheckoutAPI` — case-mixed.
- `checkout` (no env) — collides across envs.
- `prod-checkout-tg-1234abc` — random suffix in name; goes in tag if needed for uniqueness, otherwise drop.
- Different envs running in the same security group named `default-sg` — no env separation.
- Tags missing `Owner` — incident routing falls back to "all of engineering" Slack.

## Sources

- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §1 (Naming), §2 (AWS limits), §3 (Tags).
- AWS service-quota / naming-constraint docs (per resource type, in service docs).
- AWS Tagging Best Practices (docs.aws.amazon.com/tag-editor/).
