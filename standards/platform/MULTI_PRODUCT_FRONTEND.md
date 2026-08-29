# MULTI_PRODUCT_FRONTEND.md - One DNS name across many product frontends

**Authoritative source:** [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) "External exposure" (lines 501-506: platform-managed ALB + CloudFront, centrally-managed WAF, platform Route53 zone); [`../security/AUTH.md`](../security/AUTH.md) (Sessions, OAuth 2.1 / OIDC, Authorization); [`../../handbook/03-design.md`](../../handbook/03-design.md) line 412 (frontend default; "Micro-frontends, only at 50+ engineers"); the AWS CloudFront API model, re-checked by [`../../scripts/verify-multi-product-frontend-claims.sh`](../../scripts/verify-multi-product-frontend-claims.sh).

## Scope

Applies when an organisation runs two or more customer-facing product frontends (server-rendered, SPA, or a mix) and wants them reachable without the customer changing hostnames. Does not apply to internal tools, or to a single product with multiple routes.

## The pattern (one-line summary)

**One hostname, path-prefix routing at a shared edge, one OIDC issuer behind it, shared navigation shipped as a versioned package.**

```
app.example.com/billing/*        -> product A origin (S3 + OAC, SPA)
app.example.com/analytics/*      -> product B origin (SSR, ALB)
app.example.com/api/<product>/*  -> that product's API
```

## The three layers (never ship layer 1 alone)

What customers experience as "one product" is three separable layers. Shipping the URL merge without the other two delivers close to nothing, because the customer still hits a login wall crossing products.

| Layer | Delivers | Mechanism |
|---|---|---|
| 1. Routing | One bookmark, one origin, no CORS | Path-prefix cache behaviors at the CDN |
| 2. Identity | One login across products | Single OIDC issuer, one session cookie on the shared host |
| 3. Shell | One navigation, products read as modules | Shared header/design system as a versioned package |

**Layer 2 is the one customers actually feel.** Sequence the work so identity lands with, or before, the second product's migration.

## Topology decision

| | Path-based | Subdomain per product | Runtime micro-frontend |
|---|---|---|---|
| One URL for the customer | Yes | No (one brand, many hosts) | Yes |
| Session sharing | Free (same origin) | Needs a `.example.com` domain cookie | Free |
| CORS between products | None | Must be configured | None |
| Deploy independence | Shared CDN config is contended | Full | Shared runtime is coupled |
| Blast radius of one XSS | All products | Contained to one product | All products |
| Per-product build change | Required | None | Substantial |

**Default: path-based.** Choose subdomains instead when a product sits in a different compliance scope (PCI, HIPAA), is operated by a third party, or is a legacy app that cannot be made base-path aware. A separate origin is a real security boundary; giving it up is a cost, not just plumbing.

**Runtime micro-frontends are out of scope by default**, per [`../../handbook/03-design.md`](../../handbook/03-design.md) line 412 ("Micro-frontends, only at 50+ engineers"). Adopting them needs an ADR.

## Hard rules - routing

1. **R-1. One hostname is the product surface.** All products resolve under a single alias record. Per-product hostnames may continue to exist only as redirect sources (R-8).
2. **R-2. Route by path prefix at the edge, one prefix per product.** The prefix is allocated centrally and is never reused.
3. **R-3. Cache behaviors are ordered; first match wins.** CloudFront compares the requested path against path patterns "in the order in which cache behaviors are listed in the distribution", and the default behavior's pattern is `*` and "cannot be changed". [VERIFIED - `CacheBehavior.PathPattern` documentation in the CloudFront service model; check C-7a/C-7b]. A new product's behavior must be inserted above the catch-all, not appended.
4. **R-4. Never use CloudFront custom error responses for SPA history fallback on a shared distribution.** `CustomErrorResponses` is a member of `DistributionConfig` and is **not** a member of `CacheBehavior` or `DefaultCacheBehavior` [VERIFIED - checks C-1a/C-1b/C-1c]. A 403/404-to-`/index.html` mapping therefore applies to every behavior on the distribution, including API paths, converting genuine API errors into HTTP 200 with an HTML body.
5. **R-5. Do SPA history fallback per behavior, in a CloudFront Function on `viewer-request`.** `PathPattern` and `FunctionAssociations` are both members of `CacheBehavior` [VERIFIED - checks C-2a/C-2b], so the rewrite can be scoped to one product. It must run viewer-side: the API model states you "cannot use origin-facing event types (origin-request and origin-response) with a CloudFront function" [VERIFIED - check C-3].
6. **R-6. Lock S3 origins with Origin Access Control.** Set `Origin.OriginAccessControlId` [VERIFIED - checks C-6a/C-6b]. No public bucket policy, per [`AWS_ECS_TERRAFORM.md`](AWS_ECS_TERRAFORM.md) auto-rejection ("Public S3 bucket without explicit ADR").
7. **R-7. Serve each product's API under the shared host** (`/api/<product>/*`) so no product needs CORS. A product that still needs CORS after migration has a routing bug.
8. **R-8. Old hostnames redirect permanently and are never retired on a schedule.** `301` each retired hostname to its new path prefix. Bookmarks and saved links outlive every migration.

