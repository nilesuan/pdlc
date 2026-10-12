---
id: LESSON-0110
date: 2026-10-08
trigger: user-correction
phases: [08]
keywords: [game-bot, closed-loop, verify-effect, screen-state, hardcoded-geometry, actrl, onlysword, tribulation]
related-rules: [CLAUDE.md]
status: candidate
---

## What went wrong

The user reported "tribulation is failing" and that the OnlySword tribulation bot did not press Start like the other bots. The live logs showed four defects. First, the bot dragged on the intro dialog: it read the dialog's red Start button as beams and put a finger down there. The game ignores a touch that begins on the dialog, so it ignored that finger all game, and the bot, still believing its own moves, was struck 3 times. Second, the Tribulation Failed screen was never recognised. The watcher took it over again and again for 9 minutes, each time pressing and dragging 50 px below the Retry button, and Retry spends Breakthrough Pills. Third, the lanes were hardcoded as 5, measured in one realm, while three other realms have 4. Fourth, the cultivator-position reader moved 200 px or more whenever stray gold appeared. The project memory had already marked how a tribulation starts as UNVERIFIED, and nothing closed that gap before the bot was trusted with live play.

## Why it happened (root cause)

The bot was open-loop. It updated its belief from the action it sent, not from what the screen showed afterwards. Its model of the game (the lane geometry, which screens exist) came from a single observed session and was never checked against other states. A screen-driven take-over trusted a single positive signal (the title is up) without a negative check for the end states that look similar.

## How to prevent it (the rule)

A bot that acts on a live game must check the effect of each action on screen, and go by the screen when the two disagree for a steady run of frames. Geometry measured on one level is read from the screen, or verified on every level the bot is enabled for. Every screen that shares the take-over signal (dialogs, failure and result screens) is captured as a fixture with a take-over test before the bot runs unattended. An UNVERIFIED note about game flow blocks unattended use until a fixture covers it.

## Verification

For each bot activity there is a test where the game ignores or overrides the bot's action and the bot recovers. For the tribulation this is `test_tribulation_goes_by_the_screen_when_the_cultivator_does_not_follow`: with the re-sync turned off it reproduces the live result of 3 hits out of 3. Take-over tests also cover every end screen that keeps the title up, such as `test_a_tribulation_intro_is_taken_over_and_a_failure_screen_never_is`.
