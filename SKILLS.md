# Skills 清单

本仓库当前收录 35 个用户级 Skill。`本地`表示原先直接安装在 `~/.codex/skills`；`cc-switch` 表示原先由该目录中的软链接指向 `~/.cc-switch/skills`；`本仓库`表示迁移过程中创建并由本仓库维护。迁入本仓库后，`skills/<name>` 均为可独立使用的完整原件。

## 搜索、浏览器与自动化

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `ai-search-hub` | 自动操作元宝、LongCat、豆包、千问、Gemini、Grok、MiniMax 等 AI 搜索站点 | 本地 |
| `defuddle` | 从网页提取干净 Markdown，去除导航与页面杂质 | cc-switch |
| `playwright` | 用真实浏览器执行导航、填表、截图、抓取和 UI 调试 | 本地 |
| `webapp-testing` | 使用 Playwright 验证和调试本地 Web 应用 | cc-switch |

## 文档、表格与演示

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `doc-coauthoring` | 结构化协作撰写文档、提案、规范和决策记录 | cc-switch |
| `docx` | 创建、读取和编辑 Word 文档 | cc-switch |
| `internal-comms` | 编写状态报告、领导更新、FAQ、事故报告等内部沟通材料 | cc-switch |
| `pdf` | 读取、生成、合并、拆分、OCR 和处理 PDF | cc-switch |
| `pptx` | 创建、读取和编辑 PowerPoint 演示文稿 | cc-switch |
| `ppt-master` | 从 PDF/DOCX/网页等源文档生成原生可编辑 PPTX（SVG 多角色协作流程） | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) |
| `xlsx` | 创建、读取、清洗和编辑 Excel、CSV、TSV 表格 | cc-switch |

## 设计、图像与前端

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `algorithmic-art` | 用 p5.js 和可复现随机数创作生成艺术 | cc-switch |
| `baoyu-article-illustrator` | 分析文章并在合适位置生成配图 | 本地 |
| `brand-guidelines` | 将 Anthropic 品牌色彩与字体规范应用到产物 | cc-switch |
| `canvas-design` | 设计 PNG、PDF 海报和静态视觉作品 | cc-switch |
| `frontend-design` | 创建具有设计感的生产级网页和前端组件 | cc-switch |
| `slack-gif-creator` | 创建适合 Slack 体积与尺寸约束的动画 GIF | cc-switch |
| `theme-factory` | 为文档、幻灯片和网页应用成套主题 | cc-switch |
| `web-artifacts-builder` | 使用 React、Tailwind 和 shadcn/ui 构建复杂 HTML 交互产物 | cc-switch |

## Figma

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `figma` | 获取 Figma 设计上下文、截图、变量和资源并辅助设计转代码 | 本地 |
| `figma-code-connect-components` | 建立 Figma 组件与代码组件的 Code Connect 映射 | 本地 |
| `figma-create-design-system-rules` | 根据代码库生成项目专属的设计系统规则 | 本地 |
| `figma-create-new-file` | 创建新的 Figma Design 或 FigJam 文件 | 本地 |
| `figma-generate-design` | 从应用页面或描述在 Figma 中组装完整界面 | 本地 |
| `figma-generate-library` | 从代码库构建或更新 Figma 设计系统与组件库 | 本地 |
| `figma-implement-design` | 将 Figma 设计高保真实现为生产代码 | 本地 |
| `figma-use` | 执行 Figma 文件内的节点、变量、布局和组件读写；调用 `use_figma` 前置 Skill | 本地 |

## Obsidian 与知识管理

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `json-canvas` | 创建和编辑 Obsidian JSON Canvas 画布 | cc-switch |
| `obsidian-bases` | 创建和编辑 Obsidian Bases 的视图、筛选、公式与汇总 | cc-switch |
| `obsidian-cli` | 通过 Obsidian CLI 管理笔记、任务、属性、插件和主题 | cc-switch |
| `obsidian-markdown` | 编写含双链、嵌入、Callout、属性的 Obsidian Markdown | cc-switch |

## Agent 与扩展开发

| Skill | 用途 | 原来源 |
| --- | --- | --- |
| `mcp-builder` | 使用 Python 或 TypeScript 构建 MCP Server | cc-switch |
| `project-skill-bootstrap` | 分析项目所需能力，生成跨会话计划，并在批准后安全创建项目级 Skill 链接 | 本仓库 |
| `skill-creator` | 创建或更新高质量 Agent Skill | cc-switch |
| `template` | Skill 目录占位模板，描述尚未填写，不建议直接启用 | cc-switch |

## 维护说明

- 每个 Skill 的权威说明是其目录中的 `SKILL.md`；本清单只提供快速索引。
- 新增、删除、重命名或实质修改 Skill 时，必须同步更新本文件。
- `template` 保留是为了忠实收纳当前用户 Skill 集合；在完善其名称和描述前，不应链接到业务项目。
- Codex 系统内置 Skill 与插件缓存未收录，它们应继续由对应的系统或插件更新机制维护。
