---
name: infrastructure as code
description: Industry-standard infrastructure-as-code tools and configuration management
type: research
---

# Infrastructure as Code

**Question:** What are the current industry-standard tools for declaring and provisioning infrastructure in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Cloud infrastructure provisioning, configuration management for servers, and declarative Kubernetes configuration. Application build tools and CI are in `07-ci-cd.md`; Kubernetes manifests specifically in `06-orchestration.md`.

## Shape of the decision

Three categories of IaC tooling coexist:

1. **Cloud-agnostic IaC** (Terraform, OpenTofu, Pulumi) — declare cloud resources with a single tool across AWS/Azure/GCP/others.
2. **Cloud-vendor native** (AWS CloudFormation/CDK, Azure Resource Manager/Bicep, Google Cloud Deployment Manager) — first-party tools that support only that vendor's resources.
3. **Configuration management** (Ansible, Chef, Puppet, Salt) — traditionally agent- or SSH-based tools for configuring server state. Still widely used for VM-based fleets; less relevant in container-first architectures.

## Evidence base

Direct primary-survey numbers for IaC tooling are thinner than for most categories. The strongest signals:

- GitHub Octoverse 2024 listed **HCL** (HashiCorp Configuration Language, used by Terraform) among the fastest-growing languages of 2024 [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] (accessed 2026-04-24) [VERIFIED].
- Secondary coverage reports that Terraform "experience on a CV has 3x more candidates than Pulumi" per LinkedIn Talent Insights; Pulumi serves "150k+ users and 2000 customers" [UNVERIFIED — I did not fetch the LinkedIn report or Pulumi's customer page as primary sources].
- Stack Overflow surveys don't separate Terraform cleanly; it appears in tooling but not in a distinct IaC breakdown I was able to extract.

The low survey coverage itself is informative: IaC is a niche within the DevOps/platform role, not the broad developer population that dominates Stack Overflow and JetBrains samples.

## The Terraform / OpenTofu / Pulumi dynamic

### Terraform (HashiCorp)

- The long-standing default. Declarative HCL syntax; very large provider ecosystem.
- **License change (10 August 2023):** HashiCorp moved its products from the Mozilla Public License v2.0 (MPL 2.0) to the Business Source License v1.1 (BSL, also stylized BUSL) for "all future releases." HashiCorp's APIs, SDKs, and "almost all other libraries" remain MPL 2.0. Products covered by the change include Terraform, Packer, Vault, Consul, Nomad, Waypoint, and Boundary [[HashiCorp — adopting BSL, 10 Aug 2023](https://www.hashicorp.com/en/blog/hashicorp-adopts-business-source-license)] (accessed 2026-04-24) [VERIFIED — primary announcement fetched]. The BSL prohibits use that competes with HashiCorp's commercial offerings.
- **Current status:** Terraform remains dominant among existing users. HashiCorp was acquired by IBM; acquisition closed in 2025 [UNVERIFIED specific close date].

### OpenTofu

- A fork of Terraform under the Mozilla Public License 2.0, initiated in response to the BSL change. Hosted by the Linux Foundation: OpenTofu's own site describes it as "a reliable, flexible, community-driven infrastructure as code tool under the Linux Foundation's stewardship" [[OpenTofu — opentofu.org](https://opentofu.org/)] (accessed 2026-04-24) [VERIFIED].
- Compatible with Terraform 1.5.x; development has diverged modestly since.
- Adoption is growing among orgs that wanted to preserve open-source governance and among CI/cloud vendors wanting to ship Terraform-compatible tooling without BSL constraints.

### Pulumi

- Infrastructure as code in general-purpose languages (TypeScript, Python, Go, C#, Java, YAML) rather than a DSL.
- Differentiator: full language expressiveness (loops, functions, libraries) at the cost of needing language-level linting/testing. Usage concentrated in shops that want a single language across app + infra.
- Specific adoption share smaller than Terraform; Pulumi's own public numbers (cited in their docs) say "150k+ users" [UNVERIFIED — Pulumi-reported].

### How the three compare

| Dimension | Terraform | OpenTofu | Pulumi |
|---|---|---|---|
| Language | HCL | HCL | TS/Python/Go/C#/Java |
| License | BSL | MPL 2.0 | Apache 2.0 |
| Cloud provider coverage | Largest ecosystem (4,800+ providers reported by HashiCorp) | Terraform-compatible subset | Terraform providers usable via Pulumi; smaller native |
| State backend | Terraform state; HashiCorp Terraform Cloud / Terraform Enterprise | Compatible; many open-source backends | Pulumi Cloud; can use other backends |
| Governance | HashiCorp / IBM | Linux Foundation | Pulumi (private company) |

[The "4,800+ providers" number comes from secondary sources citing HashiCorp's own reporting — not fetched as primary here and thus [UNVERIFIED].]

## Cloud-vendor native IaC

### AWS CloudFormation and AWS CDK

- **CloudFormation** is AWS's native declarative IaC in YAML/JSON. Default for AWS-only shops especially in regulated or FedRAMP-heavy environments.
- **AWS CDK** (Cloud Development Kit) compiles imperative language code (TypeScript, Python, Java, C#, Go) down to CloudFormation. Adoption grew substantially post-2020 as teams wanted language expressiveness while staying on AWS-native tooling.
- **SAM (Serverless Application Model)** is a CloudFormation superset for serverless (Lambda) workloads.

### Azure ARM and Bicep

- **ARM templates** (Azure Resource Manager) are JSON-based. Widely considered cumbersome.
- **Bicep** is Microsoft's newer DSL that compiles to ARM; cleaner syntax. Now the recommended path for Azure-native IaC per Microsoft docs [UNVERIFIED in this session].

### Google Cloud: Deployment Manager → Config Connector + Terraform

- GCP's Deployment Manager is effectively deprecated in practice; Google officially positions Terraform as the recommended IaC for GCP. Config Connector exposes GCP resources as Kubernetes CRDs. [UNVERIFIED specific deprecation status.]

### Kubernetes-native: Crossplane

- **Crossplane** is a CNCF incubating project that represents cloud resources as Kubernetes CRDs, letting platform teams present cloud infra through the Kubernetes API. Growing in platform-engineering contexts. [UNVERIFIED specific CNCF status.]

## Configuration management

These tools pre-date the container/IaC era and remain in heavy use for VM-based and hybrid fleets:

- **Ansible** — agentless (SSH), Python-based. The most widely used CM tool in 2024–2026. [UNVERIFIED specific share.]
- **Chef, Puppet** — older agent-based tools; still in use especially in long-lived enterprises but declining in mindshare.
- **SaltStack** — Python-based, supports both agent and agentless modes. Niche.

CM's share of the new-greenfield market has shrunk as container-based deployments pushed configuration into images rather than running configuration on the host.

## Packer, Docker, and the build-time/provision-time distinction

- **Packer** (HashiCorp) — builds machine images (AMIs, Azure Managed Images, Google Images, OCI images) from declarative templates. Often paired with Terraform to produce golden images.
- **Docker / Buildah / Kaniko / Buildpacks** — build OCI container images. See `06-orchestration.md`.

## Policy as code

Adjacent to IaC: who is allowed to create what, and how is that enforced?

- **HashiCorp Sentinel** — policy engine embedded in Terraform Enterprise / HCP Terraform.
- **Open Policy Agent (OPA)** — CNCF graduated; Rego language; used as a generic policy engine, including for Kubernetes admission (Gatekeeper) and Terraform (Conftest).
- **Checkov, tfsec, KICS** — static analysis of Terraform / CloudFormation for security misconfigurations.

## Putting the stack together (typical 2026 defaults)

- **Multi-cloud or hyperscaler-agnostic teams:** Terraform or OpenTofu + Cloud providers' Terraform providers + Terraform Cloud / OpenTofu Cloud / self-hosted state.
- **AWS-native enterprise:** CDK + CloudFormation; optionally Terraform for third-party.
- **Azure-native enterprise:** Bicep + Terraform for non-Azure.
- **GCP-centric:** Terraform (Google's recommended path).
- **Kubernetes-first platform teams:** Crossplane + Terraform for pre-cluster provisioning + Argo CD for deployment.
- **Developers who prefer general-purpose languages:** Pulumi.
- **VM-based fleets:** Packer for images + Terraform for provisioning + Ansible for configuration.

## Sources (accessed 2026-04-24)

- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
- [HashiCorp — "HashiCorp adopts Business Source License" (10 Aug 2023)](https://www.hashicorp.com/en/blog/hashicorp-adopts-business-source-license)
- [OpenTofu — opentofu.org](https://opentofu.org/)

## Open questions

- **OpenTofu's adoption share** as of 2026 — no authoritative survey; CNCF end-user radar mentioned Terraform and would be the nearest primary source.
- **CDK vs CloudFormation split within AWS shops** — widely reported as CDK-dominant in new projects; no primary survey.
- **Pulumi's "150k users"** is vendor-reported.
- **Crossplane adoption** — CNCF incubating status and specific share not extracted.
- **Ansible usage share in 2026** — surprisingly hard to pin down; Red Hat does not publish adoption numbers directly.
- **Policy-as-code adoption rate** — no primary survey located.
- **ARM template vs Bicep split within Azure shops** — likely Bicep-first in new projects but not surveyed here.
