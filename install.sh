#!/usr/bin/env bash
# Install the EXTERNAL companion skills referenced by xhs-workflow.
#
# Bundled skills (xhs-workflow itself, xhs-copy + its humanizer, xhs-image)
# already ship in this repo and need NO install.
#
# This script only fetches the third-party skills that live upstream:
#   - video-use      (browser-use)  -> video edit / transcribe / burn-in subtitles
#   - hyperframes    (heygen-com)   -> HTML video / cover / motion / transitions (+ adapters)
#
# Bring-your-own capabilities (imagegen / presentations) are NOT installable; supply your own.
set -euo pipefail

SKILLS_DIR="${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}"
mkdir -p "$SKILLS_DIR"

info() { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skip]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }

# --- video-use ---------------------------------------------------------------
if [ -d "$SKILLS_DIR/video-use/.git" ] || [ -f "$SKILLS_DIR/video-use/SKILL.md" ]; then
  ok "video-use already present at $SKILLS_DIR/video-use"
elif command -v git >/dev/null 2>&1; then
  info "Cloning video-use into $SKILLS_DIR/video-use ..."
  git clone https://github.com/browser-use/video-use "$SKILLS_DIR/video-use"
  ok "video-use cloned. Next: open a chat in that folder and run video-use/install.md"
  ok "(it wires up ffmpeg + the ElevenLabs API key)"
else
  warn "git not found — install git, then re-run, or clone video-use manually."
fi

# --- hyperframes ecosystem ---------------------------------------------------
if [ -f "$SKILLS_DIR/hyperframes/SKILL.md" ]; then
  ok "hyperframes already present at $SKILLS_DIR/hyperframes"
elif command -v npx >/dev/null 2>&1; then
  info "Installing hyperframes (+ adapters: gsap, animejs, three, …) ..."
  info "Requires Node.js >= 22 and FFmpeg on PATH."
  npx skills add heygen-com/hyperframes
  ok "hyperframes ecosystem installed."
else
  warn "npx (Node.js) not found — install Node.js >= 22, then run: npx skills add heygen-com/hyperframes"
fi

echo
ok "Done. Bring-your-own image generation (imagegen / xhs-image rendering)"
ok "needs an image-editing model you supply — recommended: Codex + GPT-5.5."
