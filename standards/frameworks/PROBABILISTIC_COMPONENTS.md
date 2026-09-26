# PROBABILISTIC_COMPONENTS.md — Conditional escalation (testing models, LLMs, OCR, and other nondeterministic components)

**Authoritative sources:** [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) (suite shape, test-double discipline); [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) (the bake-off that chose the component, and the harness it leaves behind); [`EXPERIMENTATION.md`](EXPERIMENTATION.md) (pre-registration, one primary metric, no peeking); [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md) (production drift signal); [`../EVIDENCE.md`](../EVIDENCE.md) (claim schemas); [`../../research/05-testing/llm-evaluation.md`](../../research/05-testing/llm-evaluation.md) (graders, judge validation, error analysis, capability and regression suites, agent evaluation); [`../../handbook/llm-products.md`](../../handbook/llm-products.md) (the whole process, with roles and rituals).

## Activation

Two entries in [`trigger-index.json`](trigger-index.json) load this file, both at `max_passes = 5` (escalated from default 3):

| Entry | Phases | Keywords |
|---|---|---|
| `probabilistic-components` | `solve` (the bake-off and its promoted harness), `build` (the component being wired in), `test` (suite audit), `run` (production drift) | `LLM`, `model`, `OCR`, `embedding`, `classifier`, `extraction`, `transcription`, `nondeterministic`, `probabilistic`, `prompt`, `inference`, `RAG`, `AI`, `GenAI`, `LLMOps`, `agentic`, `evals`, `fine-tuning` |
| `probabilistic-components-lifecycle` | `discover`, `plan`, `design`, `ship`, `evolve` | The same list without `model` |

`model` is left out of the second entry because the "Done when" text of [`../../commands/design.md`](../../commands/design.md) says "data model", "tenancy model" and "threat model", and that text is part of every design brief. [`../../scripts/test-controls.sh`](../../scripts/test-controls.sh) fails if any keyword of either entry appears in its own phases' "Goal" or "Done when" text.

§"By phase" says what each phase owes. Everything else here applies wherever the file loads.

## What makes these components different

An ordinary unit test asserts a value. `parse("2024-01-01")` returns that date or the test fails, and a failure means the code is wrong.

A probabilistic component breaks both halves of that. The same input can produce different output across runs, and a single wrong output does not mean the component is broken — it may be operating exactly as measured. Correctness is a property of a distribution over a corpus, not of any one call.

Applying deterministic test discipline anyway produces the two failure modes this framework exists to prevent:

- **Assert-the-string.** A test pins one exact output. It passes on the day it is written and fails on every harmless rewording thereafter, so the team deletes it or pins the model so hard the test proves nothing.
- **No test at all.** "You can't unit-test an LLM" becomes the reason a component with no measured accuracy ships into a path that matters.

Both are avoidable. The component is measurable; it is just measured differently.

One set of evals does three jobs. Before building it is the spec: if the quality owner cannot mark a case pass or fail, the feature is not defined yet. While building and in CI it is the gate. In production the same graders run on sampled live traffic as the monitor.

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

**Every model version is a pinned dependency.** Record it where dependencies are recorded. Changing it re-runs the full corpus and must clear the same gates as the original selection (§"Model upgrades"). An unreviewed provider-side model change is a production risk, and the corpus run is what detects it.

## The ground-truth corpus

The corpus is the fixture. Everything else depends on it being honest.

