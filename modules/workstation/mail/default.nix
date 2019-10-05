{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    imports = [ ./pkgs.nix ];
  };

  imports = [ ./timer.nix ];
}
