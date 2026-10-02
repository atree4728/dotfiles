# dotfiles

macOS environment managed with nix-darwin and home-manager.

## Bootstrap

1. Install Xcode Command Line Tools: `xcode-select --install`
2. Install [Determinate Nix](https://docs.determinate.systems/).
3. Install [Homebrew](https://brew.sh/).
4. Sign in to the App Store (apps from it are installed during activation).
5. Clone this repository to `~/src/github.com/atree4728/dotfiles` (files under `config/` are symlinked from this path) and run the following in it.

```sh
# nix-darwin manages this file and refuses to overwrite the installer's copy
sudo mv /etc/nix/nix.custom.conf{,.before-nix-darwin}

sudo nix run --inputs-from . nix-darwin -- switch --flake .#Ree

chsh -s /run/current-system/sw/bin/fish
```

## Usage

Tasks are run with [mise](https://mise.jdx.dev/); `mise tasks` lists them.

```sh
mise trust
mise generate git-pre-commit --write --task=pre-commit  # once per clone
mise run apply
mise run vscode-extensions  # once per machine
```

```sh
mise run upgrade  # update flake.lock, apply, upgrade everything outside Nix, then commit the lock files
mise run gc       # delete generations older than 7 days
```

`mise run upgrade` stops at the first failing step; `mise run -c upgrade` continues past it, and each step can be run alone (`mise run upgrade:brew`). It ends with `mise run lock`, which commits `flake.lock` and `config/nvim/lazy-lock.json` and nothing else; run it by hand after a step that was run alone. If the build fails after the update, `flake.lock` is restored.

Homebrew packages that are not declared in `nix/homebrew.nix` are uninstalled by `mise run apply`, so declare a formula or cask there instead of running `brew install`.

## Recovery

- The login shell is the fish installed by Nix, so it does not start when Nix is broken. Open Terminal.app, choose Profiles > Shell > Startup > Run command and run `/bin/zsh`.
- `sudo darwin-rebuild --rollback` switches back to the previous generation.
- After a major macOS update, run `mise run apply` again; the update can overwrite `/etc/zshrc` and drop the Nix initialisation.
- When a managed file already exists, home-manager moves it to `<name>.hm-backup`, and `mise run apply` fails if that backup already exists. Check the backup, delete it and apply again.
