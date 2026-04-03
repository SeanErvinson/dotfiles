---
name: spike
description: Build a time-boxed throwaway prototype in an isolated worktree to reduce uncertainty before building the real thing. Triggered by "/spike", "spike this", "prototype first", or "build to learn". The output is learnings, not production code.
tools: Agent, Read, Write, Edit, Glob, Grep, Bash, EnterWorktree, ExitWorktree, AskUserQuestion
---

# Spike — Build to Learn

Goal: build a **scrappy, throwaway prototype** to surface unknowns, foot guns, and codebase gaps — then report what you learned so the real implementation can be built right.

## Input

`$ARGUMENTS` — a feature description, bug report, design brief, or problem statement to spike on.

## Rules

1. **Build fast, not well** — this code gets thrown away. No tests, no polish, no edge case handling
2. **The output is the learnings, not the code** — the prototype exists to teach, not to ship
3. **Always use a worktree** — spike code never touches the main branch
4. **Keep exploration short** — the prototype itself is the exploration. Don't over-research before building
5. **Scope ruthlessly** — build the smallest slice that answers the key unknowns

---

## Steps

### 1. Parse the Request

Extract from `$ARGUMENTS`:

- **What** is being built
- **Why** — what problem it solves or what question it answers
- **Key unknowns** — what we don't know yet that building will reveal

### 2. Quick Explore

Launch **1-2 Explorer agents** to find just enough context to start building:

- Existing patterns, types, and entry points relevant to the feature
- How similar things are wired up in this codebase

Spend minutes here, not hours. The prototype is the real exploration.

### 3. Scope the Spike

Present the user with a tight scope — **3-5 bullet points max**:

```
## Spike scope
Building the minimum to learn:
- [ ] ...
- [ ] ...
- [ ] ...

**Not doing**: tests, error handling, edge cases, polish

Does this scope target the right unknowns?
```

Wait for user confirmation before building.

### 4. Build in Worktree

1. **Enter a worktree** using `EnterWorktree` with name `spike/<short-descriptor>`
2. **Build the prototype** — write code fast and loose:
    - Get something working end-to-end over getting anything perfect
    - Hardcode what you'd normally parameterize
    - Skip validation, skip auth, skip error handling
    - Leave `TODO` markers when you hit something that would be hard in the real build
3. **Try to run it** — verify it at least compiles/starts. Fix obvious crashes but don't debug deeply

### 5. Document Learnings

After building, produce a structured debrief:

```
## Spike Debrief: [Feature Name]

### What worked easily
- ...

### Harder than expected
- ...

### Codebase gaps discovered
- ...

### Key decisions for the real build
- ...

### Recommended approach
[How to build this for real, informed by what the spike revealed]
```

### 6. Hand Off

```
Spike complete. The throwaway code is on branch `spike/<name>` for reference.

Next:
A) Plan the real implementation (informed by these learnings)
B) Keep the worktree around for reference
C) Clean up — remove the worktree and spike branch
```

On choice A: exit worktree (keep), then kick off `/plan` with the debrief as context.
On choice B: exit worktree (keep).
On choice C: exit worktree (remove).
