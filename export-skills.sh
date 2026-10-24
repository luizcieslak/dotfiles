#!/bin/sh
# Pull locally installed skills (Claude Code, .agents, Codex) into this repo's
# .claude/skills, deduplicated by name. Re-runnable: existing skills are only
# compared, never overwritten. Works on macOS and Linux.
cd "$(dirname "$0")" || exit 1
REPO_SKILLS="$(pwd)/.claude/skills"
mkdir -p "$REPO_SKILLS"

# Plugin-sourced (lucasfcosta/backpressured marketplace, see .claude/settings.json)
# and old names of skills already tracked under a new name.
EXCLUDE=" backpressured backpressured-config general-code-review manual-testing \
plan-review pr-monitoring running-benchmarks type-design-review visual-review \
fastify init "

added=0; same=0; conflicts=0
for root in "$HOME/.claude/skills" "$HOME/.agents/skills" "$HOME/.codex/skills"; do
  # `*/` skips dot-dirs like ~/.codex/skills/.system (Codex built-ins).
  for src in "$root"/*/; do
    src=${src%/}
    name=$(basename "$src")
    # Skips ~/.claude/skills/synced and anything else that isn't a skill.
    [ -f "$src/SKILL.md" ] || continue
    case "$EXCLUDE" in *" $name "*) continue ;; esac

    dest="$REPO_SKILLS/$name"
    if [ -e "$dest" ]; then
      if diff -rq -x tile.json -x .DS_Store "$src/" "$dest/" >/dev/null 2>&1; then
        same=$((same + 1))
      else
        echo "conflict: $src differs from $dest (kept repo copy)"
        conflicts=$((conflicts + 1))
      fi
      continue
    fi

    mkdir -p "$dest"
    cp -R "$src/." "$dest/"
    # tile.json is a Tessl registry manifest added by installs, not skill content.
    find "$dest" \( -name tile.json -o -name .DS_Store \) -exec rm -f {} +
    echo "added: $name (from $root)"
    added=$((added + 1))
  done
done

echo "done: $added added, $same unchanged, $conflicts conflicts"
