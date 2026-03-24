---
name: explore
description: Explore an area of the codebase to understand its behaviors, capabilities, and shape. Spins up multiple Explorer agents in parallel to investigate, and pulls external docs only when codebase exploration isn't sufficient.
tools: Agent, Read, Glob, Grep
---

# Codebase Exploration

Goal: give the user a clear mental model of the area they're asking about — its **behaviors**, **capabilities**, **boundaries**, and **shape**.

## Input

`$ARGUMENTS` — the area, feature, or concept to explore (e.g. "expense allocations", "auth middleware", "how payments settle").

## Rules

1. **Do NOT write code or make file changes** — this is a read-only exploration
2. **Prefer codebase over external docs** — only fetch docs when the area involves libraries/frameworks and the codebase alone can't answer the question
3. **Parallelize aggressively** — launch multiple Explorer agents simultaneously to cover different angles
4. **Be concrete** — reference specific files, functions, and line numbers in your findings

---

## Steps

### 1. Parse the Question

Break `$ARGUMENTS` into:

- **Target area**: what part of the codebase to investigate
- **Likely angles**: entry points, data flow, side effects, configuration, error handling, integrations
- **External dependencies**: any libraries/frameworks that may need doc lookups

### 2. Launch Parallel Exploration

Spin up **2-4 Explorer agents** simultaneously, each with a distinct angle. Example splits:

- **Agent A — Structure & entry points**: find the key files, types, endpoints, and how they're wired together
- **Agent B — Data flow & behavior**: trace the core operations — what gets created, mutated, queried, deleted
- **Agent C — Boundaries & integrations**: how this area connects to other features, external services, or middleware
- **Agent D — Edge cases & configuration**: error handling, validation, feature flags, configuration options

Tailor the agents to the specific area. Not every exploration needs all four angles — use your judgment, but always launch at least 2.

Set thoroughness based on scope:

- Narrow question (single feature/handler) → "medium"
- Broad area (whole feature domain) → "very thorough"

### 3. Fetch External Docs (only if needed)

If the exploration reveals the area depends on a library/framework and understanding the codebase requires understanding that dependency:

- Launch a **docs-explorer** agent to fetch relevant documentation
- Be specific about what you need — not "tell me about EF Core" but "EF Core filtered indexes with `HasFilter()`"

**Skip this step entirely** if the codebase answers the question on its own.

### 4. Synthesize

Combine all agent results into a structured summary:

```
## [Area Name]

### What it does
[Core behaviors and capabilities — what this area is responsible for]

### How it's shaped
[Key files, types, and their relationships — the structural layout]

### How it flows
[Entry point → processing → side effects → output. Trace the main paths]

### Boundaries
[What it touches, what it doesn't. Integrations with other areas]

### Notable details
[Edge cases, configuration, non-obvious behavior, constraints]
```

Use **Mermaid diagrams** when relationships or flows are complex enough to benefit from visualization.

### 5. Offer Next Steps

After presenting findings, offer:

```
Want me to:
A) Dive deeper into a specific part
B) Plan changes to this area
C) That's all I needed
```
