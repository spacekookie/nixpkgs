{ lib, pkgs, ... }:

let
  rev = "f20a3230bf7e93c4b5b41dff85740763d7ce02c8";
  lorriSrc = fetchTarball {
    url = "https://github.com/target/lorri/archive/${rev}.tar.gz";
    sha256 = "1lp77rms6zlx04kz7nxar8ksay8xcl8bmi7nijgwyapzjy5q5cmq";
  };
in
{
  home.packages = [
    (import lorriSrc { inherit pkgs; })
  ];
}
