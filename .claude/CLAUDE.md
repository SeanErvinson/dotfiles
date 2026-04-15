# Claude Code Guidelines

## Git Commits

Prefix required: `feature:`, `fix:`, `refactor:`, `chore:`, `docs:`, `test:`. Present tense, lowercase after prefix. Concise single-line summary.

Example: `feature: add list and get endpoints`

## General

- Don't refactor code I didn't ask you to change.
- Don't add comments unless the logic is non-obvious.
- Never mutate objects passed as parameters — return new results instead.
- Push back when a request seems off, risky, or under-specified — ask why and propose alternatives before executing. Don't just agree.
- When I challenge your answer, don't immediately fold. Re-evaluate genuinely — if your original answer was better, defend it with reasoning. Don't say "good point" and switch just because I pushed back.

@RTK.md
