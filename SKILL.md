---
name: xhs-workflow
description: Personal Xiaohongshu (小红书 / RED / Little Red Book) workflow skill for consistent content production across agents and computers. Use whenever the user asks for Xiaohongshu strategy, raw-video-to-post work, idea development, draft editing, photo/screenshot carousel planning, titles, cover text, captions, scripts, tags, first comments, publishing bundles, or post diagnostics. First route the request by input type, then follow the matching workflow. Mandatory gates: final copy must pass the bundled humanizer-xhs workflow, and final visual deliverables must pass the visual quality workflow. Preserves the existing XHS strategy rules for platform-tuned titles, body templates, tags, sensitive wording, pre-publish checks, diagnostics, and staged video production.
---

# XHS Workflow Skill

This is the project-level source of truth for producing Xiaohongshu content in Annie's `xhs` workspace.

It owns the workflow, copy strategy, publishing checks, and delegation map. It does not need to force every step through a separate skill. Instead, it uses two mandatory quality gates:

1. **Copy gate**: every final title, cover text, caption, script, first comment, carousel text, and post copy must pass `dependencies/humanizer-xhs/SKILL.md`.
2. **Visual gate**: every final cover, carousel image, title card, subtitle style, or video visual package must pass `rules/visual-rules.md`.

The existing XHS strategy rules below are retained as the platform/copy rulebook. Use them after routing the user's input.

---

## Intake router

Before doing any work, classify what the user already has. Do not force every request through ideation.

| Input type | Route |
|---|---|
| Raw video or rough edit | Raw Video Workflow |
| A loose idea / topic / feeling | Idea Workflow |
| Draft copy | Draft Editing Workflow |
| Photos / screenshots | Photo & Screenshot Workflow |
| Published post data | Diagnostics / Review Workflow |
| Nothing concrete yet | From-Scratch Planning Workflow |

If the input is ambiguous, ask one concise question to identify the route.

### Raw Video Workflow

If the user provides or references raw video, do not start with title or caption. The video itself comes first.

1. Understand the footage: what happens, usable moments, emotional tone, weak moments.
2. Extract the strongest theme.
3. Choose the presentation format: lifestyle vlog, tutorial, review, recommendation, story, contrast, opinion, or behind-the-scenes.
4. Give editing recommendations: opening 0-3 seconds, keep/cut moments, subtitle beats, pauses, zooms, arrows, B-roll gaps, voiceover needs, target length, BGM mood.
5. Wait for or confirm the edited direction.
6. Generate title candidates based on the confirmed cut.
7. Generate cover text.
8. Create or design the cover image.
9. Write the post caption.
10. Generate hashtags, first comment, and interaction prompt.
11. Run the copy gate, visual gate, and pre-publish checklist.

### Idea Workflow

When the user only has an idea, the goal is to turn it into a presentable content angle before drafting.

1. Identify the target reader and pain point.
2. Judge whether the idea is worth a post.
3. Choose the content type: tutorial, list, mistake/avoidance, comparison, experience, review, narrative, or opinion.
4. Define the core claim or emotional point.
5. Decide whether it should be video, photo carousel, or text-led note.
6. Produce an outline and a shot/photo/material list.
7. Then continue into title, cover, copy, tags, and checks.

### Draft Editing Workflow

When the user provides draft copy, preserve their intent and improve it.

1. Check whether the theme is clear.
2. Fix structure and paragraph order.
3. Strengthen the opening and rhythm.
4. Make the voice more natural and less generic.
5. Add title, cover text, tags, first comment, and interaction prompt if needed.
6. Run the copy gate before delivery.

### Photo & Screenshot Workflow

When the user provides photos or screenshots, build the carousel around the images instead of inventing unrelated copy.

1. Identify what each image can communicate.
2. Sort or group images by story/value.
3. Design the carousel page structure.
4. Write cover text and per-page copy.
5. Write the body caption, tags, first comment, and interaction prompt.
6. Run the copy gate, visual gate, and pre-publish checklist.

