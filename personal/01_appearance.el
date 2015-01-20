02_indent.el                                                                                        000644  000766  000024  00000000261 12446302676 013464  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (defun space-aholic()
  (setq indent-tabs-mode nil))
(setq tab-width 4)
(setq sgml-basic-offset 4)
(setq js-indent-level 4)
(setq css-indent-offset 4)
(setq js2-basic-offset 4)
                                                                                                                                                                                                                                                                                                                                               03_productive.el                                                                                    000644  000766  000024  00000004270 12433661257 014373  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;----------------------------------------
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
                                                                                                                                                                                                                                                                                                                                        05_dired.el                                                                                         000644  000766  000024  00000003740 12433665123 013275  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;----------------------------------------
; dired mode enhancement
;----------------------------------------
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
;; borrow from http://ann77.emacser.com/Emacs/EmacsDiredExt.html
;; and slightly modified to my shell alias style link "ls" "lx" "lt"
(add-hook 'dired-mode-hook (lambda ()
  (interactive)
  (make-local-variable  'dired-sort-map)
  (setq dired-sort-map (make-sparse-keymap))
  (setq header-line-format "Sort by: Time(lt), Size(lk), Extension(lx), Name(ls). Edit by C-x C-q")
  (define-key dired-mode-map "l" dired-sort-map)
  (define-key dired-sort-map "k"
    '(lambda () "sort by Size"
       (interactive) (dired-sort-other (concat dired-listing-switches "S"))))
  (define-key dired-sort-map "x"
    '(lambda () "sort by eXtension"
       (interactive) (dired-sort-other (concat dired-listing-switches "X"))))
  (define-key dired-sort-map "t"
    '(lambda () "sort by Time"
       (interactive) (dired-sort-other (concat dired-listing-switches "t"))))
  (define-key dired-sort-map "s"
    '(lambda () "sort by Name"
       (interactive) (dired-sort-other (concat dired-listing-switches ""))))))

(defun dired-sort ()
  "Dired sort hook to list directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))
(add-hook 'dired-after-readin-hook 'dired-sort)

;; http://www.emacswiki.org/emacs/KillingBuffers#toc3
(defun kill-all-dired-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count ))))
                                06_org.el                                                                                           000644  000766  000024  00000002060 12433661312 012764  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;----------------------------------------
