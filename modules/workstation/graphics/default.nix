{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
  ];

  services.gnome3.gnome-keyring.enable = true;
  services.xserver = {
    enable = true;
    desktopManager = {
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "xfce";
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
      ./kitty
    ];

    services.gnome-keyring.enable = true;

    home.packages = [
      pkgs.gnome3.gnome-screenshot
    ];
  };
}
