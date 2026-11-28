# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a "package" whose contents mirror `$HOME`.

## Usage

`.stowrc` sets the target to `~`, so run stow from this directory:

```sh
cd ~/Work/dotfiles
stow bash        # symlink a package into $HOME
stow -D bash     # remove the symlinks
stow -R bash     # restow (after adding/removing files)
```

Or stow everything at once (skips `keyd` and `plymouth`, creates the directories that must stay
real, and reports conflicts without stopping):

```sh
./install.sh             # restow every package
./install.sh bash nvim   # just these
./install.sh -n          # dry run
```

### macOS

```sh
./install_macos.sh               # brew packages + Proton Drive CLI, then restow
./install_macos.sh --stow-only   # just restow (`,dot` runs this on macOS)
./install_macos.sh -n            # dry run
```

Needs [Homebrew](https://brew.sh). Installs bash 5, stow, neovim, tmux, starship, yazi, fzf,
fd, bat, jq, gh, lazygit, Ghostty and the Terminess Nerd Font, plus Proton's official
`proton-drive` CLI (checksum-verified) into `~/.local/bin`, and makes `~/.bash_profile`
source `~/.bashrc`. Stows `bash bin ghostty jdf nvim starship tmux yazi`; skips `keyd`,
`plymouth`, `hypr`, `omarchy-lock`, `omarchy-themes` and the Linux-only scripts in `bin`
(`battery`, `wifi`, `plymouth-ghost`, `mem`, `ports`). The jdf TUIs (`/usr/bin/jdf-*`, Arch
packages) don't exist there: `tmux-main` just leaves those windows as shells, and `pdrive`
(`,pd`) stands in for `jdf-pdrive`. Switch your login shell to Homebrew's bash afterwards
(the script prints the `chsh` line). Without Omarchy, `.bashrc` sets up starship, zoxide and
fzf itself, nvim falls back to `astrodark`, and Ghostty's theme include is simply skipped.

## Packages

- `bash` — `.bashrc` (layered on top of Omarchy's defaults) and `.bash_aliases`
- `bin` — personal scripts in `~/.local/bin` (e.g. `reload-shells`, `ports` — explains what is listening on each port, `mem` — which apps are using memory, `battery` — battery saver: `,battery` / `,battery off` / `,battery status`, `mkpr` — `,pr` opens a pull request for the current branch with a Claude-written title and description, `plymouth-ghost` — installs the `plymouth` boot splash, see below, `pdrive` — `,pd` fzf browser for Proton Drive over the `proton-drive` CLI)
- `jdf` — `~/.config/jdf/usage.toml`, settings for the key-usage logging in `~/Work/apps`
  (on/off, Amplitude region, user id, upload interval). The Amplitude API key is a secret and
  stays out of this public repo: it goes in `~/.config/jdf/amplitude.key`, a real file beside the
  link (`install.sh` keeps `~/.config/jdf` a real directory, and `.gitignore` covers the key).
- `hypr` — Hyprland `bindings.lua` and `looknfeel.lua` (the rest of `~/.config/hypr` stays
  Omarchy-managed). `looknfeel.lua` drops gaps and gives only the focused window a 1px border
  and a soft glow, both in the active theme's `accent` read from `colors.toml` (theme switches
  reload Hyprland, so it recolours itself). Themes with their own window frame (windows-3.1)
  keep Omarchy's border.
- `omarchy-lock` — the `jfolino.lock` shell plugin: Omarchy's lock screen with a different
  design for each theme. `LockView.qml` embeds Omarchy's real lock view (password field,
  fingerprint) with its backdrop made transparent, and loads `themes/<theme-name>.qml` behind
  it, reading the name from `~/.local/state/omarchy/current/theme.name` (watched, so
  `omarchy theme set` swaps it live). Themes without a file get `themes/default.qml`, the
  movie-terminal look (glowing `HH:mm:ss`, prompt header, `[ ACCESS DENIED ]`). Overlays are
  decoration only and take their colours from the theme's `colors.toml` (`lock.pal("red")`),
  with shared bits in `parts/` (`Clock`, `Status`, `Txt`, `Glow`). A few examples: hackerman
  digital rain, retro-82 synthwave sun and grid, tokyo-night skyline with a neon sign,
  kanagawa ink waves and a hanko, catppuccin a cat on pastel digits, nord an animated aurora,
  lumon a corporate number grid, oled-low-glare a small dim clock that shifts a few pixels
  every minute. `Service.qml` and `FingerprintModel.js` are symlinks to Omarchy's lock plugin,
  so password/fingerprint handling keeps getting Omarchy's fixes. If Omarchy ever restructures
  its lock view, the overlay ends up hidden behind its backdrop but unlocking still works.
  After stowing, run `omarchy plugin enable jfolino.lock` then `omarchy restart shell` (while
  unlocked; also needed after editing overlays). Preview with `omarchy-shell lock preview`
  (click to close). Back to stock: `omarchy plugin enable omarchy.lock`.
  (`omarchy plugin validate` rejects it because of the symlinks; that check is for shared
  plugins, the shell loads it fine.)
