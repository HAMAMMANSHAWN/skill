---
name: codex-cursor-review
description: Use when Cursor has implemented a Codex-planned project or feature and Codex should review the resulting code, compare it against Cursor task docs, inspect diffs, run verification, and produce a concise engineering review before fixes or handoff.
---

# Codex Cursor Review

Review Cursor's implementation against the approved Codex-Cursor task package. Treat this as an engineering review first, not a rewrite.

## Workflow

1. Read `CURSOR_HANDOFF.md` and `docs/codex-cursor/` if present.
2. Inspect git status and diffs. Identify files Cursor changed before reading the whole project.
3. Compare implementation against:
   - `IMPLEMENTATION_BRIEF.md`
   - `CURSOR_TASKS.md`
   - `REVIEW_CHECKLIST.md`
   - Any deviations Cursor recorded in task notes.
4. Run the verification commands named in `REVIEW_CHECKLIST.md`. If no checklist exists, infer the smallest useful set from project scripts.
5. Review in this order: contract compliance, security/data integrity, build/test correctness, UX states, maintainability.
6. Write or update `docs/codex-cursor/CODEX_REVIEW_REPORT.md`.
7. Final response leads with findings. Implement fixes only when the user explicitly asks for fixes, or when the user request includes "修复", "直接改", or equivalent.

## Review Report

Use this structure:

```md
# Codex Review Report

Date: YYYY-MM-DD
Scope: <what Cursor completed>

## Verdict
<Pass | Pass with issues | Blocked>

## Findings

### P0/P1/P2: <title>
- File: path:line
- Problem: <specific behavioral or contract issue>
- Expected: <what the plan/checklist required>
- Recommendation: <specific fix direction>

## Verification
- `<command>`: <passed/failed/not run and why>

## Contract Coverage
- <task or contract>: <met/partial/missing>

## Cursor Follow-up Tasks
1. <small exact task>
```

Severity:

- P0: data loss, security break, app unusable, migration destructive.
- P1: core requirement or API contract broken.
- P2: important quality, UX, or maintainability issue.
- P3: polish or optional improvement.

## What To Check

- API routes match method, path, request, response, and error shape.
- Frontend calls match backend contracts and handle loading, empty, and error states.
- Auth and permissions are enforced server-side, not only in UI.
- Database schema matches the brief; migrations are reversible or clearly safe.
- Secrets are not committed and environment variables are documented.
- Tests cover fragile contracts and core business logic.
- Generated code does not drift into unrelated refactors.
- UI text fits containers and does not overlap at common desktop/mobile sizes.

## Output Rules

- Lead with concrete findings, ordered by severity.
- Include file and line references whenever available.
- Say clearly when no issues are found.
- Say which commands were run and their result.
- Do not praise Cursor generically.
- Do not rewrite large sections of code during review unless explicitly asked.
