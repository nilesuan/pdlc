# DIATAXIS.md — Documentation framework

**Authoritative source:** Daniele Procida, "Diátaxis" (diataxis.fr, 2017–present); [`../../../handbook/04-build.md`](../../../handbook/04-build.md) and [`../../../handbook/07-run.md`](../../../handbook/07-run.md).

## The four modes

Documentation serves four distinct user needs. Mixing modes in one document is the most common documentation failure.

```
              | Practical (use)      | Theoretical (acquire)
    --------- | -------------------- | ----------------------
    Acquiring | Tutorial             | Explanation
    skill /   | (learning-oriented)  | (understanding-oriented)
    --------- | -------------------- | ----------------------
    Applying  | How-to guide         | Reference
    skill /   | (task-oriented)      | (information-oriented)
```

| Mode | Reader's question | What it gives | What it does NOT do |
|---|---|---|---|
| **Tutorial** | "Teach me, I'm new" | Step-by-step learning experience | Cover edge cases or alternatives |
| **How-to** | "How do I do X?" | Recipe to accomplish a specific task | Teach concepts |
| **Reference** | "What's the API for Y?" | Complete, accurate, dry list of facts | Explain or persuade |
| **Explanation** | "Why does Z work this way?" | Discussion of context, trade-offs, history | Tell you what to type |

## Hard rules

1. **One document = one mode.** A tutorial that drifts into reference confuses both new readers and lookup readers.
2. **Filename / location signals the mode.** `tutorials/`, `how-to/`, `reference/`, `explanation/`. Or prefixes: `getting-started-...`, `how-to-...`.
3. **Tutorials are "learning by doing."** A working result the reader can run. Short. Single happy path. No "but you could also..." digressions.
4. **How-to guides assume the reader knows the basics.** Goal-oriented; do not re-teach concepts; link to tutorial / explanation if needed.
5. **Reference is generated from source where possible.** Auto-generated API docs from code annotations. Hand-written reference rots.
6. **Explanation is the "why" document.** Trade-offs, decisions, history. Often overlaps with ADRs (see [`ADR.md`](ADR.md)) — ADRs are decision records; explanation is broader narrative.

## Project documentation set (minimum)

A service / project's `docs/` should contain:

```
docs/
  README.md            — short index, links to the four modes
  tutorials/
    getting-started.md — runs in 10 minutes, produces a working result
  how-to/
    deploy.md, debug-X.md, rotate-Y.md, ...
  reference/
    api.md             — generated where possible
    config.md          — every env var / flag, default, range
  explanation/
    architecture.md    — high-level, links to ADRs
    decisions/         — link to ADRs (or symlink to `adr/`)
```

Plus an `adr/` directory at repo root (see [`ADR.md`](ADR.md)).

## Auto-rejection (used by code-reviewer in doc PRs)

| Trigger | Severity |
|---|---|
| New "guide" mixes tutorial + how-to + reference in one file | Major |
| Tutorial with multiple alternative paths ("you could also...") | Major |
| Reference written by hand for content that could be auto-generated | Minor |
| How-to that re-teaches concepts | Minor |
| README pointing to docs that don't exist | Major |
| Doc that hasn't been updated > 12 months and references current behavior | Minor (verify and date it) |

## What "good" looks like for each mode

### Tutorial
- Title: "Getting started with X"
- Result: a runnable artifact (e.g., a working hello-world).
- Length: 5–20 min.
- No discussion of trade-offs.
- Tested in CI where possible (broken tutorial = broken onboarding).

### How-to
- Title: "How to <verb> <noun>" — concrete task.
- Reader has a specific goal in mind.
- Numbered steps where order matters; bullets where it doesn't.
- Includes "if X fails, do Y" branches.
- Linked from runbooks (see [`../operations/ON_CALL.md`](../operations/ON_CALL.md)).

### Reference
- Complete and accurate; no ambiguity.
- Dry, structural, alphabetical / topical.
- Does not say "this is a great way to..." — that's marketing.
- Source of truth for the API surface.

### Explanation
- Title: "Understanding X" / "Why X is the way it is".
- Discursive. Includes history, alternatives considered, current trade-offs.
- Often the entry point for new senior engineers joining the project.
- Links liberally to ADRs and reference docs.

## Anti-patterns to flag

- A README that tries to be all four modes at once. Split it: index + four sections.
- "Living documents" that nobody updates. A doc with a "last updated" 3 years old is misinformation, not documentation.
- "Documentation is in the wiki" — prefer in-repo, in-PR, version-controlled. Wiki for cross-cutting org docs is fine; service docs belong with the service.
- Auto-generated reference that nobody verifies for accuracy. Generation is necessary, not sufficient — test it.

## Sources

- Daniele Procida, *Diátaxis* (diataxis.fr).
- Procida's PyCon talk "What nobody tells you about documentation" (2017).
- *The Documentation System* — original article (later expanded into the Diátaxis website).
