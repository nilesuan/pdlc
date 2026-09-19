---
id: LESSON-0032
date: 2026-09-19
trigger: user-correction
phases: [01, 02]
keywords: [writeup, deliverable, scope, ambiguous-referent, local-project, general-request, playbook, LLMOps]
related-rules: [CLAUDE.md]
status: active
---

**Provenance.** Interactive session in `~/.claude`, 2026-09-19. The conversation was about the general workflow for building AI products. The user then asked whether their own PDF-extraction approach was right, and in the same message asked to "Create the full writeup into ~/Desktop/". Mid-task the user corrected: "I want the full new LLMOps plan not my own pdf-extract plan."

## What went wrong

One message contained two asks: a yes/no question about a specific local project, and a request for a deliverable whose subject was not stated ("the full writeup"). The deliverable was scoped to the local project. About ten reads of that project's ADRs, plans and findings happened before the correction, and the writeup was being planned around its open decisions instead of the general workflow the conversation was about.

## Why it happened (root cause)

The unstated subject was resolved to the nearest noun, the project, and the project's detailed documentation pulled the work further toward it. No step asked which of the two asks the deliverable belonged to before effort was committed. What caught the error was a status line naming the project as the thing being read.

## How to prevent it (the rule)

**When a message pairs a question about a specific local project with a request for a deliverable whose subject is unstated, scope the deliverable to the conversation's main topic, answer the project question briefly in the reply, and include project-specific material only if the user names it.**

## Verification

- The first status line of a deliverable task names the deliverable's subject, so a wrong scope is visible before the work is done.
- The category that should fall to zero: deliverables rescoped mid-task because they were built around a local project the user did not name as the subject.
