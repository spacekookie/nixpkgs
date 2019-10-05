{ config, pkgs, ... }:

{
  nix.trustedUsers = [ "@wheel" ];

  nix.nixPath = [
    "home-manager=/run/current-system/libkookie/home-manager"
    "nixos-config=/run/current-system/libkookie/configuration.nix"
    "nixpkgs-overlays=/run/current-system/libkookie/overlays"
    "nixpkgs=/run/current-system/libkookie/nixpkgs"
  ];

  system.extraSystemBuilderCmds = ''
    ln -s ${lib.cleanSource ../..} $out/libkookie
  '';

}
