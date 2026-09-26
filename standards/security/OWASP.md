# OWASP.md — Top 10 application risks + ASVS levels

**Authoritative source:** [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) §10 (Security baseline); [`../../research/03-design/security-design.md`](../../research/03-design/security-design.md); [`../../research/05-testing/non-functional-testing.md`](../../research/05-testing/non-functional-testing.md) (Security testing section).

## OWASP Top 10 — primary categories

The OWASP Top 10 is the de-facto list of the most critical web application security risks. This system targets the latest published edition; current code-reviewer / security-reviewer rules below match the categories. Verify the current version when citing externally.

| ID | Category | Common manifestation |
|---|---|---|
| A01 | Broken Access Control | IDOR, missing authz check, force-browsing |
| A02 | Cryptographic Failures | Plaintext storage, weak hash, TLS misconfig |
| A03 | Injection | SQL injection, command injection, LDAP, NoSQL |
| A04 | Insecure Design | Missing threat model, no rate limit on critical flow |
| A05 | Security Misconfiguration | Default creds, debug endpoints exposed, verbose errors |
| A06 | Vulnerable & Outdated Components | Unpatched library with known CVE |
| A07 | Identification & Authentication Failures | Weak session mgmt, missing MFA, credential stuffing |
| A08 | Software & Data Integrity Failures | Unsigned artifact, untrusted deserialization, supply-chain |
| A09 | Security Logging & Monitoring Failures | No audit log on auth events, log tampering possible |
| A10 | Server-Side Request Forgery | Internal-network access via user-controlled URL |

## Hard rules

