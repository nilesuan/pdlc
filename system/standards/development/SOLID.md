# SOLID.md — SOLID design principles

**Authoritative source:** [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §6.

## The five principles (verbatim from Robert C. Martin's 2020 restatement)

- **SRP — Single Responsibility Principle.** "Each software module should have one and only one reason to change." Restatement: "Gather together the things that change for the same reasons. Separate those things that change for different reasons."
- **OCP — Open/Closed Principle.** "A module should be open for extension but closed for modification."
- **LSP — Liskov Substitution Principle.** "A program that uses an interface must not be confused by an implementation of that interface."
- **ISP — Interface Segregation Principle.** "Keep interfaces small so that users don't end up depending on things they don't need."
- **DIP — Dependency Inversion Principle.** "Depend in the direction of abstraction. High level modules should not depend upon low level details."

## Apply where, apply when

- New code: SOLID applies. Reviewed by code-reviewer (`CR-SOLID-*`) and systems-architect.
- Legacy code: SOLID violations are not bugs. Sweeping rewrites to satisfy SOLID need an ADR and a business reason.
- Edges of legacy code: when adding to or modifying legacy, apply SOLID to the *new* edges.

## What violations look like

| Principle | Common violation |
|---|---|
| SRP | Class doing user lookup + email formatting + persistence in one place |
| OCP | New behavior added by inserting `if isinstance(...)` into an existing function |
| LSP | Subclass throws `NotImplementedError` for half the parent's methods |
| ISP | Caller forced to implement methods it never uses |
| DIP | High-level policy imports a concrete database driver directly |

## Severity calibration

| Severity | Example |
|---|---|
| major | DIP violation in domain layer (importing infra concretes from domain) |
| minor | SRP violation in a non-hot module (class with 6+ public methods doing distinct things) |
| nit | "I'd have used DI here" with no actual coupling problem |

## Anti-patterns to flag

- Adding interfaces for one implementation "for testability" — over-engineering.
- "SOLID police" PRs that rewrite working legacy without business reason.
- Treating SOLID as a checklist instead of a design conversation.

## Sources

- Robert C. Martin, "Solid Relevance" (2020) and "The Single Responsibility Principle" (2014) — see [`../../../platform-team/engineering-policy.md`](../../../platform-team/engineering-policy.md) §6 for URLs.
- Research: [`../../../research/04-development/coding-practices.md`](../../../research/04-development/coding-practices.md) §4 (Clean Code).
