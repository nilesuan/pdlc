---
id: LESSON-0078
date: 2026-09-28
trigger: audit-finding
phases: [03]
keywords: [threat-model, event-driven, lambda, s3-events, sweep, hand-back, reconciler, retry-path, invocation-path, fail-open, resource-policy]
related-rules: [standards/security/OWASP.md, standards/ANTI_HALLUCINATION.md]
status: candidate
---

# A check that reads the trigger's payload holds only on the paths that carry that payload

## What went wrong

In a Sofaoke `/design` run, a threat-model row stated that two event-driven functions refuse an object whose writer,
taken from the S3 event, is not the prefix's expected role, "trustworthy because only S3 can start the function".
The design, in a parallel record, also had a scheduled sweep start the same functions with only an object key, to
recover lost events. That path carries no event and no writer, so the check could not run there, and the stated
premise ("only S3") was false. A reconciliation review caught the first half. Re-reading the sweep found a second:
a refusal that left the request's stage unchanged would be handed back by the sweep 5 minutes later, through the
path that skips the check, and pass. A fail-closed check had become a 5-minute delay.

## Why it happened (root cause)

The control was reasoned about on the primary event path only. Its premise was not re-checked against every
invoker the function's resource policy admits, and the recovery path lived in another record. A refusal was
modelled as "do nothing", but in a design with a retry or reconcile loop, doing nothing means trying again later.

## How to prevent it (the rule)

For any control that depends on a field of the triggering payload, list every invoker the function's resource
policy admits, and state the control per path: where it runs, and what replaces it where it cannot. Make every
refusal durable: record it in the state that retry and reconcile loops read, so no loop can re-offer a refused
input through a path that skips the check.

## Verification

In threat models and ADRs for event-driven functions, each "refuses" or "checks" claim names the invocation paths it
covers, and each sweep, reconciler or retry path is checked against the refusals it could re-offer. The category
that should fall: reconciliation findings where a control is asserted for an invocation path that lacks its input.
