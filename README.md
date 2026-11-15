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
- `bin` — personal scripts in `~/.local/bin` (e.g. `reload-shells`)
- `hypr` — Hyprland `bindings.lua` (only this file; the rest of `~/.config/hypr` stays Omarchy-managed)
- `nvim` — `lua/plugins/hidden-files.lua`: snacks file/grep pickers show dotfiles (rest of the LazyVim config stays Omarchy-managed)
- `yazi` — `yazi.toml` with `show_hidden = true` (also used by yazi.nvim)
