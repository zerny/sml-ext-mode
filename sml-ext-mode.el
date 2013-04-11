;;; sml-ext-mode.el -*- mode: emacs-lisp-mode -*-

;;;###autoload
(define-minor-mode sml-ext-mode
  "Extensions to sml-mode for Standard ML"
  :group 'sml
  :lighter "EXT"
  :keymap 
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-x C-f") 'sml-ext-next-hole)
    (define-key map (kbd "C-c C-x C-b") 'sml-ext-prev-hole)
    map))

;;;###autoload
(add-hook 'sml-mode 'sml-ext-mode)

(provide 'sml-ext-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sml-ext-next-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-next-hole"))

(defun sml-ext-prev-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-prev-hole"))
