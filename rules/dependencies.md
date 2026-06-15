# Dependencies & preflight（依赖自检与引导安装）

This skill is the **Director (routing + strategy + compliance) brain**. Copy and cover production are delegated to **bundled sub-agents** (`dependencies/xhs-copy/`, `dependencies/xhs-image/`). Heavy video/motion production is delegated to **companion skills that do NOT ship inside this repo** (`video-use`, `hyperframes`).

This file is the authoritative dependency registry. When a workflow step needs a companion skill, the agent must run the **preflight protocol** below instead of silently failing or faking the output.

---

## Preflight protocol（agent 必须照做）

When a step is about to delegate to a companion skill (per the delegation map in `SKILL.md` and `rules/visual-skills.md`):

1. **Identify** which companion skill the current step needs.
2. **Check if it is installed.** Look for a directory named `<skill>` that contains a `SKILL.md`, under any of these roots:
   - `~/.cursor/skills/<skill>/`
   - `~/.claude/skills/<skill>/`
   - `~/.codex/skills/<skill>/` (or `$CODEX_HOME/skills/<skill>/`)
   - `~/.agents/skills/<skill>/`
   - project-local `./.cursor/skills/<skill>/`
3. **If installed** → proceed and delegate normally.
4. **If missing** → do **not** fail quietly and do **not** fabricate the production output. Instead:
   a. Tell the user which capability is blocked and why.
   b. Look the dependency up in the registry below.
   c. **If 🔵 Public** → show the exact install command, ask the user for permission, then run it, verify it loaded (re-check step 2), and continue.
   d. **If 🟡 Optional/substitutable** → explain there is no fixed public install; ask the user to either point you at their own equivalent tool, or approve degrading that step to advice-only.
5. **Never block the copy/strategy deliverable** just because a production dependency is missing. Always still deliver titles / body / tags / cover text. Only the production-execution step degrades.

> Reliability note: the agent only "knows" to do this because this protocol is written here. Keep install commands accurate — a wrong command is worse than none.

---

## Dependency registry

Status legend:
- 🟢 **Bundled** — ships in this repo, no install needed
- 🔵 **Public** — open-source, installable with the listed command
- 🟡 **Optional / substitutable** — no fixed public source; treat as a capability the user must supply

| Capability | Skill name(s) | Status | Install / source |
|---|---|---|---|
| 全部文案生产（标题/正文/标签/钩子 + copy gate） | `xhs-copy` | 🟢 Bundled | Ships at `dependencies/xhs-copy/` — no install. Humanizer gate at `dependencies/xhs-copy/humanizer/` |
| 视频剪辑 / 转写 / 烧字幕（raw footage → 成片） | `video-use` | 🔵 Public | `git clone https://github.com/browser-use/video-use`, then follow its own `install.md` (handles ffmpeg + agent registration + ElevenLabs key) |
| HTML 视频合成 / 封面单帧 / 字幕动效 / 转场 | `hyperframes` (+ `hyperframes-cli`, `hyperframes-media`) | 🔵 Public | `npx skills add heygen-com/hyperframes` — requires Node.js ≥ 22 + FFmpeg. CLI is `npx hyperframes`. Apache-2.0 |
| 动效适配器（timeline / 3D / 浏览器原生动画等） | `gsap`, `animejs`, `waapi`, `css-animations`, `three`, `typegpu`, `tailwind`, `lottie`, `remotion-to-hyperframes` | 🔵 Public | Installed together by `npx skills add heygen-com/hyperframes` (same ecosystem) |
| 小红书封面（编辑真实照片 撕纸描边/贴纸标题，或从零生成） | `xhs-image` | 🟢 Bundled | Ships at `dependencies/xhs-image/` — no install. ⚠️ Edit mode needs an **image-editing** model (see `imagegen`); **首选 Codex + GPT-5.5**（保留本人五官、出图最好看，见其 `README.md`）。无编辑型模型时降级为只给封面文案 + 排版备注 |
| 文生图 / 参考图编辑 | `imagegen` | 🟡 Optional | Generic capability, not a fixed package. Use whatever image-generation tool/MCP the user has (nano-banana / Gemini image / etc.). Fallback: skip image generation, deliver cover text + 视觉备注 only |
| 多页图文卡片 / 文字杂志卡 | `presentations` | 🟡 Optional | Generic capability, not installed. Fallback: `hyperframes`, or deliver per-slide copy + layout note only |

---

## Quick install summary（给人看的）

```bash
# 1. Video production (raw footage → finished vlog, burn-in subtitles)
git clone https://github.com/browser-use/video-use ~/.cursor/skills/video-use
# then open a chat in that folder and let the agent run video-use/install.md
# (it wires up ffmpeg + ElevenLabs API key for you)

# 2. HTML video / cover rendering / motion (needs Node.js >= 22 + FFmpeg)
npx skills add heygen-com/hyperframes

# 3. Image generation / cover: bring your own image model (imagegen-class tool).
#    xhs-image is bundled, but its edit mode needs an image-editing model — substitute or skip.
```

If you only want the **copy + strategy** layer (titles, body, tags, carousel/opinion copy, diagnostics), you need **nothing else** — this repo runs standalone for that.
