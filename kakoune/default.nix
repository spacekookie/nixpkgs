{ pkgs, ... }:

let
  package = (pkgs.kakoune.overrideAttrs ({ src, makeFlags, ... }: {
      src = pkgs.fetchFromGitHub {
        repo = "kakoune";
        owner = "mawww";
        rev = "89cd68d8aff07792b03a0affc19dbb01f036f554";
        sha256 = "0nc71jl2bpzzx3daqhfjgmmf3fh9k3gj1y1j536xnybd78vvgxq1";
       };
      enableParallelBuilding = true;
    }));
in
  {
    home.packages = [ package ]; 

    xdg.configFile."kak/" = {
      recursive = true;
      executable = false;
      source = ./.;
    };
  }
