# INIT_SESSION

Personal dotfiles and helper scripts for Adam, for macOS and Linux.

## Layout

- `home/`: the chezmoi source folder (`.chezmoiroot` points to it). Files use the chezmoi names, for example `dot_bashrc` becomes `~/.bashrc`.
- `home/dot_bashrc.d/`: shell functions and aliases. `common.sh` is for all systems, `Darwin.sh` is for macOS, `Linux.sh` is for Linux. On this Mac, `~/.bashrc.d/*.sh` are symlinks to these files, so an edit is live after `source`.
- `config/`, `diff/`, `keep/`, `linux/`, `prompts/`, `stress/`, `working/`: older scripts and notes.

## Notes

- `Darwin.sh` has `window_place`, which moves an app window to the top-right corner of the external monitor with `osascript -l JavaScript`. The terminal must have the Accessibility permission. `sgit` (SmartGit, 80% width, full height) and `md` (Typora, 70% width, 90% height) use it.
- After a change to a shell file, run `bash -n <file>` to make sure that the syntax is correct.
