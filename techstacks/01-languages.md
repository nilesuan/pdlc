---
name: programming languages
description: Industry-standard programming languages, their adoption signals, and what drives their standing
type: research
---

# Programming languages

**Question:** Which programming languages are industry-standard in 2026, for what purposes, and what is the evidence for each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.

## Why this chapter exists separately

Languages underpin every other chapter, but "most popular language" means very different things depending on how you count. Three widely cited rankings use three different methodologies and give three different answers. Before trusting any single number, it helps to understand what each ranking actually measures.

| Ranking | What it measures | Sample / method |
|---|---|---|
| Stack Overflow Developer Survey | Self-reported "used in the past year" | 49,000+ self-selected respondents globally (2025) [[SO 2025](https://survey.stackoverflow.co/2025/technology/)] |
| GitHub Octoverse | Repository and contribution activity on GitHub | All public activity on GitHub.com [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] |
| TIOBE Index | Search-engine results for "{language} programming" | Monthly web-search aggregation [[TIOBE](https://www.tiobe.com/tiobe-index/)] |

The three are not measuring the same thing; a language can lead one and trail another. They are complementary, not contradictory.

## Top languages across the three standard rankings

### Stack Overflow Developer Survey 2025 (used in past year, all respondents)

1. JavaScript — 66%
2. HTML/CSS — 61.9%
3. SQL — 58.6%
4. Python — 57.9%
5. Bash/Shell — 48.7%

Source: [[Stack Overflow 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24) [VERIFIED]

For comparison, Stack Overflow 2024 (60,171 respondents) had JavaScript 62.3%, HTML/CSS 52.9%, Python 51%, SQL 51%, TypeScript 38.5% [[Stack Overflow 2024](https://survey.stackoverflow.co/2024/technology)] (accessed 2026-04-24) [VERIFIED]. The year-over-year rise in every line is partly real growth and partly a change in respondent composition — the 2025 survey had fewer total respondents (49k vs 60k), so the pools are not directly comparable.

### GitHub Octoverse 2024 (repository activity)

1. **Python** — first place in 2024, overtaking JavaScript after a 10-year reign [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)]. Driven by the AI / data-science surge.
2. JavaScript
3. TypeScript — entered the top three in 2023, continued climbing in 2024
4. Java
5. C#
6. C++
7. PHP
8. Shell
9. C
10. Go

Octoverse reports JavaScript still leads in code pushes specifically; Python leads in overall activity (contributions, reviews, discussions). Fastest-growing languages in 2024 per Octoverse: Python, TypeScript, Go, HCL, Kotlin, Dart, Rust [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)] (accessed 2026-04-24) [VERIFIED].

### TIOBE Index (April 2026, web-search based)

1. Python — 20.97%
2. C — 12.34%
3. C++ — 8.03%
4. Java — 7.79%
5. C# — 5.98%
6. JavaScript — 3.11%
7. Visual Basic — 3.02%
8. SQL — 1.75%
9. R — 1.62%
10. Delphi/Object Pascal — 1.52%

Language of the Year: Python (2024), C# (2025). Source: [[TIOBE Index](https://www.tiobe.com/tiobe-index/)] (accessed 2026-04-24) [VERIFIED].

**Note on TIOBE:** TIOBE's methodology (search engine hits for "{X} programming") rewards languages with many beginners searching and tutorials written, which is why it ranks JavaScript lower than surveys of practicing developers do. It captures a different signal than Stack Overflow or Octoverse and should not be read as professional-developer usage. [SYNTHESIS based on TIOBE's own methodology note and the clear gap between TIOBE and survey data.]

## What "industry-standard" means for each language

These descriptions combine cited evidence (Stack Overflow usage, Octoverse activity, TIOBE) with clearly labeled synthesis from the same sources.

### JavaScript / TypeScript

**Standing:** The default language for the browser — there is no other executable language natively available on the web platform, so "JavaScript is standard for frontend" is near-tautological [VERIFIED, structural]. In the 2025 Stack Overflow survey, JavaScript was reported by 66% of respondents — the most-used language for the thirteenth consecutive year [[Stack Overflow 2025 Technology](https://survey.stackoverflow.co/2025/technology/)] (accessed 2026-04-24).

**TypeScript's rise:** TypeScript adoption went from 12% in 2017 to 35% in 2024 in the JetBrains DevEco survey [[JetBrains DevEco 2024](https://www.jetbrains.com/lp/devecosystem-2024/)]. In GitHub Octoverse, TypeScript entered the top three in 2023 and kept climbing in 2024 [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)]. TypeScript is today treated as the default for new production frontend and Node.js projects [SYNTHESIS based on the JetBrains and Octoverse evidence above plus the State of JS 2024 note that hybrid TypeScript-first frameworks are standard [[State of JS 2024](https://2024.stateofjs.com/en-US)]].

**Server-side via Node.js:** In Stack Overflow 2025, Node.js is the most-used "web framework/technology" at 48.7%, ahead of React (44.7%) [[Stack Overflow 2025](https://survey.stackoverflow.co/2025/technology/)].

### Python

**Standing:** Stack Overflow 2025 reports 57.9% usage, up from 51% in 2024 — the largest year-over-year jump of any major language [[SO 2024](https://survey.stackoverflow.co/2024/technology) → [SO 2025](https://survey.stackoverflow.co/2025/technology/)]. GitHub Octoverse 2024 ranks Python #1 by repository activity for the first time in 10 years [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)]. TIOBE has Python at 20.97%, first by a wide margin [[TIOBE](https://www.tiobe.com/tiobe-index/)].

**Why:** Every one of those sources attributes the acceleration to AI/ML and data-science workloads. Octoverse notes Jupyter Notebook usage rose 92% in 2024; Stack Overflow describes Python as "the go-to language for AI, data science, and back-end development" [[Stack Overflow 2025 Technology](https://survey.stackoverflow.co/2025/technology/)].

### Java

**Standing:** TIOBE April 2026 rank 4 at 7.79% [[TIOBE](https://www.tiobe.com/tiobe-index/)]. Stack Overflow 2024/2025 shows Java among the top ten used languages but slipping year over year [[SO 2025](https://survey.stackoverflow.co/2025/technology/)]. Java's niche is established: large-enterprise back-end systems, Android (though Kotlin now preferred for new Android code — see `04-mobile.md`), and regulated industries with long-lived codebases [SYNTHESIS from Stack Overflow 2024–2025 trend data and Octoverse's persistent top-5 Java ranking].

### C#

**Standing:** TIOBE 2025 Language of the Year [[TIOBE](https://www.tiobe.com/tiobe-index/)]. Stack Overflow 2024 lists .NET as the most-used "other framework/library" at 25.2% [[SO 2024](https://survey.stackoverflow.co/2024/technology)]. C#'s gains reflect modernization: cross-platform .NET (since .NET 5/6), strong tooling in VS Code + Visual Studio, Unity game development. [SYNTHESIS — the TIOBE gain is verifiable; the attribution to .NET modernization is inferred but consistent with the .NET usage data and widely discussed in the press cited by Stack Overflow.]

### Go

**Standing:** Octoverse 2024 lists Go in the top 10 by activity and among the fastest-growing languages [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)]. Stack Overflow 2024/2025 places it behind the top 10 by raw usage but with high admiration/desired scores. Go is the dominant language for new cloud-native infrastructure tooling: Docker, Kubernetes, Terraform, Prometheus, etcd, containerd, Istio are all written in Go [VERIFIED structurally — each of those projects' public repositories is primarily Go; see `06-orchestration.md`].

### Rust

**Standing:** Stack Overflow 2024: most-admired language for the second consecutive year with 83% admiration [[SO 2024](https://survey.stackoverflow.co/2024/technology)]. Octoverse 2024 lists Rust among the fastest-growing languages. Rust's industry standing is narrower than Python/JavaScript but rising: the Linux kernel ships an official Rust documentation tree at `Documentation/rust/` with Quick Start, Coding Guidelines, Architecture Support, and Testing sections [[Linux kernel docs — Rust](https://www.kernel.org/doc/html/latest/rust/index.html)] (accessed 2026-04-24) [VERIFIED]. Rust is preferred in systems-programming contexts where C/C++ would previously have been used and memory safety matters.

### C and C++

**Standing:** TIOBE rank 2 and 3 respectively [[TIOBE](https://www.tiobe.com/tiobe-index/)]. Stack Overflow 2024 ranks C++ in the top 10 used languages but substantially behind web languages. C/C++ remain industry-standard for operating systems, embedded, game engines (Unreal), high-performance computing, and the major database engines (PostgreSQL, MySQL are largely C) [SYNTHESIS — structural and widely documented; C's TIOBE rank is verified].

### Kotlin

**Standing:** The official Android developers site positions Kotlin as the primary language for Android development: "Kotlin is a modern statically typed programming language used by over 60% of professional Android developers," Android Studio provides "first-class support for Kotlin," and the "modern UI toolkit" (Jetpack Compose) is "built on Kotlin" [[Android developers — Kotlin](https://developer.android.com/kotlin)] (accessed 2026-04-24) [VERIFIED]. The page does not use the exact phrase "preferred language," but the positioning (usage share, tool support, Jetpack Compose's Kotlin-first architecture) is unambiguous. Octoverse 2024 lists Kotlin among the fastest-growing languages [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)]. See `04-mobile.md` for more detail.

### Swift

**Standing:** Apple's designated language for iOS/macOS/watchOS/tvOS development since its introduction in 2014. TIOBE April 2026 rank 19 at 0.92% [[TIOBE](https://www.tiobe.com/tiobe-index/)] — the small global share reflects that Swift is structurally tied to Apple platforms. Within Apple-platform development, Swift is the current industry standard; SwiftUI is the current UI framework. See `04-mobile.md`.

### SQL

**Standing:** Stack Overflow 2025 lists SQL at 58.6% usage — third overall [[SO 2025](https://survey.stackoverflow.co/2025/technology/)]. SQL is less a "programming language" and more a standardized query language across relational databases (ANSI/ISO/IEC 9075); the survey data is best read as "share of developers who touched a SQL database last year." Most vendor dialects extend the standard in incompatible ways — see `05-databases-data.md`.

### Bash / Shell

**Standing:** Stack Overflow 2025 places Bash/Shell at 48.7% usage [[SO 2025](https://survey.stackoverflow.co/2025/technology/)]. It is not a career language but a baseline competency across DevOps, CI/CD, and Linux operations.

### Languages that are not (yet) industry-standard but commonly discussed

- **Zig, Gleam, Elixir, Nim, V, Crystal, Roc, OCaml** — interesting, but none cross the adoption threshold in Stack Overflow, Octoverse, or TIOBE to count as "industry-standard." They appear in specialty or research contexts [SYNTHESIS from their absence or very low ranking in all three cited surveys].

## How to use this chapter

- The rest of the documents in this directory reference specific languages as the default for each domain (e.g., TypeScript for frontend, Go for infra tooling, Swift/Kotlin for native mobile). Those claims are supported by category-specific surveys, not by this general language ranking.
- A language being "industry-standard overall" does not mean it is the right choice for a given project. Choice is dominated by ecosystem fit, hiring market, and existing codebase.

## Sources (all fetched 2026-04-24)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
- [TIOBE Index (April 2026)](https://www.tiobe.com/tiobe-index/)
- [JetBrains State of Developer Ecosystem 2024](https://www.jetbrains.com/lp/devecosystem-2024/)
- [State of JavaScript 2024](https://2024.stateofjs.com/en-US)
- [Android developers — Kotlin](https://developer.android.com/kotlin)
- [Linux kernel docs — Rust integration](https://www.kernel.org/doc/html/latest/rust/index.html)

## Open questions

- Swift on server (Vapor, Hummingbird): anecdotal adoption; not verified with survey data.
- Whether JetBrains's 35% TypeScript figure is "used at all" or "primary" language — JetBrains's blog post mentions the 12→35% figure without clarifying which.
