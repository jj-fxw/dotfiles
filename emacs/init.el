
;; Initial Housekeeping Set Up

(setq inhibit-startup-message t)	; Disable the splash screen

(scroll-bar-mode -1) 			; Disable the scroll bar
(tool-bar-mode -1)			; Disable the toolbar
(tooltip-mode -1)			; Disable tooltips
(set-fringe-mode 10)			; Add fringe
(menu-bar-mode -1)			; Disable menu bar

(column-number-mode)
(global-display-line-numbers-mode t)

;; note note

;; Display Settings

(setq visible-bell t)			; Set up the visible bell

(if (display-graphic-p)
    (progn
      (load-theme 'deeper-blue))
  (progn
    (load-theme 'wombat)))

;; Initialise package sources

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
      ("org" . "https://orgmode.org/elpa/")
      ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
(package-refresh-contents))

;; Initialize use-package on non-Linux platforms

(unless (package-installed-p 'use-package)
(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Packages below

;; diminish - allows commands to be hidden

(use-package diminish)
(require 'diminish)

;; command-log-mode - lists input in a separate buffer

(use-package command-log-mode)

;; counsel - provides tooltips when executing commands
;; already installed with ivy
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)))

;; ivy - autocomplete module

(use-package ivy
  :diminish)
(ivy-mode 1)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; to allow persistence

(use-package persist)

;; doom-modeline

(use-package all-the-icons)

(use-package doom-modeline
     :init (doom-modeline-mode 1)
     :custom ((doom-modeline-height 20)))

;; exercism - intergrate with exercism.io

(use-package exercism)

;; which-key - displays tooltips when beginning to chord a command

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; reddigg - a reddit viewer for emacs

(use-package md4rd)

;; hackernews - a hacker news viewer for emacs

(use-package hackernews)

;; treemacs - provides a project tree pane

(use-package treemacs)

;; lsp-mode - activate the language server
;; note - install 'python-lsp-server[all]' (pip) before use for python support

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymaps-prefix "C-c l"))
;;  :config
;;  (lsp-enable-which-key-intergration t))

;; company-mode - provides pop-up autocompletion from the lsp
;; it will also launch a terminal when started

(use-package company
  :hook (python-mode . company-mode))

;; elpy - tools for programming in python
;; note - elpy is dependent on readline (pip)

(use-package elpy
  :init
  (elpy-enable))

;; preferences

(setq org-link-elisp-confirm-function nil) ;; enables simpler browsing

;; keybindings

(global-set-key (kbd "C-M-]") 'restart-emacs)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-mode which-key treemacs-nerd-icons reddigg nnreddit nerd-icons-ivy-rich md4rd lsp-mode hackernews exercism elpy doom-modeline diminish counsel command-log-mode all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
