---
name: ai/ml and data engineering
description: Industry-standard ML frameworks, MLOps tooling, LLM application frameworks, and data-engineering stacks
type: research
---

# AI / ML and Data Engineering

**Question:** What are the current industry-standard tools and practices for machine learning, LLM application development, and data engineering in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Deep-learning and classical-ML frameworks, model hubs, MLOps (tracking, registry, serving, feature stores), LLM application frameworks (RAG / agents), data pipelines (orchestration, transformation), and data warehouses / lakehouses. Database engines are in `05-databases-data.md`. AI-specific cloud providers are discussed in `08-cloud.md`.

## Shape of the decision

Modern AI/ML work splits into several increasingly-overlapping tracks:

1. **Deep learning framework.** PyTorch has become the dominant research and increasingly production framework; TensorFlow still large in production-deploy and mobile/edge scenarios. JAX is the emerging research-second-choice for some high-performance work.
2. **Model hub and transfer-learning.** Hugging Face is the de-facto model hub for transformers; TensorFlow Hub and PyTorch Hub are secondary.
3. **Classical ML.** scikit-learn, XGBoost, LightGBM, CatBoost. Still load-bearing for tabular data.
4. **MLOps — experiment tracking, registry, serving.** MLflow (open-source dominant), Weights & Biases (SaaS, research-heavy), Kubeflow (Kubernetes-native), cloud-vendor platforms (SageMaker, Vertex AI, Azure ML).
5. **LLM application layer.** LangChain, LlamaIndex, LlamaStack, LangGraph, plus vendor SDKs (OpenAI, Anthropic, AWS Bedrock). Increasingly Model Context Protocol (MCP) for tool integration.
6. **Vector stores / embeddings.** pgvector (Postgres extension), Pinecone, Weaviate, Qdrant, Milvus, Chroma — see `05-databases-data.md` for deeper coverage.
7. **Data orchestration.** Apache Airflow remains dominant; Dagster and Prefect are the active challengers.
8. **Data transformation.** dbt is the de-facto SQL transformation tool for warehouses.
9. **Warehouses / lakehouses.** Snowflake, Databricks, BigQuery, Redshift, Azure Synapse, Fabric. Apache Iceberg and Delta Lake are the table-format competitors for open-format lakehouses.

## Evidence base

