---
name: databases and data
description: Industry-standard database and data-storage choices, with evidence
type: research
---

# Databases and data

**Question:** What are the current industry-standard choices for data storage, analytics, and streaming in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** OLTP, document/key-value stores, search, caching, data warehousing, streaming, and vector stores. Embedded databases and niche analytical systems are mentioned where relevant but not centered.

## Shape of the decision

Data storage is not one market; it's half a dozen overlapping markets. The dominant choices in each:

| Category | Dominant choices |
|---|---|
| Relational (OLTP) — new projects | **PostgreSQL** (default), MySQL, SQL Server (Microsoft shops), Oracle (legacy/regulated) |
| Document | **MongoDB**, plus Firestore / DynamoDB as managed alternatives |
| Key-value / cache | **Redis**, Memcached, Valkey (open-source Redis fork) |
| Search | Elasticsearch, OpenSearch, Meilisearch, Typesense |
| Data warehouse | **Snowflake**, **Databricks**, **BigQuery**, Redshift |
| Streaming | **Apache Kafka** (self-managed or Confluent, MSK, Redpanda) |
| Vector / embedding | Pinecone, Weaviate, Qdrant, Milvus, pgvector (Postgres extension) |

The rest of this document works through each category with cited evidence.

## Evidence base

### Stack Overflow Developer Survey — databases (all respondents)

