# CLEAN_ARCHITECTURE.md — The Dependency Rule

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §7.

## The Dependency Rule

**Source-code dependencies can only point inwards.** Inner layers know nothing about outer layers.

The four canonical layers (Robert C. Martin, "The Clean Architecture"):

```
┌───────────────────────────────────────────────┐
│  Frameworks & Drivers                         │
│  (web framework, DB driver, message broker)   │
│  ┌─────────────────────────────────────────┐  │
│  │  Interface Adapters                     │  │
│  │  (controllers, presenters, repositories) │  │
│  │  ┌───────────────────────────────────┐  │  │
│  │  │  Use Cases                        │  │  │
│  │  │  ┌─────────────────────────────┐  │  │  │
│  │  │  │  Entities                   │  │  │  │
│  │  │  │  (domain business rules)    │  │  │  │
│  │  │  └─────────────────────────────┘  │  │  │
│  │  └───────────────────────────────────┘  │  │
│  └─────────────────────────────────────────┘  │
└───────────────────────────────────────────────┘

  Dependencies point inward only.
```

## Hard rules

1. **Business rules (Entities, Use Cases) do not depend on frameworks, databases, UI, or external agencies.** Frameworks are plugins.
2. **Source-code dependencies point inwards.** A `from sqlalchemy import` inside a `domain/` file is a blocker.
3. **Hexagonal / Ports-and-Adapters / Onion** are compatible variants. Adopt freely.
4. **Replacing the Dependency Rule with a mixed model requires an ADR.**

## Auto-rejection (used by code-reviewer)

| Trigger | Severity |
|---|---|
| `domain/` or `entities/` imports infra (DB, HTTP, FS, framework) | Blocker |
| `application/` (use case) imports a framework directly without an adapter wrapper | Major |
| `infra/` imports `domain/` types | OK (allowed direction) |
| Use case constructor takes a concrete repository instead of an interface | Major |
| Domain entity has methods that perform IO (e.g., DB write) | Blocker |

## Practical layout examples

**Python:**

```
src/
  domain/        # entities, value objects, domain services. NO imports from below.
  application/   # use cases, orchestration. Imports domain only.
  infra/         # adapters: repositories, HTTP clients, DB. Imports application & domain.
  api/           # web framework wiring. Imports application.
```

**Go:**

```
internal/
  domain/
  usecase/
  adapter/
  cmd/
```

## What "the framework is a plugin" means

You should be able to:

- Replace your web framework (Flask → FastAPI, Express → Fastify) with changes only in `api/` and `infra/`.
- Replace your DB (Postgres → DynamoDB) with changes only in `infra/`.
- Run your domain logic in a unit test with no DB, no HTTP, no message broker.

If any of those require touching `domain/`, the architecture is leaking.

## Anti-patterns to flag

- ORM models doubling as domain entities. The ORM model is infra; the domain entity is policy. Conflating them is the most common Clean Architecture failure.
- "Service layer" that does both orchestration and IO. Split into use case (orchestration only) + repository (IO only).
- Test fixtures that need a DB to instantiate a domain entity.

## Sources

- Robert C. Martin, "The Clean Architecture" (2012) — see [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §7.
- Research: [`../../../research/03-design/system-architecture.md`](../../../research/03-design/system-architecture.md).
- Handbook: [`../../../handbook/03-design.md`](../../../handbook/03-design.md), [`../../../handbook/04-build.md`](../../../handbook/04-build.md).
