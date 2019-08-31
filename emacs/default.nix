{ pkgs, ... }:

let
  package = with pkgs; emacsWithPackages (epkgs:
      (with epkgs; [ 
        (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
          cp ${./init.el} $out/share/emacs/site-lisp/default.el
        '')

        # Some general improvements
        color-theme-sanityinc-tomorrow          
        ergoemacs-mode
        sublimity

        # Language support
        lsp-mode
        markdown-mode
        nix-mode
        rust-mode

        # Various utils
        ledger-mode
        lsp-ui
        magit
        org
      ]));
in
  {
    home.packages = [ package ]; 
  }
