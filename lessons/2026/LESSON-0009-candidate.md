---
id: LESSON-0009
date: 2026-09-08
trigger: self-detected-violation
phases: [02.5, 03, 04, 05, 07]
keywords: [pii, projection, allowlist, denylist, regex-fallthrough, column-level-sensitivity, manifest, disclosure, c-15, metrics-only, stdout]
related-rules: [CLAUDE.md, standards/EVIDENCE.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md]
status: candidate
---

**Provenance.** Raised from the `/solve` Phase 02.5 run-2 QA pass on `pdf-extraction-financial-docs`, 2026-09-08. Self-detected: no cross-verifier vote, no broken link and no auto-rejection fired. The pass brief carried an explicit, unambiguous rule ("Never print a filename or document content... Project away `source`/`stem`/`file` before printing") and the agent violated it **twice in the same session**, in two different ways. Captured at detection per `CLAUDE.md` §1.

## What went wrong

The corpus at `data/wild/manifest.csv` has 12 columns; three of them (`source`, `stem`, `file`) carry client names. The brief named those three and required them projected away before any print. Two separate violations followed anyway.

**Violation 1 - the projection was a regex, and the regex fell through.** A script derived a document-type label from the `stem` with `re.match(r"^([A-Za-z-]+?)-\d", stem)` and printed `Counter` keys. The intent was that only the matched type token would ever be printed. The pattern did not match the actual ROMA naming shape, so the `else` branch put the **whole raw `stem`** into the counter key, and the counter was then printed. Roughly sixty client-identifying strings reached the transcript and one persisted tool-output file, which was deleted on detection.

**Violation 2 - a fourth column carried identifiers and was on nobody's list.** After the first fix, a probe printed normalised patterns of the `notes` column to learn what page-level ground truth the builder had recorded. `notes` is builder-authored prose on twelve of the thirteen kinds and carries no identifier - but on the 2,512 `sandwich` rows it ends with `see <filename>.sandwich.errors.csv`. The normalisation replaced digits and left the name. Three more client-identifying strings reached the transcript.

## Why it happened (root cause)

Two distinct root causes that share one shape: **the control was a denylist over a fallible transform, where it needed to be an allowlist over the output.**

1. **A projection implemented as a pattern match fails open.** A denylist ("strip the identifier") and an extraction ("keep the type token") look the same when the pattern matches, and diverge exactly when it does not. On the miss, the raw input is what survives into the output. There was no assertion on the output, so the failure was silent - no error, no exit code, no alert, which is the property `constraints.md` C-15 already records as making this failure class invisible.
2. **Sensitivity was reasoned about at file granularity, then at named-column granularity, and both are wrong.** The brief had already made the refinement from "the manifest is readable" to "these three columns are not", which is the same lesson at one level of resolution. The second violation shows the refinement did not go far enough: `notes` is *mostly* safe and is unsafe on one kind, so the safe unit is neither the file nor the column but **the actual bytes about to be printed**.

The amplifier is that this agent was, at the moment of both violations, writing an artifact whose §13 records the identical failure mode for a different actor. Knowing the rule, quoting the rule and having just written the rule down did not prevent it, because the rule was being applied to the design of the deliverable rather than to the agent's own working commands.

## How to prevent it (the rule)

When printing anything derived from a sensitive record, **the output must be constrained by an allowlist, and the allowlist must be checked against the bytes leaving the process, not against the transform that produced them.**

Three operational forms:

1. **Extract by allowlist, never by pattern-with-fallthrough.** If the printable values are a known finite set (five document-type tokens, thirteen kind names, a set of verdicts), match against that set and route everything else to a bucket that prints **only its count**. Never let an unmatched input become its own label.
2. **Assert on stdout, not on intent.** Before a script that touches a sensitive record is run for real, hold the identifier set in memory, capture the script's stdout and stderr, and assert that no identifier appears as a substring. Report a count of violations, never the matching text. Give the assertion a deliberate negative case - a script that does print an identifier must make it fail - per LESSON-0005; a positive-only test of this control passes unconditionally.
3. **Do not enumerate the sensitive columns; enumerate the safe ones.** "Project away `source`, `stem`, `file`" is a denylist and it missed `notes`. "Select `kind`, `expect`, `pages`, `chars`, `bytes`" would not have. Column lists grow; safe-column lists are the ones that fail closed when they do.

The generalisation beyond this repository: an exploratory command run against regulated data is production code for disclosure purposes. It gets the same control as the deliverable, at the moment it is typed, not after it has printed.

## Verification

- The signal that it is working: for any pass that reads a regulated record, every script that prints has an explicit printable-value allowlist, and the pass's own transcript contains zero identifier substrings when scanned against the identifier set.
- The failure category that should drop to zero: "a normalisation, redaction or extraction step printed its input because the pattern did not match".
- Cheap check available to the pass-runner: for a brief that names sensitive columns, flag any agent-authored script containing a regex whose non-matching branch reaches a `print`, a `Counter` key, or a format string.
- **A third instance in the same session, of a neighbouring failure mode, recorded because it shares the root cause.** The same pass asserted "no spike script exists anywhere in the repository" and wrote out the `find` invocation that supposedly grounded it, without running that command. Twenty spike scripts existed. That is LESSON-0008's failure (an absence claim whose search is described rather than run) meeting this lesson's failure (a control that fails open when nobody checks its output). The shared root cause: **the artifact that would have caught it - the command's actual output - was never produced, and nothing in the workflow required it to be.** Same fix shape: run the command, paste its result, and let the result rather than the intent be the evidence.
- Note for promotion review: this lesson and `constraints.md` C-15 on that project are the same finding reached independently, once from an orchestrator incident and once from this one. The column-versus-file refinement in C-15 is a strict subset of the allowlist rule above.

- **A fourth instance, found by the Pass 2 spike agent on the same run, and it is the first one caught by the control rather than by hindsight.** `metric-register.md` §2.4 was written to fix instances one and two, and its own table classifies the manifest column `ground_truth` as **printable**. It is not: its basename equals the client-identifying `stem` on **27,632 of 27,632 rows that carry it** [VERIFIED - equality tested per row over `data/wild/manifest.csv`, 2026-09-08]. The spike agent printed one such value into its transcript while probing the manifest's shape, before the allowlist was written. What is notable is the shape of the error, not the error: §2.4 had already made the corrective move this lesson prescribes - it replaced a denylist with an allowlist - and then populated the allowlist by inspecting **column names** rather than **column values**, so a column whose name says "ground truth" and whose value is a filename was waved through. The allowlist was right and its contents were wrong.
- **The refinement that follows.** "Enumerate the safe columns" is necessary and not sufficient. A column earns a place on the allowlist only when a **value-level** test says it does: sample it, and assert that no value is a substring of, or contains, any identifier. Naming a column safe is a claim about its values and must be verified as one. The spike harness at `cdocs/spike/spikelib.py` implements this: `PRINTABLE_COLUMNS` holds seven low-cardinality builder-authored columns and integers, `IDENTIFIER_COLUMNS` names `ground_truth` alongside `source`, `stem`, `file` and `notes`, and `StdoutGuard` scans the emitted bytes against the identifier set with the mandatory negative case per LESSON-0005.
