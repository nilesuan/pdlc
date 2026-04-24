# Feature Flags, Progressive Delivery, and Release Management

**Question:** How do teams decouple deploy from release, and how do they version and communicate what they ship?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. Feature flags / feature toggles

### Definition

`[VERIFIED]` Pete Hodgson's canonical 2017 article on martinfowler.com:

> "Feature Toggles (often also refered to as Feature Flags) are a powerful technique, allowing teams to modify system behavior without changing code."

([Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24); confirmed at [Feature Toggle — Martin Fowler bliki, 2010/2016/2023](https://martinfowler.com/bliki/FeatureToggle.html) (accessed 2026-04-24)).

### The four categories

`[VERIFIED]` Hodgson defines four categories, each with distinct dynamism and lifetime ([Feature Toggles — Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html)):

| Category | Purpose | Lifetime | Dynamism |
|---|---|---|---|
| **Release toggles** | Allow incomplete code to ship to production as dormant functionality. Support trunk-based development for continuous delivery. | Short-lived | Low |
| **Experiment toggles** | Enable A/B and multivariate tests by placing users into cohorts. | Short-lived (experiment duration) | Highly dynamic (per request) |
| **Ops toggles** | Control operational aspects; allow graceful degradation; some become permanent "kill switches" for non-critical features during high-demand periods. | Varies; some permanent | Varies |
| **Permissioning toggles** | Restrict features to specific user groups (premium, beta, internal). | Can be "very-long lived compared to other categories" | Always per-request dynamic |

### The "inventory" warning

`[VERIFIED]` Hodgson's key warning against flag proliferation:

> Teams should "view their Feature Toggles as inventory which comes with a carrying cost, and work to keep that inventory as low as possible" through proactive removal and expiration strategies.

([Feature Toggles — Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html)).

### Vendor implementations

`[SYNTHESIS]` LaunchDarkly is the most commonly cited commercial feature-flag platform. The LaunchDarkly documentation home page fetched on 2026-04-24 points to the `/docs/home/getting-started`, `/docs/sdk`, and `/docs/guides` sections for the detailed feature-flag mechanics, targeting rules, and SDK integration ([LaunchDarkly Docs home](https://launchdarkly.com/docs/home) (accessed 2026-04-24)). The product advertises "Guarded rollouts, AI Configs, Experimentation, and Observability" as its top-level feature areas (same source, accessed 2026-04-24). A more specific definitional page was not successfully fetched in this session; the primary-source treatment above is Hodgson's.

---

## 2. Progressive delivery

### Origin and definition

`[VERIFIED]` The term is associated with James Governor, co-founder of the analyst firm RedMonk. Direct fetch of the canonical RedMonk post `redmonk.com/jgovernor/2018/08/06/towards-progressive-delivery/` still returns HTTP 404 as of 2026-04-24, but the attribution to Governor (co-defined with Adam Zimman of LaunchDarkly in mid-2018) is documented by third-party contemporaneous coverage ([Industry Watch: What follows CD? Progressive delivery — SD Times](https://sdtimes.com/devops/industry-watch-what-follows-cd-progressive-delivery/) (accessed 2026-04-24), which states: "As defined by Redmonk analyst James Governor and Zimman in mid-2018, progressive delivery allows organizations to roll out changes while being mindful of the users' experience" and directly references Governor's August 2018 RedMonk post).

`[VERIFIED]` Governor is a co-author of the book *Progressive Delivery: Build the Right Thing for the Right People at the Right Time* (James Governor, Kimberly Harrison, Heidi Waterhouse, Adam Zimman; IT Revolution, 2025). The publisher-linked framework article confirms the "four A's" ([The Four A's: A Framework for Progressive Delivery — IT Revolution](https://itrevolution.com/articles/the-four-as-a-framework-for-progressive-delivery/) (accessed 2026-04-24)).

### The four A's — framework from the book

`[VERIFIED]` The IT Revolution framework article ([itrevolution.com](https://itrevolution.com/articles/the-four-as-a-framework-for-progressive-delivery/) (accessed 2026-04-24)) credits James Governor of RedMonk with coining "progressive delivery" and describes the Four A's framework:

1. **Abundance** — ample compute/bandwidth/storage resources, focused on developer experience.
2. **Autonomy** — "the ability of an individual to act independently from others."
3. **Alignment** — focusing organizational resources in one direction, centered on user experience.
4. **Automation** — programmatic processes for repetitive tasks.

The authors express progressive delivery as: **(Abundance × Autonomy) / (Alignment × Automation)** — numerator as developer experience, denominator as user-experience delivery.

### The simplest working reading

`[SYNTHESIS]` Progressive delivery = continuous delivery *plus* per-cohort control. Where continuous delivery is concerned with "can we ship safely?", progressive delivery is concerned with "who sees it and when?" The implementing primitives already exist: canary release ([Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html)) + feature flags ([Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html)) + dark launching ([Fowler, 2020](https://martinfowler.com/bliki/DarkLaunching.html)) + traffic-splitting infrastructure (Kubernetes, service mesh).

---

## 3. Release management — versioning and changelogs

### Semantic Versioning

`[VERIFIED]` Semantic Versioning 2.0.0 is authored by Tom Preston-Werner (GitHub co-founder); the specification states ([Semantic Versioning 2.0.0 — semver.org](https://semver.org/) (accessed 2026-04-24)):

> "A normal version number MUST take the form X.Y.Z where X, Y, and Z are non-negative integers"

And the core three rules verbatim:
> "Patch version Z (x.y.Z | x > 0) MUST be incremented if only backward compatible bug fixes are introduced"
>
> "Minor version Y (x.Y.z | x > 0) MUST be incremented if new, backward compatible functionality is introduced"
>
> "Major version X (X.y.z | X > 0) MUST be incremented if any backward incompatible changes are introduced"

> "Version 1.0.0 defines the public API"

The spec is published under Creative Commons CC BY 3.0 ([semver.org](https://semver.org/)).

`[SYNTHESIS]` The binding idea is that the version number is a contract with consumers of the API. If you are not yet committing to a stable API, stay on `0.y.z`; once you do, move to `1.0.0` and the rules above apply.

### Keep a Changelog

`[VERIFIED]` Created and maintained by Olivier Lacan; current specification is version 1.1.0 ([Keep a Changelog 1.1.0 — keepachangelog.com](https://keepachangelog.com/en/1.1.0/) (accessed 2026-04-24)).

Seven guiding principles (verbatim numbering from the spec):
1. "Changelogs are _for humans_, not machines."
2. "There should be an entry for every single version."
3. "The same types of changes should be grouped."
4. "Versions and sections should be linkable."
5. "The latest version comes first."
6. "The release date of each version is displayed."
7. Projects should indicate whether they follow Semantic Versioning.

Standard change categories:
- `Added` — new features
- `Changed` — modifications to existing functionality
- `Deprecated` — features slated for removal
- `Removed` — features that are now gone
- `Fixed` — bug corrections
- `Security` — vulnerability patches

Philosophy:
> "a changelog is a file which contains a curated, chronologically ordered list of notable changes for each version of a project."

Lacan argues this contrasts sharply with raw commit logs, which are "full of noise" ([Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/)).

### How SemVer and Keep a Changelog work together

`[SYNTHESIS]` Given the SemVer rules and the Keep a Changelog categories, there is a clean mapping:

- Anything in `Added` or an incompatible `Changed` / `Removed` → bumps MAJOR (if it breaks consumers) or MINOR.
- `Fixed` → PATCH.
- `Deprecated` → no version bump by itself; it signals the intent to remove in a future MAJOR.
- `Security` → PATCH when backward compatible, MINOR or MAJOR otherwise.

This mapping is not given verbatim in either spec; it is a `[SYNTHESIS]` of the two.

### Release notes

`[SYNTHESIS]` The fetched sources do not define a standard format for user-facing release notes distinct from the internal changelog; in practice teams either publish the changelog directly (common for libraries) or curate a summary from it for end users (common for products). Both `semver.org` and `keepachangelog.com` stop at the internal artifact.

---

## Open questions

- **Calendar versioning (CalVer).** Not covered by SemVer or Keep a Changelog; used by projects like Ubuntu (YY.MM) and Python packaging. No primary source fetched this session.
- **Conventional Commits.** A commit-message specification that automates CHANGELOG generation; frequently paired with SemVer. Not fetched this session.
- **Progressive-delivery 2018 primary text.** The original RedMonk post (`/jgovernor/2018/08/06/towards-progressive-delivery/`) still returns 404 on direct fetch in the 2026-04-24 verification pass. Attribution upgraded to `[VERIFIED]` using contemporaneous coverage (SD Times, 2018) and the IT Revolution framework article for the four A's. A verbatim primary quote from the 2018 post would require an accessible archive.
- **LaunchDarkly definitional page.** Product documentation home page did not surface a single primary definition of "feature flag" suitable for quoting; the definitional anchor in this file remains Hodgson's article.

## Sources

- [Feature Toggles — Pete Hodgson, 2017](https://martinfowler.com/articles/feature-toggles.html) (accessed 2026-04-24)
- [Feature Toggle — Martin Fowler bliki, 2010/2016/2023](https://martinfowler.com/bliki/FeatureToggle.html) (accessed 2026-04-24)
- [LaunchDarkly Docs home](https://launchdarkly.com/docs/home) (accessed 2026-04-24)
- [Semantic Versioning 2.0.0 — semver.org](https://semver.org/) (accessed 2026-04-24)
- [Keep a Changelog 1.1.0 — keepachangelog.com](https://keepachangelog.com/en/1.1.0/) (accessed 2026-04-24)
- [Canary Release — Danilo Sato, 2014](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24)
- [Dark Launching — Martin Fowler, 2020](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24)
- [Industry Watch: What follows CD? Progressive delivery — SD Times, 2018](https://sdtimes.com/devops/industry-watch-what-follows-cd-progressive-delivery/) (accessed 2026-04-24)
- [The Four A's: A Framework for Progressive Delivery — IT Revolution](https://itrevolution.com/articles/the-four-as-a-framework-for-progressive-delivery/) (accessed 2026-04-24)
- [Progressive Delivery (book) — Simon & Schuster](https://www.simonandschuster.com/books/Progressive-Delivery/James-Governor/9781950508976) (noted via search; not fetched)
- Canonical RedMonk 2018 post `https://redmonk.com/jgovernor/2018/08/06/towards-progressive-delivery/` returned HTTP 404 on direct WebFetch 2026-04-24.
