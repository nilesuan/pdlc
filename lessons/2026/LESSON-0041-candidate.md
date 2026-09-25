---
id: LESSON-0041
date: 2026-09-20
trigger: agent-self-corrected
phases: [02.5, 04, 05]
keywords: [check, test, named, property, mechanism, source scan, status, proves, reach, demonstrate, integrity control]
related-rules: [standards/ANTI_HALLUCINATION.md, standards/QUALITY.md, standards/process/LEARNING.md]
status: candidate
---

**Provenance.** Sofaoke, third /solve run, D3's real-song line-timing check, 2026-09-20.
The same failure twice in one run, both caught by the executor checking its own work:

1. A test named `test_it_changes_no_outcome`, guarding that a refusal profile never
   re-estimates a refused song, was a `grep` of the module source for three function names.
   It proved a spelling. A call assembled at runtime from fragments passes it untouched.
2. A reader meant to find songs "scored on a bundle the chain judged invalid" flagged any
   chain status other than `done`. It named a song that produced no output at all and was
   therefore never scored, and would have put a limit into the Results section that the
   data does not support.

## What went wrong

In both cases the check's name stated the property wanted. The implementation reached
something narrower - a spelling in the first, a status inequality in the second - and the
gap between them was invisible to everyone reading afterwards, including the author,
because the name is what a reader takes the check to mean.

## Why it happened (root cause)

A check is written immediately after the property is articulated, so the name is minted
from the intent while the intent is still the live thought. Once named, the name is the
artefact that gets read when anyone asks whether the property holds. Nothing forces a
second look at whether the mechanism reaches as far as the name claims, and the greener
the check runs, the less likely anyone looks.

## How to prevent it

Name a check after the mechanism it runs, not the property it is meant to establish -
`test_the_module_source_has_no_call_to_locate`, not `test_it_changes_no_outcome`. Then
state the property separately as a claim, and demonstrate it: construct the case the check
must catch and confirm it fails. If the demonstration is awkward to construct, that
awkwardness is the finding - the check does not reach the property. A check that has never
been made to fail is a check nobody has read.

**Two kinds, needing different remedies, and one test that catches both.** A check can miss
its property by inspecting the wrong thing (the source scan above), or by inspecting the
right thing on an input where the correct and incorrect implementations agree. A third
instance in the same run was the second kind: a test of the tie rule's float-noise
behaviour passed with the rounding removed, because the synthetic song was built so that
the smaller float already sat at the smaller `|s|`, where exact and rounded comparison
reach the same shift. The real song that exposed the defect had it the other way round -
which is why the defect was visible in the data and invisible in the test.

By the end of that run there were five instances - the fifth in an auditor's own evidence,
where a pattern written to enumerate every constant in a module, `^[A-Z_]+ *=`, silently
skipped every name containing a digit and so never saw `P90_DEPTH_DB`. The conclusion
happened to be right because that constant had been checked separately, which is how such a
gap survives. **Three of the five sat in files written specifically to guard the thing they
failed to guard** - the integrity test for a
profile that must not re-estimate, the determinism test under every reference start, the
pollution filter in the file added to stop that pollution. Writing a guard is the moment of
greatest confidence that the property now holds, and that confidence is what stops anyone
testing the guard. Treat "I have just written a check for this" as the cue to make it fail,
not as the reason not to.

The fourth was found only by mutating the rule it guarded: a condition in the onset rule
had no test that read it, and deleting the condition left the suite green. Reading would
not have found it, because the test looked correct and its assertion was true - it simply
held an input on which the condition never had anything to do.

**The same shape appears one level up, in the tooling.** The sweep that found the fourth
instance mutated sealed constants in a shared working tree in place, reverting after each,
with no lock and no copy - and corrupted two audits that were reading that tree at the same
time. Every mutation reverted cleanly, so the sweep's own artefact came out green either
way: its failure mode was invisible to everything it produced. A tool that makes a tracked
file temporarily wrong cannot show that harm in its own output, which is exactly the
property that makes an inert check look sound. Ask what a tool's artefact would look like
if the tool were damaging something outside its own scope, and if the answer is "the same",
the artefact is not evidence about that harm.

**Verifying the inputs to a sentence is not verifying the sentence.** The one defect in that
run that would have reached the owner was a claim that completing a run moved a measured
share "further from the bar". Every figure in it had been recomputed from the raw records
and every figure was right: the bar 0.25, the before 0.4091, the after 0.3846, the
pre-computed floor 0.36. Nobody did the subtraction. 0.1591 against 0.1346 - the share moved
*nearer*. It was published in three records including the one the decision-maker reads, by
two agents who between them had checked every component and neither of whom had checked the
composition. A check that validates each input of a claim reports success on a false claim,
which is the same failure one level up from a check that cannot fail: it is a check whose
name ("the figures are verified") is true and whose subject was never the thing at issue.

**Knowing this lesson does not prevent it, and that is the most important thing in it.** The
sixth instance was written by the agent that had just helped articulate the rule, hours
after articulating it, in the test built to fix the run's most serious defect: a test named
`test_no_share_or_verdict_survives_anywhere_once_the_rule_fires` that traverses four
expected blocks. A share placed anywhere else publishes with every test green. The author
had even made a check fail that day - but the failure constructed was for a different
property the test also covered (that the suppression is conditional and not blanket), not
for the property the test's name claims. So the refinement is exact: when you make a check
fail, construct the failure its NAME promises to catch. A check that has been made to fail
on some other axis is still a check nobody has read on the axis you are trusting it for.

Naming the mechanism exposes the first kind, because the mismatch becomes readable. It does
nothing for the second, where the name is accurate and the input is the problem; there the
remedy is to construct the discriminating case deliberately, which usually means extracting
the decision so an adverse input can be handed to it rather than hoped for. Making the
check fail is the one operational test that catches both, which is why it is the rule and
the naming is the aid.
