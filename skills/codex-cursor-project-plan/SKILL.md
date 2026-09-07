---
name: codex-cursor-project-plan
description: Use when starting a software project or feature where Codex should produce a strict frontend/backend implementation direction and task package for Cursor to execute, especially when the user says Cursor will write the code, asks to save tokens, wants architecture first, or wants core code guidance without full implementation.
---

# Codex Cursor Project Plan

Create a Cursor-executable project package. Codex owns product clarification, architecture, contracts, core implementation direction, and acceptance criteria; Cursor owns the bulk code writing.

## Workflow

1. Inspect the current project if files exist: README, package manifests, framework config, existing source, tests, and git status.
2. Ask only blocking questions. If reasonable assumptions are possible, record them in the brief instead of pausing.
3. Choose a conservative stack and architecture that fit the project direction and existing code.
4. Create or update these files:
   - `docs/codex-cursor/IMPLEMENTATION_BRIEF.md`
   - `docs/codex-cursor/CURSOR_TASKS.md`
   - `docs/codex-cursor/REVIEW_CHECKLIST.md`
   - `CURSOR_HANDOFF.md`
5. Do not implement the full application. Include short snippets only for fragile or core logic where Cursor must not improvise.
6. End by telling the user to open the project in Cursor and follow `CURSOR_HANDOFF.md`.

## Implementation Brief

`IMPLEMENTATION_BRIEF.md` is the project contract. Include:

- Goal and non-goals.
- Chosen frontend, backend, database, auth, deployment, and testing stack.
- Directory structure with ownership boundaries.
- Data model or schema outline.
- API contract: route, method, request, response, error shape.
- State management and data-fetching rules.
- Security rules: auth, secrets, validation, permissions, rate limits where relevant.
- Assumptions and decisions Cursor must preserve.

Keep it directive. Avoid open-ended alternatives after the decision is made.

## Cursor Tasks

`CURSOR_TASKS.md` must be a numbered execution list. Each task uses this shape:

````md
## Task N: <imperative title>

Files:
- path/to/file
- path/to/other-file

Goal:
- <observable outcome>

Exact Requirements:
- <specific behavior>
- <specific contract>

Core Direction:
- <architecture and implementation notes Cursor must follow>

Core Snippet:
```ts
// Only include this section for fragile/core code.
```

Acceptance:
- <command, test, or manual check>
- <expected result>
````

Task quality rules:

- One task should be small enough for Cursor to complete without redesigning architecture.
- Name exact files whenever possible.
- Define API and data contracts before UI tasks that consume them.
- Put database migrations/schema before backend services.
- Put backend contracts before frontend integration.
- Include error states, empty states, loading states, and validation states for user-facing flows.
- Include tests only where they protect contracts, auth, payments, data integrity, or complex logic.

## Review Checklist

`REVIEW_CHECKLIST.md` defines how Codex will later judge Cursor's work:

- Required commands: install, lint, typecheck, test, build, migration checks, or framework equivalents.
- Contract checks: API shape, schema, auth, error handling, state boundaries.
- Frontend checks: responsiveness, accessibility basics, loading/error/empty states, no layout overlap.
- Backend checks: validation, transactions, authorization, secrets, logging, idempotency where relevant.
- Done criteria for each milestone.

## Handoff

`CURSOR_HANDOFF.md` is the only file the user needs to open first in Cursor. Keep it short:

- Link to the three detailed docs.
- State that Cursor must follow tasks in order.
- State that Cursor should not change stack, contracts, directory structure, or acceptance criteria unless the user asks.
- Tell Cursor to mark completed tasks in `CURSOR_TASKS.md` and note deviations under each task.

## Guardrails

- Prefer exact direction over broad advice.
- Do not generate full production files unless the user explicitly asks Codex to implement.
- Do not ask Cursor to "build the app" as one task.
- Do not leave TODO/TBD placeholders.
- Do not create private-project details inside the central Skill library.
