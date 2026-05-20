# QUALITY.md — Pass scoring rubric

This file defines how the pass-runner scores a pass. The score determines whether the work passes the quality gate (≥85/100) or triggers a retry.

---

## The scoring model

Every pass starts at **100**. Each surviving finding deducts points proportional to (severity weight × calibrated confidence). The pass passes if the final score is **≥ 85**.

### Severity weights

| Severity | Weight |
|---|---|
| blocker | 30 |
| major | 10 |
| minor | 3 |
| nit | 1 |
| info | 0 |

### Per-finding deduction

```
deduction_per_finding = severity_weight × (calibrated_confidence / 100)
```

`calibrated_confidence` = `adjusted_confidence × historical_accuracy[prefix]`, where `adjusted_confidence` is the cross-verifier's output (default = original confidence; raised up to +10 on especially strong CONFIRMED, lowered per the protocol-specific deltas on DOWNGRADED), and `historical_accuracy[prefix]` comes from `cdocs/review-calibration/calibration.json` (default 0.75 if no entry). Full formula and bootstrap rules in [`process/CALIBRATION.md`](process/CALIBRATION.md).

### Aggregate formula

```
score = max(0,
            100
            - sum(per_finding_deductions)
            - 5 × auto_rejected
            - 5 × xv_rejected
            - 2 × xv_downgraded
            + bonus)
```

The `auto_rejected`, `xv_rejected`, `xv_downgraded`, and `broken_links` deductions are sourced from the unified protocol in [`ANTI_HALLUCINATION.md`](ANTI_HALLUCINATION.md) (the hallucination KPIs section).

