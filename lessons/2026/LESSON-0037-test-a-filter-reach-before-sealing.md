---
id: LESSON-0037
date: 2026-09-19
trigger: self-detected
phases: [02.5]
keywords: [label rule, ruling, filter, metadata, harvest, yield, floor, stored manifest, pre-registration, amendment]
related-rules: [standards/frameworks/EXPERIMENTATION.md, standards/frameworks/PROBABILISTIC_COMPONENTS.md, agents/pass-runner.md]
status: active
---

**Provenance.** Sofaoke, third /solve run, D5 round 5, 2026-09-19. A pre-execution reviewer found that a "cover" upload of a seed recording that is itself a cover could be mislabelled (QA-D5R5-01) and offered two fixes. The orchestrator ruled the broader one: an upload whose title or channel names the seed artist leaves the cover stratum. It was sealed in amendment 5A. At the labels, the rule removed 140 of 148 cover pairs (44 of 46 uploads), because covers by other artists conventionally name the original artist in their titles, and the hard-negative floor projected 11 of 20. A further sealed amendment (5D) had to narrow the rule to the channel before any of those uploads was downloaded.

## What went wrong

A label rule was sealed without being run on any real metadata. Its effect on the stratum it filtered was large and predictable from any list of cover titles, including the previous round's 507 stored uploads, which were on disk.

## Why it happened (root cause)

The ruling was judged by its logic (does it exclude the bad case?) and not by its reach (what else does it exclude, and how much?). A filter that removes the bad case can also remove most of the good ones.

## How to prevent it (the rule)

**Before sealing a label or filter rule, run it on the most recent stored metadata of the same kind (a previous round's manifest) and record what share of each stratum it moves. If it moves more than it was meant to, narrow it before sealing.** This is metadata only; it reads no outcome, so it biases nothing.

## Verification

- Every sealed label or filter rule in a registration or amendment is followed by a pasted run on stored metadata with the counts it moves per stratum.
- The category that should fall to zero: a floor projected short at the labels because a newly sealed filter removed most of a stratum.
