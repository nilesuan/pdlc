---
id: LESSON-0107
date: 2026-10-03
trigger: xv-downgraded
phases: [02, 08]
keywords: [designed, decided, registered, not yet run, resolved, still open, staleness]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

## What went wrong

A gap-audit pass (Sofaoke repo, planning/v1 fresh read) filed four findings (RK-04, RK-05, CAD-01, RM-02) claiming a risk register or roadmap line was "stale" because a decision had since been made, and each proposed text that said the matter was now fully resolved. The cross-verifier downgraded all four for the same reason: the cited line was already accurate on a closer read, or the proposed fix overstated how resolved the matter was. "A design/decision exists" was repeatedly conflated with "the thing designed has been run, built, or confirmed." One mitigation line said a planted-fault check "proves" gate 5, when the check was registered but had not yet run; another said a duplicate's fate and an undo were "decided," which was true, but the fix text implied the open items around them (an unrun timing measurement, an unresolved BL-03.5) were also closed, when they were not.

## Why it happened (root cause)

A finding-writer treats "owed ADR/record now exists" and "the thing is finished" as the same fact, because both read as closing a gap in the same sentence of a source document. They are not the same: a design record can decide an approach while a measurement, a build, or a run that the design calls for still has not happened. The specific failure mode is scope creep inside one proposed fix - the writer correctly identifies that part of a multi-clause sentence is now stale, then rewrites the whole sentence as resolved, carrying the still-open neighboring clauses along with it.

## How to prevent it (the rule)

When a finding claims a record now "decides," "designs," or "resolves" something a source still calls open, check whether the resolving record also confirms the downstream action (run, build, measurement) happened - a design is not evidence that its output exists. When a sentence has multiple clauses and only one is stale, rewrite only that clause; name explicitly which neighboring clauses stay open rather than letting the fix's new prose imply they closed too.

## Verification

- A finding citing a decision record should state separately whether the record's own text confirms the follow-on action ran, not just that the decision exists.
- A multi-clause fix should be checked clause-by-clause against the cross-verifier's re-read before any clause is marked resolved in the replacement text.
- The category that should fall toward zero: an `xv_downgraded` vote whose reason is "still open" or "not yet run" against a finding's "now resolved" framing.
