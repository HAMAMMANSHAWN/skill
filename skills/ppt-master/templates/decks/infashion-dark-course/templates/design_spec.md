---
template_id: infashion-dark-course
deck_id: infashion-dark-course
kind: deck
category: brand
summary: INFashion 至尚课程专用的暗色知识型课件模板，适用于从认知讲解到个人妆面公式收官的教学场景。
keywords: [INFashion, 至尚, 化妆课程, 暗色, 教学模板]
primary_color: "#101218"
canvas_format: ppt169
canvas_width: 1280
canvas_height: 720
canvas_viewbox: "0 0 1280 720"
source_canvas_width: 1280
source_canvas_height: 720
source_viewbox: "0 0 1280 720"
replication_mode: standard
native_structure_mode: structured
page_count: 5
page_types: [cover, toc, chapter, content, ending]
placeholders:
  01_cover: ["8 日明星化妆小白班", "从认知到方法，建立你的个人妆面公式", "课程模板 · 2026"]
  02_toc: ["课程导航", "建立基础", "眼妆进阶", "底妆修容", "个人公式"]
  02_chapter: ["01", "Day 01 · 底妆基础", "从正确的认知开始，找到你的上妆逻辑"]
  03_content: ["底妆的轻透感", "先薄后叠，让妆面保留呼吸感", "03"]
  04_ending: ["把方法，变成属于自己的妆面公式", "总结你的风格、步骤与工具偏好", "04"]
---

# INFashion 至尚 · 暗色课程模板 — Design Specification

## I. Template Overview

用于 INFashion 至尚 8 日明星化妆小白班及同类教学课件。整体为暗色、克制、知识型的品牌表达：先让标题与方法论被清晰阅读，再为教师照片、案例图和过程图留出安静的放置空间。

## II. Color Scheme

- 背景墨蓝黑：`#101218`
- 深层蓝灰：`#161A24`
- 暖白正文：`#F6F1E6`
- 辅助灰：`#AEB4C1`
- 冷调强调：`#6D86B8`
- 微光金色：`#C9B58A`

强调色只用于章节数字、短横线与重点标签；正文始终以暖白和灰阶呈现，避免妆容类课程变成高饱和营销页。

## III. Typography

- 标题与正文：`Source Han Sans CN, Microsoft YaHei, PingFang SC, sans-serif`
- Day / 章节大数字：`Source Han Serif CN, SimSun, serif`

本模板以已安装的思源字体为首选；在没有思源字体的设备上，PowerPoint 会退回至微软雅黑或苹方。若需跨设备维持字形，使用前请安装或嵌入思源字体。

## IV. Signature Design Elements

- 右上角固定白色 INFashion logo，留足安全边距。
- 以墨蓝黑为底，全版规则点阵模拟“设计纸”；左下向中部扩散的蓝灰柔光形成低调层次。
- 四周以极细暖金线收边，点阵与文字均留出呼吸感，不与教师后置图片竞争。
- 所有页面采用左侧标题锚点；图像和案例默认落在右侧或正文留白区，避免与讲解文字竞争。
- 章节页用大号宋体数字建立节奏；总结页以细线网格组织“个人妆面公式”的模块关系。

## V. Page Roster

| File | Layout key / picker name | Use case | Visual character |
| --- | --- | --- | --- |
| `01_cover.svg` | `cover` / `INFashion Cover` | 课程或单日封面 | 左下大标题，右侧留图，右上品牌标识。 |
| `02_toc.svg` | `agenda` / `INFashion Course Map` | 课程节奏、目录、学习路径 | 4+4 节奏以低对比编号排列，适合展示课程地图。 |
| `02_chapter.svg` | `chapter` / `INFashion Chapter` | Day 开场、模块切换 | 章节数字为主视觉，右侧保留图片或老师示范空间。 |
| `03_content.svg` | `content` / `INFashion Content` | 知识点、图文、流程、练习说明 | 标题与要点固定在左侧，右侧设可替换内容/图片区域。 |
| `04_ending.svg` | `formula-summary` / `INFashion Formula Summary` | Day 收束、个人妆面公式、结课页 | 弱网格承接模块公式，适合结论与行动提示。 |

## VI. Assets

- `images/infashion-logo-white.png`：白色 INFashion logo，所有页面右上角固定使用。

## VII. Placeholder Overrides

每页提供可替换的示例标题和说明文字；右侧虚线留图区及正文留白仅标示排版边界，教师可直接在其上放置图片、案例或图示。