## Hard rules - build

1. **B-1. Every app is base-path aware before it is routed.** Next.js `basePath` ("Deploy a Next.js application under a sub-path of a domain"), Vite `base`, Angular `--base-href`. [VERIFIED for Next.js - `basePath?: string` in `next/dist/server/config-shared.d.ts`; check N-1]. Papering over a non-base-path-aware app with edge rewrites is forbidden: the rewrite layer becomes unmaintainable within a few products.
2. **B-2. Every product has a unique static-asset prefix.** Two products both serving `/assets/*` or `/static/*` will silently shadow each other. Next.js exposes `assetPrefix` for the case where a product owns several unrelated top-level paths [VERIFIED - `assetPrefix?: string`, check N-2].
3. **B-3. URL paths are globally unique across products.** Prefix allocation (R-2) is the register; there is no per-product override.
4. **B-4. Hashed assets are immutable; HTML is not cached.** Serve build-hashed assets as `public, max-age=31536000, immutable` [VERIFIED - this exact string ships in the Next.js distribution; check N-4] and HTML with a no-cache or very short TTL. This is what makes O-2 possible.

## Hard rules - identity

1. **I-1. One OIDC issuer for all products.** Authorization Code with PKCE, per [`../security/AUTH.md`](../security/AUTH.md) (OAuth 2.1 / OIDC rule 1).
2. **I-2. One session cookie on the shared host,** with `Secure`, `HttpOnly`, and `SameSite=Lax` minimum, per [`../security/AUTH.md`](../security/AUTH.md) (Sessions rule 2). No per-product cookie jar on a shared origin.
3. **I-3. Redirect URIs stay exact-match allowlisted.** Consolidating onto one host makes wildcards look tempting; they remain forbidden per [`../security/AUTH.md`](../security/AUTH.md) (OIDC rule 5).
4. **I-4. The edge is not an authorization boundary.** Every product authorizes at its own resource boundary; a request that bypassed the edge must still fail authz, per [`../security/AUTH.md`](../security/AUTH.md) (Authorization rule 1). Path-prefix routing grants routing, never permission.

## Hard rules - operations

1. **O-1. The shared distribution has one owning team.** It is a single Terraform resource, so N product teams editing it concurrently means merge conflicts on one applied object. Behaviors are generated from a data structure (a products map), making product onboarding a one-line diff. Per [`TERRAFORM_DISCIPLINE.md`](TERRAFORM_DISCIPLINE.md).
2. **O-2. Cache invalidations are path-scoped; `/*` is forbidden.** On a shared distribution, one team's `/*` invalidation flushes every product. With B-4 in place, routine deploys should require no invalidation at all.
3. **O-3. Per-path CSP is mandatory on a shared origin.** A shared host means one XSS reaches every product's session. `ResponseHeadersPolicyId` is a `CacheBehavior` member and the policy carries `ContentSecurityPolicy` [VERIFIED - checks C-5a/C-5b], so each product gets its own CSP. No `unsafe-inline`.
4. **O-4. Treat WAF posture as shared and centrally owned.** `WebACLId` is a member of `DistributionConfig` and is **not** a member of `CacheBehavior` [VERIFIED - checks C-4a/C-4b]: one product's rate-limit or rule change applies to all. This matches the existing central-WAF rule in [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) (line 504).
5. **O-5. Every RUM event, log line, and metric carries a `product` dimension.** Consolidating hostnames destroys the free per-product dimension that the hostname used to provide.

## Reference wiring (AWS)

| Path pattern | Origin | Cache policy | Notes |
|---|---|---|---|
| `/billing/*` | S3 + OAC | Long TTL for hashed assets | CloudFront Function on `viewer-request` for history fallback (R-5) |
| `/analytics/*` | ALB (SSR service) | `CachingDisabled` for HTML | Origin request policy forwards cookies and required headers |
| `/api/*` | ALB or API Gateway | `CachingDisabled` | No custom error mapping (R-4) |
| `*` (default) | Shell / landing origin | Short TTL | Pattern is fixed at `*` (R-3) |

Route static SPAs to S3 behaviors directly, and send all server-rendered products through **one** behavior to an ALB that does its own path routing. This keeps the number of distribution-level edits proportional to the number of static apps, not to the number of products.

## Quotas you must check, not assume

Design the prefix scheme so it does not sit near a quota, and confirm the live numbers for the account before committing to a behavior-per-product layout.

