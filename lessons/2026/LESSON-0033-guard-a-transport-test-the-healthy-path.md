---
id: LESSON-0033
date: 2026-09-19
trigger: self-detected
phases: [04, 05, 02.5]
keywords: [transport, socket, http.client, timeout, bounded-read, guard, control, healthy-path, regression, probe, lrclib]
related-rules: [standards/process/LEARNING.md, standards/development/PRINCIPLES.md]
status: active
---

**Provenance.** `/solve` Phase 02.5 pass 5, Sofaoke `song-processing`, 2026-09-19. Finding E2E5-LRCLIB-01 (major, CONFIRMED at 95 by the cross-verifier) in that project's `cdocs/.pipeline-solve/pass5/e2e-findings.yaml`; fixed in commit `46df103`. Found when a registered probe of the "song has no lyrics" path ran for the first time since the guard was added.

## What went wrong

A safety fix in the previous pass (`7fb767c`) bounded how long the chain would wait while reading an answer from the lyrics service, so a slow server could not stall a job. It set a timeout on the socket before each read. When the service's answer is framed by a length header, Python's HTTP client closes the socket as soon as the last byte is read, and setting a timeout on a closed socket raises an error. The service frames an empty search result that way. So every song with no lyrics was recorded as "lyrics service could not be reached" instead of "no lyrics found", and any complete answer framed the same way would have failed alike. The guard's tests covered the slow-server failure it was written for and passed; nothing exercised a normal, complete answer through the real transport after the change.

## Why it happened (root cause)

The guard was tested only against the failure it was added to stop. A control wrapped around a real transport changes the healthy path too, and the healthy path was the one no test drove after the change.

## How to prevent it (the rule)

**A guard added around a real transport (a socket, an HTTP read, a subprocess pipe) ships with a test of the healthy path through that transport: a complete, normal answer read to its end, including the framings the real service uses, not only the failure the guard stops.**

## Verification

- A change that wraps a transport read carries at least one test that reads a complete answer through the same wrapper, as `46df103`'s loopback test does, and that test fails if the guard is reverted to the broken form.
- A registered probe of each outcome path (found, not found, unreachable) runs after any change to that transport, before the change is counted as done.
- The category that should fall to zero: a normal outcome reported as a transport failure after a hardening change.
