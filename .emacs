; no menubar
(menu-bar-mode -1)


; mode-line format
(setq default-mode-line-format
    (list
        " " 'mode-line-modified
	" " 'mode-line-buffer-identification
        " " 'mode-line-modes
	" " 'mode-line-position
	" " 'vc-mode
    )
)


; line numbering
(global-linum-mode t)
(setq linum-format "%3d ")
(set-face-foreground 'linum "brightblack")


; current line highlighting
(global-hl-line-mode t)
(set-face-background 'hl-line "brightblack")


; show parentheses
(show-paren-mode t)
(set-face-background 'show-paren-match "blue")


; mouse
(xterm-mouse-mode t)
(global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] '(lambda () (interactive) (scroll-up 1)))
