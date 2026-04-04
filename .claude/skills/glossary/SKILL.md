---
name: glossary
description: Update GLOSSARY.md to reflect the shared domain ontology. Scans the full codebase — entities, enums, handlers, strategies, services — to identify domain concepts and ensure the glossary captures their meaning, relationships, and deliberate terminology choices.
tools: Read, Edit, Glob, Grep
---

# Glossary Update

Goal: keep `GLOSSARY.md` as the authoritative shared ontology of the application — the place where the team aligns on what concepts mean, why specific terms were chosen, and how concepts relate to each other.

The glossary is not an entity catalog. It captures domain language wherever it lives: entities, enums, strategies, handler names, service boundaries, and naming conventions.

## Input

`$ARGUMENTS` — optional. Specific terms or concepts to update (e.g., "AllocationGroup", "split vs allocation"). If empty, scan the codebase broadly and diff against the glossary.

## Steps

### 1. Read Current Glossary

Read `GLOSSARY.md` at the repo root. Understand:

- What terms are already defined
- The tone, format, and level of detail used
- How entries relate to each other (grouping, cross-references)

### 2. Scan the Codebase for Domain Concepts

Domain language lives everywhere, not just in entity files. Check `CLAUDE.md` for project structure guidance, then scan:

- **Entities/models** — the core persisted concepts
- **Enums** — named categories, statuses, and strategies that carry domain meaning
- **Handlers/endpoints** — action names often reveal domain verbs and workflows
- **Services/strategies** — named patterns that encode business rules
- **Constants and naming conventions** — terms the team has standardized on

Look for concepts that have distinct names, relationships, or behaviors worth defining.

### 3. Identify Gaps

Compare what you found against the glossary:

- **New concepts** — terms that appear in the code but aren't in the glossary
- **Stale entries** — glossary descriptions that no longer match how the concept is used (relationships changed, meaning shifted, concept was restructured)
- **Removed concepts** — terms still in the glossary but no longer in the codebase
- **Missing distinctions** — related terms that could be confused (e.g., two concepts with similar names but different meanings). If the glossary doesn't clarify the distinction, it should.

If `$ARGUMENTS` was provided, focus on those terms but also check related concepts that may need updating as a result.

### 4. Draft Updates

For each gap, draft a glossary entry following the existing style:

- **Bold term** followed by `--` and a domain-level definition
- Describe what it _means_ in the domain, not how it's implemented
- Note relationships to other concepts in plain language
- Where relevant, note terminology choices: why this word and not a synonym
- Keep entries concise (2-4 sentences max)

### 5. Apply Changes

Use the Edit tool to update `GLOSSARY.md`:

- Add new entries near related terms
- Update stale entries in place
- Remove entries for concepts that no longer exist

### 6. Summary

Report what was added, updated, or removed — and flag any terms where you weren't confident about the domain meaning so the team can refine them.

## Rules

- The glossary defines domain language, not implementation details. No framework internals, column types, or language-specific types.
- A concept doesn't need to be a persisted entity to deserve a glossary entry. Strategies, statuses, workflows, and domain verbs matter too.
- When two terms could be confused, the glossary should explicitly disambiguate them.
- Match the existing tone and format exactly.
- When a concept sits between others in a hierarchy, mention both parent and child relationships.
