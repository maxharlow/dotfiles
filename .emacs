; mode-line format
(defun mode-line ()
    (let* (
              (project     (if (projectile-project-p)
                               (concat (projectile-project-name) " │ ")))
              (buffer      (if (projectile-project-p)
                               (file-relative-name (buffer-name) (projectile-project-root))
                               (substring-no-properties (buffer-name))))
              (saved       (if (buffer-modified-p) " •" (if buffer-read-only " ×")))
              (position    mode-line-position)
              (coding      (upcase (symbol-name buffer-file-coding-system)))
              (git-branch  (if (eq (vc-backend (buffer-file-name)) 'Git)
                               (concat " │ " (replace-regexp-in-string "\n" "" (vc-git--run-command-string nil "rev-parse" "--abbrev-ref" "HEAD")))))
              (git-dirty   (if (eq (vc-backend (buffer-file-name)) 'Git)
                               (if (eq (vc-git--run-command-string nil "diff" "--quiet") nil) " •")))
              (left        (format-mode-line (list " " project buffer saved " │ " position)))
              (right       (format-mode-line (list " " coding " │ " mode-name git-branch git-dirty " ")))
              (spacer-size (- (window-total-width) (length left) (length right)))
              (spacer      (make-string (if (< spacer-size 3) 3 spacer-size) ?\s)))
        (concat left spacer right)))

(setq-default mode-line-format '(:eval (mode-line)))


; memory tweaks (for lsp)
(setq gc-cons-threshold 100000000) ; ~100MB
(setq read-process-output-max (* 1024 1024)) ; 1MB


; why backup when we can autosave
(auto-save-visited-mode t)
(setq auto-save-timeout 1)
(setq auto-save-interval 20)
(setq make-backup-files nil)
(setq create-lockfiles nil)


; default character encoding
(prefer-coding-system 'utf-8-unix)


; remove scratch buffer
(kill-buffer "*scratch*")


; save customisation separately
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))


; layout display
(set-display-table-slot standard-display-table 'vertical-border ?│)
(set-display-table-slot standard-display-table 'wrap ? )
(set-display-table-slot standard-display-table 'truncation ?…)
(setq-default truncate-lines t)


; builtin modes
(menu-bar-mode -1)          ; no menubar
(column-number-mode t)      ; keep track of what column we're in
(show-paren-mode t)         ; highlight matching parentheses
(electric-pair-mode t)      ; automatically pair characters
(global-auto-revert-mode t) ; automatically reload changed buffers
(global-hl-line-mode t)     ; highlight current line
(global-display-line-numbers-mode t)
(setq uniquify-buffer-name-style 'forward)
(setq tab-always-indent 'complete)


; shortcuts
(global-set-key (kbd "C-M-n") 'scroll-up-line)
(global-set-key (kbd "C-M-p") 'scroll-down-line)
(global-set-key (kbd "C-n")   (lambda () (interactive) (forward-line  5)))
(global-set-key (kbd "C-p")   (lambda () (interactive) (forward-line -5)))
(global-set-key (kbd "M-3")   (lambda () (interactive) (insert "#")))
(global-set-key (kbd "M-;")   'comment-line)
(global-set-key (kbd "M-%")   'query-replace-regexp)


; colourscheme
(set-face-attribute 'mode-line                nil :foreground "black"         :background "brightwhite"                            :inverse-video 'unspecified)
(set-face-attribute 'header-line              nil :foreground "black"         :background "brightwhite"   :underline 'unspecified                              :inherit 'unspecified)
(set-face-attribute 'line-number              nil :foreground "brightwhite"   :background "brightblack")
(set-face-attribute 'line-number-current-line nil :foreground "white"         :background "brightblack")
(set-face-attribute 'minibuffer-prompt        nil :foreground "brightwhite")
(set-face-attribute 'highlight                nil                             :background "brightblack")
(set-face-attribute 'region                   nil :foreground "black"         :background "brightblue")
(set-face-attribute 'show-paren-match         nil :foreground "white"         :background "brightmagenta")
(set-face-attribute 'show-paren-mismatch      nil :foreground "white"         :background "red"                                    :inverse-video t)
(set-face-attribute 'trailing-whitespace      nil                             :background "red")


; syntax highlighting
(set-face-attribute 'font-lock-keyword-face       nil :foreground "blue"                    :weight 'bold)
(set-face-attribute 'font-lock-builtin-face       nil :foreground "blue"                    :weight 'bold)
(set-face-attribute 'font-lock-function-name-face nil :foreground "blue")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "yellow")
(set-face-attribute 'font-lock-constant-face      nil :foreground "yellow")
(set-face-attribute 'font-lock-string-face        nil :foreground "green")
(set-face-attribute 'font-lock-type-face          nil :foreground "cyan")
(set-face-attribute 'font-lock-comment-face       nil :foreground "red")
(set-face-attribute 'font-lock-warning-face       nil :foreground "white" :background "red" :weight 'bold :inherit 'unspecified)


; dired
(require 'dired)
(setq dired-listing-switches "-lohaF")
(set-face-attribute 'dired-header     nil :foreground "brightwhite"                                   :inherit 'unspecified)
(set-face-attribute 'dired-directory  nil :foreground "green"                                         :inherit 'unspecified)
(set-face-attribute 'dired-symlink    nil :foreground "magenta"                                       :inherit 'unspecified)
(set-face-attribute 'dired-mark       nil :foreground "black"       :background "white" :weight 'bold :inherit 'unspecified)
(set-face-attribute 'dired-marked     nil :foreground "yellow"                          :weight 'bold :inherit 'unspecified)
(set-face-attribute 'dired-flagged    nil :foreground "red"                             :weight 'bold :inherit 'unspecified)
(set-face-attribute 'dired-perm-write nil                                                             :inherit 'unspecified)


; text editing
(add-hook 'text-mode-hook (lambda () (setq truncate-lines nil)))
(add-hook 'text-mode-hook (lambda () (setq word-wrap t)))


; javascript editing
; note lsp requires: mkdir -p ~/.emacs.d/.cache/lsp/npm/{typescript,typescript-language-server}/lib
(add-hook 'js-mode-hook (lambda () (define-key js-mode-map (kbd "M-.") 'lsp-find-definition)))


; packages
(require 'package)
(setq package-selected-packages
    '(
         orderless
         selectrum
         marginalia
         ctrlf
         iflipb
         projectile
         consult
         company
         company-shell
         syntax-subword
         move-text
         which-key
         undo-tree
         editorconfig
         flycheck
         diff-hl
         idle-highlight-mode
         smartscan
         indent-guide
         lsp-mode
         markdown-mode
         csv-mode
         json-mode
         yaml-mode
         dotenv-mode
         dockerfile-mode
         cypher-mode))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defun package-all-installed ()
    (cl-loop for p in package-selected-packages
        when (not (package-installed-p p)) return nil
        finally return t))

(unless (package-all-installed)
    (package-refresh-contents)
    (package-install-selected-packages))


; orderless
(require 'orderless)
(setq completion-styles '(orderless))


; selectrum
(require 'selectrum)
(setq selectrum-refine-candidates-function 'orderless-filter)
(setq selectrum-highlight-candidates-function 'orderless-highlight-matches)
(global-set-key (kbd "C-x C-z") 'selectrum-repeat)
(set-face-attribute 'selectrum-current-candidate     nil :foreground "black" :background "white" :inherit 'unspecified)
(set-face-attribute 'selectrum-completion-annotation nil                                         :inherit 'unspecified)
(selectrum-mode t)


; marginalia
(require 'marginalia)
(setq marginalia-annotators '(marginalia-annotators-heavy))
(marginalia-mode t)


; ctrlf
(require 'ctrlf)
(set-face-attribute 'ctrlf-highlight-active nil  :foreground "black" :background "white"         :inherit 'unspecified)
(set-face-attribute 'ctrlf-highlight-passive nil :foreground "white" :background "brightmagenta" :inherit 'unspecified)
(ctrlf-mode t)


; iflipb
(require 'iflipb)
(setq iflipb-wrap-around t)
(setq iflipb-permissive-flip-back t)
(global-set-key (kbd "C-x <right>") 'iflipb-next-buffer)
(global-set-key (kbd "C-x <left>") 'iflipb-previous-buffer)
(global-set-key (kbd "C-x k") 'iflipb-kill-buffer)


; projectile
(require 'projectile)
(setq projectile-completion-system 'default)
(define-key projectile-mode-map (kbd "C-j") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-j f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-j %") 'projectile-replace-regexp)
(define-key projectile-mode-map (kbd "C-j s") 'consult-ripgrep)
(projectile-mode t)


; consult
(require 'consult)
(setq consult-async-min-input 1)
(setq consult-project-root-function #'projectile-project-root)
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "M-y") 'consult-yank-pop)
(global-set-key (kbd "M-g M-g") 'consult-goto-line)


; company
(require 'company)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-tooltip-align-annotations t)
(add-to-list 'company-backends 'company-shell)
(define-key company-mode-map (kbd "TAB") 'company-indent-or-complete-common)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)
(set-face-attribute 'company-tooltip                      nil :foreground "black"       :background "white")
(set-face-attribute 'company-tooltip-selection            nil :foreground "white"       :background "brightblue")
(set-face-attribute 'company-tooltip-common               nil :foreground "brightblack"                           :underline t)
(set-face-attribute 'company-tooltip-common-selection     nil :foreground "white")
(set-face-attribute 'company-tooltip-annotation           nil :foreground "brightred")
(set-face-attribute 'company-tooltip-annotation-selection nil :foreground "white")
(set-face-attribute 'company-scrollbar-bg                 nil                           :background "brightblack")
(set-face-attribute 'company-scrollbar-fg                 nil                           :background "brightwhite")
(global-company-mode t)


; syntax-subword
(require 'syntax-subword)
(global-syntax-subword-mode t)


; which-key
(which-key-mode t)


; move-text
(global-set-key (kbd "ESC <down>") 'move-text-down)
(global-set-key (kbd "ESC <up>") 'move-text-up)


; undo-tree
(require 'undo-tree)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "undo" user-emacs-directory))))
(set-face-attribute 'undo-tree-visualizer-active-branch-face nil :foreground "white" :weight 'bold)
(set-face-attribute 'undo-tree-visualizer-default-face       nil :foreground "brightwhite")
(set-face-attribute 'undo-tree-visualizer-unmodified-face    nil :foreground "cyan")
(set-face-attribute 'undo-tree-visualizer-current-face       nil :foreground "red")
(global-undo-tree-mode t)


; editorconfig
(editorconfig-mode t)


; flycheck
(require 'flycheck)
(set-face-attribute 'flycheck-error   nil :foreground "white" :background "brightred"    :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-warning nil :foreground "white" :background "brightyellow" :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-info    nil :foreground "white" :background "brightgreen"  :underline 'unspecified :inherit 'unspecified)
(global-flycheck-mode t)


; diff-hl
(require 'diff-hl)
(setq diff-hl-side 'right)
(set-face-attribute 'diff-hl-insert nil :foreground "brightgreen" :background "brightgreen" :inherit 'unspecified)
(set-face-attribute 'diff-hl-delete nil :foreground "brightred"   :background "brightred"   :inherit 'unspecified)
(set-face-attribute 'diff-hl-change nil :foreground "brightblue"  :background "brightblue")
(global-diff-hl-mode t)
(diff-hl-margin-mode t)
(diff-hl-flydiff-mode t)


; idle-highlight
(require 'idle-highlight-mode)
(set-face-attribute 'idle-highlight nil :foreground "brightmagenta" :inherit 'unspecified)
(add-hook 'prog-mode-hook 'idle-highlight-mode)


; smartscan
(global-smartscan-mode t)


; indent-guide
(require 'indent-guide)
(setq indent-guide-char "∙")
(set-face-attribute 'indent-guide-face nil :foreground "brightwhite")
(indent-guide-global-mode t)


; lsp
(require 'lsp)
(setq lsp-enable-file-watchers nil)
(set-face-attribute 'lsp-face-highlight-read nil :foreground "brightmagenta" :background 'unspecified :underline t :inherit 'unspecified)
(add-hook 'prog-mode-hook 'lsp)


; lsp-headerline
(require 'lsp-headerline)
(setq lsp-headerline-arrow "→")
(set-face-attribute 'lsp-headerline-breadcrumb-path-face            nil :foreground "black")
(set-face-attribute 'lsp-headerline-breadcrumb-path-error-face      nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-path-warning-face    nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-path-hint-face       nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-path-info-face       nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-symbols-face         nil                                             :inherit 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-symbols-error-face   nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-symbols-warning-face nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-symbols-hint-face    nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-symbols-info-face    nil                     :underline 'unspecified)
(set-face-attribute 'lsp-headerline-breadcrumb-separator-face       nil                                             :inherit 'unspecified)


;
