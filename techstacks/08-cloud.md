---
name: cloud platforms
description: Industry-standard cloud providers and the services that define each
type: research
---

# Cloud platforms

**Question:** Which cloud providers and cloud services are industry-standard in 2026, and what evidence supports the share claims?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Public-cloud IaaS/PaaS providers and their canonical services. Private/on-prem infrastructure is mentioned where relevant but not centered.

## Shape of the decision

Three "hyperscalers" dominate the cloud infrastructure market:

- **Amazon Web Services (AWS)** — first-mover and still largest.
- **Microsoft Azure** — strong in enterprise, deeply integrated with Microsoft 365 and Active Directory / Entra ID.
- **Google Cloud Platform (GCP)** — third by size, strong in data/analytics/ML and Kubernetes.

Below the Big Three, specialist and regional providers matter for specific niches:

- **Cloudflare** — edge / serverless / DNS / CDN / DDoS protection.
- **Oracle Cloud** — Oracle-specific workloads.
- **Alibaba Cloud** — dominant in China.
- **DigitalOcean, Linode (now Akamai), Hetzner, Scaleway, Fly.io** — smaller/regional providers for developer-friendly compute and managed databases.
- **Vercel, Netlify, Render, Railway, Fly.io** — developer platforms built on hyperscalers; serve the "don't want to think about infrastructure" segment.
- **CoreWeave, Lambda Labs, Together AI, Modal** — specialized GPU / AI infrastructure providers, rising fast in 2024–2026.

## Evidence base

### Global cloud infrastructure market share — Q4 2024 (Synergy Research)

