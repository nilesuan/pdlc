# PDLC — The Product Development Life Cycle for Software

A research-backed, opinionated guide for taking a software product from an idea to a running system with customers who love it — and keeping it healthy as you add features.

**Last updated:** 2026-04-24

---

## What's in this repository

This is a **research workspace**, not a code project. It contains two complementary bodies of work:

| Directory | Purpose | Style |
|---|---|---|
| [`research/`](research/) | What the software industry actually does — frameworks, standards, primary sources | **Descriptive.** Multiple competing approaches documented fairly, with citations. |
| [`handbook/`](handbook/) | A single opinionated path through those options, end-to-end | **Prescriptive.** One default for each decision. Every recommendation links back to the research that justifies it. |

Two more files govern how this workspace operates:

- [`VISION.md`](VISION.md) — the original goal of the project.
- [`CLAUDE.md`](CLAUDE.md) — the strict research rules: facts only, sources mandatory, explicit uncertainty tags, no fabrication. Read this before contributing.

If you disagree with a recommendation in the handbook, follow the "Why this works" link at the end of each chapter into the research, and pick differently. The handbook picks; the research explains.

---

## Where to start

**You want a prescription — just tell me what to do.**
Start at [`handbook/README.md`](handbook/README.md). Read Phase 01 → 08 in order. Each phase has a Goal / Duration / Done-when header and an exit checklist.

**You want evidence — show me the industry landscape first.**
Start at [`research/README.md`](research/README.md). The corpus is organized by the same eight stages as the handbook, plus an overview section covering PDLC vs SDLC, models (Waterfall / Agile / Lean / DevOps), and industry frameworks.

**You're debating a specific choice** (e.g., trunk-based vs Git Flow, test pyramid vs trophy, microservices vs monolith).
Use `research/` as a reference — search the relevant stage folder. Every contested choice is documented with sources on both sides.

---

## The eight phases

| # | Phase | Handbook | Research |
|---|---|---|---|
| 01 | **Discover** | [handbook/01-discover.md](handbook/01-discover.md) | [research/01-ideation/](research/01-ideation/) |
| 02 | **Plan** | [handbook/02-plan.md](handbook/02-plan.md) | [research/02-planning/](research/02-planning/) |
| 03 | **Design** | [handbook/03-design.md](handbook/03-design.md) | [research/03-design/](research/03-design/) |
| 04 | **Build** | [handbook/04-build.md](handbook/04-build.md) | [research/04-development/](research/04-development/) |
| 05 | **Test** | [handbook/05-test.md](handbook/05-test.md) | [research/05-testing/](research/05-testing/) |
| 06 | **Ship** | [handbook/06-ship.md](handbook/06-ship.md) | [research/06-release/](research/06-release/) |
| 07 | **Run** | [handbook/07-run.md](handbook/07-run.md) | [research/07-operations/](research/07-operations/) |
| 08 | **Evolve** | [handbook/08-evolve.md](handbook/08-evolve.md) | [research/08-maintenance/](research/08-maintenance/) |

The first trip through 01 → 08 is the "from idea to loved product" journey. Afterward, it's a continuous loop: 01 ↔ 08 forever.

---

## Scope

The handbook and research both target **modern web-based software products** (SaaS, web apps, API-first products) in the 2020s, built by teams of 2–20 to start, growing from early product through post-PMF. Cloud-native, Git, modern CI/CD.

The *principles* transfer to embedded firmware, safety-critical systems, or heavily regulated environments — but many *specifics* (release cadence, testing rigor, documentation formality) will not. Use this as a starting point and expect to diverge where your context demands it.

---

## How the research was produced

Every claim in `research/` is either:

- **[VERIFIED]** — cited to a primary source that was actually fetched and read during research, OR
- **[SYNTHESIS]** — explicitly labeled as the researcher's inference, with the reasoning shown, OR
- **[UNVERIFIED]** / **[CONTESTED]** / **[OUT OF DATE]** — explicitly flagged with the gap named.

The corpus went through three verification passes, each targeting specific open questions — standards, post-2024 sources, book-length primary sources, and attribution uncertainties. Unresolved gaps (paywalled standards, blocked URLs) are documented explicitly in [`research/README.md`](research/README.md) rather than papered over.

If you find a claim that looks fabricated, wrong, or out of date: that's a bug. The rules in [`CLAUDE.md`](CLAUDE.md) exist to prevent it.
