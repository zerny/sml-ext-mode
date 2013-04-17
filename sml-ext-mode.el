;;; sml-ext-mode.el -*- mode: emacs-lisp; lexical-binding: t -*-

;;;###autoload
(define-minor-mode sml-ext-mode
  "Extensions to sml-mode for Standard ML"
  :group 'sml
  :lighter "EXT"
  :keymap 
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-x C-l") 'sml-ext-load-buffer)
    ;; (define-key map (kbd "C-c C-x C-f") 'sml-ext-next-hole)
    ;; (define-key map (kbd "C-c C-x C-b") 'sml-ext-prev-hole)
    map))

;;;###autoload
(add-hook 'sml-mode 'sml-ext-mode)

(require 'sml-ext-process-mlton)
(require 'sml-ext-process)
(provide 'sml-ext-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sml-ext-reinstall-mode ()
  "Development helper to install and reload the sml-ext-mode.
Must be run where default-directory is the sml-ext-mode source
directory."
  (interactive)
  (compile "make -k package")
  (set-process-sentinel (get-process "compilation")
			'sml-ext-on-recompile))

(defun sml-ext-on-recompile (process event)
  (princ
   (format "Process: %s had the event `%s'" process event))
  (when (string= event "finished\n")
    (package-install-file (concat default-directory "sml-ext-mode-0.1.tar"))
    (when (featurep 'sml-ext-mode)
      (unload-feature 'sml-ext-mode)
      (unload-feature 'sml-ext-process)
      (unload-feature 'sml-ext-process-backend))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sml-ext-next-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-next-hole"))

(defun sml-ext-prev-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-prev-hole"))

(defun sml-ext-load-buffer ()
  "Load the buffer."
  (interactive)
  (sml-ext-process-load-buffer))
