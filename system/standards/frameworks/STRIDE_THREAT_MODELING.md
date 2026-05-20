# STRIDE_THREAT_MODELING.md — Conditional escalation

**Authoritative source:** [`../../../research/03-design/security-design.md`](../../../research/03-design/security-design.md); [`../../../handbook/03-design.md`](../../../handbook/03-design.md); OWASP STRIDE references.

## Activation

Loaded when the brief contains any of: `auth`, `authentication`, `PII`, `payment`, `billing`, `internet-facing`, `trust-boundary`, `STRIDE`, `threat-model`.

## Required artifacts

- **Threat model document** at `docs/threat-models/<feature>.md` with:
  - Per-element STRIDE pass on the C4 container diagram (Spoofing / Tampering / Repudiation / Information Disclosure / DoS / Elevation of privilege).
  - Per threat: status (accept / eliminate / mitigate / transfer) with the chosen control named.
  - Trust boundaries marked on the diagram.
- **Linked ADR** for any non-obvious mitigation (custom auth, encrypted-at-rest scope decisions, etc.).

## Pass-by-pass checks

| Pass | Focus | Required check |
|---|---|---|
| 1 | Correctness | C4 container diagram is current; all internet-facing edges and trust boundaries are drawn |
| 2 | Threat coverage | Every container element has a STRIDE row; no element silently skipped |
| 3 | Mitigations | Every threat has a chosen response; "accept" is justified in writing |
| 4 | Verification | Test or control evidence exists for each "mitigate" entry |
| 5 | Sign-off | Security-reviewer and systems-architect both sign; ADR linked for any custom path |

## Escalation impact

- `max_passes = 5`.
- The security-reviewer agent is **mandatory** in the sub-agent set, run on `opus`.
- A pass cannot be scored if the threat model artifact is missing.

## Sources

- [`../../../research/03-design/security-design.md`](../../../research/03-design/security-design.md) — STRIDE definitions, OWASP references.
- [`../../../handbook/03-design.md`](../../../handbook/03-design.md) — design-phase prescriptions including threat modeling.
- [`../security/OWASP.md`](../security/OWASP.md) — Top 10:2025 categories used as the threat list.
