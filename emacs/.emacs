;; -*- lexical-binding: t; -*-
(require 'package)

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(tool-bar-mode -1)
;;(setq mac-allow-anti-aliasing t)

(setq ns-use-srgb-colorspace t)
(setq package-enable-at-startup nil)


(package-initialize)
(use-package exec-path-from-shell :ensure t)

(when (memq window-system '(mac ns x pgtk))
  (exec-path-from-shell-initialize))


(setq treesit-enabled-modes t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq display-line-numbers-type 'relative)


(defun my/evil-scroll-and-center (order)
  (funcall order nil)
  (recenter))


(defun my/evil-scroll-up-center ()
  (interactive)
  (my/evil-scroll-and-center #'evil-scroll-up ))



(setq treesit-language-source-alist
      '((haskell "https://github.com/tree-sitter/tree-sitter-haskell")))

(defun my/evil-scroll-down-center ()
  (interactive)
  (my/evil-scroll-and-center #'evil-scroll-down ))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :bind
  (:map corfu-map
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("C-y" . corfu-insert))
  :init
  (global-corfu-mode))
;; A few more useful configurations...
(use-package emacs
  :custom
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package evil 
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-minibuffer t)
  (setq evil-undo-system 'undo-redo)
  
  
  :config 
  (evil-set-initial-state 'minibuffer-mode 'insert)
  (evil-mode 1)
  
  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode)))


(evil-set-leader 'motion (kbd "SPC"))
(evil-define-key 'normal 'global (kbd "C-u") 'my/evil-scroll-up-center)
(evil-define-key 'normal 'global (kbd "C-d") 'my/evil-scroll-down-center)
(evil-define-key 'normal 'global (kbd "K") #'eldoc-doc-buffer)

;; Use Microsoft's standalone Roslyn server for C#.
(defun my/dotnet-project-find (dir)
  (when-let* ((root
               (locate-dominating-file
                dir
                (lambda (parent)
                  (directory-files
                   parent nil "\\.\\(?:slnx?\\|csproj\\)\\'" t)))))
    (cons 'transient root)))

(add-hook 'project-find-functions #'my/dotnet-project-find)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-ignored-server-capabilities
               :semanticTokensProvider)
  (add-to-list 'eglot-ignored-server-capabilities
               :inlayHintProvider)
  (add-to-list 'eglot-ignored-server-capabilities
               :documentColorProvider)
  (add-to-list
   'eglot-server-programs
   `((csharp-mode csharp-ts-mode) .
     (,(expand-file-name "~/.dotnet/tools/roslyn-language-server")
      "--stdio" "--autoLoadProjects"))))

(dolist (hook '(csharp-mode-hook csharp-ts-mode-hook))
  (add-hook hook #'eglot-ensure))

;;(add-to-list 'evil-emacs-state-modes 'ag-mode)
(add-to-list 'evil-emacs-state-modes 'flycheck-error-list-mode)
(use-package tab-bar
  :ensure nil ; built-in
  :config
  (tab-bar-mode 1))

(add-to-list 'evil-emacs-state-modes 'git-rebase-mode)


(use-package magit :ensure t)
(use-package haskell-mode :ensure t)
(use-package vterm :ensure t)
(use-package naysayer-theme :ensure t)
(load-theme 'naysayer t)


(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

(defvar evil-mode-buffers '())

(getenv "PATH")
;;NEWCOMERS THEME SETTINGS
(setopt imenu-auto-rescan t)
(setopt view-read-only t)
;;(setq pixel-scroll-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(setopt column-number-mode t)
(setopt font-use-system-font t)
(setopt frame-resize-pixelwise t)
(setopt window-resize-pixelwise t)
(setopt frame-inhibit-implied-resize t)
(setopt mode-line-compact 'long)
(setopt save-place-mode t)
(setopt savehist-mode t)
;;(setopt minibuffer-visible-completions t)
(setopt completions-detailed t)
(setopt completions-group t)
(setopt completion-eager-update t)
(setopt completion-auto-select 'second-tab)
(setopt completion-styles '(basic emacs22 flex))
(setopt global-completion-preview-mode t)
(setopt which-key-mode t)
(setopt tab-bar-history-mode t)
(setopt tab-bar-show t)
(setopt dired-auto-revert-buffer t)
(setopt dired-mouse-drag-files t)
(setopt shell-command-prompt-show-cwd t)
(setopt mouse-drag-and-drop-region t)
(setopt mouse-drag-and-drop-region-cross-program t)
(setopt package-autosuggest-mode t)
(setopt package-menu-use-current-if-no-marks nil)
(setopt compilation-scroll-output 'first-error)
;;(add-hook 'prog-mode-hook 'flyspell-mode)
(setopt electric-pair-mode t)
(setopt indent-tabs-mode nil)
(setopt etags-regen-mode t)
(setopt vc-auto-revert-mode t)
(setopt editorconfig-mode t)
(setopt vc-dir-save-some-buffers-on-revert t)
(setopt vc-find-revision-no-save t)
(setopt vc-follow-symlinks t)
(setopt vc-use-incoming-outgoing-prefixes t)
(setopt vc-deduce-backend-nonvc-modes t)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(add-hook 'haskell-mode-hook #'eglot-ensure)

(use-package dired
  :ensure nil ; built-in
  :bind
  ;; Bind '-' in normal mode globally to jump to the current file in Dired
  (:map evil-normal-state-map
        ("-" . dired-jump))
  :config
  (when (and (eq system-type 'darwin) (executable-find "gls"))
    (setq insert-directory-program "gls"))
  ;; Ensure '-' inside Dired moves up to the parent directory
  (evil-define-key 'normal dired-mode-map
    (kbd "-") 'dired-up-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(context-menu-mode t nil nil "Copied from newcomers-presets by `copy-theme-options'")
 '(custom-safe-themes
   '("7f2c65918a7dedf4ea480a20701c0f57ddbad842113fb66e669099ee970bbff9"
     "01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
     "26d26fc2e6ded35deef0791cad0b673d2cfa908ea82abde614b5339149612f4b"
     "921f165deb8030167d44eaa82e85fcef0254b212439b550a9b6c924f281b5695"
     "e14289199861a5db890065fdc5f3d3c22c5bac607e0dbce7f35ce60e6b55fc52"
     "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0"
     "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19"
     "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326"
     "8363207a952efb78e917230f5a4d3326b2916c63237c1f61d7e5fe07def8d378"
     "5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     "955c95aeaf2fd7d33ba8809334080762db4e93987d207b2456d0af910147aa60"
     default))
 '(delete-selection-mode t nil nil "Copied from newcomers-presets by `copy-theme-options\12'")
 '(display-line-numbers-type 'relative)
 '(global-xref-mouse-mode t nil nil "Copied from newcomers-presets by `copy-theme-options'")
 '(newcomers-presets-mode t nil nil "Copied from newcomers-presets by `copy-theme-options'")
 '(package-selected-packages
   '(corfu evil-surround exec-path-from-shell gruber-darker-theme
           gruvbox-theme haskell-mode magit naysayer-theme nov
           projectile vterm))
 '(recentf-mode t nil nil "Copied from newcomers-presets by `copy-theme-options'")
 '(repeat-mode t nil nil "Copied from newcomers-presets by `copy-theme-options'")
 '(tool-bar-mode nil)
 '(warning-suppress-types '((use-package))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka" :foundry "nil" :slant normal :weight regular :height 160 :width normal)))))


;; Store all backup and auto-save files in a single directory
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))



(use-package projectile
  :ensure t
  :demand t
  :init
  (projectile-mode 1)

  :config

  ;; Restore saved sessions when Emacs starts.
  )

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(evil-define-key 'normal 'global
  (kbd "<leader>p") #'projectile-command-map)

;; Store the project root associated with each tab.

(require 'tab-bar)
(require 'projectile)
(require 'cl-lib)
(require 'dired)

(tab-bar-mode 1)


(defvar my/project-tab-roots (make-hash-table :test #'equal)
  "Map tab names to canonical project roots.")


(defun my/projectile-switch-project-action ()
  "Switch to an existing project tab or create a new one."
  (let* ((root (file-name-as-directory
                (expand-file-name (projectile-project-root))))
         (tabs (funcall tab-bar-tabs-function))
         (existing-tab
          (cl-find-if
           (lambda (tab)
             (equal (gethash (alist-get 'name tab)
                             my/project-tab-roots)
                    root))
           tabs)))
    (if existing-tab
        (tab-bar-switch-to-tab (alist-get 'name existing-tab))
      (let ((tab-name
             (file-name-nondirectory
              (directory-file-name root))))
        (tab-bar-new-tab)
        (tab-bar-rename-tab tab-name)
        (puthash tab-name root my/project-tab-roots)
        (setq default-directory root)
        (dired root)))))

(setq projectile-switch-project-action
      #'my/projectile-switch-project-action)
