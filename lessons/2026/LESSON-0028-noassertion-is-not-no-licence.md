---
id: LESSON-0028
date: 2026-09-19
trigger: xv-rejected
phases: [01, 02.5, 03]
keywords: [licence, license, NOASSERTION, spdx_id, dataset, corpus, absence-claim, LICENSE-file, github-api, huggingface]
related-rules: [standards/EVIDENCE.md, agents/cross-verifier.md, lessons/2026/LESSON-0008-vocabulary-grep-is-not-absence.md]
status: active
---

**Provenance.** Cross-verifier, `/solve` Phase 02.5 Pass 4 (resumed), Sofaoke `song-processing`, 2026-09-19. `REJECTED` on P4B-CORPUS-01 (`cdocs/.pipeline-solve/pass4/xv-A.yaml`). The same sentence stands in the D3 record's addendum (`solutions/song-processing/spikes/lyric-alignment.md:448`).

## What went wrong

A finding said a word-level lyric-timing corpus's annotations "declare no licence". Its evidence was the GitHub API's `"spdx_id":"NOASSERTION"` for the corpus's repository and a count of 0 for "licen" in the Hugging Face dataset README. The saved API record also held `"key": "other", "name": "Other"`, which is how GitHub reports a licence file it cannot match to a standard licence, and the saved Hugging Face file listing named a `LICENSE` file at the dataset root. That file, fetched from both hosts on 2026-09-19, is the MIT License, and it excludes only the subfolders "lyrics" and "mp3", which it places under per-song Creative Commons licences; the word annotations sit in `annotations/words/`, outside those exclusions.

## Why it happened (root cause)

Two proxies for "has a licence" were checked, a metadata field and a README, and the licence file itself was never opened. `NOASSERTION` reads like "none" but means "not recognised".

## How to prevent it (the rule)

**Before stating that a dataset or repository declares no licence, open every licence-bearing file it ships (`LICENSE*`, `COPYING*`, `NOTICE*`, the dataset card's `license:` field) and quote what it says about the part you need; an API's `NOASSERTION` or a README with no licence section is never evidence of absence.**

## Verification

- A licence-absence claim carries the file listing it searched and the fetched text or the fetch error of each licence-bearing file.
- The cross-verifier fetches the licence file itself for every licence claim, not only the field the finding cites.
- The category that should fall to zero: a corpus or tool excluded for "no licence" when a licence file exists.
