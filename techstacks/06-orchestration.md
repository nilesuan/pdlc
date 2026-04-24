---
name: containers and orchestration
description: Industry-standard container, orchestration, service mesh, and GitOps stacks
type: research
---

# Containers and orchestration

**Question:** What are the current industry-standard choices for packaging and running server-side workloads in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Container build and runtime, container orchestration, service mesh, ingress, GitOps deployment, and workload-level concerns. The cloud substrate (AWS/Azure/GCP) is in `08-cloud.md`; CI/CD pipelines in `07-ci-cd.md`.

## Shape of the decision

At the application layer:

1. **Containers** — Docker-formatted OCI images, built with Docker or alternative builders.
2. **Orchestration** — Kubernetes is the dominant default; managed services (EKS, GKE, AKS) are the usual way to consume it.
3. **Service mesh** — Istio, Linkerd, Cilium Service Mesh, or no mesh. Adoption has plateaued below the peak hype of 2020–2022.
4. **Ingress / API gateway** — NGINX, Envoy-based (Istio Ingress Gateway, Emissary, Contour), Kubernetes Gateway API.
5. **GitOps** — ArgoCD (dominant), Flux, with Kargo / Codefresh GitOps for promotion.
6. **Packaging on Kubernetes** — Helm is standard; Kustomize is built into kubectl; both often used together.

## Evidence base

