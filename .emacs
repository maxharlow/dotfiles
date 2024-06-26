
; CORE

; search for packages in Melpa
(use-package package
    :config
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
)

; save customisations in a separate file
(use-package custom
    :config
    (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
)

; project shortcuts
(use-package project
    :init
    (keymap-global-unset "C-j")

    :bind
    ("C-j C-b" . project-list-buffers)
    ("C-j C-f" . project-find-file)
    ("C-j C-%" . project-query-replace-regexp)
)


; INTERFACE

; mode-line format
(setq-default mode-line-format '(""
    " "
    (:eval (if (project-current) (file-name-nondirectory (directory-file-name (project-root (project-current)))))) ; project
    (:eval (if (project-current) " → "))
    (:eval (if (project-current) (file-relative-name (buffer-name) (project-root (project-current))) (substring-no-properties (buffer-name)))) ; buffer
    " "
    (:eval (if (buffer-modified-p) "•" (if buffer-read-only "×"))) ; saved?
    " │ "
    mode-line-position
    mode-line-format-right-align
    (:eval (if (eq (vc-backend (buffer-file-name)) 'Git) (car (vc-git-branches))))
    (:eval (if (eq (vc-backend (buffer-file-name)) 'Git) (if (eq (vc-git--run-command-string nil "diff" "--quiet" "--staged") nil) " *")))
    (:eval (if (eq (vc-backend (buffer-file-name)) 'Git) (if (eq (vc-git--run-command-string nil "diff" "--quiet") nil) " •")))
    (:eval (if (eq (vc-backend (buffer-file-name)) 'Git) " │ "))
    (:eval (upcase (symbol-name buffer-file-coding-system)))
    " │ "
    mode-name
))

(use-package emacs
    :init
    (kill-buffer "*scratch*") ; remove scratch buffer
    (menu-bar-mode -1) ; no menubar

    ; keep track of where we are
    (column-number-mode t)
    (global-hl-line-mode t)
    (global-display-line-numbers-mode t)

    (electric-pair-mode t) ; automatically pair characters

    ; truncate and tidy long lines
    (set-display-table-slot standard-display-table 'vertical-border ?│)
    (set-display-table-slot standard-display-table 'wrap ? )
    (set-display-table-slot standard-display-table 'truncation ?…)
    (setq-default truncate-lines t)

    :config
    (setq uniquify-buffer-name-style 'forward) ; distinguish between buffers with the same file name

    :custom-face
    ; colourscheme faces
    (mode-line                ((t (:foreground "black"         :background "brightwhite"                            :inverse-video unspecified))))
    (line-number              ((t (:foreground "brightwhite"   :background "brightblack"))))
    (line-number-current-line ((t (:foreground "white"         :background "brightblack"))))
    (minibuffer-prompt        ((t (:foreground "brightwhite"))))
    (highlight                ((t (                            :background "brightblack"))))
    (region                   ((t (:foreground "black"         :background "brightblue"))))
    (show-paren-match         ((t (:foreground "white"         :background "brightmagenta"))))
    (show-paren-mismatch      ((t (:foreground "white"         :background "brightred"))))
    (trailing-whitespace      ((t (                            :background "red"))))
)

; orderless completion style
(use-package orderless
    :ensure t

    :config
    (setq completion-styles '(orderless basic))
    (setq completion-category-defaults nil)
    (setq completion-category-overrides '((file (styles partial-completion))))
)

; completion interface
(use-package vertico
    :ensure t

    :init
    (vertico-mode)

    :config
    (setq vertico-resize t)

    :bind
    ("C-x C-z" . vertico-repeat)

    :custom-face
    (vertico-current ((t (:foreground "black" :background "white" :inherit 'unspecified))))
)

; show annotations inside completion interface
(use-package marginalia
    :ensure t

    :init
    (marginalia-mode)

    :custom-face
    (marginalia-documentation ((t (:inherit 'unspecified))))
)

; completion-at-point interface
(use-package company
    :ensure t

    :init
    (global-company-mode)

    :config
    (setq company-idle-delay 0)
    (setq company-minimum-prefix-length 2)
    (setq company-tooltip-align-annotations t)

    :bind
    ("TAB" . company-indent-or-complete-common)
    (:map company-active-map ("TAB" . company-abort))

    :custom-face
    (company-tooltip                      ((t (:foreground "black"       :background "white"))))
    (company-tooltip-selection            ((t (:foreground "white"       :background "brightblue"))))
    (company-tooltip-common               ((t (:foreground "brightblack"                           :underline t))))
    (company-tooltip-common-selection     ((t (:foreground "white"))))
    (company-tooltip-annotation           ((t (:foreground "brightred"))))
    (company-tooltip-annotation-selection ((t (:foreground "white"))))
    (company-tooltip-scrollbar-track      ((t (                          :background "brightblack"))))
    (company-tooltip-scrollbar-thumb      ((t (                          :background "brightwhite"))))
)

; improved search and navigation commands
(use-package consult
    :ensure t

    :config
    (setq consult-async-min-input 1)

    :bind
    ("M-y"     . consult-yank-pop)
    ("C-x b"   . consult-buffer)
    ("M-g g"   . consult-goto-line)
    ("C-j C-s" . consult-ripgrep)
    ("C-j C-b" . consult-project-buffer)
)

; highlight uncommitted changes
(use-package diff-hl
    :ensure t

    :init
    (global-diff-hl-mode)
    (diff-hl-margin-mode)
    (diff-hl-flydiff-mode)

    :config
    (setq diff-hl-side 'right)

    :custom-face
    (diff-hl-insert ((t (:foreground "brightgreen" :background "brightgreen" :inherit 'unspecified))))
    (diff-hl-delete ((t (:foreground "brightred"   :background "brightred"   :inherit 'unspecified))))
    (diff-hl-change ((t (:foreground "brightblue"  :background "brightblue"))))
)

; display indentation markers
(use-package indent-guide
    :ensure t

    :hook
    (prog-mode . indent-guide-mode)

    :config
    (setq indent-guide-char "∙")

    :custom-face
    (indent-guide-face ((t (:foreground "brightwhite"))))
)

; highlight current symbol
(use-package idle-highlight-mode
    :ensure t

    :hook
    (prog-mode . idle-highlight-mode)

    :custom-face
    (idle-highlight ((t (:foreground "brightmagenta" :inherit 'unspecified))))
)

; show onward keybindings
(use-package which-key
    :ensure t

    :init
    (which-key-mode)
)


; MOVEMENT

; movement shortcuts
(use-package emacs
    :bind
    ("C-M-n" . 'scroll-up-line)
    ("C-M-p" . 'scroll-down-line)
    ("C-n"   . (lambda () (interactive) (forward-line  5)))
    ("C-p"   . (lambda () (interactive) (forward-line -5)))
)

; search in buffers
(use-package isearch
    :config
    (setq isearch-repeat-on-direction-change t)

    :custom-face
    (isearch        ((t (:foreground "black" :background "white"))))
    (lazy-highlight ((t (:foreground "white" :background "brightmagenta"))))
)

; jump between current symbols with M-n and M-p
(use-package smartscan
    :ensure t

    :init
    (global-smartscan-mode)
)

; camelcase-aware point movement
(use-package syntax-subword
    :ensure t

    :init
    (global-syntax-subword-mode)
)


; EDITING

(use-package emacs
    :init
    (prefer-coding-system 'utf-8-unix) ; default character encoding

    :config
    ; autosaves and backups
    (auto-save-visited-mode t)
    (setq auto-save-timeout 1)
    (setq auto-save-interval 20)
    (setq make-backup-files nil)
    (setq create-lockfiles nil)
    (setq kill-buffer-delete-auto-save-files t)

    (setq kill-whole-line t) ; when point is in column zero kill the newline as well as the line itself

    (setq tab-always-indent 'complete) ; tab key should indent on first press, complete on second

    ; text editing
    (add-hook 'text-mode-hook (lambda () (setq truncate-lines nil)))
    (add-hook 'text-mode-hook (lambda () (setq word-wrap t)))

    :bind
    ; editing shortcuts
    ("M-3" . (lambda () (interactive) (insert "#")))
    ("M-;" . 'comment-line)
    ("M-%" . 'query-replace-regexp)
)

; reread from disc if the underlying file changes
(use-package autorevert
    :init
    (global-auto-revert-mode)

    :config
    (setq auto-revert-interval 1)
    (setq auto-revert-check-vc-info t)
)

; persist undo data
(use-package undo-fu-session
    :ensure t

    :init
    (undo-fu-session-global-mode)
)

; undo tree interface
(use-package vundo
    :ensure t

    :config
    (setq vundo-glyph-alist vundo-unicode-symbols)

    :bind
    ("C-x u" . vundo)
)

; move current line up or down
(use-package move-text
    :ensure t

    :bind
    ("ESC <down>" . move-text-down)
    ("ESC <up>"   . move-text-up)
)

; respect editorconfig files
(use-package editorconfig
    :ensure t

    :init
    (editorconfig-mode)
)


; LANGUAGES

(use-package emacs
    ; syntax highlighting faces
    :custom-face
    (font-lock-keyword-face       ((t (:foreground "blue"                             :weight bold))))
    (font-lock-builtin-face       ((t (:foreground "blue"                             :weight bold))))
    (font-lock-function-name-face ((t (:foreground "cyan"))))
    (font-lock-variable-name-face ((t (:foreground "yellow"))))
    (font-lock-constant-face      ((t (:foreground "yellow"))))
    (font-lock-string-face        ((t (:foreground "green"))))
    (font-lock-escape-face        ((t (:foreground "green"                            :weight bold :inherit 'unspecified))))
    (font-lock-type-face          ((t (:foreground "cyan"))))
    (font-lock-comment-face       ((t (:foreground "red"))))
    (font-lock-warning-face       ((t (:foreground "black" :background "brightyellow"              :inherit 'unspecified))))
)

; prompt install treesit grammars and automatically switch to treesit modes when available
(use-package treesit-auto
    :ensure t

    :config
    (global-treesit-auto-mode)
    (setq treesit-auto-install 'prompt)
)

; interface with lsp servers
; not enabled by default
(use-package eglot
    :custom-face
    (eglot-diagnostic-tag-unnecessary-face ((t (:foreground "black"         :background "brightyellow" :inherit 'unspecified))))
    (eglot-highlight-symbol-face           ((t (:foreground "brightmagenta"                            :inherit 'unspecified))))
)

; ensure other language modes are installed
(use-package markdown-mode
    :ensure t
)
(use-package csv-mode
    :ensure t
)
(use-package json-mode
    :ensure t
)
(use-package yaml-mode
    :ensure t
)
(use-package dotenv-mode
    :ensure t
)

; directory listings
(use-package dired
    :config
    (setq dired-listing-switches "-lohaF")

    :custom-face
    (dired-header     ((t (:foreground "brightwhite"                                  :inherit 'unspecified))))
    (dired-directory  ((t (:foreground "green"                                        :inherit 'unspecified))))
    (dired-symlink    ((t (:foreground "magenta"                                      :inherit 'unspecified))))
    (dired-mark       ((t (:foreground "black"       :background "white" :weight bold :inherit 'unspecified))))
    (dired-marked     ((t (:foreground "yellow"                          :weight bold :inherit 'unspecified))))
    (dired-flagged    ((t (:foreground "red"                             :weight bold :inherit 'unspecified))))
    (dired-perm-write ((t (                                                           :inherit 'unspecified))))
)


;;
