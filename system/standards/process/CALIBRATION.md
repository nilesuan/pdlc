# CALIBRATION.md — Per-prefix historical-accuracy calibration

This file defines the per-prefix historical-accuracy calibration that the pass-runner applies during scoring. Without calibration, every agent's findings are weighted equally; with calibration, agents (and finding domains) whose findings have historically been accepted weigh more, and agents whose findings have historically been wrong weigh less. The loop closes by recording every finding's outcome over time.

This file extends the unified anti-hallucination protocol in [`../ANTI_HALLUCINATION.md`](../ANTI_HALLUCINATION.md). It is not itself one of the six layers — it does not check the current pass's findings; it weights them by past accuracy — but it shares the same anti-hallucination goal, and is referenced from [`../QUALITY.md`](../QUALITY.md) and [`../../agents/pass-runner.md`](../../agents/pass-runner.md).

---

## Why per-prefix calibration

Without history, every agent's confidence claim is trusted equally. In practice, some prefixes (e.g., `SEC-INPUT`) historically prove correct over 90% of the time while others (e.g., `GEN-MAINT`) prove correct around 60%. Calibration captures that asymmetry: a `SEC-INPUT` finding at confidence 80 should weigh more in scoring than a `GEN-MAINT` finding at the same confidence, and the system should learn that asymmetry from outcomes rather than encode it by hand.

*Why:* a single-pass review cannot detect that an agent has a systematic 30-point optimism bias on its own claims; only outcomes over time can.

---

## Files

- `cdocs/review-calibration/history.jsonl` — append-only log of every finding from every review pass, with outcome resolution.
- `cdocs/review-calibration/calibration.json` — per-prefix accuracy snapshot, recomputed every 5 resolved-outcome rows.

`cdocs/` is gitignored per [`../../CLAUDE.md`](../../CLAUDE.md) §3 — generated artifacts go under `cdocs/`.

---

## history.jsonl row format

One JSON object per finding per pass, appended:

```json
{"timestamp": "2026-04-27T15:23:00Z", "command": "review", "pass": 1, "finding_id": "SEC-AUTH-01", "prefix": "SEC-AUTH", "severity": "blocker", "confidence": 90, "calibrated_confidence": 72, "xv_verdict": "CONFIRMED", "adjusted_severity": "blocker", "outcome": "pending"}
```

`outcome` transitions from `pending` → `accepted` (the user fixed the issue or merged the suggested change) or `rejected` (the user marked the finding as wrong). The orchestrator updates `outcome` when the user's response arrives. *Why: outcome resolution is the signal — without it, history is just a record of what we said, not what was true.*

`prefix` is `finding_id` with the trailing `-NN` stripped (e.g., `SEC-AUTH-01` → `SEC-AUTH`). *Why: the prefix is the calibration unit; the index is meaningless across passes.*

---

## calibration.json format

```json
{
  "_default": {"accuracy": 0.75, "n": 0},
  "SEC-AUTH": {"accuracy": 0.92, "n": 24},
  "GEN-MAINT": {"accuracy": 0.61, "n": 41},
  "_meta": {"computed_at": "2026-04-27T15:23:00Z", "history_rows_at_compute": 145}
}
```

`accuracy` ∈ [0, 1]; `n` is the resolved-outcome row count for the prefix at the moment the snapshot was computed. `_meta.computed_at` is mandatory so a stale snapshot can be detected.

---

## Recomputation cadence

Every 5 resolved-outcome rows added to `history.jsonl`, the pass-runner recomputes the snapshot. Pseudocode:

```
for each prefix found in history.jsonl:
  resolved = rows where outcome != "pending" AND prefix matches
  accepted = rows where outcome == "accepted" AND prefix matches
  if len(resolved) >= 5:
    accuracy[prefix] = len(accepted) / len(resolved)
    n[prefix] = len(resolved)
  else:
    omit (use _default)
write calibration.json with _default, _meta.computed_at, _meta.history_rows_at_compute
```

*Why every 5:* fewer recomputations than per-row, but frequent enough that a new prefix graduates out of `_default` quickly. Matches the predecessor cadence in `~/.claude.old/commands/amrr.md` §"Step 4c. Feedback Capture".

---

## How the pass-runner applies it

For each surviving finding (post cross-verifier):

