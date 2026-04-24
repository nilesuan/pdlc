# Chaos Engineering and Production Testing

**Question:** What is the verified definition of chaos engineering, what production-testing techniques (canary, dark launch, A/B) exist, and where do they intersect?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Chaos engineering — the canonical definition

The Principles of Chaos document at principlesofchaos.org: "Chaos Engineering is the discipline of experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions in production." [VERIFIED] [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24).

The document lists four experimental steps:

1. Define 'steady state' as measurable system output indicating normal behavior.
2. Hypothesize that steady state continues in control and experimental groups.
3. Introduce variables reflecting real-world events (server crashes, network failures, etc.).
4. Attempt to disprove the hypothesis by observing differences between groups. [VERIFIED] [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24).

Five "advanced principles" guide ideal application:

1. **Hypothesis around steady-state behavior** — focus on measurable system output rather than internal attributes.
2. **Vary real-world events** — prioritize by impact or frequency (hardware failures, software failures, traffic spikes).
3. **Run experiments in production** — test on actual traffic and environments where systems operate.
4. **Automate experiments continuously** — build automation into systems for orchestration and analysis.
5. **Minimize blast radius** — contain and reduce negative customer impact from experiments. [VERIFIED] [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24).

The site lists "Last Updated: March 2019." No individual authors are credited on the page. [VERIFIED] [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24).

---

## Netflix's role — Chaos Monkey and the Simian Army

### The canonical 2011 blog post

