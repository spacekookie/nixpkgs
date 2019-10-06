{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    programs.fish.enable = true;
    programs.fish.shellInit = import ./config.nix { inherit pkgs; };

    home.packages = [
      pkgs.any-nix-shell
    ];
  };

  programs.fish.enable = true;
}
