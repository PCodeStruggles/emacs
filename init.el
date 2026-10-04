;; -*- lexical-binding: t; -*-

;; Package
(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(setq x-super-keysym 'meta)

(setq custom-file (expand-file-name ".emacs.custom" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

;; Ui
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(setq whitespace-style '(face spaces space-mark))
(global-whitespace-mode 1)

;; BackUp Files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; Ido
(ido-mode 1)
(ido-everywhere 1)

;; Font
(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font Mono"
                    :height 200)

;; Theme
(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))

;; Smex
(use-package smex
  :bind (("M-x" . smex)
         ("C-c C-c M-x" . execute-extended-command)))

;; SimpC
(add-to-list 'load-path "~/.emacs.d/simpc")
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(defun astyle-buffer ()
  (interactive)
  (let ((saved-line-number (line-number-at-pos)))
    (shell-command-on-region
     (point-min)
     (point-max)
     "astyle --style=kr"
     nil
     t)
    (goto-line saved-line-number)))

(global-set-key (kbd "C-x p") 'astyle-buffer)

;; Duplicate Line
(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;; Company
(use-package company
  :custom
  (company-idle-delay nil)   
  :hook (after-init . global-company-mode)
  :bind ("C-c i" . company-complete))

;; Magit
(use-package magit
  :bind ("C-x g" . magit-status))

;; Recompile
(global-set-key (kbd "C-x r") 'recompile)
