;;; electric-spacing-rust.el --- c-buffer-is-cc-mode tunings

;; Copyright (C) 2019 Free Software Foundation, Inc.

;; Author: William Xu <william.xwl@gmail.com>
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with EMMS; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'electric-spacing)

(defun electric-spacing-:-cc-mode ()
  (if (looking-back ": *")
      (electric-spacing-insert ":" 'middle)
    (electric-spacing-insert ":")))

(defun electric-spacing-*-cc-mode ()
  "See `electric-spacing-insert'."
  ;; ,----
  ;; | a * b;
  ;; | char *a;
  ;; | char **b;
  ;; | (*a)->func();
  ;; | *p++;
  ;; | *a = *b;
  ;; | printf("%d", *ip);
  ;; | func(*p);
  ;; `----
  (cond ((looking-back (concat (electric-spacing-c-types) " *" ))
         (electric-spacing-insert "*" 'before))
        ((looking-back "\\* *")
         (electric-spacing-insert "*" 'middle))
        ((looking-back "^[ (]*")
         (electric-spacing-insert "*" 'middle)
         (indent-according-to-mode))
        ((looking-back "( *")
         (electric-spacing-insert "*" 'middle))
        ((looking-back ", *")
         (electric-spacing-insert "*" 'before))
        ((looking-back "= *")
         (electric-spacing-insert "*" 'before))
        (t
         (electric-spacing-insert "*"))))

(defun electric-spacing-&-cc-mode ()
  "See `electric-spacing-insert'."
  ;; ,----[ cases ]
  ;; | char &a = b; // FIXME
  ;; | void foo(const int& a);
  ;; | char *a = &b;
  ;; | int c = a & b;
  ;; | a && b;
  ;; | scanf ("%d", &i);
  ;; | func(&i)
  ;; `----
  (cond ((looking-back (concat (electric-spacing-c-types) " *" ))
         (electric-spacing-insert "&" 'after))
        ((looking-back "= *")
         (electric-spacing-insert "&" 'before))
        ((looking-back "( *")
         (electric-spacing-insert "&" 'middle))
        ((looking-back ", *")
         (electric-spacing-insert "&" 'before))
        (t
         (electric-spacing-insert "&"))))

(defun electric-spacing->-cc-mode ()
  "See `electric-spacing-insert'."
  (if (looking-back " - ")
      (progn
        (delete-char -3)
        (insert "->")))
  (electric-spacing-insert ">"))

(defun electric-spacing-+-cc-mode ()
  "See `electric-spacing-insert'."
  (cond ((looking-back "\\+ *")
         (when (looking-back "[a-zA-Z0-9_] +\\+ *")
           (save-excursion
             (backward-char 2)
             (delete-horizontal-space)))
         (electric-spacing-insert "+" 'middle)
         (indent-according-to-mode))
        (t
         (electric-spacing-insert "+"))))

(defun electric-spacing---cc-mode ()
  "See `electric-spacing-insert'."
  (cond ((looking-back "\\- *")
         (when (looking-back "[a-zA-Z0-9_] +\\- *")
           (save-excursion
             (backward-char 2)
             (delete-horizontal-space)))
         (electric-spacing-insert "-" 'middle)
         (indent-according-to-mode))
        (t
         (electric-spacing-insert "-"))))

(defun electric-spacing-?-cc-mode ()
  "See `electric-spacing-insert'."
  (electric-spacing-insert "?"))

(defun electric-spacing-%-cc-mode ()
  "See `electric-spacing-insert'."
  ;; ,----
  ;; | a % b;
  ;; | printf("%d %d\n", a % b);
  ;; `----
  (if (and (looking-back "\".*")
           (not (looking-back "\",.*")))
      (insert "%")
    (electric-spacing-insert "%")))

(defun electric-spacing-<-cc-mode ()
  "See `electric-spacing-insert'."
  (cond
   ((looking-back
     (concat "\\(" (regexp-opt
                    '("#include" "vector" "deque" "list" "map" "stack"
                      "multimap" "set" "hash_map" "iterator" "template"
                      "pair" "auto_ptr" "static_cast"
                      "dynmaic_cast" "const_cast" "reintepret_cast"

                      "#import"))
             "\\)\\ *")
     (line-beginning-position))
    (if (looking-back "^#\\(include\\|import\\) *")
        (electric-spacing-insert " " 'middle))
    (insert "<>")
    (backward-char))
   (t
    (electric-spacing-insert "<"))))

(provide 'electric-spacing-cc-mode)
;;; electric-spacing-cc-mode.el ends here