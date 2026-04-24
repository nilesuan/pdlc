---
name: security stack
description: Industry-standard application-security frameworks, tools, and identity protocols
type: research
---

# Security

**Question:** What are the current industry-standard frameworks, tools, and protocols for application security in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Application security — vulnerability-class guidance (OWASP), secure-development frameworks (NIST SSDF), code / dependency / container scanning (SAST/DAST/SCA), identity and access management (OAuth, OIDC, IdPs), secrets management, supply-chain security (signing, SBOMs, SLSA), and zero-trust architecture. Infrastructure-layer security is entangled with `08-cloud.md` and `06-orchestration.md`.

## Shape of the decision

Security is not a single choice but a stack of complementary controls:

1. **Threat model & classification** — OWASP Top 10 (web), OWASP API Security Top 10, OWASP MASVS (mobile), CWE catalog, STRIDE.
2. **Secure-development framework** — NIST SSDF (SP 800-218), BSIMM, SAFECode practices.
3. **Scanning tools in CI** — SAST (your code), SCA (dependencies), secret scanning, container scanning, IaC scanning, DAST (running app).
4. **Identity and access** — OAuth 2.0 / OIDC as the interop standard, with an IdP (Okta/Auth0, Entra ID, Keycloak, Ping, ForgeRock) and an authorization model (OPA/Cedar, RBAC/ABAC, SPIFFE for services).
5. **Secrets management** — HashiCorp Vault, cloud-vendor secret managers, 1Password/Doppler.
6. **Supply-chain** — Sigstore / cosign for signing, SLSA provenance, SBOMs (SPDX/CycloneDX), attestations.
7. **Runtime / cloud** — CSPM, CWPP, CNAPP (Wiz, Prisma Cloud, Orca, Lacework, Aqua, Sysdig), EDR, SIEM.
8. **Architecture** — Zero Trust per NIST SP 800-207.

## Evidence base

