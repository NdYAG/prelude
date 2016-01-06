(prelude-require-package 'emmet-mode)

(eval-after-load 'web-mode
  (progn
    (web-mode-set-engine "mako")
    (setq web-mode-disable-auto-pairing t)
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-indent-style 2)
    (setq web-mode-block-padding 2)
    (setq web-mode-style-padding 2)
    (setq web-mode-script-padding 2)))

(add-hook 'web-mode-hook 'emmet-mode)

(provide 'aria-web)
