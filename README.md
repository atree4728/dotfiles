# dotfiles

macOS (nix-darwin + home-manager) and Linux on WSL (home-manager).

## Install

Prerequisites: on macOS, sign in to the App Store; on WSL, set `systemd=true` under `[boot]` in `/etc/wsl.conf` and restart the distribution.

```sh
# macOS only
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# `config/` is symlinked from this path
git clone https://github.com/atree4728/dotfiles ~/src/github.com/atree4728/dotfiles
cd ~/src/github.com/atree4728/dotfiles
./install.sh
```

Open a new shell afterwards. Linux gets the command-line tools only; `mise install` additionally needs `sudo apt install build-essential`.

## Usage

```sh
mise trust
mise generate git-pre-commit --write --task=pre-commit  # once per clone
mise tasks                                              # list tasks
mise run apply
mise run upgrade                                        # flake.lock, topgrade, gc, then commit lock files
```

- Homebrew packages not declared in `nix/darwin/homebrew.nix` are uninstalled by `mise run apply`; do not `brew install`.
- VS Code is only installed from here; sign in to its Settings Sync.

## Recovery

```sh
bash --norc                       # Linux: fish is broken
sudo darwin-rebuild --rollback    # macOS: previous generation
rm ~/<name>.hm-backup             # apply fails because a backup exists; check it first
mise run apply                    # macOS: after a major update, which can drop the Nix init from /etc/zshrc
```

- macOS, fish is broken: Terminal.app > Profiles > Shell > Startup > Run command: `/bin/zsh`.
- Uninstall on Linux: `/nix/nix-installer uninstall`.
- Uninstall on macOS: change the login shell to `/bin/zsh` first, then run the following in this order; reversing it breaks the SSL certificate link and the nix-darwin uninstaller.

```sh
chsh -s /bin/zsh
sudo nix run nix-darwin#darwin-uninstaller
/nix/nix-installer uninstall
```
