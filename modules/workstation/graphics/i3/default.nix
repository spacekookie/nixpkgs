{ pkgs, ... }:

let
  wallpaper = "~/pictures/wallpaper/my-cyber-city-4k-28-2560x1440.jpg";
in
{
  xsession.windowManager.i3 = import ./config.nix { inherit pkgs wallpaper; };

  xdg.configFile."i3/dynamic-tags/" = {
    recursive = true;
    executable = true;
    source = ./dynamic-tags;
  };

  xdg.configFile."i3/compton.conf" = {
    source = ./compton.conf;
  };

  xdg.configFile."i3/i3status.conf" = {
    source = ./i3status.conf;
  };
}
