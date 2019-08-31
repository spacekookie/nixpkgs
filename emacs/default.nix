{ pkgs, ... }:

let
  package = with pkgs; emacsWithPackages (epkgs:
      (with epkgs; [ 
        (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
          cp ${./init.el} $out/share/emacs/site-lisp/default.el
        '')
       
        # Language support
        lsp-mode
        markdown-mode
        nix-mode
        rust-mode
        fish-mode

        # Some general improvements
        color-theme-sanityinc-tomorrow          
        ergoemacs-mode
        fzf
        ledger-mode
        lsp-ui
        magit
        org
        sublimity
        yasnippet
      ]));
in
  {
    home.packages = [ package ]; 
  }