- **Starts small and real.** 20-50 real inputs with pass/fail criteria are enough to start, and evals get harder to build the longer they wait. Synthetic cases cover the space until there is traffic.
- **Stratified by input class.** Whatever dimension makes inputs hard (document type, source system, language, scan quality, length, edge formatting) becomes a stratum with its own minimum count. A corpus that is 90% easy cases produces a number that describes nothing.
- **Negative cases included.** Cases where a behaviour must not happen: the input to refuse, the case to hand to a person, the tool that must not be called. A set with only positive cases optimises the component into doing the thing everywhere.
- **Hand-labelled by a person**, or derived from an authoritative record. Never labelled by the model under test, and never by a sibling of it. Labelling the corpus with the thing you are grading is circular and the resulting score is meaningless.
- **Versioned.** In the repo where size permits; otherwise a pointer plus a content hash, so a silently-changed corpus is detectable. A score is only comparable across time if the corpus is the same corpus.
- **Growable, append-only in practice.** Every production failure that reaches a human becomes a corpus entry. Removing an entry because it is failing is the single most damaging thing anyone can do here, and it should require the same review as deleting a test.
- **Held-out slice.** Keep a portion the prompt and configuration were never tuned against. Iterating a prompt against the whole corpus overfits to it, and the score stops predicting production.
- **One record per case**, with `id`, `segment`, `split` (dev or held-out), `input` and its fixtures, `expected` (a reference output or the criteria it must meet), `must_not`, `graders`, `source` (production trace, expert-written, synthetic or incident), the `failure_type` it guards, and `added` (date and author).

When people may not read the data, run the analysis on metrics instead (failure class by segment, field and stage, with values hashed), and keep a synthetic slice with no real personal data that people can read.

## Gate on metrics, not on values

Per input class, declare in advance:

| Field | Notes |
|---|---|
| Primary metric | One, with exact definition. Character error rate, field-level recall, classification F1, whatever decides |
| Threshold | The number that must be met |
| Tolerance band | Expected run-to-run spread. A result inside the band is not a regression |
| Sample size | How many corpus items. Enough that the band is narrower than the effect you care about. At 95% confidence, 97 items measure a pass rate to +/- 10 points and 385 to +/- 5 |
| Guardrails | Cost per item, p95 latency, refusal rate. Tracked, not decision-bearing |

Thresholds are declared before results, and a threshold lowered after a failing run is a blocker, not a fix. This is [`EXPERIMENTATION.md`](EXPERIMENTATION.md) §"Hard rules" applied to a corpus run, and the same reasoning holds: a threshold set after seeing the number measures nothing.

**Segment, or the aggregate lies.** Report and gate per class. A 94% aggregate that hides one class failing at 40% is the normal way this goes undetected, because the failing class is usually the rare, important one.

## Graders and judges

Grade with code where the answer is exact: schema, allowed values, required citations, the right tool called, numbers matching the source, forbidden content. Use a model only where judgement is needed: tone, faithfulness to a source, whether the question was answered. People supply ground truth, find the failure types and calibrate the judges.

An LLM judge is a component with its own error rate, so:

- One judge per failure type, with a written rubric and examples.
- Pass/fail, not a 1-5 scale. Raters cannot hold a consistent line between a 3 and a 4.
- Validated before it gates anything. The quality owner labels examples by hand; split them 10-20% for examples inside the judge's prompt, 40-45% as a dev set while refining it, and 40-45% held back for one final test, with 30 to 50 passes and 30 to 50 failures in each of dev and test where possible. Report the true-positive rate (failures it catches) and the true-negative rate (good outputs it passes) on the test split. A judge that passes everything is perfect on one and useless on the other.
- Re-validated when the criteria, the judged model or the judge model changes.
- Never the only gate on a correctness-bearing path (§"Anti-patterns").

A generic score ("helpfulness", "quality 1-10") is not a gate. Each gate grades one named failure type.

## Error analysis

Reading real outputs and naming what went wrong is how the failure types, and so the evals, are found. On each iteration in `/build`, and weekly once live:

1. Review at least 100 diverse traces. The quality owner annotates the first 30 personally.
2. **Open coding:** a free-text note on whatever went wrong in each trace.
3. **Axial coding:** group the notes into a failure taxonomy and count each type.
4. Fix the largest type first, one change at a time, re-running the evals after each.
5. Stop reviewing when new traces stop revealing new types (theoretical saturation).
6. Turn each type that matters into an eval: a code check if possible, otherwise a validated judge.

