# Phase 04 — Build: Process Breakdown

Companion to [`04-build.md`](04-build.md). The chapter describes *what* and *why*; this document details *how* — the discrete processes, their owners, their inputs and outputs, the cadence, and the exit gates.

**Last updated:** 2026-04-24.

## How to read this

- Phase 04 is continuous, not a one-shot phase. The "daily loop" in the chapter (8 steps) decomposes into discrete processes, most of them per-change or per-PR. Additional processes cover the shared infrastructure of building (style setup, documentation authoring, onboarding, DevEx maintenance) that is not daily but is load-bearing.
- Each process has: **purpose, RACI, triggers, inputs, activities, outputs, tools, cadence, exit gate, pitfalls.**
- RACI convention: **R**esponsible · **A**ccountable · **C**onsulted · **I**nformed.
- Defaults assume the **team-of-5** scale. Solo and team-of-50+ variations called out where they change the process meaningfully.

## Process inventory

| # | Process | When | Owner (R) | Primary output |
|---|---|---|---|---|
| 1 | Task Pickup & Branch Creation | Per task (daily) | Any engineer | Scoped branch from `main` |
| 2 | Local Development & TDD | Per task (daily) | Any engineer | Working code + tests green locally |
| 3 | Commit Hygiene | Continuous | Any engineer | Small, coherent, Conventional commits |
| 4 | Self-Review | Before opening PR | Any engineer | Clean diff, polished description |
| 5 | PR Authorship | Per change | Any engineer | PR ≤400 lines, description with why + test plan |
| 6 | Peer Code Review | Within 1 business day | Any reviewer | Reviewed PR with severity-labelled comments |
| 7 | Merge & Integrate | On review approval + green CI | Author | Merged commit on `main` |
| 8 | Refactoring (Two-Hats) | Rolling | Any engineer | Preparatory + camp-rule refactors |
| 9 | Style & Static Analysis Setup | Phase kickoff; on new language | Platform/DevEx or tech lead | Linter, formatter, type checker, SAST in CI |
| 10 | Documentation Authoring (Diátaxis) | Per feature or behavior change | Author engineer | Tutorial/How-to/Reference/Explanation doc |
| 11 | DevEx Maintenance | Continuous | Platform/DevEx or tech lead | Fast loops, one-command setup, dev container |
| 12 | Onboarding New Engineer | On hire | Tech lead + buddy | First PR in week one |
| 13 | Pair/Mob Programming | On demand | Engineers | Shared understanding / unstuck review |
| 14 | Codebase Health Review | Quarterly | Tech lead | Debt backlog + metric trends |

## Default RACI across the phase

| Role | Scope of accountability |
|---|---|
| **Engineers** | Daily loop: branch, code, test, PR, review, merge. Everyone who writes code reviews code. |
| **Tech lead / senior engineer** | Standards, review culture, CODEOWNERS once it exists, unblocking stalled reviews. |
| **Engineering manager** | Throughput and health metrics (PR cycle time, review latency, CI duration). |
| **Platform / DevEx engineer (if present)** | Dev environment, linter/formatter config, pre-commit, CI templates, "one-command setup." |
| **Product / design** | Consumers and reviewers of output; not gatekeepers of process. |

The system is the point, not the individuals. When the loop jams, fix the loop.

---

## Process 1 — Task Pickup & Branch Creation

**Purpose.** Start every change from a scoped task that fits in 1–2 days, branched cleanly from current `main`.

**RACI.** R: any engineer · A: engineer · C: PM if scope ambiguous · I: —.

**Triggers.** Engineer has capacity and the next-highest-priority Ready item is queued.

**Inputs.**
- Prioritized backlog (Phase 02 artefact).
- Item in "Ready" state (refined, sized, acceptance criteria).
- Up-to-date `main` fetched locally.

**Activities.**
1. **Pull latest `main`.** `git fetch && git switch main && git pull`.
2. **Claim the item** in the issue tracker (assign to self; move to "In progress").
3. **If item is >1–2 days, split.** Return to PM/refinement with the split proposal. Do not start.
4. **Branch with a descriptive name** (`fix-stripe-idempotency`, `add-webhook-retries`). Avoid `feature/`, `bug/` style prefixes unless team convention requires.
5. **Write the planned test + code outline in the PR description draft.** Even 3 bullets. Future-you will thank you.

