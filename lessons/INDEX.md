# INDEX.md — Lesson index

This file is the index the pass-runner reads before pass 1 to load matched lessons into sub-agent briefs. The authoritative rules for what a lesson is, when to record one, how it is structured, and when it retires live in [`../standards/process/LEARNING.md`](../standards/process/LEARNING.md). The table below is the loader's input — a lesson not listed here is not in the loop.

## Active

| ID | Date | Trigger | Phases | Keywords | Status | Title |
|---|---|---|---|---|---|---|
| LESSON-0001 | 2026-06-18 | user-correction | 04, 05 | worktree, subagent, background, fan-out, isolation, permission | active | Writing sub-agents get a non-blocking write posture, and every wait on their output gets a deadline |
| LESSON-0002 | 2026-06-12 | xv-rejected | 01 | verbatim-quote, fabricated-quote, spliced-quote, paraphrase-as-verbatim, interpolated-parenthetical, miscited-source, one-quote-one-source, byte-identical, SOURCES-array, corroboration, cross-verifier | active | Verbatim-quote integrity: a quote must appear verbatim on its single cited source |
| LESSON-0003 | 2026-07-20 | user-correction | 05, 07 | mcp, 404, plane, community-edition, endpoint-gap, partial-failure, bridged-server, workspace-slug, permissions, discovery-tool, hardcoded-id, bearer, x-api-key, auth-header | active | A partial 404 across tools on one server and credential is an endpoint gap, not an auth, slug, or permission problem |
| LESSON-0004 | 2026-08-16 | xv-rejected | 02, 03 | design-claim, cited_excerpt, cross-reference, tracked-not-resolved, split, evidence-source | active | A finding asserting a change must cite the artifact that changed, not the source that motivated it |
| LESSON-0005 | 2026-08-21 | audit-finding | 04, 05, 07 | inert-control, silent-failure, unfired-hook, config-validation, dead-guard, self-verification, drift, permission-rule, path-mismatch, tag-pattern, gate | active | A control that can fail silently must have a test that makes it speak |
| LESSON-0007 | 2026-08-21 | audit-finding | 04, 05 | css, selector, stylesheet, scope, styling, jsdom, visual-regression, screenshot, appearance, narrowing, mutation-testing, deploy-watcher, gh-run-list | active | Verify a selector on every screen it reaches, not only the one it was written for |

## Retired

| ID | Date | Retired | Retired-reason | Title |
|---|---|---|---|---|
