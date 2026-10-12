---
id: LESSON-0105
date: 2026-10-03
trigger: xv-rejected
phases: [02.5, 03, 08]
keywords: [proposed, pending, section heading, table row, status, scope, owner-action, registry, governing-heading]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A gap-audit finding (PLAT-14, Sofaoke repo) claimed a story's reference to an owner-action item as "proposed" was stale, because that same item is "a named row in epic-011 now" - reasoning that once an item has a defined row in the epic's registry, calling it "proposed" elsewhere must be outdated. The cross-verifier rejected it: the table the item's row sits in is itself headed "**Proposed additions, pending the orchestrator**" - the row being named and defined does not mean the item has moved past proposed status, because the section it lives in is the proposed-and-pending section. Nine other stories citing neighboring items in the same table all say "proposed" too, consistently with the table's own heading, which the finding did not check before concluding the one citing OA13 was the stale outlier.

## Why it happened (root cause)

"Named" and "accepted" were treated as synonyms. A registry row that gives an item a stable ID, a description and a source is necessary for that item to be tracked at all, but it says nothing about whether the item has cleared the stage the registry's own section heading announces it is still in. The finding read the row in isolation - confirming the ID exists and is "a named row" - without reading upward to the heading that scopes the table the row sits in, which is exactly the information that would have settled the status question the finding was trying to answer.

## How to prevent it (the rule)

Before filing a staleness finding whose evidence is "this item now has a defined entry [in a registry/table/catalogue]," read the heading or introductory sentence that scopes the table the entry sits in, and check whether every sibling row in that same table makes the same status claim the cited one does - a shared status across all siblings under one heading is evidence of a consistent convention, not a finding.

## Verification

- A finding whose only evidence for "no longer applies" is "it now has a row/entry" should drop to zero once this check is applied, because having an entry and having cleared the status that entry's governing heading announces are different claims.
- Check: before filing, did the finding read the heading or first sentence of the table/section the cited row belongs to, and the status word used by at least one sibling row under the same heading?