From [[Synergy Research — 2024 cloud market $330B](https://www.srgresearch.com/articles/cloud-market-jumped-to-330-billion-in-2024-genai-is-now-driving-half-of-the-growth)] (accessed 2026-04-24) [VERIFIED]:

- **Market size:** Full-year 2024 $330.4B, Q4 2024 $90.6B. +22% YoY in Q4; +$60B YoY full-year.
- **Share (Q4 2024):**
  - **Amazon AWS — 30%**
  - **Microsoft — 21%**
  - **Google — 12%**
  - Top 3 combined — 68%
- **GenAI as a driver:** Synergy attributes half of the 2023–2024 market growth to generative AI (new GenAI platform services, GPU-as-a-service, AI enhancements to other cloud services).
- **Rising tier-two providers:** CoreWeave (entered top 20 in 2024), Oracle, Snowflake, Cloudflare, Databricks — highest YoY growth rates among non-hyperscalers.

### Developer-level "which cloud do you use" (Stack Overflow)

From [[Stack Overflow 2024 Technology](https://survey.stackoverflow.co/2024/technology)] (accessed 2026-04-24) [VERIFIED]:

- AWS — 48%
- Azure — 27.8%
- Google Cloud — 25.1%
- Cloudflare — 15.1%
- Firebase — 13.9%

From [[Stack Overflow 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24) [VERIFIED]:

- Cloud platforms are listed within the combined "Cloud Platforms & Tools" section; AWS is reported at 43.3% (Stack Overflow's format changed slightly; Docker/npm/AWS appear together in the same ranking). Kubernetes 28.5%.

**Reconciling the two views.** Synergy measures dollar revenue; Stack Overflow measures developer usage. A developer using both AWS for their day job and Cloudflare for personal projects counts twice in Stack Overflow but not in Synergy. The two views agree on the order of magnitude: AWS ~first, Azure and Google next, Cloudflare as the fourth-biggest name-recognition player.

## AWS

### Why AWS is first

- **First-mover** (2006 EC2/S3 launch), deepest service catalog (>200 services).
- **Scale advantage** in data-center real estate and custom silicon (Graviton CPUs, Nitro hypervisor, Trainium/Inferentia for ML).
- **Partner ecosystem**: the largest third-party system integrators, training market, and marketplace.

### Services that are industry-standard within AWS

[SYNTHESIS — these are the services most consistently referenced across ThoughtWorks Technology Radar, cloud architecture blogs, and the "AWS Well-Architected Framework" documentation, which I did not individually fetch.]

- **Compute:** EC2, ECS / Fargate (containers), **EKS** (Kubernetes), Lambda (serverless), App Runner (simplified PaaS).
- **Storage:** S3 (object), EBS (block), EFS (file), FSx (managed file systems).
- **Database:** RDS (managed relational: Postgres, MySQL, Oracle, SQL Server), **Aurora** (AWS-native compatible Postgres/MySQL with separated compute/storage), DynamoDB (key-value/doc), ElastiCache (Redis/Memcached), Redshift (warehouse), Timestream (time-series), Neptune (graph).
- **Networking:** VPC, Route 53 (DNS), CloudFront (CDN), Direct Connect, Transit Gateway, Global Accelerator.
- **Identity & security:** IAM, KMS, Secrets Manager, Certificate Manager, WAF, Shield, GuardDuty, CloudTrail, Security Hub.
- **Messaging / eventing:** SQS, SNS, EventBridge, MSK (managed Kafka), Kinesis.
- **AI/ML:** SageMaker, Bedrock (foundation-model APIs), Trainium/Inferentia for custom silicon.
- **Observability:** CloudWatch (metrics/logs), X-Ray (tracing), OpenSearch Service.

## Microsoft Azure

### Why Azure is second

- **Deep enterprise integration** with Microsoft 365, Windows Server, SQL Server, Active Directory (now Entra ID), .NET, Office, Teams.
- **Government / regulated** — Azure's compliance posture and government-cloud offerings match or exceed AWS in some geographies.
- **Microsoft's OpenAI relationship** — Azure was the primary OpenAI training and production cloud through 2023–2024; Azure OpenAI Service is a differentiated position in the GenAI market.

### Canonical Azure services

[SYNTHESIS — same caveat as the AWS section; based on Azure's own documentation hierarchy which I did not fetch individually.]

- **Compute:** Azure Virtual Machines, Azure Container Instances, Azure Container Apps, **AKS** (Kubernetes), Azure Functions, App Service (PaaS).
- **Storage:** Blob Storage, Azure Files, Azure NetApp Files, Managed Disks.
- **Database:** Azure SQL Database, Azure Database for PostgreSQL / MySQL, Cosmos DB (multi-model document/KV/graph), Azure Synapse (warehouse).
- **Identity:** Microsoft Entra ID (formerly Azure AD) — the enterprise-identity linchpin for Microsoft shops.
- **AI/ML:** Azure Machine Learning, Azure OpenAI Service, Cognitive Services.
- **DevOps:** Azure DevOps (integrated CI/CD/boards), GitHub Actions (Microsoft owns GitHub too).

## Google Cloud Platform (GCP)

### Why GCP is third (and particular)

- **Google's own data/AI/search infrastructure.** Google invented many of the concepts that became cloud-native: Borg → Kubernetes, MapReduce → Hadoop, Spanner, BigQuery, TensorFlow.
- **Strength in data/analytics/ML.** BigQuery is widely considered the strongest serverless data warehouse; Vertex AI hosts Gemini models; TPUs are a real alternative to GPUs for certain ML workloads.
- **Weakness in breadth.** GCP has fewer services than AWS and less dominant in enterprise than Azure.

### Canonical GCP services

[SYNTHESIS — based on GCP documentation organization.]

- **Compute:** Compute Engine, **GKE** (Kubernetes — the first managed K8s), Cloud Run (serverless containers), Cloud Functions.
- **Storage:** Cloud Storage (object), Persistent Disk, Filestore.
- **Database:** Cloud SQL, AlloyDB (Postgres-compatible), Spanner (globally distributed, strong consistency), Bigtable (wide column), Firestore (document), Memorystore (Redis/Memcached), **BigQuery** (warehouse).
- **Identity:** Cloud IAM, Identity Platform, Workforce Identity Federation.
- **AI/ML:** Vertex AI, Gemini models, TPUs (Tensor Processing Units).
- **Data:** Dataflow (Apache Beam), Pub/Sub, Dataproc (Spark/Hadoop), Composer (Airflow).

## Cloudflare

Cloudflare is not a general-purpose IaaS but is near-ubiquitous at the edge:

- **CDN, DNS, DDoS protection** — Cloudflare's original business.
- **Workers** — V8-isolate-based serverless compute at the edge (over 300 cities globally per Cloudflare marketing; [UNVERIFIED specific figure]). Often paired with **Durable Objects** for state and **R2** for S3-compatible object storage with zero egress fees.
- **Zero Trust** — ZTNA (Access), secure web gateway, CASB.
- **AI** — Workers AI for inference at edge; partnerships with Hugging Face.

Cloudflare is the commonest "second cloud" for companies whose primary is AWS/Azure/GCP. [SYNTHESIS.]

## Vercel, Netlify, Render, Railway, Fly.io (developer platforms)

These platforms sit on top of hyperscalers and offer opinionated deployment targets, primarily for frontend and small-to-medium backends:

- **Vercel** — Next.js's sponsor/company; the default deployment target for Next.js apps.
- **Netlify** — Originator of the "Jamstack" term; Gatsby-era dominant, now a general JAMstack/static/functions host.
- **Render, Railway, Fly.io** — "Heroku-like" modern PaaS. Fly.io runs Firecracker microVMs in dozens of regions.
- **Supabase, Convex, PlanetScale, Neon** — developer-oriented managed databases.

None of these has hyperscaler-scale market share but they are the default path for small teams shipping new products fast. [SYNTHESIS.]

## Specialized AI-cloud providers

A new category has emerged since 2023 for GPU-heavy workloads:

- **CoreWeave** — reported by Synergy as entering the top 20 IaaS vendors in 2024 [[Synergy Research](https://www.srgresearch.com/articles/cloud-market-jumped-to-330-billion-in-2024-genai-is-now-driving-half-of-the-growth)] [VERIFIED].
- **Lambda Labs, Together AI, Modal, Runpod, Oblivus** — GPU-focused clouds and serverless-GPU providers.

These are notable but too new to have stable share data.

## Multi-cloud and "platform engineering"

The prevailing 2024–2026 pattern:

- **Primary cloud** for most workloads (usually AWS).
- **Cloudflare** at the edge for DNS / CDN / WAF / some workloads.
- **A specialist** for specific workloads (e.g., Snowflake for warehouse, Databricks for ML, CoreWeave for training).
- **Platform engineering** teams build an internal developer platform (IDP) on top of this substrate to make the consumption uniform — see the ThoughtWorks Technology Radar's recurring coverage of the pattern [UNVERIFIED specific radar reference in this session].

## Putting it together (typical 2026 defaults)

- **SaaS startup:** Primary AWS (EKS or ECS/Fargate) + RDS Postgres + CloudFront + Cloudflare for edge + GitHub Actions + Terraform.
- **Enterprise / Microsoft-centric:** Azure (AKS) + Azure SQL + Entra ID + Azure DevOps or GitHub Actions + Bicep/Terraform.
- **Data-heavy / Google-aligned:** GCP (GKE) + BigQuery + Vertex AI + Pub/Sub + Google Cloud Build.
- **Small/frontend-centric:** Vercel (or Netlify) for frontend + Supabase/Neon for data + Cloudflare for edge.
- **Training large models:** CoreWeave / Lambda for GPU + S3 or R2 for data + Weights & Biases for experiment tracking.

## Sources (accessed 2026-04-24)

- [Synergy Research Group — 2024 cloud market $330B](https://www.srgresearch.com/articles/cloud-market-jumped-to-330-billion-in-2024-genai-is-now-driving-half-of-the-growth)
- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)

## Open questions

- **Developer-PaaS share** — no primary survey for Vercel/Netlify/Render/Fly usage share.
- **Cloudflare Workers adoption numbers** — widely cited but no independent survey extracted.
- **Multi-cloud adoption rate** — CNCF surveys have asked; I did not extract.
- **Region-level share within each cloud** — Azure's EU share vs AWS, e.g., is material for GDPR decisions but not fetched.
- **AI-cloud (CoreWeave, Lambda, Modal) specific sizing** — still early; no stable share data.
- **Alibaba Cloud global ex-China share** — not fetched.
- **IBM Cloud, Oracle Cloud** — mentioned; specific industry-standard services not enumerated here.
