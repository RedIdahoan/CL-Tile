(in-package :CL-Tile)

(defmacro data-to-stream (obj str)
  ""
  `(mapcar #'(lambda (x) (princ x ,str) (fresh-line)) ,obj)
  )

(defun save-to-LTF (file)
  (if (eq file nil)
      (save-as-dialog)
      (with-open-file (fn file :direction :output :if-exists :supersede)
;;;;    (mapcar #'(lambda (obj) (data-to-stream obj fn) (fresh-line)) object-list)
	(print Tile-File fn)
	(print tile-sheet fn)
	)
      )
  )

(defun save-as-dialog ()
  (let ((dialog-box (gtk-file-chooser-dialog-new "Save as"
						 Tile-Window
						 :save
						 "gtk-cancel" :cancel
						 "gtk-save" :accept)))
    (gtk-file-chooser-set-current-name dialog-box "Map.LTF")
    (if (eq (gtk-dialog-run dialog-box) (foreign-enum-value 'gtk-response-type :accept))
	(let ((fn (gtk-file-chooser-get-filename dialog-box)))
	  (setf (obj-file Tile-File) fn)
	  (save-to-LTF fn)
	  ))
    (gtk-widget-destroy dialog-box)))

(defun open-LTF (file)
  (with-open-file (fn file :direction :input)
    (defvar Tile-File (read fn))
    (defvar tile-sheet (read fn))
    (push tile-sheet objects-list)
    (push Tile-File objects-list)
    )
  )