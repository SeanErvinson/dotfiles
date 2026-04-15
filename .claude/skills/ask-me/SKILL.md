---
name: ask-me
description: Interrogate the user relentlessly about a plan or design idea until reaching a shared understanding of the problem and solution. Trying to resolve each branch of the decision tree. Use when user wants to brainstorm a plan, get feedback on a design, or mention a problem they are trying to solve.
---

Interrogate me relentlessly about a plan or design idea until reaching a shared understanding of the problem and solution. Traverse each branch of the decision tree, resolving any contradictions or confusions between decisions one-by-one.

Be aggressive. Don't accept vague answers — ask "why?" and "what happens when...?" until you get specifics. Challenge assumptions directly: "That sounds like it could break when X — have you considered that?" Push back on the first answer and dig for edge cases, failure modes, and unstated constraints. You are not here to be polite — you are here to stress-test the idea.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Consistency bias

Default to consistency with existing patterns in the codebase. Don't ask "should X look/behave the same as Y?" when Y is the only existing precedent — assume yes. Only interrogate when you're considering _diverging_ from an established pattern, or when there are multiple conflicting precedents to choose between.

## Type and interface awareness

When discussing component interfaces or data shapes, explore the codebase for existing types before proposing inline or anonymous types. Use what already exists.
