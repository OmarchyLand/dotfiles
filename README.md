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

## Packages

- `bash` — `.bashrc` (layered on top of Omarchy's defaults) and `.bash_aliases`
- `bin` — personal scripts in `~/.local/bin` (e.g. `reload-shells`, `ports` — explains what is listening on each port)
- `hypr` — Hyprland `bindings.lua` (only this file; the rest of `~/.config/hypr` stays Omarchy-managed)
- `nvim` — full AstroNvim v6 config (replaces Omarchy's LazyVim). Before stowing, run
  `mkdir -p ~/.config/nvim/lua/plugins` so that directory stays real: Omarchy symlinks
  its active theme into it as `theme.lua`, which `lua/plugins/omarchy.lua` reads.
- `yazi` — `yazi.toml` with `show_hidden = true` (also used by yazi.nvim)
