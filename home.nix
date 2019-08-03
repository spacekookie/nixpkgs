{ lib, pkgs, ... }:

let
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
  kookiepkgs = import <kookiepkgs> { };
in
  {
    home.packages = with pkgs; [
      cmake
      compton
      darktable
      feh
      firefox
      fontconfig
      gajim
      gcc9
      gcc9Stdenv
      gnome3.gnome-screenshot 
      gnumake
      gnupg
      gopass
      (hunspellWithDicts (with hunspellDicts; [ en-gb-ise ]))
      isync
      jq
      kicad
      kitty
      libreoffice
      mono
      msmtp
      notmuch
      paprefs
      pasystray
      patchelf
      pavucontrol
      python37Packages.python-axolotl # Needed for OMEMO
      quasselClient
      rustup
      signal-desktop
      steam
      spotify
      subversion
      superTuxKart
      syncthing-gtk
      tdesktop
      torbrowser
      transmission-gtk
      void
      w3m
      weechat
      wine
      xorg.xmodmap
    ];

    home.sessionVariables = {
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      NIX_PATH = "nixpkgs=/home/sys/nixpkgs:kookiepkgs=/home/sys/kookiepkgs:nixos-config=/home/sys/configuration.nix";
    };

    fonts.fontconfig.enable = true;

    programs.fish.enable = true;
    programs.fish.shellInit = import ./fish { inherit pkgs; };

    xdg.configFile."nixpkgs/config.nix" = {
      source = pkgs.writeTextFile {
        name = "config.nix";
        text = "{ allowUnfree = true; }";
      };
    };

    imports = [ 
      ./emacs
      ./git
      ./gui/i3
      ./htop
      ./kakoune
      ./mail
      ./shell.nix
    ];

    programs.home-manager = {
      enable = true;
      path = "/home/sys/home-manager";
    };
  }
