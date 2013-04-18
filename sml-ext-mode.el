;;; sml-ext-mode.el -*- lexical-binding: t; indent-tabs-mode: nil; -*-

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
;;;; Fancy syntax highlighting (holes, bindings/occurrences, constructors, types)

;; (require 'annotation)

(defgroup sml-ext-faces nil
  "Extra faces for the extended SML mode"
  :group 'SML)

(defface sml-ext-faces-locked
  '((t (:background "slate gray")))
  :group 'sml-ext-faces)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar sml-ext-buffer-loaded
  "Set to t if the buffer is loaded, nil otherwise."
  nil)

(defvar sml-ext-hole-list
  "List all the hole start- and end-points (as markers). Only makes
sense if `sml-ext-buffer-loaded' is t."
  nil)

(defun sml-ext-next-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-next-hole")
  (when sml-ext-buffer-loaded
    (let ((holes sml-ext-hole-list)
          (moved nil))
      (while (and (not (null holes)) (not moved))
        (let ((nexth (caar holes)))
          (if (< (point) nexth)
              (progn
                (goto-char nexth)
                (setq moved 't))
            (setq holes (cdr holes)))))
      (if (and (not moved) (not (null sml-ext-hole-list)))
          (goto-char (caar sml-ext-hole-list))))))

(defun sml-ext-prev-hole ()
  "Move cursor to the next hole."
  (interactive)
  (message "sml-ext-prev-hole")
  (when (and sml-ext-buffer-loaded (not (null sml-ext-hole-list)))
    (if (<= (point) (cdar sml-ext-hole-list))
        (goto-char (caar (last sml-ext-hole-list)))
      (let ((holes (cdr sml-ext-hole-list))
            (lasth (caar sml-ext-hole-list)))
        (while (and (not (null holes)) (> (point) (cdar holes)))
          (setq lasth (caar holes)
                holes (cdr holes)))
        (goto-char lasth)))))

(defun sml-ext-load-buffer ()
  "Load the buffer."
  (interactive)
  (when (sml-ext-process-load-buffer)
    (setq sml-ext-buffer-loaded t)
    (let ((lock-overlay (make-overlay (point-min) (point-max)))
          (hook (lambda (&rest unused)
                  (remove-overlays (point-min) (point-max) 'name 'sml-ext-lock)
                  ;; TODO: does this really kill the overlay?
                  (setq sml-ext-hole-list nil
                        sml-ext-buffer-loaded nil))))
      (overlay-put lock-overlay 'name 'sml-ext-lock)
      (overlay-put lock-overlay 'face 'sml-ext-faces-locked)
      (overlay-put lock-overlay 'modification-hooks (list hook))
      (overlay-put lock-overlay 'insert-in-front-hooks
                   (list (lambda (ov post start end &rest unused)
                           (when (equal (point-min) start)
                             (remove-overlays (point-min) (point-max) 'name 'sml-ext-lock)
                             (when (equal post 't)
                               (remove-overlays start end 'name 'sml-ext-lock))))))
      (overlay-put lock-overlay 'insert-behind-hooks
                   (list (lambda (ov post start end &rest unused)
                           (when (equal end (point-max))
                             (remove-overlays (point-min) (point-max) 'name 'sml-ext-lock))))))
    (let ((holes (sml-ext-process-holes))
          (doit (lambda (hole)
                  (let ((new-start (make-marker))
                        (new-end (make-marker)))
                    (set-marker new-start (car hole))
                    (set-marker new-end (cdr hole))
                    (remove-overlays new-start new-end 'name 'sml-ext-lock)
                    (cons new-start new-end)))))
      (setq sml-ext-hole-list (mapcar doit holes)))))
