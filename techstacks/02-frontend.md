---
name: frontend stack
description: Industry-standard frontend web stacks — frameworks, meta-frameworks, build tools, styling, and language choice
type: research
---

# Frontend (web)

**Question:** What are the current industry-standard choices for building web frontends in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Browser-rendered web apps. Desktop (Electron, Tauri) and hybrid-mobile are referenced but not centered.

## Shape of the decision

A modern frontend stack is not a single choice but a stack of six co-decided layers:

1. **Language** — TypeScript is now the default for production frontend work (evidence below).
2. **Core UI framework** — React, Vue, Angular, Svelte, Solid, etc.
3. **Meta-framework** — Next.js, Nuxt, SvelteKit, Astro, Remix/React Router, etc. These bundle routing, SSR/SSG, data fetching.
4. **Build tool / bundler** — Vite is dominant for new projects; Webpack legacy; esbuild/SWC/Turbopack underneath.
5. **Styling** — Tailwind CSS dominant; CSS Modules strong; CSS-in-JS declining.
6. **Component library** — Material UI, Ant Design, shadcn/ui, Radix UI, Chakra UI, etc.

Each layer has its own evidence. The rest of this document goes through them in order.

## 1. Language: TypeScript

TypeScript has become the default language for professional frontend work.

- **Usage growth:** JetBrains DevEco reports TypeScript adoption rose from 12% in 2017 to 35% in 2024 [[JetBrains DevEco 2024](https://www.jetbrains.com/lp/devecosystem-2024/)] (accessed 2026-04-24).
- **Stack Overflow 2024 placed TypeScript at 38.5% of respondents** [[SO 2024](https://survey.stackoverflow.co/2024/technology)], and rising through 2025.
- **GitHub Octoverse 2024** lists TypeScript in the top three most-used languages on GitHub and among the fastest-growing [[Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)].

Why TypeScript became standard [SYNTHESIS from the above data and public project positioning]: the major meta-frameworks (Next.js, Nuxt, SvelteKit, Remix, Astro) all ship TypeScript-first scaffolding; Vue 3 was rewritten in TypeScript; Angular has always been TS-first. Developers joining new projects overwhelmingly encounter TypeScript as the assumed default.

## 2. Core UI framework

Data from State of JS 2024 (12,964 respondents) and Stack Overflow 2024/2025 agree on the ordering of mainstream UI libraries:

### React — clear leader

- Stack Overflow 2024: React was the #2 web framework/technology at 39.5%; Stack Overflow 2025: 44.7% [[SO 2024](https://survey.stackoverflow.co/2024/technology), [SO 2025](https://survey.stackoverflow.co/2025/technology/)].
- State of JS 2024: React had 8,548 respondents using it at work — by far the largest count [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)].
- Net effect: React is the default choice by a wide margin for new professional projects; hiring market depth reinforces the lead.

React's role has shifted with **React Server Components** (RSC), which are server-rendered React components that "never send JavaScript to the browser" per the Next.js docs [[Next.js — Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components)] (citation is descriptive and links to framework docs; "only framework with full production-ready support" claim is from secondary sources and marked [CONTESTED] — competitors Waku, Remix, and other RSC-supporting frameworks exist).

### Vue — solid second

- State of JS 2024: Vue had 3,976 at-work respondents [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)].
- Stack Overflow lists Vue as a popular framework; its relative strength is in Asia and Europe [SYNTHESIS — the regional strength is widely reported in State of JS, though I did not fetch the regional breakdown page directly].

### Angular — enterprise-concentrated third

- State of JS 2024: Angular had 3,642 at-work respondents [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)].
- State of JS 2024 framing: Vue.js has "continued to overtake Angular and hold on to its position as the second most used framework" [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)] (accessed 2026-04-24) [VERIFIED].
- Angular remains dominant in large-enterprise contexts (originally sponsored by Google, TypeScript-first from day one).

### Svelte — smaller but very high satisfaction

- State of JS 2024: 1,409 at-work respondents — much smaller user base than React/Vue [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)].
- State of JS 2024: Svelte "continues to top the rankings in terms of overall positive opinions" [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)] (accessed 2026-04-24) [VERIFIED].

### Solid, Lit, Qwik, Preact, Alpine.js, HTMX, Web Components / Stencil

- State of JS 2024 at-work counts: Lit 557, Preact 490, Alpine.js 389, Solid 345, HTMX 316, Stencil 235, Qwik 130 [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)] (accessed 2026-04-24) [VERIFIED].
- Structurally: these are minority choices with high enthusiasm in specific niches. HTMX specifically argues against the SPA model and is closer to an HTML-extension library than a framework (noted as such in the State of JS 2024 commentary).
- Large companies lean toward Lit and Web Components (standards-based, long-lived); small companies lean toward Alpine, Qwik, Solid [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)].

### Summary

React is the default. Vue is the credible second. Angular holds enterprise. Svelte is the critically acclaimed small-user-base contender. Everything else is niche. [SYNTHESIS from Stack Overflow, State of JS, and Octoverse evidence above.]

