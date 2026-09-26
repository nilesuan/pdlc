# Building LLM-powered products (LLMOps)

**Last updated:** 2026-09-26

**What this is:** the end-to-end workflow for building and running products whose behaviour depends on an LLM or another model. It covers principles, roles, the eval system, the first release phase by phase, the loop for every new feature, CI/CD, production operations, security and governance. Vendor-neutral. It runs across the handbook's phases rather than being one of them: section 5 follows the same 01 to 08 sequence and names the command for each phase.

**How to read it:** section 0 is the one-page version. Sections 1 to 11 are the detail. Appendix A holds templates. Appendix B lists where each part is enforced.

**Evidence:** `[n]` cites the numbered sources at the end. Quoted phrases are verbatim from the cited source; each was re-read against it on 2026-09-26, and the checked record is [`../research/05-testing/llm-evaluation.md`](../research/05-testing/llm-evaluation.md). `[L1]` is the local standard [`PROBABILISTIC_COMPONENTS.md`](../standards/frameworks/PROBABILISTIC_COMPONENTS.md), which turns this chapter into rules the phase commands score against. Recommendations without a citation are synthesis from these sources.

---

## 0. The one-page version

### 0.1 What replaces the SDLC

The development method is often called **evaluation-driven development** (EDD). The operations side is called **LLMOps**. Together they are the SDLC with one substitution: a set of **evals** serves as the spec, the test suite and the production monitor, and failures from production keep being added to it. It is test-driven development for a system where correctness "is a property of a distribution over a corpus, not of any one call" [L1].

| | Traditional SDLC | LLM product |
|---|---|---|
| Spec | Written upfront | Partly discovered by grading real outputs, then pinned as eval cases [4] |
| Test result | Pass or fail | A pass rate over a dataset, with run-to-run noise |
| What changes behaviour | Your code | Code, prompts, model version, retrieved data, tools, user input, the provider |
| Done when | Tests are green | The pass rate meets a threshold set in advance, per segment, and keeps being measured in production |
| A bug | Fix it, add a test | Name the failure type, fix it, add eval cases that catch it if it returns |
| Monitoring | Uptime, latency, errors | Also quality, cost per task, safety events, human-review queue depth |

### 0.2 The lifecycle at a glance

```
  01 Discover --> 02 Plan (define evals) --> 02.5 Solve (bake-off) --> 03 Design
                                                              |
        +-----------------------------------------------------+
        v
  04 Build <--> error analysis --> 05 Test (harden) --> 06 Ship (flag, shadow, canary, A/B)
                                                              |
        +-----------------------------------------------------+
        v
  07 Run (traces, online evals, review queue) --> 08 Evolve (failures become eval cases)
                                                              |
        +-----------------------------------------------------+
        v
  Every new feature: the loop in section 6, starting again at "define evals"
```

| Phase | In one line |
|---|---|
| 01 Discover (`/discover`) | Is AI the right tool, what does a wrong answer cost, can an expert grade the output |
| 02 Plan (`/plan`) | Define "good": write the evals and thresholds before the first prompt |
| 02.5 Solve (`/solve`) | Let candidates (LLMs, smaller models, specialist models, plain code) compete on your own data |
| 03 Design (`/design`) | The simplest architecture that passes; design for being wrong; trace everything |
| 04 Build (`/build`) | Baseline, then error analysis and one change at a time until thresholds are met |
| 05 Test (`/test`) | Harden: held-out set, validated judges, red-teaming, CI gates |
| 06 Ship (`/ship`) | Behind a flag that defaults off; dogfood, shadow, canary, A/B |
| 07 Run (`/run`) | Online evals, user signals, cost, review queue, AI incident response |
| 08 Evolve (`/evolve`) | Production failures become eval cases; model upgrades go through the full suite |

### 0.3 The loop for every new feature

1. Frame the job and the cost of a wrong answer.
2. Collect 20-50 real inputs for it, plus cases where the behaviour must not happen.
3. Write capability evals and thresholds; run them on the current system and watch them fail.
4. Make the smallest change.
5. Run the new evals plus the full regression suite.
6. Do error analysis on the failures and fix the largest failure type; go back to 4 until thresholds are met.
7. Harden: held-out set, judge validation, red-team cases.
8. Merge behind a flag, default off.
9. Roll out and compare against control.
10. Move the feature's evals into the regression suite; remove the flag.

### 0.4 The five habits that matter most

1. Write evals before prompts.
2. Read real outputs every week and name the failure types.
3. Grade with code where possible and with validated judges where necessary.
4. Ship behind a flag, measure online, roll back with the flag.
5. Turn every production failure into an eval case.

---

## 1. What is different about building with LLMs

