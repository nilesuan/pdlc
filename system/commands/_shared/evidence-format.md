# _shared/evidence-format.md

Evidence format is layer 4 of the six-layer anti-hallucination protocol — see [`../../standards/ANTI_HALLUCINATION.md`](../../standards/ANTI_HALLUCINATION.md).

Reminder: every finding must conform to [`../../standards/EVIDENCE.md`](../../standards/EVIDENCE.md). The full schemas are there. This file lists only the most-violated rules, since they're the ones a command needs to hammer.

## The five most-violated rules

1. **No weasel grounding.** "Industry standard", "typically", "best practice", "most teams" are not sources. The cited source must use the framing you're attributing to it.

2. **Excerpt must be verbatim.** Not paraphrased. Not "essentially". Byte-identical. If you've added formatting, removed a blank line, or changed a quote style, the cross-verifier will downgrade or reject.

3. **`why` cannot restate `claim`.** It must explain how the evidence supports the claim. "Line 42 has a SQL string concat" → claim. "Because it concatenates user-controlled input into the query without parameter binding, an attacker can alter the query" → why.

4. **`location` is `path:line` or `path:line-line`, not vague.** "Around line 40" is not a location. "src/api/users.py:42-58" is.

5. **`retrieved` for URLs is a real date within 90 days.** If you cited a URL last week and re-use the same evidence today, `retrieved` is today only if you actually re-fetched.

When in doubt: file with `confidence: low` and `kind: clarification-needed` rather than inflate.
