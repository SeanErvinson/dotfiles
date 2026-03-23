---
name: plan
description: Use when the user wants to plan a feature, design a system, or think through an approach. Triggered by "/plan", "let's plan", "help me plan", "think through", "let's go through it together", or "brainstorm". Runs an interactive planning session explores the codebase, identifies unknowns, asks clarifying questions, and reaches shared agreement before implementation.
tools: Read, Glob, Grep, Bash, Agent
---

# Interactive Planning Session

Goal: reach **shared understanding and explicit agreement** before implementation. Do NOT write code or make file changes.

## Rules

1. **Explore before asking** — if the codebase can answer it, look it up first
2. **Max 3-4 questions per round** — group by theme, use multiple choice when options are clear
3. **Visualize to align** — use Mermaid diagrams when necessary to make the plan concrete
4. **Gate on agreement** — don't conclude until the user confirms

---

## Steps

### 1. Understand

Parse `$ARGUMENTS`: what is being built, why, and any stated constraints.

### 2. Explore

Search the codebase for relevant context before asking anything:

- Existing similar features or patterns
- Affected data models, endpoints, or UI screens
- Relevant auth/permission patterns
- Test conventions to follow

### 3. Identify Unknowns

Categorize what's unclear: **Technical** | **UX/Design** | **Scope** | **Order**

### 4. Present & Ask

**Show what you found:**

```
## What I found
- Existing pattern: ...
- Affected areas: ...
```

**Visualize with Mermaid** (pick what fits):

- Entities → `erDiagram`
- User flow → `sequenceDiagram`
- Architecture → `graph TD`
- States → `stateDiagram-v2`

**Ask questions** — multiple choice when options are enumerable:

```
**Q**: How should we handle X?
A) Option A — [implication]
B) Option B — [implication]
C) Something else?
```

### 5. Iterate

Incorporate answers → update diagrams → ask follow-ups only if truly needed.

### 6. Present Final Plan & Confirm

```
## Plan: [Name]
**Summary**: ...
**In scope**: ...
**Out of scope**: ...
**Approach**: ...
**Affected areas**: [table]
**Key decisions**: ...
**Implementation order**: 1. ... 2. ... 3. ...
```

> Does this match your intent? Any changes before we proceed?

Don't move forward until the user approves.

### 7. Hand Off

Once confirmed:

```
Plan approved. Next:
A) Start implementation now
B) Enter Plan mode for detailed task breakdown
C) Save as reference doc
D) Just the plan for now
```
