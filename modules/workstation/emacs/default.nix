{ pkgs, ... }:

let
  package = with pkgs; emacsWithPackages (epkgs:
    (with epkgs; [
      (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
          cp ${./init.el} $out/share/emacs/site-lisp/default.el
        '')

      # Custom patched mode
      pkgs.emacs-ergoemacs-mode

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
      fzf
      ledger-mode
      lsp-ui
      magit
      notmuch
      org
      smex
      sublimity
      visual-fill-column
      yasnippet
    ]));
in
{
  home.packages = [ package ];
}
