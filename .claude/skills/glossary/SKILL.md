---
name: glossary
description: Update the domain glossary to reflect the shared ontology. Scans the codebase — entities, enums, handlers, strategies, services — to capture domain concepts, their meaning, relationships, and deliberate terminology choices (with opinionated _Avoid_ lists). Supports a single root GLOSSARY.md or per-domain glossary files mapped from GLOSSARY-MAP.md.
tools: Read, Edit, Glob, Grep
---

# Glossary Update

Goal: keep the glossary as the authoritative shared ontology of the application — the place where the team aligns on what concepts mean, why specific terms were chosen (and which synonyms to avoid), and how concepts relate to each other.

The glossary is not an entity catalog. It captures domain language wherever it lives: entities, enums, strategies, handler names, service boundaries, and naming conventions.

## Input

`$ARGUMENTS` — optional. Specific terms or concepts to update (e.g., "AllocationGroup", "split vs allocation"). If empty, scan the codebase broadly and diff against the glossary.

## Layout: single file vs per-domain

Detect which layout applies before doing anything else:

- If **`GLOSSARY-MAP.md` exists** at the repo root → multi-domain. Read the map to find each domain's `GLOSSARY.md`, then work in the relevant per-domain file(s).
- Else if **only a root `GLOSSARY.md` exists** → single context. Work in that file.
- Else (**neither exists**) → infer from the codebase. For a small or single-domain repo, create one root `GLOSSARY.md`. When the codebase has distinct domains (clear top-level feature/module boundaries, often visible in `CLAUDE.md` or the folder structure), create a `GLOSSARY-MAP.md` plus per-domain `GLOSSARY.md` files that live in each domain's folder.

When multi-domain and it's unclear which domain a term belongs to, ask rather than guess.

`GLOSSARY-MAP.md` shape:

```md
# Glossary Map

## Domains

- [Allocation](./src/Allocation/GLOSSARY.md) — splits and settles charges across parties
- [Billing](./src/Billing/GLOSSARY.md) — generates invoices and processes payments

## Relationships

- **Allocation → Billing**: Allocation produces settled groups; Billing turns them into invoices
- **Allocation ↔ Billing**: shared `MoneyAmount` and `PartyId` types
```

## Steps

### 1. Read Current Glossary

If `GLOSSARY-MAP.md` exists, read it first, then read the relevant per-domain `GLOSSARY.md` file(s). Otherwise read the root `GLOSSARY.md`. Understand:

- What terms are already defined
- The tone, format, and level of detail used
- How entries relate to each other (grouping, cross-references)
- In multi-domain repos, the domain boundaries and relationships the map records

### 2. Scan the Codebase for Domain Concepts

Domain language lives everywhere, not just in entity files. Check `CLAUDE.md` for project structure guidance, then scan (per domain when multi-domain):

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
- **Missing `_Avoid_` guidance** — concepts the code refers to by several competing words, where the glossary doesn't yet say which one is canonical.

If `$ARGUMENTS` was provided, focus on those terms but also check related concepts that may need updating as a result.

### 4. Draft Updates

For each gap, draft a glossary entry following the existing style:

- **Bold term** followed by `--` and a domain-level definition
- Describe what it _means_ in the domain, not how it's implemented
- Note relationships to other concepts in plain language
- When real competing words exist, add an `_Avoid_:` line listing the rejected synonyms so the doc enforces shared language rather than just describing it. Only add it when there genuinely are alternatives — not every term needs one.
- Keep entries concise (2-4 sentences max)

Format:

```md
**AllocationGroup** — a set of charges settled together as one unit.
_Avoid_: batch, bucket, split-set
```

### 5. Apply Changes

Use the Edit tool to update the glossary:

- Add new entries near related terms, in the correct per-domain file when multi-domain
- Update stale entries in place
- Remove entries for concepts that no longer exist
- In multi-domain repos, add or refresh the matching `GLOSSARY-MAP.md` entry and any new cross-domain relationships

### 6. Summary

Report what was added, updated, or removed — and flag any terms where you weren't confident about the domain meaning so the team can refine them.

## Rules

- The glossary defines domain language, not implementation details. No framework internals, column types, or language-specific types.
- **Only terms specific to this project's domain.** General programming concepts (timeouts, retries, error types, utility patterns) don't belong even if the project uses them heavily. Before adding a term, ask: is this a concept unique to this domain, or a general programming concept? Only the former belongs.
- A concept doesn't need to be a persisted entity to deserve a glossary entry. Strategies, statuses, workflows, and domain verbs matter too.
- Be opinionated about terminology. When multiple words exist for one concept, pick the best one and list the rest under `_Avoid_`.
- When two terms could be confused, the glossary should explicitly disambiguate them.
- Match the existing tone and format exactly.
- When a concept sits between others in a hierarchy, mention both parent and child relationships.