### Diagnostics / Review Workflow

When the user provides published post data, diagnose before rewriting.

1. Identify the likely bottleneck: topic, title, cover, opening, completion, save value, comments, compliance, or account consistency.
2. Separate evidence from guesses.
3. Suggest the smallest useful changes for the next post.
4. If editing an existing draft, run the relevant route above.

### From-Scratch Planning Workflow

Only use this when the user has no existing idea, media, draft, or data.

1. Clarify content pillar and target reader.
2. Generate a compact set of post ideas.
3. Pick the best angle.
4. Continue through the Idea Workflow.

---

## Mandatory copy gate

Before delivering final Xiaohongshu copy, read and apply:

`dependencies/humanizer-xhs/SKILL.md`

This applies to platform titles, cover text, captions, body copy, video scripts, voiceover, carousel page text, first comments, and interaction prompts.

If the current agent supports skills, it may install or activate a humanizer skill. If not, it must read the bundled `dependencies/humanizer-xhs/SKILL.md` and apply the rules manually. Do not skip this gate because a specific external skill is unavailable.

---

## Mandatory visual gate

Before delivering final visual assets, read and apply:

`rules/visual-rules.md`

Use `rules/visual-skills.md` to decide which visual skills or tools are available and appropriate. The visual tool may render assets, but this workflow remains the source of truth for title, cover text, post copy, and publishing checks.

---

## When to apply

Apply automatically when the user:
- Asks for Xiaohongshu / 小红书 / RED post copy, 文案, 笔记, 标题, 标签
- Wants to adapt a vlog, photo set, screenshot set, travel album, or article into Xiaohongshu format
- Mentions 图文轮播 / 图文笔记 / 轮播图 / 封面文案 / 每页小字 / carousel
- Wants an 观点 / 情绪 / 感悟 / 经历类图文（personal-opinion or narrative note）
- Asks "why no views" / "limited traffic" / 限流 diagnostics
- Asks about platform rules: 什么会被推荐 / 什么吸引人 / 违禁项 / 审核合规 / best practice
- Asks for content strategy for Xiaohongshu

Do **not** apply for: other platforms (Douyin, Instagram, TikTok, Twitter/X). Those have different algorithms and conventions.

---

## Companion skills (delegation map)

This skill owns **strategy** (what to write, why, how to dodge limits). It does **not** own production execution. When the user supplies raw materials, delegate to the right companion skill:

| User intent | Skill to invoke | Why |
|---|---|---|
| Cut raw footage into a finished vlog | `video-use` | Transcript-driven cuts, automatic ffmpeg orchestration, subtitle SRT generation |
| Burn subtitles into the video | `video-use` | Xiaohongshu does **not** support sidecar SRT — subtitles must be hardcoded |
| Design cover with big title text | `xiaohongshu-photo-cover` if available, otherwise `hyperframes` + `animejs` / `gsap` | Visual rendering only; this skill owns title, cover text, and caption copy |
| Produce photo-carousel page copy | **This skill** | Cover headline, slide titles, page body, caption, and tags are copy strategy, not visual production |
| TikTok / Xiaohongshu-style word-by-word captions | `hyperframes` | Built-in template for word-level karaoke captions; this style is trending in 2026 |
| Animated lower-thirds, location pins, kinetic text | `gsap` / `animejs` / `waapi` | Pick by complexity — `waapi` for simple, `gsap` for timeline-heavy |
| 3D opening title or volumetric scene | `three` / `typegpu` | Heavy; use only for premium one-off content |
| Style any HTML overlay (cover, end-card) | `tailwind` | Standard utility classes |
| Convert an existing Remotion project to web-native motion | `remotion-to-hyperframes` | Edge case; mention only if user already has Remotion code |

**Default production pipeline** when user provides raw footage + a brief:

