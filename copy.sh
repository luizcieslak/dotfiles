#!/bin/sh
# Works on Ubuntu and macOS. Safe to re-run.
cd "$(dirname "$0")" || exit 1

# Copy $1 to $2 only if $2 doesn't exist yet (keeps machine-local config).
copy_if_missing() {
  if [ -e "$2" ]; then
    echo "exists, skipped: $2"
  else
    cp "$1" "$2"
  fi
}

# Move a real directory out of the way (into $1.bak/) so a symlink can take
# its place. ln -sfn would otherwise create the link *inside* the directory.
backup_dir() {
  # sh has no locals, so these names must not clash with the caller's.
  _bd_dir="$1"; _bd_name=$(basename "$_bd_dir"); _bd_bak="$(dirname "$_bd_dir").bak"
  [ -d "$_bd_dir" ] && [ ! -L "$_bd_dir" ] || return 0
  mkdir -p "$_bd_bak"
  if [ -e "$_bd_bak/$_bd_name" ]; then
    mv "$_bd_dir" "$_bd_bak/$_bd_name.$(date +%s)"
  else
    mv "$_bd_dir" "$_bd_bak/$_bd_name"
  fi
  echo "backed up: $_bd_dir -> $_bd_bak/"
}

cp .zshrc ~/.zshrc
case "$(uname)" in
  Darwin) HYPER_DIR="$HOME/Library/Application Support/Hyper" ;;
  *) HYPER_DIR="$HOME/.config/Hyper" ;;
esac
mkdir -p "$HYPER_DIR"
cp hyper.json "$HYPER_DIR/hyper.json"
mkdir -p ~/.hyperinator
cp .hyperinator/*.yml ~/.hyperinator/
cp ssl.conf  ~/.ssl.conf

# Claude Code config + hand-authored skills.
# (The plugin-sourced skills like backpressured are reinstalled from the
# marketplace declared in settings.json, so they are not tracked here.)
mkdir -p ~/.claude/skills
copy_if_missing .claude/settings.json ~/.claude/settings.json
cp -r .claude/skills/. ~/.claude/skills/

# Codex config (config.toml, rules) is machine-specific (trusted project
# paths), so it isn't tracked; Codex only gets the skills below.
mkdir -p ~/.codex/skills

# ~/.agents/skills and ~/.codex/skills are symlinks into ~/.claude/skills.
mkdir -p ~/.agents/skills
# Old names of skills now tracked as fastify-best-practices / init-agents-md.
backup_dir ~/.codex/skills/fastify
backup_dir ~/.codex/skills/init
for skill in .claude/skills/*/; do
  name=$(basename "$skill")
  for dir in ~/.agents/skills ~/.codex/skills; do
    backup_dir "$dir/$name"
    ln -sfn "$HOME/.claude/skills/$name" "$dir/$name"
  done
done
