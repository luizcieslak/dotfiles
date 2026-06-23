#!/bin/sh
cp .zshrc ~/.zshrc
mkdir -p ~/.config/Hyper
cp hyper.json ~/.config/Hyper/hyper.json
mkdir -p ~/.hyperinator
cp .hyperinator/*.yml ~/.hyperinator/
cp ssl.conf  ~/.ssl.conf

# Claude Code config + hand-authored skills.
# (The plugin-sourced skills like backpressured are reinstalled from the
# marketplace declared in settings.json, so they are not tracked here.)
mkdir -p ~/.claude/skills
cp .claude/settings.json ~/.claude/settings.json
cp -r .claude/skills/. ~/.claude/skills/

# Codex config + rules.
mkdir -p ~/.codex/rules ~/.codex/skills
cp .codex/config.toml ~/.codex/config.toml
cp .codex/rules/*.rules ~/.codex/rules/

# ~/.agents/skills and ~/.codex/skills are symlinks into ~/.claude/skills.
mkdir -p ~/.agents/skills
for skill in ~/.claude/skills/*/; do
  name=$(basename "$skill")
  ln -sfn "$skill" ~/.agents/skills/"$name"
  ln -sfn "$skill" ~/.codex/skills/"$name"
done