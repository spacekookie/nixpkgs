{ config, pkgs, lib, ... }:

{
  nix.trustedUsers = [ "@wheel" ];

  nix.nixPath = [
    "home-manager=/run/current-system/libkookie/home-manager"
    "nixos-config=$ROOT"
    "nixpkgs-overlays=/run/current-system/libkookie/overlays"
    "nixpkgs=/run/current-system/libkookie/nixpkgs"
  ];

  system.extraSystemBuilderCmds = ''
    ln -s ${lib.cleanSource ../..} $out/libkookie
  '';

}
