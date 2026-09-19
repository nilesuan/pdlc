---
id: LESSON-0030
date: 2026-09-19
trigger: self-detected
phases: [02.5, 04, 05]
keywords: [relay, coordinator, owner-ruling, scope, parallel-agents, sealed, registration, timing, mediaanalysisd, decision-bearing]
related-rules: [agents/pass-runner.md, standards/frameworks/EXPERIMENTATION.md, standards/operations/SCHEDULED_WORK.md]
status: active
---

**Provenance.** `/solve` Phase 02.5 pass 5, Sofaoke `song-processing`, 2026-09-19. Found by the orchestrator between about 04:33Z and 04:38Z while preparing D2 round 5's release, before any affected command ran; recorded in that project's `cdocs/.pipeline-solve/pass5/progress.json` and in the rulings `pass5/gates/d2r5-amend-r5-12.txt` and `pass5/gates/d5r4-amend-c.txt`.

## What went wrong

At 03:11:37Z the coordinator, answering a question about D2 round 5, restated the owner's rule for stopping a macOS daemon in general words: only "right before a timing run that is still decision-bearing". Two sealed registrations written before that message both stopped the daemon before timing runs their own text called information only or "never decision-bearing": D2 round 5 (not yet started) and D5 round 4 (running, its timing run hours away). The orchestrator applied the restated rule to neither. Its draft release for D2 even told D2 the opposite, that an informational timing run could stop the daemon. Neither stop had happened when the gap was found; both registrations were amended before their timing runs.

## Why it happened (root cause)

The orchestrator filed the message under the workstream it was about. It did not check every running and pending workstream whose sealed text the rule's words reached. A rule stated in general words is a rule for every workstream it covers, whoever asked the question.

## How to prevent it (the rule)

**When a coordinator or owner message states a rule in general words, search every sealed registration and every pending gate draft for the action the rule governs, and relay it to each affected workstream in the same turn, not only to the one the message was about.**

## Verification

- For each such message, the progress record lists the searches run (for example `grep -n killall` over the harness directories and the registration blocks) and the workstreams told.
- A gate draft that contradicts the latest relayed rule is a finding before release.
- The category that should fall to zero: a sealed step outside a rule the coordinator has already stated, discovered at or after execution.
