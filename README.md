# xiaohongshu-content

A [Cursor Agent Skill](https://cursor.com/docs/agent/skills) for producing 小红书 (Xiaohongshu / RED / Little Red Book) post copy that aligns with the **2026 platform algorithm** — CES scoring, search-recommendation coupling, traffic equality for sub-1K-follower accounts.

When this skill is installed, Cursor will automatically apply it whenever you ask for:
- Xiaohongshu titles, captions, body copy, or tags
- Adapting a vlog / photo set / article into 小红书 format
- An 观点 / 情绪 / 经历类图文 (opinion or narrative note)
- "Why is my post not getting views" / 限流 diagnostics
- Platform rules: what gets recommended, what is engaging, what triggers limits / 审核合规 / best practices
- Content strategy for 小红书

## What's inside

A single `SKILL.md` that encodes:

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
- **Pre-publish checklist**
- **Output format** that produces directly-copy-pasteable content
- **Diagnostic decision tree** for 限流 / shadow-banned accounts

## Installation

### As a personal Cursor skill (recommended)

```bash
# Clone or download this folder, then:
mkdir -p ~/.cursor/skills
ln -s "$(pwd)/xiaohongshu-content" ~/.cursor/skills/xiaohongshu-content
```

Or just copy:

```bash
cp -r xiaohongshu-content ~/.cursor/skills/
```

### As a project skill

Drop this folder into `.cursor/skills/` inside any project:

```bash
mkdir -p .cursor/skills
cp -r xiaohongshu-content .cursor/skills/
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
