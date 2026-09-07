# Skill Library

这是个人使用的 Agent Skills 集中仓库，当前收录 38 个用户级 Skill。Skill 原件统一保存在 [`skills/`](skills/) 中；具体项目只通过软链接启用所需 Skill，避免全局安装过多 Skill 占用上下文并造成误触发。

## 内容

- [`SKILLS.md`](SKILLS.md)：全部 Skill 的名称、用途与原始来源
- [`docs/项目级-Skills-管理指南.md`](docs/项目级-Skills-管理指南.md)：项目级安装、更新、移除与排错教程
- [`docs/Cursor-Skill-同步指南.md`](docs/Cursor-Skill-同步指南.md)：让 Cursor 通过项目规则使用引导 Skill
- [`AGENTS.md`](AGENTS.md)：供 Codex、Claude Code 等 Agent 自动读取的仓库约定
- [`templates/cursor/`](templates/cursor/)：Cursor Rules 模板
- [`scripts/`](scripts/)：项目接入与同步脚本
- [`skills/`](skills/)：Skill 原件，每个子目录包含自己的 `SKILL.md`

## 快速接入一个项目

```bash
mkdir -p /path/to/project/.agents/skills
ln -s "$(pwd)/skills/<skill-name>" /path/to/project/.agents/skills/<skill-name>
mkdir -p /path/to/project/.codex
ln -s ../.agents/skills /path/to/project/.codex/skills
mkdir -p /path/to/project/.claude
ln -s ../.agents/skills /path/to/project/.claude/skills
```

建议让 Agent 代为执行，并要求它在创建前检查目标是否已存在。

新项目可以只启用 `project-skill-bootstrap`：它会先生成 `.agents/skill-plan.md`，待用户确认后再按需链接其他 Skill，并把执行提示留给下一个会话。

## Cursor 快速接入

Cursor 使用 Rules 作为稳定入口。把引导 Skill 同步到当前项目：

```bash
/Users/project/Github/skill/scripts/sync-cursor-project-skill-bootstrap.sh --apply "$PWD"
```

这会创建项目级 Cursor Rules，同时软链接 `project-skill-bootstrap`，并补齐 Codex/Claude 兼容入口。若希望 Cursor 打开全新项目时主动提醒，可把 [`templates/cursor/user-rule-project-skill-bootstrap.md`](templates/cursor/user-rule-project-skill-bootstrap.md) 的内容复制到 Cursor User Rules。
