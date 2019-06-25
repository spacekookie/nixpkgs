{ lib, pkgs, ... }:

let
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
      skim
      company
      flycheck
      ripgrep
      magit
      markdown-mode
      multiple-cursors
      nix-mode
      ox-reveal

      rust-mode
      cargo
      flycheck-rust
      eglot

      lsp-mode
      lsp-ui
      company-lsp
    ])));
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
in
  {
    home.packages = [
      emacs
      iosevka
    ] ++ (with pkgs; [
      tmux
      links
      gnupg
      any-nix-shell
      fish
      fzf
      transmission-gtk
      gopass
      cmake
      gnumake
      w3m
      void
      pciutils
      usbutils

      compton
      xorg.xmodmap
      jq
      bat
      fontconfig
      wine
      mono
      feh
      syncthing-gtk
      pasystray
      paprefs
      pavucontrol
      gnome3.gnome-screenshot 

      neomutt
      notmuch
      msmtp
      isync
      
      rustup
      gcc9
      gcc9Stdenv
      binutils
      patchelf

      alacritty
      kitty
      firefox
      torbrowser
      kicad
      darktable

      quasselClient
      gajim
      python37Packages.python-axolotl # Needed for OMEMO
      signal-desktop
      weechat
      tdesktop
    ]);

    home.sessionVariables = {
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      NIX_PATH = "nixpkgs=/home/sys/nixpkgs:nixos-config=/home/sys/configuration.nix";
    };

    fonts.fontconfig.enable = true;

    programs.fish.enable = true;
    programs.fish.shellInit = import ./fish { inherit pkgs; };

    # xdg.configFile."mutt/" = {
    #   recursive = true;
    #   executable = false;
    #   source = ./mutt;
    # };

    xsession.windowManager.i3 = import ./i3 { i3 = pkgs.i3; };

    xdg.configFile."i3/dynamic-tags/" = {
      recursive = true;
      executable = true;
      source = ./i3/dynamic-tags;
    };

    xdg.configFile."i3/compton.conf" = {
      source = ./i3/compton.conf;
    };

    xdg.configFile."i3/i3status.conf" = {
      source = ./i3/i3status.conf;
    };

    imports = [ ./kakoune ./htop ];

    programs.home-manager = {
      enable = true;
      path = "/home/sys/home-manager";
    };
  }