- `starship` — terse `user@host:~/path (branch*)#` prompt. Colours are ANSI names, so they
  follow each Omarchy theme's terminal palette; the `#` turns red after a failed command.
- `omarchy-themes` — custom Omarchy themes in `~/.config/omarchy/themes` (deco-futura,
  desert-dusk-oled, octagon, oled-low-glare, phreak, starry-night, windows-3.1, windows-98) plus
  pure-black `colors.toml` overlays for the stock themes. `~/.config/omarchy/themes` stays a
  real directory and each theme is its own symlink, so themes added with
  `omarchy theme install` stay out of the repo. After editing an active theme, re-apply it
  with `omarchy theme set <name>`; Omarchy copies the theme rather than reading it live.
  Each custom theme has a `screensaver.txt`; the theme-set hook
  `hooks/theme-set.d/40-theme-screensaver` copies it to `~/.config/omarchy/branding/` on
  every switch, and themes without one get `branding/screensaver.default.txt` (your
  pre-theme screensaver) or the Omarchy logo back. Preview with
  `omarchy-launch-screensaver force`.
  For OLED, `hooks/theme-set.d/35-theme-oled-opaque` installs Omarchy's `window-opaque`
  toggle whenever a `mode = "dark"` theme is set, so Ghostty and other normally
  translucent windows are 100% opaque and the wallpaper never glows through the black;
  switching to a light theme removes it again (only if the hook added it).
  `hooks/font-set.d/10-hide-ghostty-restart` dismisses Omarchy's "restart Ghostty to see font
  change" notification; Ghostty already reloads the font live on the SIGUSR2 font-set sends.
- `nvim` — full AstroNvim v6 config (replaces Omarchy's LazyVim). Before stowing, run
  `mkdir -p ~/.config/nvim/lua/plugins` so that directory stays real: Omarchy symlinks
  its active theme into it as `theme.lua`, which `lua/plugins/omarchy.lua` reads.
- `tmux` — `tmux.conf` (started from Omarchy's default; `omarchy refresh tmux` would
  overwrite it). Ghostty runs `~/.local/bin/tmux-main`, which keeps four sessions `1`–`4`
  with 5 windows each; hold `/` and press `q` `w` `e` `r` to switch (keyd sends Alt+F9–F12).
- `yazi` — `yazi.toml` with `show_hidden = true` (also used by yazi.nvim)

## Not stowed

- `plymouth` — the `ghost` boot splash: black screen of scrolling boot text, real systemd
  status lines in the accent colour, and the LUKS passphrase prompt as a centred
  `>> ENCRYPTED VOLUME DETECTED <<` / `KEY: ****_` that answers `ACCESS GRANTED`. It runs
  before the disk is unlocked, so the active theme's colours are baked in by
  `plymouth-ghost`: `plymouth-ghost install` (theme files + default), `plymouth-ghost test`
  from a text console to see it, then `plymouth-ghost sync` to rebuild the boot image
  (`limine-mkinitcpio`). Re-run `sync` after changing theme. `plymouth-ghost revert` goes
  back to Omarchy's splash. If it ever shows nothing at boot, the passphrase still works
  typed blind; or remove `splash` from the kernel line in the Limine menu.

- `keyd` — system-wide key remapping (home row mods, nav/workspace layers). keyd
  reads `/etc/keyd/` as root at boot, so this is copied rather than symlinked.
  Don't `stow keyd`. After editing, install it with:

  ```sh
  sudo install -m 644 keyd/default.conf /etc/keyd/default.conf && sudo keyd reload
  ```

  If you edit `/etc/keyd/default.conf` directly, copy it back with
  `cp /etc/keyd/default.conf keyd/`.