- **GitHub generative-AI activity — primary.** [[GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] (accessed 2026-04-24) [VERIFIED]: Python overtook JavaScript as GitHub's most-used language in 2024. **137,000 public generative-AI projects** (+98% YoY). **70,000 new generative-AI projects** launched in 2024. **59% surge in contributions** to generative-AI projects. Top project by contributors: `ollama/ollama`. **5.2B contributions** across all projects. **Over 1M free-tier Copilot users** among teachers, students, maintainers.
- **PyTorch dominance on Hugging Face — secondary.** Multiple secondary sources report that "almost 92% of models on Hugging Face are PyTorch-exclusive" (rising from ~85% in 2023) [UNVERIFIED — secondary summaries; I did not fetch an official Hugging Face page confirming this figure]. Paperswithcode is widely cited as showing PyTorch in ~80% of deep-learning papers [UNVERIFIED primary].
- **MLOps market scale — secondary.** "MLOps market grew from $1.58B in 2024 to projected $19.55B by 2032" — secondary-source forecast; original analyst report not fetched [UNVERIFIED primary].
- **Airflow scale — secondary.** "More than 30 million downloads per month" [UNVERIFIED — Astronomer-reported; not fetched as primary here].
- **Data-warehouse revenue — secondary.** "Snowflake $3.8B run rate (+27% YoY), Databricks $2.6B (+57% YoY) in 2024" — from SaaS commentary [UNVERIFIED — not fetched from Snowflake / Databricks filings directly].

## Deep learning frameworks

### PyTorch

- Originally Facebook / Meta (FAIR); now governed by the Linux Foundation's **PyTorch Foundation** (established September 2022) [UNVERIFIED specific date in this session; widely reported].
- **Dominant in research and in transformer-based workloads.** Most new architectures are published with PyTorch reference implementations first.
- Ecosystem: `torch.nn`, `torch.compile` (dynamo/inductor JIT), `torch.distributed`, FSDP for sharded training, TorchServe for serving, TorchScript / `torch.export` for production.
- Mobile: **ExecuTorch** is the newer mobile/edge runtime; PyTorch Mobile is being superseded [UNVERIFIED specific deprecation timing].

### TensorFlow

- Google-maintained. Lost research-frontier mindshare to PyTorch through 2019–2023 but retains substantial production/edge footprint.
- **Keras 3** (multi-backend: TensorFlow, JAX, PyTorch) released 2023 reframes Keras as a framework-agnostic high-level API [UNVERIFIED specific release date].
- Deployment: TensorFlow Serving, TensorFlow Lite (mobile/edge), TensorFlow.js.
- Strong in Google Cloud (Vertex AI) and in older production models still in service.

### JAX

- Google Research; functional / transformations-based (`jit`, `grad`, `vmap`, `pmap`).
- Dominant in Google Brain/DeepMind-derived work and in some HPC research contexts; smaller industry share than PyTorch or TF.
- Ecosystem: Flax (neural nets), Optax (optimizers), Haiku (DeepMind-originated).

### ONNX

- **Open Neural Network Exchange** — interchange format. PyTorch → ONNX → TensorRT / OpenVINO / ONNX Runtime is a common production-deployment path.

## Classical ML

- **scikit-learn** — the stdlib of classical ML: linear models, trees, clustering, model selection. Still the first recommendation for tabular problems.
- **XGBoost, LightGBM, CatBoost** — gradient-boosted trees; dominant for tabular prediction tasks and Kaggle competitions.
- **statsmodels** — classical statistics.
- **Scipy / NumPy / pandas / Polars** — foundational. **Polars** (Rust-backed, lazy API) is rising as a pandas alternative for larger-than-memory tabular work.
- **DuckDB** — in-process OLAP SQL; used heavily in data-science and ML-prep workflows. See `05-databases-data.md`.

## Model hubs and transfer learning

- **Hugging Face Hub** — de-facto hub for transformer-family models, datasets, and inference endpoints. Libraries: `transformers`, `datasets`, `tokenizers`, `accelerate`, `peft` (parameter-efficient fine-tuning), `trl` (reinforcement learning), `evaluate`, `optimum`.
- **Hugging Face positioning.** Almost all new open-weight models publish first to Hugging Face. Secondary sources put PyTorch's share of HF models near 92% [UNVERIFIED].
- **TensorFlow Hub / Kaggle Models** — secondary to Hugging Face in 2024–2026.

## MLOps

### Experiment tracking, model registry

- **MLflow** — open-source, Databricks-backed. Provides tracking, model registry, deployment, and projects abstractions. Widely adopted across industry.
- **Weights & Biases (W&B)** — SaaS (and self-hostable). Popular in research-heavy teams; used at OpenAI, Nvidia, Stability [UNVERIFIED — W&B marketing claim, not independently verified].
- **Comet, Neptune.ai, Aim** — smaller alternatives.
- **DVC** — data and model versioning in Git; often paired with MLflow or W&B.

### Orchestration for ML pipelines

- **Kubeflow** — Kubernetes-native ML pipeline platform. Scale target: teams running on their own k8s clusters.
- **Metaflow** (Netflix, now Outerbounds) — Python-decorator-driven pipeline tool.
- **Prefect, Dagster, Airflow** — general-purpose orchestrators often used to coordinate ML training jobs.
- **Flyte** (CNCF incubating, from Lyft) — production-grade typed-pipeline framework.
- **Ray / KubeRay** — distributed Python for ML, reinforcement learning, LLM serving (Ray Serve).

### Model serving

- **TorchServe, TensorFlow Serving** — framework-native.
- **Triton Inference Server** (Nvidia) — multi-framework, GPU-optimized.
- **vLLM, TensorRT-LLM, TGI (Text Generation Inference — Hugging Face)** — LLM-specific serving stacks. vLLM (PagedAttention) has rapid adoption in self-hosted LLM serving [VERIFIED as a widely-reported pattern; specific numbers not fetched].
- **BentoML, KServe, Seldon Core, Cortex** — serving frameworks / platforms.

### Feature stores

- **Feast** — open-source feature store.
- **Tecton** — commercial, Feast-based.
- Cloud-native: SageMaker Feature Store, Vertex AI Feature Store, Databricks Feature Store.

### Cloud-vendor end-to-end MLOps

- **AWS SageMaker** — broad AWS-native suite.
- **Google Vertex AI** — integrates with BigQuery, Gemini models.
- **Azure Machine Learning** — integrates with Azure ML Studio, Azure OpenAI.
- **Databricks (Machine Learning / Mosaic AI)** — lakehouse + ML/LLM.

## LLM application frameworks

### Orchestration / agents

- **LangChain** — broad-scope framework for composing prompts, retrievers, agents, tools. Large adoption; notable churn across versions.
- **LangGraph** — LangChain's graph-based orchestration for more-complex agent workflows.
- **LlamaIndex** — data-ingestion-focused framework; strong retrieval/RAG primitives. Common in document-heavy enterprise.
- **Haystack (deepset)** — earlier NLP pipeline framework; still maintained.
- **DSPy** (Stanford) — programmatic-prompt framework; compiles programs to prompts.
- **Semantic Kernel** (Microsoft) — .NET / Python LLM orchestration; strong in Microsoft-centric orgs.
- **Pydantic AI** — Python-native, Pydantic-model-driven agent framework.
- **Claude Agent SDK** — Anthropic's SDK for building production agents on top of Claude.

### Tool and context standards

- **Model Context Protocol (MCP)** — Anthropic-originated open standard for connecting LLMs to tools and data sources; increasingly adopted across vendors since 2024 [UNVERIFIED specific adoption numbers].
- **Function calling / tool use** — OpenAI-popularized, now supported across most model APIs.
- **OpenAI-compatible APIs** — many self-hosted LLM servers (vLLM, Ollama, LM Studio, LiteLLM) implement the OpenAI Chat Completions API as a portability layer.

### RAG components

- **Vector stores:** pgvector, Qdrant, Weaviate, Pinecone, Milvus, Chroma, Elasticsearch/OpenSearch k-NN, Redis VSS (see `05-databases-data.md`).
- **Embeddings:** OpenAI text-embedding-3, Cohere embed, Voyage AI, open models (BGE, E5, Jina, Nomic).
- **Rerankers:** Cohere Rerank, Voyage Rerank, Jina Rerank, cross-encoders from sentence-transformers.

### Evaluation

- **Ragas, DeepEval, Promptfoo, LangSmith, Arize Phoenix, Braintrust, Humanloop** — LLM evaluation and observability tools. No primary survey; adoption growing rapidly [UNVERIFIED share].

## Foundation-model providers and self-hosted LLMs

- **Proprietary API providers:** Anthropic (Claude), OpenAI (GPT, o-series), Google (Gemini), Mistral (La Plateforme / Codestral), Cohere, AI21.
- **Cloud aggregators:** AWS Bedrock, Azure OpenAI, Google Vertex AI Model Garden. Offer access to multiple foundation models under cloud contract / data-residency.
- **Open-weight model families** widely used in 2024–2026: Meta Llama 3/4, Mistral (Mixtral, Mistral Small/Medium/Large), Qwen (Alibaba), DeepSeek, Gemma (Google), Phi (Microsoft), Command R / R+ (Cohere). [UNVERIFIED specific model-version lineups are dated; this area changes monthly.]
- **Self-hosted serving:** Ollama (local desktop), LM Studio, text-generation-webui, vLLM (production), TGI, TensorRT-LLM, SGLang.
- **GPU / accelerator clouds:** CoreWeave, Lambda Labs, Crusoe, Modal, Runpod, Together AI, Fireworks, Baseten — see `08-cloud.md`.

## Data engineering: orchestration and transformation

### Orchestration

- **Apache Airflow** — open-source dominant. "More than 30M monthly downloads" [UNVERIFIED primary] [VERIFIED qualitatively as the long-standing default].
- **Dagster** — software-defined-assets orientation; deep dbt integration. Growing in modern-data-stack teams.
- **Prefect** — Pythonic, dynamic DAGs; popular in ML-adjacent workflows.
- **Flyte** — typed, CNCF incubating; pipelines and ML.
- **Mage, Kestra, Argo Workflows** — smaller footprints.
- **Azure Data Factory / AWS Step Functions / Google Cloud Composer (managed Airflow)** — cloud-native managed orchestration.

### Transformation

- **dbt (data build tool)** — de-facto SQL transformation framework for warehouse-native modeling. dbt Core is open source; dbt Cloud is the commercial SaaS. Owned by **dbt Labs**.
- **SQLMesh (Tobiko Data)** — dbt challenger; focuses on virtual data environments and contract-first.
- **Apache Spark** — large-scale batch and streaming; the Databricks runtime underneath.
- **Apache Beam / Google Dataflow** — unified batch/stream.
- **Polars, DuckDB, Ibis** — lightweight / in-process transformations.

### Ingestion / ELT

- **Fivetran, Airbyte, Meltano, Stitch, Rivery** — managed / open-source EL tools.
- **Debezium + Kafka** — change-data-capture from databases into streaming.
- **Estuary Flow, Materialize, RisingWave** — streaming transformation.

### Data catalogs, quality, lineage

- **DataHub, Amundsen, OpenMetadata, Atlan, Collibra, Alation** — catalogs.
- **Great Expectations, Soda, Monte Carlo, Bigeye, Elementary, dbt tests** — data quality / observability.
- **OpenLineage** — open standard for pipeline lineage metadata.

## Warehouses and lakehouses

### Warehouses

- **Snowflake** — cloud-native shared-data warehouse. Separation of storage and compute, secure data sharing, wide ecosystem integrations.
- **Google BigQuery** — serverless warehouse; strong with ML functions and Looker.
- **AWS Redshift** — older warehouse; Redshift Serverless and RA3 moves toward shared-storage.
- **Azure Synapse / Microsoft Fabric** — Azure-native; Fabric unifies Synapse, Data Factory, Power BI.

### Lakehouses

- **Databricks (Delta Lake, Unity Catalog, Photon)** — the lakehouse pioneer; ML-heavy positioning.
- **Apache Iceberg** — open table format; adopted by Snowflake, Databricks (via UniForm), BigQuery, many others. The 2024–2025 "open-table-format war" is Iceberg-vs-Delta-vs-Hudi, with Iceberg winning broad vendor support.
- **Apache Hudi** — older open table format; strong where CDC-heavy.
- **Starburst, Dremio, Trino (open), Presto** — federated SQL engines over lakehouses.

### Streaming / real-time

- **Kafka** (plus Confluent / Redpanda / WarpStream) — de-facto streaming. See `05-databases-data.md`.
- **Apache Flink** — stream processing; dominant for exactly-once state-heavy stream jobs.
- **Materialize, RisingWave, ClickHouse** — streaming SQL / real-time OLAP.

## AI governance, safety, and policy frameworks

- **NIST AI Risk Management Framework (AI RMF 1.0, 2023)** and AI RMF generative-AI profile — US public-sector reference.
- **ISO/IEC 42001:2023** — AI management system standard.
- **EU AI Act** — entered into force August 2024 [UNVERIFIED specific date]; risk-tiered obligations phase in through 2025–2027.
- **NIST SP 800-218A** — SSDF companion for generative-AI model development (see `13-security.md`).

## Putting the stack together (typical 2026 defaults)

- **Research / prototyping:** PyTorch + Hugging Face + W&B + Jupyter/VS Code notebooks + Ray for distributed training.
- **Production ML (tabular / classic):** scikit-learn / XGBoost + MLflow + cloud-vendor serving (SageMaker / Vertex AI / Azure ML) or KServe on Kubernetes.
- **Production deep learning:** PyTorch + Triton or TorchServe + vLLM/TGI for LLMs + Weights & Biases or MLflow tracking + feature store (Feast / Tecton / cloud-native).
- **LLM application / RAG:** Model via API (Anthropic, OpenAI, Bedrock) or self-hosted (vLLM/Ollama) + LangChain or LlamaIndex + pgvector or Qdrant/Pinecone + evaluation with LangSmith / Phoenix / Ragas + observability (OpenTelemetry traces).
- **Modern data stack:** Fivetran / Airbyte → Snowflake or BigQuery → dbt → BI (Looker / Hex / Mode / Tableau). Orchestrator: Airflow, Dagster, or Prefect.
- **Lakehouse-first:** Object storage (S3/GCS/ADLS) + Iceberg tables + Trino/Spark/Databricks + Unity Catalog or Polaris (Snowflake's) catalog + dbt on top.

## Sources (accessed 2026-04-24)

- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
- [Hugging Face](https://huggingface.co)
- [PyTorch Foundation / Linux Foundation](https://pytorch.org/foundation)
- [NIST AI Risk Management Framework 1.0](https://www.nist.gov/itl/ai-risk-management-framework)
- [EU AI Act — European Commission](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)

## Open questions

- **Exact PyTorch vs TF share of new models on Hugging Face** — widely cited ~92% PyTorch; should be verified against a Hugging Face analytics dashboard.
- **MLOps market-size primary figures** — all publicly circulating $B numbers are analyst-firm projections; no primary data fetched.
- **Airflow's exact current download/usage figures** — Astronomer / Apache reports exist; not fetched this session.
- **LangChain vs LlamaIndex adoption split** — anecdotal; no primary survey located.
- **Vector-DB usage share** — no primary survey (pgvector vs Pinecone vs Qdrant vs Weaviate).
- **Snowflake and Databricks financials for 2024** — specific revenue / ARR figures should be taken from each company's investor filings if used for decisions.
- **Iceberg adoption share among lakehouses** — widely described as winning; no single primary survey located.
- **EU AI Act timeline precision** — obligations phase in between 2025 and 2027; exact dates per provision should be taken from the official Regulation text if decisions depend on them.
- **MCP (Model Context Protocol) adoption** — growing rapidly qualitatively; no primary survey data located.
