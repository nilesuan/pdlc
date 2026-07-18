# PRINCIPLES.md - Cross-cutting design principles

**Companion to** the design standards that already stand on their own: [`TRUNK_BASED.md`](TRUNK_BASED.md), [`TDD.md`](TDD.md), [`CLEAN_ARCHITECTURE.md`](CLEAN_ARCHITECTURE.md), [`SOLID.md`](SOLID.md). Those are not repeated here.

This file codifies the smaller, cross-cutting principles that govern the shape of day-to-day code. Each carries a one-line rule, a **Why**, and - where it would otherwise contradict another rule - an explicit precedence note. These are defaults for applying judgment, not dogma to pattern-match. On any conflict with [`../../CLAUDE.md`](../../CLAUDE.md), CLAUDE.md wins (§9).

## Proportionality (the meta-rule)

Apply every principle below in proportion to the change's size and blast radius. A throwaway script does not earn the layering a payments service does. **KISS and YAGNI are the governors** that stop the structural principles (Clean Architecture, SOLID, CQS, composition) from turning into gold-plating. Proportionality governs how much structure a change *needs*; it does not waive the SOLID and Clean-Architecture Hard rules in [`../../platform-team/engineering-policy.md`](../../platform-team/engineering-policy.md) §6-§7 - deviating from those on shipped code still requires a recorded ADR (§12). *Why: cargo-culted structure is a failure mode this system already refuses elsewhere (TRUNK_BASED.md: "We use GitFlow because the book is good" (refuse)).*

## The principles

### KISS - Keep It Simple

The simplest design that meets the requirement wins; add structure only when a concrete, present need forces it. *Why: complexity is a tax every future reader and change pays. Precedence: KISS bounds how much Clean Architecture / SOLID a given change earns.*

### YAGNI - You Aren't Gonna Need It

Build only what the current requirement needs. No speculative hooks, config, or abstraction for a hypothetical future. *Why: speculative generality ages into wrong guesses that become load-bearing before anyone notices. This is the design-level restatement of CLAUDE.md §6 (do exactly what was asked; no defensive code for impossible cases).*

### DRY - Don't Repeat Yourself

Give each piece of *knowledge* - a business rule, a constant, a schema - a single authoritative home. DRY targets duplicated knowledge, not incidental line-level similarity. *Why: two copies of one rule drift apart silently and the stale one becomes a bug. Precedence: bounded by AHA - do not deduplicate code that merely looks alike.*

### AHA - Avoid Hasty Abstractions

Prefer duplication over the wrong abstraction. Wait until the shared shape is proven (rule of thumb: the third occurrence) before extracting. *Why: a premature abstraction couples callers that were never really the same and is costlier to unwind than the duplication it replaced. Precedence: AHA decides WHEN DRY fires; when DRY and AHA pull apart, AHA wins.*

### Composition Over Inheritance

Model reuse and variation by composing small parts (has-a, uses-a); reserve inheritance for genuine, Liskov-clean subtype relationships. *Why: deep inheritance is rigid and leaks base-class assumptions into every subclass. Relation: the concrete corollary of SOLID's LSP and DIP (see SOLID.md).*

### CQS - Command-Query Separation

A method is either a query (returns a value, no observable side effect) or a command (changes state, returns nothing), never both. Asking a question must not change the answer. *Why: a query that mutates makes call order load-bearing and surprises every caller. Named exceptions exist (an atomic `pop()` / get-and-set); document them at the call site.*

### PoLE - Principle of Least Astonishment

Code behaves the way a reasonable developer reading the call site expects. No clever tricks, no misleading names, no hidden mutation of global state. *Why: surprise is a defect even when the code is "correct" - it is the seam where the next maintainer introduces a real bug. Relation: reinforces CQS and CLAUDE.md §6's comment rule.*

### Fail Fast

On bad input or an unexpected condition, stop loudly at the boundary where it is detected; never continue on bad data or paper over it with a silent fallback. *Why: silent continuation corrupts state far from the cause; a loud early failure surfaces the bug where it started. Reconciliation with CLAUDE.md §6: validate and fail at boundaries (user input, external API, deserialization) - do NOT add defensive checks for framework-guaranteed internal invariants. Fail-fast means not swallowing real errors, not distrusting your own types.*

