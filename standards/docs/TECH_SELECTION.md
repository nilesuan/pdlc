# TECH_SELECTION.md — Choosing a technology, architecture, or approach with evidence

**Authoritative sources:** [`ADR.md`](ADR.md) (record format); [`../frameworks/EXPERIMENTATION.md`](../frameworks/EXPERIMENTATION.md) (pre-registration discipline, ported here from A/B testing to bake-offs); [`../EVIDENCE.md`](../EVIDENCE.md) (claim schemas); [`../../techstacks/00-methodology.md`](../../techstacks/00-methodology.md) (source hierarchy and claim tagging); [`../../research/01-ideation/discovery.md`](../../research/01-ideation/discovery.md) (riskiest-assumption test, cheapest evidence that actually proves it).

This standard governs [`../../commands/solve.md`](../../commands/solve.md). It defines what separates a decision that is **proven** from one that is merely **argued**.

## The problem this solves

An ADR with a well-written Alternatives section is still just an opinion if nobody ran anything. Desk research tells you what worked for someone else, on their data, at their scale, under their constraints. It does not tell you what will work here. The gap between "the survey says PostgreSQL is popular" and "PostgreSQL holds our write volume at our latency target" is the entire decision.

The discipline below closes that gap without paying for it on every choice. Most decisions do not deserve a bake-off. The skill is knowing which do.

## Decision classes

Classify every decision before spending anything on it.

| Class | Test | What it needs |
|---|---|---|
| **Load-bearing** | Expensive to reverse, other components will depend on it, or it constrains future options (per [`ADR.md`](ADR.md) §"What an ADR is") | Selection ADR + evidence at the tier the reversal cost demands |
| **Consequential but reversible** | A wrong answer costs days, not quarters | Selection ADR, desk evidence sufficient, no spike |
| **Routine** | Refactor when needed; no downstream dependency | No ADR. Decide in code review. ([`ADR.md`](ADR.md) §"When NOT to write one") |

Misclassifying upward is the more common failure and it is expensive: a bake-off on a routine choice burns a week and produces a document nobody reads. Misclassifying downward is rarer but worse. When genuinely unsure, ask what reversing it costs in six months, and classify on that number.

## Evidence tiers

| Tier | Name | What it is | Sufficient for |
|---|---|---|---|
| 0 | **Asserted** | "Everyone uses X." No source. | Nothing. Auto-rejected per [`../EVIDENCE.md`](../EVIDENCE.md) trigger 4 (weasel grounding). |
| 1 | **Desk** | Cited sources: vendor docs, specs, surveys with disclosed methodology, [`../../techstacks/`](../../techstacks/) | Reversible decisions. Candidate shortlisting. Hard-constraint elimination. |
| 2 | **Reproduced** | Someone else's published benchmark, re-run and confirmed | Load-bearing decisions where our workload genuinely resembles the published one, and we say why |
| 3 | **Spiked** | Our workload, our data, our constraints, thresholds pre-registered | Load-bearing decisions. The default requirement. |

**The rule:** a load-bearing decision needs Tier 3, unless the candidates are not materially different on the deciding axis (say so, and cite what makes them equivalent) or a hard constraint already eliminated everything but one survivor (then the constraint is the evidence, and the ADR records the constraint).

Tag every claim in a selection ADR with its tier. An untagged claim is treated as Tier 0.

## Constraint-first ordering

Run the cheap eliminations before the expensive measurements. In order:

1. **Hard constraints.** Data residency, licence compatibility, compliance regime, regulated-data handling, hard cost ceiling, existing platform commitment, team capability. These are boolean and they are free to check. A candidate that fails one is out, and no benchmark can rescue it.
2. **Desk research** on what survives. Narrow to two to four candidates. Fewer than two is not a decision; more than four means the constraints were not applied properly.
3. **Spike** the survivors on the axis that actually decides.

Benchmarking a candidate that a licence or a data-residency rule already disqualified is the most common way this process wastes a week. For anything touching regulated or personal data, the residency and processing-location constraint is written first, before any candidate list exists, because it typically eliminates whole categories of hosted service.

## Bake-off protocol

A spike is pre-registered before it runs. This is [`../frameworks/EXPERIMENTATION.md`](../frameworks/EXPERIMENTATION.md) §"Pre-registration / hypothesis ledger" applied to technology choice: the same failure modes (HARKing, peeking, moving the metric) apply, and the same discipline prevents them.

Write `solutions/<slug>/spikes/<decision-slug>.md` **before writing any spike code**, with:

| Field | Notes |
|---|---|
| Decision | The question this spike answers, as one sentence |
| Candidates | Two or more. One-candidate spikes are validations, not selections; label them so |
| Representative workload | The actual input the system will face. Real data where lawful, synthetic only where it is not, and say which |
| Primary acceptance metric | One. Exact definition: numerator, denominator, window, units |
| Threshold | The number that decides. Declared now, not after |
| Guardrail metrics | Tracked, not decision-bearing (cost per unit, p99 latency, operational burden) |
| Disqualifiers | Conditions that eliminate a candidate regardless of primary metric |
| Time-box | Wall-clock ceiling. On expiry the spike ends and reports what it has |
| Owner | One person accountable for the result |