| Property | Consequence for the workflow |
|---|---|
| The same input can give different outputs | Correctness is a pass rate with noise. Tests become measurements with sample sizes and tolerance bands (4.6) |
| "Good" is discovered, not fully specified upfront | "users need criteria to grade outputs, but grading outputs helps users define criteria" [4]. Start with a small eval set and grow it from what you observe |
| Behaviour changes with no code change | Model versions, provider-side changes, retrieved data and user inputs all move quality, so evaluation keeps running in production (section 8) |
| Failures are fluent | A wrong answer reads like a right one. You need independent checks, not a read-through |
| Every call costs money and time | Cost per task and latency are quality attributes with thresholds |
| Instructions and data share one channel | Prompt injection is first on the OWASP list [7]. Anything the model reads can try to steer it |

---

## 2. Principles: the new ways of working

1. **Evals before prompts.** No prompt is written before 20-50 real inputs have pass/fail criteria. "Evals get harder to build the longer you wait" [1].
2. **Look at the data.** Error analysis (reading real outputs and naming the failure types) is "the single most valuable activity in AI development and consistently the highest-ROI activity" [2].
3. **One owner of "good".** For small and medium-sized companies, a single domain expert acts as "the definitive voice on quality standards" [3]. This removes labelling conflicts and stalemates.
4. **Simplest thing that works.** Anthropic recommends "finding the simplest solution possible, and only increasing complexity when needed" [5]. Every added step adds failure modes and cost.
5. **Every change is an experiment.** Change one thing, re-run the evals, and keep it only if the score improves with no regression. Two changes at once make both results unreadable.
6. **Prompts, models and configs are code.** They live in the repo, get reviewed, are pinned to exact model versions (never a floating alias), and pass the same gates as code [L1].
7. **Deterministic where possible, model where necessary.** This holds for graders [1] and for the system itself: use code where the answer is exact, and a model only where judgement is needed.
8. **Design for being wrong.** The error rate is never zero, so errors must be visible and cheap to fix. "The human-review queue is part of the design, not an admission of failure" [L1].
9. **Merge dark, release by flag.** Every AI feature ships behind a flag that defaults off, then goes out through dogfood, shadow, canary and A/B. Merging is not releasing.
10. **The flywheel.** Every failure a person catches in production becomes an eval case. Over time the eval set, not the prompt, is the product's most valuable asset.

---

## 3. Roles and rituals

### 3.1 Roles

| Role | Owns |
|---|---|
| Product owner | The job to be done, the autonomy level, the business metric, sign-off on thresholds |
| Quality owner (a domain expert) | What "good" means, labelling, the final say on disagreements [3] |
| AI engineer | Prompts and configs, the eval harness, experiments, error analysis with the quality owner |
| Platform engineer | Tracing, the model gateway, flags, CI tiers, cost controls, fallbacks |
| Security | Threat model, red-teaming, guardrails |
| Production reviewers | The human-review queue. Their corrections feed the eval set |

"The people closest to product requirements and users are best positioned to define success" [1], so product managers and customer-facing staff should be able to add eval cases directly.

### 3.2 Rituals

| Ritual | Cadence | Output |
|---|---|---|
| Trace review | Weekly | New failure notes, updated counts per failure type |
| Eval diff in code review | Every PR that touches prompts, models, retrieval or tools | Score change per segment, plus cost and latency change, attached to the PR |
| Judge calibration | Monthly, and whenever the criteria, the judged model or the judge model changes | True-positive and true-negative rates on held-out labels |
| Model review | When a provider ships or deprecates a model | An upgrade decision made on the full suite |
| Incident review | After every AI incident | New eval cases, guardrail changes |
| Criteria review | Quarterly | An updated rubric, and relabelling if the criteria changed |

Treat the cadences as starting points and tune them to traffic and risk.

---

## 4. The eval system

### 4.1 Three jobs, one set of evals

1. **Spec**, before building: real inputs plus what a good output must do. If the quality owner cannot mark each case pass or fail, the feature is not defined yet.
2. **Gate**, while building and in CI: every change to prompts, models, retrieval or tools runs them, and a regression blocks the merge.
3. **Monitor**, in production: the same graders run on live traffic, alongside user signals.

### 4.2 Graders

Use "deterministic graders where possible, LLM graders where necessary or for additional flexibility" [1].

| Grader | Use it for | Strengths [1] | Weaknesses [1] |
|---|---|---|---|
| Code | Schema, allowed values, required citations, the right tool called, numbers matching the source, forbidden content | "Fast", "Cheap", "Objective", "Reproducible" | "Brittle to valid variations", "Lacking in nuance" |
| LLM judge | Tone, faithfulness to a source, whether the question was answered | "Flexible", "Scalable" | "Non-deterministic", "More expensive than code" |
| Human | Ground truth, finding failure types, calibrating judges | "Gold standard quality" | "Expensive", "Slow" |

**Rules for LLM judges:**

