#|
(ql:quickload :cl-cffi-gtk)
(load "Main.lisp")
(in-package #:CL-Tile)
(tile-app)
|#

(defpackage #:CL-Tile
  (:use #:cl #:gtk #:gdk #:gdk-pixbuf #:gobject
	#:glib #:gio #:pango #:cairo #:cffi)
  )

(in-package #:CL-Tile)
;;;;(setf *default-pathname-defaults* (merge-pathnames "LISP/CL-Tile/" *default-pathname-defaults*))
    
(defvar current-tool 'paint)
(defvar current-tile 0)
(defvar Tile-File nil)

(defun Tile-App ()
  (within-main-loop
   (init)
   (g-signal-connect Tile-Window "destroy"
		     (lambda (widget)
		       (declare (ignore widget))
		       (leave-gtk-main)))
   (gtk-widget-show-all Tile-Window)))

(defun init ()
  (load "Load-Everything.lisp")
  )
