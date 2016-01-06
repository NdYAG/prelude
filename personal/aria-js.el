(prelude-require-package 'react-snippets)
(prelude-require-package 'emmet-mode)

(defun setup-js2-mode ()
  (setq js2-basic-offset 2)
  (setq sgml-basic-offset 2)
  (setq emmet-expand-jsx-className? t))

(add-hook 'js2-mode-hook 'emmet-mode)
(add-hook 'js2-mode-hook 'setup-js2-mode)

(provide 'aria-js)
