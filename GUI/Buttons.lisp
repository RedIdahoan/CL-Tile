;;;;(:use #:cl #:gtk #:gdk #:gdk-pixbuf #:gobject
;;;;      #:glib #:gio #:pango #:cairo)
(in-package #:CL-Tile)

(defmacro custom-button (var image)
  `(progn (defvar ,var (gtk-button-new))
	  (setf (gtk-button-image ,var) (gtk-image-new-from-file ,image))
	  )
  )

(custom-button paint-button "GUI/paint.png")
(custom-button eraser-button "GUI/erase.png")

(g-signal-connect paint-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (setf current-tool 'paint)
		    ))

(g-signal-connect eraser-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (setf current-tool 'erase)
		    ))
