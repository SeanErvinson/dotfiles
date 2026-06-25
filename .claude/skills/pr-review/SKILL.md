---
name: pr-review
description: Deep, full-context review of a GitHub pull request. Gathers the PR diff, changed files at head, and existing review comments, then runs the pr-reviewer agent to surface stateful/async/cross-file bugs the diff-only /review misses. Report-only — you decide what to post. Usage: /pr-review <pr-url-or-number>
tools: Read, Glob, Grep, Bash, Agent, WebFetch
---

# Deep PR Review

Goal: give the user a deep, full-context review of a pull request — the stateful, cross-file, and concurrency issues that a diff-only review misses — and let them decide what to act on. This skill is **report-only**: it never posts comments, pushes, or edits code.

This is a thin wrapper. The actual review is done by the `pr-reviewer` agent; this skill resolves the target, gathers context, runs the agent, and relays the report.

## Input

`/pr-review <pr-url-or-number>`

- A bare number (e.g. `37`) → the PR in the current repo.
- A full URL (e.g. `https://github.com/<owner>/<repo>/pull/37`) → that PR; the repo must be checked out locally for a full-context review.

## Steps

### 1. Resolve the target

- If given a URL, parse `<owner>/<repo>` and the PR number from it. If given a bare number, use the current repo (`gh repo view --json owner,name`).
- Confirm `gh` is authenticated (`gh auth status`).
- Confirm the target repo is the current working directory's repo. Deep review reads files beyond the diff and greps for callers, so it needs the repo checked out locally.
    - If the URL points to a repo that is **not** the current clone, stop and tell the user: full-context review needs that repo checked out. Offer to either (a) proceed with a degraded **diff-only** review (clearly labeled as shallow), or (b) wait while they `cd` into the clone and re-run. Do not silently produce a shallow review as if it were deep.

### 2. Gather context

Collect, and hand to the agent:

- `gh pr view <n> --json title,body,author,headRefName,baseRefName,files`
- `gh pr diff <n>`
- Existing comments: `gh api repos/<owner>/<repo>/pulls/<n>/comments` and `gh api repos/<owner>/<repo>/issues/<n>/comments`
- Ensure the PR head is reachable so files can be read at head: `git fetch origin pull/<n>/head` (or fetch the head ref). The agent reads files at head itself.

### 3. Run the pr-reviewer agent

Invoke the `pr-reviewer` agent with the PR identifier (`<owner>/<repo>#<n>`) and the gathered context. Instruct it to run a full deep scan and return a report-only result.

- For a large PR (many files, or several distinct concerns), you may fan out a few `pr-reviewer` agents in parallel, each scoped to a subset of files or one concern, then merge their reports. Each remains report-only.

### 4. Relay the report

Present the agent's consolidated report to the user as-is — grouped by severity, with trigger scenarios and recommended actions. Do not post anything to the PR. End by reminding the user that nothing was posted and that they decide what, if anything, to raise.
