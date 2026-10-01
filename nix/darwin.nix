{ ... }:
{
  determinateNix.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
    };
    WindowManager.EnableTiledWindowMargins = false;
    dock = {
      autohide = true;
      expose-group-apps = true;
      wvous-br-corner = 1;
    };
    finder.AppleShowAllFiles = true;
    menuExtraClock.ShowSeconds = true;
  };

  system.stateVersion = 7;
}
