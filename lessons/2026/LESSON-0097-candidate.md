---
id: LESSON-0097
date: 2026-10-02
trigger: self-detected
phases: [02.5, 03, 04, 05]
keywords: [lesson-file, unverified-claim, overwritten, secondhand-account, fork, citation-to-claim-mismatch, candidate-stub, read-before-write]
related-rules: [standards/process/LEARNING.md, standards/ANTI_HALLUCINATION.md, agents/pass-runner.md]
status: candidate
---

## What went wrong

While auditing the incident that LESSON-0099 covers (a research fork that misread its own dispatch wrapper and ran most of the orchestrator's task), the orchestrator had already written a first-draft candidate lesson about it, grounded in its own direct `git diff` / `git blame` observations. Minutes later the same file was found rewritten with a different, overlapping but not identical account: it gave a different agent count than the orchestrator had actually dispatched, and it asserted that a sub-agent "wrote a matching code fix... into the main checkout" - the one repository this task was never supposed to touch. The orchestrator checked `git status --short` in the main checkout at that moment and found it completely clean, so that specific claim was false as stated. A later, more detailed report from the fork itself (now recorded as LESSON-0099) independently confirmed that the main checkout had in fact briefly held uncommitted edits to seven files earlier in the run, before self-correcting - so the rewritten lesson was not pure invention, but it stated an unverified, secondhand reconstruction as settled fact, with a specific detail (the agent count) that did not match anything the orchestrator had actually dispatched, and without first reading the draft it overwrote.

## Why it happened (root cause)

The same inherited-context pressure that LESSON-0099 names for editing design records applies just as much to the lesson-recording mechanism itself: an agent that is not the orchestrator, observing fragments of an in-progress incident it did not directly witness, and operating under the standing instruction to record mistakes on detection, assembled a plausible-sounding narrative and wrote it into a tracked file as if it were a verified account - the exact citation-to-claim mismatch LESSON-0004 already names, here aimed at the system's own self-correction channel rather than at a design record. Nothing distinguishes "a lesson I am recording from my own direct evidence" from "a lesson I am recording from inference about events I did not see" at the point of writing, and the lesson-file format itself carries no evidence field that would force the distinction the way EVIDENCE.md's schemas do for ordinary findings.

## How to prevent it (the rule)

Treat a lesson-candidate file exactly like any other tracked record for citation purposes: a claim in it must cite the evidence the writer itself directly observed (a command it ran, a diff it read, a file it opened), never a reconstruction of another agent's unwitnessed actions, and an agent that was not party to an incident should not write its lesson at all - it should surface what it noticed as a `clarification-needed` or `out-of-scope-observations` item for the agent that was party to the incident, or for the orchestrator, to confirm and record. Before overwriting any file under `lessons/`, read its current content first, per the ordinary read-before-write discipline; a draft that already exists for the same incident is a signal to add to or correct, not silently replace.

## Verification

- A lesson-candidate file's "What went wrong" and "Why it happened" sections name only evidence the filing agent itself directly gathered in this session; a claim about another agent's unwitnessed action is marked as inference or left out.
- A lesson file touched by a second agent after a first draft already exists shows evidence that the second agent read the first draft (its content is extended, corrected, or explicitly superseded with a stated reason) rather than silently replaced.
- See LESSON-0099 for the mechanism that produced the underlying incident this lesson's content was initially (and partly inaccurately) trying to describe.
