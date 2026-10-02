{
  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.fastfetch.enable = true;
  programs.fd.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.ripgrep.enable = true;
  programs.tealdeer.enable = true;

  programs.lsd = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    settings.git.diffRenderers = [ { command = "delta --dark --paging=never"; } ];
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
