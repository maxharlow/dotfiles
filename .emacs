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


; builtin modes
(menu-bar-mode -1)         ; no menubar
(show-paren-mode t)        ; highlight matching parentheses
(electric-pair-mode t)     ; automatically pair characters
(electric-indent-mode t)   ; automatically indent
(global-hl-line-mode t)    ; highlight current line
(global-linum-mode t)      ; numbered lines
(setq linum-format "%3d ")


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


; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 1)
(setq ac-auto-show-menu ac-delay)
(setq ac-quick-help-delay (+ ac-auto-show-menu 0.5))


; undo-tree
(global-undo-tree-mode t)


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
