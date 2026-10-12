---
id: LESSON-0111
date: 2026-10-10
trigger: user-correction
phases: [08]
keywords: [game-bot, calibration, ground-truth, self-estimate, gate-breach, actrl, onlysword]
related-rules: [CLAUDE.md]
status: candidate
---

## What went wrong

The user reported that the last 3 Gate Breach (Retemper) attempts weren't Perfect. Each was 5 Perfect and 2 Good, which grades as Superior. The bot timed each tap to the moment the Gate visibly disappeared, and judged its own accuracy from that same moment ("landed +X deg by the model"). The game grades a tap 40-80 ms earlier. So every tap landed early by the qi's speed times that gap, and the fastest Gates crossed the edge into Good. A memory note from 2026-10-08 ("Perfect spans +-7 deg") had been measured on the bot's own biased scale and was passed along as fact. The truth was on screen the whole time: the HUD score rises by 120 + 20n for a Perfect and by 50 for a Good, which gives each tap's grade.

## Why it happened (root cause)

The bot's feedback loop measured its own output against its own model. It never compared that against the game's verdict, so a constant bias was invisible from inside the loop. The thresholds learned from that loop inherited the same bias.

## How to prevent it (the rule)

Calibrate a timing or aiming bot against the target's own verdict, not the bot's estimate of its own accuracy. That verdict can be a score delta, a grade popup or a result screen. Before tuning any threshold, find a ground-truth signal and check that the bot's estimate agrees with it. Label any "measured" game fact with the scale it was measured on.

## Verification

The Gate Breach fit uses the grades decoded from the HUD (178 taps, 31 games). The closed-loop scenarios model a judge-to-visible gap, and they fail when the bot aims at the visible break.
