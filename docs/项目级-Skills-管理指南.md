# 项目级 Skills 管理指南

## 为什么只在项目内启用

Agent 的上下文窗口有限。即使 Skill 默认只暴露名称和描述，数量多了也会占用上下文，并增加无关 Skill 被误触发、进而加载完整说明的概率。把原件集中管理、在项目内按需链接，可以让每个项目只暴露真正需要的能力。

## 推荐目录

假设本仓库位于 `~/Github/skill`：

```text
~/Github/skill/
├── skills/                 # Skill 原件
│   ├── pdf/
│   ├── xlsx/
│   └── frontend-design/
└── docs/

~/Github/my-project/
├── .agents/skills/         # 项目启用列表（软链接）
├── .codex/skills           # 指向 ../.agents/skills
└── .claude/skills          # 指向 ../.agents/skills
```

> macOS 默认文件系统通常不区分大小写，但路径书写应始终与实际目录一致。本机当前仓库路径是 `/Users/project/Github/skill`。

## 给项目安装 Skill

以 `pdf` 为例，在业务项目根目录执行：

```bash
mkdir -p .agents/skills
ln -s /Users/project/Github/skill/skills/pdf .agents/skills/pdf
mkdir -p .codex
ln -s ../.agents/skills .codex/skills
mkdir -p .claude
ln -s ../.agents/skills .claude/skills
```

如果 `.codex/skills` 或 `.claude/skills` 已存在，不要覆盖；先用 `ls -la` 判断它是目录还是软链接。Codex 可通过 `.codex/skills` 使用同一组 Skill；Claude Code 通过 `.claude/skills` 使用同一组 Skill。

也可以直接对 Agent 说：

> 把 `/Users/project/Github/skill/skills/pdf` 软链接到当前项目的 `.agents/skills/pdf`；如果 `.codex/skills` 或 `.claude/skills` 不存在，再创建指向 `../.agents/skills` 的软链接。不要覆盖已有文件。

## 用一个引导 Skill 冷启动

如果项目一开始还不知道需要哪些 Skill，可以只启用 `project-skill-bootstrap`。它采用两段式流程：

1. 当前会话分析项目目标与文件，只生成 `.agents/skill-plan.md`，不安装其他 Skill。
2. 用户确认方案后，计划状态变为 `approved`。
3. 新会话读取计划，先 dry-run，再建立获批的项目级软链接并验证。
4. 再开一个干净会话执行正式任务，使上下文只包含真正需要的 Skill。

跨会话信息必须写入计划文件，不能依赖上一段聊天记录。引导 Skill 自带的脚本默认只预览；必须显式添加 `--apply` 才会创建链接，并且遇到任何已有文件或冲突链接都会停止。

推荐把 `project-skill-bootstrap` 作为唯一全局例外常驻，这样任意新项目都能直接触发规划流程，无需先在项目内手动链接：

```bash
cd /Users/project/Github/skill
./skills/project-skill-bootstrap/scripts/install-global-bootstrap.sh --apply
```

脚本会把原件链接到 `~/.cursor/skills/project-skill-bootstrap` 与 `~/.agents/skills/project-skill-bootstrap`。不要全局安装其他用户 Skill。若暂时不想全局安装，也可在项目 `AGENTS.md` 中注明先读取本仓库的 `skills/project-skill-bootstrap/SKILL.md`。

如果用户已经明确说“安装 / 链接 / 启用某个 Skill 到当前项目”，这句话本身就是对这些具名 Skill 的批准。Agent 应创建或更新 `.agents/skill-plan.md` 记录批准，再 dry-run 和安装；不要要求用户复述固定批准口令。若用户不记得 Skill 名称，先从 `SKILLS.md` 列出可选项或推荐最小集合，再等待用户选择。

## Cursor 项目接入

Cursor 不直接消费 Codex Skill 列表，推荐用项目 Rules 引导它读取本仓库的 Skill 原件。当前仓库提供同步脚本：

```bash
/Users/project/Github/skill/scripts/sync-cursor-project-skill-bootstrap.sh --apply "$PWD"
```

它会为当前项目创建 `.cursor/rules/project-skill-bootstrap.mdc`、`.cursor/rules/project-skill-bootstrap/RULE.md`、`.cursor/skills/project-skill-bootstrap`、`.agents/skills/project-skill-bootstrap`、`.codex/skills` 和 `.claude/skills`。详细说明见 `docs/Cursor-Skill-同步指南.md`。

