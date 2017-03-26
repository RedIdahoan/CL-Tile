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

(defun open-dialog ()
  (let ((dialog-box (gtk-file-chooser-dialog-new "Open"
						 Tile-Window
						 :open
						 "gtk-cancel" :cancel
						 "gtk-open" :accept)))
    (g-signal-connect dialog-box "response" 
		      (lambda (dialog-box response-id)
			(if (eq response-id -3)
			    (let ((fn (merge-pathnames (gtk-file-chooser-get-filename dialog-box) (gtk-file-chooser-get-current-folder dialog-box))))
			      (open-ltf fn)
			      ))
			(gtk-widget-destroy dialog-box)))
    (gtk-widget-show-all dialog-box))
  )

(defun open-ltf (file)
  (with-open-file (str file :direction :input)
    (setf Tile-File (read str))
    )
  (let* ((size-x (cadr (array-dimensions (obj-array Tile-File))))
	 (size-y (car (array-dimensions (obj-array Tile-File))))
	 (t-s-x (obj-tsx Tile-File))
	 (t-s-y (obj-tsy Tile-File))
	 (cr (cairo-image-surface-create :argb32 (* size-x t-s-x) (* size-y t-s-y)))
	 )
    (setf (obj-map-surface Tile-File) cr)
    )    
  (let* ((sheet (obj-sheet tile-file))
	 (surface (cairo-image-surface-create-from-png sheet)) 
	 (size-x (cairo-image-surface-get-width surface))
	 (size-y (cairo-image-surface-get-height surface))
	 )
    (setf (obj-ts-surface Tile-File) surface)
    (add-tile-sheet-canvas size-x size-y)
    (make-canvas-widget)
    (make-preview-widget)
    )
  )

#|
(defun open-LTF (file)
  (with-open-file (fn file :direction :input)
    (defvar Tile-File (read fn))
    (defvar tile-sheet (read fn))
    (push tile-sheet objects-list)
    (push Tile-File objects-list)
    )
  )
|#
