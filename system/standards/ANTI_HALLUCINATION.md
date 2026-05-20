# ANTI_HALLUCINATION.md — The unified protocol

This file is the canonical, single-page index of every anti-hallucination control in the system. Controls are scattered across the root research rules, the global rules, the per-agent preamble, the evidence schemas, and the cross-verifier; this file names them, orders them as defense-in-depth, and adds the missing layer that verifies authored Markdown artifacts before they leave the workspace. If a rule here conflicts with another standard, that standard wins for its domain — but the layering and the KPIs below are authoritative.

---

## The protocol in three lines

1. **Cite or tag.** Every factual claim carries an inline citation OR one of `[VERIFIED]` / `[UNVERIFIED]` / `[SYNTHESIS]` / `[CONTESTED]` / `[OUT OF DATE]`. No untagged unsourced assertions. (See [`../../CLAUDE.md`](../../CLAUDE.md) §4.)
2. **Verify before claiming.** Read the file, fetch the URL, run the command — *in this session*. Memory of training data is not evidence. (See [`../CLAUDE.md`](../CLAUDE.md) §1 Truthfulness, §2 Verification.)
3. **Cross-check before scoring.** Findings pass through the cross-verifier; authored artifacts pass through the pre-output gate; auto-rejection deducts. (See [`../agents/cross-verifier.md`](../agents/cross-verifier.md), [`EVIDENCE.md`](EVIDENCE.md) auto-rejection triggers, and §"Pre-output gate" below.)

---

## Defense-in-depth: the six layers

The system layers six independent controls so a hallucination must defeat all of them to reach the user. Each layer is owned by an existing artifact (or, for layer 6, the new artifact below).

### Layer 1 — Source rules (research-level)

Defined in [`../../CLAUDE.md`](../../CLAUDE.md) §§1–4: facts only, no fabrication, sources mandatory, verify before citing, primary-vs-secondary source ranking, the five uncertainty tags. This is the *content* layer — it governs what may be written into any research document.

### Layer 2 — Global rules (session-level)

Defined in [`../CLAUDE.md`](../CLAUDE.md) §1 Truthfulness and §2 Verification: never assert unverified facts, never invent identifiers, quote verbatim when accuracy matters, match the source's confidence, read before editing, cross-verify load-bearing claims. This is the *behavioral* layer — applies to every Claude Code session running this system, regardless of agent role.

### Layer 3 — Per-agent preamble (agent-level)

Defined in [`AGENT_PREAMBLE.md`](AGENT_PREAMBLE.md): every agent acknowledges that evidence is non-negotiable, must produce findings (not prose), and must calibrate confidence (`high` requires direct evidence; tempted-to-write-high-without-it → lower it). Each specialist agent loads this file at the top of its prompt.

### Layer 4 — Evidence schemas (finding-level)

Defined in [`EVIDENCE.md`](EVIDENCE.md): three claim schemas (code-finding, factual-assertion, design-claim) plus the eight auto-rejection triggers (missing location, empty excerpt, restated claim, weasel grounding, impossible location, dead source, fabricated quote, severity gaming). The pass-runner runs these checks structurally; failed findings deduct `-5` per [`QUALITY.md`](QUALITY.md).

### Layer 5 — Cross-verifier (re-read sources)

Defined in [`../agents/cross-verifier.md`](../agents/cross-verifier.md): always opus, runs after every pass, re-reads each cited source — file, URL, doc — and votes `CONFIRMED` / `DOWNGRADED` / `REJECTED` per the three-protocol split (one protocol per evidence schema). This is the highest-leverage hallucination control documented; it does not evaluate claim correctness, only that evidence exists and supports the claim.

### Layer 6 — Pre-output artifact verification (NEW)

Defined in §"Pre-output gate" below. Implemented by [`../scripts/verify-artifact.sh`](../scripts/verify-artifact.sh). Runs on every authored Markdown artifact before the pass-runner reports completion. Closes the gap between layer 5 (which verifies *findings*) and the artifact the user will actually read (ADR, runbook, problem statement, design doc).

