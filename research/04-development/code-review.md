# Code Review, Pair Programming, and Mob Programming

**Question:** What are the accepted practices for code review, pair programming, and mob programming, and what do the primary sources (Google engineering practices, XP, Woody Zuill) say about them?

**Status:** Draft

**Last updated:** 2026-04-24

## 1. Google's code review practices

Google publishes its internal engineering practices at [google.github.io/eng-practices](https://google.github.io/eng-practices/review/), including a three-part code-review guide: an introductory overview, "How To Do A Code Review" (reviewer guide), and "The CL Author's Guide" [VERIFIED]. [Google Engineering Practices — Code Review](https://google.github.io/eng-practices/review/) (accessed 2026-04-24).

### The review standard

Google's **code review standard** page states [VERIFIED]:

> "Reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn't perfect."

Principles pulled from the page:

- Progress matters; stalled CLs prevent codebase improvement.
- Quality matters; reviewers prevent code-health degradation.
- Polish is secondary — minor stylistic concerns should be marked "Nit:" rather than blocking approval.
- Technical merit decides; factual evidence and design principles override personal preferences.
- When multiple valid approaches exist and the author justifies their choice, the reviewer defers.

[Code Review Standard — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/standard.html) (accessed 2026-04-24).

### What reviewers look at

Google's reviewer guide enumerates eight dimensions reviewers evaluate: design, functionality, complexity, testing, naming, comments, style, and documentation updates [VERIFIED]. [Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) (accessed 2026-04-24).

### Speed of review

Google's speed guidance is specific [VERIFIED]: reviewers should respond "shortly after receiving them if not in focused work"; the maximum acceptable response time is **one business day** (ideally by the next morning); a typical CL should get multiple rounds of review within a single day if needed. Google also notes that developers in the middle of focused work should wait for a natural break rather than context-switch immediately — the distinction is between quick *responses* (expected) and quick *completion* (not always achievable). [Speed of Code Reviews — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/speed.html) (accessed 2026-04-24).

### Writing review comments

Google's guidance on comment tone [VERIFIED]: comments should be kind, address the code not the developer, explain reasoning, label severity ("Nit:", "Optional:", "FYI:"), and if code needs explanation in the review tool the developer should rewrite the code more clearly instead. Positive feedback on good work is also encouraged. [How to Write Code Review Comments — Google](https://google.github.io/eng-practices/review/reviewer/comments.html) (accessed 2026-04-24).

### Small CLs

Google's CL Author's guide dedicates a page to small CLs with specific size guidance [VERIFIED]:

- A small CL is "one self-contained change" addressing just one thing.
- ~100 lines is typically reasonable; ~1000 lines is usually too large.
- Number of files matters too — 200 lines across 50 files is different from 200 lines in one file.
- Reviewers can reject a CL solely for being oversized.

Benefits listed: faster reviews, more thorough review, reduced bug risk, less wasted effort if rejected, easier merging and rollbacks, better code quality, and the author can work on other CLs while awaiting review. [Small CLs — Google Engineering Practices](https://google.github.io/eng-practices/review/developer/small-cls.html) (accessed 2026-04-24).

## 2. Pair programming

Pair programming is defined by the Agile Alliance as two programmers sharing a single workstation — one screen, keyboard, and mouse — with both actively engaged in the coding task simultaneously [VERIFIED]. [Pair Programming — Agile Alliance Glossary](https://www.agilealliance.org/glossary/pair-programming/) (accessed 2026-04-24).

### Driver-Navigator pattern

Two roles, per the Agile Alliance [VERIFIED]:

- **Driver** — the programmer at the keyboard actively writing code.
- **Navigator** — the other programmer focusing on overall direction while remaining actively involved.

Developers are expected to "swap roles every few minutes or so."

### History

The Agile Alliance entry states the practice predates the modern Agile movement [VERIFIED]:

- 1992 — Larry Constantine coined "Dynamic Duo" at Whitesmiths Inc.
- 1995 — Jim Coplien described "Developing in Pairs" in pattern form.
- 1998 — Pair programming emerged as a core practice in Extreme Programming (XP).
- 2000 — The Driver and Navigator roles were formally introduced and named.

The fetched source notes pair programming is an "original twelve practice" in XP and that the exact originator remains uncertain.

> **Source-availability note.** I attempted to fetch `extremeprogramming.org/rules/pair.html` (the canonical XP rules page) three times via `http`, `https`, and `www` prefixes; all returned TLS or connection errors in this session. The Kent Beck XP origin claim is therefore based on the Agile Alliance glossary above, which itself names XP as the context of formalization.

## 3. Mob programming

Mob programming extends pair programming to the whole team: multiple developers work together on a single machine at the same time. The term is most associated with Woody Zuill.

[VERIFIED] The canonical Zuill tagline appears verbatim on mobprogramming.org:

> "All the brilliant people working on the same thing, at the same time, in the same space, and on the same computer."

([Mob Programming — mobprogramming.org](https://mobprogramming.org/) (accessed 2026-04-24)). The site is maintained by Zuill and hosts the mob-programming conference announcements.

[VERIFIED — as the literal content] The page at `woodyzuill.com/mob-programming/` is a placeholder ("This is a placeholder for a simple introduction to Mob Programming"); substantive content and the canonical phrasing live at mobprogramming.org. [Mob Programming placeholder — Woody Zuill](https://woodyzuill.com/mob-programming/) (accessed 2026-04-24).

Specific rotation rules (typist/timer/driver/rotation interval) are documented in Zuill & Meadows' LeanPub book *Mob Programming: A Whole Team Approach* (not fetched in this session).

## 4. DORA on code review

DORA's capabilities catalog and the trunk-based-development capability page tie code review practices to delivery performance [VERIFIED]. Specifically, the TBD page says heavyweight review processes and asynchronous reviews are obstacles to high-performing delivery, and recommends "synchronous code reviews" at merge time rather than long asynchronous cycles. [DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) (accessed 2026-04-24).

DORA also names "streamlining change approval" as one of its core capabilities. [DORA capabilities](https://dora.dev/capabilities/) (accessed 2026-04-24).

## 5. Bacchelli & Bird — "Expectations, Outcomes, and Challenges of Modern Code Review" (ICSE 2013)

Alberto Bacchelli and Christian Bird published this paper at the 35th International Conference on Software Engineering (ICSE 2013). The Microsoft Research landing page confirms authorship, venue, and year: [Expectations, Outcomes, and Challenges of Modern Code Review — Microsoft Research](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/) (accessed 2026-04-24). [VERIFIED — abstract]

The study methodology (per the Microsoft Research abstract) used observations, interviews, and surveys of developers and managers at Microsoft, plus manual classification of hundreds of review comments across diverse teams [VERIFIED via abstract].

Key findings, quoted / paraphrased from the Microsoft Research abstract:

- "Finding defects remains the main motivation for review" — i.e., developers still expect reviews to catch bugs. [VERIFIED]
- In practice, "reviews are less about defects than expected" and instead deliver benefits including knowledge transfer, increased team awareness, and the creation of alternative solutions to problems. [VERIFIED]
- "Code and change understanding" is identified as the key aspect of code reviewing; developers use a range of mechanisms to reach that understanding, "most of which are not met by current tools." [VERIFIED]

The Microsoft Research PDF itself was fetched but WebFetch returned binary PDF bytes rather than parsed text, so specific numeric results (e.g., exact sample sizes, comment classification percentages) remain `[UNVERIFIED]` from the primary PDF this session.

## 6. Other claims not verified this session

- SmartBear's white-paper claims (e.g. the "200-400 lines per hour" figure often attributed to Cisco/SmartBear's 2006 study) were **not fetched**. [UNVERIFIED].
- Phabricator (Phacility) shut down commercial support in 2021; Gerrit's origin at Google for Android is widely stated. Neither was fetched from a primary source this session — omitted rather than asserted.

## Sources

- [Expectations, Outcomes, and Challenges of Modern Code Review — Bacchelli & Bird, ICSE 2013 (Microsoft Research landing page)](https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/) (accessed 2026-04-24; abstract)
- [Google Engineering Practices — Code Review overview](https://google.github.io/eng-practices/review/) (accessed 2026-04-24)
- [Code Review Standard — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/standard.html) (accessed 2026-04-24)
- [Speed of Code Reviews — Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/speed.html) (accessed 2026-04-24)
- [How to Write Code Review Comments — Google](https://google.github.io/eng-practices/review/reviewer/comments.html) (accessed 2026-04-24)
- [Small CLs — Google Engineering Practices](https://google.github.io/eng-practices/review/developer/small-cls.html) (accessed 2026-04-24)
- [Pair Programming — Agile Alliance Glossary](https://www.agilealliance.org/glossary/pair-programming/) (accessed 2026-04-24)
- [Mob Programming — mobprogramming.org (Woody Zuill)](https://mobprogramming.org/) (accessed 2026-04-24)
- [Mob Programming placeholder — woodyzuill.com](https://woodyzuill.com/mob-programming/) (accessed 2026-04-24)
- [DORA — Trunk-Based Development capability](https://dora.dev/capabilities/trunk-based-development/) (accessed 2026-04-24)
- [DORA capabilities](https://dora.dev/capabilities/) (accessed 2026-04-24)

## Open questions

- Canonical XP pair-programming page (`extremeprogramming.org`) failed TLS in this session; needs re-attempt.
- Bacchelli & Bird 2013 landing-page abstract was fetched this session; full PDF text remained unparseable via WebFetch. Specific numeric results inside the paper still need extraction from a parseable copy.
- SmartBear's review-rate numbers were not verified; need the original PDF.
- Is there a DORA finding on code review speed (hours vs. days) separate from the TBD capability page? Not found this session.
- Zuill & Meadows' *Mob Programming: A Whole Team Approach* book itself (LeanPub) was not fetched; the canonical one-line definition is verified via mobprogramming.org. Rotation-rule specifics (e.g., 10-minute driver intervals) remain outside the verified content.
