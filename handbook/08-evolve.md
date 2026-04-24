# Phase 08 — Evolve

**Goal:** Turn a running product with users into a product users love — by listening continuously, iterating on real signal, and keeping the system healthy enough to ship for years.

**Duration:** Forever.

**You are done when:** Never. But you're on track when feature velocity is sustained year-over-year, on-call load is stable, and customer satisfaction trends up.

---

## What this phase is about

"Customers love it and we just keep adding features" sounds like a static happy ending. It isn't. It's a continuous capability: the ability to hear real customer pain, ship improvements fast, and not slow down as the system ages.

Meir Lehman's 1974–1996 laws of software evolution describe why. Lehman's First Law (Continuing Change) says an "E-type" system — software embedded in a real-world operating environment — "must be continually adapted or it becomes progressively less satisfactory." His Second Law (Increasing Complexity) says complexity increases unless work is done to maintain or reduce it. His Seventh Law (Declining Quality) says quality appears to decline unless the system is rigorously maintained. His Eighth Law (Feedback System) says E-type evolution is a multi-level, multi-loop, multi-agent feedback system. Put together: the job in Phase 08 is to run those feedback loops deliberately rather than let them run you.

Three failure modes this phase exists to prevent:

1. **Drift from customers** — the team ships what's easy to build, not what matters. The roadmap fills with engineering pet projects and executive whims.
2. **Tech debt collapse** — the system slows to a crawl. Every change is risky. Senior engineers leave.
3. **Security rot** — dependencies go unpatched, CVEs pile up, the SBOM is stale. Then something explodes.

Treat this phase as the system's steady state, not an epilogue. Every practice below — customer interviews, experimentation, debt budgets, dependency automation, patch SLAs, deprecation policy — is a muscle that must be exercised weekly.

---

## Who does what

- **Product** owns the outer feedback loop — customer research, metrics review, roadmap evolution, OKRs, experiment strategy.
- **Engineering** owns the inner feedback loop — tech debt, dependency hygiene, security patching, refactoring, legacy modernization.
- **Design** owns usability feedback, friction hunts, and in-product surveys.
- **Customer-facing roles** — support, customer success, sales — are *input channels*, not side-characters. The PM should spend time with them weekly.
- **Security** owns the CVE watchlist, patch SLA enforcement, and coordinated disclosure policy.
- **On-call rotation** (from Phase 07) continues — production pain is a signal back into this phase.

At 2–20 people the PM is the primary owner of the customer feedback loop; the engineering lead is the primary owner of system health. One person can cover both, but if both hats are on the same head, schedule dedicated time for each or the loud one will eat the quiet one.

---

## Inputs

- A running production system with real users (output of Phases 06–07).
- Phase 07 observability — SLOs, dashboards, error tracking, on-call — still live and monitored.
- Phase 01 discovery muscle still active (interview cadence, pain hunting, evidence over opinion).
- Phase 02 OKRs or equivalent strategic frame, revisited periodically.
- A changelog and a customer-facing communication channel (email, in-product, status page).

If any is missing, fix that first. You cannot iterate on a system you cannot observe, and you cannot learn from customers you never talk to.

---

## Closing the loop: feedback

The work of Phase 08 starts with hearing. If you cannot reliably hear what customers think, feel, and do with the product, every downstream activity is guesswork.

### Quantitative signals

Pick a small set and watch them weekly. Too many metrics becomes noise; nobody looks at a dashboard with sixty tiles on it.

- **Product analytics** — feature usage, funnels, cohort retention, activation. Recommend PostHog (open-core, self-hostable), Amplitude, or Mixpanel. For larger teams, Segment as a data plane feeding both a SaaS tool and a warehouse works well. Instrument events as you ship features, not in a "we'll add analytics later" sprint that never happens.
- **Net Promoter Score (NPS)** — Fred Reichheld's 2003 *Harvard Business Review* metric: "How likely is it that you would recommend [product/service/company] to a friend or colleague?" on a 0–10 scale. Promoters score 9–10, Passives 7–8, Detractors 0–6. NPS = %Promoters − %Detractors. Use quarterly for long-term loyalty trend. Always pair the numeric score with an open-ended "Why?" — the verbatim text is where the actual signal lives.
- **Customer Satisfaction (CSAT)** — transactional. "How satisfied were you with this interaction?" 1–5 scale, measured after a specific event (ticket closure, feature use, onboarding). Good for micro-feedback on specific touchpoints.
- **Customer Effort Score (CES)** — Matthew Dixon, Karen Freeman, and Nick Toman's 2010 HBR finding ("Stop Trying to Delight Your Customers"): reducing the effort customers spend on a task predicts loyalty better than exceeding their expectations. The original wording was "How much effort did you personally have to put forth to handle your request?" on a 1–5 scale. The revised CES 2.0 form asks for agreement with a statement like "[The company] made it easy for me to handle my issue" on a 1–7 scale. Best predictor of churn for support experiences and friction-heavy flows. Pick one variant per product and stick to it so trends are comparable.
- **Business metrics** — revenue (MRR/ARR), expansion, churn, lifetime value (LTV), customer acquisition cost (CAC). These are the outcomes; feature usage is the leading indicator. Don't replace them with vanity counts (sign-ups, page views).
- **Error and support ticket trends** — total volume, top categories, median time to resolve. A rising trend is a health signal independent of what any individual bug says.

