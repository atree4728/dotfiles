# dotfiles

macOS environment managed with nix-darwin and home-manager.

## Bootstrap

1. Install Xcode Command Line Tools: `xcode-select --install`
2. Install [Determinate Nix](https://docs.determinate.systems/).
3. Clone this repository and run the following in it.

```sh
# nix-darwin manages this file and refuses to overwrite the installer's copy
sudo mv /etc/nix/nix.custom.conf{,.before-nix-darwin}

sudo nix run --inputs-from . nix-darwin -- switch --flake .#Ree
```

## Usage

Tasks are run with [mise](https://mise.jdx.dev/); `mise tasks` lists them.

```sh
mise trust
mise generate git-pre-commit --write --task=pre-commit  # once per clone
mise run apply
```
