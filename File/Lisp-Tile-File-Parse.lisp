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
	)
      )
  )

(defun save-as-dialog ()
  "I'm not sure why the commented out save-as-dialog function doesn't work correctly. I tried multiple things, different ways, and they didn't work. This one does though."
  (let ((dialog-box (gtk-file-chooser-dialog-new "Save as"
						 Tile-Window
						 :save
						 "gtk-cancel" :cancel
						 "gtk-save" :accept)))
    (gtk-file-chooser-set-do-overwrite-confirmation dialog-box t)
    (gtk-file-chooser-set-current-name dialog-box "Map.LTF")
    (g-signal-connect dialog-box "response" 
		      (lambda (dialog-box response-id)
			(if (eq response-id -3)
			    (let ((fn (merge-pathnames (gtk-file-chooser-get-filename dialog-box) (gtk-file-chooser-get-current-folder dialog-box))))
			      (print fn)
			      (setf (obj-file Tile-File) fn)
			      (save-to-LTF fn)
			      ))
			(gtk-widget-destroy dialog-box)))
    (gtk-widget-show-all dialog-box)))

#|(defun save-as-dialog ()
  (let ((dialog-box (gtk-file-chooser-dialog-new "Save as"
						 Tile-Window
						 :save
						 "gtk-cancel" :cancel
						 "gtk-save" :accept)))
    (gtk-file-chooser-set-do-overwrite-confirmation dialog-box t)
    (gtk-file-chooser-set-current-name dialog-box "Map.LTF")
    (if (eql (gtk-dialog-run dialog-box) (foreign-enum-value 'gtk-response-type :accept))
	(let ((fn (merge-pathnames (gtk-file-chooser-get-filename dialog-box) (gtk-file-chooser-get-current-folder dialog-box))))
	  (print fn)
	  (setf (obj-file Tile-File) fn)
	  (save-to-LTF fn)
	  ))
(gtk-widget-destroy dialog-box)))|#


(defun open-LTF (file)
  (with-open-file (fn file :direction :input)
    (defvar Tile-File (read fn))
    (defvar tile-sheet (read fn))
    (push tile-sheet objects-list)
    (push Tile-File objects-list)
    )
  )
