# Agent Instructions

## 仓库定位

本仓库是用户自定义 Skills 的唯一原件库。`skills/<name>/` 是可被其他项目软链接引用的 Skill 原件，不是安装后的临时副本。

## 开始工作前

1. 阅读 `README.md` 了解目录结构。
2. 阅读 `SKILLS.md` 查找 Skill 的用途与来源。
3. 涉及安装、迁移、更新或删除时，先阅读 `docs/项目级-Skills-管理指南.md`。
4. 使用某个 Skill 时，必须完整阅读对应的 `skills/<name>/SKILL.md`，再按其中说明操作。

新项目尚未选择 Skill 时，优先使用 `project-skill-bootstrap` 生成可跨会话读取的计划；规划阶段不得同时安装其他 Skill。该 Skill 是唯一建议常驻全局的例外（`~/.cursor/skills` 与 `~/.agents/skills`），以便任意新项目直接触发；安装脚本见 `skills/project-skill-bootstrap/scripts/install-global-bootstrap.sh`。

## 修改约定

- 不要把 Skill 复制到业务项目；从业务项目的 `.agents/skills/<name>` 创建指向本仓库原件的软链接。
- Claude Code 的统一入口为 `.claude/skills -> ../.agents/skills`。
- `project-skill-bootstrap` 可作为全局例外常驻；其他用户 Skill 不要全局安装。
- 迁移期允许保留 `~/.codex/skills` 的兼容软链接；只有在用户明确要求后才能修改或移除这些全局入口。
- 修改 Skill 原件前先检查 Git 状态；修改后更新 `SKILLS.md` 中相关说明并运行基本校验。
- 不提交密钥、登录态、浏览器资料、构建产物或依赖缓存。
- 删除或重命名 Skill 会破坏其他项目的软链接，必须先查找引用方并征得用户确认。
