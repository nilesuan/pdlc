# Incident Response & Postmortem Culture

**Question:** When production breaks, how do industry-grade teams organise the response, and how do they learn from it afterwards?

**Status:** Draft

**Last updated:** 2026-04-24

---

## The Incident Command System foundation

Google's Managing Incidents chapter explicitly names its lineage [VERIFIED]:

> "The framework is based on the Incident Command System, known for its clarity and scalability in emergency response."

This is a deliberate import from emergency services (fire, medical, disaster response) into software operations.

Source: [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/) (accessed 2026-04-24).

---

## Roles

### Google SRE's four roles

From Managing Incidents [VERIFIED]:

- **Incident Commander** — "Maintains high-level incident state and structures the response task force, assigning duties based on priority and need."
- **Operational Lead** — "Works with the commander to apply operational tools and respond to the incident. 'The operations team should be the only group modifying the system during an incident.'"
- **Communications Lead** — "Serves as the public face, responsible for 'issuing periodic updates to the incident response team and stakeholders (usually via email).'"
- **Planning Lead** — "Handles longer-term concerns like filing bugs, arranging handoffs, and tracking system divergence from normal operations."

Structural features the chapter names: "recursive separation of responsibilities," a recognised command post (physical or virtual via IRC — now typically a Slack/Teams room), a living incident state document editable by multiple people, and explicit commander handoff procedures.

Source: [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/) (accessed 2026-04-24).

### PagerDuty's extended role set

PagerDuty's public Incident Response documentation — described as "a cut-down version of our internal documentation" — names more specialised positions [VERIFIED]:

- **Incident Commander (IC)** — leads the response.
- **Deputy** — backs up and supports the IC.
- **Scribe** — documents the incident as it unfolds.
- **Subject Matter Expert (SME)** — provides technical expertise on the specific failing system.
- **Customer Liaison** — public-facing representative.
- **Internal Liaison** — coordinates with internal teams.

