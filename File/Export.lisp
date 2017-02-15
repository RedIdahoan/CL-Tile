#|
defarea (town area area-name size-x size-y transition-pts init-contents)
|#

(defun export-for-game (file-name)
  (with-open-file (fn file-name :direction :output :if-exists :supersede)
    (let ((map (obj-array Tile-File))
	  (size-x (cadr (array-dimensions (obj-array Tile-File))))
	  (size-y (car (array-dimensions (obj-array Tile-File))))
	  (name (obj-name Tile-File))
	  )
      (princ "(defarea town " fn)
      (princ name fn)
      (princ " \"" fn)
      (princ name fn)
      (princ "\" " fn)
      (princ size-x fn)
      (princ " " fn)
      (princ size-y fn)
      (princ " '(trans-pts) '(" fn)
      (loop for y below (cadr (array-dimensions map))
	 do (progn (princ "(" fn)
		   (loop for x below (car (array-dimensions map))
		      do (progn (princ (aref map x y) fn)
				(princ " " fn)))
		   (princ ")" fn)
		   (fresh-line fn))
	   )
      (princ ") )" fn)
      )
    )
  )

(defun export-dialog ()
  "I'm not sure why the commented out save-as-dialog function doesn't work correctly. I tried multiple things, different ways, and they didn't work. This one does though."
  (let ((dialog-box (gtk-file-chooser-dialog-new "Export"
						 Tile-Window
						 :save
						 "gtk-cancel" :cancel
						 "gtk-save" :accept)))
    (gtk-file-chooser-set-do-overwrite-confirmation dialog-box t)
    (gtk-file-chooser-set-current-name dialog-box "Area.lisp")
    (g-signal-connect dialog-box "response" 
		      (lambda (dialog-box response-id)
			(if (eq response-id -3)
			    (let ((fn (merge-pathnames (gtk-file-chooser-get-filename dialog-box) (gtk-file-chooser-get-current-folder dialog-box))))
			      (export-for-game fn) ;;Change it to an exporter checker function, i.e. export as csv, txt, or other formats.
			      ))
			(gtk-widget-destroy dialog-box)))
    (gtk-widget-show-all dialog-box)))
