(in-package #:CL-Tile)

(defmacro append-tool (bar tool pos)
  `(gtk-toolbar-insert ,bar ,tool ,pos))
(defmacro tool-from-stock (var txt)
  `(defvar ,var (gtk-tool-button-new-from-stock ,txt)))

(defvar toolbar (make-instance 'gtk-toolbar
			       :width-request 1360
			       :height-request 48))

(tool-from-stock new-button "gtk-new")
(tool-from-stock open-button "gtk-open")
(tool-from-stock save-button "gtk-save")

(append-tool toolbar new-button -1)
(append-tool toolbar open-button -1)
(append-tool toolbar save-button -1)

(g-signal-connect new-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (New-File-Dialog)
		    ))

(g-signal-connect open-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (open-dialog)
		    ))		  

(g-signal-connect save-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (save-to-LTF (obj-file Tile-File))
		    ))
