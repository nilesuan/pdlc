---
id: LESSON-0042
date: 2026-09-20
trigger: xv-rejected
phases: [02.5, 04, 05]
keywords: [only, sole, the only trace, cited to, mis-cited, wrong clause, absence, uniqueness, search, negative claim]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, standards/process/LEARNING.md]
status: candidate
---

**Provenance.** Sofaoke, third /solve run, D3's line-timing check, 2026-09-20. Two of 27
audit findings were REJECTED by the cross-verifier, and both failed the same way:

1. QA-D3AUD-11 said "the only trace of this is <one field>". False - `provenance.json`
   carried a dedicated block for it and `record_must_say` carried an entry.
2. ARCH-D3AUD-10 said a figure travelled "cited to B1.1", implying B1.1 did not contain it.
   B1.1 does contain it, at md:985-998, and acting on the recommended re-citation would
   have introduced an error into the record.

Both auditors had been briefed, in writing, with the existing rule that an absence claim
must state the search that would have found it. Both stated searches for their other
findings. Neither applied it here.

## What went wrong

The rule did not fire because neither claim looks like an absence claim. "The only trace is
X" reads as a positive statement about X. "It is cited to the wrong clause" reads as a
critique of a citation. Both are in fact claims about everywhere else: that no other trace
exists, and that the cited clause does not contain the thing. Each needed a search over the
corpus it was implicitly quantifying over, and neither got one.

## Why it happened (root cause)

A self-check keyed to the surface form of a claim only catches claims in that form. An
auditor asking "am I claiming something is absent?" answers no, honestly, while writing a
sentence whose truth depends entirely on an absence. The existing rule was not ignored; it
was not recognised as applying.

## The general shape, which is worth more than the instance

By the end of that run six defects shared one form: **a mechanism whose failure looks
exactly like the answer it was asked for.** Five were searches that could not find - a
mangled argument list, a pattern that skipped names containing digits, a listing scoped to
the wrong subtree, a moving target. One was a summary built from the wrong list, which
omitted a block. A grep with a wrong pattern returns nothing, and "nothing" is a valid
answer. An omitted block looks like a block with nothing in it.

In every case the output was well-formed and indistinguishable from the true case. That is
why reading it more carefully never helps, why a second reviewer looking at the same output
does not help either, and why the only defence is a **positive control**: something the
same mechanism, run the same way, is known to find. A search that returns zero and has
never been shown to return anything is not evidence of absence; it is evidence of nothing
at all.

**One remedy covers the whole family, and a second reader is not it.** An inert check, a
false zero and a correct answer to the wrong question are the same defect wearing three
faces, and the obvious defence - have someone else look - fails on all three, because what
they look at is the well-formed output. The ancestry error proved it: one agent made the
inference, a second reproduced it while independently checking, because the fact was true,
the command was plausible and the output was indistinguishable from the true case. What
worked, every time, was a **control that must come out differently**: the same search run
against something it is known to find, the same mutation applied to something the guard must
catch, the same command pointed at a file that does differ. If the control comes out the
same as the subject, the mechanism is not discriminating and its answer means nothing,
whoever reads it.

The habit that catches it at the reporting boundary is cheap: **state the question a check
answers in the same breath as its result.** "Ancestry says not an ancestor" invites the next
question; "verified" does not. Two claims in one day were reported as verified when what had
been verified was their inputs - the figures inside a sentence, the ancestry behind a
collision - and both would have reached a decision-maker.

The near-miss is the one to remember. The summary defect would have omitted a required
block from the final record if the run had stopped a few songs earlier, and it would have
shipped as an absence - a section quietly not there, in a document whose every present
number was correct.

## How to prevent it

Treat **only**, **sole**, **the single**, **no other**, **nowhere else**, **cited to** and
**mis-cited** as absence markers, and give each the same search an explicit absence claim
gets. The operational test is to ask what would have to be true *everywhere you did not
look* for the sentence to hold: if the answer is "nothing else like this exists" or "that
place does not contain it", the sentence is an absence claim wearing a positive face. A
recommendation built on one is worse than the claim, because acting on it writes a new
error into the record - which is exactly what the second of these would have done.
