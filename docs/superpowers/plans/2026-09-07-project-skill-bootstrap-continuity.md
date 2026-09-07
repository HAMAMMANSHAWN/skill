# Project Skill Bootstrap Continuity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep `project-skill-bootstrap` discoverable across project conversations and support persistent, multi-round Skill consultation.

**Architecture:** A safe project setup script establishes local agent entrypoints and a managed `AGENTS.md` reminder without overwriting existing content. The Skill gains explicit Ensure and Consult phases, while a consultation file preserves recommendations across conversations.

**Tech Stack:** Bash, Markdown, symbolic links.

**Spec:** Design approved in the 2026-09-07 conversation.

## Global Constraints

- The central library at `/Users/project/Github/skill` remains the only Skill source of truth.
- Never overwrite an existing file or conflicting symlink.
- CC Switch configuration and storage are out of scope.
- A running conversation cannot be retroactively given a Skill it did not discover at startup.

---

### Task 1: Add a safe bootstrap-continuity setup script

**Files:**
- Create: `skills/project-skill-bootstrap/scripts/ensure-project-skill-bootstrap.sh`
- Create: `skills/project-skill-bootstrap/tests/ensure-project-skill-bootstrap.test.sh`

**Interfaces:**
- Consumes: `ensure-project-skill-bootstrap.sh [--apply] PROJECT_ROOT`
- Produces: project-local Skill links and one managed block in `AGENTS.md`.

- [x] Write an integration test for dry-run, apply, idempotence, and existing `AGENTS.md` preservation.
- [x] Run the test and observe failure because the setup script is absent.
- [x] Implement the smallest safe script that passes the test.
- [x] Run the integration test again.

### Task 2: Add persistent consultation guidance

**Files:**
- Modify: `skills/project-skill-bootstrap/SKILL.md`
- Create: `skills/project-skill-bootstrap/assets/skill-consultation-template.md`
- Modify: `skills/project-skill-bootstrap/assets/skill-plan-template.md`

**Interfaces:**
- Consumes: a user’s evolving project needs.
- Produces: `.agents/skill-consultation.md` with enabled, library-available, external-suggestion, and deferred groups.

- [x] Add Ensure and Consult phases, retaining separate authorization for planning and installation.
- [x] Add the cross-conversation consultation template and a handoff prompt.
- [x] Update the plan template with the correct helper-script location and consultation handoff.

### Task 3: Align user-facing documentation and validate

**Files:**
- Modify: `docs/项目级-Skills-管理指南.md`
- Modify: `SKILLS.md`

- [x] State that the general Skill linker lives under `skills/project-skill-bootstrap/scripts/`, not the repository root `scripts/` directory.
- [x] Update the bootstrap listing for consultation and continuity behavior.
- [x] Run the new integration test, shell syntax checks, and the Skill validator.
