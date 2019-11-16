{ pkgs, ... }:

let
  emacs = with pkgs; emacsWithPackages (epkgs:
    (with epkgs; [
      (runCommand "init.el" {} ''
          mkdir -p $out/share/emacs/site-lisp
          cp ${./init.el} $out/share/emacs/site-lisp/default.el
        '')

      # TODO: Add custom patched mode
      ergoemacs-mode

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
      direnv
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
  home.packages = [ emacs pkgs.direnv ];
}