Use a token-aware staged workflow. Do not jump straight into full scripting, rendering, and publishing unless the user explicitly says the direction is already locked.

1. **Light inventory** → invoke `video-use` only far enough to create a compact source index: file names, durations, 1-line visual description, likely use, and 2-3 possible content directions. Prefer a 10-line `shotlist.md` plus targeted key frames over broad frame dumps.
2. **Lock the brief** → ask the user to confirm the narrative arc, voiceover/script direction, target length, must-keep moments, must-cut moments, subtitle style, and BGM mood. Treat these as hard constraints once confirmed.
3. **Cut one preview** → delegate to `video-use` to produce a first preview and subtitle backup. Keep generated logs, EDL, SRT, and verification output in `scratch/<note>/`, but only read the specific ranges needed for the current decision.
4. **Batch feedback** → ask the user for 3-5 concrete changes per review round. Aim for 2-3 preview iterations before publishing. For ambiguous visual fixes, extract/inspect 3-5 frames before rendering another full preview.
5. **Cover + copy** → once the cut is approved, create cover candidates and generate `post.md` using this skill's title/body/tag templates.
6. **Bundle output** → place upload-ready assets in `published/<note>/`; keep transcripts, segment renders, previews, frame dumps, and other intermediate files in `scratch/<note>/`

Token discipline for video projects:

- Do not repeatedly read full `edl.json`, full SRT files, large terminal output, or entire project logs. Read only the relevant lines/ranges unless doing a final audit.
- Let local tools (`ffmpeg`, `ffprobe`, render scripts) process video/audio bytes. The model should reason from short summaries, targeted frames, scripts, and user feedback.
- If the user asks for a fast or low-cost pass, skip full contact sheets, animation experiments, and extra cover/BGM variants until the base cut is approved.

**Default production pipeline** when user provides photos/screenshots + a brief:

1. **Copy strategy** → use **Photo-carousel mode** in this skill to produce cover text, per-slide text, body, and tags
2. **Cover/carousel visuals** → delegate visual rendering to `xiaohongshu-photo-cover` if available, otherwise `hyperframes`
3. **Bundle output** → place rendered images + `post.md` in `published/<note>/`; keep design drafts and generated intermediates in `scratch/<note>/`; do not let the visual tool invent separate title/body copy

If the user only asks for copy (text only), skip visual production and produce the relevant output template alone.

---

## Sandbox 环境下的生产 workaround（sandbox-adapted）

在受限沙盒里跑视频生产时，默认流程会被三类限制卡住：**网络白名单、无 GPU、系统工具精简**。按下面的回退方案处理。核心原则：**所有依赖装进工作区内的 venv**（沙盒通常只允许写工作区），跑通后留在 `scratch/<note>/` 里可复用，不必每次重踩。

### 限制 → 解法

1. **网络只有白名单** → 云端转写 / 模型下载常被拦（403 / ProxyError）。
   - 不要依赖云端 ASR（如 ElevenLabs Scribe）。改用**本地、离线、已缓存模型**。

2. **没有 GPU** → `mlx-whisper` 等 Metal/CUDA 方案会崩（如 `NSRangeException`，拿不到 GPU 设备）。
   - 转写改用 **`faster-whisper`（CPU / CTranslate2）**，离线加载本地缓存模型。慢一点但稳定、不挑环境。

3. **系统 ffmpeg 精简** → Homebrew 等构建常缺 `libass`（烧字幕的 `subtitles` 滤镜）和 `zscale`（HDR 色彩转换），且全局 `pip install` 受限。
   - `pip install imageio-ffmpeg`（装进 venv），它**自带一个完整静态编译的 ffmpeg 二进制**，含 `libass`/`subtitles`/`zscale`/`tonemap`。
   - 之后所有渲染命令**用该二进制的绝对路径**，不要用系统 `ffmpeg`：
     `<venv>/lib/pythonX.Y/site-packages/imageio_ffmpeg/binaries/ffmpeg-<platform>-vN.N`
   - 上手前先验证：`<ffmpeg> -hide_banner -filters | grep -E "subtitles|zscale"`，两个都在才用。

