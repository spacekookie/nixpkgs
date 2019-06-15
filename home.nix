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
  emacs = (with pkgs; (emacsPackagesNgFor emacs26-nox).emacsWithPackages (epkgs:
  (with epkgs; with epkgs.melpaStablePackages;
    [
      # Note: substituteAll
      (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
           cp ${./emacs/init.el} $out/share/emacs/site-lisp/default.el
      '')
      use-package
      color-theme-sanityinc-tomorrow
      fzf
      company
      flycheck
      ripgrep
      magit
      markdown-mode
      multiple-cursors
      nix-mode
      ox-reveal

      rust-mode
      lsp-rust
      cargo
      flycheck-rust
      eglot

      lsp-mode
      lsp-ui
      company-lsp
    ])));
  htop = (pkgs.htop.overrideAttrs ({ src, patches ? [], nativeBuildInputs ? [], ... }: {
      src = pkgs.fetchFromGitHub {
        repo = "htop";
        owner = "hishamhm";
        rev = "402e46bb82964366746b86d77eb5afa69c279539";
        sha256 = "0akyspxl80h2kgp6nhbhnz9v5265pi6d57i6l90pf50l92z61sw7";
      };
      nativeBuildInputs = nativeBuildInputs ++ [ pkgs.autoreconfHook ];
      patches = patches ++ [ ./0001-htop-untruncated-username.patch ];
    }));
  git = (pkgs.git.override { svnSupport = true; sendEmailSupport = true;  });
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
      emacs
      htop
      iosevka
      kakoune
    ] ++ (with pkgs; [
      tmux
      gnupg
      any-nix-shell
      fish
      fzf
      gajim
      python37Packages.python-axolotl # Needed for OMEMO
      signal-desktop
      transmission-gtk
      yubikey-personalization

      neomutt
      msmtp
      isync
      
      rustup
      gcc9
      gcc9Stdenv
    ]);

    home.sessionVariables = {
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      NIX_PATH = "nixpkgs=/home/sys/nixpkgs";
    };

    fonts.fontconfig.enable = true;

    programs.fish.enable = true;
    programs.fish.shellInit = import ./fish { inherit pkgs; };

    xdg.configFile."mutt/" = {
      recursive = true;
      executable = false;
      source = ./mutt;
    };

    # programs.kitty.enable = true;
    # programs.kitty.config = import ./kitty;

    # xsession.windowManager.i3 = import ./i3 { inherit i3; };

    # xdg.configFile."i3/dynamic-tagging/" = {
    #   recursive = true;
    #   executable = true;
    #   source = ./i3/dynamic-tagging;
    # };

    # xdg.configFile."i3/compton.conf" = {
    #   source = ./i3/compton.conf;
    # };

    programs.home-manager = {
      enable = true;
      path = "/home/sys/home-manager";
    };
  }
