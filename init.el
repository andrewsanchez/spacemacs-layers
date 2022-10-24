;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(vimscript
     react
     (auto-completion :variables
                      auto-completion-enable-snippets-in-popup t)
     autohotkey
     better-defaults
     (bibtex :variables
             bibtex-completion-bibliography '("~/Dropbox/org/refs/refs.bib")
             bibtex-completion-library-path "~/Dropbox/org/refs/"
             bibtex-completion-notes-path "~/Dropbox/org/"
             ;; Taken from https://github.com/jkitchin/org-ref#configuration
             bibtex-autokey-year-length 4
             bibtex-autokey-name-year-separator "-"
             bibtex-autokey-year-title-separator "-"
             bibtex-autokey-titleword-separator "-"
             bibtex-autokey-titlewords 2
             bibtex-autokey-titlewords-stretch 1
             bibtex-autokey-titleword-length 5
             bibtex-completion-pdf-open-function
	           (lambda (fpath)
	             (call-process "open" nil 0 nil fpath))
             )
     csv
     (deft :variables
       deft-default-extension "org"
       deft-directory "~/Dropbox/org/"
       deft-recursive t
       deft-use-filename-as-title t
       deft-use-filter-string-for-filename t
       deft-ignore-file-regexp
       (concat "\\(?:"
               "archive\\.org\\'"
               "\\)"))
     docker
     emacs-lisp
     git
     helm
     html
     javascript
     markdown
     nginx
     osx
     (org :variables
          org-enable-roam-support t
          org-enable-roam-protocol t
          org-enable-org-journal-support t
          org-modules '(habits)
          org-enable-notifications t
          org-start-notification-daemon-on-startup t
          org-archive-subtree-save-file-p t)
     pandoc
     protobuf
     python
     rust
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     slack
     (spacemacs-layouts)
     spell-checking
     syntax-checking
     sql
     terraform
     themes-megapack
     typescript
     vagrant
     version-control
     yaml
     ;; Personal layers
     as-org
     anki)
   dotspacemacs-additional-packages
   '(
     ;; magit-section
     helm-rg
     mermaid-mode
     groovy-mode)
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only)
  )

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   dotspacemacs-enable-emacs-pdumper nil
   dotspacemacs-emacs-pdumper-executable-file "emacs"
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-gc-cons '(100000000 0.1)
   dotspacemacs-read-process-output-max (* 1024 1024)
   dotspacemacs-use-spacelpa nil
   dotspacemacs-verify-spacelpa-archives t
   dotspacemacs-check-for-update t
   dotspacemacs-elpa-subdirectory 'emacs-version
   dotspacemacs-editing-style 'vim
   dotspacemacs-startup-buffer-show-version t
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-show-startup-list-numbers t
   dotspacemacs-startup-buffer-multi-digit-delay 0.4
   dotspacemacs-new-empty-buffer-major-mode 'text-mode
   dotspacemacs-scratch-mode 'org-mode
   dotspacemacs-scratch-buffer-persistent t
   dotspacemacs-scratch-buffer-unkillable t
   dotspacemacs-initial-scratch-message nil
   dotspacemacs-themes '(solarized-dark
                         solarized-light)
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Source Code Pro"
                               :size 18.0
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)

   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-auto-generate-layout-names nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'original
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native t
   dotspacemacs-maximized-at-startup t
   dotspacemacs-undecorated-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-scroll-bar-while-scrolling t
   dotspacemacs-line-numbers '(:relative relative
     :disabled-for-modes dired-mode
                         doc-view-mode
                         pdf-view-mode
                         :size-limit-kb 1000)
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-activate-smartparens-mode t
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-enable-server t
   dotspacemacs-server-socket-dir nil
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   dotspacemacs-frame-title-format "%I@%S"
   dotspacemacs-icon-title-format nil
   dotspacemacs-show-trailing-whitespace t
   dotspacemacs-whitespace-cleanup nil
   dotspacemacs-use-clean-aindent-mode t
   dotspacemacs-use-SPC-as-y nil
   dotspacemacs-swap-number-row nil
   dotspacemacs-zone-out-when-idle nil
   dotspacemacs-pretty-docs nil
   dotspacemacs-home-shorten-agenda-source nil
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  (setq insert-directory-program "/usr/local/Cellar/coreutils/8.32/libexec/gnubin/ls"
        org-roam-v2-ack t))



(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump.")


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (setq projectile-require-project-root nil
        mermaid-mmdc-location "~/node_modules/.bin/mmdc"
        auto-revert-mode t
        custom-file "/dev/null"
        epa-pinentry-mode 'loopback
        magit-git-executable "/usr/local/bin/git"

        auto-save-visited-mode t
        projectile-project-search-path '("~/Projects/" "~/anki/" "~/healthvana/" "~/Projects/anki_addons")
        fill-column 80
        require-final-newline t)

  (add-to-list 'warning-suppress-types '(yasnippet backquote-change))
  (setenv "GPG_AGENT_INFO" nil)
  (org-roam-db-autosync-mode)
  (require 'org-roam-protocol)
  (add-hook 'org-mode-hook #'auto-fill-mode)
  ;; May be necessary if running into problems with org-batch-store-agenda-views
  (org-reload)
  ;; org-ref magic to export to other formats.
  (add-hook 'org-export-before-parsing-hook 'org-ref-csl-preprocess-buffer))
;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
)
