;----------------------------------------
; shortcut enhancement
; use M-x global-set-key to bind.
; use C-x Esc Esc to repeat.
;----------------------------------------
(defalias 'qrr 'query-replace-regexp)
(defalias 'oc 'occur)
(defalias 'evb 'eval-buffer)
(defalias 'mkdir 'make-directory)
(defalias 'yes-or-no-p 'y-or-n-p)

(defadvice occur (after goto-and-resize activate compile)
  "After opening an occur window, goto the buffer and resize it"
  (let ((w (get-buffer-window "*Occur*")))
    (when (window-live-p w)
      (select-window w)))
  (shrink-window-if-larger-than-buffer))

(defun find-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))
(global-set-key (kbd "H-SPC") 'find-user-init-file)

(defun open-with()
  "Open file with xdg-open in linux"
  (interactive)
  (when buffer-file-name
    (let ((process-connection-type nil)
          (browser (read-char-from-minibuffer "Open with: [g]Google Chrome [f]Firefox [o]Opera [x]xdg-open")))
      (setq browser (char-to-string browser))
      (cond ((string-match browser "o") (start-process "" nil "opera" buffer-file-name))
            ((string-match browser "g") (start-process "" nil "google-chrome" buffer-file-name))
            ((string-match browser "f") (start-process "" nil "iceweasel" buffer-file-name))
            ((string-match browser "x") (start-process "" nil "open" buffer-file-name))
            (t (message "Open with browser canceled"))))))
;; (start-process "" nil "xdg-open" buffer-file-name))))
;; (shell-command (concat "xdg-open " buffer-file-name)))) ;; this will froze emacs
(global-set-key (kbd "C-o") 'open-with)

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (forward-line 1)))
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)

(autoload 'c-hungry-delete "cc-cmds")
(global-set-key (quote [C-backspace]) (quote c-hungry-delete))
