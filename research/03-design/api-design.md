# API Design

**Question:** What are the canonical API styles (REST, GraphQL, gRPC), and what published design guidelines exist for each?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. REST (Representational State Transfer)

**Origin.** Roy Fielding introduced REST in his 2000 UC Irvine doctoral dissertation, "Architectural Styles and the Design of Network-based Software Architectures." Direct fetch of the dissertation chapter (https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) returned HTTP 403 in this session, so the primary source is noted below via a search-result summary and a Wikipedia cross-reference.

From a UC Irvine search-result summary (accessed 2026-04-24): "REST provides a set of architectural constraints that, when applied as a whole, emphasizes scalability of component interactions, generality of interfaces, independent deployment of components, and intermediary components to reduce interaction latency, enforce security, and encapsulate legacy systems." [Fielding Dissertation — ics.uci.edu search-result summary](https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) (access date 2026-04-24; direct fetch blocked).

**Six constraints** (per Wikipedia, cross-referenced back to Fielding's dissertation):

1. **Client–server** — "Clients are separated from servers by a well-defined interface."
2. **Stateless** — "A specific client does not consume server storage when the client is 'at rest.'"
3. **Cache** — "Responses indicate their own cacheability."
4. **Uniform interface** — the fundamental constraint requiring resource identification, manipulation through representations, self-descriptive messages, and HATEOAS (Hypermedia as the Engine of Application State).
5. **Layered system** — "A client cannot ordinarily tell whether it is connected directly to the end server, or to an intermediary."
6. **Code on demand (optional)** — "Servers are able to temporarily extend or customize the functionality of a client by transferring logic to the client."

[Representational State Transfer — Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer) (accessed 2026-04-24).

[VERIFIED via Wikipedia cross-reference; primary-source quotation requires re-fetching the Fielding dissertation.]

---

## 2. GraphQL

**Definition.** From the GraphQL specification GitHub repository (accessed 2026-04-24), GraphQL is described as "a query language and execution engine tied to any backend service," comprising "a type system, query language, execution semantics, static validation, and type introspection." [GraphQL specification — graphql/graphql-spec GitHub repo](https://github.com/graphql/graphql-spec) (accessed 2026-04-24).

**How it works** (from the same source):

- **Type system** — "APIs define available data types, fields, and their relationships through a schema," including scalars, objects, interfaces, and enums.
- **Query language** — "Clients declaratively specify exactly which data they need … [which] eliminates over-fetching and under-fetching common in REST APIs."
- **Validation** — queries are validated against the schema before execution.
- **Execution** — the server processes validated queries against its schema and data sources, returning results matching the requested structure.
- **Introspection** — clients can query the schema itself "to discover available types, fields, and documentation."

[GraphQL specification — graphql/graphql-spec GitHub repo](https://github.com/graphql/graphql-spec) (accessed 2026-04-24).

[UNVERIFIED] The canonical URL https://graphql.org/ returned HTTP 403 in this session, so quotations from graphql.org itself cannot be provided. The above is from the specification repository description.

---

## 3. gRPC

**Definition.** grpc.io describes gRPC as "A high performance, open source universal RPC framework" with the following properties:

- **Service definition**: "Define your service using Protocol Buffers, a powerful binary serialization toolset and language."
- **Performance**: "Install runtime and dev environments with a single line and also scale to millions of RPCs per second."
- **Portability**: "Automatically generate idiomatic client and server stubs for your service in a variety of languages and platforms."
- **Features**: "Bi-directional streaming and fully integrated pluggable authentication with HTTP/2-based transport."

[gRPC — grpc.io](https://grpc.io/) (accessed 2026-04-24).

---

## 4. Published API design guidelines

### 4.1 Google API Design Guide

Google's API Design Guide describes itself as a "general design guide for networked APIs. It has been used inside Google since 2014 and is the guide that Google follows when designing Cloud APIs and other Google APIs." [Google API Design Guide — docs.cloud.google.com/apis/design (via redirect from cloud.google.com/apis/design)](https://docs.cloud.google.com/apis/design) (accessed 2026-04-24).

Key emphases (from the same page):

- Applies to both REST and RPC APIs, "with particular emphasis on gRPC."
- Uses Protocol Buffers for API definition and API Service Configuration for HTTP mapping, logging, and monitoring.
- Organised around "Resource-oriented design," with **standard methods** (Get, List, Create, Update, Delete), **custom methods** for specialised functionality, **resource naming conventions**, and chapters on **error handling**, **versioning**, and **backward compatibility**.
- Explicitly framed as a "living document."

[Google API Design Guide — docs.cloud.google.com/apis/design](https://docs.cloud.google.com/apis/design) (accessed 2026-04-24).

### 4.2 Microsoft REST API Guidelines

[VERIFIED] The original `microsoft/api-guidelines` top-level `Guidelines.md` has been deprecated. The file itself now states: "This document has been deprecated and has been moved to the Microsoft REST API Guidelines deprecated" and redirects readers to product-specific guidance [Microsoft REST API Guidelines (deprecation notice) — microsoft/api-guidelines vNext/Guidelines.md](https://github.com/microsoft/api-guidelines/blob/vNext/Guidelines.md) (accessed 2026-04-24).

Current replacements on the same repository:

- **Azure teams** are directed to the [Microsoft Azure REST API Guidelines — microsoft/api-guidelines vNext/azure/Guidelines.md](https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md) (accessed 2026-04-24). This document is explicitly framed as "a living document" with a visible change-history entry dated 2025-Mar-28. It applies to data-plane APIs for Azure services and prescribes consistent patterns aligned with HTTP/REST/JSON, SDK compatibility, retries and idempotency, and versionable API contracts.
- **Microsoft Graph teams** are directed to the [Microsoft Graph REST API Guidelines — microsoft/api-guidelines vNext/graph/GuidelinesGraph.md](https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md) (accessed 2026-04-24). It covers design approach, naming, URL structure, resource modelling, query support, error handling, and versioning for the Graph v1.0 (GA) and beta public endpoints.

Both documents are on the `vNext` branch of the same `microsoft/api-guidelines` repository that previously hosted the deprecated top-level `Guidelines.md`, so the replacement is "move down the tree" rather than "migrate to a different hosting site."

---

## 5. Choosing a style

[SYNTHESIS] Combining the primary sources fetched here:

| Criterion | REST | GraphQL | gRPC |
|---|---|---|---|
| Primary use case | Web/HTTP resource-oriented APIs; heterogeneous clients | Client-driven querying over composed data graphs | High-performance service-to-service RPC |
| Contract | Often OpenAPI (not fetched here); resource-oriented | GraphQL schema (SDL) | Protocol Buffers |
| Transport | HTTP/1.1 or HTTP/2 | HTTP (typically) | HTTP/2 |
| Streaming | Limited | Subscriptions (extension) | Bi-directional streaming (first-class) |
| Key author / source | Roy Fielding (2000 dissertation) | graphql/graphql-spec repo (GraphQL Foundation) | grpc.io (CNCF project) |

Sources: [Representational State Transfer — Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer), [GraphQL specification — graphql/graphql-spec](https://github.com/graphql/graphql-spec), [gRPC — grpc.io](https://grpc.io/) (all accessed 2026-04-24). Cells without a citation (e.g., OpenAPI) are [SYNTHESIS] and would need a primary citation before they became load-bearing claims.

---

## Open questions

- **Direct Fielding dissertation quotation.** The primary UC Irvine page (ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) was not directly accessible. A PDF version is also listed on the same site and may be fetchable.
- **graphql.org primary quotation.** Blocked in this session; use of the spec repo's description is a partial substitute.
- **Detailed prescriptions from Azure / Graph guidelines.** The two replacement documents are now identified (see §4.2) but their specific prescriptions (naming, status codes, pagination patterns, etc.) have not been read into this research pass.
- **OpenAPI / AsyncAPI.** Canonical specs (openapis.org, asyncapi.com) were not fetched in this session; claims about them should not be made yet.
- **API versioning and deprecation strategy.** Not covered here. Candidate primary sources include Google's API Design Guide chapter on versioning and compatibility.

---

## Sources

- [Fielding Dissertation Chapter 5 (search-result summary) — ics.uci.edu](https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) (access date 2026-04-24; direct fetch blocked, content summarised via Google Search result)
- [Representational State Transfer — Wikipedia](https://en.wikipedia.org/wiki/Representational_state_transfer) (accessed 2026-04-24)
- [GraphQL specification — graphql/graphql-spec GitHub repo](https://github.com/graphql/graphql-spec) (accessed 2026-04-24)
- [gRPC — grpc.io](https://grpc.io/) (accessed 2026-04-24)
- [Google API Design Guide — docs.cloud.google.com/apis/design](https://docs.cloud.google.com/apis/design) (accessed 2026-04-24)
- [Microsoft REST API Guidelines (deprecation notice) — github.com/microsoft/api-guidelines vNext/Guidelines.md](https://github.com/microsoft/api-guidelines/blob/vNext/Guidelines.md) (accessed 2026-04-24)
- [Microsoft Azure REST API Guidelines — github.com/microsoft/api-guidelines vNext/azure/Guidelines.md](https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md) (accessed 2026-04-24)
- [Microsoft Graph REST API Guidelines — github.com/microsoft/api-guidelines vNext/graph/GuidelinesGraph.md](https://github.com/microsoft/api-guidelines/blob/vNext/graph/GuidelinesGraph.md) (accessed 2026-04-24)
