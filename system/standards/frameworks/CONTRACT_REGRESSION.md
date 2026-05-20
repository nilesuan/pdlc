# CONTRACT_REGRESSION.md — Conditional escalation

**Authoritative source:** [`../../../research/05-testing/test-levels.md`](../../../research/05-testing/test-levels.md) §"How Pact works (consumer-driven contracts)"; Pact docs.

## Activation

Loaded when the brief contains any of: `public-API`, `shared-library`, `cross-team`, `consumer`, `provider`, `contract`, `Pact`.

## Why

When two services agree on an interface, both need to keep that agreement testable in CI without standing up the other service. Consumer-driven contracts (Pact) generate contracts during the consumer's test execution, then verify them against the provider — concrete examples, not static specs.

## Required artifacts

- **Consumer contract tests** committed alongside the consumer code; running them generates a contract artifact (Pact file).
- **Provider verification tests** that run the contract against the real provider — passing in CI before the provider can merge.
- **Breaking-change assessment**: if the contract changes, document whether the change is breaking. If breaking → MAJOR version bump per [`../release/VERSIONING.md`](../release/VERSIONING.md), and a migration path documented.

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Consumer side | Consumer contract tests pass; contract artifact generated |
| 2 | Provider side | Provider verification tests run against real provider — green |
| 3 | Compatibility | If contract changed, breaking-change column populated; non-breaking confirmed by provider running both old + new contract |
| 4 | Versioning | If breaking, MAJOR bump applied; migration guide present |
| 5 | Pact broker / equivalent | Contract published to a broker or equivalent registry; downstream consumers notified |

## Escalation impact

- `max_passes = 5`.
- Public API change without a green provider verification is an automatic `blocker`.
- Breaking change without MAJOR bump + migration guide is an automatic `blocker`.

## Sources

- [`../../../research/05-testing/test-levels.md`](../../../research/05-testing/test-levels.md) — [VERIFIED] Pact docs and PactFlow article on consumer-driven contracts.
- [`../release/VERSIONING.md`](../release/VERSIONING.md) — SemVer policy for breaking changes.
- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §14 — Deprecation policy.
