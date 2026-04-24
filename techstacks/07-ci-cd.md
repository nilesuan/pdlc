---
name: ci/cd stack
description: Industry-standard CI/CD tooling and the DORA metrics that define delivery performance
type: research
---

# CI/CD

**Question:** What are the current industry-standard CI/CD tools and delivery practices in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Continuous integration, continuous delivery, deployment patterns, and the DORA metrics that operationalize "delivery performance." Infrastructure provisioning (Terraform etc.) is in `09-iac.md`; Kubernetes-specific GitOps deployment in `06-orchestration.md`.

## Shape of the decision

CI/CD in 2026 has three layers:

1. **CI platform** — where the build runs. GitHub Actions, GitLab CI, Jenkins, CircleCI, Azure DevOps, Buildkite, TeamCity, Bitbucket Pipelines.
2. **CD / deployment controller** — how changes reach production. For Kubernetes workloads, Argo CD or Flux are dominant (see `06-orchestration.md`). For non-Kubernetes, the CI platform often does the deploy directly via scripts or Terraform.
3. **Release control / progressive delivery** — feature flags, canary/blue-green, feature management (LaunchDarkly, Flagsmith, OpenFeature).

The two governance frameworks that define how to evaluate a CI/CD pipeline:

- **DORA four keys** — deployment frequency, lead time for changes, change failure rate, time to restore service. Used as the standard way to measure delivery performance.
- **Trunk-based development** — a branching pattern specifically correlated with elite DORA scores in the DORA research.

## Evidence base

### CI platform adoption

