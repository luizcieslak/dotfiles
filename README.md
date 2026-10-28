# dotfiles

My dotfiles.

**Current OS:** Ubuntu 22.04 / macOS

Files added:

- .zshrc
- hyper config
- prettier
- install.sh (Ubuntu only)
- install-macos.sh (macOS): Homebrew packages, oh-my-zsh, nvm + Node LTS,
  pnpm/yarn, safe-chain, Miniforge (conda), atuin, z, Docker Desktop and the
  React Native toolchain (JDK 17, Android SDK + emulator, watchman, CocoaPods,
  Xcode checks). Safe to re-run; steps needing your password or Apple ID are
  printed at the end with the command to run.
- Claude Code config (`.claude/settings.json` + hand-authored skills)

## Skills

`.claude/skills` is the single source for Claude Code, Codex and `.agents`
skills. `copy.sh` copies it to `~/.claude/skills` and symlinks each skill into
`~/.codex/skills` and `~/.agents/skills` (existing folders there are moved to
`*.bak/`). Existing `~/.claude/settings.json` is never overwritten.

To pull skills installed on the current machine back into the repo, run
`sh export-skills.sh`. It deduplicates by name, skips built-in and
plugin-provided skills, and never overwrites a skill already in the repo.

## Credits

Most of the skills under `.claude/skills` were pulled from
[mcollina/skills](https://github.com/mcollina/skills).