A prompt or model change with no failure type behind it is a guess.

## Capability and regression suites

| Suite | Question | Expected pass rate |
|---|---|---|
| Capability | What can the component do well? | Starts low. A new capability suite is run on the current system first and should mostly fail; if it passes, the cases are too easy or the work is already done |
| Regression | Does it still handle everything it used to? | Near 100%. A drop means something broke |

A capability case that passes reliably graduates into the regression suite when its feature rolls out, so every feature leaves behind cases that guard it. A capability suite sitting near 100% has stopped measuring progress; add harder cases.

## Flake versus variance

A probabilistic test that fails intermittently is not automatically flaky. Tell the two apart before quarantining anything:

1. Repeat the run N times on the same corpus slice.
2. Measure the spread of the primary metric.
3. If the spread is within the declared tolerance band, an occasional threshold miss is **variance**: the band or the sample size is wrong, not the component. Widen the sample until the band is narrower than the effect you care about.
4. If the spread exceeds the band, something in the shell is genuinely nondeterministic beyond the model, or the sample is too small to measure anything. Fix that before trusting any number from this gate.

Quarantining a probabilistic gate as "flaky" without doing this is how a component silently degrades for a quarter. [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md) flake-quarantine rules apply to the deterministic shell; they do not license muting a corpus gate.

For behaviour users rely on every time, report pass^k (all k repeated trials pass), not pass@k (at least one of k passes).

## Tier the gates by cost

Corpus evaluation costs money and wall-clock per run, so it cannot run on every push. Declare the tiers explicitly:

| Tier | When | Scope | Blocks |
|---|---|---|---|
| Shell tests | Every commit | Deterministic surface, fakes only | Yes |
| Smoke corpus | Every PR | Small stratified subset, one item per class minimum | Yes |
| Full corpus | Nightly, and on any model-version or prompt change | Everything, all classes | Yes on the change that triggered it |
| Held-out | Pre-release | The never-tuned-against slice | Yes |
| Online evals | Continuously | Sampled production traffic, the same graders | Alerts, not merges |

A model-version bump or prompt edit that does not trigger the full corpus is the gap through which regressions ship. Wire the trigger on the file path, not on the author remembering. The same holds for a retrieval-source or tool-definition change.

A PR that changes a prompt, model version, retrieval source or tool definition carries its evidence: the score change per segment, and the cost and latency change.

## Agents

When the model chooses its own steps and tools:

- Grade the outcome (the record written, the test passing, the page changed), then read the transcript to learn why. Grading the path penalises valid routes nobody anticipated.
- Start every trial from a clean environment. Shared state between trials causes correlated failures.
- Read transcripts from many trials to check the graders themselves.
- Cap steps, tokens, cost and time per task.
- Give tools least privilege, and require confirmation before any irreversible action ([`../security/OWASP.md`](../security/OWASP.md), LLM06).
- Test in a sandbox before granting production access.

## Production drift

Offline accuracy decays as real input drifts from the corpus. Per [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md):

- Sample production inputs and outputs at a declared rate. Respect the data-handling constraints recorded in the selection ADR; sampling regulated content into a log is its own incident.
- Track the primary metric where ground truth is recoverable (a human corrected it, a downstream system rejected it, the user re-did the task).
- Alert on the metric crossing the threshold, and on the **human-review queue depth**, which moves first and is usually cheaper to instrument.
- Feed corrected production failures back into the corpus.

The human-review queue is part of the design, not an admission of failure. Below-threshold outputs route to a person; the threshold that routes them is the same one the gate uses. A component with no review path has silently decided that its error rate is acceptable to whoever receives the output.

### Traces, dashboards and alerts

Every request writes one trace: input, retrieved context, tool calls and results, output, model and prompt versions, token counts, latency, cost, guardrail decisions and user feedback. Scrub what may not be stored before it is written. Name the attributes after the OpenTelemetry generative-AI semantic conventions, which now live in their own repository, and pin the version emitted.

