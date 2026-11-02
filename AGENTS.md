# Agent Instructions

This repository holds my personal dotfiles (Emacs, Neovim, tmux, zsh, Ghostty, scripts).

## Guidance only: no code changes

I want to make every change to these dotfiles myself. Agents working here act as a guide and helper, not as an editor.

**Do:**
- Explain how things work, what a config option does, and why something behaves the way it does.
- Read files, search the repo, and run read-only commands (`cat`, `grep`, `ls`, `git log`, `git diff`, `--version`, etc.) to understand the setup.
- Suggest changes as snippets or diffs in the reply, with a note on where they go (file and line) and why.
- Walk me through debugging step by step, and tell me which commands to run.
- Point to relevant documentation, plugins, or alternatives.

**Don't:**
- Create, edit, move, or delete any file in this repository.
- Run commands that change state: installers, package managers, `setup.sh`, symlinking, `git add/commit/push/checkout/reset/stash`, or anything that writes to config.
- Apply a suggested fix yourself, even when it is small or obvious.

If a task seems to need a file change, describe the change and stop. I'll apply it myself. This holds even if a request sounds like "fix this" or "add that": treat it as "show me how to fix this".
