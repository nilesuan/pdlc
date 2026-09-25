---
id: LESSON-0014
date: 2026-09-18
trigger: xv-rejected
phases: [02.5, 03]
keywords: [verbatim-copy, pre-registration, seal, sha256, gitignored-scratch, reproduction-claim, diff-before-asserting, registration-integrity, condensed-rendering]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, standards/frameworks/EXPERIMENTATION.md, agents/cross-verifier.md]
status: candidate
---

# "Verbatim copy" is a claim about bytes, and it must be diffed before it is written

**Provenance.** `/solve` Phase 02.5 Pass 2, slug `song-processing`, 2026-09-18.
Two spike records (D4 duet-part-splitting, D5 recording-matching) each carried the
sentence "This section is a **verbatim copy** of the sealed pre-registration file."
Neither section was one.

## What went wrong

A pre-registration was sealed by SHA-256 into a **gitignored** scratch file, and the
repository record reproduced it so a reader could audit the seal without that file.
The reproduction was described as verbatim. It was in fact a condensed, re-worded
rendering: sentences were tightened, table cells re-phrased, and in D5 an entire
registered section - the representative workload, carrying the 450 MB download
budget and the paced/resumable harvest constraints - was dropped. One registered
provenance requirement changed wording ("the binary's build path" became "the
binary's SHA-256"), and one qualifier was lost ("does not strictly beat C-dur **on
the primary metric**" became "does not strictly beat C-dur").

No threshold, tolerance band, disqualifier, decision floor, sample size or time-box
differed in substance - every one was checked and matched - so the registration's
integrity held. What failed was the mechanism by which a reader can *verify* that
it held.

Two sibling records in the same run did it correctly: D2 and D14 wrapped the sealed
text in `<!-- PREREG-BEGIN -->` / `<!-- PREREG-END -->` markers and published the
`awk | shasum -a 256` command that re-derives the seal from the repository file
alone. Both re-derived to the sealed hash on an independent run.

## Why it happened (root cause)

A hash proves a *file* is unchanged; it says nothing about whether a *second copy*
of that file's text is faithful. When the sealed artifact is gitignored, the
repository copy is the only thing most readers will ever see, so the reproduction
silently becomes the audit surface - while the hash that everyone trusts is
computed against a file the reader cannot open.

Prose reproduction also runs downhill toward editing. Re-typing a registration into
a narrative section invites the ordinary instincts of writing well: tighten, cut
repetition, drop a section that feels like setup. Every one of those instincts is
correct for prose and wrong for a sealed artifact, and nothing in the authoring step
distinguishes the two.

## How to prevent it (the rule)

Never write "verbatim copy" (or "byte-identical", "unchanged", "reproduced exactly")
of a sealed artifact without running the diff that proves it. Reproduce a sealed
pre-registration by delimiting it with machine-readable markers and publishing the
one-line command that re-derives its hash from the committed file alone; if the
reproduction is a summary rather than the bytes, call it a summary and say where the
sealed original lives.

## Verification

- For any record asserting a verbatim reproduction of a sealed artifact, the
  cross-verifier runs `diff` between the sealed file and the reproduced span, and
  the record's own re-derivation command, and confirms both.
- A record whose seal covers a gitignored file must carry an in-repository
  re-derivation path (delimiters plus the command), or the seal is auditable only
  by someone with the scratch tree.
- The finding category that should drop to zero: "reproduction asserted verbatim,
  observed re-worded or truncated."