Dashboards cover quality (online pass rate per grader and segment), user signals (edits, retries, escalations, abandonment), the review queue (depth, time to review, override rate), cost and tokens per task, p50 and p95 latency per stage, safety (guardrail triggers, refusals, blocked tool calls, detected injection attempts) and the provider (errors, timeouts, fallbacks taken). Alert on a quality drop past its tolerance band, a cost spike, a guardrail spike and review-queue depth.

### AI incidents

| Incident | First response | Follow-up |
|---|---|---|
| Quality regression | Flag off, or revert to the previous pinned prompt and model | Error analysis, new eval cases |
| Prompt injection exploited | Disable the affected tool or feature | Fix the guardrail; add the attack as an eval case |
| Runaway cost | Budget cap, rate limit, kill switch | A per-task cost limit in CI |
| Provider outage | Fallback model, degraded mode or a queue | Test the fallback path in CI |
| Behaviour change under a stable model name | Run the full suite on current traffic; pin or switch | Treat it as a model upgrade |

Every postmortem ([`../operations/ON_CALL.md`](../operations/ON_CALL.md)) ends with the eval cases it added.

### Model upgrades

A new model version is a dependency upgrade:

1. Pin the candidate in a branch and change nothing else.
2. Run the full suite with repeated trials, plus the held-out slice.
3. Compare per segment, including cost, latency and refusal rate.
4. Do error analysis on every case whose result changed, in either direction.
5. Adjust prompts only if needed, as a separate measured change.
6. Shadow behind a flag, then canary.
7. Switch, and keep the previous version pinned for rollback until the provider retires it.

Track the provider's deprecation date for every pinned version.

## By phase

| Phase | What this framework adds | Exit evidence |
|---|---|---|
| `/discover` | Price a wrong answer and choose the autonomy level from it: the model suggests and a person decides, it acts after confirmation, or it acts alone. Check that an expert can reliably tell a good output from a bad one; if experts disagree, fix the definition before building. Record the non-AI option (rules, search, a form) and why it loses. Settle the data rules: what may go to which provider, what is logged and for how long, who may read traces, and how deletion reaches derived copies such as eval cases | `discovery/<slug>/ai-fit.md` |
| `/plan` | Name the quality owner, the one domain expert whose pass/fail call is final. Write eval set v0: 20-50 real inputs with pass/fail criteria, covering typical, edge and adversarial cases, cases to refuse or hand to a person, and must-not cases. Pick a grader per criterion, code first. Date the threshold register before any run: quality per segment, zero-tolerance safety classes, p95 latency and cost per task, each with a tolerance band. Split off the held-out slice | `eval/<component>/corpus.md` and `eval/<component>/thresholds.md`, named for the feature until a component exists; the suite runs end to end against a stub and prints a score |
| `/solve` | The bake-off, per [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) §"Probabilistic candidates" | Selection ADR; the harness becomes the regression suite |
| `/design` | Climb only as far as the evals require: one prompt, then retrieval or tools, then a workflow in code, then an agent, and fine-tuning last. Keep the deterministic shell separate. Design for being wrong: show sources, make output editable and undo cheap, and route low-confidence or policy-sensitive cases to a person. Name the guardrails, the trace fields and the plan for a provider outage or deprecation (degraded mode, a second model, or a queue). Threat-model against the OWASP Top 10 for LLM Applications | An ADR for the rung chosen; the threat model covers LLM01-LLM10; the NFRs carry cost per task and p95 latency per stage |
| `/build` | A baseline on the strongest candidate model, then §"Error analysis" and one change at a time until the dev-set thresholds are met. Cost and latency work comes after, with the evals proving quality held | Failure taxonomy with counts; dev-set thresholds met in every segment with no zero-tolerance failures |
| `/test` | Score the held-out slice once. Validate every judge. Red-team against the OWASP list, and add every attack that works as an eval case. Repeat runs and read the spread | Held-out result; judge validation reports; CI blocks regressions |
| `/ship` | Merge behind a flag that defaults off ([`FEATURE_FLAGS.md`](FEATURE_FLAGS.md)), then internal dogfood, shadow (the model runs, users do not see its output, results are compared), canary, and an A/B test against control ([`EXPERIMENTATION.md`](EXPERIMENTATION.md)). Rollback is the flag, or the previous pinned prompt and model. Record model and prompt versions on every trace and in the release notes | Rollout plan with a shadow stage; a tested rollback; online metrics holding against control |
| `/run` | §"Production drift" and its subsections | Dashboards and alerts live; an AI-incident runbook |
| `/evolve` | Every failure a person catches in production becomes an eval case. Capability cases graduate to regression, and saturated suites get harder cases. Model upgrades follow §"Model upgrades". Review the criteria quarterly, because they drift, and re-validate judges when they change. Add segments as new users, sources and formats appear | New dated corpus cases; upgrade run records |

