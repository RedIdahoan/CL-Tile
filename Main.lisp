#|
(ql:quickload :cl-cffi-gtk)
(load "Main.lisp")
(in-package #:CL-Tile)
(tile-app)


;;;;Function for cairo-image-surface-get-height

(defcfun ("cairo_image_surface_get_height" cairo-image-surface-get-height) :int
 #+cl-cffi-gtk-documentation
 "@version{2014-2-7}
  @argument[surface]{a @symbol{cairo-surface-t}}
  @return{The height of the surface in pixels.}
  @begin{short}
    Get the height of the image surface in pixels.
  @end{short}

  Since 1.0
  @see-symbol{cairo-surface-t}
  @see-function{cairo-image-surface-get-width}"
  (surface (:pointer (:struct cairo-surface-t))))

(export 'cairo-image-surface-get-height)

;;;;In "/path/to/quicklisp-installation/dists/quicklisp/software/cl-cffi-gtk-date-git/cairo/cairo.image-surface.lisp
;;;;Put the (defcfun ...) (export ...) into that file
;;;;It should be near the bottom, the file will be fairly self-explanatory of what to do
|#

(defpackage #:CL-Tile
  (:use #:cl #:gtk #:gdk #:gdk-pixbuf #:gobject
	#:glib #:gio #:pango #:cairo #:cffi)
  )

(in-package #:CL-Tile)
    
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
