# dotfiles

macOS and Linux (WSL) environments managed with nix-darwin and home-manager.

## Bootstrap

Clone this repository to `~/src/github.com/atree4728/dotfiles` on either system; files under `config/` are symlinked from this path.

### macOS

1. Install Xcode Command Line Tools: `xcode-select --install`
2. Install [Determinate Nix](https://docs.determinate.systems/).
3. Install [Homebrew](https://brew.sh/).
4. Sign in to the App Store (apps from it are installed during activation).
5. Clone this repository and run the following in it.

```sh
# nix-darwin manages this file and refuses to overwrite the installer's copy
sudo mv /etc/nix/nix.custom.conf{,.before-nix-darwin}

sudo nix run --inputs-from . nix-darwin -- switch --flake .#mac

chsh -s /run/current-system/sw/bin/fish
```

### Linux (Ubuntu on WSL)

1. Install [Determinate Nix](https://docs.determinate.systems/).
2. Clone this repository.
3. Run the following in it, then open a new shell.

```sh
nix run --inputs-from . home-manager -- switch --impure -b hm-backup --flake .#linux
```

The user name and the architecture are read from the environment, hence `--impure`. The login shell stays bash, which starts fish; run `bash` from fish to get a bash prompt.

Only the command-line tools from Nix are set up. Homebrew packages, GUI applications, fonts, the 1Password SSH agent and verilator are macOS only. The tasks do not install the tools listed in `config/mise/config.toml`; `mise install` and the mise step of `mise run upgrade` need rustup and a C compiler (`sudo apt install build-essential`).

## Usage

Tasks are run with [mise](https://mise.jdx.dev/); `mise tasks` lists them.

```sh
mise trust
mise generate git-pre-commit --write --task=pre-commit  # once per clone
mise run apply
```

```sh
mise run upgrade  # update flake.lock, apply, upgrade everything outside Nix, collect garbage, then commit the lock files
mise run gc       # delete generations older than 7 days; upgrade runs it too
```

`mise run upgrade` runs [topgrade](https://github.com/topgrade-rs/topgrade), configured in `nix/home/topgrade.nix`; when a step fails it asks whether to retry, skip or quit, and each step can be run alone (`topgrade --only rustup`). It ends with `mise run gc` and `mise run lock`; the latter commits `flake.lock` and `config/nvim/lazy-lock.json` and nothing else; run it by hand after a step that was run alone. If the build fails after the update, `flake.lock` is restored.

On macOS, Homebrew packages that are not declared in `nix/darwin/homebrew.nix` are uninstalled by `mise run apply`, so declare a formula or cask there instead of running `brew install`.

On macOS, VS Code is only installed from here; its settings, keybindings and extensions are kept by its own Settings Sync, so sign in to it once per machine.

## Recovery

- On macOS, the login shell is the fish installed by Nix, so it does not start when Nix is broken. Open Terminal.app, choose Profiles > Shell > Startup > Run command and run `/bin/zsh`.
- On Linux, the login shell is still bash; when fish is broken, run `bash --norc`.
- `sudo darwin-rebuild --rollback` switches macOS back to the previous generation.
- After a major macOS update, run `mise run apply` again; the update can overwrite `/etc/zshrc` and drop the Nix initialisation.
- When a managed file already exists, home-manager moves it to `<name>.hm-backup`, and `mise run apply` fails if that backup already exists. Check the backup, delete it and apply again. On Ubuntu, the first activation moves the stock `~/.bashrc` and `~/.profile` to `~/.bashrc.hm-backup` and `~/.profile.hm-backup`.
