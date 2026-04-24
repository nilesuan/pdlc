# The Software Product Handbook

A prescriptive, end-to-end guide for taking a software product from an idea to a running system with users who love it — and keeping it healthy as you add features.

**Last updated:** 2026-04-24

---

## How this handbook relates to the research

This repository contains two things:

- [`../research/`](../research/) — **descriptive**: what the software industry actually does, with verified sources. Multiple competing approaches are documented fairly.
- `./` (this handbook) — **prescriptive**: a single opinionated path through those options. The recommendations here are defensible — each phase ends with a "Why this works" section that links back to the specific research documents that justify the choices.

If you disagree with a recommendation, read the linked research and pick differently. The handbook picks; the research explains.

---

## Who this is for

This handbook is written for teams building a **modern web-based software product** (SaaS, web application, API-first product) in the 2020s. Specifically:

- **Team size:** 2–20 people at the start. Patterns still apply as you grow, but some ceremony scales up.
- **Stage:** early product to post-product-market-fit. The "running in production with customers who love it" end-state assumes you've found PMF.
- **Technology:** cloud-native, Git, modern CI/CD, public internet. Not for embedded firmware, regulated medical devices, or air-gapped enterprise environments — the *principles* transfer but many *specifics* don't.
- **Business model:** customers use the software over time (retention matters). Not one-shot consulting engagements.

If you're building something very different (console games, safety-critical systems, compliance-heavy fintech), use this as a starting point and expect to diverge on specifics like testing rigor, release cadence, and documentation formality.

---

## The 8 phases

| # | Phase | What you do | Primary output |
|---|---|---|---|
| 01 | [**Discover**](01-discover.md) | Find a problem worth solving and validate it | A sharp problem statement and evidence of demand |
| 02 | [**Plan**](02-plan.md) | Decide what to build first and how you'll measure success | Product strategy, MVP scope, OKRs |
| 03 | [**Design**](03-design.md) | Make the major technical and UX decisions | System architecture, key flows, ADRs |
| 04 | [**Build**](04-build.md) | Write the code, well | Working software in version control, reviewed and refactored |
| 05 | [**Test**](05-test.md) | Make sure it works and keeps working | Automated test suite and quality gates |
| 06 | [**Ship**](06-ship.md) | Get it to real users | Live production system with repeatable deployment |
| 07 | [**Run**](07-run.md) | Keep it reliably available | SLOs, observability, on-call, incident process |
| 08 | [**Evolve**](08-evolve.md) | Learn what to build next and keep the system healthy | Working feedback loops, controlled tech debt, sustainable delivery |

**Phases are not strictly sequential.** In reality they overlap and loop. You'll discover new problems while running the system (Phase 1 inside Phase 7). You'll change architecture after launch (Phase 3 inside Phase 8). The numbering is for clarity, not for gating.

The handbook treats the first trip through Phase 01 → 08 as the "from idea to loved product" journey, and then Phase 01 ↔ 08 continuously thereafter.

---

## Before you start: foundations

Before Phase 01, make sure these foundations are in place. They are not optional and are cheap to set up early.

### 1. Team — the minimum viable team

You need three functions covered, even if one person wears multiple hats:

- **Product** — someone accountable for what to build and why. In a small team this is often a founder. Eventually a Product Manager.
- **Design** — someone accountable for how users experience the product. At small scale, a generalist designer or a design-aware PM can cover.
- **Engineering** — people who can build and operate the software. At minimum one senior engineer; ideally two so no one is single-threaded.

As you grow, specializations appear: backend engineer, frontend engineer, SRE, data, security. But the three functions above are what you must have on day one.

**Rule of thumb:** if there is no one person who is accountable for "is this the right product?" you will build the wrong thing. If there is no one accountable for "does it work in production at 3 a.m.?" you will have an outage with no owner.

**Full team-composition chapters:**
- [**The Lean Product Team**](00-team-lean.md) — the 4-seat lean baseline (2–20 people). Detailed seat descriptions, phase ownership, cadence, hiring ladder.
- [**The Full Product Team**](00-team-full.md) — the fully-staffed organization (30–200+ people). Stream-aligned squads, platform/SRE/security/data functions, leadership layer, ratios, transition path from lean.

### 2. Operating principles

Adopt these as team norms up-front. They inform every decision downstream.

- **Product, not project.** You are not building a thing and handing it off. You are building a system you will keep running and evolving. Every decision should assume the system exists for years.
- **Outcomes, not output.** You are trying to change customer behavior and business metrics, not to ship a list of features. When the list and the outcome conflict, pick the outcome.
- **Small and continuous beats big and rare.** Small changes, shipped often, are safer and faster than large batches. This applies to code, design, planning, everything.
- **Evidence over opinion.** When the team disagrees, reach for data — user interviews, A/B tests, production metrics. Opinions lose to evidence.
- **Reversible decisions cheaply, irreversible decisions carefully.** Most decisions are reversible. Move fast on those. For the few that aren't (database choice, core architecture, naming a public API), slow down.
- **Blameless by default.** When something breaks — code, process, release — focus on how the system allowed it, not who did it. This is not about being nice; it's about learning faster.
- **Write it down.** Decisions made verbally evaporate. Decisions written down (ADRs, design docs, postmortems) compound.

### 3. Baseline tooling

Set these up before you write the first feature. All are cheap or free at small scale; all pay for themselves within weeks.

- **Source control:** Git, hosted on GitHub / GitLab / similar.
- **Issue tracking:** Linear, GitHub Issues, Jira — whatever your team will actually use.
- **CI/CD:** GitHub Actions, GitLab CI, CircleCI. Wire it up before the code needs it.
- **Cloud provider:** AWS, GCP, Azure, or Vercel/Railway/Fly for early stage. Don't run your own hardware.
- **Error tracking:** Sentry, Honeycomb, Datadog, or similar. Know when something breaks.
- **Analytics:** something lightweight (Plausible, PostHog, or the native provider of your cloud).
- **Secret management:** never in Git. Use your cloud's secret manager or 1Password/Doppler.
- **Chat + docs:** Slack/Discord for chat, Notion/Confluence/a repo `/docs` folder for long-lived docs.

One concrete anti-pattern to avoid: deferring CI until "we have more code." Set it up on day one with a trivial test. Momentum compounds; so do habits.

---

## How to use this handbook

**For a new product from scratch:** read Phase 01 → 08 in order once, then start executing. Expect to revisit each phase continuously.

**For an existing product:** jump to the phase you're weakest in. Each phase is readable standalone.

**As a reference:** each phase has a table of contents and a concise checklist at the end. Use the checklists when you're about to start a new feature, a new hire, or a new cycle.

**When you disagree:** follow the "Why this works" link at the bottom of each phase into the research. If the research is thin on your specific context, use the handbook's advice as a default and adjust.

---

## Conventions used in this handbook

- **Concrete recommendations** are stated directly ("Use trunk-based development"). When the industry genuinely debates something, alternatives are named.
- **Checklists** at the end of each phase summarize the "must do" items.
- **Anti-patterns** flag common mistakes.
- **Scale notes** call out where the advice changes as the team or product grows (e.g., "at < 10 engineers, skip this; at > 50, it's mandatory").
- Every phase ends with a **Why this works** section that links back to the relevant `../research/` documents.
