# INIT_SESSION

Personal dotfiles and helper scripts for Adam, for macOS and Linux.

## Layout

- `home/`: the chezmoi source folder (`.chezmoiroot` points to it). Files use the chezmoi names, for example `dot_bashrc` becomes `~/.bashrc`.
- `home/dot_bashrc.d/`: shell functions and aliases. `common.sh` is for all systems, `Darwin.sh` is for macOS, `Linux.sh` is for Linux. On this Mac, `~/.bashrc.d/*.sh` are symlinks to these files, so an edit is live after `source`.
- `config/`, `diff/`, `keep/`, `linux/`, `prompts/`, `stress/`, `working/`: older scripts and notes.
- `keep/` is in `PATH` on the Mac and on the workspace. `keep/aws-sso` gets temporary keys for the company AWS accounts. On Linux, it logs in with `--use-device-code`. On the Mac, `/usr/local/bin/aws-sso` comes first in `PATH`.
- `keep/bastion-tunnel.sh` opens an RDP tunnel to a live Azure VM through Bastion (local port 3333). It takes a full VM resource ID or a short name. For example, `pay4` gives group `rg-vm-live-pay4-aea` and VM `cloud-pay4-1`.
- `home/dot_aws/config` becomes `~/.aws/config` (the company AWS profiles). It holds no keys.

## Notes

- `Darwin.sh` has `window_place`, which moves an app window to the top-right corner of the external monitor with `osascript -l JavaScript`. The terminal must have the Accessibility permission. `sgit` (SmartGit, 80% width, full height) and `md` (Typora, 70% width, 90% height) use it.
- After a change to a shell file, run `bash -n <file>` to make sure that the syntax is correct.