- One judge per failure type, each with a written rubric and examples.
- Pass/fail rather than a 1-5 scale: "evaluators frequently struggle with the difference between a 3 and a 4" [2].
- Validate before trusting. Label examples by hand and split them: 10-20% as training examples, 40-45% as a dev set while refining the judge, and 40-45% held back for one final test. Aim for a high true-positive rate and a high true-negative rate on that test set [3]. Check both, because a judge that passes everything is perfect on one and useless on the other.
- Re-validate when the criteria, the model being judged or the judge model changes.
- Never make a judge the only gate on an output where correctness matters [L1].

### 4.3 Two suites: capability and regression

| Suite | Question it answers [1] | Expected pass rate [1] |
|---|---|---|
| Capability | "What can this agent do well?" | "should start at a low pass rate" |
| Regression | "Does the agent still handle all the tasks it used to?" | "should have a nearly 100% pass rate" |

Capability evals with high pass rates 'can "graduate" to become a regression suite' [1]. Graduation is what makes the per-feature loop safe: every feature leaves behind cases that guard it from then on. A suite that sits near 100% stops showing progress, so add harder cases [1].

### 4.4 The dataset

- **Sources, best first:** real production traces; cases written by the quality owner; synthetic cases to cover the space before there is traffic ("synthetic data can be remarkably effective for evaluation" [2]). Where an authoritative record exists (the system of record, the source document, the filed form), derive the expected output from it. That is cheaper than hand labelling, exact, and nobody has to read sensitive data.
- **Segments:** split by whatever makes inputs hard (user type, source, language, length, format), with a minimum count per segment. Report and gate per segment [L1].
- **Negative cases:** "Test both the cases where a behavior should occur and where it shouldn't. One-sided evals create one-sided optimization" [1].
- **Held-out slice:** a part you never tune against, scored only at release. Tuning against the whole set overfits it, and the score stops predicting production [L1].
- **Versioned:** scores are comparable over time only on the same dataset version [L1].
- **Append-only in practice:** deleting a case because it fails needs the same review as deleting a test [L1].
- **Never circular:** never label with the model under test or a sibling of it, and never regenerate expected outputs from the current model [L1].

### 4.5 Error analysis

The method, from [3]:

1. Review at least 100 diverse traces, and keep going while you are still learning. The quality owner annotates at least the first 30 personally.
2. **Open coding:** write a free-text note on whatever went wrong in each trace.
3. **Axial coding:** group the notes into a failure taxonomy. "Axial coding is the most important step" [3].
4. Count each failure type and fix the largest first.
5. Stop when new traces stop revealing new failure types ("theoretical saturation" [3]).
6. Turn each failure type that matters into an eval: a code check if possible, otherwise a validated judge.

**Tooling:** build a simple viewer that shows the full context of a trace and captures labels. [3] calls a custom annotation tool "the single most impactful investment you can make for your AI evaluation workflow".

**When the data is too sensitive for people to read:** run the analysis on metrics instead (failure class by segment, field and pipeline stage, with values hashed), and keep a synthetic slice with no real personal data that people can read.

### 4.6 Noise and sample size

Pass rates from small sets are imprecise. At 95% confidence, in the worst case:

| Cases per segment | Precision of a measured pass rate |
|---|---|
| 43 | +/- 15 points |
| 97 | +/- 10 points |
| 385 | +/- 5 points |
| 1,068 | +/- 3 points |

- A measured 80% on 100 cases means the true rate is somewhere between about 72% and 88%. A 3-point gain between two prompts on 100 cases is usually noise.
- To compare two versions, size the set against the difference you need to detect, not against the pass rate.
- One failing case is enough to refute "it works on X". Confirming it needs the counts above.
- Run each case several times and declare a tolerance band. A miss inside the band is variance, not a regression [L1].
- "pass@k measures the likelihood that an agent gets at least one correct solution in k attempts", while "pass^k measures the probability that all k trials succeed" [1]. Use pass^k for anything users rely on to work every time.
- Report per segment. A good average hides a failing segment, and "the failing class is usually the rare, important one" [L1].

### 4.7 Agents

- **Grade the outcome.** "it's often better to grade what the agent produced, not the path it took" [1]. Check the final state (the record was written, the test passes, the page changed), then read the transcript to learn why.
- **Isolate trials.** 'Each trial should be "isolated" by starting from a clean environment' [1]. Shared state causes correlated failures.
- **Read transcripts to check the graders.** "You won't know if your graders are working well unless you read the transcripts and grades from many trials" [1].
- **Test in sandboxes**, "along with the appropriate guardrails" [5].
- **Cap steps and cost per task** (LLM10 Unbounded Consumption [7]).
- **Least privilege for tools, and confirmation before irreversible actions** (LLM06 Excessive Agency [7]).

### 4.8 Layers of evaluation

"no single evaluation layer catches every issue" [1]. Stack them:

| Layer | When | Catches | Limit |
|---|---|---|---|
| Automated evals | Pre-launch and in CI [1] | Regressions and known failure types | Only what the dataset covers |
| Production monitoring | After launch [1] | Real behaviour at scale | "Reactive" [1] |
| A/B tests | During rollout | Real user outcomes | Take "days or weeks to reach significance" [1] |
| User feedback | Always | What users notice | "Sparse" [1] |
| Transcript review | Weekly | New failure types | Needs people and time |

