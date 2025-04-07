;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "MesloLGLDZ Nerd Font"))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

; shell commands not in a vterm will still use bash/zsh/whatever
; since i have a policy of only using a posix compat shell by default
(setq vterm-shell "/etc/profiles/per-user/glitch/bin/fish")

(setq org-latex-compiler "lualatex")
(setq org-preview-latex-default-process 'dvisvgm)

;; Keyboard
(load! "+colemak") ; taken almost directly from the closed PR but with dh copied in and applied
; my personal fixes, made to match so i can contribute back if needed
(map!
 (:when (modulep! :tools lookup)
   :nv "E" #'+lookup/documentation)
 )
;; direnv clobbers exec-path (which is appended by nix), this HACK preserves it
(setenv "PATH" (mapconcat 'identity exec-path ":"))

;; lsp-java sucks
(after! lsp-java
  (setq lsp-java-jdt-ls-prefer-native-command t)
  (setq lsp-java-server-install-dir (getenv "JDTLS_PATH"))
  (setq lsp-java-server-config-dir (expand-file-name "./jdtls-config" (getenv "XDG_CACHE_HOME")))

  ; lsp-java has to be able to find the jar even if we tell it to not use it
  ; https://github.com/emacs-lsp/lsp-java/issues/487#issuecomment-2383307915
  (defun java-server-subdir-for-jar (orig &rest args)
    (let ((lsp-java-server-install-dir
           (expand-file-name "./share/java/jdtls" lsp-java-server-install-dir)))
      (apply orig args)))
  (advice-add 'lsp-java--locate-server-jar :around #'java-server-subdir-for-jar))
