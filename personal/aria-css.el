(prelude-require-package 'helm-css-scss)

(defun scss-mode-hook-setting()
  (setq css-indent-offset 4)
  (local-set-key (kbd "C-c S") 'helm-css-scss))

(add-hook 'scss-mode-hook 'scss-mode-hook-setting)

(provide 'aria-css)
