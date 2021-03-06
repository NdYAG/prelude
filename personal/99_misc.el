;;----------------------------------------
;; 99_misc.el
;; setup sandbox
;;----------------------------------------
(require 'ido)
(ido-mode +1)

(setq tags-table-list '(concat user-emacs-directory "TAGS"))

(add-hook 'find-file-hook 'smerge-start-session)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(add-hook 'text-mode-hook 'remove-dos-eol)

;; fix emacs dead keys
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; (global-diff-hl-mode -1)

;; cua-selection-mode
;; (cua-selection-mode t)

;; remove editorconfig hook
(remove-hook 'find-file-hook 'edconf-find-file-hook)
