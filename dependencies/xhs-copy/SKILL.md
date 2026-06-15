---
name: xhs-copy
description: The XHS copy sub-agent for the xhs-workflow Director. Owns all text production for Xiaohongshu — titles, body, photo-carousel copy, opinion/narrative copy, tags, engagement hooks, and the final de-AI humanizer gate. The Director (xhs-workflow/SKILL.md) routes here whenever copy must be written or edited; it passes the brief + confirmed direction, and this skill returns ready-to-publish wording. Platform strategy (CES, cold-start, recommendation rules) and the compliance red-line map stay in the Director — this skill applies them, it does not redefine them.
---

# XHS Copy（文案子 Agent）

This is the **copy department** of the `xhs-workflow` system. The Director owns strategy, routing, and compliance knowledge; it delegates the actual writing here. Take the Director's brief (input type, audience, confirmed angle, keywords, sensitivity notes) and produce the wording.

## Skills in this sub-agent

| Skill | What it does | Where |
|---|---|---|
| Title engine | 5 title formulas, keyword-in-first-1/3, CTR shaping | this file |
| Body templates | hook → 增量信息 → punchline → CTA, per content type | this file |
| Photo-carousel copy | cover text, per-slide text, caption | this file |
| Opinion / narrative copy | 共鸣 → 转折 → punchline emotional notes | this file |
| Tag strategy | 4-category tag split | this file |
| Engagement hooks | comment (4×) / follow (8×) / completion hooks | this file |
| **Humanizer gate** | strip AI / public-account / marketing tone (mandatory final pass) | `humanizer/SKILL.md` |
| _(future)_ topic scoring + viral teardown | 选题评估 / 爆款拆解 | _to add_ |

## Inputs this skill expects from the Director

- Input type (video / carousel / opinion note / draft) and confirmed angle
- Target reader + primary search keyword(s)
- Any sensitivity flags from the Director's 审核合规规则 red-line map
- For video: the locked cut/brief; for carousel: the image inventory

## Two hard rules

1. **Compliance is applied here, but owned by the Director.** Before finalizing any wording, apply the Director's 审核合规规则 (absolute-language list, 加密货币/金融/医疗/政治, 引战词, and the 身份/移民 red-line map with its safe-rewrite table). When a topic is flagged sensitive, use the 模糊化 rewrites — never spell out the sensitive noun. The authoritative ruleset lives in `../../SKILL.md`; this skill does not redefine it.
2. **Everything final passes the humanizer gate** (`humanizer/SKILL.md`) before it goes back to the Director.

---

## Title formulas (use one, never invent random)

