;;;;PREVIEW OR MINI-MAP
(in-package #:CL-Tile)

(defvar preview-scroll (make-instance 'gtk-scrolled-window
				      :width-request 120
				      :height-request 300))
(defvar preview-viewport (gtk-viewport-new))
(gtk-container-add preview-scroll preview-viewport)


(defclass prev-canvas (gtk-drawing-area)
  ()
  (:metaclass gobject-class))

(defmethod initialize-instance :after
    ((canvas prev-canvas) &key &allow-other-keys)
  (g-timeout-add 100 (lambda ()
		       (gtk-widget-queue-draw canvas)
		       +g-source-continue+))
  (g-signal-connect canvas "draw"
		    (lambda (widget cr)
		      (declare (ignore widget))
		      (let ((cr (pointer cr)))
			(draw-preview cr)
			(cairo-destroy cr)
			)
		      )
		    )
  )

(defun make-preview-widget ()
  (defvar preview-canvas (make-instance 'prev-canvas))
  (defvar preview-canvas-surface (cairo-create (cairo-image-surface-create :argb32
									   (* 8 (cadr (array-dimensions (obj-array Tile-File))))
									   (* 8 (car (array-dimensions (obj-array Tile-File))))
									   )))
  (gtk-container-add preview-viewport preview-canvas)
  )

(defun draw-preview (cr)
  (cairo-set-source-surface cr preview-canvas-surface 0 0)
  (cairo-scale cr 0.1 0.1)
  (cairo-paint cr)
  )