### 关键能力解锁

- **烧字幕**：有 libass 后直接用 `subtitles=master_zh.ass`（原生、快）。
  - 应急回退（确实没有 libass 时）：用 Pillow 把每句字幕渲染成透明 PNG 再 `overlay` 叠回。能出片，但几十层叠加非常慢，只在拿不到完整 ffmpeg 时用。
- **iPhone HDR 校色**：iPhone 素材常是 HLG HDR（`arib-std-b67` / `bt2020`）。不转换的话在 SDR 屏上会过饱和（用户会形容成"滤镜感"）。在抽帧/切片阶段用 zscale+tonemap 转成 Rec.709 SDR：
  ```
  zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p
  ```

### 建立可复用环境（一次）
```bash
python3 -m venv scratch/<note>/wenv
scratch/<note>/wenv/bin/pip install faster-whisper imageio-ffmpeg
```
转写脚本与产物（如 `fw_run.py`、`*_transcript.json`）留在 `scratch/<note>/`，下个视频直接复用。

### 何时跳过这套
不在沙盒、系统 ffmpeg 已含 `libass`+`zscale`、且有可用 GPU/网络时，按主流程走即可，无需 venv 回退。这一节只在受限环境触发时启用。

---

## Core 2026 platform model (3 facts agent must know)

### 1. CES scoring formula (the only formula that matters)

```
CES = 点赞×1 + 收藏×1 + 评论×4 + 转发×4 + 关注×8
```

Implications:
- **Comments and follows are 4–8× more valuable than likes.** Every post must include a comment-prompting question AND a follow-prompting CTA.
- 无意义评论（"哈哈"、"好棒"、"不错"、"顶"）不计入 CES. Engagement bait must invite specific, longer replies.
- Likes/saves alone are not enough to escape the small-pool ceiling.

### 2. Tiered cold-start (赛马模型, 2026 Q2 update)

| Stage | Duration | Gate | Unlocks |
|---|---|---|---|
| 初审池 Initial | 1 hour | CTR ≥ 4% (video) / 2.5% (image) | ~1K impressions |
| 晋级池 Promotion | 3 hours | 完播率 ≥ 40% + healthy CES | ~10K+ impressions |
| 长尾池 Long-tail | 3–9 days | Search performance | Steady stream |
| 搜索池 Search | 10+ days | Keyword matching | Long-term tail |

The first 3 hours decide everything. Optimize title, cover, and first 3 seconds for CTR/完播.

### 3. 搜推互通 Search-recommendation coupling

- Search and recommendation share the same scoring graph
- Strong search performance reinforces recommendation push, and vice versa
- **Tactical consequence**: keywords must live in the first 1/3 of the title and appear 2–3 times in the first 100 characters of the body

Also relevant: **流量平权** — accounts under 1K followers get equal initial pool access. Account size is not the bottleneck; content compliance is.

---

## 内容推荐规则（什么会被推荐 / 什么更吸引人）

把上面的机制翻译成产出时能直接用的判断。这是用户问"什么内容会被推荐 / 什么更吸引人"的标准答案区。

### 什么内容会被推荐（顺算法）
- **受众标签清晰**：一眼能被机器归类（地点 / 人群 / 场景 / 身份），标签越清晰越好推
- **选题有搜索量**：标题和正文命中真实被搜的关键词（搜推互通，搜索强 → 推荐强）
- **高互动结构**：结尾有具体可答的问题 + 关注理由（评论×4、关注×8 是 CES 主力）
- **高完播 / 高收藏**：信息型图文靠"可收藏"（清单 / 路线 / 价格），观点型图文靠"共鸣到想转发"
- **账号垂直稳定**：同一账号持续发同一赛道，标签越纯，每条起量越快

