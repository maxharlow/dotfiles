; mode-line format
(defun mode-line ()
    (let* (
              (saved       (if (buffer-modified-p) "• " (if buffer-read-only "× ")))
              (project     (and (bound-and-true-p projectile-mode) (projectile-project-p) (concat (projectile-project-name) " ❯ ")))
              (position    mode-line-position)
              (coding      (upcase (symbol-name buffer-file-coding-system)))
              (git-branch  (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (concat " ∙ " (replace-regexp-in-string "\n" "" (vc-git--run-command-string nil "rev-parse" "--abbrev-ref" "HEAD")))))
              (git-dirty   (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (when (eq (vc-git--run-command-string nil "diff" "--quiet") nil) " •")))
              (left        (format-mode-line (list " " saved project (buffer-name) "  " position)))
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


; default character encoding
(prefer-coding-system 'utf-8-unix)


; remove scratch buffer
(kill-buffer "*scratch*")


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
(set-face-attribute 'show-paren-match         nil :foreground "brightmagenta" :background 'unspecified)
(set-face-attribute 'show-paren-mismatch      nil :foreground "white"         :background "red"         :inverse-video t)
(set-face-attribute 'trailing-whitespace      nil :foreground 'unspecified    :background "red")


; syntax highlighting
(set-face-attribute 'font-lock-keyword-face       nil :foreground "blue")
(set-face-attribute 'font-lock-builtin-face       nil :foreground "blue")
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


; packages
(require 'package)
(setq package-selected-packages
    '(
         ivy
         counsel
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
         indent-guide
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


; ivy
(ivy-mode t)
(setq ivy-use-selectable-prompt t)
(global-set-key (kbd "C-r") 'ivy-resume)
(set-face-attribute 'ivy-current-match           nil :foreground 'unspecified :background "brightblue"  :weight 'unspecified)
(set-face-attribute 'ivy-minibuffer-match-face-1 nil :foreground 'unspecified :background 'unspecified  :weight 'unspecified)
(set-face-attribute 'ivy-minibuffer-match-face-2 nil :foreground "white"      :background "brightcyan"  :weight 'unspecified)
(set-face-attribute 'ivy-minibuffer-match-face-3 nil :foreground "white"      :background "brightcyan"  :weight 'unspecified)
(set-face-attribute 'ivy-minibuffer-match-face-4 nil :foreground "white"      :background "brightcyan"  :weight 'unspecified)


; swiper
(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(require 'swiper)
(set-face-attribute 'swiper-match-face-1 nil :inherit 'ivy-minibuffer-match-face-1)
(set-face-attribute 'swiper-match-face-2 nil :inherit 'ivy-minibuffer-match-face-2)
(set-face-attribute 'swiper-match-face-3 nil :inherit 'ivy-minibuffer-match-face-3)
(set-face-attribute 'swiper-match-face-4 nil :inherit 'ivy-minibuffer-match-face-4)


; projectile
(setq projectile-completion-system 'ivy)
(setq projectile-keymap-prefix (kbd "C-j"))
(projectile-global-mode t)
(define-key projectile-mode-map (kbd "C-j C-f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-j C-s") (lambda () (interactive) (counsel-ag "" (projectile-project-root))))


; company
(global-company-mode t)
(setq company-idle-delay 0)
(setq company-tooltip-align-annotations t)
(setq company-dabbrev-downcase nil)
(add-to-list 'company-backends 'company-shell)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)
(set-face-attribute 'company-tooltip            nil :foreground "black"       :background "white")
(set-face-attribute 'company-tooltip-selection  nil :foreground "white"       :background "brightblue")
(set-face-attribute 'company-tooltip-annotation nil :foreground "brightred")
(set-face-attribute 'company-tooltip-common     nil :foreground "brightblack"                           :underline t)
(set-face-attribute 'company-scrollbar-bg       nil                           :background "brightblack")
(set-face-attribute 'company-scrollbar-fg       nil                           :background "brightwhite")


; which-key
(which-key-mode t)


; move-text
(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "M-p") 'move-text-up)


; undo-tree
(global-undo-tree-mode t)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "~/.emacs.d/undo/"))))
(set-face-attribute 'undo-tree-visualizer-active-branch-face nil :foreground "white" :weight 'bold)
(set-face-attribute 'undo-tree-visualizer-default-face       nil :foreground "brightwhite")
(set-face-attribute 'undo-tree-visualizer-unmodified-face    nil :foreground "cyan")
(set-face-attribute 'undo-tree-visualizer-current-face       nil :foreground "red")


; editorconfig
(editorconfig-mode t)


; flycheck
(global-flycheck-mode t)
(set-face-attribute 'flycheck-error   nil :background "red"    :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-warning nil :background "yellow" :underline 'unspecified :inherit 'unspecified)
(set-face-attribute 'flycheck-info    nil :background "green"  :underline 'unspecified :inherit 'unspecified)


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


; indent-guide
(indent-guide-global-mode t)
(setq indent-guide-char "∙")
(set-face-attribute 'indent-guide-face nil :foreground "brightwhite")
