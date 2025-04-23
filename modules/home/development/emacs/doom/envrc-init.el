;;; home/development/emacs/doom/envrc-init.el -*- lexical-binding: t; -*-
;; variable glitch-dot-dir should be the location of the nix flake (usually /home/glitch/dts or /Users/glitch/dts)

;;; util functions needed for var definition
(defun +doom-call-process-no-err (command &rest args)
  "Execute COMMAND with ARGS synchronously.

Returns (STATUS . OUTPUT) when it is done, where STATUS is the returned error
code of the process and OUTPUT is its stdout output.
***Unlike doom-call-process, this actually ignores stderr."
  (with-temp-buffer
    (cons (or (apply #'call-process command nil '(t nil) nil (remq nil args))
              -1)
          (string-trim (buffer-string)))))

(defun +envrc--nix-get-current-system ()
  (cl-destructuring-bind (code . output)
      (+doom-call-process-no-err "nix" "eval" "--impure" "--raw" "--expr" "builtins.currentSystem")
    (if (zerop code)
        output
      (user-error (concat "Unable to read current nix system: " output)))))

;;; vars
(defcustom +envrc/nix-dts-flake-location (getenv "DOTFILES_DIR") "The location of the flake that provides your devshells")
(defcustom +envrc/nix-current-system (+envrc--nix-get-current-system) "The system string, e.g. aarch64-darwin")

;;; interactive functions
(defun +envrc/init-dts-flake () "Interactively select a devshell from your system flake and "
       (interactive)
       (let ((flake (concat (+envrc--get-flake-location) "#")))
         (+envrc--write-envrc (concat flake (+envrc--ask-shell flake)))))

(defun +envrc/init-project-flake ()
  (interactive)
  (+envrc--write-envrc ""))

;;; utils
(defun +envrc--write-envrc (shell) "Writes the given `shell` string to $root/.envrc and runs envrc-allow"
       (with-temp-file (expand-file-name "./.envrc" (doom-project-root))
         (insert "use_flake " shell)
         (message "initialized shell in %s" (expand-file-name "./.envrc" (doom-project-root))))
       (envrc-allow))

(defun +envrc--get-flake-location ()
  (let ((loc +envrc/nix-dts-flake-location))
    (if (and loc (file-exists-p loc))
        loc
      (user-error (concat "Unable to find flake file " (or loc "nil"))))))

(defun +envrc--ask-shell (flake)
  (completing-read (concat "Shell: " flake) (+envrc--eval-nix-shells (concat flake "devShells." +envrc/nix-current-system)) nil))

(defun +envrc--eval-nix-shells (path)
  (hash-table-keys (json-parse-string
                    (cl-destructuring-bind (code . output)
                        (+doom-call-process-no-err "nix" "eval" "--json" path)
                      (if (zerop code)
                          output
                        (user-error (concat "Unable to read flake " path)))))))