2024 [[SO 2024 Technology](https://survey.stackoverflow.co/2024/technology)] (accessed 2026-04-24) [VERIFIED]:

1. PostgreSQL — 48.7%
2. MySQL — 40.3%
3. SQLite — 33.1%
4. Microsoft SQL Server — 25.3%
5. MongoDB — 24.8%

2025 [[SO 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24) [VERIFIED]:

1. PostgreSQL — 55.6%
2. MySQL — 40.5%
3. SQLite — 37.5%
4. Microsoft SQL Server — 30.1%
5. Redis — 28%

PostgreSQL is most-admired for the third consecutive year: in 2025, 66% of respondents who used it want to continue, and 47% of non-users want to pick it up [[SO 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24) [VERIFIED].

### DB-Engines popularity ranking (April 2026)

Per [[DB-Engines Ranking](https://db-engines.com/en/ranking)] (accessed 2026-04-24) [VERIFIED], top 20 by composite popularity score:

| Rank | DBMS | Score | Model |
|------|------|-------|-------|
| 1 | Oracle | 1157.93 | Relational |
| 2 | MySQL | 857.69 | Relational |
| 3 | Microsoft SQL Server | 702.08 | Relational |
| 4 | PostgreSQL | 681.35 | Relational |
| 5 | MongoDB | 385.02 | Document |
| 6 | Snowflake | 217.38 | Relational/Warehouse |
| 7 | Databricks | 150.47 | Multi-model |
| 8 | Redis | 146.53 | Key-value |
| 9 | IBM Db2 | 113.25 | Relational |
| 10 | Apache Cassandra | 102.62 | Wide column |
| 11 | Elasticsearch | 99.51 | Search |
| 12 | SQLite | 95.90 | Relational |
| 13 | MariaDB | 86.41 | Relational |
| 14 | Azure SQL Database | 75.96 | Relational |
| 15 | Apache Hive | 74.13 | Relational |
| 16 | Splunk | 73.08 | Search |
| 17 | Microsoft Access | 64.92 | Relational |
| 18 | Amazon DynamoDB | 62.67 | Document/KV |
| 19 | Google BigQuery | 52.36 | Warehouse |
| 20 | Neo4j | 46.88 | Graph |

DB-Engines measures "popularity" via search-engine mentions, job listings, professional-profile entries, and technical-site citations. It therefore indexes incumbency heavily — Oracle's top rank reflects enterprise install base and job market more than greenfield adoption.

### Reconciling the two surveys

Stack Overflow asks developers what they use; DB-Engines aggregates search/job signals. That is why Oracle dominates DB-Engines but is not in Stack Overflow's top 5 — most Stack Overflow respondents don't work on Oracle even if Oracle's enterprise footprint is large.

**The useful summary:** PostgreSQL is now the default new-project OLTP choice for developers, while Oracle and SQL Server hold incumbent enterprise installations. [SYNTHESIS from the two cited surveys.]

## Relational / OLTP

### PostgreSQL — the default for new OLTP workloads

- Top of Stack Overflow's developer-used list in both 2024 and 2025, and most-admired for the third year [[SO 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] [VERIFIED].
- PostgreSQL extension ecosystem (pgvector for embeddings, TimescaleDB for time-series, PostGIS for geospatial, Citus for sharding) has made it a credible default for many specialized workloads that previously needed separate databases. [SYNTHESIS — each extension is a real project with official sites but I did not fetch them individually in this session.]
- Managed PostgreSQL is available on every major cloud: Amazon RDS for PostgreSQL / Aurora PostgreSQL, Azure Database for PostgreSQL, Google Cloud SQL for PostgreSQL, plus specialists like Supabase, Neon, Crunchy, and Timescale Cloud. [UNVERIFIED specific service availability; structurally true.]

### MySQL / MariaDB

- Stack Overflow 2024: MySQL 40.3%, 2025: 40.5% [VERIFIED]. Flat-to-slightly-growing.
- DB-Engines ranks MySQL #2 globally [VERIFIED].
- MariaDB (forked from MySQL in 2009) is DB-Engines #13 and used in many Linux distro defaults. MariaDB aims for a MySQL-compatible API with open-source governance.
- MySQL's historical strengths (LAMP/WordPress/Rails-era web apps) have left it with a huge install base.

### Microsoft SQL Server

- Stack Overflow 2024: 25.3%; 2025: 30.1% [VERIFIED]. DB-Engines #3 [VERIFIED]. Dominant in Microsoft-centric enterprise shops; often paired with .NET.

### Oracle

- DB-Engines #1 overall [VERIFIED]. Rare in greenfield but near-universal in large finance, telecom, and government shops with legacy systems.

### SQLite

- Stack Overflow 2025: 37.5% used it in the past year [VERIFIED]. Its usage is embedded — every mobile app, every browser, many desktop apps — not as a server database. SQLite's creators describe it as the most-deployed database engine in the world [UNVERIFIED — the claim is on sqlite.org; I did not fetch it directly in this session].

## Document stores

### MongoDB

- Stack Overflow 2024: 24.8%; 2025 adjacent position; DB-Engines #5 overall [VERIFIED]. The dominant document store for developer-facing use.
- MongoDB Atlas (the vendor-managed cloud) is the primary path to production today.
- Note: MongoDB's license change to SSPL in 2018 restricts certain cloud-provider use; AWS DocumentDB is a separate AWS-built API-compatible service (not MongoDB itself). [UNVERIFIED in this session; widely documented.]

### DynamoDB (AWS)

- Managed key-value + document store with the AWS ecosystem. Widely used in serverless and high-scale AWS workloads. [UNVERIFIED specific share; DB-Engines places it around #18 but that metric under-represents managed-service usage.]

### Firestore (Google) and Cosmos DB (Azure)

- Cloud-native document stores, commonly chosen when the rest of the stack is on Google / Azure. [UNVERIFIED specific share.]

## Key-value and cache

### Redis → Valkey

- Stack Overflow 2025: Redis 28% used in the past year [VERIFIED]. DB-Engines #8 [VERIFIED].
- **Redis license change (20 March 2024):** Redis moved from the three-clause BSD license to a dual license of Redis Source Available License v2 (RSALv2) and Server Side Public License v1 (SSPLv1), starting with Redis 7.4. The change is not retroactive: releases before 7.4 remain BSD-3-Clause. Redis itself acknowledges that under the OSI's definition, Redis is no longer "open source" [[Redis — dual source-available licensing, 20 Mar 2024](https://redis.io/blog/redis-adopts-dual-source-available-licensing/)] (accessed 2026-04-24) [VERIFIED — primary announcement fetched].
- **Valkey launch (28 March 2024):** The Linux Foundation launched **Valkey**, a BSD-3-Clause fork of Redis, backed by AWS, Google Cloud, Oracle, Ericsson, and Snap Inc. [[Linux Foundation — Valkey community launch, 28 Mar 2024](https://www.linuxfoundation.org/press/linux-foundation-launches-open-source-valkey-community)] (accessed 2026-04-24) [VERIFIED — primary announcement fetched].

### Memcached

- Still used, primarily as a pure cache (no persistence, no data structures). Declining mindshare vs. Redis/Valkey. [UNVERIFIED specific share.]

## Search

### Elasticsearch → OpenSearch

- DB-Engines #11 [VERIFIED]. Elastic's 2021 license change (moving to SSPL + Elastic License) led AWS to fork it as **OpenSearch** under Apache 2.0. Both projects remain active; choice often reflects whether your cloud is AWS (OpenSearch default) or a preference for the vendor-backed path (Elastic Cloud). [UNVERIFIED dates; the license change and fork are widely documented.]

### Meilisearch, Typesense, Algolia

- Developer-focused alternatives with simpler ops than Elasticsearch. Algolia is SaaS; Meilisearch and Typesense have open-source cores plus managed offerings. [UNVERIFIED specific adoption.]

## Data warehouses / lakehouses

### Snowflake — DBMS of the Year 2024 per DB-Engines

- DB-Engines ranked Snowflake DBMS of the Year 2024; first cracked top 6 in Q1 2025 [[DB-Engines ranking coverage](https://www.red-gate.com/blog/db-engines-shares-q1-2025-database-industry-rankings-and-top-climbers-snowflake-and-postgresql-trending/)] — I did not fetch this secondary source directly; the DB-Engines page I fetched did not explicitly name the 2024 DBMS of the Year in the top of its ranking page content. This claim is [CONTESTED] / needs primary DB-Engines confirmation.
- Cloud-native separation of storage and compute; multi-cloud.

### Databricks

- DB-Engines #7 in April 2026 [VERIFIED]. Lakehouse architecture built on Delta Lake; owns the Apache Spark ecosystem.

### BigQuery (Google) / Redshift (AWS) / Synapse (Azure)

- Cloud-native warehouses from each hyperscaler. BigQuery is the serverless leader; Redshift is the incumbent in AWS; Synapse is Microsoft's warehouse offering.

### ClickHouse

- Open-source columnar DBMS with very high query performance for analytic workloads; rising fast, especially for observability and real-time analytics. [UNVERIFIED specific rank; widely discussed.]

### Duckdb

- Embedded analytical database; "SQLite for analytics." Increasingly used in data engineering pipelines and local analysis. [UNVERIFIED specific rank.]

## Streaming / messaging

### Apache Kafka

- Dominant event-streaming platform. Forrester's Wave for Streaming Data Platforms Q4 2025 named Confluent a Leader [UNVERIFIED in this session — widely cited secondary reporting; the primary Forrester report is paywalled]. Kafka itself is an Apache Software Foundation project; commercial managed offerings are dominated by Confluent, AWS MSK, Azure Event Hubs for Kafka, and Aiven.
- **Redpanda** is a Kafka-wire-compatible alternative written in C++ focused on single-binary simplicity and lower latency. [UNVERIFIED specific share.]

### RabbitMQ and NATS

- RabbitMQ — traditional message broker, AMQP-based. Still common in enterprise workflow use cases.
- NATS — lightweight, high-performance messaging under the CNCF (graduated). Growing in cloud-native microservice communication. [UNVERIFIED specific share; CNCF graduation is a matter of public record.]

### Managed queuing on cloud (SQS, Pub/Sub, Service Bus)

- AWS SQS, GCP Pub/Sub, Azure Service Bus — default cloud-vendor queuing services. Often used for simple async workloads where Kafka would be overkill.

## Vector / embedding databases

Rising 2023–2026 alongside LLM applications.

- **pgvector** (Postgres extension) — has become the most common "first reach" for teams already on Postgres. [SYNTHESIS — widely reported; no single primary survey.]
- **Pinecone** — managed vector DB SaaS; among the most adopted managed offerings.
- **Weaviate, Qdrant, Milvus, Chroma** — open-source vector databases with managed and self-hosted options.
- The tradeoff is typically: pgvector when embeddings are one of many workloads in a Postgres-centric app; a dedicated vector DB when billions of vectors or very low-latency ANN queries dominate. [SYNTHESIS.]

## Graph databases

- **Neo4j** — dominant labeled property graph; DB-Engines #20 [VERIFIED]. Used where explicitly graph-shaped data (fraud, knowledge graphs, social) is central.
- **ArangoDB, JanusGraph, Amazon Neptune** — other options [UNVERIFIED specific share].

## Putting the stack together (typical 2026 defaults)

For a new SaaS product:

- **Primary OLTP:** PostgreSQL (managed — RDS Aurora, Cloud SQL, Supabase, Neon, or Fly Postgres)
- **Cache and session:** Redis (or Valkey if license-sensitive)
- **Search over OLTP data:** Postgres full-text for small; Elasticsearch/OpenSearch for large
- **Event bus / microservice comms:** Kafka (Confluent Cloud or MSK) or cloud-native pub/sub (SQS, Pub/Sub)
- **Analytics / BI:** Snowflake or BigQuery, with a tool like dbt for transformation
- **Vector / embeddings:** pgvector for small, Pinecone or Qdrant for large
- **Embedded / on-device / dev:** SQLite

[SYNTHESIS — these defaults are an amalgamation of survey results, cloud-provider marketing, and ThoughtWorks Technology Radar commentary; they approximate what a new greenfield SaaS team would pick without special constraints.]

## Sources (accessed 2026-04-24)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [DB-Engines Ranking (April 2026)](https://db-engines.com/en/ranking)
- [JetBrains State of Developer Ecosystem 2024](https://www.jetbrains.com/lp/devecosystem-2024/)
- [Redis — "Redis adopts dual source-available licensing" (20 Mar 2024)](https://redis.io/blog/redis-adopts-dual-source-available-licensing/)
- [Linux Foundation — "Linux Foundation launches open source Valkey community" (28 Mar 2024)](https://www.linuxfoundation.org/press/linux-foundation-launches-open-source-valkey-community)

## Open questions

- **Snowflake "DBMS of the Year 2024" from DB-Engines** — secondary commentary says yes, the DB-Engines front page didn't state it in my fetch; need to check db-engines.com/en/blog for the year-end post.
- **Vector database market share** — no single authoritative survey yet; growing area.
- **ClickHouse, DuckDB, TiDB, CockroachDB, YugabyteDB, Amazon Aurora DSQL** — all credible alternatives with varying niches; specific adoption data not extracted.
- **MongoDB Atlas market share** — widely reported but not extracted.
- **Forrester Wave Streaming Data Platforms Q4 2025** — the primary PDF is paywalled; only secondary citations available.
