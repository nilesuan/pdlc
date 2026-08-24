# LESSON-0007 (candidate): a CSS selector broader than the component it was written for

**Detected:** 2026-08-21, Part Marks styling pass (PRs #248-#255).
**Class:** silent scope error. Not caught by any behavioural test.

## What happened

Three defects, one mistake, in a single stylesheet. Two reached production.

| # | selector | written for | also reached | shipped |
|---|---|---|---|---|
| 1 | `input { ... }` as a text field | text inputs | radios -> 44px empty circles | YES |
| 2 | `main fieldset label` as a choice row | `MCOptions` | `DiagramCapture` markers -> boxes inside boxes | no |
| 3 | `main section > p + p`, `p:last-child` | `ReadersCard` | marked practice card -> marker FEEDBACK as a muted footnote | YES |

A 564-test suite passed on all three. Every one was obvious in a screenshot.

## Why the tests could not catch it

Every existing check was behavioural. jsdom does not load the stylesheet, and the
deployed-edge spec cannot reach a marked attempt, so NOTHING in that repo applied
real CSS to real markup. Appearance failures were structurally invisible.

## The controls that worked

1. **Render the screens a change REACHES, not the one you edited.** Defect 2 was caught
   this way, pre-merge. Defect 1 shipped because only the edited screen was checked.
2. **After narrowing a selector, re-probe what it was meant to KEEP.** A narrowing is only
   safe if the retained case still matches. Verified MC rows kept `border 1px / radius 10px /
   flex` after scoping, and the readers card was unchanged after defect 3's fix.
3. **Make the unreachable state reachable rather than styling it blind.** Stubbing the graded
   `POST /api/attempt` in the local preview exposed all three defects in the reveal, including
   a WRONG answer wearing the affirmative treatment.
4. **Read the comment already in the file.** The tidier scope (`ul ~ p:last-child`) would have
   broken the empty-list case - the file's own comment said so.

## Second-order finding

Mutation testing killed TWO of my own new tests in this pass; both had passed for the
wrong reason. One omitted the prop that made the gate testable at all, which the file
had ALREADY warned about for that exact component. A new test is not evidence until a
mutation kills it.

## Also

A deploy watcher matched on `gh run list --branch main --limit 1`, which selected the CI
run rather than the deploy, and reported success while the deploy was still running - so a
verification ran early and its result was meaningless. Filter watchers by workflow NAME and
sha, never by recency.
