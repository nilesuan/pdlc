# System Architecture

**Question:** How are architectural decisions made in industry-grade software development — who makes them, when, how they are recorded, and what architectural styles, modelling techniques, and quality attributes are considered canonical?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. The architecture process

Architecture in modern practice is treated as a stream of significant decisions rather than a single up-front artefact. Michael Nygard frames an architecturally significant decision as one that "affect[s] the structure, non-functional characteristics, dependencies, interfaces, or construction techniques" of the system; "one of the hardest things to track during the life of a project is the motivation behind certain decisions." [Documenting Architecture Decisions — Michael Nygard, cognitect.com, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24).

[SYNTHESIS] Combining Nygard's ADR framing with Fowler's "MonolithFirst" caution (below), the sources in scope support a practice where:

1. Initial architecture is deliberately conservative — expressive enough to deliver the first product, no more.
2. Each architecturally significant choice is captured as a small, dated record with context, decision, and consequences.
3. The architecture evolves decision-by-decision, with superseded records retained for trace.

This is consistent with "MonolithFirst": Fowler argues that "refactoring of functionality between services is much harder than it is in a monolith," so starting simple preserves optionality, and "the premium of microservices is a drag you should do without" during early validation. [MonolithFirst — Martin Fowler, 2015-06-03](https://martinfowler.com/bliki/MonolithFirst.html) (accessed 2026-04-24).

Fowler reinforces this as a decision rule in "Microservice Premium": "don't even consider microservices unless you have a system that's too complex to manage as a monolith," because microservices force investment in "automated deployment, monitoring, dealing with failure, eventual consistency, and other factors that a distributed system introduces." [MicroservicePremium — Martin Fowler](https://martinfowler.com/bliki/MicroservicePremium.html) (accessed 2026-04-24).

### Iterative vs big-up-front design

[CONTESTED — sources in scope do not formally resolve this debate.] The ADR approach (Nygard, adr.github.io) is explicitly agile-compatible: adr.github.io lists among its goals "strengthen[ing] tooling supporting agile and iterative engineering processes." [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24). The primary sources fetched here do not cite or defend Big Design Up Front (BDUF) as a current practice; the bulk of fetched material describes incremental, evolutionary architecture work grounded in bounded contexts, ADRs, and fitness-for-purpose diagrams.

---

## 2. Architecture Decision Records (ADRs)

**Origin.** Nygard's 2011 post "Documenting Architecture Decisions" introduced the ADR as a short, markdown-friendly document capturing one decision. The recommended structure is:

- **Title** — short noun phrase (e.g., "ADR 1: Deployment on Ruby on Rails 3.0.10")
- **Context** — "describes the forces at play, including technological, political, social, and project local" in value-neutral language
- **Decision** — "stated in full sentences, with active voice. 'We will …'"
- **Status** — "proposed," "accepted," "deprecated," or "superseded"
- **Consequences** — "All consequences should be listed here, not just the 'positive' ones"

Nygard also recommends storing ADRs alongside code (e.g., `doc/arch/adr-NNN.md`), keeping them "one or two pages long," numbering sequentially without reuse, and marking superseded ADRs with a link to the replacement. [Documenting Architecture Decisions — Michael Nygard, 2011](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24).

**Community framing.** adr.github.io defines an Architectural Decision as "a justified design choice that addresses a functional or non-functional requirement that is architecturally significant," and describes an ADR as a document that "can help you understand the reasons for a chosen architectural decision, along with its trade-offs and consequences." The site also lists downstream adoption notes, including that "the Azure Well-Architected Framework now features ADRs (as of October 2024)" and that "AWS Prescriptive Guidance recommends using ADRs for technical decision-making." [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24).

See `adrs.md` for template detail.

---

## 3. Architectural styles and patterns

### 3.1 Monolith, modular monolith, microservices

**Microservices definition.** Fowler and Lewis define the microservice architectural style as "an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API," with services "built around business capabilities and independently deployable by fully automated deployment machinery." [Microservices — Martin Fowler & James Lewis, 2014-03-25](https://martinfowler.com/articles/microservices.html) (accessed 2026-04-24).

Their nine characteristics (abbreviated):

1. Componentization via services.
2. Organized around business capabilities.
3. Products not projects.
4. Smart endpoints and dumb pipes.
5. Decentralized governance.
6. Decentralized data management.
7. Infrastructure automation.
8. Design for failure.
9. Evolutionary design.

[Microservices — Martin Fowler & James Lewis, 2014-03-25](https://martinfowler.com/articles/microservices.html) (accessed 2026-04-24).

**microservices.io** (Chris Richardson) gives a shorter definition — "an architectural style that structures an application as a collection of two or more services that are: Independently deployable [and] Loosely coupled" — and positions itself as a "microservices pattern language" covering service collaboration, testing, deployment, and cross-cutting concerns. Relevant patterns on the site include Strangler Fig (incremental refactor from monolith) and Assemblage (grouping subdomains into services). [microservices.io — Chris Richardson](https://microservices.io/) (accessed 2026-04-24).

**Monolith-first.** Fowler's 2015 post observes that successful microservice systems typically evolved from monoliths, while green-field microservice builds "frequently encountered serious problems." [MonolithFirst — Martin Fowler, 2015-06-03](https://martinfowler.com/bliki/MonolithFirst.html) (accessed 2026-04-24).

**Migration.** Zhamak Dehghani's "Break a Monolith into Microservices" lists principles for decomposition: minimise monolith dependencies, decouple vertically with data, prioritise business value, and "start macro then micro" — i.e., begin with larger services around domain concepts, refining them only as operational maturity increases. [How to Break a Monolith into Microservices — Zhamak Dehghani, 2018-04-24](https://martinfowler.com/articles/break-monolith-into-microservices.html) (accessed 2026-04-24).

**Microsoft/Azure framing.** Azure's Architecture Center describes microservices as "small, independent, and loosely coupled components that a single small team of developers can write and maintain. Each service is managed as a separate codebase … services can be deployed independently … microservices are responsible for persisting their own data or external state." Azure lists trade-offs explicitly: complexity, network latency across chatty services, data-consistency challenges ("Basically Available, Soft State, Eventual Consistency (BASE)"), and a required "mature DevOps culture." [Microservices Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24).

[SYNTHESIS] A consistent picture emerges across Fowler/Lewis, Richardson, Dehghani, and Microsoft: microservices solve organisational-scale and independent-deployment problems, at a non-trivial cost in operational, consistency, and testing complexity. None of the fetched primary sources advocate microservices as a default starting style for a new product.

### 3.2 Event-driven architecture

Microsoft defines event-driven architecture as consisting of "event producers that generate a stream of events, event consumers that listen for these events, and event channels (often implemented as event brokers or ingestion services) that transfer events from producers to consumers." Two sub-models are called out: publish-subscribe (subscriptions tracked by the broker; past events not stored for new subscribers) and event streaming (events written to an ordered, durable log that clients read at their own position). [Event-Driven Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24).

Microsoft lists two topologies: **broker** (components broadcast events; no central orchestration) and **mediator** (an event mediator manages and controls flow, dispatches commands, maintains state and handles errors — "introduces increased coupling between components, and the event mediator can become a bottleneck or a reliability concern"). [Event-Driven Architecture Style — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24).

Key challenges explicitly listed by Microsoft: guaranteed delivery, eventual consistency ("a deliberate architectural tradeoff"), in-order / exactly-once processing, message coordination across services (Saga, Choreography), error handling (dead-letter queues), data loss, observability across decoupled components (requires correlation IDs), and event schema evolution. [Event-Driven Architecture Style — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24).

### 3.3 Serverless

Mike Roberts' article (published on martinfowler.com/articles) defines serverless as "application designs that incorporate third-party 'Backend as a Service' (BaaS) services, and/or that include custom code run in managed, ephemeral containers on a 'Functions as a Service' (FaaS) platform." The key operational property is that "horizontal scaling is completely automatic, elastic, and managed by the provider." Functions are ephemeral and event-triggered; state must be externalised; execution duration is bounded by the vendor's limits; cold starts are a known latency concern. [Serverless Architectures — Mike Roberts, 2018-05-22](https://martinfowler.com/articles/serverless.html) (accessed 2026-04-24).

### 3.4 Service-Oriented Architecture (SOA)

Fowler argued in 2005 that SOA had "turned into a semantics-free concept," identifying at least four interpretations in use at the time: (a) exposing software through web services; (b) applications replaced by coordinated "core services that supply business functionality"; (c) standard (usually XML-based) communication structures; (d) asynchronous messaging between systems. [ServiceOrientedAmbiguity — Martin Fowler, 2005-07-01](https://martinfowler.com/bliki/ServiceOrientedAmbiguity.html) (accessed 2026-04-24).

[SYNTHESIS] The primary sources fetched treat "SOA" as the pre-microservices umbrella term whose ambiguity is its defining feature. Modern references tend to use microservices, event-driven architecture, or domain-driven decomposition rather than SOA as a specific design label.

---

## 4. Domain-Driven Design (DDD)

**Originator.** Eric Evans' 2003 book *Domain-Driven Design* introduced the term. Fowler writes that "Eric Evans's great contribution to this, through his book, was developing a vocabulary to talk about this approach." [Domain-Driven Design — Martin Fowler bliki](https://martinfowler.com/bliki/DomainDrivenDesign.html) (accessed 2026-04-24).

**Strategic DDD — Bounded Context & Ubiquitous Language.**

- *Bounded Context*: DDD "recognises that total unification of the domain model for a large system will not be feasible or cost-effective." Bounded Contexts divide the domain into sections, each with its own unified model, and provide explicit mapping between them for polysemic concepts (e.g., "Customer" means different things in sales and support). [BoundedContext — Martin Fowler bliki](https://martinfowler.com/bliki/BoundedContext.html) (accessed 2026-04-24).
- *Ubiquitous Language*: a rigorous, shared language between developers and domain experts, "embedded … into the software systems that we build" — "using the model-based language pervasively and not being satisfied until it flows, we approach a model that is complete and comprehensible" (Evans, as quoted on Fowler's bliki). [UbiquitousLanguage — Martin Fowler bliki](https://martinfowler.com/bliki/UbiquitousLanguage.html) (accessed 2026-04-24).

**Tactical DDD — entities, value objects, aggregates, services, events.** Microsoft's tactical DDD article summarises the patterns (attributed to Evans' book and to Vlad Khononov's *Learning Domain-Driven Design*):

- **Entity** — "an object that has a unique identity that persists over time" (e.g., customers, accounts). Entities "should encapsulate behavior, not only carry data."
- **Value object** — "no identity … defined only by the values of its attributes. Two value objects that have the same attribute values are interchangeable." Immutable.
- **Aggregate** — "defines a consistency boundary around one or more entities. Exactly one entity in an aggregate is the root." Design small; reference other aggregates by identity only; use eventual consistency across aggregates (via domain events).
- **Domain service** — "encapsulate[s] business rules that span multiple entities or aggregates."
- **Application service** — "orchestrate[s] use cases … coordinate calls to domain services and repositories, manage transactions."
- **Domain event** — a domain-significant change (e.g., "a delivery was canceled," not "a record was inserted").

[Use Tactical DDD to Design Microservices — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) (accessed 2026-04-24).

[VERIFIED] Microsoft states a concrete sizing guideline aligning DDD with microservices: "design a microservice to be no smaller than an aggregate and no larger than a bounded context." [Use Tactical DDD to Design Microservices — Microsoft](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) (accessed 2026-04-24).

---

## 5. The C4 model for diagramming

Simon Brown's C4 model is described on its home page as "an easy to learn, developer friendly approach to software architecture diagramming." The four levels of hierarchical abstraction are: **software systems → containers → components → code**. The model is "notation independent" and "tooling independent." [The C4 model — c4model.com](https://c4model.com/) (accessed 2026-04-24).

Definitions of each level (from c4model.com):

- **Level 1 — System Context.** "A system context diagram is a good starting point for diagramming and documenting a software system, allowing you to step back and see the big picture." It shows "your system as a box in the centre, surrounded by its users and the other systems that it interacts with," emphasising "people (actors, roles, personas, etc) and software systems rather than technologies, protocols and other low-level details." [System Context Diagram — c4model.com](https://c4model.com/diagrams/system-context) (accessed 2026-04-24).
- **Level 2 — Container.** "In C4, a container is an application or a data store. For example, a server-side web application, a client-side single-page application, a desktop application, a mobile app, a database schema, a folder on a file system, an Amazon Web Services S3 bucket, etc." "The container diagram shows the high-level shape of the software architecture and how responsibilities are distributed across it." [Container Diagram — c4model.com](https://c4model.com/diagrams/container) (accessed 2026-04-24).
- **Level 3 — Component.** "Next you can zoom in and decompose a container to describe the components that reside inside it; including their responsibilities and the technology/implementation details." [Component Diagram — c4model.com](https://c4model.com/diagrams/component) (accessed 2026-04-24).
- **Level 4 — Code.** Brown positions this level as optional, showing implementation-level detail (e.g., UML class diagrams) for the most important components only. [The C4 model — c4model.com](https://c4model.com/) (accessed 2026-04-24).

The higher-level "Software System" abstraction is defined as "the highest level of abstraction and describes something that delivers value to its users, whether they are human or not." [Software System — c4model.com](https://c4model.com/abstractions/software-system) (accessed 2026-04-24).

[SYNTHESIS] Read alongside Documenting Software Architectures (Views and Beyond) — which organises architecture documentation into Module, Component-and-Connector, and Allocation views — C4 can be seen as a lightweight, hierarchical subset aimed at developers. The O'Reilly book page describes the approach and its update for "service-oriented and multi-tier architectures." [Documenting Software Architectures 2nd ed. — O'Reilly catalog page, Clements et al., 2010](https://www.oreilly.com/library/view/documenting-software-architectures/9780132488617/) (accessed 2026-04-24).

---

## 6. Non-functional requirements

### 6.1 ISO/IEC 25010

[VERIFIED] The current revision is **ISO/IEC 25010:2023** (published November 2023), superseding ISO/IEC 25010:2011. The 2023 revision expands the product-quality model to **nine characteristics** by adding Safety, renaming Usability to Interaction Capability, renaming Portability to Flexibility, and introducing new sub-characteristics (Inclusivity and Self-descriptiveness under Interaction Capability; Resistance under Security; Scalability under Flexibility). User interface aesthetics and maturity were replaced with user engagement and faultlessness, respectively. [Update on ISO 25010, version 2023 — arc42 Quality Model](https://quality.arc42.org/articles/iso-25010-update-2023) (accessed 2026-04-24); [New Version of ISO 25010 released — SARM, 2023-12-06](https://sarm.org.uk/2023/12/06/new-version-of-iso-25010-released/) (accessed 2026-04-24).

The nine characteristics of ISO/IEC 25010:2023:

1. **Functional suitability**
2. **Performance efficiency** — time behaviour, resource utilization, capacity
3. **Compatibility** — co-existence, interoperability
4. **Interaction capability** (renamed from Usability in 2011) — adds inclusivity and self-descriptiveness sub-characteristics
5. **Reliability** — includes faultlessness (replacing maturity), availability, fault tolerance, recoverability
6. **Security** — adds resistance sub-characteristic
7. **Maintainability**
8. **Flexibility** (renamed from Portability in 2011) — adds scalability sub-characteristic
9. **Safety** — new in 2023

[Update on ISO 25010, version 2023 — arc42 Quality Model](https://quality.arc42.org/articles/iso-25010-update-2023) (accessed 2026-04-24); [New Version of ISO 25010 released — SARM, 2023-12-06](https://sarm.org.uk/2023/12/06/new-version-of-iso-25010-released/) (accessed 2026-04-24); [ISO/IEC 25010 overview (current) — iso25000.com](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010) (accessed 2026-04-24).

For historical reference, ISO/IEC 25010:2011 defined **eight characteristics and 31 sub-characteristics** (Functional suitability, Performance efficiency, Compatibility, Usability, Reliability, Security, Maintainability, Portability) [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24). Wikipedia's article had not yet been updated in this session to cover the 2023 revision in its main body; this explains the earlier apparent contradiction between Wikipedia (8-characteristic / 2011) and iso25000.com (9-characteristic / 2023 with Interaction Capability) — both were accurate for their respective editions.

### 6.2 Vendor quality frameworks

Microsoft's Azure Well-Architected Framework defines five pillars: **Reliability**, **Security**, **Cost Optimization**, **Operational Excellence**, **Performance Efficiency**. The framework is described as "a set of quality-driven tenets, architectural decision points, and review tools intended to help solution architects build a technical foundation for their workloads." [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24).

[SYNTHESIS] The Azure WAF pillars (Reliability, Security, Performance Efficiency, Operational Excellence, Cost Optimization) overlap with ISO/IEC 25010's reliability, security, performance efficiency, and maintainability dimensions but extend them with explicitly operational concerns (operational excellence, cost) that the 25010 product-quality model does not cover. The two can be used together: 25010 for product-quality review, WAF for workload review.

### 6.3 Observability

Microsoft's microservices guidance lists observability as a first-class concern: "Centralized logging brings logs together … Real-time monitoring with application performance monitoring agents and frameworks like OpenTelemetry provides visibility into system health and performance. Distributed tracing tracks requests across service boundaries." [Microservices Architecture Style — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24). This is detailed further in Stage 07 (Operations) research.

---

## Open questions

- **Evidence for BDUF as still-in-use practice.** The fetched sources assume iterative architecture; where BDUF persists (certain regulated domains, fixed-price contracts), sources must be fetched before those claims are made.
- **Modular monolith.** The C4, Microsoft, and Fowler pages I fetched describe monolith and microservices, but did not provide a primary-source definition of "modular monolith." That style is widely discussed but needs a cited definition (candidate: "Modular Monolith" by Simon Brown or Kamil Grzybek's blog) before use here.
- **ISO/IEC 25010:2023 primary text.** The authoritative ISO page (iso.org/standard/78176.html) returned 403; the 2023 characteristic/sub-characteristic list above is sourced from arc42's write-up and SARM's release notice. A licensed read of the standard would let the sub-characteristic list under each of the nine characteristics be enumerated directly.
- **Empirical evidence for monolith-first vs microservice-first failure rates.** Fowler acknowledges the evidence is "limited and tentative" (2015). A 2023+ study/survey has not been fetched here.

---

## Sources

- [Documenting Architecture Decisions — Michael Nygard, cognitect.com, 2011-11-15](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (accessed 2026-04-24)
- [Architectural Decision Records — adr.github.io](https://adr.github.io/) (accessed 2026-04-24)
- [Microservices — Martin Fowler & James Lewis, martinfowler.com/articles, 2014-03-25](https://martinfowler.com/articles/microservices.html) (accessed 2026-04-24)
- [MonolithFirst — Martin Fowler, 2015-06-03](https://martinfowler.com/bliki/MonolithFirst.html) (accessed 2026-04-24)
- [MicroservicePremium — Martin Fowler](https://martinfowler.com/bliki/MicroservicePremium.html) (accessed 2026-04-24)
- [ServiceOrientedAmbiguity — Martin Fowler, 2005-07-01](https://martinfowler.com/bliki/ServiceOrientedAmbiguity.html) (accessed 2026-04-24)
- [microservices.io — Chris Richardson](https://microservices.io/) (accessed 2026-04-24)
- [How to Break a Monolith into Microservices — Zhamak Dehghani, martinfowler.com, 2018-04-24](https://martinfowler.com/articles/break-monolith-into-microservices.html) (accessed 2026-04-24)
- [Serverless Architectures — Mike Roberts, 2018-05-22](https://martinfowler.com/articles/serverless.html) (accessed 2026-04-24)
- [Event-Driven Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) (accessed 2026-04-24)
- [Microservices Architecture Style — Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) (accessed 2026-04-24)
- [Domain-Driven Design — Martin Fowler bliki](https://martinfowler.com/bliki/DomainDrivenDesign.html) (accessed 2026-04-24)
- [BoundedContext — Martin Fowler bliki](https://martinfowler.com/bliki/BoundedContext.html) (accessed 2026-04-24)
- [UbiquitousLanguage — Martin Fowler bliki](https://martinfowler.com/bliki/UbiquitousLanguage.html) (accessed 2026-04-24)
- [Use Tactical DDD to Design Microservices — Microsoft Azure](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) (accessed 2026-04-24)
- [The C4 model — c4model.com](https://c4model.com/) (accessed 2026-04-24)
- [System Context Diagram — c4model.com](https://c4model.com/diagrams/system-context) (accessed 2026-04-24)
- [Container Diagram — c4model.com](https://c4model.com/diagrams/container) (accessed 2026-04-24)
- [Component Diagram — c4model.com](https://c4model.com/diagrams/component) (accessed 2026-04-24)
- [Software System — c4model.com](https://c4model.com/abstractions/software-system) (accessed 2026-04-24)
- [ISO/IEC 25010 — Wikipedia](https://en.wikipedia.org/wiki/ISO/IEC_25010) (accessed 2026-04-24)
- [ISO/IEC 25010 overview — iso25000.com](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010) (accessed 2026-04-24)
- [Update on ISO 25010, version 2023 — arc42 Quality Model](https://quality.arc42.org/articles/iso-25010-update-2023) (accessed 2026-04-24)
- [New Version of ISO 25010 released — SARM, 2023-12-06](https://sarm.org.uk/2023/12/06/new-version-of-iso-25010-released/) (accessed 2026-04-24)
- [Azure Well-Architected Framework — Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/) (accessed 2026-04-24)
- [Documenting Software Architectures (Views and Beyond), 2nd ed. — Clements et al., O'Reilly catalog page, 2010](https://www.oreilly.com/library/view/documenting-software-architectures/9780132488617/) (accessed 2026-04-24)