### Complementary defense — historical-accuracy calibration

[`process/CALIBRATION.md`](process/CALIBRATION.md) is a complementary defense that operates **across passes**, not within a single pass. It is not a "layer" in the same defense-in-depth sense — it does not check the current pass's findings; it weights them by past accuracy — but it shares the same anti-hallucination goal. After every 5 resolved-outcome rows in `cdocs/review-calibration/history.jsonl`, the pass-runner recomputes `cdocs/review-calibration/calibration.json` so each prefix's confidence is multiplied by its historical acceptance rate before the QUALITY.md scoring formula consumes it. This catches systematic agent drift that single-pass verification cannot — an agent whose findings are individually well-evidenced but consistently wrong over time will see its weight decay automatically. Cross-referenced from [`QUALITY.md`](QUALITY.md) (the formula consumes it) and [`../agents/pass-runner.md`](../agents/pass-runner.md) (the orchestrator that recomputes the snapshot).

---

## Pre-output gate

### When this layer fires

Any pass that produces an authored Markdown artifact triggers the gate. Artifact locations include (non-exhaustive):

- `cdocs/` — pass-runner's default output location (per [`../CLAUDE.md`](../CLAUDE.md) §3).
- `discovery/<slug>/` — Phase 01 problem statements and discovery docs.
- `docs/adr/` — architecture decision records (Phase 03).
- `docs/runbooks/` — operational runbooks (Phase 07).
- Any other `.md` deliverable named in the calling command's brief.

The gate runs once per artifact, after the cross-verifier has voted on findings and before the pass-runner emits its final summary.

### What it checks

The script `verify-artifact.sh <path>` performs four checks against a single Markdown file:

1. **Relative-link resolution.** Every Markdown link `](X)` where `X` is not `http(s)://...`, `mailto:...`, or a pure anchor (`#section`) is resolved against the file's directory. Each broken link is reported with its original text and the resolved absolute path.
2. **External-URL listing.** Every `http(s)://...` URL is extracted and printed. The gate does not fetch URLs — that is the cross-verifier's protocol-2 job. The list flows back to the cross-verifier for follow-up if it has not already covered that URL.
3. **Uncertainty-tag tally.** Counts of `[VERIFIED]`, `[UNVERIFIED]`, `[SYNTHESIS]`, `[CONTESTED]`, `[OUT OF DATE]` are reported.
4. **Machine-readable footer.** A single line `RESULT broken=N external_urls=N verified=N unverified=N synthesis=N contested=N out_of_date=N` for the pass-runner to parse.

The script exits `0` if no broken relative links, `1` if any are broken, `2` if invoked incorrectly. See the script header for the canonical contract.

### How the pass-runner uses the result

- `broken > 0` → automatically add a `blocker` finding (`PRE-OUT-LINK-01`) to the pass with each broken link's location; this is non-overridable.
- `external_urls` count and tag tallies → included in the pass summary so the user sees the citation density at a glance.
- `unverified / (verified + unverified + synthesis + contested + out_of_date)` ratio above the configurable `PDLC_UNVERIFIED_RATIO_MAX` (default `0.3`) → add a `major` finding (`PRE-OUT-UNVER-01`) requesting either citations or removal of unverified claims.

### Why this matters

The cross-verifier verifies the *findings* sub-agents produce. It does not inspect the *artifacts* those sub-agents author. A code-reviewer finding says "the deploy doc is missing rollback steps" — the cross-verifier confirms the doc says what the finding claims. But when the systems-architect *writes* a new ADR with three internal links and two external citations, no existing layer mechanically checks those links resolve and those tags are present. Without this gate, a hallucinated relative link inside an authored artifact reaches the user unchecked. Layer 6 closes that gap with a deterministic, sub-second check.

---

## Hallucination KPIs

The pass-runner surfaces these counts in every final summary so the user can see the protocol's signal at a glance:

