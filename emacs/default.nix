{ pkgs, ... }:

let
  package = with pkgs;
    (emacsPackagesNgFor emacs26-nox).emacsWithPackages (epkgs:
      (with epkgs; with epkgs.melpaStablePackages;
        [ (runCommand "init.el" {} ''
            mkdir -p $out/share/emacs/site-lisp
            cp ${./init.el} $out/share/emacs/site-lisp/default.el
          '')
          color-theme-sanityinc-tomorrow
          ledger-mode
          magit
          markdown-mode
          ox-reveal 
          use-package
        ]));
in
  {
    home.packages = [ package ]; 
  }
