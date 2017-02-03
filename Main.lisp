#|
(ql:quickload :cl-cffi-gtk)
(load "~/LISP/Tile Editor/Main.lisp")
(in-package #:CL-Tile)
(tile-app)
|#

(defpackage #:CL-Tile
  (:use #:cl #:gtk #:gdk #:gdk-pixbuf #:gobject
	#:glib #:gio #:pango #:cairo #:cffi)
  )

(in-package #:CL-Tile)
(setf *default-pathname-defaults* (merge-pathnames "LISP/Tile Editor/" *default-pathname-defaults*))
    
(defvar current-tool nil)
(defvar current-tile 0)

(defun Tile-App ()
  (within-main-loop
   (init)
   (g-signal-connect Tile-Window "destroy"
		     (lambda (widget)
		       (declare (ignore widget))
		       (leave-gtk-main)))
   (gtk-widget-show-all window-grid)
   (gtk-widget-show-all Tile-Window)))

(defun init ()
  (load "Load-Everything.lisp")
  )
