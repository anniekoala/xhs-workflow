# xhs-workflow

[English](https://github.com/anniekoala/xhs-workflow/blob/main/README.md) · **中文**

一套个人的小红书（RED / Little Red Book）内容工作流 —— 一个 Agent Skill，把原始视频、想法、草稿或照片，整理成可直接发布的标题、封面、正文、标签和大纲，自带文案与视觉两道质量闸门。

它把一句平铺的"写文案 prompt"升级成一个完整的工作流路由：

- 原始视频 → 剪辑方向 → 标题 / 封面 / 文案
- 一个松散的想法 → 内容角度 → 大纲 / 素材清单
- 草稿文案 → 结构与语气打磨
- 照片 / 截图 → 轮播结构与每页文案
- 已发布数据 → 限流诊断与下一条的修正

## Agent 结构

这套是 **1 个 Director + 多个专职子 Agent** 的结构。**Director（总指挥）就是大脑**（`SKILL.md`）。它自己不写文案、不画图，只负责：路由请求、掌管平台策略 + 合规 + 发布，然后把文案**派发**给 `xhs-copy`、把视觉 / 视频派发给生产子 Agent，并用两道强制质量闸门把关它们的产出。

```
              ┌──────────────────────────────────────────────┐
              │  DIRECTOR — xhs-workflow / SKILL.md           │
              │  入口路由 · 平台策略                           │
              │  合规红线 · 发布检查 · 两道闸门                │
              └───────────────────┬──────────────────────────┘
                                  │  派发
                                  │  （先跑依赖自检）
        ┌───────────────┬─────────┴────────┬──────────────────┐
        ▼               ▼                  ▼                  ▼
  ✍️ xhs-copy      🖼️ xhs-image       🎬 video-use      🎞️ hyperframes
   标题/正文/       封面：编辑真实      原始素材 →        HTML 视频 /
   标签/钩子        照片 或 从零生成     剪辑 + 烧字幕      封面单帧 /
   + humanizer      （内置）            （外部）          动效（外部）
   （内置）
        │               └──────────────────┴──────────────────┘
     文案闸门                        视觉闸门
 (xhs-copy/humanizer)            (rules/visual-rules.md)

  + 自备图像模型（imagegen 类）才能真正把封面渲染出来
```

| 角色 | Agent | 是否内置 | 推荐模型 | 干什么 |
|---|---|---|---|---|
| **Director（总指挥）** | `xhs-workflow`（`SKILL.md`） | 内置 | 任意 | 路由、平台策略、合规、发布、闸门 |
| 文案子 Agent | `xhs-copy` | 内置 | 任意 | 全部文案：标题、正文、轮播 / 观点文、标签、钩子 + humanizer **文案闸门** |
| 图像子 Agent | `xhs-image` | 内置 | **Codex + GPT-5.5**（编辑模式） | 封面——编辑**真实照片**（保真五官）或从零生成 |
| 视频子 Agent | `video-use` | 外部（`./install.sh`） | 任意 + FFmpeg | 剪素材、转写、烧字幕 |
| 动效 / 视觉子 Agent | `hyperframes`（+ 适配器） | 外部（`./install.sh`） | 任意 + Node ≥ 22 | HTML 视频、封面单帧、动效、转场 |

**两道强制闸门**

- **文案闸门** —— 所有最终的标题 / 正文 / 标签 / 文案 / 首评都要过 `dependencies/xhs-copy/humanizer/SKILL.md`（由 `xhs-copy` 执行）。
- **视觉闸门** —— 所有最终的封面 / 轮播 / 视频画面都要过 `rules/visual-rules.md`。

**依赖自检（preflight）** —— 在派发给任何子 Agent 之前，Director 会先检查它装没装。**没装就不会闷头失败、也不会伪造产出**，而是告诉你卡在哪、引导你去安装或替换。协议和注册表见 `rules/dependencies.md`。

> 文案层（标题、正文、标签、轮播 / 观点文、诊断）是**自包含的**——clone 下来不用装任何外部东西就能用。只有视频 / 视觉生产那几个子 Agent 需要额外安装上面的技能。

## 什么时候触发

装好后，当你提出以下需求时，agent 会自动套用这套：

- 小红书标题、文案、正文、标签
- 把 vlog / 照片集 / 文章改成小红书格式
- 观点 / 情绪 / 经历类图文
- "为什么我的笔记没流量" / 限流诊断
- 平台规则：什么会被推荐、什么吸引人、什么会触发限流 / 审核合规 / 最佳实践
- 小红书内容策略

## 里面有什么

- **入口路由**：原始视频、想法、草稿、照片 / 截图、诊断、从零规划
- **内置 `xhs-copy` 子 Agent**：掌管全部文案生产，内含 humanizer 闸门降 AI 味、降公众号腔、降通用营销味
- **视觉质量规则** + 可扩展的视觉技能注册表
- **2026 CES 公式**（点赞×1 + 收藏×1 + 评论×4 + 转发×4 + 关注×8）及其打法含义
- **分层冷启动闸门**（1 小时 CTR、3 小时完播率、3–9 天长尾、10 天+ 搜索）
- **内容推荐规则**：什么会被推、什么会被压、什么更吸引人
- **5 个标题公式** + 示例位
- **正文模板**："钩子 → 增量信息 → punchline → CTA"
- **三条生产线**：视频笔记、信息轮播（图文轮播）、观点 / 叙事型图文，各有模板
- **标签策略**：主搜索 / 场景身份 / 大流量品类 / 长尾 四类分配
- **审核合规规则**：静默限流怎么运作、敏感词避雷清单、身份 / 移民选题的红线地图 + 安全改写表、薯条 / 0 曝光判违规指南
- **互动钩模板**：针对 4× / 8× 的 CES 权重优化
- **token 友好的视频流程**：精简素材索引 → 锁定 brief → 一版预览 → 批量反馈 → 发布打包
- **沙盒回退方案**：受限沙盒里（无 GPU、精简 ffmpeg）跑视频——工作区内 venv、CPU `faster-whisper`、`imageio-ffmpeg` 烧字幕 + HDR→SDR 校色
- **发布前检查清单**、**输出模板**、**限流诊断决策树**
- **依赖自检**（`rules/dependencies.md`）：对生产子 Agent 的自检 + 引导安装

## 这套工作流里的技能

### ✅ 内置（仓库自带，clone 即用）

| 技能 | 作用 |
|---|---|
| `xhs-workflow`（本仓库） | Director：路由 + 策略 + 合规大脑 |
| `dependencies/xhs-copy/` | 全部文案生产（标题/正文/标签/钩子）+ humanizer 文案闸门 |
| `dependencies/xhs-image/` | 小红书封面——编辑真实照片 或 从零生成。首选 **Codex + GPT-5.5** 跑，见其 `README.md` |

### 🔵 外部——用 `./install.sh` 安装（或手动）

| 能力 | 技能 | 安装 |
|---|---|---|
| 视频剪辑 / 转写 / 烧字幕 | `video-use` | `git clone https://github.com/browser-use/video-use`，再跑它的 `install.md` |
| HTML 视频 / 封面 / 动效 / 转场 | `hyperframes`（+ 适配器：`gsap`、`animejs`、`three`…） | `npx skills add heygen-com/hyperframes`（需 Node ≥ 22 + FFmpeg） |

### 🟡 自备（无固定公开来源）

| 能力 | 技能 | 说明 |
|---|---|---|
| 文生图 / 参考图编辑 | `imagegen` | 用你手上任意图像模型 / MCP。`xhs-image` 要靠它才能真正出图 |
| 多页卡片排版 | `presentations` | 或退回用 `hyperframes`，或只给每页文案 + 排版备注 |

### 一条命令装好外部技能

```bash
./install.sh   # clone video-use + 安装 hyperframes 生态
```

## 安装

### 作为个人 Cursor 技能（推荐）

```bash
# clone 或下载这个文件夹后：
mkdir -p ~/.cursor/skills
ln -s "$(pwd)/xhs-workflow" ~/.cursor/skills/xhs-workflow
```

或者直接复制：

```bash
cp -r xhs-workflow ~/.cursor/skills/
```

### 作为项目级技能

```bash
mkdir -p .cursor/skills
cp -r xhs-workflow .cursor/skills/
```

## 验证是否加载

新开一个 Cursor 对话，问"帮我写一条小红书"。agent 应该引用这套技能的模板（标题公式、CES 考量等），而不是给泛泛的文案建议。

## 更新

小红书算法经常变。当平台规则更新时：

1. 让 agent 跑一句类似 "search for latest Xiaohongshu algorithm updates, update SKILL.md if rules changed"
2. 对照文档里的 CES 公式、冷启动闸门、敏感词清单
3. 直接改 `SKILL.md`

## License

个人使用，自由改用。