Then run it. Rules, ported directly from EXPERIMENTATION:

1. **Threshold declared before results.** Moving the threshold after seeing the numbers invalidates the spike. If the threshold was wrong, say so explicitly, record why, and re-register.
2. **One primary metric.** Secondary metrics inform; they do not decide. Deciding on a secondary metric is HARKing and requires a re-run with that metric as primary.
3. **No peeking-to-stop.** Run to the time-box or to the pre-registered stopping condition. An early call in favour of the candidate you already preferred is the failure this rule exists to catch.
4. **Disqualification is a result.** A candidate eliminated in an hour on a licence term is the cheapest possible outcome. Record it with the same weight as a benchmark win.
5. **An aborted spike is logged, not dropped.** Record the reason. An abandoned spike that leaves no trace gets re-run by the next person.
6. **The harness outlives the spike.** The workload, fixtures, and metric implementation become the regression harness the chosen candidate is held to afterwards. A spike whose code is thrown away has to be repeated to answer "did this regress?".

Rule 6 is what connects this standard to [`../testing/TEST_STRATEGY.md`](../testing/TEST_STRATEGY.md): the acceptance threshold that picked the technology becomes a gate in CI, so a later upgrade that silently breaks it fails the build rather than surprising production.

## The selection ADR

Use the [`ADR.md`](ADR.md) format, with two required additions.

```markdown
## Evidence

| Claim | Tier | Source |
|---|---|---|
| <the claim the decision rests on> | 1-3 | <link: spike record, cited doc, reproduced benchmark> |

Primary metric: <name> = <measured value> against threshold <value>. Spike: <link>.

## Reversal cost

<What it costs to undo this in six months: migration shape, data movement, coupled
components, estimated effort band. State it as a number or a band, not "hard".>
```

The Alternatives section must record the measured result for each candidate that was spiked, and the disqualifying constraint for each candidate that was eliminated. "Rejected because it was slower" without the number is not a comparison.

Selection ADRs share the single `docs/adr/` sequence with design ADRs and follow every hard rule in [`ADR.md`](ADR.md), including permanent numbering and immutability after Accepted.

## Auto-rejection

Used by systems-architect and by the pass-runner during [`../../commands/solve.md`](../../commands/solve.md).

| Trigger | Severity |
|---|---|
| Load-bearing decision recorded with Tier 0 or Tier 1 evidence and no stated reason for the exemption | Blocker |
| Spike threshold set or changed after results were seen | Blocker |
| Selection ADR with a single candidate and no recorded disqualification of alternatives | Major |
| Alternatives rejected without the measured value that rejected them | Major |
| Primary metric swapped mid-spike, or decision made on a secondary metric | Major |
| Candidate benchmarked despite failing a hard constraint | Major (wasted spend, and the result is unusable) |
| Missing Reversal cost section on a load-bearing selection ADR | Major |
| Spike code discarded rather than promoted to a regression harness | Minor |
| Evidence claim with no tier tag | Minor (treated as Tier 0) |

## Anti-patterns

- **Bake-off theatre.** The winner was chosen first; the spike was built to confirm it. The pre-registered threshold is the control, which is why it is written before the code.
- **Benchmarking on toy input.** A parser that handles the clean sample fails on the real corpus. If the representative workload is not representative, the number is decoration.
- **Deciding on aggregate metrics that hide the failure mode you care about.** An average that looks fine while a whole input class fails is the standard way this goes wrong. Segment the metric by input class when the classes differ in difficulty.
- **Resume-driven selection.** Novelty is not a decision criterion. If it is the real reason, the ADR should say so honestly; that is at least auditable.
- **Deferring the constraint check.** Discovering the licence or residency problem after the benchmark is pure waste and it is always avoidable.
- **The permanent evaluation.** Extending the spike because no candidate is clearly best. If they are that close, the decision is not load-bearing on that axis. Pick the one with the lower reversal cost and move.

## Sources

- Record format and hard rules: [`ADR.md`](ADR.md), grounding in Michael Nygard, "Documenting Architecture Decisions" (2011) and [`../../research/03-design/adrs.md`](../../research/03-design/adrs.md).
- Pre-registration, one-primary-metric, no-peeking, HARKing: ported from [`../frameworks/EXPERIMENTATION.md`](../frameworks/EXPERIMENTATION.md) §"Hard rules" and §"Pre-registration / hypothesis ledger", which grounds them in [`../../handbook/08-evolve-processes.md`](../../handbook/08-evolve-processes.md) §4.
- Claim tagging and source hierarchy: [`../../techstacks/00-methodology.md`](../../techstacks/00-methodology.md).
- Evidence schemas and the weasel-grounding auto-reject: [`../EVIDENCE.md`](../EVIDENCE.md).
- "Cheapest evidence that actually proves it": [`../../research/01-ideation/discovery.md`](../../research/01-ideation/discovery.md) (riskiest-assumption testing).
- Proportionality of verification effort to stakes: [`../../CLAUDE.md`](../../CLAUDE.md) §6.
