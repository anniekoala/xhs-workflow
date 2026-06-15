# Visual Skills Registry

Use this file to decide which visual skill/tool to call. Update it when Annie collects better visual skills.

**Before calling any tool below, run the dependency preflight in `rules/dependencies.md`** (check it is installed; if missing, guide the user to install or substitute — do not fake the output).

Status: 🔵 Public (installable) · 🟡 Optional/substitutable (no fixed public source).

## Current Preferred Tools

| Need | Preferred skill/tool | Status |
|---|---|---|
| Generate image素材 or background | `imagegen` | 🟡 bring-your-own image model |
| Design multi-page Xiaohongshu carousel cards | `presentations`, or `xhs-image` per photo | 🟢 bundled / 🟡 |
| Cover from a REAL photo (smart retouch + torn-paper outline + doodles + sticker title) | `xhs-image` edit mode (in `dependencies/xhs-image/`): feed the real photo as reference image + its prompt to an image gen/edit tool | 🟢 bundled; needs an image-editing model |
| Cover with NO real face (concept / illustration / big-text) | `xhs-image` generate mode (in `dependencies/xhs-image/`): text-to-image from the brief | 🟢 bundled; needs an image model |
| Video title cards / subtitles / motion package | `hyperframes` | 🔵 `npx skills add heygen-com/hyperframes` |
| Audio transcription / subtitles / voice workflow | `hyperframes-media` or `video-use` if installed | 🔵 / 🔵 |
| Timeline-heavy motion | `gsap` | 🔵 (ships with hyperframes install) |
| Simple browser-native motion | `waapi` or `css-animations` | 🔵 (ships with hyperframes install) |
| 3D / premium visual scene | `three` or `typegpu` | 🔵 (ships with hyperframes install) |

## Rule

Do not let the visual skill invent final copy. The source of truth for title, cover text, caption, and tags is the `xhs-copy` sub-agent (`dependencies/xhs-copy/SKILL.md`).
