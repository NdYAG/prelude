(prelude-require-package 'helm-css-scss)

(eval-after-load 'scss-mode
  (progn
    (setq css-indent-offset 4)
    (local-set-key (kbd "c-c s") 'helm-css-scss)
    ))

(provide 'aria-css)
