#!/usr/bin/env bash
# verify-multi-product-frontend-claims.sh - Re-derive every load-bearing
# factual claim in standards/platform/MULTI_PRODUCT_FRONTEND.md from a
# primary source, and fail loudly if any of them stops being true.
#
# Usage:
#   verify-multi-product-frontend-claims.sh            # AWS checks only (offline)
#   verify-multi-product-frontend-claims.sh --with-npm # also re-check Next.js
#
# Why this exists:
#   The standard makes structural assertions about the CloudFront API surface
#   (what is scoped per-distribution vs per-cache-behavior). Those assertions
#   are the load-bearing part of the routing design - if AWS ever moves
#   CustomErrorResponses onto CacheBehavior, rule R-4 becomes wrong and the
#   standard must change. Prose citations rot silently; this check does not.
#
#   Evidence source is botocore's shipped CloudFront service model
#   (service-2.json), which is the same model the AWS CLI and every AWS SDK
#   generate their clients from. It is authoritative and offline-checkable.
#
# Exit codes:
#   0 - every claim held
#   1 - at least one claim failed
#   2 - prerequisites missing

set -uo pipefail

WITH_NPM=0
[[ "${1:-}" == "--with-npm" ]] && WITH_NPM=1

if ! command -v python3 >/dev/null 2>&1; then
  echo "verify-mpf: python3 not found in PATH" >&2
  exit 2
fi

if ! python3 -c "import botocore" 2>/dev/null; then
  echo "verify-mpf: botocore not importable. Install with: pip install botocore" >&2
  exit 2
fi

echo "=== CloudFront API model claims (source: botocore service-2.json) ==="

python3 <<'PY'
import glob, gzip, json, os, re, sys

import botocore

base = os.path.join(os.path.dirname(botocore.__file__), "data", "cloudfront")
versions = sorted(d for d in os.listdir(base) if re.match(r"^\d{4}-\d{2}-\d{2}$", d))
if not versions:
    print("FAIL  no cloudfront service model found under %s" % base)
    sys.exit(1)
model_dir = os.path.join(base, versions[-1])

candidates = glob.glob(os.path.join(model_dir, "service-2.json*"))
if not candidates:
    print("FAIL  no service-2.json in %s" % model_dir)
    sys.exit(1)
path = candidates[0]
opener = gzip.open if path.endswith(".gz") else open
with opener(path, "rt") as fh:
    model = json.load(fh)

shapes = model["shapes"]
ops = set(model["operations"])
print("model: cloudfront %s (botocore %s)\n" % (model["metadata"]["apiVersion"], botocore.__version__))

failures = []


def check(claim_id, description, ok):
    status = "PASS" if ok else "FAIL"
    print("%s  %s  %s" % (status, claim_id, description))
    if not ok:
        failures.append(claim_id)


def members(shape):
    return set(shapes[shape].get("members", {}).keys())


def doctext(shape, member):
    raw = shapes[shape]["members"][member].get("documentation", "")
    return re.sub(r"<[^>]+>", " ", raw)


# C-1: custom error responses are distribution-scoped, never per-behavior.
# This is what forbids the "map 403/404 to /index.html" SPA fallback when a
# distribution fronts more than one app.
check("C-1a", "CustomErrorResponses IS a member of DistributionConfig",
      "CustomErrorResponses" in members("DistributionConfig"))
check("C-1b", "CustomErrorResponses is NOT a member of CacheBehavior",
      "CustomErrorResponses" not in members("CacheBehavior"))
check("C-1c", "CustomErrorResponses is NOT a member of DefaultCacheBehavior",
      "CustomErrorResponses" not in members("DefaultCacheBehavior"))

# C-2: path routing and edge functions ARE per-behavior, so the per-product
# SPA fallback belongs in a CloudFront Function on the product's behavior.
check("C-2a", "PathPattern IS a member of CacheBehavior",
      "PathPattern" in members("CacheBehavior"))
check("C-2b", "FunctionAssociations IS a member of CacheBehavior",
      "FunctionAssociations" in members("CacheBehavior"))

# C-3: CloudFront Functions are viewer-side only. The rewrite must run on
# viewer-request; origin-facing event types are unavailable to them.
c3 = doctext("FunctionAssociation", "EventType")
check("C-3", "FunctionAssociation.EventType docs forbid origin-facing events",
      "cannot use origin-facing event types" in c3.lower())

