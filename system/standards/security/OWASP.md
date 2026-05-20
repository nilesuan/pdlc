# OWASP.md — Top 10 application risks + ASVS levels

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §10 (Security baseline); [`../../../research/03-design/security-design.md`](../../../research/03-design/security-design.md); [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md) (Security testing section).

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
- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §10 (Security baseline).
- Research: [`../../../research/03-design/security-design.md`](../../../research/03-design/security-design.md), [`../../../research/05-testing/non-functional-testing.md`](../../../research/05-testing/non-functional-testing.md).
