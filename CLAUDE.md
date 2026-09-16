# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles for a Linux (Gentoo) workstation, managed by a custom **PHP-templating + symlink** script — not GNU stow, not a bare git repo, no submodules.

## The pipeline

`src/` (templates, tracked) → `php` → `out/` (generated, gitignored) → symlinks in `$HOME`.

```bash
./sync.sh   # the only command; runs from any cwd
```

`sync.sh` does four things: `rm -rf out/*`, recreate `src/`'s directory tree under `out/`, render **every** file in `src/` through the `php` CLI, then create symlinks per the `links` manifest.

Consequences to respect:

- **Never edit `out/` or the dotfiles in `$HOME`** — both are regenerated/wiped by `sync.sh`. Edit `src/` and re-run `./sync.sh`.
- Every `src/` file is piped through `php`, including pure-config ones. A literal `<?` anywhere in a config would be eaten as a PHP open tag.
- `sync.sh` requires `php` on PATH.
- The link step only writes when the target is already a symlink or missing (`[ -h ... ] || [ ! -e ... ]`), so it never clobbers a real file in `$HOME`. Corollary: if a target exists as a regular file, the link is silently skipped.
- Paths in `src/` mirror `$HOME` minus the leading dot (`src/config/sway/config` → `~/.config/sway/config`, `src/gitconfig` → `~/.gitconfig`), but the mapping is **not** inferred — a new file only gets linked once it is added to `links` as `<path-relative-to-src> <target>`.

## Per-host configuration

Host-specific config is inlined with PHP alternative-syntax conditionals, evaluated at render time on the machine running `sync.sh`:

```php
<?php if (gethostname() === "leopardus"): ?>
font_size 8.0
<?php else: ?>
font_size 12.0
<?php endif ?>
```

Two hosts in use:

- **`felis`** — laptop: battery/backlight modules, `eDP-1`, wifi (`wlan0`/`wlp4s0`), `nm-applet`.
- **`leopardus`** — desktop: multi-monitor (`DP-1`/`DP-2`/`HDMI-A-1`/`HDMI-A-2`), ethernet (`br0`/`enp5s0`), smaller fonts, `/tmp/maxmati` ramdisk.

Used in `src/config/sway/config`, `src/config/waybar/config`, `src/config/kitty/kitty.conf`, `src/config/fish/config.fish`, `src/i3/config`, `src/i3status.conf`. When adding a host-specific setting, extend the existing `if`/`elseif` chain in place rather than adding a separate block. `misc/misc.php` defines `hasHostname()` but is dead code — templates call `gethostname()` directly and nothing includes it.

## Layout

- **Wayland (current):** `src/config/sway/config`, `src/config/waybar/config`, `src/config/kitty/kitty.conf`
- **X11 (legacy, still tracked & linked):** `src/i3/config`, `src/i3status.conf`, `src/xmonad/xmonad.hs` (Haskell), `src/xmobarrc`, `src/stalonetrayrc`
- **Shell / misc:** `src/config/fish/config.fish` (keychain, PATH, `fish_prompt`), `src/config/pulse/daemon.conf`, `src/ssh/config`
- **Git:** `src/gitconfig`, `src/gitignore_global`

`src/gitconfig` is the user's live global git config (identity, GPG signing key, `commit.gpgsign`, `format.signoff`, rebase-by-default, `insteadOf` rules for work remotes). Changes there affect how the user's commits are made everywhere — treat it as high-blast-radius.

Sway/i3 `$mod` is `Mod4` (Super); keyboard layout is `pl`. Configs invoke external tools that must exist on the host: `swaylock`, `swayidle`, `swaymsg`, `grim`, `slurp`, `wl-copy`, `j4-dmenu-desktop`, `pactl`, `pavucontrol`, `keychain`, `user-suspend`/`user-hibernate`, `xdg-user-dir`.

## Verifying a change

There are no tests. To check a template change:

```bash
php src/config/sway/config          # render in isolation, inspect output
./sync.sh                           # full re-render + relink
swaymsg reload                      # or restart the affected tool
```

Since `sync.sh` renders for the *current* hostname only, a change guarded for the other host cannot be verified locally beyond reading the rendered output — say so rather than claiming it was tested.

## Commits

Single-line subjects, 2–6 words, sentence-capitalized, imperative, no trailing period, no conventional-commit prefixes or scopes, no bodies ("Add waybar", "Felis config", "Fix leopardus monitor setup"). Commits are GPG-signed and `format.signoff` is on, so `git commit` adds a `Signed-off-by` trailer automatically.
