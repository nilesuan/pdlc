---
id: LESSON-0024
date: 2026-09-18
trigger: audit-finding
phases: [02.5, 04, 05]
keywords: [sealed, pre-registration, verbatim, shared-module, instrument.py, contention, frozen, file-ownership, parallel-agents, brief]
related-rules: [agents/pass-runner.md, standards/frameworks/EXPERIMENTATION.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md]
status: active
---

**Provenance.** Pre-execution review of D2 round 4, `/solve` Phase 02.5 Pass 3, Sofaoke `song-processing`, 2026-09-18: finding QA-D2R4-01, blocker at 95, in that project's `cdocs/.pipeline-solve/pass3/qa-d2r4-findings.yaml`. Found by the review before any round-4 command ran, so no result was affected.

## What went wrong

A sealed spike registration adopted a measuring function from another workstream's module verbatim: the machine-contention check in `eval/e2e/instrument.py`, lines 88-107, whose two criterion lines the harness asserts at run time. Nine minutes after the registration was sealed, a parallel agent that owned `eval/e2e/**` changed that function for its own purposes, so that processes in the caller's own tree no longer counted. The registered harness then refused its first step, and the round could not run, let alone select anything. Its own assertion caught the change; nothing upstream prevented it.

## Why it happened (root cause)

File ownership in parallel briefs was drawn by directory, and a sealed registration's dependencies are not directories: they are specific functions it quotes. The brief that gave one agent `eval/e2e/**` did not name the function another agent's sealed text had adopted, so from the owning agent's side the change was an ordinary edit inside its own lane.

## How to prevent it (the rule)

**When a sealed registration adopts code by quotation, the harness loads that code from the commit named in the seal, verified by hash, and every parallel brief names the adopted function as frozen for all other agents.**

## Verification

- A registered harness that imports a quoted function from a live file, rather than from a hash-checked copy of the sealed commit's blob, is a finding.
- Each parallel brief's "do not edit" list includes every function a sealed registration quotes from that agent's lane.
- The category that should fall to zero: a registered run refusing to start because a quoted dependency changed under it.