Pick a **North Star metric** that captures the value the product creates for the user (weekly active teams, documents created, minutes saved, whatever fits the domain) plus 3–5 input metrics that feed it. Watch them weekly. Dashboards with more than ten tiles get ignored; dashboards with fewer than three don't tell you enough.

A note on NPS as a vanity metric. A quarterly NPS that goes up with no investigation into *why* is worthless — possibly worse than worthless, because it manufactures confidence. The follow-up "Why?" text, read by the team, is what makes NPS useful. Without it, skip the survey.

### Qualitative signals

Numbers tell you *that* something is happening. Text and voice tell you *what* and *why*. You need both.

- **Continuous customer interviews** — Teresa Torres's continuous discovery framing from Phase 01 does not stop at launch. The PM should interview at least one customer per week, every week, forever. Schedule in advance, use a standard script, record with consent, keep an always-on opportunity tree.
- **Support conversations** — the product team should read support tickets weekly. Rotate a "voice of customer" duty: one engineer per week reads the last seven days of tickets and summarizes patterns for the team.
- **Sales/CS calls** — the PM should attend at least one sales call and one customer success call per month. Not to pitch or defend; to listen.
- **In-product feedback** — a "send feedback" affordance, an Intercom-style widget, or a periodic in-product survey. Cheap to add, catches things nobody would bother to open a ticket about.
- **Community channels** — Slack/Discord communities, GitHub Discussions, or domain-specific forums. Lurk, don't brand-police.

### Closing the loop concretely

A rhythm that works at 2–20 people:

- **Daily:** scan error tracker, production dashboards, and the support queue for anything anomalous.
- **Weekly (Monday):** product team reviews top product metrics + top support themes. Thirty minutes, fixed agenda: what changed, what surprised us, what do we want to look at more.
- **Weekly:** at least one customer interview. If none happened, that's a red flag — don't let it slide for two weeks in a row.
- **Every 2 weeks:** retrospective (see "Continuous improvement" below).
- **Monthly:** cohort analysis, NPS read, churn review, roadmap touch-up.
- **Quarterly:** strategy review, OKR refresh, roadmap re-prioritization.

Post the rhythm on the team wiki. If a cadence is not on a calendar, it won't happen.

---

## Experimentation

Once you have signal, the next question is: when should we decide by experiment, and when should we just decide?

### A/B testing

A/B testing is the right tool when the outcome is genuinely uncertain, the change is user-facing, and you have enough traffic to get a statistically useful answer.

**When to A/B test:** landing page and onboarding variants; pricing experiments (carefully — cohort effects); feature variants where one might be materially better and you don't know; algorithmic changes (search ranking, recommendation tuning) with measurable before/after behaviour.

**When NOT to A/B test:** obvious bug fixes (just ship); UI copy tweaks on low-traffic pages; strategic pivots (you commit and adjust); changes where running two variants costs more than the answer is worth; security or compliance changes.

**Practical rules:**

- **Minimum traffic:** roughly 1000 conversions per variant to reliably detect a 1–3% effect. If you don't have that, run longer, pick bigger changes, or ship-then-measure.
- **Don't peek.** Pre-register a sample size and a stopping rule. Early peeking inflates false positives dramatically.
- **Use a framework.** Optimizely, GrowthBook (open source), PostHog Experiments, LaunchDarkly. The framework handles sample-size calculation, stats, and variant exposure.
- **Reuse Phase 06 feature flags.** Experiments are feature flags with a measurement plan attached.
- **Keep an experiment log.** Hypothesis, variants, metric, outcome, decision.

### Holdout groups

Hold back 5% of users who never see a new feature for 30–90 days. This catches long-term regressions short-window A/B tests miss: a feature that looks great in week one but drives slow disengagement over a quarter. At small scale, holdout groups are overkill; at 50+ engineers shipping weekly experiments, they are cheap insurance.