## 3. Meta-framework

Modern frontend projects are usually started from a meta-framework rather than a bare UI library. The meta-framework provides routing, SSR/SSG, server-side rendering, data fetching, and deployment conventions.

State of JS 2024 meta-frameworks section had 12,044 respondents to its happiness question. Top usage:

- **Next.js — clear leader**: 5,147 at-work respondents, by a wide margin [[State of JS 2024 Meta-Frameworks](https://2024.stateofjs.com/en-US/libraries/meta-frameworks/)] (accessed 2026-04-24) [VERIFIED].
- Stack Overflow 2024 ranks Next.js #4 web framework/technology at 17.9%; 2025: 20.8% [[SO 2024](https://survey.stackoverflow.co/2024/technology), [SO 2025](https://survey.stackoverflow.co/2025/technology/)] [VERIFIED].

### Next.js

Next.js is the dominant React meta-framework. State of JS 2024 frames retention as declining (positive sentiment has softened "as alternatives like Remix, SvelteKit, and Astro have become more mainstream") [[State of JS 2024 Meta-Frameworks](https://2024.stateofjs.com/en-US/libraries/meta-frameworks/)] — note this is narrative from the State of JS commentary; I was unable to extract the specific retention percentage from the rendered page. [CONTESTED / incomplete.]

### Nuxt

Vue's meta-framework. State of JS 2024 positions Nuxt as the main Vue meta-framework — counts not extracted. Widely used in Vue shops.

### SvelteKit

Svelte's meta-framework. State of JS 2024: ranked high in satisfaction; Svelte's usage "is increasing at a steady pace" [[State of JS 2024 Front-end](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)] [VERIFIED].

### Astro

Content-heavy sites and marketing pages — "islands architecture." State of JS 2024 ranked Astro "#1 in interest, retention, and positivity" [[State of JS 2024 Meta-Frameworks](https://2024.stateofjs.com/en-US/libraries/meta-frameworks/) — I was unable to extract exact interest/retention numbers, but the ranking claim appears in multiple secondary summaries and is consistent with Astro's high satisfaction ratings observed across the survey. [SYNTHESIS]

### Remix → React Router v7

The Remix team announced the merger in a blog post dated **14 May 2024**: "Remix has always just been a layer on top of React Router — and that layer has been shrinking over time." The post directs that "Remix users should keep using Remix and switch to React Router v7 when it's released by just changing the imports." React Router v7 was released in December 2024, effectively folding Remix's server capabilities (loaders, actions, SSR, data fetching) into the React Router library itself [[Remix blog — Merging Remix and React Router, 14 May 2024](https://remix.run/blog/merging-remix-and-react-router)] (accessed 2026-04-24) [VERIFIED].

### Gatsby

Once dominant for JAMstack/static React sites; clearly in decline. In State of JS 2024 respondent counts, Gatsby is well below Next.js and Astro. Netlify acquired Gatsby in 2023 [UNVERIFIED in this session].

## 4. Build tools and bundlers

### Vite — dominant for new projects

Vite has become the de facto default for new frontend builds because the major meta-frameworks (SvelteKit, Nuxt 3, Astro, Remix/React Router v7 where applicable) use Vite as their underlying build tool [UNVERIFIED — this is structurally true from each project's documentation but I did not fetch those docs in this session]. Vite's advantages are ES-modules-native dev mode (no pre-bundling cost), Rollup-based production builds, and a plugin ecosystem that mirrors Rollup's.

### Webpack — legacy but still heavily used

Webpack was the dominant bundler of the 2015–2022 era and remains embedded in Next.js through the App Router transition [UNVERIFIED; Next.js is migrating to Turbopack].

### Turbopack

Vercel's Rust-based bundler, built to replace Webpack in Next.js. Continues in active development [UNVERIFIED status in production per 2026 — check Next.js release notes].

### esbuild and SWC

Both are low-level tooling used underneath higher-level bundlers — esbuild (Go) for bundling; SWC (Rust) for transpilation. They are not typically used standalone for application bundling.

### Summary

The 2026 pattern: most new frontend projects use a meta-framework (Next.js, Nuxt, SvelteKit, Astro) and inherit its bundler choice. Vite is the most common underlying bundler across non-Next.js meta-frameworks. [SYNTHESIS from the meta-framework evidence above.]

## 5. Styling

State of CSS 2024 data on tools (≈9,700 total respondents, ~50% answered the frameworks question) [[State of CSS 2024 Tools](https://2024.stateofcss.com/en-US/tools/)] (accessed 2026-04-24) [VERIFIED]:

### CSS frameworks (4,890 respondents to this question)

- **Tailwind CSS — 3,657 responses** — largest by far
- Bootstrap — 2,623
- Ant Design — 646
- Materialize CSS — 614
- Bulma — 446
- Foundation — 362
- UnoCSS — 272

Tailwind CSS is clearly the dominant utility-first CSS framework; Bootstrap remains in heavy use especially in admin / enterprise UI. [VERIFIED from the above counts.]

### CSS-in-JS and related (3,458 respondents)

- CSS Modules — 2,113
- styled-components — 2,043
- Emotion — 876
- Styled JSX — 675

CSS-in-JS is in a slow decline in the React ecosystem (State of CSS commentary, broader community signals) — the classic runtime-CSS-in-JS model is considered incompatible with React Server Components [SYNTHESIS — the RSC incompatibility is well-documented by the styled-components maintainers' announcements but I did not fetch them directly in this session].

### Pre/post-processors (6,897 respondents)

- Sass/SCSS — 4,652 — still leading
- PostCSS — 2,622

### Component libraries

Not directly extracted from State of CSS 2024 in this session. Widely used options:
- **Material UI (MUI)** — React, Google Material Design ecosystem [UNVERIFIED usage stats]
- **Ant Design** — React, enterprise-oriented, strong in China [partially verified via State of CSS count above]
- **Chakra UI** — React [UNVERIFIED]
- **shadcn/ui + Radix UI** — unstyled primitives + copy-paste components model; widely discussed in 2024–2026 as rising fast [UNVERIFIED stats in this session; usage anecdotal]
- **Headless UI / Ark UI** — unstyled primitives [UNVERIFIED]

## 6. State management

Not directly extracted in this session. Commonly cited: Redux/Redux Toolkit, Zustand, Jotai, Recoil (deprecated), Pinia (Vue), Svelte stores, TanStack Query (for server state). [UNVERIFIED in this session — State of JS 2024 does have a data-management section; should be re-fetched and quantified.]

## Putting the stack together

The most common "hello world on a greenfield in 2026" stack, inferred by cross-referencing Stack Overflow, State of JS, and State of CSS adoption rankings:

- Language: TypeScript
- UI framework: React
- Meta-framework: Next.js
- Bundler: Next.js internal (Webpack transitioning to Turbopack) — or Vite if not using Next.js
- Styling: Tailwind CSS
- Components: shadcn/ui (Radix primitives) — [UNVERIFIED as dominant, but heavily discussed]
- Server state: TanStack Query — [UNVERIFIED]
- Client state: Zustand / Redux Toolkit — [UNVERIFIED]

This is the default, not the best choice for every case. Vue shops pick Nuxt; content-heavy sites pick Astro; teams wanting end-to-end type safety often pick SvelteKit; enterprise shops stay on Angular.

## What is NOT industry-standard, to flag explicitly

- **Classic runtime CSS-in-JS (styled-components as the default)** — fading due to RSC incompatibility and performance concerns; CSS Modules + Tailwind are eating its share [SYNTHESIS from State of CSS counts].
- **jQuery** — still reported by 21.4% in SO 2024 and 23.4% in SO 2025 but overwhelmingly on legacy sites; not a choice for greenfield work [VERIFIED from SO counts; the "legacy" interpretation is SYNTHESIS].
- **Create React App (CRA)** — officially deprecated by the React team on **14 February 2025**. The React blog states: "Today, we're deprecating Create React App for new apps, and encouraging existing apps to migrate to a framework, or to migrate to a build tool like Vite, Parcel, or RSBuild." Recommended frameworks: Next.js, React Router, Expo [[React blog — Sunsetting Create React App, 14 Feb 2025](https://react.dev/blog/2025/02/14/sunsetting-create-react-app)] (accessed 2026-04-24) [VERIFIED].
- **Bower, Gulp, Grunt, Bootstrap as default JS framework** — all superseded.

## Sources (accessed 2026-04-24)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [State of JavaScript 2024 — Front-end Frameworks](https://2024.stateofjs.com/en-US/libraries/front-end-frameworks/)
- [State of JavaScript 2024 — Meta-Frameworks](https://2024.stateofjs.com/en-US/libraries/meta-frameworks/)
- [State of CSS 2024 — Tools](https://2024.stateofcss.com/en-US/tools/)
- [Next.js — Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components)
- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
- [JetBrains State of Developer Ecosystem 2024](https://www.jetbrains.com/lp/devecosystem-2024/)
- [React blog — Sunsetting Create React App, 14 Feb 2025](https://react.dev/blog/2025/02/14/sunsetting-create-react-app)
- [Remix blog — Merging Remix and React Router, 14 May 2024](https://remix.run/blog/merging-remix-and-react-router)

## Open questions

- **Exact State of JS 2024 retention/interest percentages** for each framework and meta-framework. The rendered data is in interactive charts that I could not extract as numeric ratios in this session; counts of at-work respondents were extractable but not the percent-retention figures.
- **Next.js Turbopack production readiness status** as of April 2026 — needs Next.js 15.x/16.x release notes fetched.
- **shadcn/ui adoption data** — no survey number located; its model (copy-paste rather than npm install) is hard to measure.
- **State management usage share** — not extracted.
