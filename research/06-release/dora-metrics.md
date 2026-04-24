# DORA Metrics, Rollback, Database Migrations, and Supply Chain

**Question:** How do we measure whether release/deployment is working; how do we safely migrate the data layer; and how do we trust the artifacts that flow through the pipeline?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. DORA four key metrics

### The canonical four keys

`[VERIFIED]` From the Google Cloud blog's "Use Four Keys metrics" article (not dated on the page but identified as the canonical Google Cloud statement of the Four Keys):

> "The DevOps Research and Assessment (DORA) team has identified four key metrics that indicate the performance of a software development team":
>
> 1. **Deployment Frequency** — How often an organization successfully releases to production.
> 2. **Lead Time for Changes** — The amount of time it takes a commit to get into production.
> 3. **Change Failure Rate** — The percentage of deployments causing a failure in production.
> 4. **Time to Restore Service** — How long it takes an organization to recover from a failure in production.

And:

> "Deployment Frequency and Lead Time for Changes measure velocity, while Change Failure Rate and Time to Restore Service measure stability."

([Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)).

### Performance tiers

`[VERIFIED]` Google Cloud's Four Keys blog identifies performance tiers of Elite, High, Medium, Low ([Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)).

`[VERIFIED]` The same article's editor's note records a shift: "for the 2022 State of DevOps Report, cluster analysis detected only three clusters: High, Medium, and Low (eliminating the Elite designation)." ([Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)).

`[VERIFIED]` The 2023 State of DevOps announcement explicitly reverses that: "Our analysis revealed four performance levels, including the return of the Elite performance level, which we did not detect in last year's cohort. Elite performers around the world are able to achieve both throughput and stability." ([Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)).

`[CONTESTED]` The tier model is thus **not stable year-on-year**. Teams tracking their tier over time should note which annual report defined their tier.

### Verbatim 2024 tier thresholds

`[VERIFIED]` The 2024 Accelerate State of DevOps Report gives the following cluster-analysis-derived thresholds (p. 13), computed on the original four metrics for year-on-year comparability. Percentages in parentheses are the 89% uncertainty interval for the share of respondents in that tier.

| Performance level | Change lead time | Deployment frequency | Change fail rate | Failed deployment recovery time | % respondents |
|---|---|---|---|---|---|
| **Elite** | Less than one day | On demand (multiple deploys per day) | 5% | Less than one hour | 19% (18–20%) |
| **High** | Between one day and one week | Between once per day and once per week | 20% | Less than one day | 22% (21–23%) |
| **Medium** | Between one week and one month | Between once per week and once per month | 10% | Less than one day | 35% (33–36%) |
| **Low** | Between one month and six months | Between once per month and once every six months | 40% | Between one week and one month | 25% (23–26%) |

