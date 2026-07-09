# Cursor Skill 同步指南

Cursor 有自己的 Skills 入口，也支持 Rules。为了让 Cursor 打开项目时稳定使用本仓库的 `project-skill-bootstrap`，本仓库同时提供 Cursor Rules 模板、Cursor 项目 Skill 入口，并补齐 Codex/Claude 兼容入口。

## 同步到当前项目

在业务项目根目录执行：

```bash
/Users/project/Github/skill/scripts/sync-cursor-project-skill-bootstrap.sh --apply "$PWD"
```

它会创建：

```text
.cursor/rules/project-skill-bootstrap.mdc
.cursor/rules/project-skill-bootstrap -> /Users/project/Github/skill/templates/cursor/project-skill-bootstrap
.cursor/skills/project-skill-bootstrap -> /Users/project/Github/skill/skills/project-skill-bootstrap
.agents/skills/project-skill-bootstrap -> /Users/project/Github/skill/skills/project-skill-bootstrap
.codex/skills -> ../.agents/skills
.claude/skills -> ../.agents/skills
```

脚本默认 dry-run；只有加 `--apply` 才会写入。遇到已有文件、目录或不同目标的软链接时会停止，不会覆盖。

## 新项目推荐流程

1. 新建或打开项目。
2. 运行同步脚本。
3. 重启 Cursor 或重新打开该项目。
4. 让 Cursor 执行：

   > 按项目规则读取 project-skill-bootstrap，只生成 `.agents/skill-plan.md`，不要安装其他 Skill。

5. 审批计划后，再让 Cursor 按计划执行安装。

## 让 Cursor 每次打开新项目都知道这件事

把下面文件的内容复制到 Cursor 的 User Rules：

```text
/Users/project/Github/skill/templates/cursor/user-rule-project-skill-bootstrap.md
```

这样 Cursor 在没有项目规则的新项目里，会先提醒你运行同步脚本，而不是把所有 Skill 全局安装。

## 为什么不是直接全局安装 Skill

全局安装会让每个项目都暴露额外上下文，和本仓库的设计目标相反。Cursor User Rules 只保存一个很短的“引导提醒”，真正的 Skill 仍然通过项目级软链接按需启用。

## Cloud Agent 注意事项

Cursor Cloud Agent 运行在远端环境，不一定能读取本机的 `~/.cursor/skills` 或 `/Users/...` 绝对路径。若希望 Cloud 页面也能发现 Skill，应把项目级入口提交到仓库：

```text
.cursor/skills/project-skill-bootstrap -> ../../skills/project-skill-bootstrap
```

这个链接目标在仓库内部，Cloud 克隆项目后也能解析。只在本机创建 `~/.cursor/skills/project-skill-bootstrap` 只能影响本地 Cursor。
