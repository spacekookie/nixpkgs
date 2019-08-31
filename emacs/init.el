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

(add-hook 'rust-mode-hook #'lsp)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(require 'color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-eighties)

;; More ergonomic keybindings 
(require 'ergoemacs-mode)
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(ergoemacs-mode 1)

;; Distraction free mode and minimap
(require 'sublimity)
(require 'sublimity-map)
(require 'sublimity-attractive)

(setq sublimity-map-size 10)
(setq sublimity-map-fraction 0.5)
(setq sublimity-map-text-scale -7)

(sublimity-map-set-delay nil)
