# CHARACTERIZATION_TESTING.md — Conditional escalation

**Authoritative source:** [`../../../research/08-maintenance/README.md`](../../../research/08-maintenance/README.md) §"Feathers on seams and dependency breaking"; Michael Feathers, *Working Effectively with Legacy Code* (Prentice Hall, 2004).

## Activation

Loaded when the brief contains any of: `legacy-code`, `no-tests`, `refactor`, `behavior-preservation`, `untested`.

## Why

Modifying untested code without first capturing current behavior is how regressions ship. Feathers' technique: write tests that pin down what the code *currently* does (regardless of whether it's correct) before changing anything. The tests become the safety net for refactor.

## Required artifacts

- **Characterization tests** at `tests/characterization/<module>/` (or equivalent) with:
  - Each test names: input → observed output, with a flag for "known bug" (the test pins the bug; do not fix it in this pass).
  - Tests pass against the **unmodified** code on the first run. Failing tests on unmodified code mean the test is wrong, not the code.
- **Seam map** documenting where dependency-breaking happens (preprocessing seams, link seams, object seams — Feathers' three types). Per the Pearson/InformIT excerpt, "object seams are the best choice in object-oriented languages" — prefer object seams unless a constraint blocks it.

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Capture | Characterization tests pass against unmodified code; observed behavior recorded |
| 2 | Seams | Dependency-breaking documented; object seams preferred where applicable |
| 3 | Refactor | Refactor changes structure; characterization tests still pass; behavior preserved |
| 4 | New tests | New unit tests added for changed surfaces (TDD on the new code) |
| 5 | Cleanup | Known-bug flags resolved or filed; the characterization layer reduced where unit tests now cover |

## Escalation impact

- `max_passes = 5`.
- A pass cannot be scored if `tests/characterization/...` doesn't exist or doesn't pass against the pre-change tree.
- Refactor commits without characterization tests are an automatic `blocker`.

## Sources

- [`../../../research/08-maintenance/README.md`](../../../research/08-maintenance/README.md) — Feathers grounding, seam types, [VERIFIED] InformIT excerpt.
- [`../development/TDD.md`](../development/TDD.md) — once characterization is in place, new code follows TDD.
- Michael Feathers, *Working Effectively with Legacy Code*, Chapter 4 "The Seam Model" and Part III "Dependency Breaking Techniques" — see research source above.
