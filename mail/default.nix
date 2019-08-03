#       REPOSITORY NOTE
# 
# This repository does not contain my e-mail
# configuration. That is stored in a seperate
# repository, with no publuc access. These
# derivations are merely included to give
# people a better understanding of how I
# configure my mutt (neomutt) and to keep all
# installed packages in a single place.
{ pkgs, ... }:

let
  pkg = pkgs.neomutt.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [ ./1388.patch ];
  });
in
  {
    home.packages = [ pkg ];
  }