### 什么内容会被压（逆算法，即使不违规也没量）
- **标签模糊**：机器不知道推给谁（泛泛的"分享生活 / 记录日常"）
- **纯复述**：只描述画面或经历，没有视频 / 图片之外的增量信息
- **无互动设计**：没有问题、没有关注钩，CES 上不去
- **标题 / 封面无钩**：初审池 CTR 不达标（图文 2.5%），1 小时就出局
- **操作扣权重**：频繁删改、同内容重发判重、蹭不相关热点

### 什么内容更吸引人（点击 + 停留 + 互动）
- **反差**：标题或封面制造预期落差（见 Title Formula 1）
- **共鸣**：说出受众"想说却没说出口"的那句话（观点 / 情绪文的核心武器）
- **信息增量**：让人"哦原来如此"，有收藏价值
- **具体 > 形容词**：数字、价格、地名、时间、真实细节，永远比"很美 / 很棒"有效
- **钩子前置**：第一行（feed 预览）和封面大字承担约 90% 的点击决策

---

## Title formulas (use one, never invent random)

Pick ONE formula. All titles must embed the primary search keyword in the **first 1/3** of the title, be **≤ 20 characters** when possible, contain **0–2 emojis**, and avoid absolute-language words (see avoidance list).

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

Use this mode when the deliverable is a Xiaohongshu image/carousel note rather than a video note. This skill owns the full copy layer:

- Platform title
- Cover headline/subtitle
- Per-slide text
- Body caption
- Tags
- Comment/follow CTA

Visual tools (`xiaohongshu-photo-cover`, `hyperframes`, design apps) may render the cover and carousel, but must treat this skill's copy as source of truth.

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
3. One反认知 / personal insight
4. A specific comment question
5. A follow reason if this is part of a series

Carousel notes have lower "完播" dependence than video, but stronger save/share potential. Optimize for **收藏** by making the last 1–2 slides useful as a checklist or decision aid.

### Photo-carousel copy template

```markdown
## 图文轮播文案

### 平台标题（3 选 1）
1. [标题 A - 搜索关键词在前 1/3]
2. [标题 B]
3. [标题 C]

### 封面文案
主标题：[8–14 字]
副标题：[可选，≤16 字]
视觉备注：[主体/构图/大字位置]

### 每页图上字
P1 封面：[主标题] / [副标题]
P2 [页标题]：[≤28 字页面文案]
P3 [页标题]：[≤28 字页面文案]
P4 [页标题]：[≤28 字页面文案]
P5 [页标题]：[≤28 字页面文案]
P6 收藏页：[清单/路线/价格/总结]
P7 互动页：[具体问题 + 关注理由]

### 正文（复制到正文框）
[完整正文，按 carousel caption rules 写]

### 标签（一次性粘贴）
#标签1 #标签2 ... #标签N
```

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

关键词仍要在前 1/3；敏感选题用模糊词（见「审核合规规则」的赛道红线地图），不明示。

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
- **慎碰敏感叙事**：身份 / 移民 / 政治 / 婚恋 / 收入这类，先过「审核合规规则」的红线地图
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

**禁止**：在 tag 里放敏感词（见下方避雷清单）。Tag 是平台审核重点扫描区。

---

## 审核合规规则（违反即限流）

### 审核机制怎么运作（先理解再避雷）
小红书审核是**静默的**：违规内容通常不报错、不提示，直接降权或 0 曝光。两个早期信号能判断有没有踩线：

- **薯条（付费推广）被拒** → 提示"不符合薯条推广规范"，说明内容已命中敏感标签（薯条审核比自然流量更严）。这是最强的"内容违规"信号。
- **发布后整天 0 曝光**（不是低，是 0）→ 基本是审核卡住或内容级静默限流，而不是"内容不够好"。

发布前，**逐项扫描标题、正文、tag、封面大字**：

