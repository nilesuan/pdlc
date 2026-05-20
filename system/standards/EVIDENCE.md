# EVIDENCE.md — Claim schemas and auto-rejection rules

This file defines layer 4 of the six-layer anti-hallucination protocol — see [`ANTI_HALLUCINATION.md`](ANTI_HALLUCINATION.md) for the full stack.

Every finding produced by an agent in this system must carry evidence in one of three schemas. The pass-runner auto-rejects findings that fail validation. Auto-rejection counts against the pass score.

This file defines: the three schemas, the universal required fields, the auto-rejection triggers, and worked examples.

---

## Why evidence is mandatory

A finding without evidence is an opinion. The user does not need our opinions; they need claims they can verify or act on. Evidence is what makes the difference.

The cross-verifier exists specifically to confirm evidence is real. It is the highest-leverage hallucination control in the system.

---

## Universal required fields

Every finding, regardless of kind, must include:

- `id` — kebab-case, prefixed with the agent's domain (e.g., `SEC-AUTH-01`, `BUILD-TDD-03`, `PLAT-TF-02`). The trailing `-NN` is stripped to derive a **prefix** (`SEC-AUTH-01` → `SEC-AUTH`); per-prefix historical accuracy is applied during scoring per [`process/CALIBRATION.md`](process/CALIBRATION.md).
- `severity` — `blocker | major | minor | nit | info`
- `claim` — one sentence, declarative, specific
- `recommendation` — one sentence, actionable
- `confidence` — `0-100` (integer). See "Confidence calibration" and "Severity-gated minimum confidence" below.
- `evidence` — see schemas below

### Confidence calibration

Confidence is a **numeric** 0-100 score, not a categorical label. Bands:

| Band | Meaning |
|---|---|
| 90-100 | Direct evidence, multiply-corroborated (e.g., the file was read, the URL was fetched, AND a second independent signal agrees) |
| 75-89 | Direct evidence from a single source (the file was read, the URL was fetched, no corroboration) |
| 60-74 | Inference from real evidence (the source supports the claim by reasonable extension, not by direct statement) |
| 40-59 | Weak inference (the source touches the area; the claim leaps several steps from it) |
| ≤39 | "I'm not sure" — file as `info` severity per "I'm not sure is a valid finding" below |

If you are tempted to set `confidence: 95` without direct evidence, lower it.

### Severity-gated minimum confidence

A finding's confidence must clear the floor for its severity, or the finding is auto-rejected (trigger 9 below).

| Severity | Min confidence |
|---|---|
| blocker | ≥ 80 |
| major | ≥ 70 |
| minor | ≥ 60 |
| nit | ≥ 50 |
| info | ≥ 30 |

This rule means: a high-severity claim with low confidence is treated as a hallucination risk, not a useful finding. Bring the confidence up (find more evidence) or downgrade the severity.

### Severity → effect on pass score

| Severity | Weight | Per-finding deduction |
|---|---|---|
| blocker | 30 | `30 × (calibrated_confidence / 100)` |
| major | 10 | `10 × (calibrated_confidence / 100)` |
| minor | 3 | `3 × (calibrated_confidence / 100)` |
| nit | 1 | `1 × (calibrated_confidence / 100)` |
| info | 0 | `0` |

The full aggregate formula (with per-prefix calibration, the critical override, and the auto-reject / cross-verifier deductions) lives in [`QUALITY.md`](QUALITY.md). Calibration is defined in [`process/CALIBRATION.md`](process/CALIBRATION.md).

---

## Schema 1 — code-finding

Used when the claim is about the codebase under review.

```yaml
evidence:
  kind: code-finding
  location: <repo-relative-path>:<line>-<line>
  excerpt: |
    <verbatim copy of the lines being claimed about — no edits, no truncation that hides context>
  why: |
    <one or two sentences connecting the excerpt to the claim — what about the excerpt makes the claim true?>
```

Required:
- `location` must be a real path with real line numbers; the cross-verifier will Read the file and confirm.
- `excerpt` must be byte-identical to the file (modulo line endings).
- `why` must explain the connection — without it, the claim is restated.

Worked example:

```yaml
- id: BUILD-TDD-04
  severity: major
  claim: "API handler add_user has no test for the duplicate-email path."
  evidence:
    kind: code-finding
    location: src/api/users.py:42-58
    excerpt: |
      def add_user(email, password):
          if not email:
              raise ValueError("email required")
          existing = db.users.find_one({"email": email})
          if existing:
              return {"error": "duplicate"}, 409
          ...
    why: |
      The 409 path on line 47 has no corresponding test in tests/api/test_users.py
      (verified by ripgrep for "duplicate" against test files; zero matches).
  recommendation: "Add tests/api/test_users.py::test_add_user_duplicate_email covering the 409 response."
  confidence: 90
```

---

## Schema 2 — factual-assertion

Used when the claim references an external doc, standard, or specification.

```yaml
evidence:
  kind: factual-assertion
  source: <URL or repo-relative-path>
  excerpt: |
    <verbatim quote from the source — the part that supports the claim>
  retrieved: <YYYY-MM-DD>
  why: |
    <how the excerpt supports the claim>
```

Required:
- `source` must be a real URL or path. The cross-verifier will fetch/read it.
- `excerpt` must be a verbatim quote, not a paraphrase.
- `retrieved` is the date you read it (URLs go stale).
- For paywalled or login-gated sources: note that and link to a reachable cache or the closest open equivalent.

Worked example:

