{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      default = "xfce";
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;

    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
    useGlamor = true;
  };

  home-manager.users.spacekookie = { ... }: {
    imports = [
      ./i3
      ./browser.nix
      ./fun.nix
    ];
  };
}