---

## 5. The first release, phase by phase

Each phase lists its goal, the work, what it produces and the exit gate.

### 01 Discover (`/discover`)

**Goal:** a job worth doing, and a decision on whether AI is the right tool.

**Work:**

- Name the user, the job, how it is done today, and the pain.
- Price a wrong answer. That sets the autonomy level: the AI suggests and a person decides, the AI acts after confirmation, or the AI acts alone. The higher the cost of an error, the less autonomy.
- Check that an expert can reliably tell a good output from a bad one. If experts often disagree, fix the definition before building anything.
- Check the non-AI option: rules, search, a form, a better screen.
- Collect real inputs: logs, tickets, documents, recordings.
- Settle the data rules now: what may go to a model provider, what may be logged, how long it is kept, and who may read it.

**Produces:** problem statement, autonomy decision, sample inputs, data-handling rules.
**Exit gate:** an expert can grade outputs, the autonomy level is chosen, and the data rules are known.

### 02 Plan: define "good", evals first (`/plan`)

**Goal:** a spec you can run.

**Work:**

- Appoint the quality owner [3].
- For 20-50 real inputs, write the expected output or the pass/fail criteria. "20-50 simple tasks drawn from real failures is a great start" [1]. Cover typical, edge and adversarial cases, cases the system should refuse or hand to a person, and cases where a behaviour must not happen [1].
- Choose a grader per criterion: code first, a judge only where code cannot decide.
- Write the thresholds before the first run: quality per segment, zero-tolerance safety classes, p95 latency and cost per task, each with a tolerance band. As [L1] puts it, "a threshold set after seeing the number measures nothing".
- Split off the held-out slice.

**Produces:** eval dataset v0 (versioned), threshold register, grader specs.
**Exit gate:** the eval suite runs end to end against a stub and produces a score.

### 02.5 Solve: select the approach, the bake-off (`/solve`)

**Goal:** decide what does the work by measuring on your own data. This is where "is an LLM the answer?" gets settled.

**Work:**

1. **Build the truth corpus first.** Derive expected outputs from authoritative records wherever they exist. Otherwise have experts label, with two people labelling independently where the stakes justify it and a third settling disagreements.
2. **Put truth at the level the product promises.** Score the fields, actions or outcomes the user receives, not a proxy that is easy to measure. A pipeline can recover nearly every character of a document and still get most structured fields wrong, and only truth at the output level shows it.
3. **Prefer variety to volume.** Cover every source, format and user segment the product will meet. A huge corpus from one source gives very precise answers about that source and none about the others.
4. **Shortlist across categories, not only LLMs:** hosted frontier models, small or open-weight models you run yourself, specialist models (OCR, speech, classifiers, embeddings, rerankers), deterministic code (parsers, rules, search), and hybrids. Public benchmarks help you shortlist but not choose, because they do not contain your inputs.
5. **Eliminate on hard constraints before measuring anything:** data that may not leave a boundary, licences (check model weights separately from code), cost per task at expected volume, latency, and operating burden (GPUs, model servers).
6. **Pre-register** the primary metric, threshold, tolerance band and sample size per segment, dated before any run [L1].
7. **Decide per stage, not globally.** Most pipelines mix methods: deterministic code where the answer is exact, a model where judgement or flexibility is needed. Run one bake-off per stage.
8. **Score generative candidates on invention and omission separately.** Grounding: every value emitted is supported by the input. Coverage: every required value is emitted. A generative model's typical failure is a plausible wrong value, which a coverage-only metric cannot see.
9. **Count agreement only between methods that fail differently.** Two methods reading the same underlying signal tend to fail on the same cases, so their agreement proves little.
10. **Record the decision** in an ADR, with the measured value that rejected each alternative and the cost of reversing it. Then **keep the bake-off harness as the regression suite** [L1].

**Produces:** shortlist with elimination reasons, pre-registration, results, decision record, harness.
**Exit gate:** a candidate clears every pre-registered threshold in every segment, or the decision is recorded as open with what would close it.

### 03 Design (`/design`)

**Goal:** a system that can be wrong safely and can be observed.

**Work:**

- **Climb the ladder only as far as the evals require** [5]:
  - one prompt
  - add retrieval or tools
  - a workflow, where "LLMs and tools are orchestrated through predefined code paths" [5]
  - an agent, where "LLMs dynamically direct their own processes and tool usage" [5]
  - fine-tuning last, once prompting and retrieval plateau and there is enough labelled data
