---
name: techstacks index
description: Index of research documents on current industry-standard tech stacks
type: overview
---

# Industry-Standard Tech Stacks — Research Index

**Question:** What are the current industry-standard tech stacks across the major domains of software engineering (frontend, backend, mobile, databases, orchestration, CI/CD, cloud, IaC, observability, version control, testing, security, AI/ML), and why did those choices become standard?

**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** General-purpose commercial software — SaaS web apps, cloud-native services, and mobile apps. Embedded, gaming, HPC, and scientific computing are out of scope except where they overlap (e.g., Python for ML).
**Evidence basis:** Primary industry surveys (Stack Overflow Developer Survey 2024 and 2025, JetBrains State of Developer Ecosystem 2024, GitHub Octoverse 2024, CNCF Annual Survey 2024 + 2025 announcement, DORA Accelerate State of DevOps 2024, State of JS / State of CSS 2024, DB-Engines ranking, Synergy Research cloud market data, ThoughtWorks Technology Radar vol. 31–33), plus official project/standards documentation. See `00-methodology.md`.

## Why this question is harder than it looks

"Industry standard" is an elastic phrase. A few disclaimers are load-bearing for every document that follows:

1. **"Standard" means different things.** Some standards are formally ratified (HTTP, OAuth 2.0, OIDC, CNCF graduated projects). Others are *de facto* — held up by overwhelming usage (Git, React, PostgreSQL, Kubernetes, Linux). The documents below flag which is which.
2. **Surveys are self-selected.** Stack Overflow, JetBrains, State of JS et al. draw respondent pools skewed toward web/English-speaking/open-source-aware developers. They are the best signal available, but percentages are point estimates on biased samples, not census data. `00-methodology.md` discusses this.
3. **"Why it won" is not always "why it's best."** Network effects, hiring markets, and vendor backing carry more weight than technical merit in many choices — this is called out explicitly rather than buried.

## Document index

| # | Document | Topic |
|---|----------|-------|
| 00 | [Methodology](00-methodology.md) | How this research was conducted, what counts as a source, limitations |
| 01 | [Programming languages](01-languages.md) | Language-level rankings and what they mean |
| 02 | [Frontend (web)](02-frontend.md) | Frameworks, meta-frameworks, build tools, styling, TypeScript |
| 03 | [Backend](03-backend.md) | Server-side languages/frameworks, API styles (REST, GraphQL, gRPC) |
| 04 | [Mobile](04-mobile.md) | Native (SwiftUI, Jetpack Compose) and cross-platform (React Native, Flutter, KMP) |
| 05 | [Databases and data](05-databases-data.md) | OLTP, OLAP/warehouses, key-value, document, search, streaming |
| 06 | [Containers and orchestration](06-orchestration.md) | Docker, Kubernetes, service mesh, GitOps |
| 07 | [CI/CD](07-ci-cd.md) | GitHub Actions, GitLab CI, Jenkins, deployment patterns, DORA |
| 08 | [Cloud platforms](08-cloud.md) | AWS / Azure / GCP market share, platform engineering |
| 09 | [Infrastructure as code](09-iac.md) | Terraform, OpenTofu, Pulumi, CDK, Ansible |
| 10 | [Observability](10-observability.md) | OpenTelemetry, Prometheus, Grafana, Datadog, logging |
| 11 | [Version control and collaboration](11-version-control.md) | Git, GitHub/GitLab/Bitbucket, branching strategies |
| 12 | [Testing](12-testing.md) | Unit, integration, E2E (Playwright, Cypress), contract, load |
| 13 | [Security](13-security.md) | OAuth 2.0/OIDC, SAST/DAST/SCA, secrets, supply chain |
| 14 | [AI/ML and data engineering](14-ai-ml.md) | PyTorch/TensorFlow, Hugging Face, MLOps, Airflow/Dagster/dbt |

## How to read these documents

- Every factual claim either has an inline citation to a fetched source or is tagged with an uncertainty marker (`[VERIFIED]`, `[SYNTHESIS]`, `[UNVERIFIED]`, `[CONTESTED]`, `[OUT OF DATE]`).
- Percentages quoted are from a specific survey and a specific respondent pool — those are named rather than summarized as "industry."
- Each document ends with a **Sources** section listing every URL fetched and an **Open questions** section listing what remains unverified.
- The documents describe what is standard; they do not prescribe what the reader should use. Translating "standard" into "right for your team" is outside scope.
