# Claude Code Guidelines

## Git Commits

Prefix required: `feature:`, `fix:`, `refactor:`, `chore:`, `docs:`, `test:`. Present tense, lowercase after prefix. Concise single-line summary.

Example: `feature: add list and get endpoints`

## General

- Don't refactor code I didn't ask you to change.
- Don't add comments unless the logic is non-obvious.
- Minimize visibility/scope by default (private, internal, etc.).
- Never mutate objects passed as parameters — return new results instead.
- Entities/models own their state — no anemic models.