### Qualitative experiments

Not every test needs a control group. Five-user prototype tests (Nielsen's rule of thumb — five users find ~85% of usability problems) still hold at Phase 08. A handful of unmoderated tests can kill a bad idea before it gets a variant in production.

---

## Managing technical debt

The system will get more complex whether you manage it or not (Lehman's Second Law). What you control is whether complexity pays for itself.

### Cunningham's metaphor

Ward Cunningham introduced the debt metaphor in his 1992 OOPSLA experience report on the WyCash portfolio management system. The essence:

> "Shipping first time code is like going into debt. A little debt speeds development so long as it is paid back promptly with a rewrite."
>
> "Every minute spent on not-quite-right code counts as interest on that debt."
>
> "Entire engineering organizations can be brought to a stand-still under the debt load of an unconsolidated implementation."

Three things to take from Cunningham:

1. **Debt is a feature, not a bug.** A small deliberate amount speeds delivery and lets you learn. Refusing all debt is its own failure mode — you ship slowly and learn little.
2. **Interest is real and ongoing.** Every change near the debt costs more than it should. Interest compounds.
3. **Paying down is a concrete act** — refactoring, consolidation, rewriting — not a vague intention.

Cunningham later clarified in a 2009 interview that the metaphor was about *evolving understanding*, not deliberately sloppy code. Debt accrues when "we failed to make our program align with what we then understood to be the proper way to think about" the domain. That reframe matters: most debt in a healthy codebase is the gap between what you knew when you shipped and what you know now.

### Fowler's quadrant

Martin Fowler's "TechnicalDebtQuadrant" classifies debt along two axes: **deliberate vs. inadvertent** and **prudent vs. reckless**.

- **Deliberate–Prudent** ("We must ship now and deal with consequences") — you knew, the trade was worth it. Fine. May not need to pay down if interest is low.
- **Deliberate–Reckless** ("We don't have time for design") — you knew, you didn't bother. Fowler: "usually a reckless debt, because people underestimate where the DesignPayoffLine is." Stop doing this.
- **Inadvertent–Reckless** ("What's layering?") — you didn't know, you made a mess. Training, code review, pairing fix this; process alone does not.
- **Inadvertent–Prudent** ("Now we know how we should have done it") — you did the best you could; you learned later. Fowler: "It's often the case that it can take a year of programming on a project before you understand what the best design approach should have been." This is the dominant category in any real system.

The quadrant is a *diagnostic*, not a priority ordering. You react differently to reckless debt (fix the process, not the code) than to prudent debt (budget refactoring time).

### How to track debt

Don't build a 500-item "tech debt backlog." Nobody will touch it. Within six months it's archaeology.

What works:

- **Tag debt in-code** with a standard comment — `// TODO(debt):` or `// FIXME(debt):` — so `grep` surfaces it and static analysis can count it. Include a one-line description and a ticket or ADR reference.
- **Hotspot analysis.** Adam Tornhill's *Your Code as a Crime Scene* approach: use commit history to find files that concentrate high change frequency *and* high defect/incident frequency. That's where interest is actually being paid. CodeScene automates this; a `git log --pretty=format: --name-only | sort | uniq -c | sort -rg` plus your incident-to-file map gets you 80% of the way.
- **Track cycle time by area.** If the median PR touching module X takes twice as long as one touching module Y, X probably has debt worth attention.
- **Connect debt to outcomes.** Fowler's rule: interest is triggered by modification activity, not time. Cleanup that targets stable unchanged modules is wasted effort.

### How to pay it down

- **Allocate fixed capacity.** 15–20% of engineering capacity, continuously, every sprint. Not "after the next big launch" (there's always another launch).
- **Refactor in small PRs alongside feature work.** Boy scout rule: leave code better than you found it. The PR that adds a feature to a module also cleans up the module's obvious messes.
- **Avoid big-bang refactoring sprints.** They fail for the same reasons rewrites fail — massive batch, delayed integration, no user benefit shipped along the way.
- **Never ship without understanding the debt you're adding.** If a PR knowingly takes on debt, fine — but the author names it in the description and (if it's load-bearing) writes a short ADR.

Heuristic: at the end of each sprint, name one thing the team made materially better. If you can't, the 15–20% was not spent on debt.

---

## Bug management

Bugs are not unusual; they are a constant. The practice is triaging and closing them predictably, not pretending to have zero.

### Severity vs. priority

These are two distinct fields. Conflating them is the most common bug-tracking mistake.

- **Severity** — how bad the problem is. Impact on users, data, revenue, reputation, compliance. Property of the bug.
- **Priority** — when will we fix it. Property of the team's queue and schedule.

They usually correlate, but not always:

- **High severity, low priority** exists — a catastrophic edge case that affects 0.01% of sessions and has a known workaround. You file it, you plan it, but it doesn't jump in front of Monday's work.
- **Low severity, high priority** exists — a cosmetic bug a major customer sees on their demo landing page tomorrow.

Track them as separate fields. Severity feeds your SLA; priority feeds your sprint.

### Triage process

- **Daily triage** for small teams: fifteen minutes, same time each day, one person on rotation.
- **Weekly triage** for teams with low bug inflow: thirty minutes, whole team, walk the new tickets.
- Every bug gets severity, priority, owner, target resolution date, reproduction note. If you cannot fill those fields, the bug isn't ready — send it back.
- Close "can't reproduce" and "won't fix" tickets explicitly. An unresolved open bug is a question the team committed to answering.

### SLAs by severity

Recommend as defaults — adjust for your risk profile and contract obligations. These are not sourced to an industry body; they are a workable starting point.

- **SEV1** — outage, data loss, security incident. Page on-call. Fix now.
- **SEV2** — major feature broken, affects many users, obvious workaround absent. Fix within 1 business day.
- **SEV3** — annoying but not blocking, affects some users or one flow. Fix within 2 weeks.
- **SEV4** — cosmetic, edge case, would-be-nice. Backlog. Revisit quarterly.

Post these and hold yourself to them. A bug SLA that you miss 40% of the time is worse than not having one — it signals to the team that SLAs are vibes.

### Security bugs — a special track

Security bugs score on a different scale. Use the Common Vulnerability Scoring System (CVSS), maintained by FIRST.Org through its CVSS Special Interest Group. The current version is CVSS v4.0, published November 2023. CVSS v4.0 has four metric groups — Base, Threat, Environmental, Supplemental — with Base being the intrinsic characteristics, Environmental letting you adjust for your specific deployment, and Supplemental adding context without changing the score.

NIST's National Vulnerability Database maps CVSS scores to severity bands:

| Band | Range |
|------|-------|
| None | 0.0 |
| Low | 0.1 – 3.9 |
| Medium | 4.0 – 6.9 |
| High | 7.0 – 8.9 |
| Critical | 9.0 – 10.0 |

NIST explicitly notes: "CVSS is not a measure of risk." Score and risk are different — a 10.0 CVSS on a dependency you don't deploy is not an emergency. Your environmental metrics turn a score into a risk.

Recommended security patch SLAs (these are not industry-mandated; adjust to your contract and threat model):

- **Critical (9.0–10.0):** patch within 24 hours.
- **High (7.0–8.9):** patch within 7 days.
- **Medium (4.0–6.9):** patch within 30 days.
- **Low (0.1–3.9):** patch within 90 days.

If an externally-reported vulnerability is in your software, operate coordinated disclosure (see "Security patching lifecycle" below).

---

## Dependency management

Your code is a minority of the software running in your product. The rest is dependencies — direct and transitive — and their hygiene determines whether you are exposed when the next Log4Shell hits.

### Keep it boring

Boring beats clever. The checklist:

- **Use a package manager.** Do not vendor code manually. Do not copy snippets out of Stack Overflow and call them yours.
- **Commit lockfiles.** `package-lock.json`, `yarn.lock`, `Cargo.lock`, `Gemfile.lock`, pinned `requirements.txt`, `go.sum`. Lockfiles pin the transitive tree so CI and prod builds reproduce.
- **Automate update PRs.** GitHub's Dependabot: "Dependabot can fix vulnerable dependencies for you by raising pull requests with security updates." The open-source Renovate bot (Mend.io) does the same across multiple platforms and languages and supports scheduled, grouped, and replacement PRs.
- **Respect semantic versioning.** Semver 2.0.0: MAJOR "MUST be incremented if any backward incompatible changes are introduced to the public API"; MINOR "MUST be incremented if new, backward compatible functionality is introduced"; PATCH "MUST be incremented if only backward compatible bug fixes are introduced." Trust semver for auto-merge on patch releases; be more careful on minors; always read the changelog on majors.
- **Merge security patches fast.** 1–7 days for Critical/High CVSS.
- **Minor/patch updates on a schedule** — monthly or quarterly, batched. If the test suite is solid, most can auto-merge after CI.
- **Major updates deliberately** — on a schedule, with planned effort, not when forced by a CVE.

### Supply chain security

Three incidents frame the threat model:

- **npm left-pad (March 2016).** An 11-line string-padding utility with 15 million weekly downloads, transitive dep of Babel, React, Webpack. The author unpublished it over a dispute. Builds at Facebook, PayPal, Netflix, Spotify broke. npm restored it within two hours and changed policy so packages cannot be unpublished 24 hours after release if others depend on them. **Lesson:** trivial transitive dependencies are a single-point-of-failure. Lockfiles and private package mirrors reduce exposure.
- **SolarWinds (disclosed December 2020).** Attackers compromised the Orion build pipeline in March 2020. Of ~300,000 SolarWinds customers, ~33,000 used Orion and ~18,000 downloaded compromised versions. Malware went undetected for ~8–9 months. **Lesson:** signed artifacts from a trusted vendor are only as trustworthy as the build pipeline. Provenance (reproducible builds, SLSA-style attestations) complements version pinning.
- **Log4Shell (CVE-2021-44228, disclosed December 2021).** RCE in Apache Log4j via default JNDI/LDAP lookup. CVSS 10.0. CISA Director Jen Easterly called it "one of the most serious I've seen in my entire career." **Lesson:** know what's in your stack transitively, and be able to patch quickly.

Concrete practices:

- **Dependency scanning in CI** — Snyk, GitHub Advanced Security, Trivy, OWASP Dependency-Check. Scanning in CI beats scanning in production.
- **Generate and archive an SBOM** per release (Phase 06). When the next widely-exploited CVE lands, you want to answer "do we use it?" in minutes, not days. CycloneDX and SPDX are common formats.
- **Verify signatures where possible** — cosign for container images, sigstore for open-source artifacts.
- **Mirror critical dependencies.** A private proxy (Artifactory, Nexus, GitHub Packages) means an upstream unpublish doesn't break your builds.
- **Minimize transitive depth** when you can.

---

## Security patching lifecycle

Patching is part of operations, not an interruption to it. NIST SP 800-40 Revision 4 ("Guide to Enterprise Patch Management Planning: Preventive Maintenance for Technology," April 2022) frames it as "the process of identifying, prioritizing, acquiring, installing, and verifying the installation of patches, updates, and upgrades throughout an organization" — "a cost of doing business, and a necessary part of what organizations need to do in order to achieve their missions."

### The NIST risk-response phases

NIST SP 800-40 Rev. 4 structures patch execution as four phases:

1. **Prepare the risk response** — acquire, validate, and test patches; coordinate deployment with change management.
2. **Implement the risk response** — distribute and install the patch; resolve issues that surface during deployment.
3. **Verify the risk response** — confirm the install completed and the patches function as intended.
4. **Continuously monitor the risk response** — sustain oversight over time so the response stays in place and effective.

Fit these phases into your delivery pipeline rather than treating patching as a separate workflow. If you cannot push a security patch through CI/CD in under an hour, you cannot hit a 24-hour Critical SLA.

### The lifecycle, end-to-end

1. **Identify.** Subscribe to CVE/NVD feeds and vendor advisories for dependencies you actually deploy. Automate. MITRE maintains the CVE system, funded via DHS; it is the foundation for the NVD.
2. **Assess.** Score with CVSS base + threat + environmental metrics. NIST: "CVSS is not a measure of risk."
3. **Coordinate.** If the vulnerability is in software you maintain, run coordinated disclosure.
4. **Remediate.** Deploy through change management.
5. **Verify.** Confirm patches are applied everywhere — prod, staging, dev, demo.
6. **Communicate.** Changelog, security advisory, in-product notice if users need to act.

### Coordinated disclosure

If you're the reporter: give the vendor a reasonable window. Google Project Zero operates a 90-day embargo, shortened if a patch ships earlier. Zero Day Initiative uses 120 days from vendor response. Complex cases like Meltdown and Spectre ran ~7 months. Err on the side of more time for complex vulns, less for simple patches.

If you're the vendor: publish a `security@` inbox, a security policy (`security.txt`), SLAs for triage response, and a clear expectation for how you acknowledge, embargo, and patch. Don't threaten researchers who report in good faith.

---

## Deprecation and sunsetting

Adding features is easy. Removing them is where teams fail. Over time, unremoved features become the majority of maintenance cost — code to keep working, docs to keep current, tests to keep passing, on-call pages to keep answering — for declining user benefit.

### When to deprecate

- A feature isn't used (usage drops below a meaningful threshold — decide ahead of time, not when arguing about it).
- A feature is superseded by a better alternative already shipped.
- A feature has outsized maintenance cost per active user.
- An API version has been replaced.
- A feature conflicts with a strategic direction and forks the product.

Deprecation is a decision, not a drift. Decide, announce, execute.

### How to deprecate public APIs

- **The HTTP `Sunset` header.** RFC 8594 (Erik Wilde, IETF Informational, May 2019) defines a response header that "indicates that a URI is likely to become unresponsive at a specified point in the future." Syntax: `Sunset: Sat, 31 Dec 2027 23:59:59 GMT`. Clients treat the timestamp as a hint, not a guarantee. Emit on deprecated endpoints well before removal.
- **The `Deprecation` header** — an IETF draft exists; include it where tooling supports it as a complementary hint to `Sunset`.
- **Named versions with a committed support window.** GitHub uses date-based REST API versioning via the `X-GitHub-Api-Version` header (default `2022-11-28`) and commits: "When a new REST API version is released, the previous API version will be supported for at least 24 more months following the release of the new API version." Stripe uses named major releases (e.g., "Acacia") with backward-compatible monthly updates under the same name and per-request version overrides for testing upgrades. Pick one model; publish your commitment; honour it.
- **6–12 months of lead time** for public APIs with paying customers. Shorter for internal APIs or a tiny set of known integrators.
- **In-product warnings** for customers hitting the deprecated endpoint — log-line, email to integration owner, header echo.
- **A migration guide** with real before/after code.
- **A public deprecation policy** so customers can plan.

### How to sunset features

- **Communicate.** In-product banner, email to affected users, changelog entry, status page note. One channel is not enough.
- **Provide an alternative.** If there is none, you're asking users to change workflow; budget help and time.
- **Provide data export** if the feature stored user-owned data.
- **Freeze, then retire, then remove.** No new users → existing users migrated → code deleted. Each step has a date. Track adoption of the replacement before the sunset date.
- **Be humane about holdouts.** A small cohort always misses the deadline. Reach out individually if numbers allow.

---

## Legacy modernization

At some point a part of the system becomes hard to change — the architecture no longer fits the problem, the framework is end-of-life, the database schema is calcified. You have two options: rewrite or strangle. Strangle almost always wins.

### The Strangler Fig pattern

Martin Fowler named the Strangler Fig Application pattern (revised August 2024): incrementally replace a legacy system with new components that grow around and eventually replace the old one. The name is from the fig species that germinates in a host tree's canopy and grows roots down around the host until the host dies inside the fig.

Fowler: the approach "begins with small additions, often new features, that are built on top of, yet separate to the legacy code base." It "doesn't make the exercise easy" but lets "investment and returns occur gradually and visibly."

The pattern requires a transitional architecture where old and new systems coexist. Four activities Fowler names: establish clear desired outcomes; decompose into manageable components; deliver replacements incrementally; implement organizational changes to sustain the approach.

Concrete steps:

1. **Identify the seams.** Michael Feathers (*Working Effectively with Legacy Code*, 2004) defines a seam as "a place where you can alter behavior in your program without editing in that place." Feathers lists preprocessing seams, link seams, and object seams, with "object seams are the best choice in object-oriented languages."
2. **Stand up the new system alongside** — same inputs, same protocol, initially zero traffic.
3. **Route one slice** — one endpoint, one entity type, one small tenant.
4. **Verify parity.** Shadow requests, canary percentages, diff tools. Don't trust a rewrite without evidence.
5. **Promote** — real traffic moves, old code path retired for that slice.
6. **Repeat** until the old system is empty, then delete it.

### Rewrites

Rewrites usually fail. A full rewrite takes multiple years, ships nothing in the meantime, competes with the old system for effort, and arrives at a moving target spec.

A rewrite is occasionally justified when *all* of: the old system is actively blocking the business in a way incremental change cannot fix; the team has capacity to run both in parallel until handoff; the problem domain is well-understood so the rewrite isn't also a discovery project; executive commitment exists to actually ship, not just start.

If any of those is missing, strangle instead.

---

## Continuous improvement

Product and engineering quality do not stay constant; they drift. Continuous improvement is how you notice drift early and correct.

### Retrospectives

Norman Kerth's *Project Retrospectives: A Handbook for Team Reviews* (Dorset House, 2001) is the canonical text.

- **Cadence:** every 2 weeks, at sprint boundary, or after any significant event (launch, incident). Don't skip.
- **Duration:** 60–90 minutes. Longer becomes theatre; shorter misses context.
- **Format:** whatever works — "start/stop/continue," "mad/sad/glad," "4 Ls" — but fixed so the team doesn't relearn the ceremony.
- **Kerth's Prime Directive**, read aloud at the start: "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand." Not polite wallpaper. It is the operating assumption that makes retrospectives useful: if you suspect blame, you hunt for it; if you assume good faith, you ask why the system produced the outcome.
- **Concrete action items** with owners and target dates, written down.
- **Review last retro's actions at the start of the next.** If action items disappear, the ritual dies.

### PDCA and Toyota Kata

Retrospectives generate ideas; you still need a method for running improvements.

**PDCA (Plan–Do–Check–Act).** Walter Shewhart's 1920s quality-control cycle, popularized by W. Edwards Deming. Four phases for a single experiment: Plan (establish objective and expected result); Do (execute); Check (Deming preferred "Study" — evaluate outcome against expectation); Act (standardize what works, reset what doesn't). PDCA is the unit of learning for one change.

**Toyota Kata (Mike Rother, 2009).** Two patterns: the **Improvement Kata** (consider vision, grasp current condition, define a target condition, iterate toward it while discovering obstacles) and the **Coaching Kata** (mentor-mentee routine that teaches the Improvement Kata culturally). Rother's argument: sustained advantage comes from mastering "a routine for developing fitting solutions repeatedly."

How they fit together: retrospectives produce hypotheses; the Improvement Kata picks a target condition and shapes the sequence of changes; each change is a PDCA cycle.

### Metrics for team health

- **DORA four keys** (from Phase 06 / Accelerate): deployment frequency, lead time for changes, change-failure rate, time to restore service. These measure engineering throughput without measuring individuals.
- **On-call health** — pages per shift, pages per week, percentage of off-hours pages. Rising trend = operational debt.
- **Cycle time trend** — PR open to merge, idea to production. If it doubles over a quarter, something is wrong.
- **Employee engagement (eNPS or similar)** — quarterly pulse on how the team feels. Not a vanity metric; it predicts attrition, which is expensive.

---

## Roadmap evolution

Phase 02 gave you a roadmap. Phase 08 evolves it.

- **Revisit OKRs quarterly.** Drop the ones that didn't land; don't pretend they did. Keep the ones that still matter. Promote new ones from the signal you've been gathering.
- **Now / Next / Later format.** Items move each sprint: Next becomes Now when capacity frees up; Later becomes Next when its time is close. The format forces you to prioritize without over-committing to precise dates on work that hasn't started yet.
- **Retire strategy items that didn't work** openly — "we tried X, it didn't move Y, we're stopping." Teams that hide failures lose the lesson.
- **Be willing to kill features.** Deprecate them (see above), don't just add alternatives. A product with fifteen ways to do the same thing is a product with fifteen support burdens.
- **Close the loop from interviews and data into roadmap changes** explicitly. "We moved X up because customers A, B, and C all asked for it this month" is the sentence a healthy PM says often.

---

## Anti-patterns

- **Feature factories** — measuring output (shipped features) over outcomes (customer behaviour changes, business metrics moved). Marty Cagan-style anti-pattern: the roadmap is a throughput target, not a hypothesis set.
- **"We'll refactor after the next big launch."** You won't. There's always another launch. Allocate debt capacity continuously.
- **500-item bug backlog nobody triages.** Close "won't fix" openly. A backlog you never work is archaeology, not a work queue.
- **Ignoring dependency updates until a CVE hits.** Log4Shell cost more in scrambled weekends than a year of Renovate PRs would have cost in review time.
- **Two-year rewrite projects that never ship.** Strangle instead.
- **Retros as ceremony theatre with no follow-through.** If last retro's actions are not reviewed this retro, skip the retro — it's just eating an hour.
- **Sunsetting a feature without a migration path.** Users who built workflows on the feature will leave.
- **NPS as a vanity metric.** The number without the "Why?" is noise.
- **Pet-project refactors disguised as debt paydown.** The 15–20% budget should target hotspots tied to user or business outcomes, not whichever module the senior engineer finds ugly.
- **Drift from customers.** A month without a customer interview is a yellow flag. Two months is red.
- **Shipping without a changelog.** If users don't know what changed, they don't use the new capability and they can't diagnose regressions.

---

## Scale notes

- **Solo or tiny team (1–3 people):** product analytics + one customer interview per week + 15% debt capacity + Dependabot auto-merging security patches + a weekly thirty-minute metrics review. Skip formal A/B testing until traffic supports it.
- **Team of 5:** the full rhythm above. Add simple A/B testing via feature flags (GrowthBook or PostHog Experiments). Deprecation discipline — write the policy down even if short.
- **Team of 20:** dedicated on-call rotation already; formal CVE watchlist with owner; written deprecation policy; tech-debt capacity tracked per sprint; retrospective notes archived.
- **Team of 50:** dedicated experimentation platform; deprecation policy in writing and enforced at code review; a platform team owning dependency updates across services; a written security patching runbook; a customer-advisory cohort for major changes.
- **Team of 500+:** full experimentation and personalization platform; platform team owning dependencies at the organizational level; formal API deprecation lifecycle with customer-communication SLAs; separate security response team with published SLA; customer research org embedded in product.

Scale the ceremony to the team. The three invariants at every size: someone talks to customers weekly; debt capacity is allocated and spent; security patches land within SLA.

---

## Exit checklist (per quarter)

This phase doesn't exit. But every quarter, confirm:

- [ ] North Star + 3–5 input metrics tracked and reviewed at least weekly.
- [ ] At least one customer interview per week completed over the quarter.
- [ ] Bug SLAs met for > 90% of bugs by severity.
- [ ] Dependency updates merged within policy for the quarter.
- [ ] CVE patch SLAs met for > 95% of applicable vulnerabilities.
- [ ] Tech debt capacity (target 15–20%) actually spent on debt — not feature work with a "refactor" label.
- [ ] Retrospective action items from the previous cycle reviewed and closed or re-planned.
- [ ] Any deprecations announced to customers with dates and migration guides.
- [ ] Roadmap re-prioritized against the quarter's signal; OKRs refreshed.
- [ ] SBOM regenerated for the current production release and archived.
- [ ] DORA four keys and on-call health metrics reviewed; any adverse trend has a named owner.

---

## Why this works

The recommendations above trace to the research and are not arbitrary. Key citations:

- **Continuous change and evolution.** Lehman's laws of software evolution (1974–1996) — see `../research/08-maintenance/README.md` §1. The whole framing of Phase 08 as a continuous capability rather than a terminal phase derives from Lehman's First, Second, and Eighth Laws.
- **Categories of maintenance.** ISO/IEC/IEEE 14764:2022 — corrective, adaptive, perfective, preventive — see `../research/08-maintenance/README.md` §2. Enhancement (perfective + adaptive) dominates the work, which is why this chapter treats deprecation, refactoring, and capability expansion as core rather than exceptional activities.
- **Customer feedback metrics.** NPS (Reichheld, HBR 2003), CES (Dixon/Freeman/Toman, HBR 2010), CSAT — see `../research/08-maintenance/feedback-loops.md` §§1–3. Continuous discovery as the outer feedback loop — `../research/08-maintenance/feedback-loops.md` §5 aligned to Lehman's Eighth Law.
- **Retrospectives and continuous improvement.** Kerth's *Project Retrospectives* (Dorset House, 2001) and the Prime Directive — `../research/08-maintenance/feedback-loops.md` §6. PDCA (Shewhart/Deming) and Toyota Kata (Rother, 2009) — `../research/08-maintenance/feedback-loops.md` §§7–9.
- **Technical debt.** Cunningham's OOPSLA '92 debt metaphor — `../research/08-maintenance/technical-debt.md` §1. Fowler's debt definition and quadrant — §§2–3. Tornhill's hotspot approach — §4.
- **Bug management.** Severity vs. priority — `../research/08-maintenance/bug-management.md` §1. CVSS v4.0 and FIRST.Org / NIST NVD severity bands — §3.
- **Dependency management and supply chain.** Semver 2.0.0 — `../research/08-maintenance/dependency-management.md` §1. Dependabot and Renovate — §§3–4. left-pad, SolarWinds, Log4Shell as primary incident evidence — §5.
- **Security patching.** CVE system governance (MITRE, DHS) — `../research/08-maintenance/security-patching.md` §1. CVSS v4.0 — §2. Coordinated disclosure embargoes (Project Zero 90 days, ZDI 120 days) — §3. NIST SP 800-40 Rev. 4 four-phase risk response — §5.
- **Deprecation.** RFC 8594 Sunset header — `../research/08-maintenance/deprecation.md` §1. Stripe and GitHub API versioning as documented examples — §2.
- **Legacy modernization.** Fowler's Strangler Fig pattern — `../research/08-maintenance/deprecation.md` §4 and `../research/08-maintenance/README.md` §3. Feathers' seams and dependency-breaking techniques — `../research/08-maintenance/README.md` §3.

If you disagree with a specific recommendation, the research file spells out what is verified and what is synthesis, and you can make a different trade-off with your eyes open. What is not optional is having *some* version of the four loops this phase names: customer feedback → roadmap, production signal → engineering, retro → process, CVE feed → patching. Miss any one of those and Lehman's Second and Seventh Laws come for you.
