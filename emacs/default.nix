{ pkgs, ... }:

let
  package = with pkgs; emacsWithPackages (epkgs:
      (with epkgs; [ 
        (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
          cp ${./init.el} $out/share/emacs/site-lisp/default.el
        '')
       
        # Language support
        fish-mode
        lsp-mode
        markdown-mode
        nim-mode
        nix-mode
        python-mode
        rust-mode

        # Some general improvements
        company
        company-lsp
        color-theme-sanityinc-tomorrow          
        elfeed
        ergoemacs-mode
        fzf
        ledger-mode
        lsp-ui
        magit
        mastodon
        org
        ranger
        smex
        sublimity
        visual-fill-column
        vterm
        yasnippet
      ]));
in
  {
    home.packages = [ package ]; 
  }