## 与现有全局软链接结合

本机原有配置并不需要一次性推倒重来。推荐采用平滑迁移：

```text
迁移期间（兼容）
~/.codex/skills/<name> ───────┐
                              ├─> /Users/project/Github/skill/skills/<name>
项目/.agents/skills/<name> ───┘

迁移完成（推荐）
项目/.agents/skills/<name> ─────> /Users/project/Github/skill/skills/<name>
项目/.codex/skills ─────────────> ../.agents/skills
项目/.claude/skills ────────────> ../.agents/skills
```

迁移期间，可以把已有的全局入口重新指向本仓库，同时让新项目直接按需链接本仓库。这样原有工作流不会中断，新工作流也可以立刻开始。确认所有常用项目都已有自己的链接后，再移除全局入口，才能真正减少全局 Skill 摘要带来的上下文占用。

以 `pdf` 为例，安全地替换已有全局软链接：

```bash
test -L ~/.codex/skills/pdf
old_target="$(readlink ~/.codex/skills/pdf)"
rm ~/.codex/skills/pdf
ln -s /Users/project/Github/skill/skills/pdf ~/.codex/skills/pdf
readlink ~/.codex/skills/pdf
```

只有第一条检查成功时才应继续。若目标是实体目录，不要删除或覆盖；先人工确认内容是否已完整进入本仓库。旧目标可用于回滚：删除新链接后，重新链接到 `$old_target`。

### 本机现有链接如何处理

- 原先指向 `~/.cc-switch/skills` 的 22 个入口，其完整内容已收纳到本仓库；可以逐个改指向本仓库，或保持不动直到项目迁移完成。
- 原先直接位于 `~/.codex/skills` 的 11 个 Skill 原件也已收纳，但不要直接删除原目录。先为项目建立链接并验证，再决定是否备份、移除或改成指向本仓库的链接。
- `codex-primary-runtime` 不是 Skill，不参与迁移。
- 系统 Skill 和插件缓存不应改链，它们继续由 Codex 或插件管理器维护。

## 查看与验证

```bash
ls -la .agents/skills
readlink .agents/skills/pdf
test -f .agents/skills/pdf/SKILL.md && echo OK
```

验证重点：链接目标存在、目标内有 `SKILL.md`、Agent 重启或重新进入项目后能发现该 Skill。

## 更新

本仓库是所有原件的唯一来源：

```bash
cd /Users/project/Github/skill
git pull --ff-only
```

所有引用这些原件的项目会立即使用更新后的内容。更新前建议查看变更；上游改动可能改变触发条件或依赖。

## 修改并反哺

通过项目软链接编辑 Skill 时，实际修改的是本仓库里的原件。完成后回到本仓库检查、提交和推送：

```bash
cd /Users/project/Github/skill
git status
git diff
```

修改 Skill 时同步检查其 `SKILL.md`、脚本、引用资源和 `SKILLS.md` 清单。不要把项目私密信息写回公共 Skill。

## 移除项目中的 Skill

只删除软链接，不删除它指向的原件：

```bash
rm .agents/skills/pdf
```

执行前可用 `test -L .agents/skills/pdf` 确认它确实是软链接。不要使用带递归参数的删除命令。

## 新增 Skill 原件

1. 将完整 Skill 目录放入 `skills/<name>/`。
2. 确认存在有效的 `SKILL.md`，且名称、描述和触发条件清楚。
3. 在 `SKILLS.md` 登记用途与来源。
4. 检查其中没有密钥、个人路径、登录态和大体积缓存。
5. 仅在需要它的项目中创建软链接。

## 常见问题

### 链接失效

使用 `readlink` 查看目标。通常是原件目录被移动、重命名，或使用了错误的相对路径。修复软链接即可，不需要复制 Skill。

### Agent 没发现 Skill

确认入口路径正确、`SKILL.md` 存在，并重新启动 Agent 会话。不同 Agent 支持的入口可能不同，因此统一保留 `.agents/skills`，再为具体工具建立入口软链接。

### 多个项目需要不同版本

为稳定版本建立 Git tag 或独立 worktree，再让要求稳定的项目指向固定 worktree。直接链接主分支适合希望始终跟随最新版的项目。

### 跨机器使用

克隆仓库后，绝对路径会变化。应在每台机器上重新创建项目软链接，或使用从业务项目到本仓库的正确相对路径；不要提交只在一台机器有效的绝对软链接。
