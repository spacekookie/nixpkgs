
;; Kookie's emacs config
;;
;; Focused on ergonomics and multi-cursor editing features
;; Only used with ncurses UI

;; A package loading utility
(require 'use-package)

;; More sane line-number behaviour
(setq display-line-numbers-grow-only 1)
(setq display-line-numbers-width-start 1)
(global-display-line-numbers-mode 1)

;; Spaces are better than tabs
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; Swap/Backup files are annoying AF
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Some editing niceties
(delete-selection-mode 1)
(show-paren-mode 1)

;; Setup better (less jumpy) scroll characteristics
(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

;; View scroll without moving cursors
(global-set-key "\M-n"  (lambda () (interactive) (scroll-up   1)) )
(global-set-key "\M-p"  (lambda () (interactive) (scroll-down 1)) )

;; Multiple cursors keybindings
(global-set-key (kbd "C-c RET") 'mc/edit-lines)
(global-set-key (kbd "C-c [") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c ]") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c _") 'mc/mark-all-like-this)

;; Decrease startup time by dropping certain debug output
(setf inhibit-startup-screen 1
      inhibit-startup-echo-area-message 1
      inhibit-startup-message 1)

;; Weird clipboard stuff I haven't fully understood
(setf select-enable-clipboard 1
      save-interprogram-paste-before-kill 1
      mouse-yank-at-point 1)

;; General ergonomics
(defalias 'yes-or-no-p 'y-or-n-p)
(ido-mode 1)
(setf ido-enable-flex-matching 1
      ido-everywhere 1)

;; I like pretty colours!
(require 'color-theme-sanityinc-tomorrow)
(color-theme-sanityinc-tomorrow-eighties)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
