# CLAUDE.md — Research Rules (PDLC)

This repository is a **research workspace**, not a code project. The goal is to document the industry-grade Product Development Life Cycle for software (ideation → production → maintenance → iteration). See `VISION.md`.

The output of this research will be used to make real decisions. **Accuracy is the only thing that matters.** A short, verified document beats a long, plausible one. Speed is irrelevant; correctness is everything.

These rules are non-negotiable. Re-read them at the start of every session.

---

## 1. Core Principles (read first, every time)

1. **Facts only.** Every claim in `research/` must be either (a) directly cited to a verifiable source, or (b) explicitly labeled as synthesis/inference with the reasoning shown.
2. **Never fabricate.** Do not invent statistics, framework names, company practices, author names, dates, quotes, URLs, study titles, or version numbers. If you cannot find it, say so.
3. **Never assume.** If something is unclear, ambiguous, or underspecified, do more research — or write "Unknown" / "Not verified." Assumptions silently become facts; do not allow it.
4. **When in doubt, stop.** Do not write the sentence. Research the point, or mark it explicitly as unverified.
5. **Sources are mandatory.** No claim ships without a source — or an explicit `[UNVERIFIED]` tag.
6. **Verify before citing.** Read the source before citing it. Do not cite a URL you have not actually fetched and read in this session.

---

## 2. Anti-Hallucination Rules

These are the failure modes to actively guard against:

- **Plausible-but-fake citations.** Do not cite books, papers, articles, or specs unless you have fetched them or can point to a real, accessible URL. "Fowler wrote about this" is not allowed unless you found the specific Fowler piece and link it.
- **Plausible-but-fake numbers.** No statistics, percentages, survey results, or "studies show…" without a fetched source and the methodology noted. If a number sounds reasonable, that is not evidence it is real.
- **Plausible-but-fake frameworks.** Do not name methodologies, ceremonies, roles, or stages unless they are documented in a real source. "The 5 stages of X" must come from somewhere specific.
- **Composite memories.** Do not blend several half-remembered sources into a single confident claim. Each claim → one (or more) specific, verifiable source.
- **Authority laundering.** "Industry standard," "widely used," "most teams" are claims that need evidence (surveys, reports, multiple primary sources). Do not use these phrases to dodge sourcing.
- **Date drift.** Practices and tools change. Note the date of every source. Prefer sources from the last 3 years for tooling/practice claims; older sources are fine for foundational concepts but flag the age.
- **Self-citation.** Do not cite content generated earlier in the session as if it were a source. Synthesis can build on prior synthesis, but the underlying facts must trace back to external evidence.

If you catch yourself writing something you "just know" — stop and verify. Training data is not a source.

---

## 3. Source Rules

### What counts as a source
- **Primary (preferred):** official documentation (e.g., Scrum Guide, IEEE/ISO standards, NIST SP, OWASP), vendor docs (GitHub, GitLab, AWS, Atlassian), peer-reviewed research, books with authors and editions, reports from named organizations (DORA/Google, Stack Overflow Developer Survey, State of DevOps), conference talks with speaker + venue + year.
- **Secondary (acceptable with care):** reputable engineering blogs from named companies (Google, Netflix, Stripe, Shopify engineering blogs), Martin Fowler's site, ThoughtWorks Tech Radar, named-author posts on InfoQ / IEEE Software.
- **Weak (use sparingly, flag explicitly):** Wikipedia (use for orientation, then chase its citations), Medium posts (only if author has verifiable expertise), aggregator sites.
- **Not allowed as primary evidence:** AI-generated content, SEO content farms, undated blog posts, anonymous Stack Overflow answers, marketing pages making unsupported claims, ChatGPT/Claude/etc. screenshots.

### How to cite
Every claim that is not common knowledge gets an inline citation. Format:

```
Claim. [Source Title — Author/Org, Year](URL) (accessed YYYY-MM-DD)
```

Each research document ends with a **Sources** section listing every URL fetched, with access date. If a source is paywalled or behind login, note that.

### When sources disagree
Document the disagreement. Do not pick a winner silently. Format:
> **Note:** Source A says X (link). Source B says Y (link). Difference appears to stem from [reason / unknown].

---

## 4. Uncertainty & Honesty

Use these tags explicitly in research documents — do not bury uncertainty in soft language.