## Required artifacts

A pass that touches a probabilistic component in `/solve`, `/build`, `/test` or `/run` must produce, before scoring proceeds:

- **Corpus manifest** at `eval/<component>/corpus.md`: strata, counts per stratum, labelling provenance, version or content hash, held-out slice, and which cases are capability and which regression.
- **Threshold register** at `eval/<component>/thresholds.md`: per class, the primary metric definition, threshold, tolerance band, sample size, guardrails. Dated before the first run.
- **Run records** at `eval/<component>/runs/<date>-<version>.md`: model version, corpus version, per-class results, verdict.
- **Failure taxonomy** at `eval/<component>/failure-taxonomy.md`, from `/build` on: each failure type with its count, the traces it came from, and the eval that now guards it.
- **Judge validation report** at `eval/<component>/judges/<judge>.md` for every LLM judge that gates: rubric, label source and split, true-positive and true-negative rates on the test split, judged-model and judge-model versions, date.
- **Gate wiring**: the CI job, its tier, and what it blocks.
- **Fakes** covering malformed, empty, truncated, and error responses on the deterministic shell.

In `/discover`, `/plan`, `/design`, `/ship` and `/evolve`, the required artifact is the exit evidence §"By phase" names.

## Pass-by-pass checks

| Pass | Check |
|---|---|
| 1 | Are the two surfaces separated, is the shell tested with fakes including failure responses, and is the model version pinned and recorded as a dependency? In `/discover`, `/plan`, `/design`, `/ship` and `/evolve`: is the §"By phase" exit evidence present? |
| 2 | Is the corpus stratified, human-labelled, versioned, held-out-sliced, and does it include must-not cases? Are thresholds dated before the first run, per class, with tolerance bands and sample sizes? Is every gating judge validated, with both rates reported? |
| 3 | Are gates tiered and wired, does a model-version or prompt change trigger the full corpus, does a failure taxonomy with counts stand behind the changes made, and does drift monitoring plus a human-review queue exist with an owner? |

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
| LLM judge gating with no true-positive and true-negative rates measured on held-out human labels | Major |
| LLM judge as the only gate on a correctness-bearing path | Major |
| Generic score ("helpfulness", "quality 1-10") used as a gate | Major |
| Eval set with no must-not cases | Major |
| Agent or model call with no cap on steps, tokens, cost or time | Major (OWASP LLM10) |
| Autonomy level or data rules undecided at the end of `/discover` | Major |
| No named quality owner, or pass/fail criteria an expert cannot apply, at the end of `/plan` | Major |
| Model-backed feature rolled out with no shadow or canary stage | Major |
| Corpus unversioned, so scores are not comparable across time | Minor |
| Production drift unmonitored | Minor (major once the component is in a revenue or compliance path) |
| Prompt or model change with no failure type behind it once a failure taxonomy exists | Minor |
| New capability suite never run red on the current system | Minor |
| Agent graded on its path rather than its outcome | Minor |
| Model or prompt version missing from traces | Minor (major in a compliance path) |

