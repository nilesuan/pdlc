# COMPOSITION_VERIFICATION.md — Conditional escalation

**Authoritative source:** This system; pattern lifted from `~/.claude.old/commands/build.md` (Composition Verification rules) — see [`../../../SYSTEM.md`](../../../SYSTEM.md). Reinforces TDD by adding a wiring-correctness check that unit-level TDD doesn't naturally cover.

## Activation

Loaded when the brief contains any of: `wire`, `entry-point`, `daemon`, `lifecycle`, `register`, `multi-component`, `main()`.

## Why

Unit tests pass when each component is correct in isolation. Composition bugs happen when the wiring between components is wrong: A constructs B but doesn't `start()` it; a callback registers but never fires; a server initializes after the listener is bound; a provider is constructed but not added to the manager. Mocking the wiring hides these bugs because the mock plays the role the real component should be playing.

The composition test runs from the **real entry point** (e.g., `main()`, daemon startup) through to the leaf, with no internal mocks.

## Required artifacts

- **Integration test** that:
  - Starts at the real entry point (`main()`, daemon `start()`, app initialization).
  - Crosses every internal component boundary using the real types — no mocking of internal seams.
  - Asserts lifecycle ordering (construct → register → start; or whatever the contract is).
  - Includes at least one **negative case**: behavior when a wiring step is missing (server not started, provider not registered, callback not wired).

External boundaries (databases, third-party APIs) may use fakes or test doubles; internal seams may not.

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Entry point | Test starts at real `main()` / daemon entry, not a mid-chain factory |
| 2 | No internal mocks | Component-to-component calls use real types; mocks limited to external boundaries |
| 3 | Lifecycle ordering | Test asserts order (construct → register → start) explicitly |
| 4 | Negative case | At least one test verifies behavior when a wiring step is missing |
| 5 | Story coverage | Every story tagged `[WIRE]` (or equivalent) has an integration test in this set |

## Escalation impact

- `max_passes = 5`.
- A `[WIRE]` story (or any story that wires multiple runtime components) **must** have at least one composition test before scoring proceeds.
- The pass-runner enforces this with finding ID `COMP-WIRE-01`, severity `blocker`, and it is **not overridable**.

## Where this complements TDD

| Test layer | What it proves |
|---|---|
| Unit | Each component is correct in isolation |
| Composition (this) | The wiring between components is correct (lifecycle, registration, callback firing) |
| Integration (external) | Real-world behavior with real external dependencies (DB, network) |
| E2E | User-visible journey end-to-end |

Composition verification sits **between** unit and integration. It's faster than full integration (no real DB) but slower than unit (real internal types). Most valuable on stories that are mostly wiring (entry-point setup, plugin registration, dependency-injection containers).

## Anti-patterns to flag

- "Unit-tested both sides; we don't need an integration test." Misses every wiring bug.
- An integration test that starts mid-chain (e.g., calls `Server.handleRequest()` directly) — defeats the purpose.
- Internal mocks ("we mocked the manager so the test would be fast") — defeats the purpose.
- No negative case — tests the happy path only.

## Sources

- [`../../../SYSTEM.md`](../../../SYSTEM.md) — analysis of `~/.claude.old/commands/build.md` Composition Verification.
- [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) — pyramid / trophy positioning of composition tests.
- [`../development/TDD.md`](../development/TDD.md) — composition tests are a complement, not a replacement.