- **Separate the deterministic shell from model behaviour.** Parsing, retries, timeouts, validation, routing and prompt assembly are ordinary code. Test them with fakes that return malformed, empty, truncated and error responses [L1].
- **Design for being wrong:** show sources, make output editable, make undo cheap, and route low-confidence or policy-sensitive cases to a person. Edits and undos double as quality signals.
- **Guardrails:** validate inputs and outputs (schema, allowed values, personal data), treat retrieved content and tool output as untrusted, give tools least privilege, and confirm before irreversible actions [7].
- **Observability from day one:** a trace per request (8.1).
- **Resilience:** pin model versions, and plan for provider outages and deprecations (degraded mode, second model, or a queue).
- **Threat model** against the OWASP Top 10 for LLM Applications (9.1).

**Produces:** architecture decision records, guardrail list, trace schema, review-route design, threat model.
**Exit gate:** every stage has an interface, an owner and a way to be measured.

### 04 Build (`/build`)

**Goal:** meet the thresholds on the dev set by evidence, not by feel.

**Work:**

1. **Baseline:** build the simplest version on the strongest model and run the evals. This tells you early whether the task is feasible at all.
2. **Error analysis** (4.5): read traces, name the failure types, count them, fix the largest.
3. **Add an eval for each failure type that matters.** Skip generic scores such as "helpfulness": "Generic metrics are worse than useless", because they "create a false sense of measurement and progress" [2].
4. **One change at a time.** Re-run and keep what improves without regressions.
5. **Then cost and latency:** smaller models, routing, caching, shorter context, with the evals proving quality held.

**Produces:** prompts and configs in the repo, a growing eval set, a failure taxonomy with counts, a cost and latency profile.
**Exit gate:** dev-set thresholds met in every segment, with no zero-tolerance failures.

### 05 Test: harden (`/test`)

**Goal:** confidence that holds beyond the data you tuned on.

**Work:**

- Score the **held-out slice** once.
- **Validate every judge** (4.2).
- **Red-team** against the OWASP list [7]. Every attack that works becomes an eval case.
- **Repeat runs** and read the spread. Use pass^k where reliability matters [1].
- **Wire the CI tiers** (section 7).

**Produces:** held-out result, judge validation report, red-team report, CI wiring.
**Exit gate:** the held-out slice meets thresholds, the judges are validated, and CI blocks regressions.

### 06 Ship (`/ship`)

**Goal:** release with a cheap rollback and real-world evidence.

**Work:**

- Merge behind a flag that **defaults off**. The off path is the old behaviour.
- Roll out in stages:
  - internal dogfood
  - **shadow mode**: the AI runs but users do not see the output, and results are compared
  - a **canary** percentage of users
  - an **A/B test** against control on a business metric
- Roll back by turning the flag off, or by reverting to the previous pinned prompt and model.
- Record the model and prompt versions on every trace and in the release notes.

**Produces:** rollout plan, dashboards, a tested rollback.
**Exit gate:** online metrics hold against control, with no zero-tolerance incidents.

### 07 Run (`/run`)

See section 8.

### 08 Evolve (`/evolve`)

- Every production failure a person catches becomes an eval case.
- Capability evals graduate into regression, and saturated suites get harder cases [1].
- A new model version is a dependency upgrade: full suite, held-out slice, shadow, flag (Appendix A.4) [L1].
- Re-check the criteria periodically because they drift [4], and re-validate judges when they change.
- Add segments as new users, sources and formats appear.

---

## 6. The loop for every new feature

"Feature" here includes a new capability, a new user segment or input source, a new tool, a new output field and a change of model.

| Step | Do | Output |
|---|---|---|
| 1 Frame | The job, the segments affected, the cost of a wrong answer, the autonomy level | A one-paragraph brief |
| 2 Collect | 20-50 real inputs (production traces if live), plus negative cases | Cases tagged by segment |
| 3 Specify | Capability evals and thresholds, pre-registered. Run them on the current system: most should fail. If they pass, the evals are too easy or the work is already done | A red capability suite |
| 4 Change | The smallest change: prompt, tool, retrieval source, workflow step or model | One diff |
| 5 Measure | The new capability evals plus the full regression suite | Score per segment |
| 6 Analyse | Error analysis on the failures; fix the largest failure type; back to step 4 until thresholds are met with no regression | Failure counts trending down |
| 7 Harden | Held-out slice once, validation for any new judge, red-team cases for new inputs or tools | Pre-release evidence |
| 8 Merge | Behind a flag, default off. The PR shows eval deltas per segment, plus cost and latency deltas | A dark merge |
| 9 Roll out | Dogfood, shadow, canary, A/B against control | Online evidence |
| 10 Graduate | Capability evals join the regression suite; production failures become cases; the flag is removed once stable | A bigger regression suite |

**Other triggers enter the loop part-way:**

| Trigger | Enter at |
|---|---|
| Model version change or provider deprecation | Step 5 (full suite plus held-out slice), then steps 8-9 |
| Prompt or config edit | Step 5 |
| New data source or retrieval index change | Step 2 for the new source's cases, then step 5 |
| Online metric drop, or a jump in review-queue depth | Step 6 on recent traces, then step 2 |
| New failure type from the weekly trace review | Step 2 |
| Incident | Mitigate first (flag off, or the previous pinned version), then step 2 |

