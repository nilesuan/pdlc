---
id: LESSON-0077
date: 2026-09-28
trigger: xv-downgraded
phases: [03]
keywords: [verbatim-quote, overreach, qualifier-dropped, inferred-claim, excerpt-does-not-carry-claim, factual-assertion, cited-page]
related-rules: [standards/EVIDENCE.md, lessons/2026/LESSON-0002-verbatim-quote-integrity.md, agents/cross-verifier.md]
status: candidate
---

# A verbatim excerpt is checked against the specific claim it is cited for, not only against the page it came from

## What went wrong

In one pass of a Sofaoke `/design` run, the cross-verifier downgraded three factual-assertion findings
(SEC-AUTH-03, SEC-AUTH-04, SEC-AUTH-05) from the same sub-agent for the same underlying reason, though each cited a
different URL. Each excerpt was byte-identical to real text on its cited page, so none was a fabricated or
mis-sourced quote in the sense LESSON-0002 already covers. What failed was narrower: the claim attached to the
quote said more than the quote itself supported. One excerpt was cited to show an ID token is absent from a
documented response, but the word "id_token" never appears on that page at all, so the excerpt's true support was
weaker than "shows it's absent". Another excerpt was cut a few words before a qualifying clause that materially
changed what the sentence was saying. A third combined a verbatim quote with a claim ("only they get this check")
that the page never states and that is only a plausible reading of it.

## Why it happened (root cause)

The finding-writing agent verified that the excerpt field would pass a literal string search against the source,
which is the check LESSON-0002 established, and treated that as sufficient. It is necessary but not sufficient: a
real, verbatim excerpt can still be quoted in support of a claim that requires either more of the surrounding text
(a qualifier a few words further on) or an inferential step the source does not itself take. No check compared the
claim sentence against the excerpt's actual logical content, only the excerpt against the page.

## How to prevent it (the rule)

After confirming an excerpt is verbatim on its cited source, re-read the claim sentence and ask whether the excerpt
alone, with no added inference, states it. If the claim requires a step the excerpt does not take, either quote
enough of the source to cover that step, mark the added step in the `why` field as synthesis rather than folding it
into the claim, or lower the claim to what the excerpt actually supports. Read at least the paragraph around a
short excerpt before citing it, so a nearby qualifying clause is not missed.

## Verification

The cross-verifier's protocol-2 check already asks "does the excerpt support the claim" as its fifth step; this
lesson asks that step to be answered by re-reading the claim against the excerpt alone, not against the general
topic of the source. The category that should fall: DOWNGRADED votes whose notes describe the excerpt as verbatim
but the claim as inferred, overstated, or missing a qualifier the source states nearby.