### 一票否决类（绝对化用语，2026 严打）
最 / 第一 / 全网最低 / 完爆 / 碾压 / 必看 / 永远 / 唯一 / 顶级 / 神级 / 王炸

替换思路："完爆" → "比 X 好很多"；"必看" → "推荐看看"；"最 X" → "我觉得 X 很 ..."

### 加密货币（强敏感，**直接限流**）
比特币 / Bitcoin / 加密货币 / 加密 / 币圈 / 链上 / Web3 / 数字货币 / NFT / 区块链 / DeFi / 挖矿

替换思路：完全删除或改写为"当地货币文化"等模糊措辞。如果是萨尔瓦多比特币法币这类话题，可用"看完整条视频应该懂"的钩子绕过明示。

### 金融 / 医疗 / 政治（强敏感）
炒股 / 理财 / 保本 / 包治 / 神药 / 维权 / 抗议 / 体制 / 翻墙

### 引战 / 极端
血亏 / 智商税 / 倾家荡产 / 完蛋 / 离谱 / 韭菜 / 收割

### 平台禁词
微信 / 加我 / 私信我 / 联系方式（含联系方式会被判违规）

### AI 生成内容
任何 AI 生成内容必须在发布时勾选"AI 生成"标签，否则限流。

### 赛道红线地图（身份 / 移民 / 海外，重点）
海外生活 / 留学 / 职场赛道最容易踩的是**政治-移民擦边**。这类词机器会归到敏感标签，**不报违规直接 0 曝光**。

强敏感（标题 / 正文 / tag 都别明示）：
绿卡 / 移民 / 移民倾向 / 身份（指居留身份）/ 入籍 / 国籍 / 润 / 政治庇护 / 体制 / 国家认同 这类去留叙事

能写 vs 不能写：
| ❌ 容易限流的写法 | ✅ 安全的模糊改写 |
|---|---|
| 放下对绿卡的执念 | 放下了一个执念 / 不再追一个"标准答案" |
| 留美14年 / 移民身份焦虑 | 在国外待了很多年 / 那种悬着的感觉 |
| 该不该润 / 要不要移民 | 要不要留下来 / 去和留之间 |
| tag 写 #绿卡 #移民 | tag 写 #海外生活 #心态 #30岁 等中性词 |

模糊化原则：**把敏感名词换成"那张卡""一个东西""一个答案"等指代，真正的意思留给评论区和懂的人。** 标题靠"看完才懂"的钩子承载，绝不明示。

> 案例（2026-06）：一条「留美14年后…放下对绿卡的执念」图文，整天 0 曝光 + 薯条判违规。情绪和文笔都没问题，纯粹是"绿卡 / 移民"选题踩线。重发把身份框架换成"心态 / 松弛感"即可。

### 自查工具
5118、灰豚、千瓜 都可以查违禁词。拿不准的选题先用模糊词发，别赌。

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

## 发布时机与冷启动

### 黄金发布时间
- 周二 / 周三 / 周日 **19:00–21:00**
- 次选：周一 / 周四 12:00–13:00（午休）
- 避开：周五晚 + 周六全天（用户在外不刷）

### 发布后前 30 分钟必做
1. 让 3–5 个朋友点开看完，**不要只点赞**，要留长评 + 关注
2. 自己用其他账号留 1 条长评（不是水评）
3. 不要急着删除编辑（每次删改都扣账号权重）

### 第 3 天 / 第 7 天看数据
- 曝光 < 100：账号权重问题，不是这条笔记的问题，需养号
- 曝光 200–500：内容定位问题，关键词模糊
- 曝光 3K–5K：内容有价值但互动不足
- 曝光 1W+：进入人工审核观察期，加大互动引导

---

## Pre-publish checklist

发出去前对照这个清单，全部 ✅ 才能发：