---

## 7. CI/CD for AI

| Tier | When | Scope | Blocks |
|---|---|---|---|
| Shell tests | Every commit | Deterministic code with fakes, including failure responses | Yes |
| Smoke evals | Every PR | Small stratified subset, at least one case per segment | Yes |
| Full evals | Nightly, and on any prompt, model, retrieval or tool change | All cases, all segments, repeated trials | Yes, on the change that triggered it |
| Held-out | Before release | The never-tuned slice | Yes |
| Online evals | Continuously | Sampled production traffic | Alerts |

The tiers follow [L1]. Three rules:

- **Trigger on file paths.** A prompt, model-config or tool-definition change must start the full suite. "Wire the trigger on the file path, not on the author remembering" [L1].
- **Separate infrastructure errors from quality failures.** Treating a provider outage as a test failure teaches the team to ignore red [L1].
- **The PR carries the evidence:** score deltas per segment, cost and latency deltas, and any new or changed eval cases.

---

## 8. Running in production (LLMOps)

### 8.1 Tracing

For each request, log the input, retrieved context, tool calls and results, output, model and prompt versions, token counts, latency, cost, guardrail decisions and user feedback. Scrub anything you are not allowed to store before it is written. OpenTelemetry's generative-AI semantic conventions give standard names for these attributes. They now live in their own repository [8], so pin the version you emit.

### 8.2 Dashboards

| Area | Measures |
|---|---|
| Quality | Online pass rates per grader and segment; grounding and coverage where they apply |
| Users | Edits to AI output, retries, thumbs up/down, escalations to a person, abandonment, task completion |
| Review queue | Depth, time to review, override rate |
| Cost | Cost per task, tokens per task, cache hit rate |
| Latency | p50 and p95, end to end and per stage |
| Safety | Guardrail triggers, refusal rate, blocked tool calls, detected injection attempts |
| Provider | Error rates, timeouts, fallbacks taken |

### 8.3 Alerts

Alert on a quality drop past its tolerance band, a cost spike, a guardrail spike, and review-queue depth. Queue depth "moves first and is usually cheaper to instrument" [L1].

### 8.4 AI incidents

| Incident | First response | Follow-up |
|---|---|---|
| Quality regression | Flag off, or revert to the previous pinned prompt and model | Error analysis, new eval cases |
| Prompt injection exploited | Disable the affected tool or feature | Fix guardrails; add the attack to the eval set |
| Runaway cost | Budget caps, rate limits, kill switch | Per-task cost limits in CI |
| Provider outage | Fallback model, degraded mode, or a queue | Test the fallback path in CI |
| Provider behaviour change under a stable model name | Run the full suite against current traffic; pin or switch | Handle it as a model upgrade |

Every postmortem ends with new eval cases.

### 8.5 Model lifecycle

- Pin exact model versions and record them as dependencies [L1].
- Track provider deprecation dates. "A pinned version is deprecated on the provider's schedule, not yours" [L1].
- Upgrade with the checklist in Appendix A.4.

### 8.6 Cost control

- Set a budget per task.
- Route easy cases to cheaper models and escalate hard ones.
- Cache repeated context and trim context.
- Batch offline work.

Every cost change goes through the evals, because a cheaper version that is worse is not a saving.

---

## 9. Security, safety and governance

### 9.1 OWASP Top 10 for LLM Applications 2025 [7]

| Risk | Main controls |
|---|---|
| LLM01:2025 Prompt Injection | Treat all external content as data, kept separate from instructions; least-privilege tools; confirmation for sensitive actions; red-team cases in the eval set |
| LLM02:2025 Sensitive Information Disclosure | Data rules from `/discover`; scrubbed logs; output filters; no secrets in prompts |
| LLM03:2025 Supply Chain | Pin models and libraries; check licences for code and weights; verify where weights come from |
| LLM04:2025 Data and Model Poisoning | Control where training, fine-tuning and retrieval data come from |
| LLM05:2025 Improper Output Handling | Validate and escape model output before it reaches code, SQL, HTML or a shell |
| LLM06:2025 Excessive Agency | Least privilege, scoped credentials, confirmation before irreversible actions |
| LLM07:2025 System Prompt Leakage | Assume the prompt will be read; keep secrets and access rules out of it |
| LLM08:2025 Vector and Embedding Weaknesses | Access control on retrieval indexes; separation per tenant |
| LLM09:2025 Misinformation | Grounding checks, citations, review routes for high-stakes answers |
| LLM10:2025 Unbounded Consumption | Rate limits, budgets, step caps, timeouts |

### 9.2 Data handling

Settle these in `/discover`:
- what may go to which provider
- what is logged, and for how long
- who can read traces
- how deletion works, including derived copies such as eval cases

The answers decide which candidates can even enter the bake-off.

### 9.3 Governance frameworks

