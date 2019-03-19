{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
  # (kakoune.overrideAttrs ({ src, makeFlags, ... }: {
  #     src = fetchFromGitHub {
  #       repo = "kakoune";
  #       owner = "mawww";
  #       rev = "89cd68d8aff07792b03a0affc19dbb01f036f554";
  #       sha256 = "0nc71jl2bpzzx3daqhfjgmmf3fh9k3gj1y1j536xnybd78vvgxq1";
  #      };
  #     enableParallelBuilding = true;
  #   }))
    (htop.overrideAttrs ({ patches ? [], ... }: {
      patches = patches ++ [ ./0001-Make-spacekookie-fit-untruncated-as-a-user-name.patch ];
    }))
    (iosevka.override {
      design = [ "v-at-long"
                 "v-l-italic"
                 "v-asterisk-low"
                 "v-zero-dotted"
                 "v-dollar-open"
                 "v-numbersign-slanted" ];
      upright = [ "v-i-hooky" ];
      set = "iosevka-ss09-term";
    })
    neovim
    fish
    fzf
  ];

  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  fonts.fontconfig.enableProfileFonts = true;
    
  programs.fish.enable = true;
  programs.fish.shellInit = import ./fish.nix { inherit pkgs; };

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

  xdg.configFile."i3/compton.conf" = {
    source = ./i3/compton.conf;
  };

  programs.home-manager = {
    enable = true;
    path = "/home/spacekookie/Personal/clones/home-manager";
    # https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
