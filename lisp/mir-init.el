;;; mir-init.el --- init utilities                   -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Allen Li
;; Keywords: local

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Personal init utilities.

;;; Code:

(defmacro mir-init-add-hooks (hook &rest funcs)
  "Add to the HOOK the given FUNCS."
  (declare (indent 1) (debug (sexp &rest form)))
  `(dolist (f (list ,@(nreverse funcs)))
     (add-hook ',hook f)))

(defsubst mir-init--mode-hook (mode)
  "Return the hook symbol for the MODE symbol."
  (intern (concat (symbol-name mode) "-hook")))

(defmacro mir-init-add-to-modes (form &rest modes)
  "Add FORM to the mode hooks for MODES."
  (declare (indent 1) (debug (form &rest sexp)))
  (let ((x (gensym)))
    `(let ((,x ,form))
       (dolist (m ',modes)
         (add-hook (mir-init--mode-hook m) ,x)))))

(defmacro mir-init-enable-for-modes (minor-mode &rest modes)
  "Enable the minor mode MINOR-MODE for MODES."
  (declare (indent 1) (debug (sexp &rest sexp)))
  `(mir-init-add-to-modes (lambda () (,minor-mode 1)) ,@modes))

(defmacro mir-init-disable-for-modes (minor-mode &rest modes)
  "Disable the minor mode MINOR-MODE for MODES."
  (declare (indent 1) (debug (sexp &rest sexp)))
  `(mir-init-add-to-modes (lambda () (,minor-mode -1)) ,@modes))

(defmacro mir-init-setter (var value)
  "Make hook function for setting VAR to VALUE."
  `(lambda () (defvar ,var) (setq-local ,var ,value)))

(defmacro mir-init-bind-keys (keymap &rest forms)
  "Define keys in KEYMAP symbol according to FORMS."
  (declare (indent 1) (debug (sexp &rest form)))
  `(when (boundp ',keymap)
     ,@(mapcar (lambda (form) `(define-key ,keymap ,@form)) forms)))

(defmacro mir-init-dir-class (class variables &rest dirs)
  "Define a directory CLASS with VARIABLES on DIRS."
  (declare (indent 2) (debug (sexp form &rest form)))
  `(progn
     (dir-locals-set-class-variables ',class ,variables)
     (dolist (d (list ,@dirs))
       (dir-locals-set-directory-class d ',class))))

(provide 'mir-init)
;;; mir-init.el ends here
