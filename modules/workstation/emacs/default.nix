{ pkgs, ... }:

let
  emacs = with pkgs; emacsWithPackages (epkgs:
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

      color-theme-sanityinc-tomorrow
      company-lsp
      direnv
      fzf
      ledger-mode
      lsp-ui
      magit
      monokai-theme
      notmuch
      org
      smex
      sublimity
      undo-tree
      visual-fill-column
      yasnippet
      company
    ]));
in
{
  home.packages = [ emacs pkgs.direnv ];
}
