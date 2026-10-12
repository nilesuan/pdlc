---
id: LESSON-0073
date: 2026-09-27
trigger: audit-finding
phases: [03, 04]
keywords: [absence, truncated-read, read-limit, long-file, duplicated-pages, contract-review, LESSON-0072]
related-rules: [lessons/2026/LESSON-0072-candidate.md]
status: candidate
---

# A clause is absent only after the whole document was read

## What went wrong

A review of a job offer said the terms sheet had "no post-employment restraint at all" and told the
reader they could work anywhere after leaving. That absence was then listed as a benefit of the offer
and copied into memory. The terms sheet has a restraint clause on pages 7 to 9. The review was read
from a text copy in which every page appears three times, 3,451 lines in all. The restraint heading
first appears at line 2,156, and the review cites no clause after clause 12. The claim stood for two
days, until a re-read for a different question found the restraint.

## Why it happened (root cause)

The file reader returns the first 2,000 lines by default, and a partial result looks like a complete
one unless the line count is checked. The tripled pages made an 11-page document three times longer
than it looked, which pushed its last clauses past the limit. The review's tool calls were not
inspected, so this mechanism is inferred from the line numbers. A partial read supports every "has X"
claim within its reach. It also silently supports every "has no X" claim, which is why absence claims
are the exposed ones.

## How to prevent it (the rule)

Before saying a document lacks a clause, compare its total line count with what was read, then grep
the whole file for the clause's own words (restrain, compet, solicit), with a known-present clause as
the control.

## Verification

A review that says a contract has "no X" names the full-file grep it ran and the control term that
matched.
