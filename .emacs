; packages
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(unless (package-installed-p 'scala-mode2) (package-refresh-contents) (package-install 'scala-mode2))


; default tab handling
(setq-default tab-width 4)
(setq-default tab-stop-list (number-sequence 4 120 4))


; backups
(setq make-backup-files nil)


; mouse
(xterm-mouse-mode t)
(setq mouse-sel-mode t)
(global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] '(lambda () (interactive) (scroll-up 1)))


; mode-line format
(setq default-mode-line-format
	  (list " " 'mode-line-modified
			" " 'mode-line-buffer-identification
			" " 'mode-line-modes
			" " 'mode-line-position
			" " 'vc-mode)
)


; modes
(menu-bar-mode -1)         ; no menubar
(show-paren-mode t)        ; show parentheses
(global-hl-line-mode t)    ; current line highlighting
(global-linum-mode t)      ; line numbering
(setq linum-format "%3d ")

