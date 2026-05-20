# AUTH.md — Authentication and authorization patterns

**Authoritative source:** OWASP ASVS §2 (Authentication), §3 (Session Management), §4 (Access Control); [`OWASP.md`](OWASP.md); [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §10 (Security baseline); [`../../../research/03-design/security-design.md`](../../../research/03-design/security-design.md).

## Authentication

### Hard rules

1. **Use a vetted identity provider.** Cognito, Auth0, Okta, Keycloak, AWS IAM. Do not implement primary authentication from scratch.
2. **Password hashing: argon2id (preferred), bcrypt (acceptable), or scrypt.** Never MD5, SHA-1, SHA-256-without-salt-and-iteration, or anything custom. Per OWASP ASVS V2.4.
3. **Minimum password policy follows NIST SP 800-63B:** ≥ 8 chars, no composition rules, screened against breached-password lists. No 90-day rotation.
4. **MFA required for admin / privileged access.** TOTP or WebAuthn preferred over SMS.
5. **Account lockout / rate limiting on authentication endpoints.** Failed attempts trigger backoff and / or CAPTCHA. Per ASVS V2.2.
6. **Generic error messages.** "Invalid credentials" — never "user not found" vs "wrong password" (account-enumeration).
7. **Credentials never logged.** Pre-commit + CI scans for accidental logging.

## Sessions

### Hard rules

1. **Session ID has ≥ 64 bits of entropy.** From a CSPRNG. Per ASVS V3.2.
2. **Cookie flags on all session cookies:** `Secure`, `HttpOnly`, `SameSite=Lax` minimum (`Strict` where compatible).
3. **Idle timeout + absolute timeout.** E.g. 30 min idle, 12 hr absolute for typical sessions; tighter for admin.
4. **Session fixation defense.** Issue a new session ID on authentication.
5. **Logout invalidates server-side.** A logout that just deletes the cookie is broken.
6. **Concurrent-session policy** decided per service and documented.

## JWTs (when used)

1. **Sign with asymmetric key (RS256 / ES256) for federated tokens; HS256 acceptable for single-issuer.** Never `alg: none`.
2. **Short-lived access tokens (≤ 15 min); refresh token for renewal.**
3. **Validate `iss`, `aud`, `exp`, `nbf`, signature on every request.** Skipping `aud` or `iss` is a common mistake.
4. **Token revocation strategy** documented. Stateless JWT can't be revoked without a deny-list; account for this.
5. **No JWT in `localStorage`** for browser apps if you can avoid it; use HttpOnly cookies. (XSS exfil risk.)

## OAuth 2.1 / OIDC

1. **Authorization Code with PKCE** is the default flow for all clients (public and confidential).
2. **Implicit flow is deprecated.** Don't use it.
3. **Use OIDC for identity (ID tokens); OAuth 2 for delegated access (access tokens).** They are not interchangeable.
4. **Validate `state` parameter** to prevent CSRF on the authorization callback.
5. **Redirect URIs are exact-match allowlisted.** No wildcards, no open redirect.

## Authorization

### Hard rules

1. **Authorization happens at the resource boundary**, not only at the gateway. A request that bypassed the gateway must still fail authz.
2. **Default deny.** Authz checks default to deny; allow-list specific permissions.
3. **Object-level access control on every resource access.** "Can this user see this specific record?" — checked, not assumed from URL membership. (A01 IDOR class.)
4. **RBAC or ABAC chosen explicitly.** RBAC simpler; ABAC more expressive. Mixing both unintentionally creates gaps.
5. **Privilege elevation requires re-auth.** Sensitive actions (password change, admin ops) re-prompt for credentials or step-up MFA.

## Auto-rejection (used by security-reviewer)

| Trigger | Severity |
|---|---|
| Custom-rolled password hashing | Blocker |
| `alg: none` accepted in JWT verification | Blocker |
| JWT signature not verified | Blocker |
| Endpoint with no authz check returns user-specific data | Blocker (A01 / IDOR) |
| Session cookie without `Secure` flag in prod | Major |
| Session cookie without `HttpOnly` flag | Major |
| Refresh token in `localStorage` | Major |
| OAuth flow without PKCE | Major |
| Open redirect in OAuth `redirect_uri` allowlist | Blocker |
| Account lockout / rate limit absent on auth endpoint | Major |
| Login distinguishes "no such user" vs "wrong password" | Minor (enumeration) |
| Privilege escalation without re-auth | Major |

## Anti-patterns to flag

- Storing passwords reversibly. Encryption is not hashing.
- "Trust the JWT" — verify *every* claim relevant to authz.
- "We'll add authz later." Authz retrofits are where IDOR vulnerabilities live forever.
- Role explosion: 47 roles, nobody knows what they grant. Consolidate or move to ABAC.
- Long-lived API keys with broad scope. Use short-lived OIDC-federated credentials wherever possible.

## Sources

- OWASP ASVS V2 (Authentication), V3 (Session), V4 (Access Control) — owasp.org/www-project-application-security-verification-standard/.
- NIST SP 800-63B (Digital Identity Guidelines / Authenticator Assurance).
- IETF RFC 6749 (OAuth 2.0), RFC 7636 (PKCE), RFC 8252 (OAuth for native apps), OAuth 2.1 draft.
- OpenID Connect Core 1.0 spec.
- IETF RFC 7519 (JWT), RFC 8725 (JWT Best Current Practices).
