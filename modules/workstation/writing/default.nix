{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