- Stack Overflow 2024: Docker 53.9% "most-used tool" [[SO 2024 Technology](https://survey.stackoverflow.co/2024/technology)] (accessed 2026-04-24) [VERIFIED].
- Stack Overflow 2025: **Docker 71.1%** ("cloud platforms and tools"), the #1 tool ahead of npm (56.8%) and AWS (43.3%). Kubernetes 28.5% [[SO 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24) [VERIFIED]. Stack Overflow's commentary: Docker "moved from a popular tool to a near-universal one" with a +17 percentage-point jump from 2024 to 2025.
- CNCF Annual Cloud Native Survey 2024 — "Cloud Native 2024: Approaching a Decade of Code, Cloud, and Change," published April 2025, 750 respondents from fall 2024 [[CNCF 2024 Survey landing](https://www.cncf.io/reports/cncf-annual-survey-2024/), [CNCF 2024 Survey PDF](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] (accessed 2026-04-24) [VERIFIED — primary PDF fetched]. Headline numbers: Kubernetes production use **80%** (up from 66% in 2023, +20.7% YoY); containers in production **91%** (up from 80% in 2023); 93% use, pilot, or evaluate Kubernetes.
- CNCF Annual Cloud Native Survey 2025: Kubernetes production use **82%**. 98% of surveyed organizations have adopted cloud-native techniques. 66% of organizations running GenAI models use Kubernetes for inference. 58% of "cloud native innovators" use GitOps extensively vs. 23% of "adopters" [[CNCF 2025 announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)] (accessed 2026-04-24) [VERIFIED].
- CNCF End-User Technology Radar 2025: **Argo CD** used in "nearly 60% of Kubernetes clusters"; 97% of respondents run it in production; Net Promoter Score 79 [[CNCF End-User Survey — Argo CD](https://www.cncf.io/announcements/2025/07/24/cncf-end-user-survey-finds-argo-cd-as-majority-adopted-gitops-solution-for-kubernetes/)] (accessed 2026-04-24) [VERIFIED].

## Individual CNCF project production use

The 2024 survey's Figure 13 ("graduated projects in use or evaluation," Q32, n=689) reports the following **production-use** percentages among respondents evaluating any CNCF project [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] (accessed 2026-04-24) [VERIFIED]:

| Project | Production use | Evaluating |
|---|---|---|
| Kubernetes | 85% | 9% |
| Helm | 77% | 10% |
| Prometheus | 73% | 12% |
| etcd | 70% | 8% |
| containerd | 62% | 11% |
| CoreDNS | 59% | 11% |
| Cert Manager | 48% | 13% |
| Argo (all Argo projects) | 43% | 19% |
| Fluentd | 39% | 10% |
| Istio | 31% | 10% |
| CRI-O | 25% | 9% |
| Envoy | 22% | 12% |
| Cilium | 20% | 18% |
| Harbor | 20% | 9% |
| Open Policy Agent | 20% | 17% |
| Flux | 18% | 11% |
| KEDA | 16% | 11% |
| Jaeger | 14% | 17% |
| Falco | 8% | 12% |
| Linkerd | 8% | 11% |

Incubating projects (Figure 14, Q33, n=689) include: OpenTelemetry 39% production / 23% evaluating; gRPC 35%/14%; Keycloak 27%/12%; Backstage 10%/18%; Kyverno 10%/13%; Kubeflow 10%/11%; Crossplane 7%/16%; Buildpacks.io 4%/10%; OpenFeature 2%/7% [VERIFIED].

Caveat: the chart's sample is respondents using or evaluating *any* CNCF project, so percentages are relative to that denominator rather than to the general developer population. "Kubernetes 85%" here is higher than the headline "Kubernetes in production 80%" because the two questions differ.

## Containers

### Docker / OCI images

Docker popularized Linux containers starting in 2013. The image format and runtime specifications are now maintained under the **Open Container Initiative (OCI)**, which means "Docker image" and "OCI image" are the same thing today [UNVERIFIED in this session — OCI's charter is a matter of public record on opencontainers.org; I did not fetch the specific spec pages].

Docker's Stack Overflow trajectory:
- 2023 → 2024 → 2025: Docker moved from popular to near-universal among developers, culminating in 71.1% in 2025 [[SO 2025](https://survey.stackoverflow.co/2025/technology/)] [VERIFIED].

### Build tools

- **Docker** (the CLI + Docker Desktop) remains the default build tool.
- **BuildKit** (Docker's internal builder) is now the standard builder with concurrency and secrets-mounted layers.
- **Buildpacks** (Cloud Native Buildpacks, originally Heroku; now CNCF-incubating) — opinionated image building without writing Dockerfiles. CNCF 2024 Figure 14 places "Buildpacks.io" in the incubating-projects chart with **4% production / 10% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 17](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].
- **Jib** (Google) — build OCI images for JVM apps without a Docker daemon. [UNVERIFIED.]
- **Kaniko, img, ko** — alternative build tools for container-in-container or CI-native builds. [UNVERIFIED specific share.]

### Container runtimes

On Kubernetes nodes, Docker was deprecated as the container runtime in Kubernetes 1.20 (2020) and removed in 1.24 (2022) in favor of CRI-compatible runtimes:

- **containerd** — the dominant CRI runtime; CNCF graduated. CNCF 2024 Figure 13: **62% production use / 11% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED]. Default runtime on EKS, GKE, and AKS.
- **CRI-O** — Red Hat-backed, CNCF graduated; default on OpenShift. CNCF 2024: **25% production / 9% evaluating** [VERIFIED].
- **runc** sits underneath as the low-level OCI runtime.

## Kubernetes

Kubernetes is the industry-standard container orchestrator.

- **Production use:** 80% of CNCF 2024 respondents; 82% in 2025 [[CNCF 2024 Survey](https://www.cncf.io/reports/cncf-annual-survey-2024/), [CNCF 2025 announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)] [VERIFIED].
- **Near-universal evaluation:** 93% using, piloting, or evaluating per CNCF 2024 [[CNCF 2024 Survey](https://www.cncf.io/reports/cncf-annual-survey-2024/)] [VERIFIED].
- **For AI inference:** 66% of surveyed orgs running GenAI models use Kubernetes for inference per CNCF 2025 [VERIFIED].

### Managed Kubernetes

Most organizations consume Kubernetes through managed services rather than self-operating a control plane:

- **Amazon EKS** — AWS's managed Kubernetes.
- **Google Kubernetes Engine (GKE)** — Google Cloud; Google authored Kubernetes originally from their internal Borg.
- **Azure Kubernetes Service (AKS)** — Microsoft Azure.
- **Red Hat OpenShift** — Kubernetes distribution with an opinionated platform layer; commercial.
- **Rancher, Tanzu, Karmada, k3s, kind, Minikube** — other distributions / single-node tools.

No single-provider percentage breakdown was extracted from a primary source in this session. [SYNTHESIS — the three hyperscaler offerings are treated as roughly proportional to their general cloud market share, which is 30/21/12 per Synergy Q4 2024; see `08-cloud.md`.]

### Workload controllers (Kubernetes API objects)

The canonical building blocks are specified in Kubernetes's own API documentation:

- **Deployment** — most common controller for stateless apps.
- **StatefulSet** — for workloads that need stable identity, ordered start, and persistent volumes (databases, Kafka brokers).
- **DaemonSet, Job, CronJob** — per-node agents, batch, scheduled batch.
- **HorizontalPodAutoscaler (HPA), VerticalPodAutoscaler (VPA), Cluster Autoscaler / Karpenter** — autoscaling primitives. Karpenter (AWS-originated, now CNCF) is widely used for node-level autoscaling on AWS. [UNVERIFIED specific share.]

## Packaging and templating

### Helm

- De facto Kubernetes package manager. CNCF graduated project. CNCF 2024: **77% production / 10% evaluating** (n=689), second only to Kubernetes itself [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED]. Charts in Helm's format are the common way third-party software (ArgoCD, Prometheus, Grafana, Kafka operators) is distributed.
- Helm's weaknesses (string templating over YAML, Go template syntax) are well-known; alternatives like Kustomize, Timoni (CUE-based), Carvel-ytt, and Jsonnet exist but none has displaced Helm.

### Kustomize

- Built into `kubectl` since 1.14. Overlay-based configuration without templating. Often used alongside Helm (Helm for third-party; Kustomize for your own overlays).

### Operators (Kubernetes Operator Pattern)

- Custom resource definitions (CRDs) plus controllers that encode operational knowledge. Database vendors (PostgreSQL, Kafka, Redis) ship operators; OperatorHub.io aggregates them.

## Service mesh

**Adoption has plateaued.** Per CNCF 2024 Figure 19 (Q47, n=689), service mesh in production dropped from **50% in 2023 to 42% in 2024** (16% "most or all apps" + 26% "a few apps"); the "no near-term plans to use" cohort doubled from **16% to 31%**; pilots fell from 20% to 11% [[CNCF 2024 Survey PDF, p. 22](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] (accessed 2026-04-24) [VERIFIED — primary PDF fetched]. The PDF attributes the decline to "concerns over complexity, cost, and performance."

### Istio

- Google/IBM-originated; most mindshare in the "classic" service-mesh category. CNCF graduated project. CNCF 2024: **31% production / 10% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].
- **Ambient Mesh** (sidecar-less) shipped 2024, reducing the per-pod overhead that was the main operational criticism of Istio. [UNVERIFIED specific release dates in this session.]

### Linkerd

- CNCF graduated, Rust data plane. Small, simple, fast. Preferred in shops that want service mesh without Istio's complexity. CNCF 2024: **8% production / 11% evaluating** (n=689) — an order of magnitude behind Istio in the graduated-projects chart [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].

### Cilium Service Mesh

- eBPF-based, avoids sidecars. Fast-growing in 2024–2026. CNCF graduated. CNCF 2024 (Cilium project overall, not mesh-specifically): **20% production / 18% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED — the chart measures Cilium as a whole project, not separating CNI-only from full mesh].

### Consul (HashiCorp)

- Multi-platform service mesh; less Kubernetes-specific than Istio/Linkerd.

### When a mesh is worth it — the synthesis

Service mesh is less compelling for teams where Cilium's base CNI already provides mTLS and network policy, where API gateways handle cross-service auth, or where workloads are too small to justify a control-plane overhead. [SYNTHESIS from the CNCF 2024 plateau data and public postmortems.]

## Ingress and API gateways

- **NGINX Ingress Controller** — classic default. Kubernetes-community-maintained variant plus F5-NGINX variant.
- **Envoy-based** — Contour, Emissary (formerly Ambassador), Istio Ingress Gateway.
- **Traefik** — simple Kubernetes-native ingress; widely used in smaller clusters.
- **Kubernetes Gateway API** — the successor to the long-standing `Ingress` resource. **v1.0 GA released 31 October 2023**: the Gateway, GatewayClass, and HTTPRoute resources graduated to v1 / GA, with backwards-compatibility guarantees [[Kubernetes blog — Gateway API v1.0 GA Release, 31 Oct 2023](https://kubernetes.io/blog/2023/10/31/gateway-api-ga/)] (accessed 2026-04-24) [VERIFIED]. The GAMMA (service-mesh) initiative reached GA in the Standard Channel starting at v1.1.0 [[Gateway API — sigs.k8s.io/gateway-api](https://gateway-api.sigs.k8s.io/)] [VERIFIED]. Most projects now implement Gateway API alongside classic Ingress.

## GitOps

GitOps — declaring cluster state in Git and reconciling it against live clusters — is now the common deployment pattern on Kubernetes.

- **Argo CD (CNCF graduated)** — dominant GitOps controller. CNCF End-User Survey: Argo CD in "nearly 60% of Kubernetes clusters"; 97% in production; NPS 79 [[CNCF — Argo CD majority](https://www.cncf.io/announcements/2025/07/24/cncf-end-user-survey-finds-argo-cd-as-majority-adopted-gitops-solution-for-kubernetes/)] (accessed 2026-04-24) [VERIFIED]. In the 2024 Annual Survey (broader respondent pool, not just GitOps users), the "argo" project family reports **43% production / 19% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].
- **Flux (CNCF graduated)** — lighter-weight, Kustomize-native, pull-based. Preferred where Flux's multi-tenant model or simpler operator model fits. CNCF 2024: **18% production / 11% evaluating** [VERIFIED].
- **Kargo, GitOps Promoter, Codefresh GitOps** — emerging tools layered on top of Argo CD / Flux for environment promotion across dev/staging/prod [VERIFIED via the same CNCF announcement mentioning these as emerging].

CNCF 2025: 58% of "cloud native innovators" use GitOps extensively vs. 23% of "adopters" — a large gap between organizations that self-identify as innovators and the broader adopter population [[CNCF 2025 announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)] [VERIFIED].

## Policy, security, and supply chain for Kubernetes

- **OPA / Gatekeeper** — CNCF graduated; Rego policy language. CNCF 2024: **20% production / 17% evaluating** [[CNCF 2024 Survey PDF, p. 16](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].
- **Kyverno** — Kubernetes-native policy language; listed as a CNCF incubating project in the 2024 survey's incubating-projects chart. CNCF 2024: **10% production / 13% evaluating** (n=689) [[CNCF 2024 Survey PDF, p. 17](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)] [VERIFIED].
- **Falco** — runtime security; CNCF graduated. CNCF 2024: **8% production / 12% evaluating** [VERIFIED].
- **Cosign / Sigstore** — OCI image signing; OCI-ecosystem standard.
- **Trivy** — image vulnerability scanning; widely integrated. [UNVERIFIED current project status — Aqua Security-sponsored.]

## Putting the stack together

For a new company running Kubernetes in 2026, the commonest default stack [SYNTHESIS — from CNCF, ThoughtWorks Technology Radar, and cloud-vendor reference architectures]:

- **Runtime:** containerd on managed Kubernetes (EKS / GKE / AKS).
- **Node autoscaling:** Karpenter on AWS; native on GKE/AKS.
- **Build:** Docker BuildKit or Buildpacks in CI.
- **Packaging:** Helm + Kustomize overlays.
- **Deployment / delivery:** Argo CD with PR-driven promotion.
- **Ingress:** NGINX or the managed cloud-vendor ingress; Gateway API where supported.
- **Service mesh:** only where clearly justified — Linkerd for simplicity, Cilium Service Mesh for eBPF-native, Istio Ambient for the Istio ecosystem. Many teams run none.
- **Observability:** Prometheus + Grafana + OpenTelemetry (see `10-observability.md`).
- **Policy:** OPA/Gatekeeper or Kyverno.
- **Supply chain:** Cosign image signing, Trivy scanning.

## Sources (accessed 2026-04-24)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [CNCF Annual Cloud Native Survey 2024 — "Cloud Native 2024" landing page](https://www.cncf.io/reports/cncf-annual-survey-2024/)
- [CNCF Annual Cloud Native Survey 2024 — report PDF (March 2025)](https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf)
- [Kubernetes blog — Gateway API v1.0: GA Release (31 Oct 2023)](https://kubernetes.io/blog/2023/10/31/gateway-api-ga/)
- [Kubernetes Gateway API docs — gateway-api.sigs.k8s.io](https://gateway-api.sigs.k8s.io/)
- [CNCF Annual Cloud Native Survey 2025 — Announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/)
- [CNCF End-User Technology Radar — Argo CD majority (2025)](https://www.cncf.io/announcements/2025/07/24/cncf-end-user-survey-finds-argo-cd-as-majority-adopted-gitops-solution-for-kubernetes/)
- [OpenTelemetry — CNCF project page](https://www.cncf.io/projects/opentelemetry/)

## Open questions

- **Managed-Kubernetes market share by hyperscaler** — I did not find a primary source distinguishing EKS/GKE/AKS usage.
- **Karpenter usage share** — anecdotal; no primary survey.
- **Istio Ambient Mesh adoption** — released 2024, not surveyed directly in the 2024 CNCF report.
- **Cilium Service Mesh vs. Cilium CNI split** — the 2024 CNCF chart measures "Cilium" as a single project; the proportion of respondents using Cilium's mesh features specifically is not separable from the chart.
