(global-linum-mode t)
(mouse-avoidance-mode 'animate)
(setq x-select-enable-clipboard t)

(scroll-bar-mode 0)

(set-face-attribute 'default nil :height 200)
(set-frame-font "Inconsolata")
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family "PingFang SC" :size 18)))

(column-number-mode t)
;;; customize linum-mode for base16-ocean-dark
(add-hook 'linum-before-numbering-hook
          (lambda ()
            (setq linum-format
                  (let ((w (length (number-to-string
                                    (count-lines (point-min) (point-max))))))
                    (concat " %" (number-to-string w) "d ")))))
(set-face-attribute 'linum nil :background (face-background 'default))
(set-face-attribute 'fringe nil :background (face-background 'default))

(require 'hlinum)
(hlinum-activate)
(set-face-attribute 'linum-highlight-face nil
                    :foreground (face-foreground 'default)
                    :background (face-background 'highlight))
