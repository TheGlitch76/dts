;; -*- lexical-binding: t; -*-
(use-package emacs :ensure nil
  :custom
  (inhibit-startup-message t)
  (visible-bell t)
  :config
  (tool-bar-mode -1)
  (menu-bar-mode -1))
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))
(use-package solaire-mode
  :ensure t
  :init
  (solaire-global-mode +1))
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))
(add-to-list 'default-frame-alist
	     '(font . (font-spec :family "MesloLGLDZ Nerd Font")))