- Cache behaviors per distribution: **default quota is in the tens and is adjustable on request.** The current published default is 75 [UNVERIFIED - `docs.aws.amazon.com` is not reachable from this environment; value seen only in search summaries of the live quotas page]. The archived AWS documentation mirror gives 25, but that mirror's last commit is 2023-06-15 and its README states it is "archived, read-only, and no longer updated" [OUT OF DATE].
- Confirm both the service code and the live value for your account before designing against either number:

```
aws service-quotas list-services | grep -i cloudfront
aws service-quotas list-service-quotas --service-code cloudfront
```

If a design needs more than a few dozen behaviors, that is the signal to move SSR products behind a single ALB behavior (see Reference wiring) rather than to raise the quota.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| Custom error responses used for SPA fallback on a distribution serving more than one app or any API path (R-4) | Blocker |
| Wildcard OIDC redirect URI introduced during consolidation (I-3) | Blocker |
| Authorization enforced only at the edge, not at the product's resource boundary (I-4) | Blocker |
| Public S3 bucket instead of Origin Access Control (R-6) | Blocker |
| App routed under a path prefix without being base-path aware (B-1) | Major |
| Two products sharing a static-asset prefix (B-2) | Major |
| `/*` cache invalidation in a product's deploy pipeline (O-2) | Major |
| Old product hostname retired without a permanent redirect (R-8) | Major |
| Shared origin with no per-path CSP, or CSP containing `unsafe-inline` (O-3) | Major |
| New behavior appended below the catch-all instead of above it (R-3) | Major |
| Product frontend consolidated onto the shared host with no shared OIDC issuer (I-1) | Major |
| Telemetry with no `product` dimension after consolidation (O-5) | Minor |

## Anti-patterns to flag

- **"We'll unify the URLs now and do SSO later."** This is the most common sequencing error. It delivers a cosmetic change, and the second login prompt tells the customer the consolidation is fake. Layer 2 is the deliverable.
- **Edge rewrites standing in for base paths.** Works for one product, collapses at three. Fix the build (B-1).
- **One god-cookie carrying every product's authority.** A shared origin already widens XSS blast radius; a single token with union-of-all scopes maximises it. Scope tokens per product.
- **Micro-frontend runtime composition adopted to solve a URL problem.** Module Federation does not make hostnames consistent; path routing does, at a fraction of the coupling.
- **Per-product CloudFront distributions chained behind a router distribution.** Adds a full edge hop of latency and a second cache layer to reason about. Prefer behaviors, or an ALB behind one distribution.
- **Treating the shared distribution as unowned shared infrastructure.** Without O-1 it becomes the slowest-moving object in the platform.

## Verification

Run the claim harness. It re-derives every structural assertion above from botocore's shipped CloudFront service model (the same model the AWS CLI and all AWS SDKs are generated from), and optionally re-checks the Next.js configuration surface against the published npm package:

```
scripts/verify-multi-product-frontend-claims.sh             # 14 AWS checks, offline
scripts/verify-multi-product-frontend-claims.sh --with-npm  # + 4 Next.js checks
```

Exit code `0` means every claim still holds. A `FAIL` line names the rule that has gone stale: for example, if `C-1b` ever fails, AWS has moved `CustomErrorResponses` onto `CacheBehavior` and **R-4 must be rewritten**.

Per [`../ANTI_HALLUCINATION.md`](../ANTI_HALLUCINATION.md), this file is an authored artifact and passes `scripts/verify-artifact.sh` before release.

## Sources

- CloudFront service model `service-2.json`, API version `2020-05-31`, as shipped in botocore. Authoritative for every `[VERIFIED]` structural claim (checks C-1 through C-7). Re-checkable offline via the harness above.
- `next` npm package, version 16.3.3: `dist/server/config-shared.d.ts` (`basePath`, `assetPrefix`, `rewrites`) and the `public, max-age=31536000, immutable` header string in `dist/` (checks N-1 through N-4).
- [`../../platform-team/developer-guidelines.md`](../../platform-team/developer-guidelines.md) lines 501-506, "External exposure": platform-managed ALB + CloudFront, centrally-managed WAF, platform Route53 zone.
- [`../security/AUTH.md`](../security/AUTH.md): Sessions, OAuth 2.1 / OIDC, and Authorization hard rules, referenced by I-1 through I-4.
- [`../../handbook/03-design.md`](../../handbook/03-design.md) line 412: frontend default and the 50-engineer threshold for micro-frontends.
- [Micro Frontends - Cam Jackson, martinfowler.com](https://martinfowler.com/articles/micro-frontends.html): background on runtime composition trade-offs. [UNVERIFIED - `martinfowler.com` is not reachable from this environment; URL recorded from search results, contents not re-read here.]
- [Guides: Multi-zones - Next.js](https://nextjs.org/docs/app/guides/multi-zones): the framework-native expression of path-prefix routing. [UNVERIFIED - `nextjs.org` is not reachable from this environment; the underlying `basePath` / `assetPrefix` / `rewrites` configuration surface was instead verified directly against the published package.]
