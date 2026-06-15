---
name: humanizer-xhs
description: Rewrite Xiaohongshu copy so it sounds like a real person, not AI, a public account, or a generic marketing script. Use as the mandatory copy gate for titles, cover text, captions, scripts, carousel text, first comments, and interaction prompts.
---

# Humanizer XHS

Use this after drafting Xiaohongshu copy and before delivering it.

## Goal

Make the copy sound like Annie's natural Xiaohongshu voice:

- specific
- observant
- lightly personal
- not over-polished
- not generic
- not public-account style
- not AI-summary style
- not hard-selling unless the user explicitly wants commercial copy

## Rewrite Rules

1. Keep the meaning, but remove generic AI phrasing.
2. Replace broad claims with concrete details.
3. Prefer lived experience over abstract advice.
4. Allow first person when it fits.
5. Use shorter paragraphs for mobile reading.
6. Keep the opening direct. Do not warm up with "今天想和大家聊聊".
7. Avoid fake intimacy: "姐妹们听我说", "家人们", "真的绝了" unless the user has explicitly chosen that voice.
8. Avoid public-account transitions: "首先", "其次", "最后", "综上", "值得注意的是".
9. Avoid generic platform bait: "干货满满", "建议收藏", "保姆级", "必看", "封神", "天花板", "王炸".
10. Do not make every ending a motivational quote.

## Xiaohongshu-Specific Checks

For titles and cover text:

- Shorten aggressively.
- Prefer a clear concrete noun, problem, place, result, or contradiction.
- Cover text and platform title should not be identical.
- Remove bloated adjectives before adding more hooks.

For captions:

- The first line should make sense without context.
- Add context not visible in the video/images.
- Keep one clear point per paragraph.
- End with a specific question, not "你怎么看".

For scripts:

- Make it speakable.
- Remove written-language stiffness.
- Keep pauses where a real person would breathe.

## Output

Return:

1. Final humanized version.
2. Optional short note on what changed if useful.

Do not return a long audit unless the user asks for one.
