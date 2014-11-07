(prelude-require-packages
 '(
   yasnippet
   deft
   ag
   multiple-cursors
   ))


(eval-after-load 'yasnippet
  (progn
    (setq yas-snippet-dirs
          '("~/.emacs.d/snippets"
            "~/.emacs.d/elpa/yasnippet-20141017.736/snippets"
            ))
    (yas-global-mode t)))

(eval-after-load 'deft
  (progn
    (setq deft-directory "~/Dropbox/Notebook")
    (setq deft-extension "org")
    (setq deft-text-mode 'org-mode)
    (global-set-key [f8] 'deft)))

(eval-after-load 'multiple-cursors-mode
  (progn
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))
