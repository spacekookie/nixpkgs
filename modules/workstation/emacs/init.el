;; Kookie's emacs config

;; More sane line-number behaviour
(setq display-line-numbers-grow-only 1)
(setq display-line-numbers-width-start 1)
(global-display-line-numbers-mode 1)

;; I just need my personal space
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;;disable splash screen and startup message
(setq inhibit-startup-message 1) 
(setq initial-scratch-message nil)

;; Swap/Backup files are annoying AF
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Some editing niceties
(delete-selection-mode 1)
(show-paren-mode 1)

;; Explicitly enable lsp-mode for certain languages
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-hook 'java-mode-hook (local-unset-key "M-a"))
;; (add-hook 'prog-mode-hook (local-unset-key "M-a"))

(column-number-mode 1)
(ido-mode 1)
(add-hook 'find-file-hook (lambda () (ruler-mode 1)))

(require 'color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-eighties)

;; More ergonomic keybindings 
(require 'ergoemacs-mode)
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(ergoemacs-mode 1)

;; VTerm integration
(require 'vterm)

;; Distraction free mode and minimap
(require 'sublimity)
(require 'sublimity-map)
(require 'sublimity-attractive)

(setq sublimity-map-size 10)
(setq sublimity-map-fraction 0.5)
(setq sublimity-map-text-scale -7)

;; Display minimap without delay
(sublimity-map-set-delay nil)

;; This is require for lsp-mode
(require 'yasnippet)

;; Better completion handling with lsp-mode
(require 'company-lsp)
(push 'company-lsp company-backends)
(setq lsp-ui-doc-max-width 45)
(setq lsp-ui-doc-max-height 10)

;; Turns out I'm a huge dork
(setq emacs-anchor default-directory)
(defun mitosis () (interactive) (make-frame))

;; Setup RSS feeds
(setq elfeed-feeds
  '(("https://alyssa.is/feed.xml" girlfriend blog)
    ("https://spacekookie.de/rss.xml" self blog)
    ("https://xkcd.com/rss.xml" webcomic)
    ("https://deterministic.space/feed.xml" rust blog)
  ))
