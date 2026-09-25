---
id: LESSON-0010
date: 2026-09-14
trigger: xv-rejected
phases: [02.5, 03]
keywords: [evidence-table, selection-adr, source-column, bundled-claim, multi-fact-row, tier-1, licence, constraints.md, decision-register, citation-coverage]
related-rules: [standards/docs/TECH_SELECTION.md, standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0004-citation-to-claim-mismatch.md]
status: candidate
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 3 (Handoff), Sofaoke `song-processing`, 2026-09-14. Verdict `ADR-0004-EV-10` in `solutions/song-processing/xv-pass3.yaml` (worktree `agent-a8afdab2afe77758e`).

## What went wrong

A selection ADR's Evidence table put four licence facts in one Tier 1 row and cited one source for all of them: "Chromaprint LGPL-2.1, audfprint MIT, Panako AGPL-3.0 clean for unmodified local use; AcoustID's web service non-commercial only | 1 | constraints.md" (`docs/adr/0004-recording-matching.md`). `constraints.md` states three of the four: Chromaprint LGPL-2.1, Panako AGPL-3.0 for unmodified local use, and AcoustID "free for non-commercial use only". It never mentions audfprint; a case-insensitive search for `audf`, `landmark` and `dpwe` returns nothing. audfprint's MIT licence is recorded in `decision-register.md` (D5 shortlist) and in the D5 spike record's Candidates field, and the row cites neither. The fact is true, but the row cannot be audited from its own Source column.

A milder case of the same shape sat in ADR-0001. "All three candidates, the runner and the judge are MIT-licensed" cites a weights table that does not list the runner, though the same record states the runner's licence in another section.

## Why it happened (root cause)

The Source column was chosen for the row as a whole. Most of the row's facts shared one source, so that source was attached to all of them, and nothing checked each fact in a bundled row against the text of the source it names.

## How to prevent it (the rule)

For every Evidence row that states more than one fact, confirm each fact appears in at least one of the sources named in that row before finalizing the table; add the missing source or split the row.

## Verification

- For each multi-fact Evidence row, search each cited source for each subject the claim names (the product plus its licence, number or property). Every subject must be found in a cited source.
- The cross-verifier category that should drop to zero: "Evidence row whose cited sources do not mention one of its subjects".
- Related: LESSON-0004 (citing the motivating source instead of the artifact that changed) is the same family, a citation that does not contain the claim. Promotion review may merge them.