([2024 Accelerate State of DevOps Report PDF — services.google.com, p. 13](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

`[VERIFIED]` An unusual 2024 finding: "the medium performance cluster, for example, may benefit from shipping changes more frequently" — medium has *lower* change failure rate than high, showing that the tiers do not collapse along a single quality axis ([2024 Accelerate State of DevOps Report PDF — services.google.com, p. 14](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

`[VERIFIED]` Elite vs. low performer comparison (p. 14 of the report): "127x faster lead time; 182x more deployments per year; 8x lower change failure rate; 2293x faster failed deployment recovery times" ([2024 Accelerate State of DevOps Report PDF — services.google.com, p. 14](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

### Evolution to five metrics

`[VERIFIED]` The publicly hosted DORA metrics guide at dora.dev presents five metrics, with renamed definitions ([DORA's software delivery metrics: the four keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)):

**Throughput:**
1. **Change lead time** — "The amount of time it takes for a change to go from committed to version control to deployed in production."
2. **Deployment frequency** — "The number of deployments over a given period or the time between deployments."
3. **Failed deployment recovery time** — "The time it takes to recover from a deployment that fails and requires immediate intervention." (Replaces MTTR / Time to Restore Service.)

**Stability:**
4. **Change fail rate** — "The ratio of deployments that require immediate intervention following a deployment."
5. **Deployment rework rate** — "The ratio of deployments that are unplanned but happen as a result of an incident in production."

The page indicates a shift "from MTTR to Failed Deployment Recovery Time," and introduces Deployment Rework Rate as new ([dora.dev/guides/dora-metrics-four-keys/](https://dora.dev/guides/dora-metrics-four-keys/)).

`[VERIFIED]` The 2024 Accelerate State of DevOps Report confirms and expands this model. It names the fifth metric explicitly as **rework rate** (not "reliability") and explains: "We have a longstanding hypothesis that the change failure rate metric works as a proxy for the amount of rework a team is asked to do." The report added a new survey question: *"For the primary application or service you work on, approximately how many deployments in the last six months were not planned but were performed to address a user-facing bug in the application?"* Analysis confirmed the hypothesis: "rework rate and change failure rate are related. Together, these two metrics create a reliable factor of software delivery stability." The 2024 model: throughput = change lead time + deployment frequency + failed deployment recovery time; stability = change failure rate + rework rate. ([2024 Accelerate State of DevOps Report PDF — services.google.com, pp. 10–12](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)).

### Other 2023 report findings

`[VERIFIED]` The 2023 State of DevOps announcement reports five additional findings, of which three are quantified verbatim:

> "Teams with generative cultures, composed of people who felt included and like they belonged on their team, have 30% higher organizational performance than organizations without a generative culture."
>
> "Teams that focus on the user have 40% higher organizational performance than teams that don't."
>
> "High-quality documentation leads to 25% higher team performance relative to low-quality documentation."

([Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)).

### Practical use

`[SYNTHESIS]` The four keys are the *outcome* metrics. Most of the material in the other Stage 06 documents — CI discipline, feature flags, canary, expand/contract migrations — exists specifically to move these numbers in the right direction without trading one against another (i.e. without buying velocity with stability, or vice versa). That is the point of the throughput/stability split in the canonical four.

---

## 2. Database migrations and zero-downtime schema change

### Expand/contract (parallel change)

`[VERIFIED]` Danilo Sato's canonical bliki entry on "Parallel Change," also known as "expand and contract":

> "'parallel change,' also known as 'expand and contract,' is a pattern for safely implementing backward-incompatible interface changes through three distinct phases: expand, migrate, and contract."

The three phases, verbatim intent:
1. **Expand:** Augment the interface to support both old and new versions simultaneously, allowing existing clients to continue functioning without modification.
2. **Migrate:** Update all clients incrementally to use the new version.
3. **Contract:** Remove the old version and clean up the interface to support only the new implementation.

> "This approach is particularly useful when practicing Continuous Delivery because it allows your code to be released in any of these three phases."

Applications named by Sato include refactoring method signatures, database schema evolution, deployment strategies (canary releases, blue-green deployments), and remote API evolution ([Parallel Change — Danilo Sato, 2014](https://martinfowler.com/bliki/ParallelChange.html) (accessed 2026-04-24)).

### Evolutionary Database Design

`[VERIFIED]` Sadalage & Fowler's article on Evolutionary Database Design (rewritten 2016; original 2003):

> Evolutionary Database Design allows "a database design to evolve as an application develops" and is essential for supporting iterative, change-driven methodologies.

The article identifies eleven interconnected practices including: close DBA-developer collaboration; version-controlled database artifacts alongside application code; all changes expressed as migrations; individual developer database instances; continuous integration of database modifications; automated refactoring application ([Evolutionary Database Design — Sadalage & Fowler, 2016 rev.](https://martinfowler.com/articles/evodb.html) (accessed 2026-04-24)).

The article's staffing observation is notable:
> "one full-time DBA plus part-time developer support sufficed for teams of 100+ people, demonstrating that 'automation' is the true enabler."

(same source, accessed 2026-04-24).

### Branch by abstraction (a parallel idea at the code level)

`[VERIFIED]` Fowler's 2014 bliki entry on Branch by Abstraction:

> "'Branch by Abstraction' is a technique for making a large-scale change to a software system in a gradual way that allows you to release the system regularly while the change is still in-progress."

Five-step migration: create an abstraction layer; migrate all client code to use it; build a new implementation behind the abstraction; gradually swap clients to the new supplier; remove the old supplier ([Branch by Abstraction — Fowler, 2014](https://martinfowler.com/bliki/BranchByAbstraction.html) (accessed 2026-04-24)).

`[SYNTHESIS]` Expand/contract is the general pattern; Branch by Abstraction is its application to internal code structure. Both exist so that the codebase is *always releasable*, never stranded mid-migration.

### Online schema-change tools for MySQL

`[VERIFIED]` **pt-online-schema-change** (Percona Toolkit): enables "ALTER tables without locking them." Mechanism verbatim from Percona docs ([pt-online-schema-change — Percona docs](https://docs.percona.com/percona-toolkit/pt-online-schema-change.html) (accessed 2026-04-24)):

- "creates an empty copy of the table to alter, modifying it as desired, and then copying rows from the original table into the new table"
- "Any modifications to data in the original tables during the copy will be reflected in the new table, because the tool creates triggers on the original table to update the corresponding rows in the new table"
- "it uses an atomic `RENAME TABLE` operation to simultaneously rename the original and new tables"

Safety features: requires a PRIMARY KEY or UNIQUE INDEX; monitors replica replication lag and can pause automatically; refuses to operate with replication filters enabled; adjusts chunk sizes dynamically.

`[VERIFIED]` **gh-ost** (GitHub): a "triggerless online schema migration solution for MySQL." Mechanism verbatim from the project README ([gh-ost — GitHub](https://github.com/github/gh-ost) (accessed 2026-04-24)):

> "gh-ost uses the binary log stream to capture table changes, and asynchronously applies them onto the ghost table."

This gives gh-ost "greater control over the migration process; can truly suspend it; can truly decouple the migration's write load from the master's workload."

`[SYNTHESIS]` The architectural difference: pt-osc uses MySQL triggers on the original table to capture concurrent writes; gh-ost tails the binary log instead. Triggers run inside the write transaction (adding latency) and complicate replication; binlog-based capture is asynchronous and can be paused — gh-ost's documented advantage. Either is substantially safer than a lock-blocking `ALTER TABLE` in production.

### What "zero-downtime" actually requires

`[SYNTHESIS]` Combining Sato, Sadalage/Fowler, and the Percona/GitHub tool docs above, a zero-downtime schema change requires at minimum:
1. Make the schema change backward-compatible (expand phase).
2. Deploy code that can work with either the old or new schema.
3. Run the online schema change (pt-osc / gh-ost / Postgres logical mechanisms).
4. Deploy code that uses only the new schema (or flip a feature flag).
5. Drop the old columns/tables (contract phase) only after step 4 is stable.

This sequencing is prescriptive but follows directly from the cited sources.

---

## 3. Rollback strategies

See also `deployment-strategies.md` §7. The summary position:

`[SYNTHESIS]` Each deployment strategy supplies its own rollback primitive (blue-green: switch the router; canary: halt promotion and route back; rolling / Kubernetes: `Deployment` revision rollback per [Kubernetes Deployments docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/); feature flag: flip the kill switch per [Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html)). The database layer is the constraint: a rollback is safe only if the schema change was expand-only. The expand/contract discipline from Sato 2014 is therefore a *precondition* for safe rollback in any of the four mechanisms.

---

## 4. Artifact management: container registries, SBOM, SLSA

### Container registries

`[VERIFIED]` Docker's own documentation describes the Docker Registry as "the open-source implementation of a container image registry" and notes it "remains a cornerstone for managing and distributing container images" (now maintained by CNCF as "Distribution") ([Docker Registry — docs.docker.com/registry](https://docs.docker.com/registry/) (accessed 2026-04-24)). The page treats the registry narrowly as the Docker reference implementation; a broader definition of "container registry" as a category was not in the fetched content.

`[SYNTHESIS]` Container registries in practice: Docker Hub, GitHub Container Registry (ghcr.io), AWS ECR, Google Artifact Registry, Azure Container Registry, and on-prem installations of Harbor, JFrog Artifactory, or the Distribution reference. Package registries have the parallel role for language artifacts (npm, PyPI, Maven Central, RubyGems). None of those vendor-specific pages were fetched in this session, so this is listed as synthesis rather than verified primary sourcing.

### SBOM — software bill of materials

`[VERIFIED]` NTIA definition ([Software Bill of Materials — NTIA](https://www.ntia.gov/page/software-bill-materials) (accessed 2026-04-24)):

> "A 'Software Bill of Materials' (SBOM) is a nested inventory for software, a list of ingredients that make up software components."

SBOMs exist to provide "transparency around software components" and "much-needed transparency for the software supply chain" (same source).

`[VERIFIED]` CISA directly. A direct WebFetch of `https://www.cisa.gov/sbom` on 2026-04-24 returned HTTP 403; a web-search result snapshot ([CISA — SBOM page, retrieved via search 2026-04-24](https://www.cisa.gov/sbom)) attributes to CISA the roles of "facilitating community engagement to advance and refine SBOM" and coordinating "with international, industry, inter-agency partners on SBOM implementation." The NTIA page confirms NTIA produced the original minimum-elements baseline. `[UNVERIFIED]` for the CISA verbatim text because the direct fetch failed; the NTIA content and search summary are used together.

### SLSA — Supply-chain Levels for Software Artifacts

`[VERIFIED]` SLSA is "pronounced 'salsa'" and defined as ([SLSA — slsa.dev](https://slsa.dev/) (accessed 2026-04-24)):

> "a security framework, a checklist of standards and controls to prevent tampering, improve integrity, and secure packages and infrastructure."

> "the levels blend together industry-recognized best practices to create four compliance levels of increasing assurance."

> SLSA targets "producers for protection against tampering and insider threats, by consumers to verify the software they rely on is secure, and by infrastructure providers as a guideline for hardening build platforms."

`[VERIFIED]` The Build-track levels v1.0 ([SLSA Build Levels — slsa.dev](https://slsa.dev/spec/v1.0/levels) (accessed 2026-04-24)):

**Build L1 — Provenance exists**
> "Package has provenance showing how it was built. Can be used to prevent mistakes but is trivial to bypass or forge."

Purpose: "Prevents accidental release mistakes rather than intentional tampering."

**Build L2 — Hosted build platform**
> "Build platform runs on dedicated infrastructure, not an individual's workstation, and the provenance is tied to that infrastructure through a digital signature."

Purpose: "Prevents tampering after the build through digital signatures."

**Build L3 — Hardened builds**
Platform must "prevent runs from influencing one another, even within the same project" and "prevent secret material used to sign the provenance from being accessible to the user-defined build steps."

Purpose: "Prevents tampering during the build — by insider threats, compromised credentials, or other tenants."

`[SYNTHESIS]` SBOM answers *what is in my artifact*; SLSA answers *how was my artifact built, and can I trust the build*. They are complementary, not alternatives. Both are explicit requirements or recommendations in U.S. federal cyber policy (Executive Order 14028 context in the NTIA page), which means enterprise software supply chains will increasingly be expected to produce both.

---

## Open questions

- **Accelerate book.** Forsgren/Humble/Kim (2018) underpins the DORA research program. In **verification pass 3 (2026-04-24)**, the four-year research basis (IT Revolution + O'Reilly mirror), the 24-capabilities/five-category structure (Wikipedia article on the book, specific enough to enumerate: Continuous Delivery 8, Architecture 2, Product and Process 4, Lean Management and Monitoring 5, Cultural 5), the "predictive pathways" framing (DORA research page), and the list of peer-reviewed companion academic papers (Forsgren's research page) are now VERIFIED at primary or specific-secondary level — see `00-overview/industry-research.md` §1.5. The book's internal statistical appendix and specific verbatim quotes from its text remain `[UNVERIFIED]`. The ACM Queue 15(6) "DevOps Metrics" article by Forsgren & Kersten (2018) returned HTTP 403 both at queue.acm.org and dl.acm.org in this session.
- **CISA SBOM page** returned HTTP 403 again on re-attempt 2026-04-24 (both `cisa.gov/sbom` and `cisa.gov/topics/cyber-threats-and-advisories/sbom`). Wayback Machine is inaccessible from this environment. The definitions here continue to lean on NTIA's page.
- **Online schema change for Postgres.** This file focuses on MySQL because pt-osc and gh-ost are well-documented. Postgres online migration (e.g., `CREATE INDEX CONCURRENTLY`, `pgroll`, Strong Migrations conventions) was not covered by a fetched primary source here.

## Sources

- [Use Four Keys metrics — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance) (accessed 2026-04-24)
- [Announcing the 2023 State of DevOps Report — Google Cloud blog](https://cloud.google.com/blog/products/devops-sre/announcing-the-2023-state-of-devops-report) (accessed 2026-04-24)
- [DORA's software delivery metrics: the four keys — dora.dev](https://dora.dev/guides/dora-metrics-four-keys/) (accessed 2026-04-24)
- [2024 Accelerate State of DevOps Report PDF — services.google.com](https://services.google.com/fh/files/misc/2024_final_dora_report.pdf) (accessed 2026-04-24)
- [Parallel Change — Danilo Sato, 2014](https://martinfowler.com/bliki/ParallelChange.html) (accessed 2026-04-24)
- [Evolutionary Database Design — Sadalage & Fowler, 2016 rev.](https://martinfowler.com/articles/evodb.html) (accessed 2026-04-24)
- [Branch by Abstraction — Martin Fowler, 2014](https://martinfowler.com/bliki/BranchByAbstraction.html) (accessed 2026-04-24)
- [pt-online-schema-change — Percona docs](https://docs.percona.com/percona-toolkit/pt-online-schema-change.html) (accessed 2026-04-24)
- [gh-ost — GitHub](https://github.com/github/gh-ost) (accessed 2026-04-24)
- [Kubernetes Deployments — kubernetes.io](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) (accessed 2026-04-24)
- [Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24)
- [Docker Registry — docs.docker.com](https://docs.docker.com/registry/) (accessed 2026-04-24)
- [Software Bill of Materials — NTIA](https://www.ntia.gov/page/software-bill-materials) (accessed 2026-04-24)
- [CISA SBOM page](https://www.cisa.gov/sbom) — direct WebFetch returned HTTP 403 on 2026-04-24; referenced via search-result summary only.
- [SLSA — slsa.dev](https://slsa.dev/) (accessed 2026-04-24)
- [SLSA Build Levels v1.0 — slsa.dev](https://slsa.dev/spec/v1.0/levels) (accessed 2026-04-24)
