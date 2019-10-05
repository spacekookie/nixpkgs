{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  
  # FIXME: Can I remove these?
  # Previously these rules were required to make
  # Yubikey support work on `uwu`, but maybe this
  # is redundant with special udev rules?
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
  ];
}
