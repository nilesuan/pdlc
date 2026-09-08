# PROBABILISTIC_COMPONENTS.md — Conditional escalation (testing models, LLMs, OCR, and other nondeterministic components)

**Authoritative sources:** [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) (suite shape, test-double discipline); [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) (the bake-off that chose the component, and the harness it leaves behind); [`EXPERIMENTATION.md`](EXPERIMENTATION.md) (pre-registration, one primary metric, no peeking); [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md) (production drift signal); [`../EVIDENCE.md`](../EVIDENCE.md) (claim schemas).

## Activation

Loaded when the brief contains any of: `LLM`, `model`, `OCR`, `embedding`, `classifier`, `extraction`, `transcription`, `nondeterministic`, `probabilistic`, `prompt`, `inference`, `RAG`.

When activated: `max_passes = 5` (escalated from default 3). Phases this can fire on: `solve` (the bake-off and its promoted harness), `build` (the component being wired in), `test` (suite audit), `run` (production drift).

## What makes these components different

An ordinary unit test asserts a value. `parse("2024-01-01")` returns that date or the test fails, and a failure means the code is wrong.

A probabilistic component breaks both halves of that. The same input can produce different output across runs, and a single wrong output does not mean the component is broken — it may be operating exactly as measured. Correctness is a property of a distribution over a corpus, not of any one call.

Applying deterministic test discipline anyway produces the two failure modes this framework exists to prevent:

- **Assert-the-string.** A test pins one exact output. It passes on the day it is written and fails on every harmless rewording thereafter, so the team deletes it or pins the model so hard the test proves nothing.
- **No test at all.** "You can't unit-test an LLM" becomes the reason a component with no measured accuracy ships into a path that matters.

Both are avoidable. The component is measurable; it is just measured differently.

## Separate the two test surfaces

Never mix these in one test. Most of the value is in the first, and most of the cost is in the second.

| Surface | What it covers | How it is tested | Cost |
|---|---|---|---|
| **Deterministic shell** | Routing, retries, timeouts, parsing the response, schema validation, error handling, fallback paths, prompt assembly, token accounting, the human-review queue | Ordinary unit tests with a **fake** returning canned responses (per [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) preference for fakes over mocks) | Free. Runs on every commit. |
| **Model behaviour** | Does the component produce acceptable output on real input | Corpus evaluation against pre-registered thresholds | Real money and minutes. Tiered (below). |

The shell is where most bugs actually live: a malformed response that crashes the parser, a timeout that silently returns empty, a retry that double-charges. Those are deterministic bugs in deterministic code and they deserve ordinary tests. Test them with a fake, and include fakes that return malformed, empty, truncated, and rate-limited responses. A team that jumps straight to corpus evaluation ships a component that is accurate and crashes on the first 503.

## Pin what you can, and do not mistake it for determinism

Set the model version explicitly, never a floating alias. Set temperature to 0 and a fixed seed where the provider supports them.

This narrows variance. It does not remove it, and it must not be treated as though it did:

- Temperature 0 is not deterministic across provider infrastructure changes, batching, or hardware.
- A pinned version is deprecated on the provider's schedule, not yours.
- A provider can change a model's behaviour behind a stable name.

So: pin, and still gate statistically. A suite whose passing depends on bit-identical model output is measuring the provider's stability, not your correctness.

**Every model version is a pinned dependency.** Record it where dependencies are recorded. Changing it re-runs the full corpus and must clear the same gates as the original selection. An unreviewed provider-side model change is a production risk, and the corpus run is what detects it.

## The ground-truth corpus

The corpus is the fixture. Everything else depends on it being honest.

- **Stratified by input class.** Whatever dimension makes inputs hard (document type, source system, language, scan quality, length, edge formatting) becomes a stratum with its own minimum count. A corpus that is 90% easy cases produces a number that describes nothing.
- **Hand-labelled by a person**, or derived from an authoritative record. Never labelled by the model under test, and never by a sibling of it. Labelling the corpus with the thing you are grading is circular and the resulting score is meaningless.
- **Versioned.** In the repo where size permits; otherwise a pointer plus a content hash, so a silently-changed corpus is detectable. A score is only comparable across time if the corpus is the same corpus.
- **Growable, append-only in practice.** Every production failure that reaches a human becomes a corpus entry. Removing an entry because it is failing is the single most damaging thing anyone can do here, and it should require the same review as deleting a test.
- **Held-out slice.** Keep a portion the prompt and configuration were never tuned against. Iterating a prompt against the whole corpus overfits to it, and the score stops predicting production.