Source: [PagerDuty Incident Response](https://response.pagerduty.com/) (accessed 2026-04-24).

The PagerDuty guide organises its content into four phases: Being On-Call, Before, During, After — mapping to preparation, initial response, ongoing management, and post-incident learning.

**[SYNTHESIS]** The Google and PagerDuty role sets are compatible. PagerDuty's Deputy and Scribe split responsibilities the Google model bundles into Operational Lead and Planning Lead; PagerDuty's Customer / Internal Liaison split the Google Communications Lead's role by audience. Both are citable independently; the mapping between them is this synthesis.

---

## Severity classification

PagerDuty's guide references a tiered SEV-1, SEV-2, SEV-3 system but the content surfaced during this fetch did not define the thresholds in detail. Source: [PagerDuty Incident Response](https://response.pagerduty.com/) (accessed 2026-04-24).

**[UNVERIFIED]** Specific severity-tier definitions ("SEV-1 = user-facing, company-wide outage" etc.) are commonly seen in industry playbooks but I did not locate a canonical, citable taxonomy during this session. Organisations typically define their own thresholds tied to SLO impact, customer impact, and data-integrity impact.

---

## Best practices during an incident

From Google's Managing Incidents [VERIFIED]:

- Prioritise impact.
- Prepare procedures in advance.
- Trust team autonomy.
- Practice regularly.
- Rotate roles to build organisational competency.

Source: [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/) (accessed 2026-04-24).

---

## Postmortem culture

### Google's definition

From the Postmortem Culture chapter of the SRE book [VERIFIED]:

> "A postmortem is a written record of an incident, its impact, the actions taken to mitigate or resolve it, the root cause(s), and the follow-up actions to prevent the incident from recurring."

A blameless postmortem "must focus on identifying the contributing causes of the incident without indicting any individual or team for bad or inappropriate behavior."

The chapter's core philosophy:

> "You can't 'fix' people, but you can fix systems and processes to better support people making the right choices."

And:

> "Removing blame from a postmortem gives people the confidence to escalate issues without fear."

Documented postmortem triggers include user-visible downtime/degradation above a threshold, data loss, on-call intervention (rollback, traffic rerouting), resolution time above threshold, and monitoring failures requiring manual discovery.

Source: [Postmortem Culture: Learning from Failure — Google SRE book](https://sre.google/sre-book/postmortem-culture/) (accessed 2026-04-24).

### The SRE Workbook's updates

The Workbook builds on the first book with practical guidance [VERIFIED]:

- Leadership must "consistently exemplify blameless behavior and encourage blamelessness in every aspect of postmortem discussion."
- Action items should have a "verifiable end state" with clear ownership and tracking.
- Publication should be fast: "written and circulated less than a week after the incident was closed."
- Distribution should be wide: "accessible to everyone at the company."

Source: [Postmortem Culture: Learning from Failure — SRE Workbook](https://sre.google/workbook/postmortem-culture/) (accessed 2026-04-24).

### Etsy's Code as Craft blameless postmortems

John Allspaw's 2012 Etsy post "Blameless PostMortems and a Just Culture" is frequently cited as popularising blameless postmortems in the software industry. **[VERIFIED]** via a companion 2013 Allspaw post hosted on his own site ([Learning from Failure at Etsy — Kitchen Soap, 2013-09-30](https://www.kitchensoap.com/2013/09/30/learning-from-failure-at-etsy/) (accessed 2026-04-24)), which presents the same Just Culture / blameless postmortem argument. Direct verbatim passages from that 2013 post (which mirrors the 2012 framing):

- Failure: "This is the traditional view of 'human error', which focuses on the characteristics of the individuals involved. It's what Sidney Dekker calls the 'Bad Apple Theory' — get rid of the bad apples, and you'll get rid of the human error."
- The alternative: "We instead want to view mistakes, errors, slips, lapses, etc. with a perspective of learning."
- Just Culture: "Having a Just Culture means that you're making effort to balance safety and accountability. It means that by investigating mistakes in a way that focuses on the situational aspects of a failure's mechanism and the decision-making process of individuals proximate to the failure, an organization can come out safer than it would normally be if it had simply punished the actors involved as a remediation."
- The purpose of the blameless write-up: an engineer "can give a detailed account… without fear of punishment or retribution. Why shouldn't they be punished or reprimanded? Because an engineer who thinks they're going to be reprimanded are disincentivized to give the details necessary to get an understanding of the mechanism, pathology, and operation of the failure."

The direct URL `www.etsy.com/codeascraft/blameless-postmortems` continued to return HTTP 403 on 2026-04-24; the companion Kitchen Soap post is Allspaw's own site and serves as a primary-author source for the same argument.

### The Learning From Incidents movement

The LFI community, started by Nora Jones, has grown around a research-informed critique of traditional root-cause analysis. Allspaw's framing, drawn from the IT Revolution essay "Learning Effectively From Incidents: The Messy Details" [VERIFIED]:

- "Learning is never not happening. It is what humans do."
- Effective incident analysis must highlight "surprise, difficulty, misunderstandings, dilemmas, and paradoxes" — the things that make stories memorable.
- The goal is capturing "the richest understanding of the event, represented for the broadest audience possible."
- Hindsight bias is a primary obstacle: the tendency to collapse a messy event into a tidy single-cause narrative.
- Progress indicators include: write-ups that are widely read, voluntary attendance at incident reviews, and documentation linked from code comments, architecture diagrams, and onboarding materials.

Source: [Learning Effectively From Incidents: The Messy Details — John Allspaw, IT Revolution](https://itrevolution.com/articles/learning-effectively-from-incidents-the-messy-details/) (accessed 2026-04-24).

**[CONTESTED — but explicit]** Traditional root-cause analysis (RCA) frames incidents as having *the* cause. The LFI perspective, grounded in human-factors and resilience engineering, frames incidents as the surprising intersection of many contributing conditions. Both views appear in industry practice. The Google SRE Postmortem chapter uses "contributing causes" language — closer to LFI than to strict RCA — though the concept of "root cause" still appears in Google's own definition of a postmortem.

---

## Sources

- [Managing Incidents — Google SRE book](https://sre.google/sre-book/managing-incidents/) (accessed 2026-04-24)
- [PagerDuty Incident Response](https://response.pagerduty.com/) (accessed 2026-04-24)
- [Being On-Call — PagerDuty Incident Response](https://response.pagerduty.com/oncall/being_oncall/) (accessed 2026-04-24)
- [Postmortem Culture: Learning from Failure — Google SRE book](https://sre.google/sre-book/postmortem-culture/) (accessed 2026-04-24)
- [Postmortem Culture: Learning from Failure — SRE Workbook](https://sre.google/workbook/postmortem-culture/) (accessed 2026-04-24)
- [Learning Effectively From Incidents: The Messy Details — John Allspaw, IT Revolution](https://itrevolution.com/articles/learning-effectively-from-incidents-the-messy-details/) (accessed 2026-04-24)
- [Learning from Failure at Etsy — John Allspaw, Kitchen Soap, 2013](https://www.kitchensoap.com/2013/09/30/learning-from-failure-at-etsy/) (accessed 2026-04-24)

---

## Open questions

- **Etsy 2012 post direct fetch** — `www.etsy.com/codeascraft/blameless-postmortems` still returned HTTP 403 on 2026-04-24; the 2013 kitchensoap.com companion post (Allspaw's own site) now substitutes for the verbatim Just Culture framing. The specific "Second Story" wording in the 2012 post remains unverified from the original Etsy URL.
- **Learning From Incidents community site** — learningfromincidents.io was again unreachable on 2026-04-24 (TLS alert internal error / connection reset on both `learningfromincidents.io` and `www.learningfromincidents.io`). Site appears to be down or mis-serving TLS. No primary quotations possible this pass.
- **Severity taxonomy** — locate a primary source for a canonical SEV-1..SEV-5 definition (if one exists), rather than re-describing company-internal definitions.
- **Incident metrics** — MTTA/MTTR/MTBF definitions deserve a cited primary source; they were referenced secondarily in fetched content but not independently defined.
- **Resilience engineering literature** — Woods, Hollnagel, Dekker are frequently cited by LFI; adding direct citations would strengthen the intellectual lineage.
