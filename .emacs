; mode-line format
(setq-default mode-line-format
  (list " " mode-line-modified
        " " mode-line-buffer-identification
        " " (upcase (symbol-name buffer-file-coding-system))
        " " mode-name
        " " vc-mode
        " " mode-line-position))


; why backup when we can autosave
(setq make-backup-files nil)
(setq auto-save-visited-file-name t)
(setq auto-save-timeout 1)
(setq auto-save-interval 20)


; default character encoding
(prefer-coding-system 'utf-8-unix)


; truncate lines
(setq-default truncate-lines t)
(set-display-table-slot standard-display-table 'truncation ?…)


; builtin modes
(menu-bar-mode -1)          ; no menubar
(show-paren-mode t)         ; highlight matching parentheses
(electric-pair-mode t)      ; automatically pair characters
(electric-indent-mode t)    ; automatically indent
(icomplete-mode t)          ; autocompletion in minibuffer
(global-subword-mode t)     ; stop point between camelcased words
(global-auto-revert-mode t) ; automatically reload changed buffers
(global-hl-line-mode t)     ; highlight current line
(global-linum-mode t)       ; numbered lines
(setq linum-format "%3d ")


; shortcuts
(global-set-key (kbd "C-M-n") 'scroll-up-line)
(global-set-key (kbd "C-M-p") 'scroll-down-line)

(global-set-key (kbd "C-c <up>") 'enlarge-window)
(global-set-key (kbd "C-c <down>") 'shrink-window)
(global-set-key (kbd "C-c <left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-c <right>") 'enlarge-window-horizontally)

(global-set-key (kbd "M-3") '(lambda () (interactive) (insert-string "#")))


; packages
(package-initialize)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(unless
  (package-installed-p 'auto-complete)
  (package-refresh-contents)
  (package-install 'auto-complete))
(unless
  (package-installed-p 'flycheck)
  (package-refresh-contents)
  (package-install 'flycheck))
(unless
  (package-installed-p 'undo-tree)
  (package-refresh-contents)
  (package-install 'undo-tree))
(unless
  (package-installed-p 'idle-highlight-mode)
  (package-refresh-contents)
  (package-install 'idle-highlight-mode))
(unless
  (package-installed-p 'multiple-cursors)
  (package-refresh-contents)
  (package-install 'multiple-cursors))
(unless
  (package-installed-p 'diff-hl)
  (package-refresh-contents)
  (package-install 'diff-hl))
(unless
  (package-installed-p 'projectile)
  (package-refresh-contents)
  (package-install 'projectile))
(unless
  (package-installed-p 'grizzl)
  (package-refresh-contents)
  (package-install 'grizzl))
(unless
  (package-installed-p 'editorconfig)
  (package-refresh-contents)
  (package-install 'editorconfig))
(unless
  (package-installed-p 'markdown-mode)
  (package-refresh-contents)
  (package-install 'markdown-mode))
(unless
  (package-installed-p 'dockerfile-mode)
  (package-refresh-contents)
  (package-install 'dockerfile-mode))
(unless
  (package-installed-p 'cypher-mode)
  (package-refresh-contents)
  (package-install 'cypher-mode))
(unless
  (package-installed-p 'scala-mode2)
  (package-refresh-contents)
  (package-install 'scala-mode2))
(unless
  (package-installed-p 'ensime)
  (package-refresh-contents)
  (package-install 'ensime))
(unless
  (package-installed-p 'tern)
  (package-refresh-contents)
  (package-install 'tern))


; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 1)
(setq ac-auto-show-menu ac-delay)
(setq ac-quick-help-delay (+ ac-auto-show-menu 0.5))


; flycheck
(global-flycheck-mode t)


; undo-tree
(global-undo-tree-mode t)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "~/.emacs-undo/"))))


; highlight other instances of current word
(idle-highlight-mode)


; inline diffs
(global-diff-hl-mode t)
(setq diff-hl-side 'right)
(diff-hl-margin-mode)


; project handling
(projectile-global-mode t)
(setq projectile-completion-system 'grizzl)
(global-set-key (kbd "C-x f") 'projectile-find-file)


; editorconfig
(editorconfig-mode t)
