# GITLAB_SECURITY.md — Repo and CI security baseline

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §11 (Repository standards), §9 (Deployment requirements), §10 (Security baseline); [`../../../NOTES.md`](../../../NOTES.md) (GitLab + repo security).

## Hard rules

### Branch protection

1. **`main` is protected.** No direct push. Merges only through MR.
2. **MR requires ≥ 1 approval** from CODEOWNERS.
3. **Pipeline must pass** before merge.
4. **Approvals reset on new commits** (so a re-pushed branch is re-reviewed).
5. **Force-push to `main` disabled** for everyone, including maintainers.
6. **Delete source branch on merge** enabled (keeps repo tidy; long-lived branches are an anti-pattern anyway — see [`../development/TRUNK_BASED.md`](../development/TRUNK_BASED.md)).

### Authentication

1. **MFA required** for all members.
2. **SSO via central IdP** (Okta / Google / Azure AD); no local-only GitLab accounts.
3. **No personal access tokens with `api` scope** for shared automation. Use group / project access tokens with minimal scope, expire ≤ 90 days.
4. **Deploy tokens for read-only artifact pulls only.** No write-deploy-tokens.

### CI/CD pipeline security

1. **OIDC trust for cloud access.** GitLab job assumes AWS role via JWT; no `AWS_ACCESS_KEY_ID` in CI variables. Per [`AWS_ECS_TERRAFORM.md`](AWS_ECS_TERRAFORM.md).
2. **CI variables marked "Protected"** (only available to protected branches) and "Masked" (redacted in logs) where appropriate.
3. **No secret in `.gitlab-ci.yml`.** Reference variables; never inline.
4. **Runners scoped per project / group**, not shared across the org for production workloads.
5. **Specific runners for production deploys** — pinned tag; on a hardened image; not used for arbitrary user code.
6. **`script:` blocks reviewed like code.** A pipeline that downloads `curl | bash` from a third-party URL is a supply-chain risk.
7. **`include:` from external sources pinned by SHA**, not by branch name. `include: project: ... ref: main` is mutable.

### Secrets

1. **Pre-commit secret scan** (gitleaks / trufflehog) on every commit.
2. **CI secret scan** as backstop in case pre-commit was skipped.
3. **A leaked secret is treated as compromised.** Rotate immediately; do not "just delete the commit" — git history is forever in clones and forks.
4. **Secrets stored in AWS Secrets Manager / SSM ParamStore SecureString**, surfaced to runtime by IAM-controlled fetch, not by environment variable injection at deploy time.

### Repository content

1. **`.gitignore` covers `.env`, `*.pem`, `*.key`, `id_rsa*`, `credentials*`, `secrets*`, `cdocs/`** and any other generated artifact paths.
2. **No binary artifacts > 10 MB committed without LFS** (and only if necessary; prefer artifact registry).
3. **No vendored dependencies in source repo** unless the toolchain requires it (e.g., Go vendor mode, by team convention).

## Auto-rejection (used by platform-engineer + security-reviewer)

| Trigger | Severity |
|---|---|
| Direct push to `main` allowed (no protection) | Blocker |
| Force-push to `main` enabled | Blocker |
| Merge without required approvals enabled | Major |
| Pipeline passing not required for merge | Major |
| Long-lived AWS access key in CI variables | Blocker |
| OIDC trust not configured for CI → AWS | Major |
| Personal access token with `api` scope used for automation | Major |
| Secret committed (any) | Blocker (rotate) |
| `.gitlab-ci.yml` `include` referencing external project by branch | Major |
| Pre-commit hook bypassed via `--no-verify` on a merged commit | Major |
| MFA not required at group level | Major |
| Shared CI runner used for production deploys | Major |

## Code owners

`CODEOWNERS` file required at repo root for any service repo. Critical paths (`infra/`, `migrations/`, `auth/`) explicitly owned. Per Atlassian / GitLab conventions for review routing.

## Audit logging

- GitLab audit events shipped to centralized log store; retained per compliance requirement.
- AWS CloudTrail enabled in every account; logs immutable (S3 Object Lock + KMS).
- Pipeline logs retained for ≥ 90 days for production deploy jobs.

## Anti-patterns to flag

- "Just temporarily disabling branch protection to push a fix." If you needed to disable it, the workflow is the bug.
- Sharing a service account's password / token in a chat. Audit-trail-killer.
- A single `DEPLOY_KEY` reused across all repos.
- "Allow failure" on the security-scan job. Defeats the gate.
- Self-approval on MRs (the author also being CODEOWNER and approving). Configure GitLab to disallow self-approval.

## Sources

- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §11 (Repository standards), §9 (Deployment requirements), §10 (Security baseline).
- [`../../../NOTES.md`](../../../NOTES.md) — explicit user policy on GitLab + repo security.
- GitLab "Permissions and roles" / "Protected branches" documentation.
- OWASP CI/CD Top 10 (owasp.org/www-project-top-10-ci-cd-security-risks/).
- SLSA framework (slsa.dev) for supply-chain security levels.