`bonus` is at most +5 and is awarded by the pass-runner when:
- The work resolves a `blocker` from the previous pass (+5, max once per pass).
- (No other bonuses. We don't reward style.)

A score below 0 is reported as 0; we don't track negative scores.

---

## Critical override

Any finding where `severity == blocker` AND `calibrated_confidence ≥ 80` forces the pass score to **0** regardless of the rest of the math, and the pass fails. This is non-negotiable.

Why: a high-confidence blocker is, by construction, a ship-stopper. Letting it be averaged out by lower-severity arithmetic would defeat the gate. The override matches the predecessor's `~/.claude.old/standards/QUALITY.md` "Critical path enforcement" + `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4d.

---

## Severity-gated minimum confidence

A finding's confidence must clear the floor for its severity, or the finding is auto-rejected by the pass-runner before scoring. (Same table as [`EVIDENCE.md`](EVIDENCE.md) §"Severity-gated minimum confidence".)

| Severity | Min confidence |
|---|---|
| blocker | ≥ 80 |
| major | ≥ 70 |
| minor | ≥ 60 |
| nit | ≥ 50 |
| info | ≥ 30 |

Below-threshold findings count as `auto_rejected` (-5 each) per [`EVIDENCE.md`](EVIDENCE.md) trigger 9.

---

## What counts as a "pass"

A pass = one cycle of: spawn sub-agents → collect findings → cross-verify → score.

The default policy is **3 passes**. The work is "done" when one of:

1. A pass returns score ≥ 85 with no `blocker` findings outstanding.
2. The 3rd pass (or 5th, if escalated) completes and we hand the result to the user — even if score < 85, the user decides whether to keep iterating manually.

Escalation to **5 passes** is triggered by [`frameworks/OPTIONAL_FRAMEWORKS.md`](frameworks/OPTIONAL_FRAMEWORKS.md) — security-sensitive code (STRIDE), legacy refactor (characterization), public API changes (contracts), feature-flagged rollouts, hot-path perf, external-service availability, and entry-point composition wiring.

---

## Severity examples

To keep severity assignments calibrated, here are anchor examples per phase:

### Phase 04 (Build)

| Severity | Example |
|---|---|
| blocker | SQL injection in query builder; commit to main without PR; secret committed to repo; failing test not updated; type error left in code |
| major | Missing test for new public function; PR > 400 lines without reviewer comment trail; public API change without deprecation note; circular import |
| minor | Function > 50 lines that could be split; magic number not named; inconsistent error-message format |
| nit | Comment typo; unused import that lint missed; non-idiomatic but functional code |

### Phase 06 (Ship)

| Severity | Example |
|---|---|
| blocker | Pipeline rebuilds image on promotion (violates immutable promotion); `terraform apply --auto-approve` to prod; main auto-deploys to prod (must be manual); rollback path absent |
| major | Pipeline doesn't run security scan; deploy notification absent; canary stage missing for risky change |
| minor | Build cache not used; pipeline takes > 15 min |
| nit | Job name not in convention |

### Phase 07 (Run)

| Severity | Example |
|---|---|
| blocker | No SLO defined for a user-facing endpoint; no alert wired for 5xx rate; on-call runbook missing for declared severity |
| major | SLO target not measurable from current metrics; alert routes to a person, not a rotation; postmortem template missing the Five Whys |
| minor | Dashboard widget not labeled; runbook references decommissioned tool |
| nit | Markdown table misformatted in runbook |

The full anchor table per phase is built into each agent's prompt.

---

## Coverage gate (Phase 04 / 05 specific)

For code work, the pass-runner additionally checks:

| Coverage scope | Minimum | Source |
|---|---|---|
| Lines, project-wide | 80% | local team default |
| Branches, project-wide | 70% | local team default |
| Lines, files matching `**/crypto/**`, `**/auth/**`, `**/billing/**` | 95% | risk-weighted critical paths |
| Mutation score, project-wide (if mutation testing configured) | 60% | secondary signal |

A pass that drops coverage by >2% on any axis without an offsetting gain produces a `major` finding.

The 80% baseline matches the handbook's recommendation in [`../../handbook/05-test.md`](../../handbook/05-test.md) (read at runtime by the qa-engineer agent). The 95% for crypto/auth/billing comes from the same chapter's "weight by risk, not by file count" guidance.

---

## What is NOT scored

The pass score does **not** include:

- Aesthetic preferences ("I'd have written it differently")
- Speculative future scenarios ("what if we add 100x users")
- Off-scope concerns ("this whole module should be rewritten")

Off-scope observations are filed under `out-of-scope-observations` (see [`AGENT_PREAMBLE.md`](AGENT_PREAMBLE.md)) and don't affect the score.

---

## Worked example

A `/build` pass on a small feature returns three findings, all CONFIRMED by the cross-verifier (so `adjusted_confidence` = original `confidence`), with no per-prefix history yet (so `historical_accuracy[prefix]` = `_default` = 0.75 for every prefix):

```yaml
findings:
  - id: BUILD-TDD-01
    severity: blocker
    confidence: 90
    # adjusted_confidence: 90  (CONFIRMED, no change)
    # calibrated_confidence: 90 × 0.75 = 67.5
    # severity_weight: 30
    # deduction: 30 × 0.675 = 20.25

  - id: BUILD-SOLID-02
    severity: minor
    confidence: 65
    # calibrated_confidence: 65 × 0.75 = 48.75
    # severity_weight: 3
    # deduction: 3 × 0.4875 = 1.46

  - id: SEC-INPUT-01
    severity: major
    confidence: 75
    # calibrated_confidence: 75 × 0.75 = 56.25
    # severity_weight: 10
    # deduction: 10 × 0.5625 = 5.625

cross_verifier:
  confirmed: 3
  downgraded: 0
  rejected: 0

auto_rejected: 0
```

Score:

```
100 - 20.25 - 1.46 - 5.625 - 0 - 0 - 0 + 0 = 72.665 → 72 (rounded down)
```

Critical-override check: `BUILD-TDD-01` is a `blocker` with `calibrated_confidence = 67.5`, which is **below** the 80 threshold, so the override does not fire. (If `BUILD-TDD-01` had `confidence: 100` and the prefix had `accuracy: 0.85`, calibrated_confidence would be 85, the override would fire, and score would be forced to 0.)

Score 72 is below the 85 gate → pass-runner retries with the findings as feedback.

After fixing on next pass, only one nit remains:

```yaml
findings:
  - id: BUILD-DOCS-01
    severity: nit
    confidence: 60
    # calibrated_confidence: 60 × 0.75 = 45
    # deduction: 1 × 0.45 = 0.45
```

Score:

```
100 - 0.45 = 99.55 → 99  → passes
```

---

## Sources

- The 85/100 threshold is calibrated from observed pass histories in `~/.claude.old/cdocs/` (see analysis in [`../../SYSTEM.md`](../../SYSTEM.md), section on "Notable design decisions"); the dogfooding evidence showed 85 separates "ship-ready" from "needs another loop" cleanly.
- The confidence-weighted scoring + per-prefix calibration model is ported from `~/.claude.old/standards/QUALITY.md` and `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4d. The original numeric severity weights (critical=25, high=15, medium=8, low=3, info=0) were rebalanced to match this system's vocabulary (blocker=30, major=10, minor=3, nit=1, info=0).
- The critical-override rule (blocker AND calibrated_confidence ≥ 80 → score = 0, pass fails) is ported from `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4d "Critical override".
- The coverage thresholds reference the handbook's [`05-test.md`](../../handbook/05-test.md) (line numbers may shift; the qa-engineer reads at runtime).
- The "what is not scored" section reflects the handbook's pervasive distinction between *prescription* and *opinion* (see [`../../handbook/README.md`](../../handbook/README.md), "Conventions").
- Hallucination-related deductions (`auto_rejected`, `xv_rejected`, `xv_downgraded`, `broken_links`) are defined in [`ANTI_HALLUCINATION.md`](ANTI_HALLUCINATION.md).
- Per-prefix calibration formula and recomputation cadence: [`process/CALIBRATION.md`](process/CALIBRATION.md).
