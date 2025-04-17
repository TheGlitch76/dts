;;; home/development/emacs/doom/envrc-init.el -*- lexical-binding: t; -*-
;; variable glitch-dot-dir should be the location of the nix flake (usually /home/glitch/dts or /Users/glitch/dts)
(defcustom +envrc/init-flake-location (getenv "DOTFILES_DIR") "The location of the flake")
(defun +envrc/init-flake ()
  (interactive)
  (let ((flake (concat +envrc/init-flake-location "#")))
   (with-temp-file (expand-file-name "./.envrc" (projectile-project-root))
      (insert "use_flake" flake (+envrc--ask-shell flake)))
    (message "initialized shell in %s" (expand-file-name "./.envrc" (projectile-project-root)))
    (envrc-allow)))
;; TODO: provide a version to use the flake in the project root
(defun +envrc--ask-shell (flake)
    (list (completing-read (concat "Shell: " flake) (+envrc--eval-nix-list (concat flake "shellNames")) nil)))

(defun +envrc--eval-nix-list (path)
  (json-parse-string
   (cl-destructuring-bind (code . output)
      (+doom-call-process-no-err "nix" "eval" "--json" path)
    (if (zerop code)
        output
      (user-error (concat "Unable to read flake " path))))
   :array-type 'list))

(defun +doom-call-process-no-err (command &rest args)
  "Execute COMMAND with ARGS synchronously.

Returns (STATUS . OUTPUT) when it is done, where STATUS is the returned error
code of the process and OUTPUT is its stdout output.
***Unlike doom-call-process, this actually ignores stderr."
  (with-temp-buffer
    (cons (or (apply #'call-process command nil '(t nil) nil (remq nil args))
              -1)
          (string-trim (buffer-string)))))
