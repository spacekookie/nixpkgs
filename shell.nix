{ pkgs, ... }:

{
  home.packages = with pkgs; [
    any-nix-shell
    bat
    binutils
    cmake
    file
    fzf
    gcc9
    gcc9Stdenv
    git
    gitAndTools.hub
    gnumake
    gnupg
    jq
    links
    patchelf
    pciutils
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
