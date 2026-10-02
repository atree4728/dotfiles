{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-family = "PlemolJP35 Console NF";
        font-size = 20;
        font-feature = "-dlig";
        theme = "Catppuccin Macchiato";
        shell-integration = "fish";
        background-opacity = 0.85;
        background-blur-radius = 20;
        macos-titlebar-style = "transparent";
        keybind = "shift+enter=text:\\n";
        macos-window-buttons = "hidden";
        macos-icon = "blueprint";
      };
    };
  };
}
