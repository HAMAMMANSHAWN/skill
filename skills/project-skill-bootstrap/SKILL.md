---
name: project-skill-bootstrap
description: Use when starting a project with no Skills, listing available project Skills, choosing which Skills a project needs, installing named project-local Skills, migrating away from global Skills, or preparing a Skill handoff for a new conversation.
---

# Project Skill Bootstrap

Use `/Users/project/Github/skill` as the default library. Resolve another library only when the project instructions or user specify one.

## Choose the phase

- **List**: Show available Skills from the central library so the user can choose.
- **Plan**: Analyze and write `.agents/skill-plan.md`. Do not create or remove Skill links.
- **Direct install**: Install one or more named Skills when the user's message explicitly asks to install/link/add/use those Skills in the current project.
- **Apply**: Read an approved plan, verify it still fits the project, then create links.
- **Audit**: Compare existing project links with the plan. Report drift before changing anything.

Never combine planning and applying unless the user explicitly asks for both in the same conversation. A direct request such as "install `pdf`", "link `youmind-file-reader` to this project", or "use `playwright` in this project" is approval for those named Skills only; do not ask the user to repeat a fixed approval phrase.

## List

When the user does not remember Skill names, asks what is available, or gives a vague capability request:

1. Read `<library>/SKILLS.md`.
2. Present a short grouped list with Skill names and one-line purposes.
3. Ask the user to choose names, or offer a recommended minimal set when the project goal is clear.
4. Do not install anything from a list response unless the user explicitly authorizes installation.

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

## Direct install

Use this phase when the user explicitly names one or more Skills and asks to install, link, add, enable, or use them in the current project.

1. Treat the user's install request as approval for those named Skills. Do not ask for a second confirmation unless the request is ambiguous, destructive, or would install additional unmentioned Skills.
2. Confirm every requested Skill exists under `<library>/skills/<name>/SKILL.md`.
3. If `.agents/skill-plan.md` is absent, create it with `status: approved`, recording the requested Skills under **Required now** and the user's request as the approval basis. If the template asset is unavailable, write the same frontmatter and sections manually.
4. If `.agents/skill-plan.md` exists, add only the requested approved Skills; do not remove or silently install conditional Skills.
5. Run `scripts/link-skills.sh <project-root> <skill>...` without `--apply`. If the script is unavailable, perform the equivalent safe symlink dry run manually.
6. Apply only if the dry run targets the requested Skills and would not overwrite anything. Use the script with `--apply` when available; otherwise create equivalent project-local symlinks safely.
7. Mark the plan `status: installed`, record `installed_at`, and add verification results.

Direct install should still be minimal: install exactly what the user requested, not every related Skill.

## Audit or remove

Report links that are missing, broken, unplanned, or point outside the central library. Removal is a separate destructive action: show the exact links first and require explicit user approval. Delete only verified symlinks, never their targets.