**Outputs.**
- Claimed item in tracker.
- Local branch from current `main`.
- Draft PR description seed.

**Tools / templates.**
- Issue tracker (Linear, Jira, GitHub Projects).
- Git.

**Cadence / duration.**
- Daily. 5–10 min per task.

**Exit gate.**
- Branch exists, named descriptively, from current `main`.
- Item is assigned and in "In progress."

**Pitfalls.**
- Starting work on an item that isn't Ready. Blows up during review.
- Branching from a stale `main`. Merge conflicts appear late.
- Claiming three items at once. WIP bloats and nothing finishes.

---

## Process 2 — Local Development & TDD

**Purpose.** Produce working code with tests, fast feedback locally, before the PR is opened.

**RACI.** R: author engineer · A: author · C: peers (if paired) · I: —.

**Triggers.** Branch created (Process 1).

**Inputs.**
- Task acceptance criteria.
- Relevant ADRs, design doc, API contract, UX hi-fi from Phase 03.
- Existing test suite.

**Activities.**
1. **For non-trivial logic: TDD Red/Green/Refactor.**
   - Red: write failing test for next bit of behavior.
   - Green: minimum code to pass (Fake It / Obvious Implementation / Triangulation).
   - Refactor: clean both new and old code.
2. **For UI polish / spikes:** write whichever (test or code) is faster. Add regression tests before merge.
3. **For bug fixes: always write the failing regression test first.** The test protects the fix forever.
4. **Run locally:** unit tests, linter, type checker, pre-commit hooks.
5. **Keep local tests under 60 seconds.** If they drift longer, fix that before adding features.
6. **Observe the two-hats rule.** Either refactoring (tests green, behavior unchanged) or changing behavior (new tests). Not both simultaneously.

**Outputs.**
- Code committed on branch.
- Unit and integration tests passing locally.
- Test plan captured in PR description draft.

**Tools / templates.**
- Editor with integrated linter, formatter, type checker.
- Language test runner (pytest, vitest, jest, go test, rspec).
- Pre-commit hooks via husky / lefthook / pre-commit.com.

**Cadence / duration.**
- Continuous per task. Most tasks 2–16 hours of local work.

**Exit gate.**
- Every acceptance criterion has a passing test.
- Local test suite green.
- No `console.log` / `print` debug statements left.

**Pitfalls.**
- "I'll add tests after." You won't. If you would, you would now.
- TDD as ritual on spike code. Beck's own guidance is pragmatic.
- Ignoring the two-hats rule. Refactor + feature in one commit hides regressions.
- Accepting slow local tests. A minute of friction per run × 20 runs a day = 20 minutes/day/engineer.

---

## Process 3 — Commit Hygiene

**Purpose.** Keep commits small, coherent, and readable via `git log` a year later.

**RACI.** R: author engineer · A: author · C: — · I: —.

**Triggers.** Continuous, per meaningful unit of change.

**Inputs.**
- In-flight branch.
- Team commit convention (Conventional Commits by default).

