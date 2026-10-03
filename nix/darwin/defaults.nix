{ config, lib, ... }:
{
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

  # Not `system.defaults.CustomUserPreferences`: it replaces the whole
  # AppleSymbolicHotKeys dictionary, resetting every other shortcut.
  system.activationScripts.postActivation.text =
    let
      asUser = ''launchctl asuser "$(id -u -- ${config.system.primaryUser})" sudo --user=${config.system.primaryUser} --'';
      control = 262144;
      command = 1048576;
      space = {
        ascii = 32;
        keyCode = 49;
      };
      disabledHotKeys = {
        "60" = control; # Select the previous input source
        "64" = command; # Show Spotlight search
      };
      disable = id: modifier: ''
        ${asUser} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${id} '
          <dict>
            <key>enabled</key><false/>
            <key>value</key>
            <dict>
              <key>type</key><string>standard</string>
              <key>parameters</key>
              <array>
                <integer>${toString space.ascii}</integer>
                <integer>${toString space.keyCode}</integer>
                <integer>${toString modifier}</integer>
              </array>
            </dict>
          </dict>'
      '';
    in
    ''
      ${lib.concatStrings (lib.mapAttrsToList disable disabledHotKeys)}
      ${asUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
}
