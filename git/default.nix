{ pkgs, ... }:

let
  git = (pkgs.git.override { svnSupport = true; sendEmailSupport = true; });
in
  {
    home.packages = with pkgs; [ gitAndTools.hub ] ++ [ git ];
  }
