;;; sml-ext-process.el -*- lexical-binding: t; indent-tabs-mode: nil; -*-

;;; This file describes the sml-ext-process-backend interface and
;;; extends it with some utility functions.

;; data type
;;   = sym     of sym ;; both type vars and named types
;;   | arrow   of type * type
;;   | product of type list
;;   | record  of (sym * type) list

;; data sym {
;;   name : string,
;;   type : type,
;;   file : (string * pos * pos) option,
;;   ;; what if its in a (unsaved) buffer?
;;   ref  : internal-process-ref,
;; }

;; sml-ext-process-symbol      : point option -> symbol option
;; sml-ext-process-loaded      : point option -> bool
;; sml-ext-process-load-region : (point * point) option -> bool
;; sml-ext-process-holes       : unit -> hole list

;; something about errors on load...

;; Maybe explicitly check that the above function names exist?

(require 'sml-ext-process-backend)

;; buffer option -> bool
(defun sml-ext-process-load-buffer (&optional buffer)
  "Load a buffer into the process. If no buffer is given, the
current buffer is loaded."
  (if buffer
      (with-current-buffer (get-buffer-create buffer)
        (sml-ext-process-load-region (point-min) (point-max)))
    (sml-ext-process-load-region (point-min) (point-max))))

(provide 'sml-ext-process)
