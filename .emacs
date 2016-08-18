; mode-line format
(defun mode-line ()
    (let* (
              (saved       (if (buffer-modified-p) " *" (if buffer-read-only "READ-ONLY" "")))
              (project     (and (bound-and-true-p projectile-mode) (projectile-project-p) (concat (projectile-project-name) " ➤ ")))
              (coding      (upcase (symbol-name buffer-file-coding-system)))
              (git-branch  (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (concat "   " (replace-regexp-in-string "\n" "" (vc-git--run-command-string nil "rev-parse" "--abbrev-ref" "HEAD")))))
              (git-dirty   (when (eq (vc-backend (buffer-file-name)) 'Git)
                               (when (eq (vc-git--run-command-string nil "diff" "--quiet") nil) " *")))
              (left        (format-mode-line (list saved " " project (buffer-name) "   " mode-line-position)))
              (right       (format-mode-line (list "   " coding "   " mode-name git-branch git-dirty " ")))
              (spacer-size (- (window-total-width) (length left) (length right)))
              (spacer      (make-string (if (< spacer-size 3) 3 spacer-size) ?\s)))
        (concat left spacer right)))

(setq-default mode-line-format '(:eval (mode-line)))


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
(global-subword-mode t)     ; stop point between camelcased words
(global-auto-revert-mode t) ; automatically reload changed buffers
(global-hl-line-mode t)     ; highlight current line
(global-linum-mode t)       ; numbered lines
(setq linum-format "%3d ")
(set-face-attribute 'linum nil :foreground "brightblack")


; shortcuts
(global-set-key (kbd "C-M-n") 'scroll-up-line)
(global-set-key (kbd "C-M-p") 'scroll-down-line)


(global-set-key (kbd "M-3") '(lambda () (interactive) (insert-string "#")))


; packages
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(unless package-archive-contents (package-refresh-contents))

(setq package-selected-packages
    '(
         ivy
         projectile
         which-key
         auto-complete
         undo-tree
         diff-hl
         editorconfig
         idle-highlight-mode
         multiple-cursors
         markdown-mode
         yaml-mode
         dockerfile-mode
         cypher-mode
         scala-mode
         ensime
         tern))

(package-install-selected-packages)


; ivy
(ivy-mode t)
(global-set-key [remap isearch-forward] 'counsel-grep-or-swiper)
;; (setq completion-in-region-function 'ivy-completion-in-region)


; projectile
(setq projectile-completion-system 'ivy)
(setq projectile-keymap-prefix (kbd "C-j"))
(projectile-global-mode t)
(define-key projectile-mode-map (kbd "C-j C-f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "C-j C-s") (lambda () (interactive) (counsel-ag "" (projectile-project-root))))


; which-key
(which-key-mode t)


; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start 1)
(setq ac-auto-show-menu ac-delay)
(setq ac-quick-help-delay (+ ac-auto-show-menu 0.5))


; undo-tree
(global-undo-tree-mode t)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "~/.emacs-undo/"))))


; diff-hl (inline diffs)
(global-diff-hl-mode t)
(diff-hl-margin-mode t)
(diff-hl-flydiff-mode t)
(setq diff-hl-side 'right)
(set-face-attribute 'diff-added nil :background "green")
(set-face-attribute 'diff-removed nil :background "red")
(set-face-attribute 'diff-changed nil :background "blue")

; editorconfig
(editorconfig-mode t)
