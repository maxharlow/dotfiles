; mode-line format
(defun mode-line ()
    (let* (
              (saved       (if (buffer-modified-p) "• " (if buffer-read-only "× ")))
              (project     (and (bound-and-true-p projectile-mode) (projectile-project-p) (concat (projectile-project-name) " ❯ ")))
              (buffer      (substring-no-properties (buffer-name)))
              (position    mode-line-position)
              (coding      (upcase (symbol-name buffer-file-coding-system)))
              (git-branch  (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (concat " ∙ " (replace-regexp-in-string "\n" "" (vc-git--run-command-string nil "rev-parse" "--abbrev-ref" "HEAD")))))
              (git-dirty   (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (when (eq (vc-git--run-command-string nil "diff" "--quiet") nil) " •")))
              (left        (format-mode-line (list " " saved project buffer "  " position)))
              (right       (format-mode-line (list " " coding " ∙ " mode-name git-branch git-dirty " ")))
              (spacer-size (- (window-total-width) (length left) (length right)))
              (spacer      (make-string (if (< spacer-size 3) 3 spacer-size) ?\s)))
        (concat left spacer right)))

(setq-default mode-line-format '(:eval (mode-line)))


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
(global-subword-mode t)     ; stop point between camelcased words
(global-auto-revert-mode t) ; automatically reload changed buffers
(global-hl-line-mode t)     ; highlight current line
(global-display-line-numbers-mode t)
(setq uniquify-buffer-name-style 'forward)


; shortcuts
(global-set-key (kbd "C-M-n") 'scroll-up-line)
(global-set-key (kbd "C-M-p") 'scroll-down-line)
(global-set-key (kbd "C-n")   (lambda () (interactive) (forward-line  5)))
(global-set-key (kbd "C-p")   (lambda () (interactive) (forward-line -5)))
(global-set-key (kbd "M-3")   (lambda () (interactive) (insert "#")))
(global-set-key (kbd "M-;")   'comment-line)


; colourscheme
(set-face-attribute 'mode-line                nil :foreground "black"         :background "brightwhite" :inverse-video 'unspecified)
(set-face-attribute 'line-number              nil :foreground "brightwhite"   :background "brightblack")
(set-face-attribute 'line-number-current-line nil :foreground "white"         :background "brightblack")
(set-face-attribute 'minibuffer-prompt        nil :foreground "brightwhite")
(set-face-attribute 'highlight                nil                             :background "brightblack")
(set-face-attribute 'region                   nil :foreground "black"         :background "brightblue")
(set-face-attribute 'show-paren-match         nil :foreground "white"         :background "brightmagenta")
(set-face-attribute 'show-paren-mismatch      nil :foreground "white"         :background "red"         :inverse-video t)
(set-face-attribute 'trailing-whitespace      nil :foreground 'unspecified    :background "red")


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
(add-hook 'text-mode-hook '(lambda () (setq truncate-lines nil)))


; packages
(require 'package)
(setq package-selected-packages
    '(
         orderless
         selectrum
         ctrlf
         iflipb
         bufler
         projectile
         company
         company-shell
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
(selectrum-mode t)


; ctrlf
(require 'ctrlf)
(ctrlf-mode t)
(set-face-attribute 'ctrlf-highlight-active nil  :foreground "black" :background "white"         :inherit 'unspecified)
(set-face-attribute 'ctrlf-highlight-passive nil :foreground "white" :background "brightmagenta" :inherit 'unspecified)


; iflipb
(require 'iflipb)
(setq iflipb-wrap-around t)
(setq iflipb-permissive-flip-back t)
(global-set-key (kbd "C-x <right>") 'iflipb-next-buffer)
(global-set-key (kbd "C-x <left>") 'iflipb-previous-buffer)
(global-set-key (kbd "C-x k") 'iflipb-kill-buffer)


; bufler
(global-set-key (kbd "C-x b") 'bufler-switch-buffer)


; projectile
(setq projectile-completion-system 'default)
(setq projectile-keymap-prefix (kbd "C-j"))
(projectile-mode t)
(define-key projectile-mode-map (kbd "C-j C-f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-j C-s") 'projectile-ripgrep)


; company
(setq company-idle-delay 0)
(setq company-tooltip-align-annotations t)
(setq company-dabbrev-downcase nil)
(global-company-mode t)
(add-to-list 'company-backends 'company-shell)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)
(set-face-attribute 'company-tooltip                      nil :foreground "black"       :background "white")
(set-face-attribute 'company-tooltip-selection            nil :foreground "white"       :background "brightblue")
(set-face-attribute 'company-tooltip-common               nil :foreground "brightblack"                           :underline t)
(set-face-attribute 'company-tooltip-common-selection     nil :foreground "white")
(set-face-attribute 'company-tooltip-annotation           nil :foreground "brightred")
(set-face-attribute 'company-tooltip-annotation-selection nil :foreground "white")
(set-face-attribute 'company-scrollbar-bg                 nil                           :background "brightblack")
(set-face-attribute 'company-scrollbar-fg                 nil                           :background "brightwhite")


; which-key
(which-key-mode t)


; move-text
(global-set-key (kbd "ESC <down>") 'move-text-down)
(global-set-key (kbd "ESC <up>") 'move-text-up)


; undo-tree
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "undo" user-emacs-directory))))
(global-undo-tree-mode t)
(set-face-attribute 'undo-tree-visualizer-active-branch-face nil :foreground "white" :weight 'bold)
(set-face-attribute 'undo-tree-visualizer-default-face       nil :foreground "brightwhite")
(set-face-attribute 'undo-tree-visualizer-unmodified-face    nil :foreground "cyan")
(set-face-attribute 'undo-tree-visualizer-current-face       nil :foreground "red")


; editorconfig
(editorconfig-mode t)


; flycheck
(global-flycheck-mode t)
(set-face-attribute 'flycheck-error   nil :foreground "white" :background "brightred"    :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-warning nil :foreground "white" :background "brightyellow" :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-info    nil :foreground "white" :background "brightgreen"  :underline 'unspecified :inherit 'unspecified)


; diff-hl
(global-diff-hl-mode t)
(diff-hl-margin-mode t)
(diff-hl-flydiff-mode t)
(setq diff-hl-side 'right)
(set-face-attribute 'diff-hl-insert nil :foreground "brightgreen" :background "brightgreen" :inherit 'unspecified)
(set-face-attribute 'diff-hl-delete nil :foreground "brightred"   :background "brightred"   :inherit 'unspecified)
(set-face-attribute 'diff-hl-change nil :foreground "brightblue"  :background "brightblue")


; idle-highlight-mode
(require 'idle-highlight-mode)
(add-hook 'prog-mode-hook 'idle-highlight-mode)
(set-face-attribute 'idle-highlight nil :foreground "brightmagenta" :inherit 'unspecified)


; smartscan
(global-smartscan-mode t)


; indent-guide
(setq indent-guide-char "∙")
(indent-guide-global-mode t)
(set-face-attribute 'indent-guide-face nil :foreground "brightwhite")


; lsp
(require 'lsp)
(add-hook 'js-mode-hook 'lsp)
(add-hook 'js-mode-hook (lambda () (define-key js-mode-map (kbd "M-.") 'lsp-find-definition)))
(set-face-attribute 'lsp-face-highlight-read nil :foreground "brightmagenta" :background 'unspecified :underline t :inherit 'unspecified)


;
