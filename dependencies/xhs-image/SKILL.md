---
name: xhs-image
description: The XHS image/cover sub-agent for the xhs-workflow Director. Produces Xiaohongshu (小红书) cover images and in-post images in two modes — EDIT mode (turn a user's REAL photo into a hit-style cover while preserving their real face/identity) and GENERATE mode (create a cover/image from scratch with text-to-image when there is no real person to preserve). The wording on the image (title/copy) comes from xhs-copy via the Director; this skill owns the image itself. Always route by "is there a real face that must stay the real person?" before choosing a mode.
---

# XHS Image（封面/图像子 Agent）

Makes Xiaohongshu cover images (and in-post images). The **text wording** on the cover comes from `xhs-copy` via the Director; this skill owns the **image**. Final images must pass the visual gate (`../../rules/visual-rules.md`) and, in edit mode, a face-match check.

## ⚠️ Mode router — decide this FIRST

| Situation | Mode | Model type |
|---|---|---|
| There is a **real person** whose identity must stay the real person (the user / a real face) | **EDIT mode** | image **editing** model (image-to-image): nano-banana / Gemini image edit / Codex built-in edit |
| **No real person to preserve** — pure-text cover, illustration, object / food / scene / landscape, or a no-face concept | **GENERATE mode** | text-to-image generator |

**The one rule that overrides everything:** if a real face must stay the real person, you may **only** edit the real photo — **never** generate or redraw the face. Text-to-image will repaint the face into someone who is not them. When in doubt, treat it as EDIT mode and ask the user for a photo.

**首选环境：Codex + GPT-5.5（"Codex 5.5"）** —— 实测出图最好看、人脸最保真。详见 [`README.md`](README.md)。

---

## EDIT mode — real photo → 小红书 cover

把用户的**真实照片**做成小红书爆款封面海报。做法是把**用户照片作为被编辑的输入图**，连同下面这段提示词（填好自定义段）喂给**图像编辑型模型**（nano-banana / Gemini 图像编辑 / Codex 内置编辑等"在原图上修改"的工具）。**不要用文生图/重画整图的生成器**——会把人脸重绘成不像本人。

### 何时用
- 用户给了自己的照片，要做小红书封面或图文封面（基于真实照片）。
- 需要"真实照片 + 智能修图 + 撕纸描边 + 手绘涂鸦互动 + 手写贴纸标题"的小红书封面风格。

### 怎么调用
1. **选对工具**：图像**编辑**型模型。没有这类工具就**先别做**，不要用文生图凑合。
2. **拿到照片**：用户的真实照片（`raw/<note>/`）。
3. **填自定义段**：见下方"用户自定义内容怎么填"。
4. **编辑**：把**用户照片作为被编辑的输入图**，指令 = "编辑这张照片，保持人物/五官/场景不变" + 下面填好的完整提示词。
5. **落盘**：草稿/调试图放 `scratch/<note>/`，最终封面放 `published/<note>/`。
6. **过视觉闸门 + 人脸比对**：对照 `../../rules/visual-rules.md`，并和原图比对确认像本人。

> 这个 IP 是用户本人。"像不像本人"比任何美化都重要。脸保不住就别发——换编辑型模型重做，别交付。

### 基础提示词（逐字模板，勿改风格规则）

> 把末尾"用户自定义内容"的各项填好，再整段发给图像模型。

请基于用户上传的原始照片，生成一张竖版 3:4 的小红书爆款封面风格创意照片海报。

核心目标：保留原照片的真实生活感和人物身份特征，在此基础上完成智能修图、视觉主次强化、手绘涂鸦互动叠加和封面标题设计。画面要真实、有温度、有设计感、有点击吸引力，不能像硬广、课程海报、模板海报或廉价电商图。

请先分析原图，再决定设计方案。重点判断人物表情、姿态、视线方向、服装颜色、背景空间、光线氛围、可留白区域、杂乱区域和最适合放标题的位置。不要机械套模板，所有文字、涂鸦和构图都要基于原图自然生成。

照片修图要求：保留人物真实五官结构、脸型、气质和生活感。适度优化光线、肤色、明暗、肤质、画面洁净度和整体质感。皮肤自然细腻但不能过度磨皮，不能塑料感，不能网红滤镜感，不能棚拍假感。背景可以轻微压暗或虚化，保留环境氛围，让人物脸部、标题和核心涂鸦成为视觉重点。整体形成"主亮副暗"的电影感层次。

构图要求：人物必须是明确主体。如果原图人物表情和姿态有感染力，采用中近景或大特写构图，让人物占画面约 35%-55%；如果原图场景更有叙事感，采用人物较小、环境更完整的氛围封面构图，让人物占画面约 10%-25%。无论哪种方式，都要保证人物突出、标题醒目、背景有呼吸感、画面不拥挤。

人物处理：在人物外轮廓添加自然的白色撕纸描边，让人物像被轻轻抠出后贴在封面上。描边必须轻薄、有手工撕纸感、边缘自然不规则，不能太厚、不能机械、不能像廉价贴纸。

涂鸦互动要求：在真实照片上叠加手绘涂鸦元素。涂鸦可以包括手绘线条、小角色、小物件、贴纸、笔刷、喷绘色块、拟声词、动作线、光环、云团、边角装饰或视觉符号。涂鸦必须与人物的视线、表情、发丝、手势、服装轮廓或环境物体产生互动，不能只是随意贴在空白处。涂鸦数量适中，保留呼吸感，不能堆满画面。

请根据人物气质自动决定涂鸦风格。温柔清新的人物使用轻盈、柔和、精致的涂鸦；自信、张扬、潮流的人物使用更有冲击力的街头感涂鸦；日常生活场景要保留真实感，涂鸦不能压过照片本身。

杂乱区域处理：智能识别照片中分散注意力、不美观或不适合公开展示的区域，用小贴纸、笔刷色块、半透明遮罩、角落图形、小角色或涂鸦边框自然弱化。遮挡要融入整体设计，不能像硬遮挡，不能破坏真实感。

请为画面生成一句短、有记忆点、有点击欲的封面标题。标题必须像为这张照片量身定制，不要像说明文字，不要长句，不要堆砌卖点。标题可以使用中文、英文或中英混合，但必须清晰可读。

标题文字必须采用手写贴纸块风格。每个字单独设计，大小、宽度、高度、角度、位置和字距可以不同。关键词最大、最有视觉重量，辅助字更小、更轻，可以嵌入大字旁边或结构缝隙中。标题整体外轮廓要紧凑，接近圆形、方形或不规则贴纸块，不要做成规整标题栏，不要拉成长斜线。

文字颜色最多 2-3 种。整体低饱和、克制、有质感。关键词可以使用少量奶黄色、浅黄色或低饱和黄绿色作为视觉钩子，辅助字使用白色、奶白色或浅灰白。可以添加轻微深色阴影、暗色细描边或局部半透明底影来增强可读性，但必须克制自然。不要厚重黑描边，不要 3D 字，不要金属字，不要明显发光字，不要高饱和霓虹色，不要大红大紫，不要彩虹色。

如果服装颜色太亮或与标题抢视觉，请适度降低服装饱和度和存在感，但保留真实材质。人物脸部、标题文字和核心涂鸦互动元素必须是前三视觉重点。

输出画面必须满足：真实照片质感清晰，人物不像换脸，五官不变形，文字可读，标题有封面点击感，涂鸦与人物或环境有互动，构图有呼吸感，画面不乱、不廉价、不模板化。

禁止：人物五官变形，过度美颜，塑料皮肤，AI 假脸，文字乱码，标题太长，涂鸦堆满，电商风，综艺高饱和风，厚重描边，硬遮挡杂物，背景完全虚化到失去生活感，画面变成纯插画，人物身份特征被改变。

——————

用户自定义内容：
文章主题：{{文章主题}}
附加口号 / 想加入的文字：{{附加口号}}
整体气质 / 风格方向：{{整体气质}}
核心互动生物或元素：{{核心互动元素}}
图片比例：{{图片比例}}

### 用户自定义内容怎么填

末尾这 5 项**按当前文章自动填**，不要每次都问用户。只有在确实无法从上下文判断时才问。

| 字段 | 怎么定 |
|---|---|
| 文章主题 | 取自当前笔记 / Director brief / 已确认的选题。 |
| 附加口号 / 想加入的文字 | **优先填 xhs-copy 已定的封面标题文字**（让模型按手写贴纸风格排版）；没有就留空，让模型按提示词自拟。 |
| 整体气质 / 风格方向 | 看照片本身的人物气质 + 笔记调性（如"温柔清新治愈" / "自信潮流街头" / "日常真实生活"）。 |
| 核心互动生物或元素 | 按主题给一个具体涂鸦互动主角（如"小猫"、"冲浪板线条"、"小太阳"）；无强需求可留空让模型自决。 |
| 图片比例 | 默认 `竖版 3:4`；用户另有要求再改。 |

---

## GENERATE mode — cover/image from scratch（无真人脸时）

Use this **only when there is no real person to preserve** — pure-text covers, illustrated covers, objects/food/scenes/landscape, or stylized no-face lifestyle. Here it is safe to use a **text-to-image** generator.

### When to use
- 纯文字封面（大字 + 简单背景），不需要真人。
- 插画 / 概念图 / 物品或场景主体（美食、风景、产品、行程图等）。
- 用户明确要"生成一张图"且画面里没有要保真的本人。

### 不要用 GENERATE mode 的情况
- 画面里有用户本人或任何"必须像本人"的真实人脸 → 回到 EDIT mode（只编辑真实照片）。
- 用户只给了真实照片、希望"美化成封面" → EDIT mode。

### 怎么调用
1. **确认无真人保真需求**（否则切回 EDIT mode）。
2. **取文案**：封面大字 / 主标题用 `xhs-copy` 已定的文字，不要自造卖点。
3. **写生成 prompt**：主体 + 风格 + 构图 + 竖版 3:4 + 文字位置/留白；风格沿用小红书审美——真实有温度、低饱和、克制、不模板化、不电商风。
4. **显式锁竖版画布**（见下方"已知坑"）。
5. **落盘 + 过视觉闸门**：草稿放 `scratch/<note>/`，终图放 `published/<note>/`，对照 `../../rules/visual-rules.md`。

### 生成 prompt 风格基线
- 竖版 3:4（1080×1440），主体清晰、留出放大字的呼吸区。
- 低饱和、自然光感、有生活气，不要电商风/综艺高饱和/廉价模板感。
- 文字最多 2–3 色（参考 EDIT mode 的标题配色规则），关键词最大。
- 不要 AI 塑料感、不要乱码文字、不要堆满元素。

---

## 规矩（两模式通用）

- EDIT mode：必须基于用户真实照片，不能改变人物身份特征 / 五官 / 换脸。
- 文字措辞来自 `xhs-copy`，不在这里另造卖点。
- 生成后过视觉闸门再交付；不满足"真实、文字可读、不模板化"就重做。

## 已知坑：强制竖版比例

很多图像工具**会忽略 prompt 里的"竖版 3:4"，默认出横图**。所以：

- 生成/编辑后**先检查输出比例**。不是竖版（3:4 / 4:5）就**重做**（在调用里显式指定竖版画布 / aspect ratio，而不是只靠 prompt 文字），或竖向裁切重排到 3:4。
- 若工具支持画布尺寸参数，直接设 1080×1440（3:4）。
- 横版的封面不要交付——小红书封面一定是竖版。