; org-mode setup, mostly borrowed from
; http://doc.norang.ca/org-mode.html
; and
; http://orgmode.org/worg/ (really great resource)
;----------------------------------------
(eval-when-compile
  (require 'org))

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(eval-after-load 'org-mode
  (progn
                                        ; directory
    (setq org-directory "~/Dropbox/org")
    (setq org-default-notes-file "~/Dropbox/org")
    (setq org-agenda-files (list "~/Dropbox/org"))
                                        ; org setting
    (setq org-src-fontify-natively t)
    (setq org-support-shift-select t)))

; key-binding
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-capture)
;; (global-set-key [f12] 'org-remember)

; time
(setq org-log-done 'time)
(setq org-log-done 'note)

(add-hook 'org-mode-hook
          '(lambda ()
             (make-variable-buffer-local 'truncate-lines)
             (setq truncate-lines nil)))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                08_programming.el                                                                                   000644  000766  000024  00000000073 12446303025 014521  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (require 'aria-web)
(require 'aria-js)
(require 'aria-css)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     09_plugins.el                                                                                       000644  000766  000024  00000001363 12427601252 013666  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (prelude-require-packages
 '(
   yasnippet
   deft
   ag
;;   multiple-cursors
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

;; (eval-after-load 'multiple-cursors-mode
;;   (progn
;;     (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;;     (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;;     (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))

(require 'image-dimensions-minor-mode)
                                                                                                                                                                                                                                                                             99_misc.el                                                                                          000644  000766  000024  00000001265 12446216725 013162  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;;----------------------------------------
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

(global-diff-hl-mode -1)
                                                                                                                                                                                                                                                                                                                                           aria-css.el                                                                                         000644  000766  000024  00000000273 12456142627 013406  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (prelude-require-package 'helm-css-scss)

(eval-after-load 'scss-mode
  (progn
    (setq css-indent-offset 4)
    (local-set-key (kbd "c-c s") 'helm-css-scss)
    ))

(provide 'aria-css)
                                                                                                                                                                                                                                                                                                                                     aria-js.el                                                                                          000644  000766  000024  00000003514 12437754006 013232  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;;; aria-js.el --- Emacs Prelude: js3-mode & jsx-mode configuration.
;;
;; Copyright © 2011-2013 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: https://github.com/bbatsov/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Some basic configuration for js-mode.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'prelude-programming)
(prelude-require-packages '(js3-mode json-mode))

(require 'js3-mode)

(add-to-list 'auto-mode-alist '("\\.js\\'"    . js3-mode))
(add-to-list 'auto-mode-alist '("\\.pac\\'"   . js3-mode))
(add-to-list 'interpreter-mode-alist '("node" . js3-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'"    . jsx-mode))

(eval-after-load 'js3-mode
  '(progn
     (defun aria-js3-mode-defaults ()
       (run-hooks 'prelude-prog-mode-hook)
       (setq js3-indent-level 4)
       (setq js3-global-externs '("$" "jQuery" "_" "angular" "console"))
       (setq mode-name "JS3"))

     (setq aria-js3-mode-hook 'aria-js3-mode-defaults)

     (add-hook 'js3-mode-hook (lambda () (run-hooks 'aria-js3-mode-hook)))))

(provide 'aria-js)
                                                                                                                                                                                    aria-web.el                                                                                         000644  000766  000024  00000000751 12431024660 013361  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (prelude-require-package 'zencoding-mode)

(eval-after-load 'web-mode
  (progn
    (web-mode-set-engine "mako")
    (setq web-mode-disable-auto-pairing t)
    (setq web-mode-markup-indent-offset 4)
    (setq web-mode-css-indent-offset 4)
    (setq web-mode-code-indent-offset 4)
    (setq web-mode-indent-style 4)
    (setq web-mode-block-padding 4)
    (setq web-mode-style-padding 4)
    (setq web-mode-script-padding 4)))

(add-hook 'web-mode-hook 'zencoding-mode)

(provide 'aria-web)
                       custom.el                                                                                           000644  000766  000024  00000010353 12452710202 013200  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(ansi-term-color-vector
   [unspecified "#202020" "#ac4142" "#90a959" "#f4bf75" "#6a9fb5" "#aa759f" "#6a9fb5" "#e0e0e0"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "4217c670c803e8a831797ccf51c7e6f3a9e102cb9345e3662cc449f4c194ed7d" "ab3e4108e9b6d9b548cffe3c848997570204625adacef60cbd50a39306866db1" "0744f61189c62ed6d1f8fa69f6883d5772fe8577310b09e623c62c040f208cd4" "de2c46ed1752b0d0423cde9b6401062b67a6a1300c068d5d7f67725adc6c3afb" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "2affb26fb9a1b9325f05f4233d08ccbba7ec6e0c99c64681895219f964aac7af" "e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" "49eea2857afb24808915643b1b5bd093eefb35424c758f502e98a03d0d3df4b1" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" "f41fd682a3cd1e16796068a2ca96e82cfd274e58b978156da0acce4d56f2b0d5" "51bea7765ddaee2aac2983fac8099ec7d62dff47b708aa3595ad29899e9e9e44" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "f0ea6118d1414b24c2e4babdc8e252707727e7b4ff2e791129f240a2b3093e32" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "e53cc4144192bb4e4ed10a3fa3e7442cae4c3d231df8822f6c02f1220a0d259a" "53e29ea3d0251198924328fd943d6ead860e9f47af8d22f0b764d11168455a8e" "978ff9496928cc94639cb1084004bf64235c5c7fb0cfbcc38a3871eb95fa88f6" "3b819bba57a676edf6e4881bd38c777f96d1aa3b3b5bc21d8266fa5b0d0f1ebf" "cb247cf944eea968aa613a5c40f4cb79f4c05503591cf33e5b4224394dd57e94" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(fci-rule-color "#383838")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(magit-diff-use-overlays nil)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
                                                                                                                                                                                                                                                                                     flycheck_aria-css.el                                                                                000644  000766  000024  00000000254 12456142622 015250  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (prelude-require-package 'helm-css-scss)

(eval-after-load 'scss-mode
  (progn
    (setq css-indent-offset 4)
    (local-set-key (kbd "c-c s"))
    ))

(provide 'aria-css)
                                                                                                                                                                                                                                                                                                                                                    image-dimensions-minor-mode.el                                                                      000644  000766  000024  00000002715 12427601210 017165  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         ;;; image-dimensions-minor-mode.el
;;
;; Display the image dimensions in the mode line, when viewing an image.
;;
;; Author: Phil S.
;;
;; Compatibility: GNU Emacs 24.3
;;
;; Installation:
;; (eval-after-load 'image-mode '(require 'image-dimensions-minor-mode))

;; Commentary:
;;
;; To also see this information in the frame title, your `frame-title-format'
;; variable might be something like the following:
;;
;; (setq frame-title-format
;;       '(buffer-file-name
;;         ("%b (Emacs) %f" image-dimensions-minor-mode-dimensions)
;;         (dired-directory
;;          (:eval (concat (buffer-name) " (Emacs) " dired-directory))
;;          ("%b (Emacs)"))))

(eval-when-compile (require 'cl-macs))

(declare-function image-get-display-property "image-mode")

(defvar-local image-dimensions-minor-mode-dimensions nil
  "Buffer-local image dimensions for `image-dimensions-minor-mode'")

(define-minor-mode image-dimensions-minor-mode
  "Displays the image dimensions in the mode line."
  :init-value nil
  :lighter image-dimensions-minor-mode-dimensions
  (when (not image-dimensions-minor-mode-dimensions)
    (let ((image (image-get-display-property)))
      (when image
        (setq image-dimensions-minor-mode-dimensions
              (cl-destructuring-bind (width . height)
                  (image-size image :pixels)
                (format " (%dx%d)" width height)))))))

(add-hook 'image-mode-hook 'image-dimensions-minor-mode)

(provide 'image-dimensions-minor-mode)
                                                   personal                                                                                            000644  000766  000024  00000002000 12457347447 013126  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         personal.tar                                                                                        000644  000766  000024  00000000000 12457347453 013706  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         preload/                                                                                            000755  000766  000024  00000000000 12457347121 013003  5                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         preload/.gitkeep                                                                                    000644  000766  000024  00000000000 12421577602 014422  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         preload/load-path.el                                                                                000644  000766  000024  00000000103 12427143736 015173  0                                                                                                    ustar 00simon                           staff                           000000  000000                                                                                                                                                                         (add-to-list 'load-path (concat user-emacs-directory "personal/"))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             