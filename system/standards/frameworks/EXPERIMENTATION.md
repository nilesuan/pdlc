# EXPERIMENTATION.md — Conditional escalation (A/B testing and product experimentation)

**Authoritative sources:** [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md) (rollout, canary, A/B); [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §Experimentation; [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4; [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md).

## Activation

Loaded when the brief contains any of: `A/B-test`, `experiment`, `hypothesis`, `primary-metric`, `hypothesis-ledger`, `holdout`.

When activated: `max_passes = 5` (escalated from default 3). Phases this can fire on: `discover` (when the riskiest-assumption test is an A/B), `ship` (rollout-vs-experiment scrutiny), `evolve` (post-launch hypothesis validation).

## What experimentation is for

An experiment exists to **answer a genuinely uncertain question with measurable user behaviour**. It is not a release strategy, not a rollout strategy, and not a substitute for shipping. The line is Fowler's: "canary releases detect problems, while A/B testing validates hypotheses — and should not be conflated." ([CanaryRelease — Martin Fowler](https://martinfowler.com/bliki/CanaryRelease.html), via [`../../../research/06-release/deployment-strategies.md`](../../../research/06-release/deployment-strategies.md) §2; verified.)

Wikipedia's working definition of A/B testing: "a user-experience research method involving randomized experiments with typically two variants to determine which performs better." ([A/B testing — Wikipedia](https://en.wikipedia.org/wiki/A/B_testing), via [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md) §A/B testing; verified.)

Two consequences:

1. **An experiment is not a deploy.** Shipping behind a flag does not make it an experiment. An experiment requires a hypothesis, a primary metric, a pre-declared sample size, and a stopping rule.
2. **Experimentation infrastructure ≠ rollout infrastructure.** They share feature flags (Hodgson's *experiment toggle* category — see [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md)) but they answer different questions.

## When to experiment vs ship-and-learn

From [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4:

**Experiment when:**

- Landing / onboarding variants where conversion is the metric.
- Pricing changes (treat cohort effects as known risk).
- Feature variants where the team does not know which is better.
- Algorithmic changes (search / ranking / recommendations) with a measurable behavioural metric.

**Do NOT experiment when:**

- It is an obvious bug fix — ship.
- It is a UI copy tweak on a low-traffic surface (insufficient power).
- It is a strategic pivot — strategy is commitment, not a variant split.
- It is a security or compliance change.
- The cost of running two variants exceeds the value of the answer.
- The change is not reversible (data migrations, destructive schema changes — see [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md)).

**Decision-reversibility heuristic.** If the change can be reverted by flipping a flag, ship-and-measure is often cheaper than a formal experiment. If reverting requires a redeploy or a data backfill, the experiment cost is justified by the safety. [SYNTHESIS, drawing on Hodgson 2017 and the handbook's experimentation pitfalls list.]

## Required artifacts

- **Hypothesis ledger entry** at `experiments/<exp-id>.md` (or the platform's experiment ID) — pre-registered before any traffic flows. All fields under [Pre-registration / hypothesis ledger](#pre-registration--hypothesis-ledger) populated.
- **Primary metric definition** with numerator / denominator / window — captured in the ledger entry.
- **Sample-size + stopping-rule record** — calculator inputs (baseline, MDE, alpha, power), computed N per variant, expected duration; filed before launch.
- **Outcome + decision entry** — appended to the same ledger entry after the run terminates: "ship A / ship B / no decision + next experiment".
- **Experiment-toggle cleanup ticket** — filed at flag creation with due date one cleanup window past the terminal decision (cross-ref [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md)).

## Hard rules

1. **Hypothesis written before the experiment is built.** Format: *"For \<audience\>, variant \<B\> will change \<primary metric\> by \<expected effect\> compared to \<A\>, because \<reasoning\>."* No hypothesis → no experiment.
2. **One primary metric, declared up front.** Secondary metrics may be tracked; the primary metric is what the decision is made on. Adding or swapping the primary metric mid-flight invalidates the run.
3. **Sample size and stopping rule pre-declared.** Use the platform's calculator; record the inputs (baseline rate, minimum detectable effect, significance level, power). Do not start the experiment without a written stopping condition.
4. **No peeking.** Do not call the result early because the dashboard "looks decisive." From the handbook: "Early stopping inflates false positives." ([`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §A/B testing.) The pre-registered stopping rule is the only allowable stop, except for guardrail/SRM aborts (below).
5. **Run to the pre-registered stopping condition** *or* abort cleanly with a documented reason (sample-ratio mismatch, instrumentation bug, kill-switch event, ethical concern). An aborted experiment is not "no result" — log it and re-run from a clean baseline.
6. **Experiment log entry mandatory.** Hypothesis, variants, primary metric, sample size and stopping rule, outcome, decision. No log entry → the experiment did not happen for organisational memory.
7. **Bury the lede in the registry, not the wiki.** The hypothesis ledger is the source of truth for "what we tried, what we learned, what we shipped." A scattered set of Slack threads is not a ledger.

## Pre-registration / hypothesis ledger

A pre-registration captures the experiment's design **before any data is collected**. It is the discipline that makes peeking, HARKing, and metric-swapping detectable.

Required fields per ledger entry:

| Field | Notes |
|---|---|
| ID | Stable identifier (e.g., `EXP-2026-014`). |
| Hypothesis | One sentence, in the format above. |
| Audience / unit of randomisation | User, session, account, etc. State which. |
| Variants | A (control) and B (treatment). Include the actual flag rule. |
| Primary metric | One. Include exact definition (numerator / denominator / window). |
| Secondary / guardrail metrics | Listed but not decision-bearing. |
| Sample size + inputs | Baseline, MDE, alpha, power; computed N per variant; expected duration. |
| Stopping rule | E.g., "stop at N=X per variant *or* T=14 days, whichever later." |
| Owner | Single person accountable for analysis and decision. |
| Status | Draft / running / stopped / shipped / killed. |
| Outcome + decision | Filled in after the run. |

The platform (GrowthBook / Optimizely / PostHog Experiments / LaunchDarkly / Statsig — same list as [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4) typically supplies most of this; the ledger is the index across platforms and across time. A spreadsheet works at small scale.

## Statistical pitfalls (named, not solved)

These pitfalls are real and named in the handbook's experimentation procedure. The standards file does **not** prescribe statistical thresholds beyond what the handbook captures; the experimentation platform's defaults are the operational source.

- **Peeking** — calling a result before reaching the pre-declared sample size. Inflates the false-positive rate above the nominal alpha. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.) Mitigation: pre-register the stopping rule and hold to it; or use a sequential-testing method that the platform explicitly supports.
- **Underpowered experiments** — declaring "no effect" from a sample too small to detect the effect that matters. "Absence of evidence ≠ evidence of absence." ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.) Mitigation: compute sample size before launch; if traffic is insufficient, do not run the experiment.
- **Sample-ratio mismatch (SRM)** — the assignment to A/B drifts from the configured split (e.g., 50/50 produces 47/53). A signal that the experiment is broken; results are not interpretable until SRM is resolved. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)
- **Novelty and seasonality effects** — short-window experiments overstate effects driven by curiosity or by a calendar event. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.) Mitigation: pre-register a minimum duration covering at least one weekly cycle; consider a holdout group for long-term effects (below).
- **HARKing** (Hypothesising After Results are Known) — generating the hypothesis from the same data that "tests" it. The pre-registered hypothesis is the safeguard. [SYNTHESIS — concept named generically; the handbook captures the practice via "hypothesis pre-registered" exit gate.] [UNVERIFIED] as a primary cited concept in the workspace research; flagged here so it is not load-bearing.
- **p-hacking / multiple comparisons** — running many cuts of the data until something crosses significance. Pre-registering the primary metric is the safeguard; secondary-metric findings are hypothesis-generating, not decision-bearing. [SYNTHESIS] [UNVERIFIED] as a primary cited concept in the workspace research; flagged here so it is not load-bearing.
- **A/B testing a bug fix.** Just ship. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)
- **A/B testing strategy.** Strategy is commitment, not a variant split. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)
- **No experiment log.** Same test run three times across years. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)

When a pitfall above is suspected mid-flight, the experiment is **paused and reviewed**, not silently corrected. The ledger entry records the pause and the resolution.

## Holdout groups

From [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §Holdout groups:

> "Hold back 5% of users who never see a new feature for 30–90 days. This catches long-term regressions short-window A/B tests miss: a feature that looks great in week one but drives slow disengagement over a quarter. At small scale, holdout groups are overkill; at 50+ engineers shipping weekly experiments, they are cheap insurance."

The holdout cohort is its own ledger entry; treat it like an experiment that runs in the background.

## Feature flags as experimentation infrastructure

Hodgson's *experiment toggle* is the relevant category. See [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) for the canonical taxonomy; do not duplicate it here.

Operational rules specific to experiment toggles:

1. **Experiment toggles are short-lived.** They die with the experiment. Closing the experiment without removing the toggle is debt.
2. **Do not reuse a release toggle as an experiment toggle.** Categories collapse and ownership is lost. ([`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) §Anti-patterns.)
3. **Targeting must be deterministic per unit of randomisation.** A user assigned to B in session 1 sees B in session 2. SRM hunts assume this.
4. **Default state is the safe state** — typically the control. ([`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) §Pass-by-pass checks.)
5. **Kill switch is mandatory.** Shipping the flag without a tested off-path is a `major` finding under the FEATURE_FLAGS rubric.

The experiment ends in one of three terminal states: **ship A**, **ship B**, **no decision + next experiment**. In all three, the toggle is removed within the cleanup window defined for experiment toggles.

## Cross-links

- **Rollout vs. experiment.** Gradual rollout (canary, percentage, ring) lives in [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md) §Deployment strategies and §Feature flags. A rollout is *not* an experiment unless it has a pre-registered hypothesis and primary metric.
- **Post-experiment analysis.** Long-term effect tracking and roadmap evolution live in [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §Roadmap evolution and §Continuous improvement.
- **Discovery-phase hypotheses.** Upstream framing of *what is worth experimenting on* lives in [`../../../research/01-ideation/discovery.md`](../../../research/01-ideation/discovery.md) (Lean Startup Build–Measure–Learn, Cagan four risks).
- **Continuous delivery substrate.** The pipeline and rollback discipline experiments rely on lives in [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md).

## Auto-rejection (used by experimentation reviewer)

| Trigger | Severity |
|---|---|
| Experiment running without a ledger entry | Major |
| Experiment running without a written hypothesis | Major |
| More than one primary metric, or primary metric changed mid-flight | Major |
| Sample size / stopping rule not pre-declared in the ledger | Major |
| Result called before the pre-registered stopping condition (no SRM / kill-switch reason logged) | Major (peeking) |
| Decision made on a secondary metric without re-running with that as primary | Major (HARKing/p-hacking risk) |
| Experiment toggle still live > cleanup window after a terminal decision | Major (per [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md)) |
| "A/B test" of a bug fix, security change, or compliance change | Blocker (category error) |
| Experiment with no kill switch | Major (per [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md)) |
| Underpowered experiment declared "no effect" without an explicit power calculation | Major |

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Hypothesis & framing | Pre-registered hypothesis present; primary metric named with exact definition; this is not a category-error (bug fix, strategy, security/compliance change) |
| 2 | Power & duration | Sample size and stopping rule pre-declared; calculator inputs recorded; expected duration covers ≥ one full weekly cycle |
| 3 | Run integrity | No peeking (no result called before pre-registered stop); SRM check passed; no mid-flight primary-metric swap; experiment toggle has a tested kill switch |
| 4 | Decision discipline | Outcome and decision recorded in the ledger; secondary-metric findings explicitly labeled hypothesis-generating, not decision-bearing |
| 5 | Cleanup | Experiment toggle removed within the cleanup window after the terminal decision; ledger entry closed; learnings cross-referenced into the next discovery cycle |

## Anti-patterns to flag

- **"Let's just turn it on for 10% and see."** That's a rollout, not an experiment. If a hypothesis-led answer is wanted, write the hypothesis. ([`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md) §A/B testing.)
- **Dashboard-driven decisions.** Treating the platform's default dashboard as ground truth without understanding what the stats actually compute. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)
- **The hypothesis is "users will like it more."** Not measurable; not a hypothesis. Replace with a primary metric and an effect size.
- **Experiment as theatre.** Running an A/B test on a change leadership has already decided to ship. The result is ignored either way; the experiment burns sample size and credibility.
- **The "winning" variant has SRM.** A statistically-significant result on a broken assignment is not a result.
- **Forever-running experiment.** No stopping rule was set; the toggle has been at "running" for a year. Either ship a winner or kill the experiment.
- **Hypothesis ledger as archaeology.** The ledger exists but is not read at the start of new experiments. Same test run three times across years. ([`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 pitfalls.)

## Escalation impact

- `max_passes = 5` (escalated from default 3).
- Frequently activated alongside [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) — when both fire, FEATURE_FLAGS' kill-switch / cleanup-deadline rules apply to the experiment toggle on top of this framework's rules.
- Auto-rejection rules above produce hard findings (`major` or `blocker`); the cross-verifier confirms each before scoring. A category-error A/B test (bug fix / security / compliance) is a non-overridable `blocker`.

## Sources

- Pete Hodgson, "Feature Toggles" (martinfowler.com, 2017) — toggle taxonomy; via [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) and [`../../../research/06-release/feature-flags.md`](../../../research/06-release/feature-flags.md).
- Danilo Sato, "Canary Release" (martinfowler.com, 2014); Martin Fowler, "Dark Launching" (2020) — separation of canary, dark launch, and A/B; via [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md) and [`../../../research/06-release/deployment-strategies.md`](../../../research/06-release/deployment-strategies.md).
- Wikipedia, "A/B testing" — working definition; via [`../../../research/05-testing/chaos-and-production-testing.md`](../../../research/05-testing/chaos-and-production-testing.md).
- Handbook: [`../../../handbook/06-ship.md`](../../../handbook/06-ship.md), [`../../../handbook/08-evolve.md`](../../../handbook/08-evolve.md), [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 (operational A/B procedure).
- Workspace standards: [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md), [`../release/CONTINUOUS_DELIVERY.md`](../release/CONTINUOUS_DELIVERY.md).

## Open questions

- **Primary citations for HARKing and p-hacking.** Both concepts are widely used in research integrity literature, but no primary source has been fetched into the workspace research. They are flagged `[UNVERIFIED]` here so they are not load-bearing — the operational protections (pre-registered hypothesis, single primary metric) are what the standard enforces, regardless of label.
- **Sequential testing / always-valid inference.** Some platforms (notably Optimizely Stats Engine, Statsig) advertise "peeking-safe" methods. The handbook does not cite their primary methodological references; treat platform claims as platform claims until those references are added to research.
- **Ronny Kohavi and the Microsoft / *Trustworthy Online Controlled Experiments* canon.** Frequently cited as the primary literature for industrial A/B testing discipline; not yet in workspace research. Adding a verified summary would let the file move several `[UNVERIFIED]` items to `[VERIFIED]`.
- **Specific sample-size and traffic-floor numbers.** The "~1000 conversions per variant for 1–3% effects" rule of thumb in [`../../../handbook/08-evolve-processes.md`](../../../handbook/08-evolve-processes.md) §4 is a heuristic, not a sourced threshold; the standards file deliberately defers actual numbers to the platform's sample-size calculator rather than reproducing the heuristic as a rule.
