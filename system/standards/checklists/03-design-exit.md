# 03-design-exit.md — Phase 03 (Design) exit checklist

**Authoritative source:** [`../../../handbook/03-design.md`](../../../handbook/03-design.md); [`../development/CLEAN_ARCHITECTURE.md`](../development/CLEAN_ARCHITECTURE.md).

This checklist is run at the end of `/design`.

## Done-when

- [ ] **User flows** documented for the primary tasks (≥ 1 per OKR / KR).
- [ ] **C4 Context diagram** (Level 1) for the system in scope.
- [ ] **C4 Container diagram** (Level 2) for the system in scope.
- [ ] **C4 Component diagram** (Level 3) for any non-trivial container.
- [ ] **Data model** drafted: entities, relationships, ownership, retention.
- [ ] **API contract** drafted: endpoints, schemas, error model, versioning approach. (REST/OpenAPI / GraphQL / gRPC — schema-as-source).
- [ ] **NFRs explicit:** target latency p99, target throughput, availability SLO, security tier (ASVS L1/L2/L3), accessibility tier (WCAG 2.2 AA default).
- [ ] **STRIDE threat model** completed: Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation of privilege. Each threat with mitigation.
- [ ] **ASVS target level chosen** per service (L1/L2/L3). See [`../security/OWASP.md`](../security/OWASP.md).
- [ ] **ADRs filed** for load-bearing decisions: storage choice, sync vs. async, auth strategy, multi-tenancy model. See [`../docs/ADR.md`](../docs/ADR.md).
- [ ] **Clean Architecture layering** sketched — domain/use-case/adapter/infra boundaries identified. See [`../development/CLEAN_ARCHITECTURE.md`](../development/CLEAN_ARCHITECTURE.md).
- [ ] **Capacity / cost estimate** at expected and peak load (rough order of magnitude OK).
- [ ] **Failure modes documented** — what breaks first under load? What's the rollback?

## Auto-rejection

| Trigger | Severity |
|---|---|
| Design proceeding without an ADR for a load-bearing choice | Major |
| Threat model absent | Blocker for any service handling user data or auth |
| Multi-tenancy model unspecified for a multi-tenant service | Blocker |
| API contract with no error model | Major |
| NFRs missing latency / availability targets | Major |
| Domain layer in the design imports infra (per Clean Arch rule) | Blocker |
| Single shared database for unrelated services without ADR | Major |
| Synchronous chain ≥ 4 hops | Major (latency / failure surface) |

## What good looks like

- The design is reviewable by someone outside the team; the C4 set + NFRs + threat model give them enough to push back substantively.
- Reversibility called out explicitly — which decisions are "easy to change later" vs. "will define this system for years".
- ADR for at least one rejected option per major decision.
- A diagram of "what happens when X fails" — not just the happy path.

## Sources

- Simon Brown, C4 Model (c4model.com).
- Robert C. Martin, *Clean Architecture* (2017).
- Adam Shostack, *Threat Modeling: Designing for Security* (2014) — STRIDE.
- OWASP ASVS (owasp.org/www-project-application-security-verification-standard/).
- WCAG 2.2 (w3.org/TR/WCAG22/).
- Michael Nygard, *Release It!* (2nd ed., 2018) — failure modes.
- Handbook: [`../../../handbook/03-design.md`](../../../handbook/03-design.md).
