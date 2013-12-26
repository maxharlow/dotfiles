; mode-line format
(setq-default mode-line-format
  (list " " 'mode-line-modified
        " " 'mode-line-buffer-identification
	" " 'mode-name
        " " 'vc-mode
        " " 'mode-line-position))


; why backup when we can autosave
(setq make-backup-files nil)
(setq auto-save-visited-file-name t)
(setq auto-save-timeout 5)


; default character encoding
(set-language-environment "UTF-8")


; builtin modes
(menu-bar-mode -1)          ; no menubar
(show-paren-mode t)         ; highlight matching parentheses
(electric-pair-mode t)      ; automatically pair characters
(electric-indent-mode t)    ; automatically indent
(global-auto-revert-mode t) ; automatically reload changed buffers
(global-hl-line-mode t)     ; highlight current line
(global-linum-mode t)       ; numbered lines
(setq linum-format "%3d ")
(require 'uniquify)         ; clarify buffer names
(setq uniquify-buffer-name-style 'reverse)


; shortcuts
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")


; packages
(package-initialize)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(unless
  (package-installed-p 'auto-complete)
  (package-refresh-contents)
  (package-install 'auto-complete))
(unless
  (package-installed-p 'undo-tree)
  (package-refresh-contents)
  (package-install 'undo-tree))
(unless
  (package-installed-p 'idle-highlight-mode)
  (package-refresh-contents)
  (package-install 'idle-highlight-mode))
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
  (package-installed-p 'scala-mode2)
  (package-refresh-contents)
  (package-install 'scala-mode2))
(unless
  (package-installed-p 'markdown-mode)
  (package-refresh-contents)
  (package-install 'markdown-mode))


; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 1)
(setq ac-auto-show-menu ac-delay)
(setq ac-quick-help-delay (+ ac-auto-show-menu 0.5))


; undo-tree
(global-undo-tree-mode t)


; highlight other instances of current word
(idle-highlight-mode)


; inline diffs
(global-diff-hl-mode t)
(setq diff-hl-margin-side 'right)
(diff-hl-margin-mode)


; project handling
(projectile-global-mode t)
(setq projectile-completion-system 'grizzl)
(global-set-key (kbd "C-x f") 'projectile-find-file)


; ensime
(add-to-list 'load-path "/usr/lib/ensime/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