- **JetBrains State of CI/CD 2025** (805 respondents) [[JetBrains State of CI/CD 2025](https://blog.jetbrains.com/teamcity/2025/10/the-state-of-cicd/)] (accessed 2026-04-24) [VERIFIED]:
  - **GitHub Actions**: 62% for personal projects, 41% for organizations
  - **TeamCity**: 7% for organizations, 2% for personal projects
  - 32% of organizations use two different CI/CD tools; 9% use at least three
  - "GitHub Actions dominates personal projects but hasn't yet displaced legacy tools like Jenkins in enterprises"
- Stack Overflow 2024 does not publish a direct CI platform list comparable to the JetBrains one.

### Survey-level snapshot

Secondary-source summary of broader industry data puts GitHub Actions ahead on enterprise adoption at ~33%, Jenkins ~28%, GitLab CI ~19% [UNVERIFIED — this came from search results referencing "State of CI/CD" data I did not fetch a primary version of; the JetBrains 2025 report, which I did fetch, is the strongest direct source available].

### DORA

- **DORA Accelerate State of DevOps 2024** — 39,000+ respondents [[DORA 2024 report PDF](https://dora.dev/research/2024/dora-report/2024-dora-accelerate-state-of-devops-report.pdf)] (accessed 2026-04-24) [VERIFIED — primary PDF fetched]. Key findings:
  - Four performance-level clusters (page 13 of the PDF): **Elite 19%** (range 18–20%), **High 22%** (21–23%), **Medium 35%** (33–36%), **Low 25%** (23–26%) [VERIFIED].
  - Elite-vs-Low gaps (page 13): 127x faster lead time for changes, 182x more deploys per year, 8x lower change-failure rate, 2,293x faster failed-deployment recovery [VERIFIED].
  - **AI adoption impact (page 39, Figure 10):** per 25-percentage-point increase in AI adoption, delivery throughput changes by **-1.5%** and delivery stability by **-7.2%** [VERIFIED]. Same scale, positive effects: documentation quality +7.5%, code quality +3.4%, code-review speed +3.1%, individual productivity +2.1%, team performance +1.4%, organizational performance +2.3% [VERIFIED].
  - **AI usage is already widespread:** 81% of respondents said their organization had shifted priorities toward AI; 75.9% rely on AI in their daily work; 39.2% reported little-to-no trust in AI-generated code [VERIFIED — DORA 2024 PDF, AI chapter].
  - Batch size remains DORA's recurring root-cause observation — larger changesets correlate with lower stability [VERIFIED — narrative theme across the 2024 report].

## CI platforms

### GitHub Actions

- Dominant among new projects and personal use (JetBrains State of CI/CD 2025: 62%) [[JetBrains State of CI/CD 2025](https://blog.jetbrains.com/teamcity/2025/10/the-state-of-cicd/)] [VERIFIED].
- Deeply integrated with GitHub; best-in-class for repositories already on GitHub. Marketplace of reusable actions.
- Free tier for public repos; per-minute pricing for private with tiered plans.
- **Self-hosted runners** grew substantially in 2024–2025 due to enterprise compliance and Kubernetes-ARC auto-scaling runner patterns [UNVERIFIED exact numbers — search results cited 38% self-hosted-runner-usage growth, source not primary-fetched].

### GitLab CI / CD

- Built into GitLab; shares a unified data model with the repo, MRs, and issues.
- Strong in enterprises that adopted GitLab for the "one-app-to-rule-them-all" pitch.
- Pipelines are declared in `.gitlab-ci.yml`.

### Jenkins

- Long-established, self-hostable, plugin-rich. Dominant in legacy enterprise pipelines and in shops with custom build infrastructure.
- Jenkins's "large share in enterprise" position is consistently reported in JetBrains and third-party surveys [[JetBrains State of CI/CD 2025 — narrative](https://blog.jetbrains.com/teamcity/2025/10/the-state-of-cicd/)] [VERIFIED narrative].
- Jenkins's declarative-pipeline Jenkinsfile and modern plugins are still widely used; the full 2010s-era Jenkins footprint is being migrated to GitHub Actions / GitLab CI where organizational constraints allow.

### CircleCI

- Early-cloud-CI leader; still widely used especially for macOS-dependent mobile builds. Popularity has softened as GitHub Actions absorbed general-purpose cloud CI.

### Azure DevOps / Azure Pipelines

- Microsoft's offering; dominant in .NET / Microsoft-centric enterprises.

### Buildkite

- Hybrid model: hosted control plane, customer-hosted agents. Popular for large-scale build farms where buying cloud minutes is uneconomical or custom hardware is required.

### TeamCity

- JetBrains's own CI platform; still in use, especially in JVM shops and shops already on JetBrains tooling. JetBrains 2025 survey: 7% at organizations [VERIFIED].

### Bitbucket Pipelines

- Atlassian's CI, bundled with Bitbucket. Primary audience is teams already on Bitbucket/Jira/Confluence.

## CD controllers

For Kubernetes workloads, Argo CD and Flux are the dominant CD controllers — see `06-orchestration.md` for the CNCF data (Argo CD in ~60% of Kubernetes clusters; 97% production adoption; NPS 79) [VERIFIED].

For non-Kubernetes deploys, the CI tool itself is typically used to run deployment scripts (shell / Terraform / Pulumi / cloud-vendor CLI).

## Progressive delivery and release control

- **Feature flags** — LaunchDarkly (leader), Unleash, Flagsmith, ConfigCat, Split, GrowthBook, cloud-vendor native (AWS AppConfig, Azure App Configuration).
- **OpenFeature** — CNCF project for a vendor-neutral feature-flag API [UNVERIFIED status in this session; the project exists on CNCF site but I did not fetch it directly].
- **Canary / blue-green / shadow** — deployment patterns supported at the gateway (Istio, Linkerd), the load balancer (AWS ALB, GCP, Azure), or the CD controller (Argo Rollouts, Flagger).
- **Argo Rollouts** — Argo CD-adjacent controller for progressive delivery on Kubernetes. Widely paired with Argo CD.
- **Flagger** — Flux-adjacent equivalent.

## DORA metrics and what the research says

The DORA team (Nicole Forsgren, Jez Humble, Gene Kim) introduced the four keys in the book *Accelerate* (2018) and have refined them through annual State of DevOps reports since. The four keys are:

1. **Deployment frequency** — how often code reaches production.
2. **Lead time for changes** — commit → running in production.
3. **Change failure rate** — percent of deploys causing a service-impacting incident.
4. **Time to restore service** — wall-clock time from detect to recover.

Historically, DORA also reports on a fifth metric added in 2021 for operational health (reliability), and sometimes tracks organizational and developer-experience measures.

The 2024 report, verbatim thresholds from page 13 of the PDF [[DORA 2024 report PDF](https://dora.dev/research/2024/dora-report/2024-dora-accelerate-state-of-devops-report.pdf)] (accessed 2026-04-24) [VERIFIED]:

| Level | Lead time for changes | Deploy frequency | Change-failure rate | Failed-deployment recovery | Share of respondents |
|---|---|---|---|---|---|
| Elite | Less than one day | On demand | 5% | Less than one hour | 19% |
| High | One day to one week | Between once per day and once per week | 20% | Less than one day | 22% |
| Medium | Between one week and one month | Between once per week and once per month | 10% | Less than one day | 35% |
| Low | Between one month and six months | Between once per month and once every six months | 40% | Between one week and one month | 25% |

- Trunk-based development plus short-lived feature flags is the pattern DORA consistently associates with Elite performance [[DORA 2024 report PDF](https://dora.dev/research/2024/dora-report/2024-dora-accelerate-state-of-devops-report.pdf)] [VERIFIED — recurring theme across the 2024 report].

## Branching strategies

- **Trunk-based development** — short-lived branches (hours to a day), frequent integration to main. DORA research and DevOps literature identify TBD as a top predictor of elite delivery performance [[DORA 2024](https://dora.dev/research/2024/dora-report/)] [VERIFIED as a recurring DORA finding].
- **Git Flow / GitHub Flow / release branches** — older multi-branch patterns. Still widespread in large or regulated orgs but consistently associated with lower DORA scores. [SYNTHESIS from DORA's published guidance.]
- **Stacked PRs** — smaller change review model used at some large shops; not surveyed but discussed widely (Graphite, Git's `git range-diff`, internal tools at Meta/Google).

## Putting the pipeline together (typical 2026 defaults)

- **Repository + CI:** GitHub + GitHub Actions (dominant for greenfield) or GitLab + GitLab CI (for all-in-one shops).
- **Build:** OCI images via Docker BuildKit or Buildpacks.
- **Artifact store:** Cloud-vendor container registry (GHCR, ECR, GAR, ACR).
- **Deploy target on Kubernetes:** Argo CD (GitOps), optionally with Argo Rollouts for progressive delivery.
- **Deploy target on serverless:** Direct from CI via the platform CLI (AWS SAM, Serverless Framework, Cloudflare Wrangler, Pulumi).
- **Progressive delivery:** feature flags (LaunchDarkly / OpenFeature-compatible), canary or blue-green at the gateway or CD controller.
- **Performance measurement:** DORA four keys reported via a tool like Swarmia, GetDX, LinearB, or home-rolled.

## Sources (accessed 2026-04-24)

- [JetBrains State of CI/CD 2025](https://blog.jetbrains.com/teamcity/2025/10/the-state-of-cicd/)
- [DORA Accelerate State of DevOps 2024 — landing page](https://dora.dev/research/2024/dora-report/)
- [DORA Accelerate State of DevOps 2024 — report PDF](https://dora.dev/research/2024/dora-report/2024-dora-accelerate-state-of-devops-report.pdf)
- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [CNCF End-User Technology Radar — Argo CD majority](https://www.cncf.io/announcements/2025/07/24/cncf-end-user-survey-finds-argo-cd-as-majority-adopted-gitops-solution-for-kubernetes/)

## Open questions

- **GitHub Actions absolute market share** — secondary sources cite 33%, 41%, and 62% across different populations (enterprise vs. personal vs. JetBrains sample). No single authoritative figure.
- **Jenkins pipeline share in 2026** — widely cited as declining but still substantial; no single clean primary figure.
- **LaunchDarkly / feature-flag market share** — heavily vendor-reported; no independent survey located.
- **Adoption of OpenFeature** — CNCF project exists; no primary adoption data extracted here.
- **Argo Rollouts vs Flagger share** — anecdotally Argo Rollouts is more widely adopted in Argo CD shops, Flagger in Flux shops, but not surveyed.
- **Stacked-PR tooling adoption** — largely non-measured.