## Gate on metrics, not on values

Per input class, declare in advance:

| Field | Notes |
|---|---|
| Primary metric | One, with exact definition. Character error rate, field-level recall, classification F1, whatever decides |
| Threshold | The number that must be met |
| Tolerance band | Expected run-to-run spread. A result inside the band is not a regression |
| Sample size | How many corpus items. Enough that the band is narrower than the effect you care about |
| Guardrails | Cost per item, p95 latency, refusal rate. Tracked, not decision-bearing |

Thresholds are declared before results, and a threshold lowered after a failing run is a blocker, not a fix. This is [`EXPERIMENTATION.md`](EXPERIMENTATION.md) §"Hard rules" applied to a corpus run, and the same reasoning holds: a threshold set after seeing the number measures nothing.

**Segment, or the aggregate lies.** Report and gate per class. A 94% aggregate that hides one class failing at 40% is the normal way this goes undetected, because the failing class is usually the rare, important one.

## Flake versus variance

A probabilistic test that fails intermittently is not automatically flaky. Tell the two apart before quarantining anything:

1. Repeat the run N times on the same corpus slice.
2. Measure the spread of the primary metric.
3. If the spread is within the declared tolerance band, an occasional threshold miss is **variance**: the band or the sample size is wrong, not the component. Widen the sample until the band is narrower than the effect you care about.
4. If the spread exceeds the band, something in the shell is genuinely nondeterministic beyond the model, or the sample is too small to measure anything. Fix that before trusting any number from this gate.

Quarantining a probabilistic gate as "flaky" without doing this is how a component silently degrades for a quarter. [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) flake-quarantine rules apply to the deterministic shell; they do not license muting a corpus gate.

## Tier the gates by cost

Corpus evaluation costs money and wall-clock per run, so it cannot run on every push. Declare the tiers explicitly:

| Tier | When | Scope | Blocks |
|---|---|---|---|
| Shell tests | Every commit | Deterministic surface, fakes only | Yes |
| Smoke corpus | Every PR | Small stratified subset, one item per class minimum | Yes |
| Full corpus | Nightly, and on any model-version or prompt change | Everything, all classes | Yes on the change that triggered it |
| Held-out | Pre-release | The never-tuned-against slice | Yes |

A model-version bump or prompt edit that does not trigger the full corpus is the gap through which regressions ship. Wire the trigger on the file path, not on the author remembering.

## Production drift

Offline accuracy decays as real input drifts from the corpus. Per [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md):

- Sample production inputs and outputs at a declared rate. Respect the data-handling constraints recorded in the selection ADR; sampling regulated content into a log is its own incident.
- Track the primary metric where ground truth is recoverable (a human corrected it, a downstream system rejected it, the user re-did the task).
- Alert on the metric crossing the threshold, and on the **human-review queue depth**, which moves first and is usually cheaper to instrument.
- Feed corrected production failures back into the corpus.

The human-review queue is part of the design, not an admission of failure. Below-threshold outputs route to a person; the threshold that routes them is the same one the gate uses. A component with no review path has silently decided that its error rate is acceptable to whoever receives the output.

## Required artifacts

A pass that touches a probabilistic component must produce, before scoring proceeds:

- **Corpus manifest** at `eval/<component>/corpus.md`: strata, counts per stratum, labelling provenance, version or content hash, held-out slice.
- **Threshold register** at `eval/<component>/thresholds.md`: per class, the primary metric definition, threshold, tolerance band, sample size, guardrails. Dated before the first run.
- **Run records** at `eval/<component>/runs/<date>-<version>.md`: model version, corpus version, per-class results, verdict.
- **Gate wiring**: the CI job, its tier, and what it blocks.
- **Fakes** covering malformed, empty, truncated, and error responses on the deterministic shell.

## Pass-by-pass checks

