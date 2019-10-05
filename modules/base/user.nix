{ pkgs, lib, ... }:

let
  mkDefault = lib.mkOverride ((lib.mkDefault null).priority - 1);
in
{
  users.mutableUsers = false;
  users.groups.spacekookie = {};
  users.users.spacekookie = {
    createHome = true;
    description = "Katharina Fey";
    home = mkDefault "/home";
    uid = mkDefault 1000;
    group = "qyliss";
    extraGroups = [ "wheel" ];
    shell = lib.mkDefault pkgs.fish;
  };

  home.spacekookie = {
    permissions = "770";
    group = "spacekookie";
  };
}

