---
name: team
description: Create and coordinate an agent team for complex tasks. Use when work benefits from multiple specialized agents working in parallel. Supports explicit roles ("/team code-reviewer, docs-explorer: review auth") or auto-inference ("/team investigate the payment bug").
---

# Agent Team Orchestrator

Goal: assemble and coordinate a team of specialized agents to tackle a complex task, ensuring thorough context-gathering before any work begins.

## Input

`$ARGUMENTS` — either `role1, role2: task description` (explicit roles) or just `task description` (auto-infer).

## Rules

1. **Gather context before spawning** — use the ask-me interrogation pattern to reach shared understanding of the problem before creating any team
2. **Max 4 teammates** — prefer fewer, well-targeted agents over many unfocused ones
3. **Confirm auto-inferred teams** — when roles are not explicitly provided, present the proposed team composition and get user approval before spawning
4. **Skip confirmation for explicit roles** — if the user named their agents, trust their intent
5. **Recommend missing agents** — if a task needs a specialist that doesn't exist in `~/.claude/agents/`, suggest creating one (with name, description, purpose) and offer to proceed with available agents or wait
6. **Always clean up** — shutdown all teammates and call `TeamDelete` when done
7. **Respect agent capabilities** — don't assign file-editing tasks to read-only agents (Explore, Plan)

---

## Steps

### 1. Parse Arguments

Examine `$ARGUMENTS` to determine the mode:

**Explicit roles** — if a colon `:` appears and the text before it is a comma-separated list where each trimmed token matches either:

- A custom agent name from `~/.claude/agents/` (e.g., `code-reviewer`, `docs-explorer`)
- A built-in type: `explore`, `plan`, `general-purpose`

Then extract roles and the task description after the colon.

**Auto-infer** — if no colon is present, or the text before the colon doesn't match known agent names, treat the entire input as the task description.

### 2. Gather Context (Ask-Me Pattern)

Before doing anything else, interrogate the user about the task to reach shared understanding:

- **Scope**: What exactly needs to be done? What's in scope and out of scope?
- **Outcome**: What does success look like? What deliverables are expected?
- **Constraints**: Are there time constraints, quality bars, or areas to avoid?
- **Codebase**: Which parts of the codebase are involved? Any known entry points?
- **Dependencies**: Are there related ongoing efforts, blocked work, or external dependencies?

Explore the codebase yourself to answer questions where possible — only ask the user what you can't determine from the code. Traverse each branch of the decision tree, resolving contradictions or ambiguities one by one. Continue this phase until you and the user have a clear, shared understanding of the problem.

### 3. Discover Available Agents

Read all files in `~/.claude/agents/*.md` to build a registry:

For each agent, extract from frontmatter:

- `name` — agent identifier
- `description` — what it does and when to use it
- `tools` — available tools (determines read-only vs full capability)
- `model` — which model it uses

Also note the built-in agent types always available:

- **Explore** — read-only codebase exploration (tools: Read, Glob, Grep)
- **Plan** — read-only architecture and design planning
- **general-purpose** — full capability agent with all tools

### 4. Select Agents

**If explicit roles were parsed:**

- Validate each role exists (custom agent or built-in type)
- If a named agent doesn't exist, tell the user and suggest the closest match or offer to proceed without it

**If auto-inferring:**

Match the task description against available agents using these signals:

| Task signal                                            | Agent                      |
| ------------------------------------------------------ | -------------------------- |
| review, code quality, PR, security, vulnerability      | code-reviewer              |
| docs, documentation, API reference, library, framework | docs-explorer              |
| SQL, query, database, schema, migration, index         | sql-pro                    |
| UI, UX, design, component, layout, styling, dark mode  | uiux-reviewer              |
| explore, understand, "how does X work", investigate    | Explore (built-in)         |
| plan, design, architect, system design                 | Plan (built-in)            |
| implement, build, fix, refactor, coding tasks          | general-purpose (built-in) |

Also read descriptions of all discovered custom agents — they may match on signals not in this table.

**Gap detection**: If the task clearly needs a specialist that doesn't exist (e.g., a performance-testing agent, a DevOps agent), recommend creating one:

```
I think this task would benefit from a **[suggested-name]** agent:
- **Purpose**: [what it would do]
- **Description**: [suggested description]
- **Tools**: [suggested tool set]

Want me to create this agent, or should we proceed with the available team?
```

**Present the proposed team** to the user for confirmation:

```
Proposed team for "[task summary]":
1. **[agent-name]** — [what they'll do on this task]
2. **[agent-name]** — [what they'll do on this task]
...

Proceed with this team?
```

### 5. Create Team

Call `TeamCreate` with a descriptive team name derived from the task (slugified, e.g., `review-auth-module`, `investigate-payment-bug`).

### 6. Decompose Task

Break the task into 2-5 concrete subtasks. Each subtask should have:

- A clear, imperative subject line
- A description with specific scope and acceptance criteria
- An assigned agent role

Set up `blockedBy` dependencies where sequential ordering matters (e.g., exploration must complete before implementation).

### 7. Create Tasks and Spawn Teammates

For each subtask:

1. Call `TaskCreate` with subject, description, and dependency info
2. Spawn the assigned agent via `Agent` with:
    - `team_name` — the team name from step 5
    - `name` — human-readable identifier (e.g., `reviewer`, `explorer`, `implementer`)
    - `subagent_type` — the agent definition name or built-in type
    - A detailed prompt describing their assignment, the team context, and what other teammates are working on
3. Call `TaskUpdate` to assign the task to the spawned teammate

### 8. Coordinate

As team lead:

- Messages from teammates arrive automatically — respond to questions, provide clarifications
- Monitor task progress via `TaskList` and `TaskGet`
- Unblock work by updating task dependencies when prerequisites complete
- Create follow-up tasks with `TaskCreate` if new work is discovered
- Reassign tasks if a teammate is stuck or a different agent would be better suited

### 9. Synthesize Results

Once all tasks are completed, gather results from teammate messages and produce a unified summary:

```
## Team Results: [Task Summary]

### Team Composition
- **[agent-name]** — [what they did]
- **[agent-name]** — [what they did]

### Findings / Deliverables
[organized by subtask or theme — include specific files, line numbers, and code references]

### Key Decisions / Recommendations
[actionable items with rationale]

### Open Questions
[anything unresolved that needs follow-up]
```

Use **Mermaid diagrams** when relationships or flows are complex enough to benefit from visualization.

### 10. Cleanup

1. Send shutdown requests to all teammates via `SendMessage`
2. Wait for confirmations
3. Call `TeamDelete` to remove the team and task directories

If cleanup fails (e.g., a teammate is unresponsive), inform the user and suggest manual cleanup steps.
