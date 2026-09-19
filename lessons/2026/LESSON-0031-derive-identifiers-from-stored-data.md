---
id: LESSON-0031
date: 2026-09-19
trigger: xv-rejected
phases: [02.5, 05]
keywords: [label, listening, Art Track, manifest, pairs-r4.json, owner_view, prose-drift, run-record, which-upload, range]
related-rules: [lessons/2026/LESSON-0018-candidate.md, lessons/2026/LESSON-0019-candidate.md, standards/EVIDENCE.md, agents/cross-verifier.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 pass 5, half C, Sofaoke `song-processing`, 2026-09-19. `REJECTED` on `D5R4X-LABEL-01`. Vote in that project's `cdocs/.pipeline-solve/pass5/xv-C.yaml`.

## What went wrong

A finding listed three uploads whose labels only listening could settle, and asked someone to listen to them. Two of the three did not match the run's stored outputs:

- It said both missed real re-upload pairs were "one Art Track" of a song. The manifest shows two Art Tracks (both 174 s), which match each other, each paired with one official video (177 s). The upload the two misses share is the official video, so the listening request named the wrong upload. The prose record had the same inversion ("the Art Track, 174 s, against official uploads of 177 s"), and the finding repeated it.
- It said karaoke and instrumental uploads "sit 6 to 57 dB lower" in vocal level, as the reason one karaoke-titled upload seemed to keep its lead vocal. The finding's own cited evidence gave 0.86 to 57.23 dB, and 29 of 251 stored pairs sit under 6 dB, some karaoke-titled uploads at 0.90 dB.

## Why it happened (root cause)

The finding was written from the prose record and a rounded summary, not re-derived from the pairs file and the manifest. Nothing checked which upload two pairs have in common, or whether a range written into the claim still matched the range in the evidence line below it. A claim about "which upload" reads the same whether the roles are right or reversed, so the reversal survived review.

## How to prevent it (the rule)

**Before a finding names an upload, a pair or a range, derive it from the stored pairs and manifest, not from the record's prose: for "both X share Y", print the pairs and the upload they have in common. Every range in the claim must equal the range in its own evidence, or the claim must say why it differs.**

## Verification

- The cross-verifier joins each named upload or pair with `pairs-*.json` and the manifest, and checks that a shared upload is shared.
- Any range in a claim that is narrower than the range its own evidence prints is a rejection, not a downgrade.
- The category that should fall to zero: findings asking for a manual check (listening, re-labelling) on an upload the stored outputs do not implicate.
