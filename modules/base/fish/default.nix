{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    programs.fish.enable = true;
    programs.fish.shellInit = import ./config.nix { inherig pkgs; };
  };

  programs.fish.enable = true;
}
