# UX Design

**Question:** What is the industry-documented UX design process (wireframes → prototypes → design systems), what usability heuristics and accessibility standards are canonical, and which legal frameworks apply?

**Status:** Draft

**Last updated:** 2026-04-24

---

## 1. UX design process (Design Thinking framing)

The Nielsen Norman Group (NNG) describes the design-thinking framework as "6 distinct phases" within three overarching buckets — Understand, Explore, Materialize. The six phases:

1. **Empathize** — "Conduct research in order to develop knowledge about what your users do, say, think, and feel."
2. **Define** — "Combine all your research and observe where your users' problems exist."
3. **Ideate** — "Brainstorm a range of crazy, creative ideas that address the unmet user needs identified in the define phase."
4. **Prototype** — "Build real, tactile representations for a subset of your ideas."
5. **Test** — "Return to your users for feedback. Ask yourself 'Does this solution meet users' needs?'"
6. **Implement** — "Put the vision into effect."

NNG emphasises "these phases are iterative and cyclical" rather than strictly linear. [Design Thinking 101 — Nielsen Norman Group](https://www.nngroup.com/articles/design-thinking/) (accessed 2026-04-24).

---

## 2. Wireframes and prototypes

[SYNTHESIS] The sources I was able to fetch support:

- **Wireframes** as low-fidelity structural sketches of an interface.
- **Prototypes** as representations — at varying fidelity — that can be user-tested. NNG's article on paper prototyping says: "With a paper prototype, you can user test early design ideas at an extremely low cost." [Paper Prototyping — Nielsen Norman Group](https://www.nngroup.com/articles/paper-prototyping/) (accessed 2026-04-24).

[UNVERIFIED in fetched sources] The canonical NNG article at `/articles/wireframes/` returned HTTP 404 in this session, so a direct primary-source quotation defining wireframes cannot be provided. A follow-up pass should fetch a current NNG wireframes article.

---

## 3. Jakob Nielsen's 10 usability heuristics

NNG publishes Jakob Nielsen's 10 usability heuristics (originally 1994; article last updated 2024 per its header). The 10 heuristics and their published descriptions:

1. **Visibility of System Status** — "The design should always keep users informed about what is going on, through appropriate feedback within a reasonable amount of time."
2. **Match Between the System and the Real World** — "The design should speak the users' language."
3. **User Control and Freedom** — "Users often perform actions by mistake. They need a clearly marked 'emergency exit' …"
4. **Consistency and Standards** — "Users should not have to wonder whether different words, situations, or actions mean the same thing."
5. **Error Prevention** — "Good error messages are important, but the best designs carefully prevent problems from occurring in the first place."
6. **Recognition Rather than Recall** — "Minimize the user's memory load by making elements, actions, and options visible."
7. **Flexibility and Efficiency of Use** — "Shortcuts — hidden from novice users — may speed up the interaction for the expert user …"
8. **Aesthetic and Minimalist Design** — "Interfaces should not contain information that is irrelevant or rarely needed."
9. **Help Users Recognize, Diagnose, and Recover from Errors** — "Error messages should be expressed in plain language (no error codes), precisely indicate the problem, and constructively suggest a solution."
10. **Help and Documentation** — "It's best if the system doesn't need any additional explanation. However, it may be necessary to provide documentation to help users."

[10 Usability Heuristics — Nielsen Norman Group, Jakob Nielsen](https://www.nngroup.com/articles/ten-usability-heuristics/) (accessed 2026-04-24).

---

## 4. Design systems

NNG defines a design system as "A complete set of standards intended to manage design at scale using reusable components and patterns." [Design Systems 101 — Therese Fessenden, NNG, 2021-04-11](https://www.nngroup.com/articles/design-systems-101/) (accessed 2026-04-24).

First-party examples whose primary pages I fetched in this session:

- **Shopify Polaris**: "Polaris Design System for React" providing "Fundamental design guidance for creating quality admin experiences" and "Reusable elements and styles, packaged through code, for building admin interfaces." Includes "Coded names that represent design decisions for color, spacing, typography, and more" and "Over 400 carefully designed icons focused on commerce and entrepreneurship." Note: the React version page I fetched flagged that Shopify now directs users to Polaris Web Components. [Shopify Polaris — polaris-react.shopify.com](https://polaris-react.shopify.com/) (accessed 2026-04-24).

[UNVERIFIED / UNFETCHED in this session] Material Design 3 (m3.material.io) and Fluent UI (developer.microsoft.com/en-us/fluentui) returned responses that did not include substantive principle text; quotations for those design systems need follow-up fetches.

---

## 5. Accessibility

### 5.1 WCAG

W3C's WAI page describes three active versions: WCAG 2.0 (2008-12-11), WCAG 2.1 (2018-06-05), and WCAG 2.2 (2023-10-05; updated 2024-12-12). "Content that conforms to WCAG 2.2 also conforms to WCAG 2.1 and WCAG 2.0." WCAG defines three conformance levels: **A, AA, and AAA**. WCAG 2.2 received ISO approval as **ISO/IEC 40500:2025**. [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

WCAG organises its guidelines around four principles (POUR): "perceivable, operable, understandable, and robust." [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24).

W3C's introductory page defines web accessibility as "websites, tools, and technologies are designed and developed so that people with disabilities can use them," enabling people to "perceive, understand, navigate, and interact with the Web" and "contribute to the Web." [Introduction to Web Accessibility — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-intro/) (accessed 2026-04-24).

### 5.2 ADA (United States)

The US Department of Justice's ADA web guidance states that the ADA's requirements apply to:

- **Title II** (state and local governments): "state and local governments must take steps to ensure that their communications with people with disabilities are as effective as their communications with others," and "the ADA's requirements apply to all the services, programs, or activities of state and local governments, including those offered on the web."
- **Title III** (public accommodations / businesses): must "provide full and equal enjoyment of their goods, services, facilities, privileges, advantages, or accommodations to people with disabilities," with the DOJ noting "the ADA's requirements apply to all the goods, services, privileges, or activities offered by public accommodations, including those offered on the web."

The DOJ's own guidance page notes that the Department's interpretation relies on "general nondiscrimination and effective communication provisions" rather than a specific technical regulation.

[ADA Web Guidance — ada.gov](https://www.ada.gov/resources/web-guidance/) (accessed 2026-04-24).

### 5.3 European Accessibility Act (EAA)

The European Commission describes the EAA as "a directive that aims to improve the functioning of the internal market for accessible products and services, by removing barriers created by divergent rules in Member States." The directive covers specific categories: computers and operating systems; ATMs, ticketing and check-in machines; smartphones; TV equipment for digital television; telephony services and related equipment; audio-visual media services; passenger transport services (air, bus, rail, waterborne); banking services; e-books; and e-commerce.

[European Accessibility Act — European Commission](https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/union-equality-strategy-rights-persons-disabilities-2021-2030/european-accessibility-act_en) (accessed 2026-04-24).

[UNVERIFIED] The exact application date and technical compliance requirements are not in the fetched page content, which notes "the page does not detail specific technical compliance requirements; for those details, consultation of the full directive text would be necessary."

---

## 6. A practical UX flow in the PDLC

[SYNTHESIS — combining fetched sources.]

1. **Research (Empathize / Define)** — user research, problem framing. (NNG design thinking.)
2. **Ideate** — sketches, concept exploration. (NNG design thinking.)
3. **Low-fidelity prototyping** — paper or wireframes, tested cheaply. (NNG paper prototyping article; wireframes article unavailable in this session.)
4. **High-fidelity prototyping** — interactive mockups using design-system components (e.g., Polaris), evaluated against Nielsen's 10 heuristics.
5. **Accessibility review** — against WCAG 2.2 (POUR; A/AA/AAA), with legal alignment to ADA (US) and EAA (EU) where applicable.
6. **Iterate** — test → iterate → implement, per NNG's cyclical framing.

Sources underpinning this flow: [Design Thinking 101 — NNG](https://www.nngroup.com/articles/design-thinking/), [Paper Prototyping — NNG](https://www.nngroup.com/articles/paper-prototyping/), [10 Usability Heuristics — NNG](https://www.nngroup.com/articles/ten-usability-heuristics/), [Design Systems 101 — NNG](https://www.nngroup.com/articles/design-systems-101/), [Shopify Polaris](https://polaris-react.shopify.com/), [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/), [ADA Web Guidance — ada.gov](https://www.ada.gov/resources/web-guidance/), [European Accessibility Act — EC](https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/union-equality-strategy-rights-persons-disabilities-2021-2030/european-accessibility-act_en) (all accessed 2026-04-24).

---

## Open questions

- **Direct wireframe definition from NNG.** The article I attempted (`/articles/wireframes/`) returned 404; find the current URL.
- **Material Design 3 and Fluent UI principles.** Primary pages did not yield substantive content in this session; fetch the "foundations" pages with fallback search.
- **EAA application date and penalties.** Need a direct fetch of the full directive or the EC page that details dates (28 June 2025 is widely cited but the EC page I fetched did not include the date — so I am not stating it here without a fetched citation).
- **ISO 9241-210 Human-centred design for interactive systems.** Not fetched in this session; commonly cited alongside NNG material as the ISO process reference.
- **Usability testing methodology.** Moderated vs unmoderated, sample sizes, remote vs in-person — not covered here; candidate primary sources are additional NNG articles.

---

## Sources

- [Design Thinking 101 — Nielsen Norman Group](https://www.nngroup.com/articles/design-thinking/) (accessed 2026-04-24)
- [Paper Prototyping — Nielsen Norman Group](https://www.nngroup.com/articles/paper-prototyping/) (accessed 2026-04-24)
- [10 Usability Heuristics for User Interface Design — Jakob Nielsen, NNG](https://www.nngroup.com/articles/ten-usability-heuristics/) (accessed 2026-04-24)
- [Design Systems 101 — Therese Fessenden, NNG, 2021-04-11](https://www.nngroup.com/articles/design-systems-101/) (accessed 2026-04-24)
- [Shopify Polaris — polaris-react.shopify.com](https://polaris-react.shopify.com/) (accessed 2026-04-24)
- [WCAG 2 Overview — W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/) (accessed 2026-04-24)
- [Introduction to Web Accessibility — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-intro/) (accessed 2026-04-24)
- [ADA Web Guidance — ada.gov](https://www.ada.gov/resources/web-guidance/) (accessed 2026-04-24)
- [European Accessibility Act — European Commission](https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/union-equality-strategy-rights-persons-disabilities-2021-2030/european-accessibility-act_en) (accessed 2026-04-24)
