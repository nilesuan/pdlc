# TERRAFORM_DISCIPLINE.md — IaC patterns and rules

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §4 (Terraform and the infrastructure repository model); [`../../../NOTES.md`](../../../NOTES.md) (Terraform plan-on-MR / apply-on-merge).

## Repo topology (per developer-guidelines.md §4)

```
tf-modules/             # reusable modules; versioned, tagged
system-core/            # shared org-level infra (VPC, IAM org, root account, IAM Identity Center)
system-component/       # per-service infra; one repo per service or per logical component
```

A service's IaC lives next to its code. The `tf-modules` repo provides primitives; the service repo composes them.

## Hard rules

1. **`terraform plan` runs on every MR.** No exception. PR cannot merge without a plan visible to reviewers.
2. **`terraform apply` runs on merge to main.** Single CI runner with OIDC-assumed role per environment. Per NOTES.md.
3. **No `terraform apply` from a developer machine** for shared environments. Local apply allowed only for personal sandboxes.
4. **`--auto-approve` only inside the CI pipeline**, where the apply is gated by the merge that the team reviewed.
5. **Remote state backend, not local.** S3 + DynamoDB lock; or Terraform Cloud / Atlantis. Per developer-guidelines §4.
6. **State file encrypted at rest.** Per backend's encryption setting.
7. **State file access scoped.** Reading state ≠ writing state; only the CI runner has write.
8. **`terraform init -upgrade` is intentional, not implicit.** Lock file (`.terraform.lock.hcl`) committed; provider versions pinned.
9. **Provider versions and module versions pinned** (not `~>` open-ended on critical modules; use exact versions and review upgrades).
10. **Module inputs validated.** `validation` blocks on variables where invariants exist.
11. **Module outputs typed.** Avoid `any` outputs that downstream code interprets ambiguously.
12. **No `count = 0` / `count = 1` toggles.** Use `for_each` with a map; or split modules. Toggles cause perpetual diffs.
13. **`null_resource` / `local-exec` are last resort.** Document why a native provider can't do the job.

## Module discipline

- **One module = one logical concern.** ALB+TG+listener is a module; ALB+TG+ECS-service+IAM-role is a god-module.
- **Inputs minimal; sensible defaults.** A module that takes 25 inputs is a code smell.
- **Outputs include the IDs / ARNs the next module needs.** Don't force callers to data-source-lookup what you already created.
- **No data-source on something this module just created.** Use the resource attribute.
- **Examples directory** with a working composition.
- **README in every module** with input/output table and a usage example. Generate with `terraform-docs`.

## Cross-repo contracts (SSM as contract)

When two service repos need to share a value (e.g., shared VPC ID, KMS key ARN), the producer writes to SSM Parameter Store with a contract path; the consumer reads. Per developer-guidelines.md.

```
/<env>/<owner>/<contract-name>
```

The contract path is the API. Renaming = breaking change.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| MR without `terraform plan` output visible to reviewer | Major |
| `terraform apply` from outside CI pipeline (local) | Blocker |
| `--auto-approve` on local terraform apply | Blocker |
| Local state backend in a shared environment | Blocker |
| State file in a public S3 bucket | Blocker |
| Provider version unpinned (`>= 5.0` style without lock file) | Major |
| Lock file (`.terraform.lock.hcl`) not committed | Major |
| Module with `count = 0` toggle | Minor |
| Module accepting `aws_iam_policy_document` as a string | Major (use the data source) |
| Hardcoded ARN / account ID where a data source / variable should be | Minor |
| `null_resource` with no comment justifying it | Minor |
| `for_each` over a list (vs a set or map) — causes index churn | Major |

## Sensitive variables

- Marked `sensitive = true`.
- Sourced from SSM SecureString or Secrets Manager, not committed.
- Outputs that contain sensitive data marked `sensitive = true`.
- No `terraform output -raw secret_name` in CI logs.

## State migrations

Renaming a resource → use `moved {}` block (Terraform 1.1+). Never run `terraform state rm` + `terraform import` on a shared state without team coordination — there's no rollback.

## Anti-patterns to flag

- One giant `main.tf` per repo. Split by concern.
- "Stacks" (workspaces) used to model environments instead of separate state files. Workspaces share modules but the blast radius of a workspace switch is too easy to mis-target.
- Terraform managing things outside its lifecycle (e.g., one-off DB migrations). Use a separate tool; Terraform is not a job runner.
- Modifying `default` resources (VPC, security group). Always create explicit ones.
- Hand-rolled IAM policies when a managed policy fits and is appropriate.

## Sources

- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §4.
- HashiCorp Terraform documentation (developer.hashicorp.com/terraform).
- Gruntwork *Terraform: Up & Running* (3rd ed., Brikman) — module patterns.
- AWS Provider documentation (registry.terraform.io/providers/hashicorp/aws/latest/docs).
