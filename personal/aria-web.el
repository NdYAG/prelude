(prelude-require-package 'zencoding-mode)

(eval-after-load 'web-mode
  (progn
    (web-mode-set-engine "mako")
    (setq web-mode-disable-auto-pairing t)
    (setq web-mode-markup-indent-offset 4)
    (setq web-mode-css-indent-offset 4)
    (setq web-mode-code-indent-offset 4)
    (setq web-mode-indent-style 4)
    (setq web-mode-style-padding 4)
    (setq web-mode-script-padding 4)))

(add-hook 'web-mode-hook 'open-with-mako)
(add-hook 'web-mode-hook 'zencoding-mode)

(provide 'aria-web)
