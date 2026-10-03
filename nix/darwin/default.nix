{ pkgs, ... }:
{
  imports = [
    ./defaults.nix
    ./homebrew.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  environment.shells = [ pkgs.fish ];

  fonts.packages = with pkgs; [
    biz-ud-gothic
    gyre-fonts
    (ibm-plex.override {
      families = [
        "mono"
        "sans"
        "sans-jp"
      ];
    })
    jetbrains-mono
    lmodern
    mplus-outline-fonts.githubRelease
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    newcomputermodern
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    plemoljp-nf
    udev-gothic-nf
  ];

  services.jankyborders = {
    enable = true;
    active_color = "0xffe1e3e4";
    inactive_color = "0xff494d64";
    width = 10.0;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 7;
}
