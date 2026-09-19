---
id: LESSON-0038
date: 2026-09-19
trigger: xv-downgraded
phases: [02.5, 05]
keywords: [symmetrised, directional, similarity, fingerprint, both directions, audit, derived value, raw record]
related-rules: [standards/EVIDENCE.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md]
status: active
---

**Provenance.** Sofaoke, third /solve run, pass 3, D5 round 5's audit, 2026-09-19. The matcher's fingerprint arm (Panako) scores a pair in each direction, and the round's rule combines the two into one value. An auditor saw a combined value of 0.0 on three missed pairs and wrote, in two findings (QA-D5R5X-01 and -04), that each was "no match either way". The cross-verifier downgraded both: for one of the three, the synthetic +2% speed copy, the fingerprint matched in one direction at 0.91 and failed only in the other, so the miss came from the combining rule, not from a total failure to match.

## What went wrong

Two findings described the raw measurements from the derived value. "0.0 after combining" was read as "0.0 in both directions", and the cause of one miss was misstated.

## Why it happened (root cause)

The audit re-derived decisions from the stored combined similarities, which is what the verdict uses, and did not open the directed records one level down when it went on to say why each pair was missed.

## How to prevent it (the rule)

**When a finding explains a result, as opposed to re-deriving it, read the rawest stored record behind the value: for a symmetrised or combined score, open each direction's record and say which failed.** A derived value supports a claim about the decision, not about its inputs.

## Verification

- Every finding or record line that explains why a pair was decided as it was quotes the directed or raw values, not only the combined one.
- The category that should fall to zero: a cross-verifier downgrade because a combined value was described as if it were every raw value.
