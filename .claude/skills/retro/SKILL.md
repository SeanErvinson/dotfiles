---
name: retro
description: Run a retrospective on the current session. Evaluates agent performance, captures feedback, proposes improvements to agent definitions, and tracks changes over time. Run "/retro" at the end of a session.
tools: Read, Write, Edit, Glob, Grep, Agent
---

# Session Retrospective

Goal: evaluate how agents performed this session, capture useful signal, and produce concrete improvements to agent definitions. This is an **interactive** process — the user is the mediator.

## Rules

1. **Read before asking** — check session context, subagent logs, and agent definitions before asking questions
2. **Be specific** — "too verbose" is not useful; "spent 3 paragraphs on missing semicolons" is
3. **One change per observation** — each proposed tweak maps to one finding
4. **Never change agent identity** — tweaks adjust behavior/focus, not core purpose
5. **Always ask before editing** — propose changes, get explicit approval, then apply
6. **Keep it concise** — max 2-3 questions per agent, don't make this a chore

---

## Steps

### 1. Gather Context

Identify which agents were used this session and what they did.

**Check subagent metadata:**

- Glob for subagent metadata files in the current project session directory under `~/.claude/projects/`
- Read each to identify agent names, descriptions, and what tasks they performed

**Load agent definitions:**

- Read the current `.md` files from `/home/asean/dotfiles/.claude/agents/` for each agent that was used

**Load recent retros for trend context:**

- Glob for recent files in `/home/asean/Development/AIWorld/retros/`
- Read the last 3-5 retro records (if they exist) to understand recurring patterns
- Check the relevant agent changelogs in `/home/asean/Development/AIWorld/changelog/`

Present a brief summary of what you found:

```
## Session Context
- **Agents used**: code-reviewer, docs-explorer
- **code-reviewer** was invoked for: [brief description from metadata]
- **docs-explorer** was invoked for: [brief description from metadata]
- **Previous retro trends**: [any recurring issues from recent retros, or "first retro"]
```

### 2. Evaluate Each Agent (Interactive)

For each agent used, ask the user **2-3 targeted questions**. Pre-fill observations from the session where possible so the user doesn't have to recall everything.

```
### code-reviewer

From what I can see, it was used to [task]. Here's what I observed:
- [observation from session context]
- [observation from session context]

**Q1: Effectiveness** — How well did it handle this? (1-5)
**Q2: Gaps** — Did it miss anything or get something wrong?
**Q3: Style** — Was the output format/verbosity appropriate?
```

If an agent was used for something trivial or worked perfectly, don't force evaluation — a quick "anything to note about [agent]?" suffices.

### 3. Write the Retro Record

Based on the user's input, create a retro record at:
`/home/asean/Development/AIWorld/retros/YYYY-MM-DD-<short-slug>.md`

Where `<short-slug>` is 2-3 words describing the session (e.g., `auth-refactor`, `api-perf-tuning`).

Use this format:

```markdown
---
date: YYYY-MM-DD
agents_used: [agent-1, agent-2]
overall_rating: N
tags: [relevant, topic, tags]
---

## Session Summary

Brief description of what was accomplished.

## Agent Evaluations

### agent-name

- **Rating**: N/5
- **Task**: What it was asked to do
- **Worked**: Specific things that went well
- **Gaps**: Specific things missed or wrong
- **Signal**: Actionable takeaway for the agent definition

## Proposed Changes

- [ ] agent-name: Description of proposed change
```

### 4. Propose Agent Definition Changes

For each actionable finding from the evaluation, propose a **specific edit** to the agent's `.md` file. Show the user exactly what would change:

```
## Proposed Changes

### 1. code-reviewer.md
**Finding**: Missed deprecated test patterns
**Edit**: Add to the "Test review" section:
  - Deprecated pattern detection
  - Modern testing idiom suggestions

### 2. code-reviewer.md
**Finding**: Too verbose on obvious violations
**Edit**: Add to the system prompt:
  "Be concise on obvious violations (1 line). Reserve detailed explanations for subtle or non-obvious issues."

Apply change 1? (y/n)
Apply change 2? (y/n)
```

If no changes are warranted (agents performed well), say so explicitly and skip to Step 6.

### 5. Apply Approved Changes

For each change the user approves:

**Edit the agent definition:**

- Use the Edit tool to modify the agent's `.md` file at `/home/asean/dotfiles/.claude/agents/<agent>.md`
- Make surgical edits — don't rewrite the whole file

**Append to the agent's changelog:**

- File: `/home/asean/Development/AIWorld/changelog/<agent>.md`
- Create the file if it doesn't exist yet
- Append an entry in this format:

```markdown
### YYYY-MM-DD

- **Change**: What was changed
- **Rationale**: Why (from the retro finding)
- **Retro**: retros/YYYY-MM-DD-<slug>.md
```

### 6. Wrap Up

```
Retrospective complete.
- Recorded: retros/YYYY-MM-DD-<slug>.md
- Changes applied: N edits to M agent(s)

Want to:
A) Review the full retro record
B) See agent changelogs
C) Done
```

---

## Edge Cases

- **No agents were used this session**: Tell the user, offer to do a general agent review instead (re-read definitions and look for improvements based on accumulated retro history).
- **User wants to evaluate an agent not used this session**: Allow it — they may have observations from recent sessions they haven't captured yet.
- **First retro ever**: Skip the trend context step. Mention this is the first record and that trends will emerge after a few retros.
- **User disagrees with a proposed change**: Drop it. Don't push back. Record the user's reasoning in the retro record under a "Rejected" section so future retros have that context.