- **NIST AI Risk Management Framework 1.0:** voluntary US guidance, published January 2023 [9].
- **ISO/IEC 42001:2023:** a certifiable standard for an AI management system [10].
- **Sector and regional regulation** (for example the EU AI Act) may add obligations. Check which apply before `/solve`, because they can eliminate candidates.

Traces provide the lineage an audit asks for: which model, prompt and data version produced which output.

---

## 10. Maturity ladder

| Level | What it looks like | Next step |
|---|---|---|
| 0 Vibes | People try prompts and eyeball the results | Collect 20-50 real inputs and write pass/fail criteria |
| 1 Golden set | A dataset and a script, run by hand | Put it in CI and add tracing |
| 2 Gated | Evals block merges and every request is traced | Weekly error analysis, validated judges, online evals |
| 3 Flywheel | Production failures become eval cases every week; a review queue is in place | Per-segment thresholds, an upgrade pipeline for models, cost gates |
| 4 Managed | Every model, prompt and config change passes the same gates automatically; drift is monitored per segment | Keep the criteria current and retire saturated suites |

---

## 11. Anti-patterns

| Anti-pattern | Why it fails |
|---|---|
| Vibe checks as the only test | With no number, no regression can be seen |
| Generic metrics (a "helpfulness score") | They "create a false sense of measurement and progress" [2] |
| An unvalidated LLM judge as the only gate | It "correlates with the failure modes of the thing it grades" [L1] |
| 1-5 rating scales | Graders "struggle with the difference between a 3 and a 4" [2] |
| Tuning against the whole eval set | It overfits, and the score stops predicting production [L1] |
| Regenerating expected outputs from the current model | It "turns every run green and measures nothing" [L1] |
| Labelling with the model under test | Circular, so the score is meaningless [L1] |
| Averaging across segments | It hides the failing segment [L1] |
| Floating model aliases ("latest") | Behaviour changes with no change on your side [L1] |
| Choosing a model from public leaderboards | Benchmarks do not contain your inputs |
| One score for a multi-stage pipeline | It cannot tell you which stage regressed [L1] |
| Building evals after the build | They grade a decision already made [L1] |
| One-sided evals | "One-sided evals create one-sided optimization" [1] |
| Grading an agent's path instead of its outcome | It penalises valid routes nobody anticipated [1] |
| Quarantining a "flaky" eval without measuring its spread | It hides real degradation [L1] |

---

## Appendix A. Templates

### A.1 Eval case record

| Field | Content |
|---|---|
| `id` | A stable identifier |
| `segment` | The segment it belongs to |
| `split` | Dev or held-out |
| `input` | The request, plus fixtures (documents, tool responses) |
| `expected` | A reference output, or the criteria it must meet |
| `must_not` | Behaviours that count as failure |
| `graders` | Which code checks and judges apply |
| `source` | Production trace, expert-written, synthetic, or incident |
| `failure_type` | The failure category it guards, if any |
| `added` | Date and author |

### A.2 Threshold register row

The fields follow [L1].

| Field | Notes |
|---|---|
| Segment | One row per segment |
| Primary metric | One metric, with an exact definition |
| Threshold | The number that must be met |
| Tolerance band | Expected run-to-run spread |
| Sample size | Enough that the band is narrower than the effect you care about |
| Guardrails | Cost per task, p95 latency, refusal rate |
| Date set | Before the first run |

### A.3 Definition of Done for an AI feature

- [ ] Quality owner named and pass/fail criteria written
- [ ] Capability evals exist, were red first, and now meet thresholds in every segment
- [ ] Full regression suite passes, with no zero-tolerance failures
- [ ] Held-out slice scored once and meets thresholds
- [ ] Every new judge validated (true-positive and true-negative rates on held-out labels)
- [ ] Red-team cases added for new inputs and tools
- [ ] Deterministic shell tested with fakes, including failure responses
- [ ] Model and prompt versions pinned and recorded
- [ ] Traces, dashboards and alerts in place
- [ ] Behind a flag that defaults off, with rollback tested
- [ ] A review route exists for low-confidence or high-stakes output
- [ ] Capability evals graduated into regression after rollout

### A.4 Model upgrade checklist

1. Pin the candidate version in a branch and change nothing else.
2. Run the full suite with repeated trials, plus the held-out slice.
3. Compare per segment, including cost, latency and refusal rate.
4. Do error analysis on every case whose result changed, in either direction.
5. Adjust prompts only if needed, as a separate measured change.
6. Shadow in production behind a flag, then canary.
7. Switch, and keep the previous version pinned for rollback until the provider retires it.

### A.5 Bake-off pre-registration

1. The decision and the pipeline stage it covers.
2. The candidates, and the constraint that eliminated each rejected one.
3. Corpus version, segments and counts, with the held-out slice untouched.
4. Primary metric, threshold, tolerance band and sample size per segment.
5. Separate grounding and coverage measures for any generative candidate.
6. The rule that picks the winner, including how ties are broken.
7. The date, recorded before any run.

