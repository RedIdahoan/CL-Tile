;;;;PREVIEW OR MINI-MAP
(in-package #:CL-Tile)

(defvar preview-widget (make-instance 'gtk-scrolled-window
				      :width-request 120
				      :height-request 300))


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
  (gtk-container-add preview-widget preview-canvas)
  )

(defun draw-preview (cr)
  (cairo-set-source-surface cr (obj-map-surface Tile-File) 0 0)
  (cairo-fill cr)
  (cairo-scale cr 0.1 0.1)
  (cairo-paint cr)
  )
