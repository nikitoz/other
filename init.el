(load-file "~/cedet-1.1/common/cedet.el")
(add-to-list 'load-path "~/.emacs.d/")
(autoload 'dirtree "dirtree" "Add directory to tree view")
(require 'dirtree)
;(load-file "d:/emacs/emacs.d/dirtree.el")
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu
(global-ede-mode t)
(set-default-font "Consolas")
;(load "d:\\emacs\\haskell-mode-2.8.0\\haskell-site-file.el")
;(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(set-default 'truncate-lines t)
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)

(set-frame-width (selected-frame) 120)
