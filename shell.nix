{ pkgs, ... }:

let
  kookiepkgs = import <kookiepkgs> { };
in
  {
    home.packages = with pkgs; with kookiepkgs; [
      any-nix-shell
      bat
      binutils
      bundix
      cmake
      curl
      file
      fzf
      gcc9
      gcc9Stdenv
      gnumake
      gnupg
      invoice
      jq
      links
      nodemcu-uploader
      patchelf
      pciutils
      pv
      ranger
      ripgrep
      rustup
      skim
      subversion
      tmux
      tree
      usbutils
      wget
    ];
  }
