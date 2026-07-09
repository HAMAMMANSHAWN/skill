# Skill Library

这是个人使用的 Agent Skills 集中仓库，当前收录 34 个用户级 Skill。Skill 原件统一保存在 [`skills/`](skills/) 中；具体项目只通过软链接启用所需 Skill，避免全局安装过多 Skill 占用上下文并造成误触发。

## 内容

- [`SKILLS.md`](SKILLS.md)：全部 Skill 的名称、用途与原始来源
- [`docs/项目级-Skills-管理指南.md`](docs/项目级-Skills-管理指南.md)：项目级安装、更新、移除与排错教程
- [`AGENTS.md`](AGENTS.md)：供 Codex、Claude Code 等 Agent 自动读取的仓库约定
- [`skills/`](skills/)：Skill 原件，每个子目录包含自己的 `SKILL.md`

## 快速接入一个项目

```bash
mkdir -p /path/to/project/.agents/skills
ln -s "$(pwd)/skills/<skill-name>" /path/to/project/.agents/skills/<skill-name>
mkdir -p /path/to/project/.claude
ln -s ../.agents/skills /path/to/project/.claude/skills
```

建议让 Agent 代为执行，并要求它在创建前检查目标是否已存在。

## 全局例外：`project-skill-bootstrap`

`project-skill-bootstrap` 是唯一建议常驻全局的 Skill，方便任意新项目直接触发规划流程。在本机执行：

```bash
./skills/project-skill-bootstrap/scripts/install-global-bootstrap.sh --apply
```

它会把该 Skill 链接到 `~/.cursor/skills/` 与 `~/.agents/skills/`。其他 Skill 仍按项目按需链接，不要全局安装。

新项目可直接让 Agent 使用该引导 Skill：它会先生成 `.agents/skill-plan.md`，待用户确认后再按需链接其他 Skill，并把执行提示留给下一个会话。