```
标题
- [ ] 主关键词在前 1/3 位置
- [ ] ≤ 20 字
- [ ] 0–2 个 emoji
- [ ] 不含绝对化用语
- [ ] 不含敏感词

正文
- [ ] 第一句 ≤ 30 字 且 是钩子
- [ ] 前 100 字内主关键词出现 2–3 次
- [ ] 有信息增量（不只是描述画面）
- [ ] 至少 1 个 punchline 反认知洞察
- [ ] 至少 1 个评论钩（具体可答）
- [ ] 至少 1 个关注钩
- [ ] emoji ≤ 8
- [ ] 不含敏感词清单中的任何词
- [ ] 不含绝对化用语

标签
- [ ] 8–15 个
- [ ] 四类分布合理
- [ ] 不含敏感词

视频与封面（如适用）
- [ ] 字幕**烧录**进视频（Xiaohongshu 不支持外挂 SRT — 用 `video-use` 烧字幕）
- [ ] 封面 3:4 或 1:1，主体清晰，标题大字（用 `hyperframes` 渲染单帧）
- [ ] 视频前 3 秒有完播钩（开头悬念 / 矛盾 / 数字 / 提问）
- [ ] 视频总时长建议 1–2 分钟（小红书 vlog 甜区）
- [ ] 中长视频（>5 分钟）默认横屏，享 90 天推荐期

图文轮播（如适用）
- [ ] 封面主标题 8–14 字，副标题 ≤16 字
- [ ] 平台标题和封面标题不完全重复
- [ ] 每页只讲 1 个点，图上字不超过两层
- [ ] 倒数 1–2 页有可收藏信息（清单 / 路线 / 价格 / 对比）
- [ ] 最后一页有具体评论问题 + 关注理由

发布操作
- [ ] 周二/三/日 19:00–21:00
- [ ] 朋友前 30 分钟互动准备好
- [ ] 没有重复发布同一视频（算法判重）
```

---

## Output format

### When user wants copy only (no production)

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

### When user wants photo-carousel copy

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

### When user wants an opinion / narrative image-text note（观点/叙事文）

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

### When user wants full production (raw footage → publishable bundle)

Produce, in this exact order:

1. **Compact asset index** (not a full edit): source files, durations, 1-line visual descriptions, likely best use, and 2-3 possible directions.
2. **Plan summary** (3–5 bullets): selected direction, narrative arc, target duration, must-keep/must-cut moments, cover/BGM concept.
3. **Confirm with user** before any rendering. Ask the user to lock the voiceover/script and hard constraints.
4. **Delegate to `video-use`** → produce one preview + `subtitles.srt` backup. Avoid reading full generated artifacts unless needed for a specific fix.
5. **Iterate in batches** → user gives 3-5 concrete changes; target 2-3 preview rounds total.
6. **Generate cover candidates + `post.md`** after the cut is approved. Use the copy-only template above for title/body/tags.
7. **Final bundle** placed in `published/<note>/`, with intermediate work in `scratch/<note>/`:
   ```
   published/<note>/
   ├── final.mp4        ← upload-ready: subtitles burned in, BGM mixed when appropriate
   ├── final_no_bgm.mp4 ← backup when practical
   ├── cover.png        ← 3:4 or 1:1 cover
   ├── post.md          ← title + body + tags + 发布建议
   └── subtitles.srt    ← backup, in case user wants to edit in 剪映

   scratch/<note>/
   └── ...              ← transcripts, previews, segment renders, frames, drafts
   ```

The user uploads `final.mp4` + `cover.png` to Xiaohongshu and pastes `post.md` into the caption fields.

---

## Diagnostic mode (限流诊断)

如果用户报告"没流量 / 限流"，按以下树形决策：

1. **是新发的笔记？**（< 24h）
   - 曝光 < 50 → 大概率账号级限流 → 进入养号流程
   - 曝光 100–500 → 内容标签模糊 → 重新查关键词布局
   - 显示"审核中" → 等 6–12 小时再看
