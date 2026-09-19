---
id: LESSON-0026
date: 2026-09-19
trigger: audit-finding
phases: [02.5, 03]
keywords: [absence-claim, relayed-claim, truncated-read, table-row, sealed-registration, pre-registration]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/EVIDENCE.md, lessons/2026/LESSON-0019-candidate.md]
status: active
---

**Provenance.** D2 round 5 of `/solve`, Pass 5, Sofaoke `song-processing`, 2026-09-19. The independent
pre-execution review's finding QA-D2R5-05 (`cdocs/.pipeline-solve/pass5/qa-d2r5-findings.yaml`) caught it
before any round-5 command; amendment R5-10 E of the D2 spike record corrects it. No result depended on it.

## What went wrong

A sealed registration said twice that a tool "ran no held-out item" in the previous round. The previous
round's record printed that tool's two held-out rows. The claim came from a relayed brief ("was not scored
on held-out"), and the author's check printed a fixed line range of the held-out table that stopped two lines
before those rows, saw no row for the tool, and treated the relayed claim as confirmed.

## Why it happened (root cause)

The check for an absent row was a window onto the file, not a search of it: a truncated print cannot show
absence, and a relayed claim read against it looked verified. Sealed registration text is not run through the
findings lint that catches unsearched absence claims.

## How to prevent it (the rule)

**An absence claim about a row, item or step is checked with a search over the whole file for the thing said
to be absent (`grep -n "<row key>" <file>`), and the command and its output are kept with the claim. Reading a
line range never establishes absence, and a relayed claim is checked the same way before it is sealed.**

## Verification

- A registration or finding that says a tool, row or step is absent carries a whole-file search for it.
- Before sealing, the author greps the sealed text for absence words ("no", "never", "none", "not run") and
  checks each against a pasted search.
- The category that should fall to zero: sealed statements of absence that a later review finds false.
