{ lib, pkgs, ... }:

{
  createHome = true;
  description = "Katharina Fey";
  home = lib.mkDefault "/home";
  uid = lib.mkDefault 1000;
  group = "spacekookie";
  extraGroups = [ "wheel" "dialout" ];
  shell = lib.mkDefault pkgs.fish;
}
