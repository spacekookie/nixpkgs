{ pkgs, ... }:

let
  package = with pkgs;
    (emacsPackagesNgFor emacs26-nox).emacsWithPackages (epkgs:
      (with epkgs; with epkgs.melpaStablePackages;
        [ (runCommand "init.el" {} ''
            mkdir -p $out/share/emacs/site-lisp
            cp ${./init.el} $out/share/emacs/site-lisp/default.el
          '')
          use-package
          color-theme-sanityinc-tomorrow
          magit
          markdown-mode
          ox-reveal ]));
in
  {
    home.packages = [ package ]; 
  }
