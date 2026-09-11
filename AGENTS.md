# Agent Instructions

## 仓库定位

本仓库是用户自定义 Skills 的唯一原件库。`skills/<name>/` 是可被其他项目软链接引用的 Skill 原件，不是安装后的临时副本。

## 开始工作前

1. 阅读 `README.md` 了解目录结构。
2. 阅读 `SKILLS.md` 查找 Skill 的用途与来源。
3. 涉及安装、迁移、更新或删除时，先阅读 `docs/项目级-Skills-管理指南.md`。
4. 使用某个 Skill 时，必须完整阅读对应的 `skills/<name>/SKILL.md`，再按其中说明操作。

新项目尚未选择 Skill 时，优先使用 `skills/project-skill-bootstrap/SKILL.md` 生成可跨会话读取的计划；规划阶段不得同时安装其他 Skill。

## 修改约定

- 不要把 Skill 复制到业务项目；从业务项目的 `.agents/skills/<name>` 创建指向本仓库原件的软链接。
- Claude Code 的统一入口为 `.claude/skills -> ../.agents/skills`。
- 迁移期允许保留 `~/.codex/skills` 的兼容软链接；只有在用户明确要求后才能修改或移除这些全局入口。
- 修改 Skill 原件前先检查 Git 状态；修改后更新 `SKILLS.md` 中相关说明并运行基本校验。
- 不提交密钥、登录态、浏览器资料、构建产物或依赖缓存。
- 删除或重命名 Skill 会破坏其他项目的软链接，必须先查找引用方并征得用户确认。

## Cursor Cloud specific instructions

- 本仓库是文档 + 脚本型的 Skill 原件库，**没有需要长期运行的服务、Web 服务器或构建产物**；不要去找 `pnpm dev` / `npm run dev` 之类的启动命令。开发工具只有两类：Python 的 Skill 校验/打包脚本，以及 Bash 的安装脚本。
- 运行时已就绪：Python 3、Node.js、Bash 均预装；唯一的第三方 Python 依赖是 `PyYAML`（由启动更新脚本安装），`skills/skill-creator/scripts/quick_validate.py` 依赖它。
- 校验（相当于 lint/test）：对单个 Skill 运行 `python3 skills/skill-creator/scripts/quick_validate.py skills/<name>`；批量校验可在 `skills/*/` 上循环调用。它只检查 `SKILL.md` frontmatter（name/description 等），不检查脚本逻辑。
- 打包（相当于 build）：`python3 skills/skill-creator/scripts/package_skill.py skills/<name> <输出目录>` 会先校验再生成 `.skill`（zip）。仓库里的 `dist/project-skill-bootstrap.skill` 就是这样产出的；重新生成时请输出到临时目录，除非有意更新 `dist/`。
- 新建 Skill 脚手架：`python3 skills/skill-creator/scripts/init_skill.py <name> --path <目录>`。注意生成的模板 `description` 是占位符（含 `[TODO ...]`），**校验会失败**，必须先补全 `description` 再校验。
- 运行核心产品（把 Skill 安装进某个项目）：`skills/project-skill-bootstrap/scripts/link-skills.sh` 和 `scripts/sync-cursor-project-skill-bootstrap.sh`。两者**默认只做 dry-run**，必须显式加 `--apply` 才会创建软链接；遇到已存在的非软链接或指向不同目标的软链接会**直接报错停止**（可安全重复执行）。
- 这些脚本创建的是**指向本仓库的绝对路径软链接**，因此测试时请指向仓库之外的临时项目目录（如 `/tmp/demo-project`），不要在本仓库内制造软链接污染 Git 状态。
