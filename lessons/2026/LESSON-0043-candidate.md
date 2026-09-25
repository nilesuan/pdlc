---
id: LESSON-0043
date: 2026-09-20
trigger: registration-implementation-mismatch
phases: [02.5, 04, 05]
keywords: [registered, constant, budget, cap, target, limit, threshold, stopping rule, sealed, pre-registration, role, parameter]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md]
status: candidate
---

**Provenance.** Sofaoke, third /solve run, D3's line-timing check, 2026-09-20. The sealed
registration says, in three places, "studio uploads **until there are 16**" (A4.3, and the
Sample rows at lines 405 and 423 of the spike record), and its shortfall clause is
conditional on the committed list being exhausted. A later amendment says "Budget from about
**23** studio plus 4 live songs, **so that 17 can resolve**" - an estimate of how many to
attempt.

The harness declared `STUDIO_BUDGET = 23` and used it in `processing_set` to cap how many
deciding studio songs the run would attempt. The run stopped at 23 attempted with 13
resolved: three short of the registered stopping rule, with 42 of 70 list songs unused and
127 of 420 active minutes remaining. None of the three registered stopping conditions - 16
resolved, list exhausted, box spent - had been met. The run was then completed to its
registered condition, and the deviation recorded.

Two audit rounds, two cross-verification rounds and the orchestrator's own reviews all
passed over it. It was found by an audit of the written records, which asked what the
registration required rather than what the code did.

## What went wrong

A constant was named for the registration's number and used as a different kind of quantity.
23 is a budget - how many to attempt - and the code made it a limit on how far to go. Both
readings produce the same integer, so every check that compared values agreed. What needed
comparing was the **role**: a target, a budget, a cap, a floor and a bar can all be the same
number and are different rules.

## Why it happened (root cause)

The number matched, so nobody asked what it was for. A constant whose value traces cleanly
to the sealed text looks verified, and its name - `STUDIO_BUDGET` - preserved the link to
the registration while its use diverged from it. The orchestrator read the run header
showing `studio_budget: 23` on the first day and took the agreement of the number as the
agreement of the rule.

## The wider shape: a real number answering a question nobody asked

The same run produced two more of these, which is what makes it a shape rather than an
accident. Each number was arithmetically correct and each was not the quantity its use
required.

1. `STUDIO_BUDGET = 23` - a correct count of songs to attempt, used as a limit on how far
   to go. Budget against cap.
2. A crowding statistic quoted as "14 of 35", then "10 of 28", finally settled at "9 of 26".
   Every count was right about the set it counted; only the third set was the rows the claim
   actually rested on, the rest including runs that contribute no line to the result.
3. "27 synthetic tempo negatives, 27 refused" - a correct count of planted records, and not
   the number of independent observations. The 27 were three variants on nine songs, and
   records planted on one song share its stem, its onsets and its record, so they are nine
   clusters. The effective n is nine, and the figure reads far stronger than it is.

4. `git merge-base --is-ancestor <commit> origin/main` returning "not an ancestor", read as
   "this work is not in main". True and irrelevant: that repository takes work by squash
   only, so the merged commit has a new identity and the original is never an ancestor
   however completely its content arrived. The question was whether the CONTENT is in main,
   and its answer is `git diff origin/main <branch> -- <path>`, which was empty.

5. The human form, and the reason this lesson cannot be only about tools. When the ancestry
   error was corrected, the correction came with a cause attached - "you compared against a
   stale local main" - inferred from an unrelated incident earlier that day and never
   checked against the command actually run. The conclusion was right and the cause was
   invented. That is worse than offering no diagnosis, because the cause is what the next
   person acts on: anyone following it would have fetched, re-run the same ancestry test,
   got the same answer, and concluded the collision was real.

In all five the result survived review because reviewing a result means checking its value,
and the value was right. What needed checking was the question it answers.

The fourth is the one to remember, because it **propagated**: one agent made the inference,
a second checked it independently and reached the same wrong place, because the fact is true
and the command is plausible and the gap between the question asked and the question meant
is invisible in the output. The other three were each caught by someone who had not made
them. An error that survives independent checking is not an error of carelessness; it is a
question everyone in the room is answering the same wrong way.

## How to prevent it

Before a run, for every constant that traces to sealed text, quote the registering sentence
beside the line of code that uses it, and check the ROLE rather than the value. Ask what
happens at the boundary: if the run reached this number and the registered condition was not
yet met, would it stop? If the answer is yes and the registration says continue, the
constant is the wrong kind of thing whatever its value.

Then give every registered stopping condition a test that makes it fire - one per condition,
each constructed so that only that condition ends the run. A stopping rule nothing has ever
been seen to trigger is not a stopping rule; it is a comment. This is the same discipline as
making a check fail, applied to the parameters rather than the assertions.
