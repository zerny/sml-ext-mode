;;; sml-ext-process-mlton.el -*- mode: emacs-lisp; lexical-binding: t -*-

;;; This file provides a file-based process backend using the
;;; 'show-def-use' flag of the MLton compilers to generate type
;;; information.  This process implementation is *ONLY* for
;;; development of the sml-ext-mode and not for acutal use.

;; (when (featurep 'sml-ext-process-backend)
;;   (error "An sml-ext-process-backend has already been loaded."))

;; point option -> symbol option
(defun sml-ext-process-symbol (&optional point)
  "Returns symbol information for the symbol at the specified point.
If no point is given the current point is used.  Returns nil if
the point is not in the loaded region.  If the buffer is not
loaded then no symbols in that buffer will be loaded.  A
non-loaded symbol in a loaded buffer can occure if the symbol is
in a hole."
  (message "sml-ext-process-symbol not implemented yet.")
  nil)

;; point option -> bool
(defun sml-ext-process-loaded (&optional point)
  "True if point is loaded in the process.
If no point is given, the current point is used.  Any change
within a loaded region (ie, outside of a hole) will change this
to be false."
  (message "sml-ext-process-loaded not implemented yet.")
  nil)

;; (point * point) option -> bool
(defun sml-ext-process-load-region (&optional start end)
  "Load a region into the process.
If start and end are not given, the entire buffer is loaded."
  (message "sml-ext-process-load-region not implemented yet.")
  nil)

(provide 'sml-ext-process-mlton)
(provide 'sml-ext-process-backend)
