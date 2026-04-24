---
name: techstacks methodology
description: How the tech-stacks research was conducted, source hierarchy, and limitations
type: methodology
---

# Methodology

**Question:** How was this research conducted, what sources were consulted, and what are the limitations?
**Status:** Draft.
**Last updated:** 2026-04-24.

## Source hierarchy

The documents in this directory prefer sources in roughly this order:

1. **Industry surveys with disclosed methodology and large samples.** Stack Overflow Developer Survey (49,000+ respondents in 2025) [[Stack Overflow 2025 Technology](https://survey.stackoverflow.co/2025/technology/)], JetBrains State of Developer Ecosystem (23,262 respondents in 2024) [[JetBrains DevEco 2024](https://www.jetbrains.com/lp/devecosystem-2024/)], CNCF Annual Cloud Native Survey (750 respondents in 2024) [[CNCF 2024 Survey](https://www.cncf.io/reports/cncf-annual-survey-2024/)], State of JS 2024 (~12,964 respondents) [[State of JS 2024](https://2024.stateofjs.com/en-US)], State of CSS 2024 (~9,700 respondents) [[State of CSS 2024](https://2024.stateofcss.com/en-US)], DORA Accelerate State of DevOps (39,000+ respondents in 2024) [[DORA 2024](https://dora.dev/research/2024/dora-report/)].
2. **Official project, standards, and vendor documentation.** CNCF project pages, IETF RFCs, OpenID Foundation specs, cloud provider docs.
3. **Named-organization analyst data.** Synergy Research Group (cloud market sizing), GitHub Octoverse (GitHub repository activity), DB-Engines ranking (database popularity).
4. **Named-author technical writing on reputable engineering sites.** InfoQ, CSS-Tricks, ThoughtWorks Technology Radar, company engineering blogs.

SEO content, marketing pages without methodology, and undated blog posts were not used as load-bearing sources.

## How claims are tagged

Every claim in the documents is either backed by a source citation or one of:

- `[VERIFIED]` — directly supported by a fetched source cited inline.
- `[SYNTHESIS]` — inference combining multiple cited sources; the reasoning is shown.
- `[UNVERIFIED]` — no source was found; included only when the gap is worth flagging.
- `[CONTESTED]` — sources disagree; both views documented.
- `[OUT OF DATE]` — source older than ~3 years in a fast-moving area.

## Known limitations of the evidence base

These limitations apply to most of the downstream documents and are not repeated there:

- **Respondent skew.** Stack Overflow, JetBrains, State of JS, and State of CSS surveys are self-selected online panels. They over-represent web developers, English speakers, open-source contributors, and small/medium companies; they under-represent enterprise, regulated, embedded, and non-English-speaking developers. Treat percentages as directional for the *surveyed population*, not as a world census.
- **Survey population differs across sources.** Stack Overflow's "all respondents" pool (~49k in 2025) is not the same population as State of JS (~13k JavaScript-centric developers) or CNCF (~750 cloud-native practitioners). Direct percentage comparisons across surveys are usually invalid.
- **"Used in last year" vs "primary."** Most surveys ask about tools used in the past year — a developer who wrote one weekend Django project and spends 40 hours a week in Spring Boot counts in both totals. Percentages therefore sum to >100% and overstate breadth.
- **Vendor-sponsored surveys carry conflicts.** Confluent reports on Kafka adoption, JetBrains on CI/CD and IDE adoption, Datadog on observability, GitHub on code hosting. This is flagged inline where relevant; vendor-sponsored data is cross-referenced against independent sources wherever possible.
- **Rapid change in AI tooling.** The 2024/2025 surveys are already dated on AI-specific tooling; AI coding assistants, MCP, and agentic tooling moved substantially quarter-over-quarter. Claims in this area are flagged `[OUT OF DATE]` more aggressively.
- **Market-share figures for infrastructure differ across analysts.** Synergy Research, Canalys, Gartner, and IDC each report different percentages because they define the market differently (IaaS only, IaaS+PaaS, cloud services broadly). The documents name the analyst whose methodology was followed.

## What this research is not

- It is not a "best tool" recommendation. Popularity and network effects dominate choice in most categories; the most popular choice is not necessarily the best technical fit.
- It is not a comprehensive survey of every tool. It covers the choices that cross a meaningful adoption threshold in the cited surveys. Niche but credible alternatives are mentioned where relevant but not exhaustively enumerated.
- It is not stable. Each document notes the date of the sources consulted; tooling in several areas (AI, frontend meta-frameworks, IaC) is moving fast enough that these claims should be re-checked every 6–12 months.

## Process followed per document

1. Scope the specific question at the top of the document.
2. Identify primary sources first (standards bodies, official docs, large surveys).
3. Fetch each source and extract specific numbers/quotes — not summaries.
4. Cross-reference any load-bearing claim against at least one independent source.
5. Draft the document with inline citations next to each claim.
6. Re-read the draft and verify each cited claim is actually in its source.
7. List every URL consulted in the Sources section with access date.
8. List remaining gaps in the Open questions section.

## Sources (primary surveys referenced across documents)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology) (accessed 2026-04-24)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/) (accessed 2026-04-24)
- [JetBrains State of Developer Ecosystem 2024](https://www.jetbrains.com/lp/devecosystem-2024/) (accessed 2026-04-24)
- [JetBrains State of Developer Ecosystem 2024 — Blog](https://blog.jetbrains.com/team/2024/12/11/the-state-of-developer-ecosystem-2024-unveiling-current-developer-trends-the-unstoppable-rise-of-ai-adoption-leading-languages-and-impact-on-developer-experience/) (accessed 2026-04-24)
- [State of JavaScript 2024 — Front-end Frameworks](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/) (accessed 2026-04-24)
- [State of JavaScript 2024 — Meta-Frameworks](https://2024.stateofjs.com/en-US/libraries/meta-frameworks/) (accessed 2026-04-24)
- [State of CSS 2024 — Tools](https://2024.stateofcss.com/en-US/tools/) (accessed 2026-04-24)
- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/) (accessed 2026-04-24)
- [CNCF Annual Survey 2024 — "Cloud Native 2024"](https://www.cncf.io/reports/cncf-annual-survey-2024/) (accessed 2026-04-24)
- [CNCF Annual Cloud Native Survey 2025 — Announcement](https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/) (accessed 2026-04-24)
- [DORA Accelerate State of DevOps 2024](https://dora.dev/research/2024/dora-report/) (accessed 2026-04-24)
- [JetBrains State of CI/CD 2025](https://blog.jetbrains.com/teamcity/2025/10/the-state-of-cicd/) (accessed 2026-04-24)
- [Synergy Research — 2024 cloud market $330B](https://www.srgresearch.com/articles/cloud-market-jumped-to-330-billion-in-2024-genai-is-now-driving-half-of-the-growth) (accessed 2026-04-24)
- [DB-Engines Ranking](https://db-engines.com/en/ranking) (accessed 2026-04-24)
- [TIOBE Index](https://www.tiobe.com/tiobe-index/) (accessed 2026-04-24)