Pick ONE formula. All titles must embed the primary search keyword in the **first 1/3** of the title, be **≤ 20 characters** when possible, contain **0–2 emojis**, and avoid absolute-language words (see the Director's avoidance list).

### Formula 1 — 反差 / Contrast (highest performer for lifestyle vlogs)
Pattern: `[反差情境]｜[反预期动作或结果]`

Examples:
- `家里停电了 我跑去 Hyatt 大堂打工🪫`
- `月薪三千 住进五星级酒店`
- `辞职去萨尔瓦多 父母以为我流落街头`

### Formula 2 — 数字 / Numeric
Pattern: `[数字]+[具体名词]+[钩子]`

Examples:
- `3 个去萨尔瓦多前必须知道的事`
- `30 刀的拉美牛排到底什么水平`

### Formula 3 — POV / Roleplay
Pattern: `POV：[角色/场景]`

Examples:
- `POV：你是萨尔瓦多打工人`
- `POV：在中美洲过一个普通工作日`

### Formula 4 — 疑问 / Curiosity
Pattern: `[小众事物]+到底+[问号/反问]`

Examples:
- `中美洲的小国家到底什么样`
- `没人来的国家是什么体验`

### Formula 5 — 共鸣 / Empathy
Pattern: `原来+[反认知洞察]`

Examples:
- `原来海外打工 也不轻松`
- `原来在拉美 也能很安全`

---

## Body structure template

```
[钩子句 ≤ 30 字 - 反差/共鸣/疑问]

[场景设置 1–2 句 - 重复主关键词 1 次]

——

📍[场景 1 标签]
[信息增量 + 个人感受]

📍[场景 2 标签]
[信息增量 + 个人感受]

📍[场景 3 标签]
[信息增量 + 个人感受]

——

[Punchline 反认知洞察 / 对比反差]
（这是文案的灵魂——读者能从这一段获得"哦原来如此"的认知）

[互动钩 - 评论引导，要具体可答的问题]
[关注钩 - 给一个继续关注的理由]
```

### Critical body rules

- **第一句 ≤ 30 字**：第一行是 feed 预览，决定点击率
- **断行多**：每 1–2 句换行，移动端阅读节奏要快
- **主关键词在前 100 字内出现 2–3 次**（自然出现，不堆砌）
- **避免直接复述视频**：内容必须有视频里没有的"增量信息"（背景、对比、感想）
- **emoji ≤ 8 个**：节制使用，每个 emoji 都要有锚点功能（地点用 📍、情绪用 🥲 等）
- **结尾必有具体问题** + **必有关注引导**

---

## Photo-carousel mode（图文轮播模式）

Use this mode when the deliverable is a Xiaohongshu image/carousel note. This skill owns the full copy layer: platform title, cover headline/subtitle, per-slide text, body caption, tags, comment/follow CTA. Visual tools (`xhs-image`, `hyperframes`) render the cover and carousel but must treat this copy as source of truth.

### Carousel structure

Recommended length: **5–9 images**. If the user provides fewer images, keep the structure shorter instead of padding.

1. **Cover image**: one clear promise or contradiction; max 2 text layers
2. **Context slide**: why this note exists / who it is for
3. **Value slides**: 3–6 pages, one idea per page
4. **Save/share slide**: checklist, route, price, key takeaways, or comparison
5. **Engagement slide**: one concrete question + follow reason

### Cover text rules

- Main headline: **8–14 Chinese characters** when possible
- Subtitle: optional, **≤ 16 Chinese characters**
- Cover text and platform title should **not be identical**. Cover optimizes CTR; title also carries search keywords.
- Put the strongest concrete noun on the cover: place / price / mistake / route / day count / before-after.
- Avoid absolute words from the avoidance list. Do not use "必看", "最全", "天花板", "封神", "王炸".

Good cover patterns:
- `[地点/人群]+真实体验`
- `[数字]+个避坑/发现/瞬间`
- `我以为 X，结果 Y`
- `[具体物品/路线/费用]+到底值不值`

### Per-slide text rules

- Slide title: **≤ 12 Chinese characters**
- Slide body: **≤ 28 Chinese characters** per text block
- One slide = one point. Do not cram caption paragraphs onto images.
- Every slide should add information, not just label the photo.
- Use numbers, route names, prices, timestamps, sensory details, and personal judgment.
- Last slide must ask a concrete question that invites a longer comment.

### Caption rules for carousel

The body caption should **not repeat every slide**. It should provide:

1. Why this carousel matters
2. Extra context not visible in the images
3. One 反认知 / personal insight
4. A specific comment question
5. A follow reason if this is part of a series

Carousel notes have lower "完播" dependence than video, but stronger save/share potential. Optimize for **收藏** by making the last 1–2 slides useful as a checklist or decision aid.

---

## 观点/叙事型图文模式（观点文 / 情绪文 / 经历文）

Use this mode for personal-opinion, emotional, or narrative image-text notes — 个人感悟、心态转变、海外 / 职场 / 留学经历、价值观输出。这是海外生活、留学、职场、人生选择赛道的**主力爆款形态**，和 Photo-carousel mode（信息 / 攻略 / 清单）写法完全不同：

- **轮播图文**靠"收藏"起量（清单、攻略、对比、避坑）
- **观点 / 叙事图文**靠"共鸣 → 评论 / 转发"起量（说出受众心声）

配图通常 1–4 张（人物 / 场景 / 纯色大字），正文是核心。

### 观点/叙事文 vs 轮播文 怎么选
| 你手里的东西 | 用哪个模式 |
|---|---|
| 攻略、清单、路线、价格、对比、避坑 | Photo-carousel mode |
| 感悟、心态转变、一个观点、一段经历、价值观 | 观点/叙事型图文模式（本节）|

### 标题（观点文倾向）
观点文最吃 **共鸣式（Formula 5 原来…）** 和 **反差式（Formula 1）**。
- ✅ `在硅谷待了14年 我终于不焦虑了`
- ✅ `30+ 才想明白的一件事`
- ✅ `原来不是所有人都要往上爬`

关键词仍要在前 1/3；敏感选题用模糊词（见 Director 的赛道红线地图），不明示。

### 正文结构（观点/叙事文模板）
```
[共鸣钩 ≤ 30 字 — 说出受众心里那句话 / 一个反差场景]

[场景或背景 1–2 句 — 把读者带入"我也是这样"]

——

[转折或冲突 — 你以为 X，结果 / 直到 Y]

[真实细节 — 具体的人、事、数字、对话，越具体越戳]

——

[反认知 punchline — 这段是灵魂，给"哦原来如此"的认知]
（观点文的转发 / 收藏全靠这一段能不能让人"想分享给某人"）

[评论钩 — 具体可答的问题，最好是"邀请讲自己的故事"]
[关注钩 — 给一个继续看下去的理由 / 系列感]
```

### 观点/叙事文 critical rules
- **第一行就是观点或冲突**，不要铺垫（feed 只露第一行）
- **写"我"的真实细节，不写道理**：道理谁都会讲，细节才有共鸣
- **punchline 要"可被转发"**：读者会不会想 @ 给某个朋友？这是观点文能不能爆的唯一标准
- **评论钩邀请故事**：`你有没有过类似的瞬间？` 比 `你怎么看？` 更能引出长评
- **慎碰敏感叙事**：身份 / 移民 / 政治 / 婚恋 / 收入这类，先过 Director 的红线地图
- emoji ≤ 5：观点文 emoji 越少越显真诚

---

## Tag strategy

发 8–15 个标签，按这四类分配：

| 类别 | 数量 | 作用 | 示例 |
|---|---|---|---|
| 主搜索词 | 2–3 | 搜索曝光主力 | `#萨尔瓦多 #ElSalvador` |
| 场景/身份词 | 2–3 | 锁定目标用户 | `#海外打工人 #数字游民` |
| 大流量品类 | 2–3 | 蹭推荐流量 | `#vlog日常 #海外生活` |
| 长尾词 | 2–3 | 蓝海搜索 | `#小众目的地 #中美洲` |

**禁止**：在 tag 里放敏感词（见 Director 的审核合规规则）。Tag 是平台审核重点扫描区。

---

## 互动钩模板（CES 优化）

CES 公式里 评论×4 / 关注×8，所以每条笔记必须双钩齐发。

### 评论钩（4× 权重）—— 必须是"具体可答"的问题
- ❌ "大家觉得怎么样？" （太泛，引出短评）
- ✅ "你最近一次松弛感是什么时候？" （引出长评故事）
- ✅ "想看哪个国家的打工日常？评论区告诉我" （引出具体关键词）
- ✅ "猜猜这顿牛排多少钱？" （引出数字猜测，回复率高）

### 关注钩（8× 权重）—— 必须给"继续关注"的理由
- ✅ "关注我 一个个拍给你看🧳"
- ✅ "正在更新海外打工系列 关注追更"
- ✅ "下条拍 XXX，关注我别错过"

### 完播钩（影响晋级池）—— 在开头埋"看完才知道"
- ✅ "墙上那个 B 是什么？看完整条应该懂🙊"
- ✅ "结尾有惊喜"
- ✅ "第三个场景我整个人愣住了"

---

## Copy output templates

Return copy in the matching template. The Director assembles these into the final `post.md` / bundle.

### Copy only (no production)

```markdown
# 小红书发布文案

## 封面建议
[一句话描述选哪一帧 + 是否加大字 + 推荐用什么动效（hyperframes / 静态）]

## 标题（3 选 1）
1. [标题方案 A，标注用的是哪个 Formula]
2. [标题方案 B]
3. [标题方案 C]

## 正文（复制到正文框）
[完整正文，按 body template 写]

## 标签（一次性粘贴）
#标签1 #标签2 ... #标签N

## 发布建议
- 时间：[具体建议]
- 前 30 分钟操作：[具体动作]
- 避雷检查：[确认没有的敏感词]
```

### Photo-carousel copy

```markdown
# 小红书图文轮播文案

## 轮播定位
[受众 + 搜索关键词 + 这组图解决什么问题]

## 平台标题（3 选 1）
1. [标题方案 A，标注用的是哪个 Formula]
2. [标题方案 B]
3. [标题方案 C]

## 封面文案
主标题：[8–14 字]
副标题：[≤16 字，可选]
视觉备注：[建议选哪张图 / 大字放哪 / 是否需要贴纸或箭头]

## 每页图上字
P1 封面：[主标题] / [副标题]
P2 [页标题]：[图上短文案]
P3 [页标题]：[图上短文案]
P4 [页标题]：[图上短文案]
P5 [页标题]：[图上短文案]
P6 收藏页：[清单/路线/价格/总结]
P7 互动页：[具体问题 + 关注理由]

## 正文（复制到正文框）
[完整正文，不逐页复述，补充背景 + 洞察 + 评论钩 + 关注钩]

## 标签（一次性粘贴）
#标签1 #标签2 ... #标签N

## 发布建议
- 时间：[具体建议]
- 互动问题：[最后一页和正文保持一致]
- 避雷检查：[确认没有的敏感词]
```

### Opinion / narrative note（观点/叙事文）

```markdown
# 小红书观点/叙事文文案

## 选题定位
[受众 + 这条想引发的共鸣 / 想说的那个观点 + 是否触及敏感选题（如触及，说明已做的模糊化处理）]

## 标题（3 选 1）
1. [标题方案 A，标注用的是哪个 Formula]
2. [标题方案 B]
3. [标题方案 C]

## 封面建议
[选哪张图 / 是否纯色大字 + 封面大字写什么（共鸣句或反差句）]

## 正文（复制到正文框）
[完整正文，按「观点/叙事文模板」写：共鸣钩 → 背景 → 转折 → 真实细节 → punchline → 评论钩 + 关注钩]

## 标签（一次性粘贴）
#标签1 #标签2 ... #标签N

## 发布建议
- 时间：[具体建议]
- 互动问题：[邀请讲自己故事的具体问题]
- 避雷检查：[确认没踩敏感词 + 红线地图，列出做了哪些模糊化替换]
```

---

## Mandatory humanizer gate

Before returning any final copy to the Director, run it through **`humanizer/SKILL.md`** — strip AI flavor, public-account tone, and generic marketing copy. This applies to titles, cover text, captions, body, scripts, voiceover, carousel page text, first comments, and interaction prompts. Do not skip this gate.
