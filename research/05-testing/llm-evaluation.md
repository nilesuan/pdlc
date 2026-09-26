# LLM Evaluation and LLMOps - Evals as Spec, Gate and Monitor

**Question:** What do the teams that build LLM products, and the bodies that secure and govern them, recommend for evaluating, releasing and running components whose behaviour depends on a model?

**Status:** Draft

**Last updated:** 2026-09-26

---

## Scope

Evaluation-driven development for model-backed components: who owns "good", graders and judge validation, error analysis, capability and regression suites, negative cases, noise and repeated trials, agent evaluation, the layers of evaluation after launch, the OWASP risks specific to LLM applications, trace conventions and governance frameworks.

This file grounds [`../../standards/frameworks/PROBABILISTIC_COMPONENTS.md`](../../standards/frameworks/PROBABILISTIC_COMPONENTS.md) and the prescriptive chapter [`../../handbook/llm-products.md`](../../handbook/llm-products.md). Every quotation below was re-read against its source on 2026-09-26 and matches it character for character, apart from typographic quote marks and italics.

---

## Who owns "good"

Husain recommends one domain expert as the quality decision maker:

> For most small to medium-sized companies, appointing a single domain expert as a "benevolent dictator" is the most effective approach. This person becomes the definitive voice on quality standards.

