{ pkgs, ... }:

{
  home.packages = with pkgs; [
    compton
    feh
    xorg.xmodmap
  ];

  xsession.windowManager.i3 = import ./config.nix { i3 = pkgs.i3; };

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
