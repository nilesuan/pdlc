---
name: platform team
description: Lean platform team composition, responsibilities, and on-call operations for AWS + ECS-on-EC2 + Terraform stack
type: operational
---

# Platform Team

**Context:** Internal platform engineering function serving product engineering teams. Production stack: AWS, ECS on EC2, Terraform.

**Status:** Draft — prescriptive/advisory, not research. Specific headcounts and rotation shapes are judgment calls synthesized from the team's stack constraints, not citations from a survey.

**Last updated:** 2026-04-24.

## Documents

- [Team composition & responsibilities](team-composition.md) — the 4-person lean shape, per-role scope, and expansion path to 6–7
- [On-call & operations](on-call-operations.md) — rotation shape, severity tiers, escalation, runbook discipline, target metrics
- [Developer guidelines](developer-guidelines.md) — the contract for teams consuming the platform: naming schema, AWS resource limits, tagging, Terraform, secrets, observability, networking, container, deploy, security, repo standards, deprecation policy
- [Engineering policy](engineering-policy.md) — binding development-practice policy (Phase 1): Trunk-Based Development, Continuous Integration, Continuous Delivery, TDD, test pyramid, SOLID, Clean Architecture, code review, Conventional Commits, refactoring, DORA. Hard rule by default; deviations require an ADR

## The short version

- **Minimum viable lean:** 4 people (Platform Head + 2 Senior Platform Engineers + 1 SRE/Observability)
- **Sustainable lean:** 6–7 people (double up on the Terraform/AWS seat and the SRE seat so pager rotation is humane)
- **On-call at 4 people is survivable, not healthy** — 1-in-3 primary rotation with the Platform Head as backup. Grow past this as fast as the budget allows.
- **Security is shared** until a compliance gate (SOC 2 Type II / PCI / HIPAA) promotes it to a named half-FTE.

## What would shift the shape

| Trigger | Shape change |
|---|---|
| Serving >8–10 product teams | Add dedicated DevEx engineer (docs, paved roads, portal) |
| SOC 2 Type II / PCI / HIPAA in flight | Security becomes named role, not shared |
| Multi-region / multi-account sprawl | Terraform/AWS seat splits into two |
| Heavy data or ML workloads | Separate data-platform specialist (do not merge with app platform) |
| >100 engineers consuming platform | Formal internal developer platform (IDP) team with its own PM |
