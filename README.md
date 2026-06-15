# xhs-workflow

**English** · [中文](https://github.com/anniekoala/xhs-workflow/blob/main/README.zh.md)

A personal Xiaohongshu (小红书 / RED / Little Red Book) content workflow — an Agent Skill that routes raw video, ideas, drafts, or photos into ready-to-publish titles, covers, captions, tags, and outlines, with built-in copy & visual quality gates.

It upgrades a flat "copywriting prompt" into a full workflow router:

- raw video → edit direction → title / cover / caption
- loose idea → content angle → outline / material list
- draft copy → structure and voice edit
- photos / screenshots → carousel structure and page copy
- published data → diagnostics and next-post fixes

## Agent structure

This skill is a **Director + specialist sub-agents** setup. The **Director** is the brain (`SKILL.md`). It never writes the copy or renders pixels itself — it routes the request, owns platform strategy + compliance + publishing, and **delegates** copy to `xhs-copy` and visuals/video to the production sub-agents, gating every output through two mandatory quality checks.

```
              ┌──────────────────────────────────────────────┐
              │  DIRECTOR — xhs-workflow / SKILL.md           │
              │  intake routing · platform strategy           │
              │  compliance red-lines · publishing · 2 gates  │
              └───────────────────┬──────────────────────────┘
                                  │  delegates
                                  │  (after dependency preflight)
        ┌───────────────┬─────────┴────────┬──────────────────┐
        ▼               ▼                  ▼                  ▼
  ✍️ xhs-copy       🖼️ xhs-image       🎬 video-use      🎞️ hyperframes
   titles/body/      covers: edit a     raw footage →     HTML video /
   tags/hooks        real photo OR      cut + burn-in     cover frame /
   + humanizer       generate fresh     subtitles (ext)   motion (ext)
   (bundled)         (bundled)
        │               └──────────────────┴──────────────────┘
    copy gate                       visual gate
 (xhs-copy/humanizer)            (rules/visual-rules.md)

  + bring-your-own image model (imagegen-class) to actually render covers
```

| Role | Agent | Ships | Best model | Job |
|---|---|---|---|---|
| **Director** | `xhs-workflow` (`SKILL.md`) | bundled | any | Routing, platform strategy, compliance, publishing, gates |
| Copy sub-agent | `xhs-copy` | bundled | any | All copy: titles, body, carousel/opinion, tags, hooks + the humanizer **copy gate** |
| Image sub-agent | `xhs-image` | bundled | **Codex + GPT-5.5** (edit mode) | Covers — edit a **real photo** (identity-preserving) or generate one from scratch |
| Video sub-agent | `video-use` | external (`./install.sh`) | any + FFmpeg | Cut footage, transcribe, burn-in subtitles |
| Motion / visual sub-agent | `hyperframes` (+ adapters) | external (`./install.sh`) | any + Node ≥ 22 | HTML video, cover frame, motion, transitions |

**Two mandatory gates**

- **Copy gate** — every final title / body / tag / caption / first comment passes `dependencies/xhs-copy/humanizer/SKILL.md` (run by `xhs-copy`).
- **Visual gate** — every final cover / carousel / video visual passes `rules/visual-rules.md`.

**Dependency preflight** — before delegating to any sub-agent, the Director checks whether it is installed. If it is missing, the Director tells you what's blocked and guides you through installing or substituting it — it never fails silently or fakes the output. Protocol and registry: `rules/dependencies.md`.

> The text layer (titles, body, tags, carousel/opinion copy, diagnostics) runs **standalone** — clone the repo and it works with no external install. Only the video/visual production sub-agents need the extra skills above.

## When it applies

When this skill is installed, your agent applies it automatically whenever you ask for:

- Xiaohongshu titles, captions, body copy, or tags
- Adapting a vlog / photo set / article into 小红书 format
- An 观点 / 情绪 / 经历类图文 (opinion or narrative note)
- "Why is my post not getting views" / 限流 diagnostics
- Platform rules: what gets recommended, what is engaging, what triggers limits / 审核合规 / best practices
- Content strategy for 小红书

## What's inside

- **Intake router** for raw video, ideas, drafts, photos/screenshots, diagnostics, and from-scratch planning
- **Bundled `xhs-copy` sub-agent** owning all text production, with a humanizer gate that strips AI flavor, public-account tone, and generic marketing copy
- **Visual quality rules** and an extensible visual skill registry
- **2026 CES formula** (点赞×1 + 收藏×1 + 评论×4 + 转发×4 + 关注×8) and its tactical implications
- **Tiered cold-start gates** (1h CTR, 3h 完播率, 3–9d long tail, 10d+ search)
- **Content-recommendation rulebook**: what gets pushed vs suppressed, and what makes content engaging
- **5 title formulas** with example slots
- **Body template** for the "hook → 增量信息 → punchline → CTA" structure
- **Three production tracks**: video notes, information carousels (图文轮播), and opinion/narrative image-text notes (观点/叙事型图文), each with its own template
- **Tag strategy** split across search / scene / category / long-tail
- **Audit-compliance ruleset**: how silent 限流 works, the sensitive keyword avoidance list, a niche red-line map for identity/immigration topics with a safe-rewrite table, and a 薯条 / 0-exposure limit-detection guide
- **Engagement hook templates** optimized for the 4× / 8× CES weights
- **Token-aware video workflow**: compact asset index → lock brief → one preview → batched feedback → publish bundle
- **Sandbox workaround**: running the video pipeline in a restricted sandbox (no GPU, minimal ffmpeg) via in-workspace venv, CPU `faster-whisper`, and `imageio-ffmpeg` for libass subtitle burn-in + HDR→SDR color
- **Pre-publish checklist**, **output templates**, and a **diagnostic decision tree** for 限流 / shadow-banned accounts
- **Dependency preflight** (`rules/dependencies.md`): self-check + guided install for the production sub-agents

## Skills in this workflow

### ✅ Bundled (ship in this repo, clone = ready)

| Skill | What it does |
|---|---|
| `xhs-workflow` (this repo) | Director: routing + strategy + compliance brain |
| `dependencies/xhs-copy/` | All copy production (titles/body/tags/hooks) + humanizer copy gate |
| `dependencies/xhs-image/` | 小红书 covers — edit a real photo or generate from scratch. Best run in **Codex + GPT-5.5** — see its `README.md` |

### 🔵 External — install with `./install.sh` (or by hand)

| Capability | Skill | Install |
|---|---|---|
| Video edit / transcribe / burn-in subtitles | `video-use` | `git clone https://github.com/browser-use/video-use`, then run its `install.md` |
| HTML video / cover / motion / transitions | `hyperframes` (+ adapters: `gsap`, `animejs`, `three`, …) | `npx skills add heygen-com/hyperframes` (needs Node ≥ 22 + FFmpeg) |

### 🟡 Bring-your-own (no fixed public source)

| Capability | Skill | Note |
|---|---|---|
| Image generation / reference-image edit | `imagegen` | Use whatever image model/MCP you have. `xhs-image` needs one of these to actually render |
| Multi-page card layout | `presentations` | Or fall back to `hyperframes`, or deliver per-slide copy + layout note |

### One-command install of external skills

```bash
./install.sh   # clones video-use + installs the hyperframes ecosystem
```

## Installation

### As a personal Cursor skill (recommended)

```bash
# Clone or download this folder, then:
mkdir -p ~/.cursor/skills
ln -s "$(pwd)/xhs-workflow" ~/.cursor/skills/xhs-workflow
```

Or just copy:

```bash
cp -r xhs-workflow ~/.cursor/skills/
```

### As a project skill

```bash
mkdir -p .cursor/skills
cp -r xhs-workflow .cursor/skills/
```

## Verifying it loaded

Open a new Cursor chat and ask "帮我写一条小红书". The agent should reference this skill's templates (title formulas, CES considerations, etc.) instead of generic copywriting advice.

## Updating

The 小红书 algorithm changes frequently. When platform rules update:

1. Re-run the agent with a prompt like "search for latest Xiaohongshu algorithm updates, update SKILL.md if rules changed"
2. Compare to the documented CES formula, cold-start gates, and sensitive keyword list
3. Edit `SKILL.md` directly

## License

Personal use. Adapt freely.
