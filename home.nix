{ lib, pkgs, ... }:

let
  kakoune = (pkgs.kakoune.overrideAttrs ({ src, makeFlags, ... }: {
      src = pkgs.fetchFromGitHub {
        repo = "kakoune";
        owner = "mawww";
        rev = "89cd68d8aff07792b03a0affc19dbb01f036f554";
        sha256 = "0nc71jl2bpzzx3daqhfjgmmf3fh9k3gj1y1j536xnybd78vvgxq1";
       };
      enableParallelBuilding = true;
    }));
  htop = (pkgs.htop.overrideAttrs ({ src, patches ? [], nativeBuildInputs ? [], ... }: {
      src = pkgs.fetchFromGitHub {
        repo = "htop";
        owner = "hishamhm";
        rev = "402e46bb82964366746b86d77eb5afa69c279539";
        sha256 = "0akyspxl80h2kgp6nhbhnz9v5265pi6d57i6l90pf50l92z61sw7";
      };
      nativeBuildInputs = nativeBuildInputs ++ [ pkgs.autoreconfHook ];
      patches = patches ++ [ ./0001-Make-spacekookie-fit-untruncated-as-a-user-name.patch ];
    }));
  iosevka = (pkgs.iosevka.override {
      design = [ "v-at-long"
                 "v-l-italic"
                 "v-asterisk-low"
                 "v-zero-dotted"
                 "v-dollar-open"
                 "v-numbersign-slanted" ];
      upright = [ "v-i-hooky" ];
      set = "iosevka-ss09-term";
    });
  i3 = (pkgs.i3.overrideAttrs ({ src, ... }: {
      src = pkgs.fetchurl {
        url = "https://i3wm.org/downloads/i3-4.15.tar.bz2";
        sha256 = "09jk70hsdxab24lqvj2f30ijrkbv3f6q9xi5dcsax1dw3x6m4z91";
      };
      enableParallelBuilding = true;
    }));
in
  {
    home.packages = [
      kakoune
      htop
      iosevka
    ] ++ (with pkgs; [
      neovim
      any-nix-shell
      fish
      fzf
    ]);

    home.sessionVariables = {
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      NIX_PATH = "nixpkgs=/home/spacekookie/.local/nixpkgs";
    };

    fonts.fontconfig.enableProfileFonts = true;
      
    programs.fish.enable = true;
    programs.fish.shellInit = import ./fish.nix { inherit pkgs; };

    programs.kitty.enable = true;
    programs.kitty.config = import ./kitty.nix;

    xsession.windowManager.i3 = {
      enable = true;
      config = null;
      extraConfig = import ./i3.nix;
      package = i3;
    };

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