## Anti-patterns

- **LLM-as-judge as the only gate.** Using a model to grade a model is useful for triage and for scaling a first pass. It is not ground truth, it correlates with the failure modes of the thing it grades, and it cannot be the sole gate on a correctness-bearing path. If it is used, its own agreement with human labels is itself a measured number.
- **Regenerating the ground truth.** Refreshing expected outputs from the current model turns every run green and measures nothing. This is the probabilistic equivalent of updating a snapshot test without looking at the diff.
- **Prompt-tuning against the full corpus.** Without a held-out slice you are fitting the test, and the score stops predicting production.
- **Averaging across strata.** See segmentation above. The rare class is usually the one that matters.
- **Treating a provider outage as a test failure.** Distinguish component error from infrastructure error in the gate, or the team learns to ignore red.
- **One number for a multi-stage pipeline.** Route, classify, extract and validate each fail differently. A single end-to-end score cannot tell you which stage regressed; instrument per stage.
- **Deferring evaluation until after the build.** The corpus is what tells you the approach works at all. Built after the fact, it grades a decision already made. [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) puts it in `/solve` for this reason.
- **Choosing a model from a public leaderboard.** Benchmarks do not contain your inputs. They shortlist; the bake-off chooses.
- **One-sided evals.** A set with no must-not cases teaches the component to do the thing everywhere.
- **1-5 rating scales.** Raters cannot hold the line between a 3 and a 4. Use pass/fail per failure type.
- **Grading an agent's path.** It penalises valid routes nobody anticipated. Grade the outcome, then read the transcript.

## Boundaries

- **Choosing** the component: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md). The bake-off's pre-registered threshold and its harness become this framework's first threshold register and corpus.
- **Suite shape, flake policy, test doubles**: [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
- **Latency budgets**: [`PERFORMANCE_BUDGET.md`](PERFORMANCE_BUDGET.md). Cost per task and tokens per task are thresholds in this framework's register, because a cheaper component that is worse is not a saving.
- **Rolling out a model change to users**: [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) and [`EXPERIMENTATION.md`](EXPERIMENTATION.md). A model swap is a behaviour change and takes a flag defaulting off, plus the shadow stage this file's §"By phase" adds.
- **Security controls for LLM applications**: [`../security/OWASP.md`](../security/OWASP.md) §"OWASP Top 10 for LLM Applications 2025".
- **Production signal**: [`../operations/OBSERVABILITY.md`](../operations/OBSERVABILITY.md).
- **Roles, rituals and the maturity ladder**: [`../../handbook/llm-products.md`](../../handbook/llm-products.md). Human process, not scored.

## Sources

- Pre-registration, one primary metric, no peeking, HARKing: [`EXPERIMENTATION.md`](EXPERIMENTATION.md) §"Hard rules", which grounds them in [`../../handbook/08-evolve-processes.md`](../../handbook/08-evolve-processes.md) §4.
- Fakes over mocks, flake quarantine, suite shape: [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md).
- Bake-off protocol, evidence tiers, harness promotion: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md).
- Segmentation-over-aggregate and the representative-workload requirement: [`../docs/TECH_SELECTION.md`](../docs/TECH_SELECTION.md) §"Anti-patterns".
- Starting with 20-50 real cases, negative cases, graders, judge validation, error analysis, capability and regression suites, pass^k, agent evaluation, the OWASP LLM risks and the trace conventions: [`../../research/05-testing/llm-evaluation.md`](../../research/05-testing/llm-evaluation.md), each quotation re-read against its source on 2026-09-26.
- The corpus, threshold and tiering rules are this workspace's synthesis of the experimentation and testing standards above; the research file grounds the evaluation practice added to them.
- Proportionality of verification effort to stakes: [`../../CLAUDE.md`](../../CLAUDE.md) §6. A probabilistic component in a path that matters earns this apparatus; a one-off script calling a model does not.