2. **历史多条笔记都低流量？**
   - 账号级限流，需养号 5–7 天：
     - 主动浏览 30 分钟/天
     - 给同行长评论 5–10 条
     - 关注 5–10 个垂直博主
     - 发 1–2 条纯安全内容（无敏感词）
     - 7 天后再发主推内容
3. **某条曾经爆款，现在掉量？**
   - 检查最近是否发了违规内容触发账号扣分
   - 检查是否频繁删除/编辑历史笔记
4. **这条薯条推广被拒（"不符合薯条推广规范"）？**
   - 实锤内容级敏感：薯条审核比自然流量严，被拒 = 已命中敏感标签
   - 配合"整天 0 曝光"基本确诊内容违规 → 别改这条（救不回还扣权重），按红线地图去敏感化**重发**
5. **检查工具**：5118、灰豚、千瓜 都可以查违禁词

---

## Best practices（产出前必读，正向清单）

把"会被推荐 + 吸引人 + 不违规"压缩成正向动作。下面是该做的；不该做的见 Anti-patterns。

**选题**
- 选有搜索量 + 受众清晰的角度；敏感选题先过红线地图再写
- 一条只讲一个点，别贪多

**标题 + 封面**
- 关键词放前 1/3；用一个 Title Formula，别即兴
- 第一行 / 封面大字承担点击，制造反差或共鸣
- ≤20 字，0–2 emoji，无绝对化用语、无敏感词

**正文**
- 第一句就是钩子（≤30 字）；多断行
- 给画面 / 经历之外的增量信息；至少 1 个反认知 punchline
- 双钩齐发：具体可答的评论钩（4×）+ 给理由的关注钩（8×）

**合规**
- 发布前逐项扫避雷清单 + 红线地图
- AI 生成内容勾选"AI 生成"标签；不放联系方式

**运营**
- 周二 / 三 / 日 19–21 点发
- 前 30 分钟让朋友留长评 + 关注，别只点赞
- 别频繁删改、别同内容重发、养号期别发主推内容
- 垂直深耕：同账号持续发同赛道，标签越纯起量越快

---

## Anti-patterns（不要做）

- ❌ 直接复述视频画面（"今天我去了 X，吃了 Y"）—— 必须有视频外的增量
- ❌ 堆砌 emoji（每行都用）
- ❌ 在 tag 里放完整句子（tag 必须是名词短语）
- ❌ 在正文最后放微信号 / 邮箱
- ❌ 用 ChatGPT 直接生成发布前不勾选"AI 生成"
- ❌ 同一视频在不同笔记里反复发（算法判重）
- ❌ 频繁编辑笔记（每次都触发重审 + 扣权重）
- ❌ 在这个 skill 里手写 ffmpeg 命令 / 手动拼接视频 —— 永远先 delegate 给 `video-use`
- ❌ 在这个 skill 里手写 PIL / Canvas 画封面 —— 永远先 delegate 给 `hyperframes` 生态

---

## Quick reference summary

| 维度 | 关键数字 |
|---|---|
| CES 公式 | 点赞×1 / 收藏×1 / 评论×4 / 转发×4 / 关注×8 |
| 1 小时初审池 CTR | 视频 ≥ 4% / 图文 ≥ 2.5% |
| 3 小时晋级池 完播率 | ≥ 40% |
| 标题字数 | ≤ 20 字 |
| 第一句字数 | ≤ 30 字 |
| 轮播封面主标题 | 8–14 字 |
| 轮播每页正文 | ≤ 28 字/块 |
| 前 100 字关键词重复 | 2–3 次 |
| 正文 emoji 总数 | ≤ 8 |
| 标签数量 | 8–15 |
| 黄金发布时段 | 周二/三/日 19:00–21:00 |
| 养号天数 | 5–7 天 |
| 中长视频推荐有效期 | 90 天 |
