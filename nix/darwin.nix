{ ... }:
{
  determinateNix.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 7;
}