| Pass | Check |
|---|---|
| 1 | Are the two surfaces separated, is the shell tested with fakes including failure responses, and is the model version pinned and recorded as a dependency? |
| 2 | Is the corpus stratified, human-labelled, versioned, and held-out-sliced? Are thresholds dated before the first run, per class, with tolerance bands and sample sizes? |
| 3 | Are gates tiered and wired, does a model-version or prompt change trigger the full corpus, and does drift monitoring plus a human-review queue exist with an owner? |

## Auto-rejection

| Trigger | Severity |
|---|---|
| Probabilistic component in a correctness-bearing path with no corpus evaluation | Blocker |
| Threshold lowered or tolerance band widened after a failing run | Blocker |
| Corpus labelled by the model under test, or by a sibling model | Blocker (circular; the score is meaningless) |
| Corpus entry removed because it was failing | Blocker |
| Model version floating (alias, "latest", unpinned) | Major |
| Model-version or prompt change that does not trigger the full corpus | Major |
| Gate reported as an aggregate with no per-class segmentation | Major |
| Exact-string assertion on model output | Major (will be deleted or will pin the model into meaninglessness) |
| Deterministic shell untested, or tested only through live model calls | Major |
| No tolerance band declared, so variance is indistinguishable from regression | Major |
| Corpus gate quarantined as flaky without the repeat-N spread analysis | Major |
| No held-out slice; prompt tuned against the whole corpus | Major (overfitted; score no longer predicts production) |
| No human-review path for below-threshold output | Major |
| Corpus unversioned, so scores are not comparable across time | Minor |
| Production drift unmonitored | Minor (major once the component is in a revenue or compliance path) |

## Anti-patterns

- **LLM-as-judge as the only gate.** Using a model to grade a model is useful for triage and for scaling a first pass. It is not ground truth, it correlates with the failure modes of the thing it grades, and it cannot be the sole gate on a correctness-bearing path. If it is used, its own agreement with human labels is itself a measured number.
- **Regenerating the ground truth.** Refreshing expected outputs from the current model turns every run green and measures nothing. This is the probabilistic equivalent of updating a snapshot test without looking at the diff.
- **Prompt-tuning against the full corpus.** Without a held-out slice you are fitting the test, and the score stops predicting production.
- **Averaging across strata.** See segmentation above. The rare class is usually the one that matters.
- **Treating a provider outage as a test failure.** Distinguish component error from infrastructure error in the gate, or the team learns to ignore red.
- **One number for a multi-stage pipeline.** Route, classify, extract and validate each fail differently. A single end-to-end score cannot tell you which stage regressed; instrument per stage.
- **Deferring evaluation until after the build.** The corpus is what tells you the approach works at all. Built after the fact, it grades a decision already made. [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) puts it in `/solve` for this reason.

## Boundaries

- **Choosing** the component: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md). The bake-off's pre-registered threshold and its harness become this framework's first threshold register and corpus.
- **Suite shape, flake policy, test doubles**: [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
- **Latency and cost budgets**: [`PERFORMANCE_BUDGET.md`](PERFORMANCE_BUDGET.md). Guardrails here, budgets there.
- **Rolling out a model change to users**: [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) and [`EXPERIMENTATION.md`](EXPERIMENTATION.md). A model swap is a behaviour change and takes a flag defaulting off.
- **Production signal**: [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).

## Sources

- Pre-registration, one primary metric, no peeking, HARKing: [`EXPERIMENTATION.md`](EXPERIMENTATION.md) §"Hard rules", which grounds them in [`../../handbook/08-evolve-processes.md`](../../handbook/08-evolve-processes.md) §4.
- Fakes over mocks, flake quarantine, suite shape: [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
- Bake-off protocol, evidence tiers, harness promotion: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md).
- Segmentation-over-aggregate and the representative-workload requirement: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) §"Anti-patterns".
- Proportionality of verification effort to stakes: [`../../CLAUDE.md`](../../CLAUDE.md) §6. A probabilistic component in a path that matters earns this apparatus; a one-off script calling a model does not.
- [UNVERIFIED] No workspace `research/` file currently covers ML or LLM evaluation practice; `techstacks/14-ai-ml.md` §Evaluation names the tool category but not the discipline. The rules here are derived from the workspace's own experimentation and testing standards rather than from an external cited source, and that gap is recorded in [`../../MAPPING.md`](../../MAPPING.md).
