# xhs-workflow

A personal Xiaohongshu (小红书 / RED / Little Red Book) workflow skill for producing consistent content across computers, agents, and models.

It preserves the old `xiaohongshu-content` strategy rules, but upgrades the skill into a full workflow router:

- raw video → edit direction → title/cover/caption
- loose idea → content angle → outline/material list
- draft copy → structure and voice edit
- photos/screenshots → carousel structure and page copy
- published data → diagnostics and next-post fixes

It also adds two mandatory gates:

- **Copy gate**: final copy must pass `dependencies/humanizer-xhs/SKILL.md`
- **Visual gate**: final visual assets must pass `rules/visual-rules.md`

When this skill is installed, Cursor will automatically apply it whenever you ask for:
- Xiaohongshu titles, captions, body copy, or tags
- Adapting a vlog / photo set / article into 小红书 format
- An 观点 / 情绪 / 经历类图文 (opinion or narrative note)
- "Why is my post not getting views" / 限流 diagnostics
- Platform rules: what gets recommended, what is engaging, what triggers limits / 审核合规 / best practices
- Content strategy for 小红书

## What's inside

The workflow includes:

- **Intake router** for raw video, ideas, drafts, photos/screenshots, diagnostics, and from-scratch planning
- **Bundled humanizer-xhs dependency** for reducing AI flavor, public-account tone, and generic marketing copy
- **Visual quality rules** and an extensible visual skill registry

- **2026 CES formula** (点赞×1 + 收藏×1 + 评论×4 + 转发×4 + 关注×8) and its tactical implications
- **Tiered cold-start gates** (1h CTR, 3h 完播率, 3–9d long tail, 10d+ search)
- **Content-recommendation rulebook**: what gets pushed vs suppressed, and what makes content engaging (click / dwell / interaction)
- **5 title formulas** with example slots
- **Body template** for the "hook → 增量信息 → punchline → CTA" structure
- **Three production tracks**: video notes, information carousels (图文轮播), and opinion/narrative image-text notes (观点/叙事型图文), each with its own template
- **Tag strategy** split across search / scene / category / long-tail
- **Audit-compliance ruleset**: how silent 限流 works, the sensitive keyword avoidance list (绝对化用语, 加密货币, 金融/医疗/政治, 引战词, AI 生成内容标记), a niche red-line map for identity/immigration topics with safe-rewrite table, and a 薯条 / 0-exposure limit-detection guide
- **Engagement hook templates** optimized for the 4× / 8× CES weights
- **Best-practices checklist** (positive do's across 选题 / 标题 / 正文 / 合规 / 运营)
- **Token-aware video workflow**: compact asset index → lock brief → one preview → batched feedback → publish bundle, so video projects do not waste context on repeated full EDL/SRT/log reads
- **Sandbox workaround**: how to run the video pipeline in a restricted sandbox (network allowlist, no GPU, minimal system ffmpeg) — in-workspace venv, CPU `faster-whisper` fallback, and the `imageio-ffmpeg` bundled full ffmpeg for libass subtitle burn-in + zscale HDR→SDR color
- **Pre-publish checklist**
- **Output format** that produces directly-copy-pasteable content
- **Diagnostic decision tree** for 限流 / shadow-banned accounts

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

Drop this folder into `.cursor/skills/` inside any project:

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

The skill is intentionally a single file so it's easy to keep current.

## License

Personal use. Adapt freely.