The original Netflix tech blog post "The Netflix Simian Army" was published on July 19, 2011 by Yury Izrailevsky (Director of Cloud & Systems Infrastructure) and Ariel Tseitlin (Director of Cloud Solutions), and is mirrored at the Medium-hosted Netflix TechBlog ([The Netflix Simian Army — Netflix Technology Blog, 2011-07-19](https://netflixtechblog.com/the-netflix-simian-army-16e57fbab116) (accessed 2026-04-24)). Direct `WebFetch` returned a TLS error; `curl -k` resolved and retrieved the full post.

Verbatim description of each Simian, from the 2011 post ([Netflix Simian Army, 2011](https://netflixtechblog.com/the-netflix-simian-army-16e57fbab116) (accessed 2026-04-24)):

- **Chaos Monkey** — "a tool that randomly disables our production instances to make sure we can survive this common type of failure without any customer impact. The name comes from the idea of unleashing a wild monkey with a weapon in your data center (or cloud region) to randomly shoot down instances and chew through cables."
- **Latency Monkey** — "induces artificial delays in our RESTful client-server communication layer to simulate service degradation and measures if upstream services respond appropriately."
- **Conformity Monkey** — "finds instances that don't adhere to best-practices and shuts them down."
- **Doctor Monkey** — "taps into health checks that run on each instance as well as monitors other external signs of health (e.g. CPU load) to detect unhealthy instances."
- **Janitor Monkey** — "ensures that our cloud environment is running free of clutter and waste. It searches for unused resources and disposes of them."
- **Security Monkey** — "is an extension of Conformity Monkey. It finds security violations or vulnerabilities, such as improperly configured AWS security groups, and terminates the offending instances."
- **10–18 Monkey** — "(short for Localization-Internationalization, or l10n-i18n) detects configuration and run time problems in instances serving customers in multiple geographic regions, using different languages and character sets."
- **Chaos Gorilla** — "is similar to Chaos Monkey, but simulates an outage of an entire Amazon availability zone."

### Chaos Monkey authorship

Wikipedia attributes the 2011 invention of Chaos Monkey to "Netflix engineers Nora Jones, Casey Rosenthal, and Greg Orzell." [VERIFIED] [Chaos Monkey — Wikipedia](https://en.wikipedia.org/wiki/Chaos_Monkey) (accessed 2026-04-24). The 2011 Netflix blog post does not name the internal authors of Chaos Monkey; the attribution rests on Wikipedia for that claim.

Netflix released the code publicly in 2012 under Apache 2.0. The current GitHub repository at `github.com/netflix/chaosmonkey` shows v2.1.3 (January 6, 2025) with a Go implementation, requires Spinnaker, and supports AWS, GCE, Azure, Kubernetes, and Cloud Foundry. [VERIFIED] [Netflix Chaos Monkey — GitHub](https://github.com/netflix/chaosmonkey) (accessed 2026-04-24).

### Simian Army GitHub repo

The original wider suite repo at `github.com/Netflix/SimianArmy` is marked retired and no longer actively maintained; its functionality is distributed across Chaos Monkey (standalone service), Swabbie (replacing Janitor Monkey), and Spinnaker (replacing Conformity Monkey). [VERIFIED] ([Netflix SimianArmy — GitHub](https://github.com/Netflix/SimianArmy) (accessed 2026-04-24)).

### Chaos Kong

Chaos Kong (drops entire AWS regions) is named in Wikipedia but is *not* in the 2011 blog post — it was introduced later. [VERIFIED for existence via Wikipedia]; attribution-year not pinned in this pass. [Chaos Monkey — Wikipedia](https://en.wikipedia.org/wiki/Chaos_Monkey) (accessed 2026-04-24).

### Authors and book

Wikipedia identifies the original developers as "Nora Jones, Casey Rosenthal, and Greg Orzell." It further records that "Jones and Rosenthal co-authored the foundational *Chaos Engineering* book (O'Reilly Media, 2020)." [VERIFIED] [Chaos engineering — Wikipedia](https://en.wikipedia.org/wiki/Chaos_engineering) (accessed 2026-04-24).

The book itself is not fetched in this session; the citation here is to the Wikipedia entry that describes its authorship and publisher.

### Earlier precursors

Per the Wikipedia article on chaos engineering: Apple's Steve Capps created "Monkey" in 1983 (random UI events to expose bugs); Amazon developed "Game day" in 2003 (intentional failures to improve reliability). [VERIFIED] [Chaos engineering — Wikipedia](https://en.wikipedia.org/wiki/Chaos_engineering) (accessed 2026-04-24).

### Adoption beyond Netflix

Wikipedia names Google (DiRT), Facebook (Project Storm), and Steadybit as examples of the practice spreading beyond Netflix. [VERIFIED] [Chaos engineering — Wikipedia](https://en.wikipedia.org/wiki/Chaos_engineering) (accessed 2026-04-24). These organizational-program names are cited to Wikipedia only; I did not fetch primary engineering-blog posts for each.

---

## Canary release

### Definition

Martin Fowler: "Canary release is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure." [VERIFIED] [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24).

### What it is for

From the same source:

- Enables capacity testing in realistic production conditions with safe rollback.
- Provides early warning of problems before they affect the whole user base.
- Allows monitoring of metrics showing how the new version impacts the system.
- Serves as an alternative to maintaining separate testing environments. [VERIFIED] [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24).

### Rollout strategies

Fowler names several: random sampling, internal-employees-first, demographic targeting; partitioning by geography or business unit in distributed systems. [VERIFIED] [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24).

### Canary vs A/B

Fowler is explicit: "while canary releases and A/B testing share similar technical implementation, they serve different purposes — canary releases detect problems, while A/B testing validates hypotheses — and should not be conflated." [VERIFIED] [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24).

---

## Dark launching

### Definition

Fowler: dark launching is "taking a new or changed back-end behavior and calling it from existing users without the users being able to tell it's being called." The primary purpose is assessing load and performance impacts before public release. [VERIFIED] [DarkLaunching — Martin Fowler](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24).

### Illustrative example (from Fowler's entry)

Implementing product recommendations at checkout. The recommendation engine runs in production and performs all computations, but results remain hidden from users via the UI. Teams toggle the feature via feature flags if performance issues emerge. [VERIFIED] [DarkLaunching — Martin Fowler](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24).

### Techniques

Two concrete mechanisms:

- **Keystone Interface** — building the feature into production without user-facing components.
- **Feature Flags** — quick on/off switching to monitor real-world impacts. [VERIFIED] [DarkLaunching — Martin Fowler](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24).

### When to use which

Fowler's own criterion: dark launching works best for enhancements to existing user interactions that don't require user choice. For features dependent on user decisions, he recommends canary release instead. [VERIFIED] [DarkLaunching — Martin Fowler](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24).

---

## A/B testing

### Definition

Wikipedia: A/B testing (also called "bucket testing" or "split testing") is "a user-experience research method involving randomized experiments with typically two variants to determine which performs better." It "consists of a randomized experiment that usually involves two variants (A and B)." [VERIFIED] [A/B testing — Wikipedia](https://en.wikipedia.org/wiki/A/B_testing) (accessed 2026-04-24).

### Origins

The first randomized double-blind trial assessing drug effectiveness occurred in 1835; Claude Hopkins used promotional coupons for early campaign testing. Contemporary web A/B testing began with Google engineers running their first test in 2000 to optimize search results display. "By 2011, Google conducted over 7,000 different tests annually." [VERIFIED] [A/B testing — Wikipedia](https://en.wikipedia.org/wiki/A/B_testing) (accessed 2026-04-24).

### Use cases

From the Wikipedia article:

- E-commerce — copy, layouts, images, colors to reduce drop-off in purchase funnels.
- Social media — Facebook and LinkedIn for feature engagement.
- Product pricing — optimal price points for digital goods.
- Political campaigns — the 2008 Obama campaign tested website buttons and images.
- API deployment — routing percentages of HTTP traffic to newer backend versions while monitoring stability. [VERIFIED] [A/B testing — Wikipedia](https://en.wikipedia.org/wiki/A/B_testing) (accessed 2026-04-24).

### Where it sits relative to testing

[SYNTHESIS] Fowler draws the clean line: canary release detects problems; A/B testing validates hypotheses. They share infrastructure (traffic splitting, feature flags) but have different success criteria — canary "did it break?", A/B "did it convert better?" This is why A/B testing is usually discussed as product experimentation rather than a test-suite activity, even when it overlaps with production testing infrastructure. [VERIFIED] [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24).

---

## How the production-testing techniques relate

[SYNTHESIS from the Fowler and Wikipedia sources above]

| Technique | Question it answers | Primary mechanism | Visibility to users |
|---|---|---|---|
| Canary release | "Does the new build work in production?" | Traffic split to a subset | Users see the new behavior |
| Dark launch | "Can the system handle this code at real-world load?" | Run new code silently | Users do not see the behavior |
| A/B test | "Does variant B perform better than A?" | Randomized split with metrics | Users see one of N variants |
| Chaos experiment | "How does the system behave when X fails?" | Introduce controlled failure | Minimize user impact via blast radius |

All four use production or near-production infrastructure; they are complementary rather than substitutable.

---

## Sources

- [Principles of Chaos Engineering](https://principlesofchaos.org/) (accessed 2026-04-24)
- [Chaos engineering — Wikipedia](https://en.wikipedia.org/wiki/Chaos_engineering) (accessed 2026-04-24)
- [Chaos Monkey — Wikipedia](https://en.wikipedia.org/wiki/Chaos_Monkey) (accessed 2026-04-24)
- [Netflix Chaos Monkey — GitHub](https://github.com/netflix/chaosmonkey) (accessed 2026-04-24)
- [The Netflix Simian Army — Netflix Technology Blog, 2011-07-19](https://netflixtechblog.com/the-netflix-simian-army-16e57fbab116) (accessed 2026-04-24)
- [Netflix SimianArmy — GitHub](https://github.com/Netflix/SimianArmy) (accessed 2026-04-24)
- [CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html) (accessed 2026-04-24)
- [DarkLaunching — Martin Fowler](https://martinfowler.com/bliki/DarkLaunching.html) (accessed 2026-04-24)
- [A/B testing — Wikipedia](https://en.wikipedia.org/wiki/A/B_testing) (accessed 2026-04-24)

---

## Open questions

- [RESOLVED 2026-04-24] The Netflix tech blog post *The Netflix Simian Army* (July 19, 2011) — now cited directly at its Medium mirror with verbatim quotes for each Simian; authors confirmed as Yury Izrailevsky and Ariel Tseitlin.
- Rosenthal and Jones' *Chaos Engineering* (O'Reilly, 2020) is referenced through Wikipedia; a fetch of the O'Reilly landing page or a recognized excerpt would upgrade the source from secondary to primary.
- Netflix's internal Gameday programs (cited in multiple summaries) were not verified via a primary Netflix source.
- Google's DiRT and Facebook's Project Storm are named in Wikipedia but primary engineering-blog citations for each were not fetched.
