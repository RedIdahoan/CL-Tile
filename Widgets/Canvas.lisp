#|
DRAWING AREA


|#

(in-package #:CL-Tile)

(defvar map-scroll-window (make-instance 'gtk-scrolled-window
					 :width-request 1000
					 :height-requst 600))
(defvar map-viewport (gtk-viewport-new))
(gtk-container-add map-scroll-window map-viewport)


(defclass tile-canvas (gtk-drawing-area)
  ()
  (:metaclass gobject-class))

(defmethod initialize-instance :after
    ((canvas tile-canvas) &key &allow-other-keys)
  (g-timeout-add 50 (lambda ()
		      (gtk-widget-queue-draw canvas)
		      +g-source-continue+))
  (g-signal-connect canvas "draw"
		    (lambda (widget cr)
		      (declare (ignore widget))
		      (let ((cr (pointer cr)))
			(draw-canvas cr)
			(cairo-destroy cr)
			)
		      )
		    )
  (gtk-widget-add-events canvas '(:button-press-mask
				  :pointer-motion-mask))
  (g-signal-connect canvas "button-press-event"
		    (lambda (widget event)
		      (declare (ignore widget))
		      (if (eql 1 (gdk-event-button-button event))
			  (let ((x (gdk-event-button-x event))
				(y (gdk-event-button-y event)))
			    (edit-canvas x y)))
		      )
		    )
  )

(defun make-canvas-widget ()
  (let ((size-x (* (obj-tsx Tile-File) (cadr (array-dimensions (obj-array Tile-File)))))
	(size-y (* (obj-tsy Tile-File) (car (array-dimensions (obj-array Tile-File)))))
	)
    (defvar map-canvas (make-instance 'tile-canvas
				      :width-request size-x
				      :height-request size-y))
    (gtk-container-add map-viewport map-canvas)
    (gtk-widget-show-all map-viewport)
    )
  )

(defun edit-canvas (x y)
  (case current-tool
    (paint (paint x y))
    (erase (erase x y))
    )
  )

#|
(defun make-new-canvas ()
  (let ((size-x (* (car (obj-tile-size Tile-File)) (cadr (array-dimensions map-array))))
	(size-y (* (cadr (obj-tile-size Tile-File)) (car (array-dimensions map-array))))
	)
;;;;    (defvar canvas-surface (cairo-create (cairo-image-surface-create :argb32 size-x size-y)))
    (setf (gtk-widget-size-request map-canvas) (list size-x size-y))
    )
  )
|#
(defun draw-canvas (cr)
  #|(let* ((map (obj-array Tile-File))
	 (size-x (cadr (array-dimensions map)))
	 (size-y (car (array-dimensions map)))
	 (t-s-x (obj-tsx Tile-File))
	 (t-s-y (obj-tsy Tile-File))
	 )
    (loop for y below size-y
       do (loop for x below size-x
	     do (progn (cairo-set-source-surface cr (render-cell (aref map y x)) (* x t-s-x) (* y t-s-y))
		       (cairo-paint cr))
	       )
  )|#
  (cairo-paint cr)
  (setf preview-canvas-surface cr)
  )
