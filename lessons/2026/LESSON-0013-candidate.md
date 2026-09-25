---
id: LESSON-0013
date: 2026-09-18
trigger: xv-downgraded
phases: [02.5]
keywords: [measured-number, wrong-configuration, config-precedence, unverified-mechanism, api-not-called, necessity-vs-sufficiency, reproduce-the-command, cross-verifier]
related-rules: [standards/EVIDENCE.md, standards/ANTI_HALLUCINATION.md, agents/cross-verifier.md]
status: candidate
---

# A real measurement proves the command ran, not that it ran the thing you named

**Provenance.** `/solve` Phase 02.5 Pass 1, slug `song-processing`, 2026-09-18.
Four of 32 findings were `DOWNGRADED` by the cross-verifier. Three share one root
cause, which makes this capture in-spec under the `xv_downgraded >= 2` trigger.

## What went wrong

Three findings attached a correct-looking conclusion to a mechanism that was
never checked. In each case the *number* or the *quote* was real; the *thing it
was said to be about* was not.

- **A measured figure credited to a configuration that was never loaded.** A
  finding reported that Panako's time-stretch-tolerant `PANAKO` strategy matched
  a +2% speed variant at time factor `0.980`, having set `STRATEGY=PANAKO` in
  `$PANAKO_HOME/.panako/config.properties`. The figure reproduces byte-for-byte.
  But Panako reads `config.properties` from the directory beside its jar, not
  from `$HOME`; the jar-adjacent file still said `STRATEGY=OLAF`, the run log
  named `be.panako.strategy.olaf.OlafStrategy`, and re-running with `PANAKO`
  genuinely engaged returned no match at all (`null`, `-1.000`). The measurement
  was real and the attribution was wrong, so the recommendation would have
  registered a spike arm on a strategy that does not match.
- **A hazard list asserted as necessary when it was only documented.** A finding
  said the Apple Silicon install "needs" an unpinned OpenLDAP clone, a mutable
  `0.8.3-SNAPSHOT`, a dylib copied into `~/Library/Java/Extensions`, and
  `--add-opens`. All four strings are verbatim on the cited blog, and the
  project README does point there. None of the four was required: a working
  install used a released Homebrew bottle, the shaded jar already pins a
  released `lmdbjava`, the global extensions directory does not exist on the
  machine, and the same README's changelog says the current version supports
  Apple M1. One limb (`--add-opens`) was real, but only on JDK 17+.
- **A service's response described without calling the service.** A finding said
  a `MusicBrainz` lookup with `inc=url-rels` returns AcoustID relationship URLs
  that must never be followed. The claim carried no quote and no call. Six live
  lookups returned zero url relations and no AcoustID.

## Why it happened (root cause)

Producing a real artifact - a reproducible number, a verbatim quote from a real
page - feels like the verification step, so it substitutes for it. But a
reproducible number proves only that *some* command ran to completion; it says
nothing about which code path served it. A verbatim quote proves the sentence
exists on the page; it says nothing about whether the procedure that sentence
describes is *necessary*, *current*, or *the only one*. Both gaps sit exactly
where the evidence looks strongest, which is why neither the author nor a
string-matching verifier catches them.

Config precedence is the sharpest form of this. A tool that silently falls back
to a different settings file will run happily and print plausible output, and
nothing in the output announces which file won.

## How to prevent it (the rule)

When a finding credits a measurement to a **named mode, strategy, profile or
configuration**, the evidence must show that mode was the one in force - a log
line naming the class, a version banner, or a differential run proving the other
mode behaves differently. "I edited a config file and the command succeeded" is
not that evidence.

When a finding says a procedure is **required** ("needs", "the only path",
"must"), the evidence must establish necessity, not just documentation: check
the project's own changelog and current dependency pins, and try the obvious
cheaper route before filing. Quoting a third-party page verbatim establishes
that the page says it, nothing more. File it as "the documented route carries X"
at the severity that shape deserves.

When a finding describes **what an API returns**, call the API and quote the
response. An assertion about a response shape with no call behind it is an
`[UNVERIFIED]` line, not evidence.

## Verification

- For any finding whose claim names a strategy, mode, profile or config value
  alongside a measured number, the evidence block must carry an independent
  witness that the named mode was active.
- For any finding using a necessity term, the evidence must name what was tried
  and failed, or cite the project's own current documentation, not only a
  third-party procedure page.
- Expected signal: `DOWNGRADED` votes reading "number real, attribution wrong"
  and "quote real, necessity overstated" fall to zero.
