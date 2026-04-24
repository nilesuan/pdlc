# Site Reliability Engineering (SRE)

**Question:** What is SRE, and what are its core concepts — SLIs, SLOs, SLAs, error budgets, and toil?

**Status:** Draft

**Last updated:** 2026-04-24

---

## Origin

Site Reliability Engineering is Google's approach to running production systems at scale. Google publishes the two canonical references — the original SRE book (2016) and the SRE Workbook (2018) — online for free at sre.google. The table of contents of the first book organises material into Introduction, Principles, Practices, Management, and Conclusions, with 34 chapters and 6 appendices. Source: [Site Reliability Engineering — Table of Contents](https://sre.google/sre-book/table-of-contents/) (accessed 2026-04-24).

The Workbook is organised into Foundations, Practices, and Processes, with dedicated chapters on Implementing SLOs, Monitoring, Alerting on SLOs, Eliminating Toil, On-Call, Incident Response, and Postmortem Culture. Source: [SRE Workbook — Table of Contents](https://sre.google/workbook/table-of-contents/) (accessed 2026-04-24).

---

## Reliability as a product feature

Google's Embracing Risk chapter states a counter-intuitive core principle [VERIFIED]:

> "100% is probably never the right reliability target: not only is it impossible to achieve, it's typically more reliability than a service's users want or notice."

Source: [Embracing Risk — Google SRE book](https://sre.google/sre-book/embracing-risk/) (accessed 2026-04-24).

Risk tolerance, the same chapter says, depends on availability targets, types of failure impact, cost-benefit analysis, and secondary metrics like latency and throughput. Treating reliability as a measurable product feature — rather than an absolute — is what makes the rest of the SRE model work.

---

## SLIs, SLOs, SLAs

The Service Level Objectives chapter provides precise definitions [VERIFIED]:

- **Service Level Indicator (SLI):** "a carefully defined quantitative measure of some aspect of the level of service that is provided." Examples the book gives: request latency, error rate, system throughput, availability.
- **Service Level Objective (SLO):** "a target value or range of values for a service level that is measured by an SLI." Structure: `SLI ≤ target` or `lower bound ≤ SLI ≤ upper bound`. Example from the book: "99% of `Get` RPC calls will complete in less than 100 ms."
- **Service Level Agreement (SLA):** "an explicit or implicit contract with your users that includes consequences of meeting (or missing) the SLOs they contain."

The book offers a diagnostic for telling SLOs and SLAs apart: "ask 'what happens if the SLOs aren't met?': if there is no explicit consequence, then you are almost certainly looking at an SLO."

Source: [Service Level Objectives — Google SRE book](https://sre.google/sre-book/service-level-objectives/) (accessed 2026-04-24).

**[SYNTHESIS]** Nesting these terms: the SLI is what you measure, the SLO is the promise you make to yourself, the SLA is the promise (with consequences) you make to a customer. Citations for each term are separate and above.

---

## Error budgets

The Embracing Risk chapter defines the error budget directly [VERIFIED]:

> "The error budget provides a clear, objective metric that determines how unreliable the service is allowed to be within a single quarter."

The budget is the complement of the SLO over a time window: if your SLO is 99.9% availability over a quarter, your error budget is 0.1% of that quarter. The chapter frames error budgets as resolving the tension between product development (optimised for velocity) and SRE (optimised for reliability):

> "Product development performance is largely evaluated on product velocity… meanwhile, SRE performance is… evaluated based upon reliability."

The budget becomes "a common incentive that allows both product development and SRE to focus on finding the right balance between innovation and reliability."

Source: [Embracing Risk — Google SRE book](https://sre.google/sre-book/embracing-risk/) (accessed 2026-04-24).

**[SYNTHESIS]** This produces an error-budget policy pattern: while the budget is healthy, ship features; when the budget is exhausted, feature work halts until reliability is restored. The specific policy mechanics are organisation-specific; the tension-resolution logic above is what the source explicitly supports.

---

## Toil

The Eliminating Toil chapter gives an exact, enumerable definition [VERIFIED]. Toil is work that is:

- **Manual** — hands-on human effort.
- **Repetitive** — performed regularly, not novel.
- **Automatable** — could be done by machines or designed away.
- **Tactical** — interrupt-driven, reactive, not strategic.
- **Devoid of enduring value** — the service is unchanged after the task.
- **Scales linearly** — effort grows proportionally with service growth.

Google's declared target: "keeping operational work (i.e., toil) below 50% of each SRE's time." At least half of an SRE's time should go to engineering work that reduces future toil.

Costs of excessive toil listed in the chapter include career stagnation, low morale and burnout, reduced product velocity, "sets precedent for inappropriate task-shifting to SRE teams," and attrition among talented engineers.

Source: [Eliminating Toil — Google SRE book](https://sre.google/sre-book/eliminating-toil/) (accessed 2026-04-24).

---

## The SRE Workbook's practical additions

The Workbook's Postmortem Culture chapter explicitly builds on the first book and adds practical guidance [VERIFIED]:

- Leadership must "consistently exemplify blameless behavior."
- Action items should have a "verifiable end state" with clear ownership.
- Postmortems should be "written and circulated less than a week after the incident was closed."
- They should be "accessible to everyone at the company."

> "When written well, acted upon, and widely shared, postmortems can be a very effective tool for driving positive organizational change and preventing repeat outages."

Source: [Postmortem Culture: Learning from Failure — SRE Workbook](https://sre.google/workbook/postmortem-culture/) (accessed 2026-04-24).

---

## Sources

- [Site Reliability Engineering — Table of Contents](https://sre.google/sre-book/table-of-contents/) (accessed 2026-04-24)
- [SRE Workbook — Table of Contents](https://sre.google/workbook/table-of-contents/) (accessed 2026-04-24)
- [Embracing Risk — Google SRE book](https://sre.google/sre-book/embracing-risk/) (accessed 2026-04-24)
- [Service Level Objectives — Google SRE book](https://sre.google/sre-book/service-level-objectives/) (accessed 2026-04-24)
- [Eliminating Toil — Google SRE book](https://sre.google/sre-book/eliminating-toil/) (accessed 2026-04-24)
- [Postmortem Culture: Learning from Failure — SRE Workbook](https://sre.google/workbook/postmortem-culture/) (accessed 2026-04-24)

---

## Open questions

- **Error budget policy exemplars** — Google's book describes the concept; which companies publish their actual policies (thresholds, freeze triggers)? Primary sources would strengthen the "how to operationalise this" story.
- **SRE vs Platform Engineering vs DevOps vs Production Engineering** — terminology is organisation-specific. Is there a canonical, citable mapping? Team Topologies provides a partial answer (platform team as IDP provider) but not a one-to-one translation.
- **Toil measurement in practice** — how do teams measure % of time spent on toil? The SRE book uses the threshold but does not give a standard instrument.
