;; Initial Housekeeping Set Up

(setq inhibit-startup-message t)	; Disable the splash screen

(scroll-bar-mode -1) 			; Disable the scroll bar
(tool-bar-mode -1)			; Disable the toolbar
(tooltip-mode -1)			; Disable tooltips
(set-fringe-mode 10)			; Add fringe
(menu-bar-mode 1)			; Disable menu bar

(column-number-mode)

;; Display line numbers in editable buffers

(use-package display-line-numbers
  :ensure nil
  :hook ((text-mode prog-mode conf-mode) . display-line-numbers-mode))

;; Require server

(require 'server)
(unless (server-running-p) (server-start))

;; Enable mouse

(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; Display Settings

(setq visible-bell t)			; Set up the visible bell

;; enable the theme - the second option is the terminal theme
;; at present, I've set them both to the same theme
;; previously, it was graphic: deeper-blue and terminal: wombat

(if (display-graphic-p)
    (progn
      (load-theme 'standard-dark-tinted t))
  (progn
    (load-theme 'standard-dark-tinted t)))

;; Initialise package sources

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package 

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; amending internal settings
(use-package emacs
  :ensure nil
  :hook
  ((prog-mode text-mode conf-mode help-mode)
   . visual-wrap-prefix-mode)
  ((prog-mode text-mode conf-mode) . display-line-numbers-mode)
  :custom
  (undo-limit 80000000)

  ;; Only text-mode on new buffers
  (initial-major-mode 'text-mode)

  :config
  ;; close scratch buffer on launch
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))

;; adjust the width of line numbers (to prevent pop-in)
(setopt display-line-numbers-width 3
        display-line-numbers-widen t)

;; always show window dividers (and customise their width)
;; the of value should be either bottom-only, right-only or t
;; t will show them on the bottom and the right

(setopt window-divider-default-places t
        window-divider-default-bottom-width 4
        window-divider-default-right-width  4)

;; show links to errors when running code

(use-package shell :ensure nil
  :commands shell
  :hook ((term-mode
          eat-mode
          vterm-mode
          shell-mode
          eshell-mode)
         . compilation-shell-minor-mode))

;; show parenthesis when inside of them

(define-advice show-paren-function (:around (fn) fix)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))

;; Packages below

;; diminish - allows commands to be hidden

(use-package diminish)
(require 'diminish)

;; to allow persistence

(use-package persist)

;; mwheel - improves scrolling behaviour

(use-package mwheel
  :ensure nil
  :custom
  (mouse-wheel-scroll-amount '(1 ((shift) . 1)))
  (mouse-wheel-progressive-speed nil)
  (mouse-wheel-follow-mouse 't)
  :config
  (setq scroll-step 1)
  (setq scroll-conservatively 1000))

;; electric-cursor - a minor mode which modifies the cursor

(use-package electric-cursor
  :diminish
  :hook ((prog-mode text-mode) . electric-cursor-mode))

;; elec-pair - auto close brackets (in certain modes)

(use-package elec-pair
  :ensure nil
  :custom
  (electric-pair-open-newline-between-pairs t)
  :hook
  ((prog-mode text-mode conf-mode) . electric-pair-mode)
  (message-mode
   . (lambda ()
       (setq-local electric-pair-pairs
                   (append electric-pair-pairs
                           '((?` . ?'))))))
  ((c-mode-common
    c-ts-base-mode
    js-ts-mode css-ts-mode json-ts-mode typescript-ts-base-mode
    go-ts-mode go-mode-ts-mode rust-ts-mode
    java-ts-mode csharp-ts-mode elisp-ts-mode)
   . (lambda ()
       "Autoinsert C /**/ comments"
       (add-hook 'post-self-insert-hook
                 (lambda ()
                   (when (and (looking-back "/[*]" 2)
                              (null (re-search-forward "[^ \t]"
                                                       (line-end-position) t)))
                     (insert " ")
                     (save-excursion
                       (insert " */"))))
                 nil t))))

;; hl-line - a minor mode that highlights the current line

(use-package hl-line
  :ensure nil
  :config (global-hl-line-mode t)
  :hook ((eshell-mode
          eat-mode
          shell-mode
          term-mode
          comint-mode
          cfrs-input-mode
          image-mode
          vterm-mode)
         ;; disable hl-line for some modes
         . (lambda () (setq-local global-hl-line-mode nil))))

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

;; doom-modeline

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 20)))

;; standard themes - just some nice themes
;; remember to use (load-theme '$THEME t) to skip checks on start-up

(use-package standard-themes)

;; which-key - displays tooltips when beginning to chord a command

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; counsel - provides tooltips when executing commands
;; already installed with ivy

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)))

;; lsp-mode - activate the language server
;; note - install 'python-lsp-server[all]' (pip) before use for python support

(use-package lsp-mode)

(use-package python-mode)

(use-package lsp-ui
  :commands lsp-ui-mode)

(add-hook 'python-mode-hook 'lsp-deferred)
(add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

;; company-mode - provides pop-up autocompletion from the lsp

(use-package company
  :hook (python-mode . company-mode))

;; elpy - tools for programming in python
;; note - elpy is dependent on readline (pip)

(use-package elpy
  :init
  (elpy-enable))

;; renpy mode - to enable highlighting in renpy

(use-package renpy)

;; goggles - pulse modified region

(use-package goggles
  :diminish
  :hook ((prog-mode text-mode) . goggles-mode))

;; fill-column - enable indicator when column width exceeded
;; config currently set globally to 80

(use-package fill-column
  :ensure nil
  :hook
  ((prog-mode text-mode) . display-fill-column-indicator-mode)
  ;; Warns  if the cursor is above of 'fill-column' limit.
  (display-fill-column-indicator-mode
   . (lambda ()
       (add-hook
        'post-command-hook
        (lambda ()
          (if (> (save-excursion (end-of-line) (current-column))
                 fill-column)
              (progn
                (setq-local
                 display-fill-column-indicator-character 9474)
                (face-remap-set-base 'fill-column-indicator
                                     (list :background "#9d1f1f"
					   :foreground "#9d1f1f")))
            (setq-local
             display-fill-column-indicator-character 9474)
            (face-remap-reset-base 'fill-column-indicator)))
        nil t))))

(setq-default fill-column 80)

(defun my-renpy-fill-column-mode-hook ()
  (setq fill-column -1)
  (auto-fill-mode t))

(add-hook 'renpy-mode-hook #'my-renpy-fill-column-mode-hook)


;; show rainbow delimiters to ease identifying brackets in coding

(use-package rainbow-delimiters
  :demand t
  :custom (rainbow-delimiters-max-face-count 4)
  :hook ((prog-mode yaml-mode xml-mode mhtml-mode)
         . rainbow-delimiters-mode))

;; nerd-icons - ensure that they are enabled

(use-package nerd-icons)

;; Dashboard - something nice to look at on start-up

(use-package dashboard
  :after nerd-icons
  :custom
  (dashboard-items '((recents  .  20)))
  (dashboard-set-footer nil)
  (dashboard-set-init-info t)
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-startup-banner 'logo)
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda ()
                                (get-buffer-create "*dashboard*")
                                (dashboard-refresh-buffer))))

;; minimap - shows the location in the document on the right side
;; remember to update settings in M-x customize-group for minimap
;; to ensure launch when entering prog-mode

(use-package minimap
  :commands minimap-mode
  :custom (minimap-window-location 'right))

(if (display-graphic-p)
    (progn
      (minimap-mode 1))
  (progn
  (minimap-mode -1)))

;; magit - for using git with a gui

(use-package magit
  :commands magit-status
  :custom
  (magit-format-file-function #'magit-format-file-nerd-icons))

;; vterm - a modern terminal emulator
;; note that it is principally compiled code so will launch a compiler
;; on first use

(use-package vterm
    :ensure t)

;; flyspell - quick spellchecking
;; you must have hunspell installed for it to function
;; there must also be at least one hunspell dictionary in one of the
;; hunspell paths (run hunspell -d to check)
;; you can grab a dictionary here https://extensions.libreoffice.org
;; note that .oxt files are just zips, there's .aff and .dic files inside
;; the file name of the .dic and .aff should match the language code
;; in my case that is 'en-GB'

(use-package flyspell
  :ensure nil
  :custom
  (ispell-program-name "hunspell")
  ;; (ispell-dictionary "en") ; customise this to change the language
  :hook
  ((text-mode markdown-mode org-mode) . flyspell-mode)
  ((html-mode yaml-mode) . flyspell--mode-off)
  ;; (prog-mode . flyspell-prog-mode)
  :config
  (dolist (my-list '((org-property-drawer-re)
                     ("=" "=") ("~" "~")
                     ("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
    (add-to-list 'ispell-skip-region-alist my-list)))


;; centaur-tabs - allow for tab based editing in emacs

(use-package centaur-tabs
  :hook (emacs-startup . centaur-tabs-mode)
  :custom
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-icon-type 'nerd-icons)
  (centaur-tabs-enable-key-bindings t) ; Enable Centaur Tabs Key bindings
  ;; (centaur-tabs-set-bar 'under) ; current tab indicator
  ;; (x-underline-at-descent-line t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-modified-marker "●")
  ;; (centaur-tabs-show-navigation-buttons t) ; Navigations Buttons
  (centaur-tabs-forward-tab-text " ⏵ ")
  (centaur-tabs-backward-tab-text " ⏴ ")
  (centaur-tabs-down-tab-text " ▾ ")
  (centaur-tabs-set-icons t) ; Icons
  (centaur-tabs-gray-out-icons 'buffer)
  :config

  (dolist (names '("*Backtrace*" "*Native-compile-Log" "*cpp"
                   "*Completions" "*Ilist" "*dap" "*copilot"
                   "*EGLOT" "*Debug" "*gud-" "*locals of" "*stack frames"
                   "*input/output of" "*breakpoints of " "*threads of "
                   "*local values of " "*css-ls" "*html-ls" "*json-ls" "*ts-ls"
                   "*dashboard" "*format-all-" "*marksman" "Treemacs"
                   "*Dirvish-preview-" "*yasnippet" "*clang" "*mybuf"
                   "*Messages" "*py" "*rg" "*lua-" "*comment-tags" "*Flymake log"
                   "dir-data-" "*Async-native" "*zone"
                   "widget-choose" "minimap" "*minimap" "Ibuffer"))
    (add-to-list 'centaur-tabs-excluded-prefixes names))

  (defun centaur-tabs-buffer-groups ()
    (list
     (cond
      ((memq major-mode '(magit-process-mode
                          magit-status-mode
                          magit-diff-mode
                          magit-log-mode
                          magit-file-mode
                          magit-b
lob-mode
                          magit-blame-mode))
       "Magit")

      ((string-prefix-p "*vc-" (buffer-name))
       "VC")

      ((derived-mode-p 'Custom-mode)
       "Custom")
      ((derived-mode-p 'dired-mode)
       "Dired")

      ((memq major-mode '(helpful-mode help-mode Info-mode))
       "Help")

      ((memq major-mode '(flycheck-error-list-mode
                          flymake-diagnostics-buffer-mode
                          flymake-project-diagnostics-mode
                          compilation-mode comint-mode eshell-mode shell-mode eat-mode
                          term-mode quickrun--mode dap-ui-breakpoints-ui-list-mode
                          inferior-python-mode calendar-mode
                          inferior-emacs-lisp-mode grep-mode occur-mode))
       "Side Bar")

      ((cl-dolist (prefix centaur-tabs-excluded-prefixes)
         (when (string-prefix-p prefix (buffer-name))
           (cl-return ""))))

      (t (if-let* ((project (project-current)))
             (project-name project)
           "No project")))))

  (defun centaur-tabs-hide-tab (x)
    "Do not show buffer X in tabs."
    (let ((name (buffer-name x)))
      (or
       (if-let* ((w (window-dedicated-p (selected-window))))
           (not (eq w 'side)))
       ;; Buffer name not match below blacklist.
       (cl-dolist (prefix centaur-tabs-excluded-prefixes)
         (when (string-prefix-p prefix name)
           (cl-return t)))

       ;; Is not magit buffer.
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (defun run-after-load-theme-hook (&rest _)
    (centaur-tabs-buffer-init)
    (centaur-tabs-display-update)
    (centaur-tabs-headline-match))
  (advice-add #'load-theme :after #'run-after-load-theme-hook))

;; dired-sidebar - leveraged dired to display a sidebar

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;;;
;;;

;; preferences

(setq org-link-elisp-confirm-function nil) ;; enables simpler browsing

;; keybindings not previously defined

(global-set-key (kbd "C-M-]") 'restart-emacs)
(global-set-key (kbd "C-x C-<return>") 'minimap-mode)


;;;
;;;
;;;
;;;
;;;

;; preferences

(setq org-link-elisp-confirm-function nil) ;; enables simpler browsing

;; keybinding to fast reboot emacs

(global-set-key (kbd "C-M-]") 'restart-emacs)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0b41a4a9f81967daacd737f83d3eac7e3112d642e3f786cf7613de4da97a830a"
     "aa545934ce1b6fd16b4db2cf6c2ccf126249a66712786dd70f880806a187ac0b" default))
 '(minimap-major-modes '(prog-mode))
 '(package-selected-packages
   '(all-the-icons apheleia breadcrumb centaur-tabs command-log-mode counsel
		   dashboard diminish dired-sidebar dirvish doom-modeline
		   eldoc-box electric-cursor elpy goggles helpful
		   highlight-indent-guides indent-bars ivy-rich lsp-ui magit
		   mini-frame minimap nerd-icons-completion persist python-mode
		   quickrun rainbow-delimiters renpy sideline standard-themes
		   treemacs treemacs-nerd-icons vterm which-key-posframe)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
