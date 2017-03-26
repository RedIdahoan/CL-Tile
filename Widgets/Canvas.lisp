#|
DRAWING AREA


|#

(in-package #:CL-Tile)

(defvar map-widget (make-instance 'gtk-scrolled-window
				  :width-request 1000
				  :height-request 600))
(defvar filled nil)

(defclass tile-canvas (gtk-drawing-area)
  ()
  (:metaclass gobject-class))

(defmethod initialize-instance :after
    ((canvas tile-canvas) &key &allow-other-keys)
  (g-timeout-add 25 (lambda ()
		      (gtk-widget-queue-draw canvas)
		      +g-source-continue+))
  (g-signal-connect canvas "draw"
		    (lambda (widget cr)
		      (declare (ignore widget))
		      (let ((cr (pointer cr)))
			(if (eq filled nil)
			    (initial-fill cr))
			(draw-canvas cr)
			(cairo-destroy cr)
			)
		      ))
  (g-signal-connect canvas "motion-notify-event"
		    (lambda (widget event)
		      (format t "MOTION-NOTIFY-EVENT ~A~%" event)
		      (when (member :button1-mask (gdk-event-motion-state event))
			(let* ((ts (obj-ts-surface Tile-File))
			       (ms (obj-map-surface Tile-File))
			       (tsx (obj-tsx Tile-File))
			       (tsy (obj-tsy Tile-File))
			       (cr (cairo-create ms))
			       (x (gdk-event-motion-x event))
			       (y (gdk-event-motion-y event)))	    
			  (edit-canvas x y ts tsx tsy cr) ;put operations in their respective files.
			  (cairo-destroy cr)
			  (gtk-widget-queue-draw widget)
			  )			
			)
		      +gdk-event-stop+))
  (g-signal-connect canvas "button-press-event"
		    (lambda (widget event)
		      (if (eql 1 (gdk-event-button-button event))
			  (let* ((ts (obj-ts-surface Tile-File))
				 (ms (obj-map-surface Tile-File))
				 (tsx (obj-tsx Tile-File))
				 (tsy (obj-tsy Tile-File))
				 (cr (cairo-create ms))
				 (x (gdk-event-button-x event))
				 (y (gdk-event-button-y event)))
			    (edit-canvas x y ts tsx tsy cr) ;put operations in their respective files.
			    (cairo-destroy cr)
			    (gtk-widget-queue-draw widget)
			    )
			    ;;;Pop-up menu
			  )
		      ))
  
  (g-signal-connect canvas "button-release-event"
		    (lambda (widget event)
		      (declare (ignore widget))
		      (if (eql 1 (gdk-event-button-button event))
			  (push-to-stack (obj-array Tile-File) undo-stack)
			  )
		      ))
  
  (gtk-widget-add-events canvas '(:button-press-mask :pointer-motion-mask :button-release-mask))
  )

(defun initial-fill (cr)
  (let ((tsx (obj-tsx Tile-File))
	(tsy (obj-tsy Tile-File))
	(size-x (cadr (array-dimensions (obj-array Tile-File))))
	(size-y (car (array-dimensions (obj-array Tile-File))))
	(ts (obj-ts-surface Tile-File))
	(array (obj-array Tile-File))
	)
    (loop for x below size-x
       do (loop for y below size-y
	     do (progn (cairo-set-source-surface cr ts
						 (- (* x tsx) (car (nth (aref array y x) (obj-cells Tile-File))))
						 (- (* y tsy) (cadr (nth (aref array y x) (obj-cells Tile-File)))))
		       (cairo-rectangle cr (* x tsx) (* y tsy) tsx tsy)
		       (cairo-fill cr)
		       )
	       )
	 ))
  )

(defun make-canvas-widget ()
  (let* ((size-x (* (obj-tsx Tile-File) (obj-size-x Tile-File)))
	 (size-y (* (obj-tsy Tile-File) (obj-size-y Tile-File)))
	 (map-canvas (make-instance 'tile-canvas
				    :width-request size-x
				    :height-request size-y))
	 )
    (gtk-container-add map-widget map-canvas)
    (gtk-widget-show-all map-widget)
    )
  )

(defun edit-canvas (x y ts tsx tsy cr)
  (case current-tool
    (paint (paint x y ts tsx tsy cr))
    (erase (erase x y tsx tsy cr))
    (bucket (bucket x y ts cr nil))
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
  (cairo-set-source-surface cr (obj-map-surface Tile-File) 0 0)
  (cairo-paint cr)
  )
