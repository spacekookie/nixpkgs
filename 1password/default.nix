{ lib, pkgs, ... }:

let
  wrapper = lib.mkDerivation {
    name = "1pass";
    buildInputs = with pkgs; [ wine mono ];
    src = ./.;
    installPhase = ''
      mkdir -p $out/bin
      cp ./1pass $out/bin/
    '';
  };
in
  {
    home.packages = [ wrapper ];
  }
