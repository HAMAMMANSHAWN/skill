---
status: approved
library: /Users/project/Github/skill
planned_at: 2026-08-10
approved_at: 2026-08-10
installed_at: 2026-08-10
---

# Project Skill Plan

## Project goal

在此中央 Skill 库项目中启用 `ppt-master`，使当前 Codex 会话可发现并调用该 Skill。

## Required now

- [x] `ppt-master` — 用户已安装该原件，并反馈 `/ppt-master` 在当前项目不可见；需要将其加入本项目的 Codex 入口。

## Conditional later

- 无。

## Rejected candidates

- 其他 Skill — 本次只解决 `ppt-master` 的发现问题，不扩大当前项目的上下文。

## Installation command

```bash
/Users/project/Github/skill/skills/project-skill-bootstrap/scripts/link-skills.sh --apply /Users/project/Github/skill ppt-master
```

## Verification

- [x] `ppt-master` 目标包含 `SKILL.md`
- [x] `.agents/skills/ppt-master` 指向中央库原件
- [x] `.cursor/skills/ppt-master` 指向中央库原件
- [x] `.codex/skills` 解析到 `.agents/skills`
- [x] `.claude/skills` 解析到 `.agents/skills`

## Next-conversation prompt

> Read `.agents/skill-plan.md` and the project instructions. The plan is approved for `ppt-master`; verify the existing links and use `ppt-master` for PowerPoint-related tasks.