- **OWASP Top 10:2021 — primary.** [[OWASP Top 10:2021](https://owasp.org/Top10/2021/)] (accessed 2026-04-24) [VERIFIED]. Methodology [[Introduction](https://owasp.org/Top10/2021/A00_2021_Introduction/)] [VERIFIED]: over 500,000 applications analyzed, almost 400 CWEs considered, average 19.6 CWEs per category. Eight categories from contributed data, two from community survey. Twelve organizations contributed testing data, including Veracode, HackerOne, and GitLab.
- **NIST SSDF — primary.** [[NIST SP 800-218 (SSDF v1.1, Final)](https://csrc.nist.gov/pubs/sp/800/218/final)] (accessed 2026-04-24) [VERIFIED]. Published February 2022. Four practice groups: Prepare the Organization (PO), Protect the Software (PS), Produce Well-Secured Software (PW), Respond to Vulnerabilities (RV). Augmented by **SP 800-218A** for generative-AI models.
- **NIST Zero Trust — primary.** [[NIST SP 800-207 Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final)] (accessed 2026-04-24) [VERIFIED]. Seven tenets. Supplemented by **800-207A** for cloud-native multi-cloud access control.
- **OAuth 2.0 — primary.** [[RFC 6749 — The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749)] (accessed 2026-04-24) [VERIFIED]. Companion [[RFC 6750 — Bearer Token Usage](https://www.ietf.org/rfc/rfc6750.txt)] [VERIFIED].
- **OpenID Connect — primary.** [[OpenID Connect Core 1.0 — OpenID Foundation](https://openid.net/specs/openid-connect-core-1_0.html)] (accessed 2026-04-24) [VERIFIED]. Sits on top of OAuth 2.0 (RFCs 6749 and 6750) and adds an identity layer.
- **Executive Order 14028 context.** The SSDF's uptake is driven in part by [EO 14028 — Improving the Nation's Cybersecurity](https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/) [UNVERIFIED — not fetched in this session; widely reported to mandate SSDF attestation for federal software suppliers].

## Vulnerability classifications and guidance

### OWASP Top 10:2021

The ten most critical web application security risks per OWASP. Current categories [[OWASP Top 10:2021](https://owasp.org/Top10/2021/)] [VERIFIED]:

1. **A01 Broken Access Control**
2. **A02 Cryptographic Failures**
3. **A03 Injection**
4. **A04 Insecure Design** (new in 2021)
5. **A05 Security Misconfiguration**
6. **A06 Vulnerable and Outdated Components**
7. **A07 Identification and Authentication Failures**
8. **A08 Software and Data Integrity Failures** (new in 2021)
9. **A09 Security Logging and Monitoring Failures**
10. **A10 Server-Side Request Forgery (SSRF)**

### OWASP Top 10:2025

The 2025 release is published at [[OWASP Top 10:2025](https://owasp.org/Top10/2025/)] (accessed 2026-04-24) [VERIFIED]. Ten categories:

1. **A01:2025 Broken Access Control**
2. **A02:2025 Security Misconfiguration**
3. **A03:2025 Software Supply Chain Failures** (new; consolidates and broadens 2021's A06 "Vulnerable and Outdated Components" and A08 "Software and Data Integrity Failures")
4. **A04:2025 Cryptographic Failures**
5. **A05:2025 Injection**
6. **A06:2025 Insecure Design**
7. **A07:2025 Authentication Failures** (renamed from 2021's "Identification and Authentication Failures")
8. **A08:2025 Software or Data Integrity Failures**
9. **A09:2025 Security Logging and Alerting Failures** (renamed from 2021's "Security Logging and Monitoring Failures")
10. **A10:2025 Mishandling of Exceptional Conditions** (new)

Notable changes vs 2021: Security Misconfiguration moves to A02; "Software Supply Chain Failures" is a new dedicated category; SSRF (2021 A10) is absorbed elsewhere; "Mishandling of Exceptional Conditions" is new.

### Adjacent OWASP lists

- **OWASP API Security Top 10 (2023)** — API-specific.
- **OWASP MASVS + MASTG** — Mobile App Security Verification Standard and Testing Guide.
- **OWASP ASVS** — Application Security Verification Standard (levels 1–3).
- **OWASP LLM Top 10 (2023, revised 2024–2025)** — applied to LLM-integrated applications.

### CWE and CVE

- **CWE** (Common Weakness Enumeration — MITRE) — the taxonomy of weakness types. Each OWASP Top 10 category maps to a set of CWEs.
- **CVE** (Common Vulnerabilities and Exposures — MITRE / NVD) — specific vulnerabilities in specific products. Each vulnerability has a CVSS score (Common Vulnerability Scoring System).

### Threat modeling

- **STRIDE** (Microsoft) — Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege.
- **PASTA**, **LINDDUN** (privacy-focused), **attack trees** — used in specific contexts.
- Tools: Microsoft Threat Modeling Tool, OWASP Threat Dragon, IriusRisk (commercial).

## Secure-development frameworks

### NIST SSDF (SP 800-218 v1.1)

[[NIST SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final)] [VERIFIED]. Four practice groups:

- **Prepare the Organization (PO)** — define security requirements, implement roles and responsibilities, implement supporting toolchains.
- **Protect the Software (PS)** — protect all code and configuration from unauthorized access/tampering, archive/protect releases.
- **Produce Well-Secured Software (PW)** — design, review, test, and verify security of software.
- **Respond to Vulnerabilities (RV)** — identify, analyze, remediate vulnerabilities; root-cause analysis.

EO 14028 drove SSDF to become the de-facto US-federal procurement standard [UNVERIFIED specific attestation requirement text — widely reported].

### BSIMM (Building Security In Maturity Model)

- Synopsys-operated, annual report (BSIMM 15 published 2024) [UNVERIFIED specific edition numbering]. Descriptive — observes what real firms do rather than prescribing. Organizes software-security activities into four domains and twelve practices.

### ISO/IEC 27034, OpenSAMM

- **ISO/IEC 27034** — ISO standard for application security. Less commonly referenced than SSDF or BSIMM in practice [UNVERIFIED adoption data].
- **OWASP SAMM (Software Assurance Maturity Model)** — open alternative to BSIMM, more prescriptive.

## Scanning in CI (SAST / SCA / DAST / secrets / container / IaC)

### Static Application Security Testing (SAST)

Analyzes source or bytecode for vulnerable patterns.

- **GitHub CodeQL** (part of GitHub Advanced Security).
- **Semgrep** — open-source, rule-based, fast; strong community rule packs.
- **SonarQube / SonarCloud** — code-quality + SAST.
- **Snyk Code** — ML-assisted SAST.
- **Checkmarx, Veracode, Fortify (OpenText)** — enterprise SAST.

### Software Composition Analysis (SCA)

Checks third-party dependencies against vulnerability databases.

- **GitHub Dependabot** — free, deeply integrated into GitHub; PRs to upgrade vulnerable deps.
- **Snyk Open Source** — dependency scanning + fix PRs.
- **Sonatype Nexus Lifecycle / OSS Index.**
- **Mend (formerly WhiteSource), Black Duck (Synopsys).**
- **Renovate** (open source) — covers the "bumps and keeps deps current" side; pairs with any SCA.
- **OWASP Dependency-Check**, **OWASP Dependency-Track** — open-source alternatives.

### Secret scanning

- **GitHub secret scanning / push protection** — free on public repos; part of Advanced Security for private.
- **Gitleaks, TruffleHog, detect-secrets** — open-source CLI scanners.
- **GitGuardian** — commercial, broad ecosystem coverage.

### Dynamic Application Security Testing (DAST)

Probes the running application.

- **OWASP ZAP** — open source.
- **Burp Suite (PortSwigger)** — dominant for manual pentesting; Burp Suite Enterprise for CI.
- **StackHawk** — developer-first DAST.
- **Veracode DAST, Invicti, Acunetix.**

### Container and image scanning

- **Trivy (Aqua Security)** — open source, widely used; scans container images, filesystem, IaC.
- **Grype (Anchore)** — open source.
- **Snyk Container**, **Docker Scout**, **JFrog Xray**, **Prisma Cloud / Twistlock.**

### IaC scanning

- **Checkov (Bridgecrew / Prisma Cloud)**, **tfsec (Aqua)**, **KICS (Checkmarx)**, **Terrascan (Accurics/Tenable)**.
- **OPA / Conftest** — policy-as-code against Terraform plans or Kubernetes manifests.

### Consolidation

Many vendors now offer unified ASPM (Application Security Posture Management) or CNAPP platforms that consolidate these scans. Snyk, Checkmarx One, GitHub Advanced Security, GitLab Ultimate, and cloud vendors' native tools sit in this space.

## Identity and access

### Protocols

- **OAuth 2.0** — authorization framework [[RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)] [VERIFIED]. Defines grant types, tokens, scopes.
- **OAuth 2.1** — consolidation of best practices; draft-status at points in 2024–2025 [UNVERIFIED publication status].
- **OpenID Connect (OIDC) 1.0** — identity layer on top of OAuth 2.0 [[OIDC Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)] [VERIFIED].
- **SAML 2.0** — older enterprise SSO standard; still widely used in B2B / B2E contexts.
- **FIDO2 / WebAuthn / Passkeys** — phishing-resistant authentication; pushed by Apple, Google, Microsoft through 2023–2025.
- **SCIM** — user/group provisioning across systems.
- **mTLS, SPIFFE/SPIRE** — service-to-service identity.

### Identity providers

- **Okta** — workforce identity leader. Acquired Auth0 in 2021 [UNVERIFIED date]. Secondary-source market estimates place Okta at ~12–21% of the broader IAM market with broader CIAM share via Auth0 [UNVERIFIED primary data].
- **Microsoft Entra ID** (formerly Azure Active Directory) — dominant for Microsoft-centric enterprises and Microsoft 365 tenants.
- **Ping Identity** — large enterprise SSO.
- **ForgeRock** — acquired by Thoma Bravo; often paired with Ping.
- **Keycloak** (Red Hat / CNCF incubating) — open source; widely used for self-hosted IAM. [UNVERIFIED CNCF status — Keycloak is a Red Hat / JBoss project; I did not verify CNCF membership specifically in this session.]
- **Auth0** (part of Okta) — developer-first CIAM.
- **AWS Cognito, GCP Identity Platform / Firebase Auth, Azure AD B2C** — cloud-vendor CIAM.
- **WorkOS** — API-first B2B SSO.
- **Clerk, Supabase Auth, Stack Auth, Logto** — developer-focused newer entrants.

### Authorization / policy

- **Open Policy Agent (OPA)** — CNCF graduated; Rego DSL; general-purpose policy engine.
- **Cedar** (AWS) — policy language behind Amazon Verified Permissions.
- **OpenFGA** — ReBAC (Google Zanzibar-style) policy engine, CNCF sandbox [UNVERIFIED status].
- **SpiceDB** (Authzed) — Zanzibar-based permissions.

## Secrets management

- **HashiCorp Vault** — widely described as the default self-hostable secrets manager; now under HashiCorp/IBM. Features: dynamic secrets, lease-based access, PKI, transit encryption, many backend plugins. "Industry standard for secrets management" is a vendor-adjacent claim [UNVERIFIED as a primary-survey result; de-facto presence is strong].
- **AWS Secrets Manager, GCP Secret Manager, Azure Key Vault** — cloud-native default for workloads in-cloud.
- **1Password Secrets Automation, Doppler, Infisical** — developer / SaaS-first alternatives.
- **Kubernetes:** External Secrets Operator bridges a cluster to Vault / cloud secret managers.
- **SOPS (Mozilla)** — encrypts secrets files in Git.

## Supply-chain security

### Signing and attestation

- **Sigstore** — CNCF graduated (2022) [[CNCF graduation — secondary sources]] [VERIFIED qualitatively]. Components: **Cosign** (signing tool), **Fulcio** (CA), **Rekor** (transparency log). Keyless signing via OIDC-bound short-lived certs.
- **in-toto** — supply-chain attestation framework; used to describe provenance.
- **GitHub artifact attestations** — built on Sigstore; standard way to attest provenance for built artifacts.

### Frameworks

- **SLSA (Supply-chain Levels for Software Artifacts)** — levels 1–4 defining provenance and build-integrity requirements. Driven by Open Source Security Foundation (OpenSSF).
- **OpenSSF Scorecard** — automated security-hygiene checks for open-source repos.
- **OpenSSF Best Practices Badge** — self-certification program (formerly CII Best Practices).

### SBOMs

- **SPDX** — ISO-standard SBOM format.
- **CycloneDX** — OWASP-maintained SBOM format, strong VEX (Vulnerability Exploitability eXchange) support.
- Tools to generate: **Syft (Anchore)**, `trivy image --format cyclonedx`, `npm sbom`, `cdxgen`.

### Package-registry security

- **PyPI, npm, crates.io** now support trusted publishing (OIDC-based upload), 2FA for maintainers, and increasingly require Sigstore-signed releases. PyPI Trusted Publishers and npm provenance are live in 2024–2025 [UNVERIFIED exact timeline].

## Runtime and cloud security

- **CSPM** (Cloud Security Posture Management) — Wiz, Prisma Cloud (Palo Alto), Lacework, Orca, Aqua, Sysdig Secure, AWS Security Hub, Microsoft Defender for Cloud.
- **CNAPP** (Cloud-Native Application Protection Platform) — unified CSPM + CWPP + SCA + container scanning.
- **CWPP** (Cloud Workload Protection Platform) — runtime protection on VMs / containers / serverless.
- **eBPF-based runtime security** — **Falco** (CNCF graduated), **Tetragon** (Isovalent/Cisco, built on Cilium).
- **EDR/XDR** — CrowdStrike, SentinelOne, Microsoft Defender, Palo Alto Cortex XDR.
- **SIEM** — Splunk, Microsoft Sentinel, Elastic SIEM, Chronicle (Google), Sumo Logic, Datadog Cloud SIEM.

## Zero Trust Architecture

[[NIST SP 800-207](https://csrc.nist.gov/pubs/sp/800/207/final)] [VERIFIED]. Seven tenets (summarized):

1. All data sources and computing services are resources.
2. All communication is secured regardless of network location.
3. Access granted per-session.
4. Access determined by dynamic policy.
5. Enterprise monitors and measures integrity/security posture.
6. Authentication and authorization are dynamic, strictly enforced before access.
7. Enterprise collects information to improve posture.

Practical ZTA stacks blend: IdP with strong MFA / passkey, device posture, per-request authorization, mTLS between services (service mesh or SPIFFE), policy engine (OPA/Cedar), observability for anomalies. Commercial ZTNA products: Cloudflare Access / Zero Trust, Zscaler, Tailscale, Netskope, Palo Alto Prisma Access.

## Compliance regimes that shape the stack

These drive concrete security-tool investment in most organizations:

- **SOC 2 (Type I / II)** — AICPA; common SaaS baseline.
- **ISO/IEC 27001:2022** — information security management system.
- **PCI DSS v4.0** — payment card data.
- **HIPAA, HITRUST** — US health data.
- **GDPR** — EU personal data.
- **CCPA/CPRA** — California.
- **FedRAMP** — US federal cloud.
- **EU Cyber Resilience Act, NIS2** — EU product and infrastructure mandates.
- **DORA** (not the DevOps metrics — the EU Digital Operational Resilience Act for finance).

## Putting the stack together (typical 2026 defaults)

- **GitHub-native startup:** GitHub Advanced Security (CodeQL SAST + Dependabot SCA + secret scanning) + GitHub artifact attestations (Sigstore) + Okta/Auth0 or WorkOS IdP + cloud-vendor Secrets Manager + OIDC-based CI deploys.
- **Enterprise AppSec program:** Semgrep / Checkmarx / Veracode SAST + Snyk / Sonatype SCA + GitGuardian secret scanning + Burp Suite Enterprise DAST + Vault for secrets + Okta + CNAPP (Wiz / Prisma) + SIEM (Splunk / Sentinel).
- **Kubernetes platform:** Falco runtime + Trivy image scanning + Kyverno or Gatekeeper (OPA) admission + SPIFFE/SPIRE for service identity + cert-manager + Kubernetes NetworkPolicy / Cilium.
- **OSS maintainer:** OpenSSF Scorecard + Dependabot/Renovate + Sigstore signing + CycloneDX or SPDX SBOMs published alongside releases.

## Sources (accessed 2026-04-24)

- [OWASP Top 10:2021](https://owasp.org/Top10/2021/)
- [OWASP Top 10:2021 — Introduction / Methodology](https://owasp.org/Top10/2021/A00_2021_Introduction/)
- [OWASP Top 10:2025](https://owasp.org/Top10/2025/)
- [NIST SP 800-218 SSDF v1.1 (Final)](https://csrc.nist.gov/pubs/sp/800/218/final)
- [NIST SP 800-207 Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final)
- [RFC 6749 — OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749)
- [RFC 6750 — OAuth 2.0 Bearer Token Usage](https://www.ietf.org/rfc/rfc6750.txt)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)

## Open questions

- **Exact IAM / CIAM market share 2024** — Okta / Entra ID / Auth0 secondary estimates vary 12–21% / larger-for-Entra. No single primary survey extracted.
- **Keycloak's governance** — open source under Red Hat; CNCF status not verified in this session.
- **Sigstore / SLSA adoption share** — widely described as growing; no primary survey.
- **SBOM format adoption split** — SPDX vs CycloneDX; anecdotal.
- **EO 14028 / SSDF attestation impact** — widely described but specific federal-agency attestation data not fetched.
- **Cloud-native security platform (CNAPP) market split** — Wiz / Prisma / Lacework / Orca — varies by analyst (Gartner MQ not fetched).
