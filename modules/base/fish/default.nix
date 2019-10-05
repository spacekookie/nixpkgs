{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    programs.fish.enable = true;
    programs.fish.shellInit = import ./config.nix { inherit pkgs; };
  };

  programs.fish.enable = true;
}
