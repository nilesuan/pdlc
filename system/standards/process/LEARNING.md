# LEARNING.md — Learn-from-mistakes loop

**Authoritative sources:** [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) (retrospectives, Kerth's Prime Directive, PDCA, Toyota Kata); [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §§6–9; [`../../../research/07-operations/incident-response.md`](../../../research/07-operations/incident-response.md) (Allspaw blameless postmortems).

## What this standard is for

The system records every mistake the moment it is detected. Each mistake becomes a durable **lesson** stored under `system/lessons/`. Before each command run, the orchestrator loads the lesson index and includes matched lessons in the sub-agent brief so the same failure does not recur. Lessons are blameless (Kerth's Prime Directive); the focus is the rule that prevents recurrence, not the agent that erred.

## What counts as a mistake

Five concrete triggers. Each fires the lesson-capture step:

1. **`cross-verifier` `REJECTED` vote.** Per [`../../agents/cross-verifier.md`](../../agents/cross-verifier.md) and [`../../standards/EVIDENCE.md`](../../standards/EVIDENCE.md), a `REJECTED` vote means the cited evidence does not exist or does not support the claim. The finding is dropped; the failure mode is captured.
2. **Pre-output gate broken link.** Per [`../../agents/pass-runner.md`](../../agents/pass-runner.md) §"Pre-output gate (layer 6)" and [`../../standards/ANTI_HALLUCINATION.md`](../../standards/ANTI_HALLUCINATION.md), a `broken_links ≥ 1` result from `scripts/verify-artifact.sh` is a `PRE-OUT-LINK-01` blocker. Captured.
3. **Auto-rejected finding.** Per [`../../standards/EVIDENCE.md`](../../standards/EVIDENCE.md) §"Auto-rejection triggers", findings that fail evidence validation are dropped and deducted. Captured.
4. **User correction.** The user explicitly says the system was wrong (a citation is fabricated, a path is invented, a rule was misapplied). Captured.
5. **Post-mortem from a failed pass.** A pass that exceeded `max_passes` without resolution per [`../../agents/pass-runner.md`](../../agents/pass-runner.md) §"Termination". The unresolved finding is itself the lesson signal.

## When to record

**Immediately on detection.** "Later" is when lessons evaporate. The pass-runner records lesson candidates as part of its post-pass routine; the cross-verifier writes a candidate stub when it casts a `REJECTED` vote; the user correction is captured by the orchestrator the moment it arrives.

This is the operational expression of Kerth's discipline applied to system self-correction: the mechanism for not repeating the failure is recording the failure mode while it is still concrete, not at a distant retrospective when memory has compressed it. [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §6).

## Where lessons live

```
system/lessons/
  INDEX.md                              — table of all lessons (active + retired)
  README.md                             — how-to-add and naming conventions
  <YYYY>/                               — calendar-year shard
    LESSON-NNNN-<slug>.md               — one file per lesson
    LESSON-NNNN-<slug>-candidate.md     — pre-promotion stub awaiting user review
```

`NNNN` is a zero-padded sequence per year, starting at `0001`. The slug is a short kebab-case description of the failure mode (`broken-handbook-link`, `fabricated-fowler-quote`).

## Lesson file structure

YAML frontmatter plus four sections. Blameless framing throughout — describe the failure mode, not the agent.

```markdown
---
id: LESSON-NNNN
date: YYYY-MM-DD
trigger: xv-rejected | broken-link | auto-rejected | user-correction | failed-pass
phases: [01, 03, 06]            # PDLC phase numbers the failure mode applies to
keywords: [feature-flag, ADR, terraform-plan]
related-rules: [standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: active                   # active | retired
retired: YYYY-MM-DD              # only present when status: retired
retired-reason: "<one line>"     # only present when status: retired
---

## What went wrong

One paragraph naming the failure mode. Specific. No agent attribution.

## Why it happened (root cause)

The mechanism that produced the failure. Not "the agent forgot" — what structural gap let the agent reach a wrong output without being stopped.

## How to prevent it (the rule)

The single sentence the orchestrator includes in future briefs. Imperative voice. Specific enough to be checkable.

## Verification

How we know the lesson is being applied. A check the next pass-runner can run, or a finding category that should drop.
```

The Prime Directive applies to authorship: "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand." [The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §6). Lesson text describes the failure mode; it does not name the agent that erred.

## Loading lessons

Before pass 1, the pass-runner reads `system/lessons/INDEX.md`, matches each active lesson's `keywords` against the brief, and includes the body of every matched lesson in every sub-agent brief.

Match rule: **case-insensitive substring on whole tokens**. The keyword `trigger-index.json` matches a brief containing the literal token `trigger-index.json`; the keyword `flag` matches `feature flag` but not `flagrant`. This is the same rule the framework trigger registry uses (per [`../../agents/pass-runner.md`](../../agents/pass-runner.md) §"Trigger evaluation in detail"), so the loader is one mechanism shared by frameworks and lessons.

A matched lesson's full body (frontmatter + four sections) is inlined into the sub-agent brief. The sub-agent reads the rule from "How to prevent it" and applies it as if it were any other standard.

## Retiring lessons

A lesson is retired when **both**:

1. It has not triggered in ≥ 1 year (no new candidate stub mentions it; no finding category it covers has fired).
2. A structural change makes the failure mode impossible (a new gate in `scripts/verify-artifact.sh`, a new auto-rejection rule in `EVIDENCE.md`, a new framework spec).

Retirement is recorded in INDEX.md with `retired: YYYY-MM-DD` and a one-line reason. The lesson file's frontmatter is updated to `status: retired` with the same date and reason. The file is **not** deleted — retired lessons remain searchable so a regression can be diagnosed against the original failure mode.

The 1-year-and-structural-change criterion is deliberate: time alone does not prove a lesson is obsolete; only a structural change that closes the failure mode does. This is the operational counterpart to the Toyota Kata Improvement-Kata pattern — a lesson is the "obstacle" identified in current condition; retirement is allowed only when the structural change toward the target condition has actually shipped. [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §8).

## Why this is a learning loop, not a blame log

The structure mirrors three established practices:

- **Retrospectives (Kerth).** The Prime Directive forbids blame; the lesson file forbids agent attribution. The unit of work is the failure mode, not the actor. [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §6.
- **PDCA (Shewhart/Deming).** Plan-Do-Check-Act treats each correction as an experiment: the rule recorded in "How to prevent it" is the Plan; loading it into future briefs is the Do; the Verification section is the Check; retirement after structural change is the Act. [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §7.
- **Blameless postmortems (Allspaw).** Etsy's framing: an engineer "can give a detailed account… without fear of punishment or retribution." The system equivalent is that lesson capture happens automatically on detection; no human decides whether to record. [`../../../research/07-operations/incident-response.md`](../../../research/07-operations/incident-response.md).

These three practices converge on the same operational claim: the mechanism for not repeating a failure is recording the failure mode while it is still concrete, in a form that can be loaded back into future work.

## How `/evolve` encodes lesson hygiene

The `/evolve` quarterly audit ([`../../commands/evolve.md`](../../commands/evolve.md)) reviews the active lessons in `system/lessons/INDEX.md` and confirms any due for retirement (≥ 1 year inactive AND structural-change criterion met) are retired. Lessons are recorded continuously by the pass-runner; they are retired in the periodic review. The two halves of the loop close in different cadences and that is intentional — recording must be fast, retirement must be deliberate.

## Hard rules

1. **Record on detection, not later.** The pass-runner and cross-verifier write candidate stubs as part of their normal flow. A stub written "after the next pass" is a stub that does not exist.
2. **Candidates are reviewed, not auto-promoted.** A stub is `LESSON-<id>-candidate.md`; the user reviews and promotes it to `LESSON-<id>-<slug>.md`. Auto-promotion would let one bad correction become a permanent rule.
3. **Lessons are blameless.** No agent attribution. The rule is the artifact; the actor is irrelevant. [Kerth Prime Directive](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §6).
4. **Keywords are matchable, not aspirational.** A lesson with the keyword `everything` matches every brief and is therefore worthless. Keywords should be the specific tokens the failure mode actually involved.
5. **Retirement requires structural change.** A lesson does not retire because a year passed; it retires because the failure mode is now mechanically prevented. Otherwise the lesson is still earning its place.
6. **The index is the loader's input.** Lessons not in `INDEX.md` do not get loaded into briefs. A lesson file that exists on disk but is missing from the index is not in the loop.

## Anti-patterns to flag

- **"We'll write the lesson after the pass."** The pass ends, attention moves, the lesson never lands. Capture during the pass or never.
- **Lesson as blame.** "Agent X failed to verify Y." Wrong shape — the failure mode is "no evidence schema check before pass scoring," not the agent's name.
- **Vague keywords.** `bug`, `error`, `wrong`. Match nothing useful.
- **Lessons without a rule.** "What went wrong" filled in, "How to prevent it" empty. A lesson without a prevention rule is a complaint, not a lesson.
- **Retiring lessons by time alone.** A lesson dormant for 14 months is still a live rule if the failure mode is still mechanically possible.
- **Index without files / files without index.** Either half on its own is decorative; the loader requires both.

## Severity calibration

| Severity | Example |
|---|---|
| blocker | Pass-runner skipped lesson loading for a brief whose keywords match an active lesson; user correction recorded as a chat reply with no candidate stub |
| major | Candidate stub written but missing the prevention rule; lesson promoted without user review |
| minor | Keyword too vague to match the failing brief; retired lesson left without structural-change evidence |
| nit | Slug phrasing that names an agent rather than the failure mode |

## Sources

- Kerth, Norman L. *Project Retrospectives: A Handbook for Team Reviews*, Dorset House Publishing, 2001 (ISBN 978-0-932633-44-6) — Prime Directive and blameless framing. Verified via [Project Retrospectives — Dorset House Publishing](https://www.dorsethouse.com/books/pr.html) (accessed 2026-04-24) and [The Prime Directive — Retrospective Wiki](https://retrospectivewiki.org/index.php?title=The_Prime_Directive) (accessed 2026-04-24). Both citations carried through [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §6.
- PDCA cycle (Shewhart/Deming) — Plan-Do-Check-Act framing of correction-as-experiment. Verified via [PDCA — Wikipedia](https://en.wikipedia.org/wiki/PDCA) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §7).
- Rother, Mike. *Toyota Kata*, McGraw-Hill, 2009 — Improvement-Kata / Coaching-Kata patterns; "obstacle" framing for retirement criterion. Verified via [Toyota Kata — Wikipedia](https://en.wikipedia.org/wiki/Toyota_Kata) (accessed 2026-04-24, via [`../../../research/08-maintenance/feedback-loops.md`](../../../research/08-maintenance/feedback-loops.md) §8).
- Allspaw, John — blameless postmortem framing. Verified via [Learning from Failure at Etsy — Kitchen Soap, 2013](https://www.kitchensoap.com/2013/09/30/learning-from-failure-at-etsy/) (accessed 2026-04-24) and [Learning Effectively From Incidents: The Messy Details — IT Revolution](https://itrevolution.com/articles/learning-effectively-from-incidents-the-messy-details/) (accessed 2026-04-24). Both citations carried through [`../../../research/07-operations/incident-response.md`](../../../research/07-operations/incident-response.md).
- Handbook: [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) — retrospectives + continuous improvement framing.
- Related standard: [`../ANTI_HALLUCINATION.md`](../ANTI_HALLUCINATION.md) — defines the pre-output gate and the auto-rejection rules whose failures populate this lesson loop.
- Related agent: [`../../agents/cross-verifier.md`](../../agents/cross-verifier.md) — issuer of `REJECTED` votes that trigger lesson capture.
- Related agent: [`../../agents/pass-runner.md`](../../agents/pass-runner.md) — orchestrator that loads matched lessons into sub-agent briefs and writes candidate stubs after each pass.
- The mechanism of **automatic candidate-stub capture on detection**, the **keyword-matching loader**, and the **1-year-plus-structural-change retirement rule** are codifications adopted by this system. They are consistent with — but not literally cited in — the retrospective / PDCA / Kata literature surveyed above. [UNVERIFIED — flagged per [`../../../CLAUDE.md`](../../../CLAUDE.md) §2.]
