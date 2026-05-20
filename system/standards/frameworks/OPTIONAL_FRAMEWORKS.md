# OPTIONAL_FRAMEWORKS.md — Conditional escalation triggers

Some kinds of work require deeper review than the default 3-pass loop. This file lists the conditional frameworks the pass-runner can load and the triggers that activate them.

**The default policy is 3 passes.** When a trigger matches, escalate to **5 passes** and load the matching framework's spec into the relevant sub-agent's brief. Only the matching framework is loaded — not the entire optional-frameworks set — so each agent's context budget stays small.

Triggers are evaluated **once at Pass 1 start** by the pass-runner against the brief in `cdocs/.pipeline.json` (task, file paths, keywords from the user's command, diff metadata). Match means: any keyword from the trigger's keyword list appears in the task description, changed-file paths, or diff metadata. Multiple triggers can match; load all matching framework specs.

## How escalation works

```
Pass 1 starts
  ↓
pass-runner reads frameworks/trigger-index.json
  ↓
For each trigger whose keywords match the brief:
  - load standards/frameworks/<spec>.md
  - inline its "Required artifacts" + "Pass-by-pass checks" into the relevant sub-agent's brief
  - set max_passes = 5
  ↓
Run the loop with the merged brief
```

A pass that meets the trigger's pass-specific check **must produce the artifact named in "Required artifacts"** before scoring can proceed. Missing the artifact is a `blocker` (per [`../EVIDENCE.md`](../EVIDENCE.md) auto-rejection rules).

## The framework index

| ID | Phase | Triggers (keywords) | Spec file |
|---|---|---|---|
| `stride-threat-modeling` | design | `auth`, `PII`, `payment`, `internet-facing`, `trust-boundary`, `STRIDE` | [`STRIDE_THREAT_MODELING.md`](STRIDE_THREAT_MODELING.md) |
| `characterization-testing` | build | `legacy-code`, `no-tests`, `refactor`, `behavior-preservation` | [`CHARACTERIZATION_TESTING.md`](CHARACTERIZATION_TESTING.md) |
| `contract-regression` | build, test | `public-API`, `shared-library`, `cross-team`, `consumer`, `provider`, `contract` | [`CONTRACT_REGRESSION.md`](CONTRACT_REGRESSION.md) |
| `feature-flags` | build, ship | `behavior-change`, `phased-rollout`, `canary`, `percentage`, `flag` | [`FEATURE_FLAGS.md`](FEATURE_FLAGS.md) |
| `experimentation` | discover, ship, evolve | `A/B-test`, `experiment`, `hypothesis`, `primary-metric`, `hypothesis-ledger`, `holdout` | [`EXPERIMENTATION.md`](EXPERIMENTATION.md) |
| `performance-budget` | build, test | `latency`, `p99`, `hot-path`, `bundle-size`, `database-query` | [`PERFORMANCE_BUDGET.md`](PERFORMANCE_BUDGET.md) |
| `failure-injection` | build, run | `external-service`, `retry`, `circuit-breaker`, `availability`, `chaos` | [`FAILURE_INJECTION.md`](FAILURE_INJECTION.md) |
| `composition-verification` | build, test | `wire`, `entry-point`, `daemon`, `lifecycle`, `register`, `multi-component` | [`COMPOSITION_VERIFICATION.md`](COMPOSITION_VERIFICATION.md) |

The machine-readable form is [`trigger-index.json`](trigger-index.json). Keep both files in sync when adding a trigger.

## Adding a new framework

1. Establish grounding: every framework's "Required artifacts" and "Pass-by-pass checks" must trace to a primary source in `research/`, `handbook/`, or `platform-team/`. No fabricated rules.
2. Write the spec file using the structure of an existing framework (e.g., [`CHARACTERIZATION_TESTING.md`](CHARACTERIZATION_TESTING.md)).
3. Add the trigger to the table above and to `trigger-index.json`.
4. Add a row to [`../../MAPPING.md`](../../MAPPING.md) under "Frameworks".

## Sources

- The trigger-index pattern is the dominant escalation shape from `~/.claude.old/standards/frameworks/`; see [`../../../SYSTEM.md`](../../../SYSTEM.md).
- Per-framework grounding is named in each framework's own Sources section.
