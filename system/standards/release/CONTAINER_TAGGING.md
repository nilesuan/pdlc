# CONTAINER_TAGGING.md — Build once, promote by digest

**Authoritative source:** [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §8; [`../../../NOTES.md`](../../../NOTES.md) (build-once policy).

## The discipline

A container image is built **once** per commit and **promoted by digest** through environments. The same `sha256:...` runs in dev, preprod, and prod.

This is the single most violated pipeline rule in practice and the source of the most "but it worked in dev" incidents.

## Hard rules

1. **One build per commit.** Image built in CI; pushed to ECR; never rebuilt downstream.
2. **Pin by digest, not tag, in deployment configs.** ECS task definitions reference `repo@sha256:...`, not `repo:latest` or `repo:dev`.
3. **Tags are convenience labels, not identity.** A tag may move; a digest is immutable. Treat tags as read-only after creation where possible (ECR `IMMUTABLE` tag mutability).
4. **No `:latest` anywhere in deployment.** Not in dev, not in preprod, not in prod. `:latest` defeats reproducibility.
5. **Image tags include the commit SHA.** Short SHA at minimum; semver tag additionally for libraries / public artifacts.
6. **ECR lifecycle policies enforced.** Untagged images cleaned up after 7 days; old tagged images expire on a schedule appropriate to the artifact (e.g., keep last 30 prod releases).
7. **Image signed (cosign) and SBOM attached** before promotion to preprod.

## Tag schema

```
<service>:<short-sha>            # canonical immutable tag, used everywhere
<service>:v<semver>              # for releases of libraries / public artifacts
<service>:<env>-<short-sha>      # optional convenience tag, env-pinned
```

Avoid: `:latest`, `:dev`, `:prod` as floating tags. They invite "which build is actually running?" debugging.

## Auto-rejection (used by platform-engineer)

| Trigger | Severity |
|---|---|
| ECS task definition references `:latest` | Blocker |
| ECS task definition references env-floating tag (e.g. `:prod`) | Major |
| Image rebuilt between dev and preprod | Blocker |
| Image rebuilt between preprod and prod | Blocker |
| ECR repo tag mutability set to `MUTABLE` | Major |
| Image not signed before prod promotion | Major |
| No SBOM attached before prod promotion | Major |
| Lifecycle policy missing → unbounded image retention | Minor (cost / supply-chain hygiene) |

## How to verify a deployment is by-digest

Read the ECS task definition; the `image` field should match `account.dkr.ecr.region.amazonaws.com/repo@sha256:...`. If it ends in `:something`, that's a tag pin and risks drift.

## Why digest-pinning matters

- **Reproducibility.** A rollback to "yesterday's prod" actually returns the same bytes.
- **Supply-chain integrity.** Cosign/Notation verifies the digest, not the tag. A signed image is signed at one digest.
- **Race-condition elimination.** Two pipelines pushing to the same tag at the same time is no longer a footgun.
- **Audit.** "Which image ran during the incident at 02:14?" answerable from logs, not detective work.

## Anti-patterns to flag

- Pipeline that re-runs `docker build` on the preprod stage. Even if the Dockerfile is identical, the bytes differ (timestamps, layer cache).
- "Hotfix" that rebuilds a tag in-place. The tag now points to a different digest than the one that was tested. The audit trail is broken.
- Multi-arch builds done at deploy time rather than build time. Pre-build all archs.
- Using `docker pull` then `docker tag` then `docker push` to "promote" — this is rebuilding by another name.

## Sources

- [`../../../platform-team/developer-guidelines.md`](../../../platform-team/developer-guidelines.md) §8 (Container images and tagging).
- [`../../../NOTES.md`](../../../NOTES.md) — build-once policy as user preference.
- AWS ECR docs on tag immutability and lifecycle policies.
- Sigstore / cosign for signing; SLSA for supply-chain levels.