```yaml
- id: PLAT-NAMING-01
  severity: blocker
  claim: "Proposed ECS service name 'platform-prod-checkout-fulfillment-orchestrator' exceeds the 32-char service-name limit."
  evidence:
    kind: factual-assertion
    source: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_CreateService.html
    excerpt: |
      "serviceName ... up to 255 characters [for service ARN], but each name must
       be unique within a cluster ... The Application Load Balancer target group
       name must be 32 characters or less ..."
    retrieved: 2026-04-26
    why: |
      AWS limits the ALB target-group name (auto-derived from service name in
      Terraform aws_ecs_service when using load_balancer block) to 32 chars;
      our naming proposal is 51 chars and will fail at apply.
  recommendation: "Shorten to 'plat-prod-co-orchestrator' (24 chars) per AWS_NAMING.md."
  confidence: 92
```

---

## Schema 3 — design-claim

Used when the claim is about design or architecture, where the source is a handbook chapter, an ADR, or a research synthesis.

```yaml
evidence:
  kind: design-claim
  source: <handbook chapter or ADR path>
  cited_excerpt: |
    <quote that directly supports the claim — must exist in the source>
  synthesis: |
    <the part of your claim that is YOUR inference, with reasoning>
  why: |
    <how the cited excerpt + synthesis combine to support the claim>
```

Required:
- A design-claim must explicitly separate the **cited** part from the **synthesis** part. If everything is synthesis, this is not a sourced claim — mark it `[UNVERIFIED]` and lower confidence.
- The cited excerpt must be from the named source, not paraphrased "in the spirit of" the source.

Worked example:

```yaml
- id: ARCH-DEPLOY-02
  severity: major
  claim: "Proposed pipeline rebuilds the container image when promoting to preprod, which violates immutable-promotion policy."
  evidence:
    kind: design-claim
    source: standards/release/CONTAINER_TAGGING.md
    cited_excerpt: |
      "Build the image once. Promote the same image digest across dev → preprod → prod
       by retagging only. Do not rebuild between environments."
    synthesis: |
      The proposed .gitlab-ci.yml has a `build:preprod` stage that runs `docker build`,
      meaning the preprod image is a new build, not the dev image retagged.
    why: |
      The CONTAINER_TAGGING standard (which this repo's release/ team has adopted)
      forbids rebuild-on-promotion specifically because rebuilds re-resolve transitive
      deps and can produce a different artifact than the one tested in dev.
  recommendation: "Replace `build:preprod` with `tag:preprod` that retags the dev digest."
  confidence: 88
```

---

## Auto-rejection triggers

The pass-runner runs each finding through these checks before scoring. A finding that fails any check is dropped and counts as an `auto-reject` deduction against the pass.

| # | Trigger | Why it's rejected |
|---|---|---|
| 1 | Missing `location` (code-finding) | Cannot be verified |
| 2 | Empty `excerpt` | Nothing to confirm |
| 3 | Restated claim — `why` just rephrases `claim` with no new info | No actual evidence |
| 4 | Weasel grounding — claim leans on "typically", "industry-standard", "best practice", "most teams" without a cited source | Authority laundering |
| 5 | Impossible location — file or line doesn't exist | Hallucinated location |
| 6 | Dead source — URL 404s; doc path removed | Hallucinated source |
| 7 | Excerpt doesn't match the source byte-for-byte (ignoring whitespace / line endings) | Fabricated quote |
| 8 | Severity grossly mismatches claim (e.g., `nit` for a SQL injection) | Severity gaming |
| 9 | Confidence below severity-gated minimum (e.g., a `blocker` with `confidence: 65`) | High-severity claim with low confidence is a hallucination risk |

The cross-verifier runs trigger 5, 6, and 7 by re-reading the source. Triggers 1–4, 8, and 9 are checked structurally by the pass-runner.

---

## "I'm not sure" is a valid finding

If you suspect something but can't get to a confident claim, file an `info`-severity finding with `confidence` in the 30–39 band and `kind: clarification-needed`. The pass-runner can route these for follow-up. **Do not** inflate a low-confidence claim by raising the confidence number or by promoting severity to avoid this. The severity-gated minimum table forbids the latter; the former is auto-rejected by the cross-verifier when the evidence does not support the asserted confidence.

```yaml
- id: SEC-CRED-INFO-01
  severity: info
  claim: "Possible credential in config/staging.yml — needs human review."
  evidence:
    kind: clarification-needed
    note: |
      Found `aws_secret_key:` followed by 40-char base64-looking string at config/staging.yml:14.
      Could be a real key, could be a placeholder, could be a test value. I lack context to tell.
  recommendation: "Human to confirm whether this is a real credential and rotate if so."
  confidence: 35
```

---

## Sources

- This file's structure is informed by the user's [`CLAUDE.md`](../../CLAUDE.md) research rules (facts only, no fabrication, sources mandatory).
- The auto-rejection trigger list is derived from observed failure modes in `~/.claude.old/standards/EVIDENCE.md` (see [`../../SYSTEM.md`](../../SYSTEM.md) for the predecessor analysis).
- The three-schema split (code / factual / design) corresponds to the three claim types where verification methods differ — confirmed by the cross-verifier protocol in [`../agents/cross-verifier.md`](../agents/cross-verifier.md).
- The numeric confidence model and the severity-gated minimum-confidence table are ported from `~/.claude.old/standards/QUALITY.md` and `~/.claude.old/commands/_shared/review-pipeline.md` Stage 4d. The 0-100 scale and the per-prefix calibration that consumes it are documented in [`process/CALIBRATION.md`](process/CALIBRATION.md).
- This file is layer 4 of the six-layer protocol in [`ANTI_HALLUCINATION.md`](ANTI_HALLUCINATION.md).