- `[VERIFIED]` — claim is directly supported by a fetched source cited inline.
- `[SYNTHESIS]` — claim is your inference combining multiple cited sources. Show the sources and the reasoning.
- `[UNVERIFIED]` — claim is included for completeness but no source was found. Must be flagged; reader needs to know.
- `[CONTESTED]` — sources disagree; both views documented.
- `[OUT OF DATE]` — source exists but is older than ~3 years and the area moves quickly.

If a section would be mostly `[UNVERIFIED]`, do not write it. Either research further or omit.

Forbidden hedges that hide uncertainty: "generally," "typically," "most teams," "it is well known that," "industry standard," "best practice" — unless backed by a specific cited source that uses the same framing.

---

## 5. Research Workflow

For each topic / PDLC stage:

1. **Scope the question.** Write the specific question being researched at the top of the document. Vague questions produce vague answers.
2. **Find primary sources first.** Start with standards bodies, official guides, and named-author canonical works. Use search to locate them; fetch and read them.
3. **Read before quoting.** Use `WebFetch` / `WebSearch` to actually retrieve the page. Do not cite a URL you have only seen referenced elsewhere. If a fetch fails, note the failure rather than guessing the contents.
4. **Cross-reference.** A claim is stronger with multiple independent sources. For any load-bearing claim (e.g., "the standard stages are X"), find at least 2 independent sources or mark as `[SYNTHESIS]`.
5. **Take notes verbatim where it matters.** For definitions, stage names, and precise terms, quote the source exactly. Paraphrase only when the meaning is preserved and is clearly the author's view.
6. **Record what you searched and what you found.** Each research file should include a `## Methodology` section listing search queries used and sources consulted (including ones rejected and why).
7. **Re-read your draft against the sources.** Before saving, verify every cited claim is actually in its source. Hallucinated citations of real URLs are a common failure mode.

---

## 6. Writing Rules

- **No filler.** Do not pad with generic introductions ("In today's fast-paced software industry…"). Get to the verified content.
- **Specific over general.** "Google's DORA report (2023) measured X" beats "studies have shown."
- **Show the reasoning.** When synthesizing, write the inference chain so a reader can audit it.
- **Distinguish description from prescription.** "Scrum defines X" (descriptive, citable) is different from "teams should do X" (prescriptive, opinion). Do not slide between them.
- **Match the source's confidence.** If a source says "some teams," do not upgrade it to "teams." If it says "may," do not write "will."
- **No emojis. No marketing tone.** This is technical research.

---

## 7. Output Structure

All research outputs go into `research/`. Suggested layout (create as needed; do not over-engineer up front):

```
research/
  README.md                  — index of research documents and current status
  00-overview/               — what PDLC is, scope of this research
  01-ideation/               — discovery, problem validation, requirements
  02-planning/               — roadmaps, prioritization, estimation
  03-design/                 — architecture, UX, technical design
  04-development/            — coding practices, version control, code review
  05-testing/                — testing strategies, QA
  06-release/                — CI/CD, deployment, release management
  07-operations/             — monitoring, incident response, SRE
  08-maintenance/            — support, iteration, deprecation
  sources/                   — saved copies / notes from key references
```

Each document should include:
- **Question:** what this document answers.
- **Status:** Draft / Reviewed / Verified.
- **Last updated:** YYYY-MM-DD.
- **Body** with inline citations and uncertainty tags.
- **Sources** section.
- **Open questions** — what is still unverified or unknown.

Do not write code in this repo unless the user explicitly asks.

---

## 8. Self-Check Before Saving

Before writing any research file to disk, verify:

- [ ] Every factual claim has an inline citation OR an `[UNVERIFIED]` / `[SYNTHESIS]` tag.
- [ ] Every cited URL was actually fetched and read in this session.
- [ ] No invented authors, books, statistics, or framework names.
- [ ] Numbers and dates match the source exactly.
- [ ] Disagreements between sources are documented, not hidden.
- [ ] Uncertainty is explicit, not hedged.
- [ ] Sources section lists every URL with access date.
- [ ] Open questions section captures what remains unverified.

If any box cannot be checked, fix it or remove the affected content.

---

## 9. When to Ask the User

Ask, do not guess, when:
- A topic could mean very different things (e.g., "release process" — for SaaS web app vs. mobile app vs. embedded firmware).
- Scope is unclear (depth, audience, target organization size).
- Sources conflict in ways that change the conclusion meaningfully.

Do not ask for things you can find through research. The bias is: research first, ask only when research cannot resolve it.