1. **Threat model every new service.** STRIDE applied at design time (Phase 03). Stored alongside the design doc; revisited on major changes.
2. **No secret in source.** gitleaks / trufflehog in pre-commit + CI. A secret in git history is treated as compromised — rotate immediately.
3. **Parameterized queries only.** No string-concatenated SQL, no `f"SELECT ... {x}"`. ORMs OK; raw SQL must use placeholders.
4. **Authn at the gateway, authz at the service.** Authentication terminates at edge; authorization decisions happen close to the resource.
5. **Default deny for authorization.** Allow-list new permissions; never default-allow.
6. **Output encoding by context.** HTML, JS, URL, SQL contexts each get the right escaping.
7. **Dependencies scanned on every PR + nightly.** SCA tool (Dependabot / Renovate / Snyk). Critical CVEs gate merge.
8. **Container images scanned for CVEs** before promotion to preprod; critical CVEs block promotion to prod.
9. **All TLS ≥ 1.2; ≥ 1.3 preferred.** No SSLv3, no TLS 1.0/1.1.
10. **Security headers on every web service.** `Content-Security-Policy`, `Strict-Transport-Security`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`.

## ASVS levels (target by service criticality)

ASVS = Application Security Verification Standard (OWASP). Three levels:

- **L1 — Opportunistic.** All apps. Defends against common, low-skill attackers.
- **L2 — Standard.** Apps handling sensitive business data. The default for product services in this stack.
- **L3 — Advanced.** High-value or high-risk apps (payments, health, critical infrastructure).

Pick a target ASVS level per service in the design doc (Phase 03). The security-reviewer audits against it.

## OWASP Top 10 for LLM Applications 2025

Applies to any component that sends input to a model or acts on a model's output, in addition to the list above. Anything the model reads can try to steer it, because instructions and data share one channel.

| Risk | Main controls |
|---|---|
| LLM01:2025 Prompt Injection | Treat all external content (retrieved documents, tool output, user files) as data, kept apart from instructions; least-privilege tools; confirmation for sensitive actions; injection cases in the eval set |
| LLM02:2025 Sensitive Information Disclosure | The data rules settled in `/discover`; logs scrubbed before write; output filters; no secrets in prompts |
| LLM03:2025 Supply Chain | Pinned models and libraries; licences checked for code and weights separately; provenance of weights verified |
| LLM04:2025 Data and Model Poisoning | Controlled sources for training, fine-tuning and retrieval data |
| LLM05:2025 Improper Output Handling | Model output validated and escaped before it reaches code, SQL, HTML or a shell |
| LLM06:2025 Excessive Agency | Least privilege, scoped credentials, confirmation before irreversible actions |
| LLM07:2025 System Prompt Leakage | Assume the prompt will be read; keep secrets and access rules out of it |
| LLM08:2025 Vector and Embedding Weaknesses | Access control on retrieval indexes; separation per tenant |
| LLM09:2025 Misinformation | Grounding checks, citations, a review route for high-stakes answers |
| LLM10:2025 Unbounded Consumption | Rate limits, budgets, step caps, timeouts |

The threat model for such a component (Phase 03) walks LLM01-LLM10 as well as STRIDE. In Phase 05 the red-team works through the same list, and every attack that works becomes an eval case per [`../frameworks/PROBABILISTIC_COMPONENTS.md`](../frameworks/PROBABILISTIC_COMPONENTS.md).

## Auto-rejection (used by security-reviewer)

| Trigger | Severity |
|---|---|
| Secret committed to repo | Blocker (rotate immediately) |
| Raw SQL string concatenation with user input | Blocker (A03) |
| Authn / authz bypass via missing check on endpoint | Blocker (A01) |
| Deserialization of untrusted input without allowlist | Blocker (A08) |
| Password stored without modern KDF (bcrypt/argon2/scrypt) | Blocker (A02) |
| TLS < 1.2 anywhere | Major (A02) |
| Critical CVE in dependency, no remediation plan | Major (A06) |
| No threat model for new service | Major (A04) |
| User-controllable URL hits internal network without allowlist | Major (A10) |
| Missing security headers on prod web service | Minor → Major depending on header |
| Default creds / debug endpoint reachable in prod | Major (A05) |
| Auth event with no audit log | Major (A09) |
| Model output reaches code, SQL, HTML or a shell without validation or escaping | Blocker (LLM05) |
| Retrieval index shared across tenants without per-tenant access control | Blocker (LLM08) |
| Personal or regulated data sent to a model provider outside the recorded data rules | Blocker (LLM02) |
| Model can call a tool with a write or irreversible effect without least privilege and confirmation | Major (LLM06) |
| Access rules or secrets placed in a system prompt | Major (LLM07); a secret there is also a committed secret |
| External content placed in the instruction channel with no separation, and no injection cases in the eval set | Major (LLM01) |
| Model calls with no rate limit, budget, step cap or timeout | Major (LLM10) |
| Model weights, fine-tuning or retrieval data from an unverified source | Major (LLM03, LLM04) |

## Mapping to PDLC phase

| Phase | Security activity |
|---|---|
| 03 Design | Threat model (STRIDE), ASVS target chosen, abuse cases |
| 04 Build | Secure coding (input handling, parameterized queries), pre-commit hooks |
| 05 Test | SAST, SCA, secrets scan, DAST against staging, ASVS verification |
| 06 Ship | Container scan, image signing, SBOM, OIDC |
| 07 Run | Audit logs reviewed, vuln management, incident response |
| 08 Evolve | Patching SLAs, dependency hygiene, periodic threat-model refresh |

## Anti-patterns to flag

- "We'll do security at the end" — a backloaded threat model finds gaps too late to fix cheaply.
- Custom crypto. Don't roll your own. Use a vetted library (libsodium, AWS KMS, GCP KMS, etc.).
- "It's behind the firewall, so it's safe." Defence-in-depth: assume the perimeter is compromised.
- IAM `*:*` policies. Least privilege; principal/resource/action all scoped.
- Logging the password / token to debug. The grep find later is a data breach.

## Sources

- OWASP Top 10 (owasp.org/Top10/) — verify current edition when citing.
- OWASP ASVS (owasp.org/www-project-application-security-verification-standard/).
- NIST SP 800-218 (Secure Software Development Framework).
- OWASP Top 10 for LLM Applications 2025 (genai.owasp.org/llm-top-10/); risk names verified in [`../../research/05-testing/llm-evaluation.md`](../../research/05-testing/llm-evaluation.md). The controls column is this system's summary, not OWASP's text.
- [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) §10 (Security baseline).
- Research: [`../../research/03-design/security-design.md`](../../research/03-design/security-design.md), [`../../research/05-testing/non-functional-testing.md`](../../research/05-testing/non-functional-testing.md).
