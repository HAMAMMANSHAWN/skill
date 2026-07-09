---
name: project-skill-bootstrap
description: Analyze a project's goals and files, select the smallest useful set of Skills from a central Skill library, persist a cross-session installation plan, and safely create project-local Skill symlinks after approval. Use when starting a project with no Skills, planning which Skills a project needs, migrating away from globally installed Skills, preparing a Skill handoff for a new conversation, or installing approved Skills into `.agents/skills` and `.claude/skills`.
---

# Project Skill Bootstrap

Use `/Users/project/Github/skill` as the default library. Resolve another library only when the project instructions or user specify one.

This Skill is the sole recommended global exception. Keep it linked under `~/.cursor/skills/project-skill-bootstrap` and `~/.agents/skills/project-skill-bootstrap` so new projects can invoke it without a project-local install first. Use `scripts/install-global-bootstrap.sh --apply` to create those links. Do not globally install other Skills from the library.

## Choose the phase

- **Plan**: Analyze and write `.agents/skill-plan.md`. Do not create or remove Skill links.
- **Apply**: Read an approved plan, verify it still fits the project, then create links.
- **Audit**: Compare existing project links with the plan. Report drift before changing anything.

Never combine planning and applying unless the user explicitly asks for both in the same conversation.

## Plan

1. Read project instructions and inspect representative files, dependencies, and intended deliverables.
2. Read the library's `SKILLS.md`. Open individual `SKILL.md` files only when their summaries are insufficient to decide.
3. Prefer the smallest sufficient set. Do not select a Skill merely because it might be useful someday.
4. Separate **required now**, **conditional later**, and **rejected** candidates. Explain each choice in one sentence.
5. Copy `assets/skill-plan-template.md` to `<project>/.agents/skill-plan.md` and fill every field.
6. Leave `status: draft` until the user explicitly approves the selection. After approval, set `status: approved` and record the approval date.
7. End the plan with the exact prompt the user can paste into a new conversation.

The plan file is the cross-session handoff. Do not rely on chat history.

## Apply

1. Require `.agents/skill-plan.md` with `status: approved`. If absent or draft, stop and request approval.
2. Confirm every selected Skill exists under `<library>/skills/<name>/SKILL.md`.
3. Run `scripts/link-skills.sh <project-root> <skill>...` without `--apply` and review the dry run.
4. Run the same command with `--apply` only when the dry run matches the approved plan.
5. Verify every link and ensure `.claude/skills` points to `../.agents/skills` when that entry was absent.
6. Set the plan to `status: installed`, record the installation date, and add verification results.
7. Tell the user to start a fresh conversation so only the newly linked Skills enter the next task context.

Never overwrite an existing file, directory, or conflicting symlink. Never modify global Skill directories. Never install conditional Skills until their condition is met and approved.

## Audit or remove

Report links that are missing, broken, unplanned, or point outside the central library. Removal is a separate destructive action: show the exact links first and require explicit user approval. Delete only verified symlinks, never their targets.