### Zero Trust

Trust no input, caller, or network position by default; authenticate and authorize at every boundary and grant least privilege. *Why: implicit trust in "internal" callers or network location is the assumption most breaches exploit. Scope: a security-boundary posture - it applies at trust boundaries (inbound requests, service-to-service calls, secrets access), not inside a pure function. Platform controls live in [`../../techstacks/13-security.md`](../../techstacks/13-security.md).*

## Deliberately not adopted as an always-rule

- **Boy Scout Rule (opportunistic inline cleanup).** Considered and declined in the "always" form: "fix any minor issue you spot while doing something else" contradicts CLAUDE.md §6 (do exactly what was asked; no "while I was in there" changes) and small-PR / trunk-based discipline. **Substitute:** when you spot an out-of-scope issue, record it as a tracked ticket or backlog item and fix it in its own scoped change, never inline in an unrelated diff. (The lessons loop in `../process/LEARNING.md` is for system self-correction, not code-defect capture, so it is deliberately not the channel for this.) *Why: reviewable, single-purpose PRs outrank opportunistic tidying; the issue still gets captured, just not smuggled into an unrelated change.*

## Auto-rejection (used by code-reviewer)

| Trigger | Severity |
|---|---|
| An error or unexpected condition is swallowed / execution continues on bad data instead of failing at the boundary (Fail Fast) | Major |
| A method both returns a value and mutates observable state, with no documented exception (CQS) | Minor |
| Inheritance used where composition fits and no Liskov-clean is-a relationship holds | Minor |
| Defensive validation added for a framework-guaranteed internal invariant (YAGNI / §6) | Minor |
| An abstraction extracted at first occurrence with no proven shared shape (AHA) | Minor |
| Hidden global-state mutation, a misleading name, or a clever trick at a call site (PoLE) | Minor |

## Relationship to CLAUDE.md

CLAUDE.md §6 (Scope) is the binding non-negotiable; the principles here shape code *within* that scope. Where any principle here would contradict CLAUDE.md, CLAUDE.md wins (§9) and this file is updated to match.

## Sources

- **KISS** - acronym attributed to Kelly Johnson, Lockheed Skunk Works; in common software use by the 1970s. [KISS principle - Wikipedia](https://en.wikipedia.org/wiki/KISS_principle).
- **YAGNI** - Extreme Programming (Kent Beck / Ron Jeffries); "You Aren't Gonna Need It".
- **DRY** - Andy Hunt and Dave Thomas, *The Pragmatic Programmer* (1999).
- **AHA** - Kent C. Dodds, ["AHA Programming"](https://kentcdodds.com/blog/aha-programming), building on Sandi Metz, "prefer duplication over the wrong abstraction" (2016).
- **Composition over inheritance** - Gamma, Helm, Johnson, Vlissides (Gang of Four), *Design Patterns* (1994): "favor object composition over class inheritance".
- **CQS** - Bertrand Meyer, *Object-Oriented Software Construction* (1st ed. 1988). [Command-query separation - Wikipedia](https://en.wikipedia.org/wiki/Command%E2%80%93query_separation).
- **PoLE** - no single coiner; "Law of Least Astonishment" appears in the PL/I Bulletin (1967) and is restated as the "Rule of Least Surprise" in Eric S. Raymond, *The Art of Unix Programming* (2003). [Principle of least astonishment - Wikipedia](https://en.wikipedia.org/wiki/Principle_of_least_astonishment).
- **Fail Fast** - Jim Shore, "Fail Fast", *IEEE Software*, September 2004 (DOI 10.1109/MS.2004.1331296). [PDF via Fowler](https://martinfowler.com/ieeeSoftware/failFast.pdf).
- **Zero Trust** - term coined by John Kindervag at Forrester (2010, "No More Chewy Centers"); standardized in [NIST SP 800-207](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf) (2020).
