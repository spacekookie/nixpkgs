;; Kookie's emacs config

;; Enable automatic shell.nix loading
(require 'direnv)
(direnv-mode)

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

(autoload 'notmuch "notmuch" "notmuch mail" t)
(setq notmuch-search-oldest-first nil)

;; Change the swap/autosave directory
(let ((backup-dir (concat user-emacs-directory "backups")))
  (make-directory backup-dir t)
  (setq backup-directory-alist (list (cons "." backup-dir)))
  (setq message-auto-save-directory backup-dir))

;; Some editing niceties
(delete-selection-mode 1)
(show-paren-mode 1)
(setq-default truncate-lines t)

;; Explicitly enable lsp-mode for certain languages
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(column-number-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(add-hook 'find-file-hook (lambda () (ruler-mode 1)))

(require 'color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-eighties)

;; Distraction free mode and minimap
(require 'sublimity)
(require 'sublimity-attractive)

;; This is require for lsp-mode
(require 'yasnippet)

(defun lorri (&optional buffer-name)
  (interactive)
  (setq buffer-name (or buffer-name (generate-new-buffer "*lorri*")))
  (start-process "lorri" buffer-name "lorri" "watch")
  (display-buffer buffer-name))

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;                               ;;;;;;;;;;;;
;;;;;;;;; KOOKIE-MODE DEFINITIONS BELOW ;;;;;;;;;;;;
;;;;;;;;;                               ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

(defun user-buffer-q ()
  "Check if a buffer is a user buffer"
  (interactive)
  (if (string-equal "*" (substring (buffer-name) 0 1))
      nil
    (if (string-equal major-mode "dired-mode")
        nil
      t
      )))

(defun next-user-buffer ()
  "Switch to the next user buffer."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (user-buffer-q))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun previous-user-buffer ()
  "Switch to the previous user buffer."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (user-buffer-q))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))


(defun move--section (offset)
  "Move a line or reg up or down by on offset."

  ;; We'll have to track 4 text points in this function
  ;; Future me: the * is important....
  (let* (txt-start
         txt-end
         (reg-start (point))
         (reg-end reg-start)

         ;; De we delete a trailing \n
         del-nl-trail)

    ;; Find the text borders
    (when (region-active-p)
      (if (> (point) (mark))
          (setq reg-start (mark))
        (exchange-point-and-mark)
        (setq reg-end (point))))
    (end-of-line)

    ;; If point > point-max there is no trailing \n
    (if (< (point) (point-max))
        (forward-char 1)
      (setq del-nl-trail t)
      (insert-char ?\n))
    (setq txt-end (point)
          reg-end (- reg-end txt-end))

    ;; text/region start points
    (goto-char reg-start)
    (beginning-of-line)
    (setq txt-start (point)
          reg-start (- reg-start txt-end))

    ;; I'm tired and numbers are hard 
    (message "ts: %d, te: %d, rs: %d, re: %d"
             txt-start
             txt-end
             reg-start
             reg-end)

    ;; Fake the txt move
    (let ((text (delete-and-extract-region txt-start txt-end)))
      (forward-line offset)
      (when (not (= (current-column) 0))
        (insert-char ?\n)
        (setq del-nl-trail t))
      (insert text))

    ;; Restore point position
    (forward-char reg-start)

    ;; Clean that annoying \n at the end
    (when del-nl-trail
      (save-excursion
        (goto-char (point-max))
        (delete-char -1)))

    ;; If we operated on a region we need to fix the selection
    (when (region-active-p)
      (setq deactivate-mark nil)
      (set-mark (+ (point) (- (- reg-start reg-end)))))))

(defun move-section-up (offset)
  "Move a line or reg upwards"
  (interactive "p")
  (if (eq offset nil)
    setq offset 1)
  (move--section (- offset)))

(defun move-section-down (offset)
  "Move a line or region dawnwards"
  (interactive "p")
  (if (eq offset nil)
      setq offset 1)
  (move--section offset))

;;; Some stolen bindings from ergo-emacs
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)
(global-set-key (kbd "C-x n") 'new-empty-buffer)
(global-set-key (kbd "C-<next>") 'next-user-buffer)
(global-set-key (kbd "C-<prior>") 'previous-user-buffer)
(global-set-key (kbd "M-s M-s") 'save-buffer)
(global-set-key (kbd "C-t") 'smex)
(global-set-key (kbd "C-M-<up>") 'move-section-up)
(global-set-key (kbd "C-M-<down>") 'move-section-down)