# C-4: WAF is attached to the distribution, not to a behavior. One shared
# distribution therefore means one shared WAF posture across all products.
check("C-4a", "WebACLId IS a member of DistributionConfig",
      "WebACLId" in members("DistributionConfig"))
check("C-4b", "WebACLId is NOT a member of CacheBehavior",
      "WebACLId" not in members("CacheBehavior"))

# C-5: response headers (and therefore CSP) ARE per-behavior. This is the
# mitigation that makes a shared origin tolerable.
check("C-5a", "ResponseHeadersPolicyId IS a member of CacheBehavior",
      "ResponseHeadersPolicyId" in members("CacheBehavior"))
check("C-5b", "ResponseHeadersPolicySecurityHeadersConfig exposes ContentSecurityPolicy",
      "ContentSecurityPolicy" in members("ResponseHeadersPolicySecurityHeadersConfig"))

# C-6: Origin Access Control is the current S3-origin lockdown mechanism.
check("C-6a", "Origin.OriginAccessControlId exists",
      "OriginAccessControlId" in members("Origin"))
check("C-6b", "OriginAccessControl CRUD operations exist",
      {"CreateOriginAccessControl", "GetOriginAccessControl"} <= ops)

# C-7: behaviors are evaluated in list order, first match wins; the default
# behavior's pattern is '*' and is not editable.
c7 = doctext("CacheBehavior", "PathPattern")
check("C-7a", "PathPattern docs state behaviors match in listed order",
      "in the order in which cache behaviors are listed" in c7)
check("C-7b", "PathPattern docs state the default behavior pattern is '*' and fixed",
      "cannot be changed" in c7)

print()
if failures:
    print("RESULT aws_claims=FAILED failed=%s" % ",".join(failures))
    sys.exit(1)
print("RESULT aws_claims=PASSED checks=14")
PY

AWS_RC=$?

if [[ $WITH_NPM -eq 0 ]]; then
  echo
  echo "(skipping Next.js checks; re-run with --with-npm to include them)"
  exit $AWS_RC
fi

echo
echo "=== Next.js claims (source: published npm tarball) ==="

if ! command -v npm >/dev/null 2>&1; then
  echo "verify-mpf: npm not found in PATH; cannot run --with-npm checks" >&2
  exit 2
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if ! (cd "$WORK" && npm pack next --silent >/dev/null 2>&1); then
  echo "FAIL  N-0  could not fetch the 'next' package from the npm registry"
  exit 1
fi

TARBALL="$(find "$WORK" -maxdepth 1 -name 'next-*.tgz' | head -1)"
if [[ -z "$TARBALL" ]]; then
  echo "FAIL  N-0  npm pack produced no tarball"
  exit 1
fi
echo "package: $(basename "$TARBALL")"
echo

tar xzf "$TARBALL" -C "$WORK" 2>/dev/null || true

NPM_FAIL=0
np_check() {
  local id="$1" desc="$2" ok="$3"
  if [[ "$ok" == "1" ]]; then echo "PASS  $id  $desc"; else echo "FAIL  $id  $desc"; NPM_FAIL=1; fi
}

DTS="$WORK/package/dist/server/config-shared.d.ts"
if [[ -f "$DTS" ]]; then
  grep -q 'basePath?: string' "$DTS" && np_check "N-1" "next.config basePath?: string is declared" 1 \
    || np_check "N-1" "next.config basePath?: string is declared" 0
  grep -q 'assetPrefix?: string' "$DTS" && np_check "N-2" "next.config assetPrefix?: string is declared" 1 \
    || np_check "N-2" "next.config assetPrefix?: string is declared" 0
  grep -q 'rewrites?:' "$DTS" && np_check "N-3" "next.config rewrites?: is declared" 1 \
    || np_check "N-3" "next.config rewrites?: is declared" 0
else
  np_check "N-1..3" "config-shared.d.ts present in package" 0
fi

if grep -rq 'public, max-age=31536000, immutable' "$WORK/package/dist" 2>/dev/null; then
  np_check "N-4" "ships 'public, max-age=31536000, immutable' for hashed assets" 1
else
  np_check "N-4" "ships 'public, max-age=31536000, immutable' for hashed assets" 0
fi

echo
if [[ $NPM_FAIL -ne 0 ]]; then
  echo "RESULT npm_claims=FAILED"
  exit 1
fi
echo "RESULT npm_claims=PASSED checks=4"

exit $AWS_RC
