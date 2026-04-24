# Deprecation, Sunset, and Legacy Modernization

**Question:** How do teams communicate deprecation, sunset, and end-of-life? What are the verified industry mechanisms — RFC 8594 Sunset header, Stripe/GitHub versioning, the Strangler Fig pattern — and how do they connect?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. RFC 8594 — the HTTP `Sunset` header

RFC 8594 (Informational, May 2019, author Erik Wilde) defines the `Sunset` HTTP response header. The abstract states it "indicates that a URI is likely to become unresponsive at a specified point in the future." [RFC 8594 — The Sunset HTTP Header Field — IETF, 2019](https://datatracker.ietf.org/doc/html/rfc8594) (accessed 2026-04-24).

Use cases called out by the RFC:

1. **Temporary resources** — inherently short-lived (e.g., pending orders).
2. **Migration** — resources being relocated ahead of time.
3. **Retention** — compliance-based deletion after mandatory retention periods.
4. **Deprecation** — API decommissioning; the RFC positions the header as useful for signalling the final date, not for initial deprecation.

The header carries an HTTP-date timestamp (`Sunset: Sat, 31 Dec 2018 23:59:59 GMT`) and, per the spec, "Clients SHOULD treat Sunset timestamps as hints: it is not guaranteed that the resource will, in fact, be available until that time." [RFC 8594 — IETF, 2019](https://datatracker.ietf.org/doc/html/rfc8594) (accessed 2026-04-24).

---

## 2. API versioning approaches — two documented examples

### Stripe

Stripe uses a **dual-release** strategy with named major releases (e.g., "Acacia") and backward-compatible monthly releases.

- Major: "Each major release, such as Acacia, includes changes that aren't backward-compatible with previous releases."
- Monthly: "Each monthly release includes only backward-compatible changes, and uses the same name as the last major release."
- Upgrade risk: "Upgrading to a new major release can require updates to existing code," but "You can safely upgrade to a new monthly release without breaking any existing code."
- SDK pinning: recent major versions of Stripe SDKs fix the API version they target (e.g., stripe-ruby v9+, stripe-python v6+, stripe-php v11+, stripe-node v12+).
- Per-request overrides: users "can override the API version in your code in all versions" and test upgrades via Workbench before committing.

[API versioning — Stripe Docs](https://docs.stripe.com/api/versioning) (accessed 2026-04-24).

### GitHub

GitHub uses **date-based REST API versioning**. The `X-GitHub-Api-Version` header selects a version; the default (at time of fetch) is `2022-11-28`. [API Versions — GitHub Docs](https://docs.github.com/en/rest/overview/api-versions) (accessed 2026-04-24).

- "The API version name is based on the date when the API version was released. For example, the API version `2026-03-10` was released on Tue, 10 Mar 2026."
- "When a new REST API version is released, the previous API version will be supported for at least 24 more months following the release of the new API version."
- GitHub commits to "provide advance notice before releasing breaking changes." Breaking changes include operations removal, parameter modifications, and authentication requirement changes; additive changes remain available across supported versions.

[API Versions — GitHub Docs](https://docs.github.com/en/rest/overview/api-versions) (accessed 2026-04-24).

**Comparison [SYNTHESIS]:** Stripe's approach couples a named major with a rolling monthly baseline and per-account default; GitHub's couples a date-stamped version selector with a 24-month support window. The common theme is: make the version explicit at the protocol surface, commit to a concrete support duration, and document breaking changes in a changelog that integrators can read before upgrading.

---

## 3. Putting deprecation together

**Operational pattern [SYNTHESIS]**, supported by the sources above:

1. *Decide* — classify the change (breaking vs. additive, per SemVer / per-vendor policy).
2. *Announce* — publish to a changelog and emit `Sunset` headers on affected endpoints (RFC 8594) well before the removal date.
3. *Enforce a window* — commit to a support duration (GitHub commits to 24 months; Stripe commits to "safely upgrade to a new monthly release without breaking any existing code").
4. *Assist migration* — provide migration guides, SDK versions pinned to API versions, and per-request overrides for testing (Stripe's approach).
5. *Remove* — at the sunset date, remove the endpoint and continue to return informative errors where feasible.

No single standard encodes steps 1 and 4–5; those are observed from the vendor documentation rather than from an RFC.

---

## 4. Legacy modernization — Strangler Fig

For deprecating larger chunks of a system rather than individual endpoints, Martin Fowler's **Strangler Fig Application** pattern is the canonical short-form reference. [Strangler Fig Application — Martin Fowler, 2024](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).

Fowler's framing: the approach "begins with small additions, often new features, that are built on top of, yet separate to the legacy code base." Modernization progresses through four activities:

1. Establish clear desired outcomes.
2. Decompose the system into manageable components.
3. Deliver replacements incrementally.
4. Implement organizational changes to sustain the approach.

Fowler cautions that using Strangler Fig "doesn't make the exercise easy" but allows "investment and returns [to] occur gradually and visibly, allowing the organization to evolve its software and business process." [Strangler Fig Application — Fowler](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).

The pattern requires a transitional architecture so old and new systems coexist during the replacement. [Strangler Fig Application — Fowler](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).

**Connection to this document [SYNTHESIS]:** The Sunset header and per-endpoint versioning (sections 1–3) are the *small-grain* mechanisms of deprecation. The Strangler Fig is the *large-grain* mechanism for retiring an entire legacy application. A migration program typically uses both: the Strangler Fig choreographs the move; per-endpoint Sunset/versioning signals manage client migration at the protocol level.

---

## 5. End-of-life — what is not covered here

The task brief asks about data migration and customer communication at EOL. This document does not yet cite a primary source specifying a general EOL data-migration procedure; such procedures are typically documented per-vendor (e.g., SaaS terms of service data-export clauses) and were not fetched in this session. Treat specific EOL playbooks as `[UNVERIFIED]` in this document.

What *is* verified:

- A public sunset signal can be encoded as a header (RFC 8594).
- A public support-window commitment is a documented practice (GitHub 24 months; Stripe monthly backward-compatible).
- Large systems can be retired progressively via Strangler Fig rather than cut-over (Fowler, 2024).

That is the minimum verified scaffolding for an EOL communication plan; the specifics (notice periods, data-export tooling, contractual obligations) depend on domain and contract.

---

## Sources

- [RFC 8594 — The Sunset HTTP Header Field — IETF, 2019](https://datatracker.ietf.org/doc/html/rfc8594) (accessed 2026-04-24).
- [API versioning — Stripe Docs](https://docs.stripe.com/api/versioning) (accessed 2026-04-24).
- [API Versions — GitHub Docs](https://docs.github.com/en/rest/overview/api-versions) (accessed 2026-04-24).
- [Strangler Fig Application — Martin Fowler, 2024](https://martinfowler.com/bliki/StranglerFigApplication.html) (accessed 2026-04-24).

---

## Open questions

- No primary source for a `Deprecation` HTTP header was fetched in this session (an IETF draft exists but was not retrieved); this document therefore treats Sunset as the only verified header-level mechanism.
- Salesforce, AWS, and Google Cloud each publish their own deprecation/sunset guarantees; none of these were fetched, so cross-vendor comparisons beyond Stripe and GitHub are `[UNVERIFIED]`.
- A primary source for general EOL data-migration obligations (e.g., a SaaS standard or cloud provider policy) was not fetched.