**Activities.**
1. **One coherent change per commit.** If the message needs "and" or bullet points, split.
2. **Use Conventional Commits prefixes:** `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `perf:`, `ci:`.
3. **Subject line = what; body = why.** Subject ≤ 72 chars.
4. **Separate refactor commits from feature commits.** Inside one PR: `refactor: extract retry logic` then `feat: use retry logic in webhook handler`.
5. **Amend vs new commit.** Amend only commits not yet pushed. Once pushed, new commit.
6. **Rebase before opening PR** if history is noisy. Linear history reads better.

**Outputs.**
- Commits with prefixed subjects and explanatory bodies when needed.
- Linear, readable branch history.

**Tools / templates.**
- Git with commit template configured per-repo.
- commitlint in pre-commit (optional, enforces the convention).

**Cadence / duration.**
- Continuous. 30 seconds per commit.

**Exit gate (per branch).**
- All commits prefixed per convention.
- No "wip" or "fix typo" in final history (squash or rebase away).
- Messages readable by someone outside the current change.

**Pitfalls.**
- "Save point" commits with no message. Clean up before PR.
- Mixing refactor + feature in one commit. Reviewer can't separate risk.
- Amending pushed commits on a shared branch. Rewrites history others have fetched.

---

## Process 4 — Self-Review

**Purpose.** Catch the obvious problems before asking a reviewer for time.

**RACI.** R: author · A: author · C: — · I: —.

**Triggers.** Local tests green, ready to open PR.

**Inputs.**
- Branch diff against `main`.
- Draft PR description.
- Definition of Done checklist.

**Activities.**
1. **Read the diff as the reviewer would.** Top to bottom, no skipping.
2. **Question own choices.** "Why is this a map not a list?" — answer in the PR body if non-obvious.
3. **Polish the description:** linked issue, why (not just what), test plan (≥1 line), risk, rollout plan if non-trivial.
4. **Check DoD checklist:** tests pass, linter passes, type checker passes, description explains why, observability added for new paths, docs updated, no new secrets.
5. **Split if >400 lines.** Consider carving refactor into a prior PR.

**Outputs.**
- Clean diff.
- Polished PR description with all template fields.

**Tools / templates.**
- GitHub / GitLab / Bitbucket diff view.
- PR template in repo (`.github/PULL_REQUEST_TEMPLATE.md`).

**Cadence / duration.**
- Every PR. 10–20 min.

**Exit gate.**
- Author would approve this PR if it came from someone else.

**Pitfalls.**
- Skipping self-review. Reviewer finds what you'd have caught in 10 minutes.
- PR description stub "updates X." Costs the reviewer 10 minutes of archaeology.
- Leaving commented-out code or debug lines. Reviewer loses trust.

---

## Process 5 — PR Authorship

**Purpose.** Open a reviewable PR with scope ≤400 lines, one concern, and a description that makes review efficient.

**RACI.** R: author · A: author · C: reviewer (selected) · I: watchers on tracker issue.

**Triggers.** Self-review complete (Process 4).

**Inputs.**
- Clean diff.
- PR description.
- CODEOWNERS (if team has one) for reviewer assignment.

**Activities.**
1. **Open PR against `main`.**
2. **Size target: ≤400 lines changed.** ~100 lines optimal (Google CL guide). Past 1000, reviewer can reject for size alone.
3. **One concern per PR.** "Refactor X and add feature Y" is two PRs.
4. **Assign reviewer(s).** One peer minimum. Two for high-risk areas (security, payments, migrations).
5. **Link to issue/task.** Traceability to Phase 02 backlog.
6. **Ping the reviewer in chat** only if urgent. Otherwise async.
7. **Mark draft or ready-for-review.** Draft = don't review yet.

**Outputs.**
- PR open, reviewer(s) assigned, CI triggered.
- Description with: linked issue, why, test plan, risk.

**Tools / templates.**
- Git forge (GitHub, GitLab).
- PR template.
- CODEOWNERS (once team grows).

**Cadence / duration.**
- Per change. 5 min to open + re-check.

**Exit gate.**
- PR ≤400 lines or has a documented reason for being larger.
- Reviewer assigned.
- Description has all template fields filled.
- CI green (or in progress).

**Pitfalls.**
- Opening a PR with "WIP" and no description. Reviewer has to read the author's mind.
- PR covering two concerns. Risk asymmetry — reviewer must approve both together.
- Not self-reviewing first. Reviewer flags what you'd have caught in 10 min.
- Pinging reviewer in chat without a reason. Erodes async norms.

---

## Process 6 — Peer Code Review

**Purpose.** Within 1 business day, engage with the PR — question, request, or approve — and help the author ship a better change.

**RACI.** R: reviewer · A: reviewer · C: author · I: team (via PR feed).

**Triggers.** PR marked ready-for-review with reviewer assigned.

**Inputs.**
- PR diff + description.
- Relevant ADRs and design docs from Phase 03.
- Existing tests.
- Team style guide + linter decisions (style is not a review topic).

**Activities.**
1. **Respond within 1 business day.** Respond means engage; finishing can take longer.
2. **Read description first, then diff.** Orient before diving.
3. **Walk Google's eight dimensions:**
   - Design (fits ADRs + architecture)
   - Functionality (does what description says; edge cases; error paths; concurrency)
   - Complexity (over-engineering is a cost)
   - Testing (meaningful tests, not tests that mirror implementation)
   - Naming
   - Comments (explain why; flag non-obvious constraints)
   - Style (linter decides; don't comment)
   - Documentation updates
4. **Label severity on every comment:** blocking (unmarked), `Nit:`, `Optional:`, `FYI:`.
5. **Ask questions before demanding changes.** "Why a map instead of a list?" beats "make this a list."
6. **Go synchronous when stuck.** After 2 async rounds with no convergence, jump on a 15-min call.
7. **Approve when the PR improves code health, even if imperfect.** Progress > perfection. File follow-up issues for deferred items.

**Outputs.**
- PR comments (severity-labelled).
- Approval, change request, or explicit hand-back for more discussion.

**Tools / templates.**
- Git forge review UI.
- Google engineering practices reference.

**Cadence / duration.**
- Per PR. 20–60 min typical, depending on size.

**Exit gate (per PR).**
- All blocking comments resolved.
- At least one peer approval.
- Reviewer's final state is approve (not just left hanging).

**Pitfalls.**
- Review as bug hunt only. Main value is understanding, knowledge transfer, shared design, code health. (Bacchelli & Bird.)
- Blocking on style. If the linter didn't catch it, either fix the linter or accept it.
- Letting PRs sit overnight. Author loses context, cycle time balloons.
- Demanding changes without explaining why. Signals authority, not argument.
- Approving without reading (rubber stamp). Review loses meaning.

---

## Process 7 — Merge & Integrate

**Purpose.** Merge to `main` cleanly once tests green and approvals in, triggering automated deploy.

**RACI.** R: author · A: author · C: reviewer · I: team (via deploy notifications).

**Triggers.** CI green + ≥1 approval + all blocking comments resolved.

**Inputs.**
- Approved PR.
- Green CI pipeline.
- Up-to-date branch against `main` (rebase or merge-in if drifted).

**Activities.**
1. **Check CI green one last time.** Re-run if flaky.
2. **Update branch against latest `main`** if drift is significant. Re-run tests.
3. **Squash or rebase-merge** per team convention. Keep history linear.
4. **Use PR title as merge commit subject.** The Conventional Commit prefix carries through.
5. **Delete the branch** (Git forge usually offers a button).
6. **Watch the deploy** (Phase 06): monitor pipeline, check canary signals, verify on staging if applicable.
7. **Close related issue** automatically via "Closes #123" in PR body, or manually.

**Outputs.**
- `main` advanced by one merge commit.
- Branch deleted.
- Deploy pipeline triggered (Phase 06 owns pipeline mechanics).

**Tools / templates.**
- Git forge merge button.
- CI/CD pipeline (Phase 06).

**Cadence / duration.**
- Multiple times daily. 2–5 min per merge + deploy watch.

**Exit gate.**
- Merge on `main`, CI green.
- Deploy pipeline triggered.
- Branch deleted.
- Issue moved to Done.

**Pitfalls.**
- Merging with red or flaky CI. One ignored failure becomes a culture of ignoring failures.
- Forgetting to rebase/merge from `main` before merging. Silent conflicts with recent work.
- Leaving stale branches. Hundreds accumulate within months.
- Merging and walking away. Watch the deploy, at least the first signal.

---

## Process 8 — Refactoring (Two-Hats)

**Purpose.** Improve the code's internal structure without changing observable behavior, in small steps, under test cover.

**RACI.** R: author engineer · A: author · C: reviewer · I: —.

**Triggers.**
- Camp rule: notice a confusing name/shape while adding a feature.
- Preparatory: "make the change easy, then make the easy change" (Beck).
- Scheduled: hotspot cleanup identified in codebase health review (Process 14).

**Inputs.**
- Existing tests covering the surface to be refactored.
- Clean, committed state to refactor from.

**Activities.**
1. **Switch to refactor hat.** Explicitly. Commit or stash any in-flight feature work.
2. **Run tests green before starting.** You cannot refactor under a red suite.
3. **Apply one named refactoring at a time** (rename, extract function, inline variable, move method).
4. **Run tests after each step.** If red, revert or fix.
5. **Commit each refactor separately** with `refactor:` prefix.
6. **Switch back to feature hat for behavior changes.**
7. **Camp rule:** rename/extract in-PR when noticed mid-feature; keep refactor commits separate from feature commits.
8. **Preparatory:** do the refactor as a standalone PR before the feature PR. Reviewer's load halves.

**Outputs.**
- Code with same behavior, clearer structure.
- Tests still green.
- Refactor commits clearly labelled in history.

**Tools / templates.**
- Editor refactoring tools (rename symbol, extract method).
- Test runner in watch mode.
- Martin Fowler's *Refactoring* (2e) catalog for named refactorings.

**Cadence / duration.**
- Continuous (camp rule) + occasional dedicated prep PRs.

**Exit gate.**
- Tests green before and after.
- Commits labelled.
- No behavior change in a refactor commit.

**Pitfalls.**
- Wearing both hats. Refactor + feature in one commit hides regressions.
- Refactoring without tests. You don't know what you broke.
- Refactoring past the point of value. Apply until it's clear enough; stop.
- Massive refactor PR. Split; "refactor the world" is unreviewable.

---

## Process 9 — Style & Static Analysis Setup

**Purpose.** Install formatter, linter, type checker, SAST, dependency scanner, and secrets scanner once — so style stops being a review topic and real problems are caught in CI.

**RACI.** R: Platform/DevEx engineer or tech lead · A: Engineering lead · C: whole team · I: —.

**Triggers.** Phase kickoff. Re-run when adding a new language or major framework.

**Inputs.**
- Team language(s).
- Community-standard style guides (PEP 8, gofmt, Prettier, rustfmt).
- Static analysis tool options.

**Activities.**
1. **Formatter:** `black`, `prettier`, `gofmt`, `rustfmt`. Configure on-save, pre-commit, and CI.
2. **Linter:** `ruff` / `flake8`, `eslint`, `golangci-lint`, `clippy`. CI fails on errors.
3. **Type checker:** `mypy` / `pyright`, TS compiler, Sorbet. CI fails on errors.
4. **SAST:** Semgrep or CodeQL on every PR.
5. **Dependency scanning:** `npm audit`, `pip-audit`, `govulncheck`, Dependabot.
6. **Secrets scanning:** `gitleaks`, GitHub secret scanning, `trufflehog`. Block at commit time via pre-commit.
7. **Security linter:** `bandit`, `eslint-plugin-security`, `gosec`.
8. **Commit config in-repo:** `.editorconfig`, `pyproject.toml`, `.eslintrc`, `tsconfig.json`, etc.
9. **Enforce in CI.** If it's not enforced by CI, it's not enforced.
10. **Publish a one-page "tooling" doc** in the team wiki.

**Outputs.**
- Config committed in-repo.
- CI pipeline stages for format check / lint / types / SAST / dep scan / secrets.
- Tooling doc in wiki.

**Tools / templates.**
- Language-appropriate tools listed above.
- Pre-commit framework (pre-commit.com).

**Cadence / duration.**
- Initial setup: 1–2 days. Per new language/framework: half-day.

**Exit gate.**
- Every commit runs formatter + linter + type checker in pre-commit.
- Every PR runs SAST + dep scan + secrets scan in CI.
- Style is not a topic in any PR review.

**Pitfalls.**
- Allowing style comments in reviews. Erodes norms fast.
- Disabling linter rules without discussion. Undermines the tooling.
- Tools in pre-commit but not CI (or vice versa). One half of the pincer.
- Inventing a custom style guide. Adopt the community standard.

---

## Process 10 — Documentation Authoring (Diátaxis)

**Purpose.** Write the doc that fits the user need (tutorial / how-to / reference / explanation), not a hybrid that fits none.

**RACI.** R: author engineer · A: Engineering lead · C: PM (user-facing docs), Tech writer if present · I: team.

**Triggers.**
- New user-facing feature → tutorial or how-to.
- New API surface → reference (generated from schema).
- New architectural decision → ADR (Phase 03 Process 3).
- Need to explain a non-obvious "why" → explanation.
- Bug fix with operational implication → runbook note (Phase 07).

**Inputs.**
- The shipping feature.
- Diátaxis framework (tutorials / how-to / reference / explanation).
- `/docs` folder structure.

**Activities.**
1. **Classify the doc need.** One mode per page. Don't mix.
2. **Place in the right folder:** `docs/tutorials/`, `docs/how-to/`, `docs/reference/`, `docs/explanation/`.
3. **Tutorial:** learning-oriented. Guide a beginner through a meaningful task. Step-by-step. End with working outcome.
4. **How-to guide:** task-oriented. Goal + steps. Concise. No teaching.
5. **Reference:** information-oriented. Structured, terse, complete. Often auto-generated from OpenAPI / SDL / code annotations.
6. **Explanation:** understanding-oriented. Discuss context, alternatives, trade-offs. Cite sources.
7. **Update README + index** when the doc lives in-repo.
8. **Auto-generate reference** from source where possible. Hand-maintained API docs drift.

**Outputs.**
- Doc in the right Diátaxis folder.
- README / index updated.
- Generated reference where applicable (OpenAPI → Redoc, TypeDoc, pydoc).

**Tools / templates.**
- Static site generators (Docusaurus, MkDocs, Astro Starlight) — optional.
- OpenAPI / GraphQL / Proto tooling for reference generation.
- `/docs` folder in the repo.

**Cadence / duration.**
- Per feature. 30 min – 2 hours per doc.

**Exit gate.**
- Doc classified cleanly (one mode).
- Linked from README or index.
- Reference autogen in place where applicable.

**Pitfalls.**
- One doc trying to be all four modes. Unreadable.
- Hand-maintained reference. Drifts within weeks.
- Writing a doc for a feature that isn't meant to be public. Wasted effort + confused readers.
- Stale code comments that restate the code in English. Delete them.

---

## Process 11 — DevEx Maintenance

**Purpose.** Keep the developer feedback loop fast — fast tests, fast setup, working dev containers, green CI — so engineers aren't taxed on every change.

**RACI.** R: Platform/DevEx engineer or tech lead · A: Engineering lead · C: whole team · I: —.

**Triggers.** Continuous. Explicit checks when:
- Local tests drift over 60s.
- CI duration drifts over 15 min.
- "Works on my machine" reports accumulate.
- New hire can't get running in their first hour.

**Inputs.**
- Metrics: unit test duration, CI wall-clock, PR cycle time, time-to-first-PR for new hires.
- Dev container / setup script.
- Lockfiles.

**Activities.**
1. **Dev container (containers.dev spec) committed in-repo.** Contributor opens the repo → gets tools, language versions, extensions pre-configured. Same container in CI.
2. **One-command setup.** `make setup` or `./scripts/bootstrap` installs deps, sets up secrets from template, starts services, runs tests once.
3. **Fast loops:**
   - Unit tests <60s locally.
   - Linter <10s.
   - Type checker <30s.
   - Editor integration for all three.
4. **Pre-commit hooks:** formatter, linter, fast unit tests, secrets scan. Under a few seconds.
5. **Reproducible builds:** pin versions, commit lockfiles.
6. **CI duration monitoring.** Alert when >15 min wall-clock.
7. **Investigate flakes on sight.** A failing CI that "everyone knows is flaky" becomes a CI nobody looks at.
8. **Quarterly DevEx review** (can fold into Process 14): what's slow, what's broken, what ate time this quarter?

**Outputs.**
- Dev container + setup script.
- Pre-commit config.
- Lockfiles committed.
- DevEx metrics dashboard.

**Tools / templates.**
- Development Containers spec.
- Docker, docker-compose.
- pre-commit / husky / lefthook.
- Language package manager with lockfile (poetry, pnpm, cargo, go mod).

**Cadence / duration.**
- Continuous. Dedicated DevEx time: 10–20% of tech lead / platform engineer capacity.

**Exit gate (rolling).**
- New engineer runs the app in <1 hour from clone.
- Unit tests <60s locally.
- CI <15 min.
- No chronic flakes.

**Pitfalls.**
- Treating DevEx as someone's spare-time task. Rots fast.
- Accepting slow loops as normal. The tax compounds.
- Skipping lockfile commit. "Works on my machine" returns.
- Letting flakes pile up. Trust in CI dies.

---

## Process 12 — Onboarding New Engineer

**Purpose.** Get a new engineer shipping their first PR within week one.

**RACI.** R: Tech lead + assigned buddy · A: Engineering lead · C: whole team · I: PM.

**Triggers.** New engineer start date.

**Inputs.**
- README.
- Dev container / setup script.
- Architecture overview (from Phase 03 C4 diagrams).
- "Good first issue" list.
- Buddy assignment.

**Activities.**
1. **Day 1:** accounts, access, hardware, clone repo, run the app. (This is a test of the dev container: if it takes >1 day, fix the container.)
2. **Day 2–3:** read Phase 03 artefacts (architecture, ADRs, data model, API contract). Shadow one PR review.
3. **Day 3–5:** pick a "good first issue" (small, well-scoped, off critical path). Pair or ask the buddy when stuck.
4. **Day 5–7:** open first PR. Buddy reviews first; another peer reviews second.
5. **Track time-to-first-PR** as an honest indicator of onboarding quality.

**Outputs.**
- First PR merged.
- Buddy pairing continuing through week 2–3.
- Updated onboarding doc if steps were missing or outdated.

**Tools / templates.**
- Onboarding checklist in team wiki.
- "Good first issue" label in tracker.

**Cadence / duration.**
- Per hire. Active period: first 2–3 weeks.

**Exit gate.**
- First PR merged in week one.
- New engineer can explain the architecture at a high level.
- Onboarding doc updated for gaps discovered.

**Pitfalls.**
- Time to first PR > 1 week. The setup is broken, not the hire.
- Starting with a critical-path issue. Blocks the team and stresses the hire.
- No buddy. Questions hit the whole team; progress slows.
- Stale onboarding doc. Each new hire re-discovers the broken steps.

---

## Process 13 — Pair / Mob Programming

**Purpose.** Use two-or-more-person programming as a targeted tool for tricky problems, knowledge transfer, and unstuck reviews — not as a default mode.

**RACI.** R: participating engineers · A: participating engineers · C: tech lead · I: team.

**Triggers.**
- Tricky problem where two perspectives help.
- Knowledge transfer (onboarding, cross-training).
- High-risk change (security-sensitive, migration, refactor spanning modules).
- Incident debugging (Phase 07).
- Stalled async review (Process 6).

**Inputs.**
- The task / bug / PR.
- A quiet space / meeting room / video call.
- Screen-share or Tuple / Live Share / Zed collaborative tooling.

**Activities.**

**Pairing:**
1. Driver at keyboard. Navigator on direction.
2. Swap every 15–25 minutes.
3. Break every 60–90 min. Pairing fatigues.
4. Both can call "my turn" or "hold on, I'm confused."

**Mobbing (whole team or 3+):**
1. One driver, rotating every few minutes (3–7).
2. Rest of the team navigates — design decisions, spot errors, add options.
3. Used for architecture-setting, gnarly debugging, new subsystem.

**Outputs.**
- Completed work (PR or commit).
- Shared understanding across participants.

**Tools / templates.**
- Tuple, VS Code Live Share, Zed multiplayer, Zoom screen share.

**Cadence / duration.**
- On demand. Typical session 1–3 hours.

**Exit gate (per session).**
- Stated goal achieved.
- Participants can summarize what was learned.

**Pitfalls.**
- Mandating pairing full-time. Few teams sustain it.
- Mobbing on routine work. Waste.
- Pairing as performance review. Kills trust.
- Skipping pairing when it'd clearly help (e.g., month-long stuck review). Avoidance.

---

## Process 14 — Codebase Health Review

**Purpose.** Quarterly step back to assess codebase debt, complexity hotspots, loop-speed metrics, and decide what to invest in.

**RACI.** R: Tech lead · A: Engineering lead · C: whole team, PM · I: exec.

**Triggers.** Quarterly. Also triggered if throughput or quality metrics degrade sharply.

**Inputs.**
- Metrics: PR cycle time, review latency, CI duration, unit test duration, flake rate, mean PR size.
- Hotspot analysis (files with most churn + most bugs — Tornhill's technique).
- DORA four keys (Phase 06 produces).
- Debt backlog from prior quarters.

**Activities.**
1. **Pull metrics.** PR cycle time (open → merge), review latency (open → first-response), CI duration, test duration, flake rate.
2. **Hotspot analysis.** Files with most commits AND most bug-fix commits are debt candidates.
3. **Debt backlog review.** Items accumulated from camp-rule refactors, `TODO(NAME)` comments, deferred review items.
4. **Workshop (90 min, whole team):**
   - Present metrics + hotspots.
   - Team votes top 3 debt targets for the quarter.
   - Budget: 15–20% of team capacity (matches Phase 08 tech-debt guidance).
5. **Schedule debt work** into sprint backlogs. Treat as first-class work, not spare-time.
6. **Publish summary** with prior-quarter improvements and current-quarter plan.

**Outputs.**
- Metrics trends report.
- Hotspot list.
- Top-3 debt targets for next quarter with owners.
- Summary pinned in team wiki.

**Tools / templates.**
- Git forge PR analytics.
- CodeScene, GitInsights, or custom scripts for hotspots.
- Flaky-test detector.

**Cadence / duration.**
- Quarterly. 90 min workshop + 1 day tech-lead prep.

**Exit gate.**
- Metrics captured.
- Top 3 debt targets scheduled.
- Prior-quarter targets have closed or explicit-defer reasons.

**Pitfalls.**
- Listing debt without scheduling it. Pure catharsis, no change.
- Quarterly only — problems fester between. Keep eyes on metrics continuously; workshop is the formal checkpoint.
- Treating debt work as "bonus." Team deprioritizes it under any pressure.
- Scoring DORA on individuals. Kills trust, invites gaming.

---

## Weekly rhythm (how these processes stack)

Phase 04 is continuous, not time-boxed. A typical engineer's day:

| Time | Activity | Process |
|---|---|---|
| 9:00 | Sync / standup | — |
| 9:15 | Check PR queue; review any waiting | Process 6 |
| 10:00 | Pick next task; branch | Process 1 |
| 10:10 | Local dev + TDD | Process 2 |
| ongoing | Commit often | Process 3 |
| 15:00 | Self-review + open PR | Processes 4, 5 |
| 15:30 | Review a peer's PR | Process 6 |
| 16:30 | Back to coding / respond to review | Process 2 |
| 17:30 | Merge what's ready | Process 7 |

Weekly: DevEx check-in (15 min). Monthly: doc sweep, onboarding-doc revision. Quarterly: codebase health review (Process 14).

---

## Scale notes

- **Solo engineer.** Process 6 becomes self-review after 24h. Same PR discipline. No CODEOWNERS. Keep all other processes.
- **Team of 5.** This document's default.
- **Team of 50.** Add CODEOWNERS mapping modules to owners. Multiple reviewers for high-risk areas. Dedicated platform/DevEx engineer (1–2) owning Processes 9, 11. Debt backlog tracked per team + org-wide.
- **Team of 500.** Dedicated platform team. Internal developer portal (Backstage). Architecture guild. Shared libraries. Monorepo governance or well-governed polyrepo. DORA metrics tracked per team with comparison only across similar services.

---

## Definition of Done (per PR)

Every PR gates on this checklist. Copy to `.github/PULL_REQUEST_TEMPLATE.md`:

- [ ] Tests written and passing (unit + relevant integration)
- [ ] Linter passing
- [ ] Type checker passing
- [ ] PR description explains WHY
- [ ] Reviewed by at least one peer
- [ ] Observability added for new code paths (logs / metrics / traces)
- [ ] Docs updated if behavior changed
- [ ] No new secrets in code

---

## Handoff — Phase 04 is continuous

Phase 04 does not end; it feeds Phase 05 (Test), Phase 06 (Ship), and Phase 07 (Run) continuously. The handoff per increment is the merge commit: green CI + peer approval + DoD ticked. Every merge triggers downstream phases automatically. Every incident in Phase 07 creates backlog items for Phase 04. The loop is the point.