- **`auto_rejected`** — count of findings that failed [`EVIDENCE.md`](EVIDENCE.md)'s eight triggers structurally (deduction `-5` each per [`QUALITY.md`](QUALITY.md)).
- **`xv_rejected`** — count of cross-verifier `REJECTED` votes (deduction `-5` each).
- **`xv_downgraded`** — count of cross-verifier `DOWNGRADED` votes (deduction `-2` each).
- **`broken_links`** — count from the pre-output gate's `RESULT` footer, summed across all artifacts in the pass.
- **`unverified_ratio`** — `unverified / (verified + unverified + synthesis + contested + out_of_date)` per artifact, plus pass-level mean.
- **`hallucination_deduction_total`** — sum of `-5 × auto_rejected + -5 × xv_rejected + -2 × xv_downgraded`. Reported alongside the `score_breakdown` block from [`../agents/pass-runner.md`](../agents/pass-runner.md).

These are reporting fields, not gates. The gates are below.

---

## Escalation

When KPIs cross thresholds, the pass-runner escalates beyond normal scoring:

- **`broken_links ≥ 3` in a single artifact** → pass fails regardless of score; the user is notified before any retry. Three broken relative links in one document is no longer a fixable typo — it indicates the agent did not read the files it linked to.
- **`xv_rejected ≥ 5` in one pass** → the pass-runner refuses to retry without the user reading the rejection notes. A pattern this dense signals a systemic source-fabrication problem; iterating without human review will compound it.
- **`unverified_ratio > 0.3` in a single authored artifact** → adds a `major` finding requesting either citations or omission of unverified claims; does not auto-fail but counts `-10` toward the score.

Escalation overrides the normal "≥85 passes" rule: the gate fires first.

---

## When verification cannot complete

Verification will sometimes hit walls. The protocol is:

- **Paywalled or login-gated URL** — the cross-verifier votes `DOWNGRADED` with `unverifiable: true` and a reason (per [`../agents/cross-verifier.md`](../agents/cross-verifier.md) §"When you can't verify"). Do not REJECT for inability to reach a real source.
- **Network error fetching a real URL** — same as paywall: `DOWNGRADED + unverifiable: true`. The pass continues.
- **File not yet committed** — if a finding cites a path that exists in the working tree but not in the index, the cross-verifier reads the working-tree file. If it does not exist on disk, REJECT.
- **Pre-output gate cannot read the artifact** — the script exits `2`; the pass-runner records this as a hard blocker and asks the user to confirm the artifact path. Do not skip the gate to "make the pass green."

Inventing a vote is forbidden. The system tolerates "I genuinely cannot tell" (`vote: UNKNOWN` in the cross-verifier; `unverifiable: true` on a finding) far better than a false confirmation.

---

## Sources

- [`../../CLAUDE.md`](../../CLAUDE.md) — root research rules; the dominant theme is anti-hallucination (§§1–4 explicitly: core principles, anti-hallucination rules, source rules, uncertainty tags).
- [`../CLAUDE.md`](../CLAUDE.md) — global rules; §1 Truthfulness and §2 Verification are the per-session non-negotiables this protocol indexes.
- [`AGENT_PREAMBLE.md`](AGENT_PREAMBLE.md) — per-agent loadable preamble; codifies "evidence is non-negotiable" and the confidence-calibration rule.
- [`EVIDENCE.md`](EVIDENCE.md) — the three claim schemas and the eight auto-rejection triggers; layer 4.
- [`QUALITY.md`](QUALITY.md) — pass scoring; the deduction weights this protocol's KPIs sum.
- [`../agents/cross-verifier.md`](../agents/cross-verifier.md) — layer 5; three protocols, vote semantics, calibration table, "when you can't verify" guidance.
- [`../agents/pass-runner.md`](../agents/pass-runner.md) — orchestrator; consumes the pre-output gate's result and surfaces the KPIs.
- [`../scripts/verify-artifact.sh`](../scripts/verify-artifact.sh) — layer 6 implementation.
- [`process/CALIBRATION.md`](process/CALIBRATION.md) — complementary across-passes defense; per-prefix historical-accuracy weighting.