[VERIFIED] [AI Evals: Everything You Need to Know - Hamel Husain](https://hamel.dev/blog/posts/evals-faq/) (accessed 2026-09-26).

Anthropic's guide makes the same point about who writes cases: "The people closest to product requirements and users are best positioned to define success". [VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

"Good" is partly discovered by grading. Shankar et al. name the effect criteria drift: "users need criteria to grade outputs, but grading outputs helps users define criteria". [VERIFIED] [Who Validates the Validators? - Shankar, Zamfirescu-Pereira, Hartmann, Parameswaran and Arawjo, arXiv 2404.12272](https://arxiv.org/abs/2404.12272) (accessed 2026-09-26).

## Start early and small

"Evals get harder to build the longer you wait." A first set does not need to be large: "20-50 simple tasks drawn from real failures is a great start." [VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

Before there is traffic, "synthetic data can be remarkably effective for evaluation". [VERIFIED] [A Field Guide to Rapidly Improving AI Products - Hamel Husain](https://hamel.dev/blog/posts/field-guide/) (accessed 2026-09-26).

## Negative cases

> Test both the cases where a behavior should occur and where it shouldn't. One-sided evals create one-sided optimization.

[VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

## Graders

Anthropic recommends "deterministic graders where possible, LLM graders where necessary or for additional flexibility". Its grader table lists:

| Grader | Strengths | Weaknesses |
|---|---|---|
| Code-based | "Fast", "Cheap", "Objective", "Reproducible" | "Brittle to valid variations that don't match expected patterns exactly", "Lacking in nuance" |
| Model-based | "Flexible", "Scalable" | "Non-deterministic", "More expensive than code", "Requires calibration with human graders for accuracy" |
| Human | "Gold standard quality" | "Expensive", "Slow" |

[VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

Husain's guide favours pass/fail over scales. Under the heading "Favor Binary Decisions Over Arbitrary Scales" it says that with a 1-5 scale "evaluators frequently struggle with the difference between a 3 and a 4". It also warns that "Generic metrics are worse than useless", because they "create a false sense of measurement and progress", with the example of a team celebrating a better "helpfulness score" while users still struggled with basic tasks. [VERIFIED] [A Field Guide to Rapidly Improving AI Products - Hamel Husain](https://hamel.dev/blog/posts/field-guide/) (accessed 2026-09-26).

## Validating an LLM judge

> Split these examples into train, dev, and test sets. Use 10 to 20 percent for train examples that may appear in the prompt. Use 40 to 45 percent for dev while refining the judge. Reserve the remaining 40 to 45 percent for one final test. When possible, include 30 to 50 Pass examples and 30 to 50 Fail examples in both the dev and test sets.

The two rates it names: "True positive rate (TPR), also called recall, measures how many actual failures the evaluator catches." and "True negative rate (TNR) measures how many good outputs the evaluator correctly passes." [VERIFIED] [AI Evals: Everything You Need to Know - Hamel Husain](https://hamel.dev/blog/posts/evals-faq/) (accessed 2026-09-26).

Both rates are needed because a judge that passes everything has a perfect true negative rate and a true positive rate of zero. [SYNTHESIS]

## Error analysis

Husain calls it "the single most valuable activity in AI development and consistently the highest-ROI activity". [VERIFIED] [A Field Guide to Rapidly Improving AI Products - Hamel Husain](https://hamel.dev/blog/posts/field-guide/) (accessed 2026-09-26).

The method in the evals FAQ: write free-text notes on each trace (open coding), then group them into a failure taxonomy and count each category (axial coding). "Axial coding is the most important step." Keep going "until you reach theoretical saturation, meaning new reviews stop revealing failure modes or changing existing ones", and "We recommend reviewing at least 100 traces." When an agent helps, "After your first 30 annotations, let it search the remaining traces for likely instances of the failures you described." On tooling, a custom annotation tool is "the single most impactful investment you can make for your AI evaluation workflow". [VERIFIED] [AI Evals: Everything You Need to Know - Hamel Husain](https://hamel.dev/blog/posts/evals-faq/) (accessed 2026-09-26).

## Capability and regression suites

Capability evals ask "What can this agent do well?" and "should start at a low pass rate". Regression evals ask "Does the agent still handle all the tasks it used to?" and "should have a nearly 100% pass rate".

> After an agent is launched and optimized, capability evals with high pass rates can "graduate" to become a regression suite that is run continuously to catch any drift.

On saturation: "An eval at 100% tracks regressions but provides no signal for improvement." [VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

## Noise and repeated trials

"pass@k measures the likelihood that an agent gets at least one correct solution in k attempts", while "pass^k measures the probability that all k trials succeed". [VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

How precise a measured pass rate is, at 95% confidence in the worst case (normal approximation, p = 0.5, n = 1.96^2 x 0.25 / e^2): 43 cases give +/- 15 points, 97 give +/- 10, 385 give +/- 5 and 1,068 give +/- 3. [SYNTHESIS]

## Agents

"it's often better to grade what the agent produced, not the path it took", and "You won't know if your graders are working well unless you read the transcripts and grades from many trials".

> Each trial should be "isolated" by starting from a clean environment.

[VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

Anthropic's agent guidance: "we recommend finding the simplest solution possible, and only increasing complexity when needed". It separates workflows, where "LLMs and tools are orchestrated through predefined code paths", from agents, where "LLMs dynamically direct their own processes and tool usage", and for agents recommends "extensive testing in sandboxed environments, along with the appropriate guardrails". [VERIFIED] [Building effective agents - Anthropic](https://www.anthropic.com/engineering/building-effective-agents) (accessed 2026-09-26).

## Layers of evaluation after launch

"no single evaluation layer catches every issue". The guide's own limits for the later layers: production monitoring is "Reactive; problems reach users before you know about them"; A/B testing is "Slow; days or weeks to reach significance and requires sufficient traffic"; user feedback is "Sparse and self-selected". [VERIFIED] [Demystifying evals for AI agents - Anthropic](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) (accessed 2026-09-26).

## Security: OWASP Top 10 for LLM Applications 2025

The ten risks: LLM01:2025 Prompt Injection, LLM02:2025 Sensitive Information Disclosure, LLM03:2025 Supply Chain, LLM04:2025 Data and Model Poisoning, LLM05:2025 Improper Output Handling, LLM06:2025 Excessive Agency, LLM07:2025 System Prompt Leakage, LLM08:2025 Vector and Embedding Weaknesses, LLM09:2025 Misinformation, LLM10:2025 Unbounded Consumption. [VERIFIED] [OWASP Top 10 for LLM Applications 2025 - OWASP GenAI Security Project](https://genai.owasp.org/llm-top-10/) (accessed 2026-09-26).

The control listed against each risk in [`../../standards/security/OWASP.md`](../../standards/security/OWASP.md) is this system's summary, not OWASP's text. [SYNTHESIS]

## Tracing

OpenTelemetry's semantic conventions for generative AI now live in their own repository; the old specification page is headed "Moved: Generative AI semantic conventions". [VERIFIED] [Generative AI semantic conventions - OpenTelemetry](https://opentelemetry.io/docs/specs/semconv/gen-ai/) and [semantic-conventions-genai - OpenTelemetry on GitHub](https://github.com/open-telemetry/semantic-conventions-genai) (accessed 2026-09-26).

## Governance

The NIST AI Risk Management Framework "is intended for voluntary use" and was "Released on January 26, 2023". [VERIFIED] [AI Risk Management Framework - NIST](https://www.nist.gov/itl/ai-risk-management-framework) (accessed 2026-09-26).

ISO/IEC 42001:2023 is a certifiable standard for an AI management system. [UNVERIFIED - iso.org returned HTTP 403 to a fetch on 2026-09-26]

## Further reading

Chip Huyen, *AI Engineering: Building Applications with Foundation Models*, O'Reilly, 2025. No claim in this file rests on it. [UNVERIFIED - not fetched]

## Sources

1. Anthropic, "Demystifying evals for AI agents", Jan 09, 2026. <https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents>
2. Hamel Husain, "A Field Guide to Rapidly Improving AI Products", March 24, 2025. <https://hamel.dev/blog/posts/field-guide/>
3. Hamel Husain, "AI Evals: Everything You Need to Know", modified September 18, 2026. <https://hamel.dev/blog/posts/evals-faq/>
4. Shankar, Zamfirescu-Pereira, Hartmann, Parameswaran and Arawjo, "Who Validates the Validators? Aligning LLM-Assisted Evaluation of LLM Outputs with Human Preferences", arXiv 2404.12272, submitted 18 Apr 2024. <https://arxiv.org/abs/2404.12272>
5. Anthropic, "Building effective agents", Dec 19, 2024. <https://www.anthropic.com/engineering/building-effective-agents>
6. OWASP GenAI Security Project, "OWASP Top 10 for LLM Applications 2025". <https://genai.owasp.org/llm-top-10/>
7. OpenTelemetry, GenAI semantic conventions. <https://github.com/open-telemetry/semantic-conventions-genai> (relocation notice: <https://opentelemetry.io/docs/specs/semconv/gen-ai/>)
8. NIST, AI Risk Management Framework. <https://www.nist.gov/itl/ai-risk-management-framework>
9. ISO/IEC 42001:2023, AI management system. Not fetched (HTTP 403).

All accessed 2026-09-26.