1. Compute `prefix = finding_id` with trailing `-NN` stripped.
2. Look up `accuracy = calibration[prefix].accuracy or calibration["_default"].accuracy or 0.75`.
3. Compute `calibrated_confidence = adjusted_confidence × accuracy`. Round to integer.
4. Pass `calibrated_confidence` into the QUALITY.md scoring formula.

Calibration applies **after** the cross-verifier's `adjusted_confidence` and **before** scoring. Never the other order. *Why: cross-verifier evidence-checking is per-finding factual; calibration is per-prefix historical. Reordering would weight the cross-verifier's own correction by historical accuracy, which double-counts.*

---

## Bootstrap

If `calibration.json` does not exist, write `{"_default": {"accuracy": 0.75, "n": 0}}` and proceed. The 0.75 default reflects "moderately trusted but not yet proven" — high enough that a new prefix is not silently suppressed, low enough that calibration matters.

The 0.75 default is a chosen starting point for this system; it has no upstream named source. [UNVERIFIED — flagged per [`../../../CLAUDE.md`](../../../CLAUDE.md) §4.] *Why flag it:* defaults are silent assumptions that compound; tagging makes the choice auditable.

---

## Outcome resolution UX

The orchestrator does **not** auto-resolve outcomes. The user marks each finding accepted or rejected after the pass — typically by acting on (or dismissing) the recommendation. The orchestrator's responsibility is to surface unresolved findings for marking; the user provides the signal.

Outcomes that stay `pending` for more than 30 days are excluded from the next recomputation (treat as inconclusive). *Why: a finding the user neither accepted nor rejected after a month is signal-less; counting it either way would corrupt the accuracy estimate.*

---

## Hard rules

1. **No agent may write to `calibration.json` directly.** Only the pass-runner recomputes it, and only at the 5-row cadence. *Why: a sub-agent that can rewrite its own accuracy is no longer being audited.*
2. **The default 0.75 is per-prefix, not global.** A new prefix starts at default and graduates to per-prefix accuracy after 5 resolved rows. *Why: a global default would mask per-prefix asymmetry, which is the entire point of calibration.*
3. **Calibration applies after cross-verifier `adjusted_confidence`, before scoring.** Never the other order. *Why: see "How the pass-runner applies it" — reordering double-counts the cross-verifier's correction.*
4. **`calibration.json` must include `_meta.computed_at`.** *Why: a stale snapshot is worse than no snapshot; the timestamp lets the pass-runner detect drift.*
5. **`--no-calibration` flag bypasses calibration.** When the user explicitly distrusts the calibration (`--no-calibration` on a command), the pass-runner uses 1.0 for every prefix and notes this in the `score_breakdown`. *Why: the user must always be able to bypass any automatic weighting; the bypass is itself recorded so the result is auditable.*

---

## Severity calibration (this standard's own findings)

| Severity | Example |
|---|---|
| blocker | Pass-runner wrote `calibration.json` without recomputing first; pass-runner used calibrated_confidence in critical-override check before applying calibration |
| major | `_meta.computed_at` missing from `calibration.json`; recomputation triggered but not at the 5-row boundary |
| minor | New prefix graduated to per-prefix accuracy with `n < 5`; pending outcomes older than 30 days included in recomputation |
| nit | `history.jsonl` row missing optional fields |

---

## Sources

- `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4b–4d — calibration formula (`calibrated_confidence = adjusted_confidence × historical_accuracy`), the 0.75 default, and the "look up by check_id prefix" rule.
- `~/.claude.old/commands/amrr.md` §"Step 4c. Feedback Capture" — the every-5-resolved-reviews recomputation cadence and `history.jsonl` row shape.
- This file extends the anti-hallucination discipline in [`../ANTI_HALLUCINATION.md`](../ANTI_HALLUCINATION.md) by adding a complementary defense that operates across passes: historical-accuracy weighting that catches systematic agent drift over time. It is not a "layer" in the same defense-in-depth sense (it does not check the current pass), but it shares the same goal.
- Consumed by [`../QUALITY.md`](../QUALITY.md) (the deduction formula) and [`../../agents/pass-runner.md`](../../agents/pass-runner.md) (the orchestrator that recomputes the snapshot).
- The 0.75 default and the 30-day pending-outcome cutoff are codifications adopted by this system, flagged `[UNVERIFIED]` against any single named source.
