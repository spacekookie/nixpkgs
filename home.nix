{ lib, pkgs, ... }:

{
  home.packages = [
    pkgs.fish
    (pkgs.htop.overrideAttrs ({ patches ? [], ... }: {
      patches = patches ++ [ ./0001-Make-spacekookie-fit-untruncated-as-a-user-name.patch ];
    }))
    (pkgs.iosevka.override {
      design = [ "v-at-long"
                 "v-l-italic"
                 "v-asterisk-low"
                 "v-zero-dotted"
                 "v-dollar-open"
                 "v-numbersign-slanted" ];
      upright = [ "v-i-hooky" ];
      set = "iosevka-ss09-term";
    })
  ];

  fonts.fontconfig.enableProfileFonts = true;
    
  programs.fish.enable = true;
  programs.fish.shellInit = import ./fish.nix;

  programs.kitty.enable = true;
  programs.kitty.config = import ./kitty.nix;

  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config = null;
  xsession.windowManager.i3.extraConfig = import ./i3.nix;

  xdg.configFile."i3/dynamic-tagging/" = {
    recursive = true;
    executable = true;
    source = ./i3/dynamic-tagging;
  };

  programs.home-manager = {
    enable = true;
    path = "/home/spacekookie/Personal/clones/home-manager";
    # https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
