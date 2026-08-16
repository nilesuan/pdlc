---
id: LESSON-0003
date: 2026-07-20
trigger: user-correction
phases: [05, 07]
keywords: [mcp, 404, plane, community-edition, endpoint-gap, partial-failure, bridged-server, workspace-slug, permissions, discovery-tool, hardcoded-id, bearer, x-api-key, auth-header]
related-rules: [standards/ANTI_HALLUCINATION.md, CLAUDE.md]
status: active
---

## What went wrong

A bridged MCP server (Plane, via a third-party HTTP bridge over a self-hosted Plane instance) returned HTTP 404 "Page not found." on some tools (`list_projects`, `get_workspace_members`) while other tools against the same server, credential, and scope returned 200 (`get_me`, `list_work_items`). The partial 404 was diagnosed as a workspace-slug or membership/permissions problem, and the response proposed checking/rewriting the server config and asked the user to verify workspace membership. The config was in fact correct. The user, checking the host directly (DB + container logs), showed the real cause: the bridge's bundled SDK calls Cloud-only "lite" endpoints (`/workspaces/{slug}/projects-lite/`, `/members-lite/`) that do not exist in the Community Edition the instance runs, so the server's URL router 404s before any workspace lookup. A round-trip was spent chasing a slug/permissions non-issue.

## Why it happened (root cause)

A partial 404 - some operations fail, others succeed against the same server, key, and scope - was read as an authentication/authorization/identity signal instead of an endpoint-availability signal. A supporting heuristic ("a real workspace always has at least one member, so a members call cannot 404") silently assumed the 404 originated from a workspace/permission lookup; a router-level "Page not found." fails before any such lookup, so the heuristic did not apply and produced false confidence. No step distinguished "endpoint absent" (a router miss - all-or-nothing per tool, uncorrelated with slug or permissions) from "resource absent or forbidden" (which would be consistent across a tool's calls and would correlate with slug/permissions). The mixed 200/404 pattern was itself the discriminating evidence and was not used.

## How to prevent it (the rule)

When a tool returns 404 / "not found" on SOME operations while OTHER operations against the SAME server, credential, and scope succeed, treat it as an unsupported or missing endpoint (an edition/version feature gap), NOT as a bad slug, credential, or permission - confirm the working operations, do not edit the server config, and do not tell the user their credential or scope is broken until an all-operations failure or an explicit auth error (401 / OAuth-parse) actually shows it. Corollary: for such servers the missing endpoint is often the discovery/list tool itself, so enumerate resources via a known-working tool or a supplied hardcoded ID rather than inferring breakage from the list tool's 404.

## Verification

- A diagnosis that attributes a partial 404 (mixed 200/404 across tools on one server + credential + scope) to auth, slug, or permissions - or that edits server config in response - is a finding.
- Regression check: given a server where `get_me` / `list_work_items` return 200 and `list_projects` returns 404, the correct first hypothesis is "endpoint not present in this edition/version," reached from the split-success pattern, not from re-checking the slug or membership.
- The specific instance is captured as a reference memory ([[reference-plane-mcp]]) naming the two broken Plane-CE tools, the auth-header rule (Bearer PAT, not x-api-key), and the hardcoded project IDs to use for discovery, so this instance does not recur.
