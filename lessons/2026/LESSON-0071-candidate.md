---
id: LESSON-0071-candidate
date: 2026-09-25
trigger: self-detected
phases: [06]
keywords: [aws, profile, account, bedrock, dry-run, live-run, credentials, data-governance, company-code, sts, get-caller-identity, cosign, version]
related-rules: [CLAUDE.md section 2, CLAUDE.md section 6 exceptions]
status: candidate
source-run: prbot stack merge and live proof, 2026-09-25
---

## What went wrong

To prove a merged prbot build end to end, a dry run was pointed at a company GitLab merge request (terraform-modules MR 269) with the machine's default AWS profile. `aws sts get-caller-identity` had succeeded, and that was taken as "the account the earlier research used". It was not: the default profile is a personal SSO organisation without the production model enabled, so Bedrock refused every call. The merge request's prompts had still been sent to that account's Bedrock endpoint before being refused.

Separately, the image signature check first used cosign v2.4.1 and reported "no signatures found"; the pipeline signs with cosign v3.0.6, whose bundle format v2 cannot read.

## Why it happened (root cause)

A credential check proves the credentials work, not which account they reach or whether that account may receive the data. The research write-up named "the development Bedrock account" without a profile, and the gap was filled with the default instead of being checked. The cosign failure had the same shape: a verifier was chosen without checking which version the signer used.

## How to prevent it (the rule)

Before sending third-party or company data to a cloud account, establish which account the credentials reach and that it is the one the data is meant for; when a document names an account without a profile, ask or use public data instead. Verify an artifact with the same tool version its pipeline signs with.

## Verification

The rule held if the next live run against private data names the target account and why it is the right one before the first call is made.