---

## Appendix B. Where each part is enforced

The phase commands score against [L1] whenever a brief mentions model-backed work: two entries in [`../standards/frameworks/trigger-index.json`](../standards/frameworks/trigger-index.json) load it in every phase, and each phase's exit checklist carries an item for it. [L1] §"By phase" holds the per-phase rules; this chapter is the narrative behind them.

| Part of this chapter | Enforced in |
|---|---|
| 01 Discover: autonomy, cost of a wrong answer, expert grading, the non-AI option, data rules | [L1] §"By phase"; [`../standards/checklists/01-discover-exit.md`](../standards/checklists/01-discover-exit.md) |
| 02 Plan: quality owner, eval set v0, thresholds, held-out slice | [L1] §"By phase"; [`../standards/checklists/02-plan-exit.md`](../standards/checklists/02-plan-exit.md) |
| 02.5 Solve: the bake-off | [`../standards/docs/TECH_SELECTION.md`](../standards/docs/TECH_SELECTION.md) §"Probabilistic candidates" |
| 03 Design: the ladder, the shell, guardrails, the review route, tracing | [L1] §"By phase"; [`../standards/checklists/03-design-exit.md`](../standards/checklists/03-design-exit.md) |
| 04 Build and section 6: error analysis, one change at a time, eval deltas on the PR | [L1] §"Error analysis", §"Tier the gates by cost" |
| 4.2 Graders and judge validation | [L1] §"Graders and judges" |
| 4.3 Capability and regression suites | [L1] §"Capability and regression suites" |
| 4.4 The dataset, including negative cases and the case record | [L1] §"The ground-truth corpus" |
| 4.6 Noise, 4.7 Agents | [L1] §"Flake versus variance", §"Agents" |
| 05 Test: held-out slice, judges, red-team, CI tiers | [L1] §"By phase"; [`../standards/checklists/05-test-exit.md`](../standards/checklists/05-test-exit.md) |
| 06 Ship: shadow, canary, A/B, rollback | [L1] §"By phase"; [`../standards/checklists/06-ship-exit.md`](../standards/checklists/06-ship-exit.md) |
| 07 Run and section 8: traces, dashboards, alerts, AI incidents | [L1] §"Production drift"; [`../standards/operations/OBSERVABILITY.md`](../standards/operations/OBSERVABILITY.md); [`../standards/operations/ON_CALL.md`](../standards/operations/ON_CALL.md) |
| 08 Evolve and A.4: the flywheel, model upgrades, criteria review | [L1] §"Model upgrades", §"By phase" |
| 9.1 OWASP Top 10 for LLM Applications | [`../standards/security/OWASP.md`](../standards/security/OWASP.md); the security-reviewer's `SEC-LLM-*` findings |
| Roles, rituals, the maturity ladder | Not scored. They describe how a team runs the process |

---

## Sources

First fetched on 2026-09-19; every quotation re-read against its source on 2026-09-26 (see [`../research/05-testing/llm-evaluation.md`](../research/05-testing/llm-evaluation.md)).

1. Anthropic, "Demystifying evals for AI agents", 2026-01-09. <https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents>
2. Hamel Husain, "A Field Guide to Rapidly Improving AI Products", 2025-03-24. <https://hamel.dev/blog/posts/field-guide/>
3. Hamel Husain, "AI Evals: Everything You Need to Know", modified 2026-09-18. <https://hamel.dev/blog/posts/evals-faq/>
4. Shankar, Zamfirescu-Pereira, Hartmann, Parameswaran and Arawjo, "Who Validates the Validators? Aligning LLM-Assisted Evaluation of LLM Outputs with Human Preferences", arXiv 2404.12272. <https://arxiv.org/abs/2404.12272>
5. Anthropic, "Building effective agents", 2024-12-19. <https://www.anthropic.com/engineering/building-effective-agents>
6. Chip Huyen, *AI Engineering: Building Applications with Foundation Models*, O'Reilly, 2025. Further reading; secondary summaries describe its evaluation-driven development framework. <https://huyenchip.com/books/>
7. OWASP GenAI Security Project, "OWASP Top 10 for LLM Applications 2025". <https://genai.owasp.org/llm-top-10/>
8. OpenTelemetry, GenAI semantic conventions repository. <https://github.com/open-telemetry/semantic-conventions-genai> (relocation notice: <https://opentelemetry.io/docs/specs/semconv/gen-ai/>)
9. NIST, AI Risk Management Framework. <https://www.nist.gov/itl/ai-risk-management-framework>
10. ISO/IEC 42001:2023, AI management system. ISO's own page was not fetched (it returned HTTP 403 on 2026-09-26). Comparison with the NIST framework: <https://docs.modulos.ai/frameworks/comparison/iso-42001-vs-nist-ai-rmf>

**L1.** Local standard: [PROBABILISTIC_COMPONENTS.md](../standards/frameworks/PROBABILISTIC_COMPONENTS.md).
