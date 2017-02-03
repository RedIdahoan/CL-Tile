(in-package #:CL-Tile)

(defvar object-list nil)

(defun make-obj (name file surface size-x size-y tsx tsy columns rows array cells)
  (list name file surface size-x size-y tsx tsy columns rows array cells)
  )

(defun obj-name (obj)
  (nth 0 obj)
  )
(defun obj-file (obj)
  (nth 1 obj)
  )
(defun obj-surface (obj)
  (nth 2 obj)
  )
(defun obj-size-x (obj)
  (nth 3 obj)
  )
(defun obj-size-y (obj)
  (nth 4 obj)
  )
(defun obj-tsx (obj)
  (nth 5 obj)
  )
(defun obj-tsy (obj)
  (nth 6 obj)
  )
(defun obj-columns (obj)
  (nth 7 obj)
  )
(defun obj-rows (obj)
  (nth 8 obj)
  )
(defun obj-array (obj)
  (nth 9 obj)
  )
(defun obj-cells (obj)
  (nth 10 obj)
  )
