---
id: LESSON-0066-candidate
date: 2026-09-25
trigger: auto-rejected
phases: [04, 05]
keywords: [new-finding, claim-scope, evidence-scope, overstatement, probe, headline, severity-anchor, scope-creep, cross-verifier]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md, lessons/2026/LESSON-0023-observation-and-cause-are-separate-claims.md]
status: candidate
source-run: cdocs/review-prbot-pr44-r2/lesson-candidate-1.md
---

**Provenance.** `/review` re-review of PR #44 on nilesuan/prbot (head 74843a1), 2026-09-25. Numbering is provisional: this run wrote to its own output directory rather than `lessons/2026/` because two other pass-runners (PRs #42 and #43) were re-reviewing concurrently; the caller assigns the real `LESSON-NNNN` when merging candidates from all three runs. Trigger is `auto-rejected` (SEC-NEW-02 fell below its severity's confidence floor after the cross-verifier's downgrade) and doubles as an instance of the `xv-downgraded >= 2 sharing a common root cause` trigger: 5 of this pass's 9 newly-filed findings were downgraded for the same reason, distinct from the 2 unrelated LESSON-0002 recurrences (CR-ADR-01, QA-COV-01) also seen this pass.

## What went wrong

Five of nine newly-filed findings (as opposed to the 26 closure verdicts checking previously-tracked findings against the code, which were far cleaner: 0 rejected, only 2 downgrades, both ordinary excerpt-fidelity slips) were downgraded because each finding's headline claim, confidence, or severity was pitched at the strongest defensible reading rather than the level the filer's own gathered evidence supported. A directory-listing-exposure claim said "a directory inside an excluded tree" when the probe pasted in the same finding showed only the *root* of an excluded tree passing the refusal check (`secrets/x` was still refused; `secrets` alone was not). A cost-estimate claim said "all tool-result text... unpriced" while its own cited excerpt showed read bodies specifically *are* priced (`read_tokens * tool_turns`) — only headers and echoed-path text were actually unpriced. A test-quality claim asserted a specific multiplier change "would break this test," which the cross-verifier disproved directly by changing the multiplier and re-running the suite (it still passed). An inference that four follow-up commits "demonstrate the author could have sliced" an oversized commit was stated as an established fact rather than a plausible reading. A flag-hygiene finding borrowed a severity anchor from FEATURE_FLAGS.md's table that is textually scoped to one flag category (Release) for a flag the same finding set had independently classified under a different, less-defined category (Experiment). In every case the underlying observation was real, the excerpt was genuine, and the filer had done real, often extensive, verification work (probes, greps, targeted test runs) — the gap was between what was checked and what was claimed about it.

## Why it happened (root cause)

Nothing distinguishes, at the moment a finding is drafted, between the scope of the search or probe actually run and the scope of the claim's wording. A probe that confirms one instance (the root of one excluded tree, one specific cost ratio at one turn count, one excerpt's own text) supports a claim scoped to that instance; broadening the wording to the general case costs nothing to write and reads as more impactful. No structural check compares claim scope against evidence scope the way LESSON-0002 compares an excerpt against its cited source, or the way EVIDENCE.md's schema requires a `why` field at all. This is a distinct failure mode from a fabricated citation (LESSON-0002: the excerpt itself is wrong) and from an unshown causal step (LESSON-0023: the claim asserts a cause not visible at the cited location) — here the citation is real and the excerpt is genuine, but the sentence built around it claims more than the citation demonstrates. It concentrated specifically in open-ended new-finding generation and not in closure verification of a previously-filed claim: checking one specific prior sentence against the current code gives the claim a narrow, pre-set target that limits room for scope creep, while discovering and wording a new finding does not.

## How to prevent it (the rule)

Before filing a new finding, state the claim at the exact scope the evidence block demonstrates — name the specific instance(s) actually probed, not the general category it belongs to — and before using a broader-sounding word ("a directory", "all X", "would break", "demonstrates"), test whether the cited probe or excerpt was actually run against that broader case; if it wasn't, narrow the claim or run the broader case first.

## Verification

- For each new (non-closure-verdict) finding whose evidence includes a probe, search, or test run, the cross-verifier re-runs the cited probe against at least one case adjacent to what was shown (a sibling path, a different turn count, the excerpt's own text read plainly) and checks whether the claim's scope words are still supported.
- The finding category that should fall to zero: a `DOWNGRADED` vote on a *new* finding whose own cited evidence, read plainly, supports a narrower claim, confidence, or severity than the one filed — distinguished in the vote reason from a `DOWNGRADED` vote on a *closure verdict* (which this pass shows is a different, lower-rate failure mode: 2 of 26, both ordinary LESSON-0002 excerpt slips, versus 5 of 9 new findings).
