#|
DRAWING AREA


|#

(in-package #:CL-Tile)

(defvar map-widget (make-instance 'gtk-scrolled-window
				  :width-request 1000
				  :height-request 600))

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
  (g-signal-connect canvas "motion-notify-event"
		    (lambda (widget event)
		      (format t "MOTION-NOTIFY-EVENT ~A~%" event)
		      (when (member :button1-mask (gdk-event-motion-state event))
			(let* ((ts (obj-ts-surface Tile-File))
			       (ms (obj-map-surface Tile-File))
			       (tsx (obj-tsx Tile-File))
			       (tsy (obj-tsy Tile-File))
			       (tr (cairo-create ts))
			       (cr (cairo-create ms))
			       (x (gdk-event-motion-x event))
			       (y (gdk-event-motion-y event)))	    
			;;;;  (cairo-set-source-surface cr ts 0 0)
			;;;;  (cairo-rectangle cr (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))) tsx tsy)
			;;;;  (cairo-set-source-surface cr ts (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy))
			;;;;  (cairo-rectangle cr (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy) tsx tsy)
			;;;;  (cairo-set-source-surface cr ts (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))))
			;;;;  (cairo-rectangle cr (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))) tsx tsy)
			  (cairo-set-source-surface cr ts (- (* (floor (/ x tsx)) tsx) (car (nth current-tile (obj-cells Tile-File)))) (- (* (floor (/ y tsy)) tsy) (cadr (nth current-tile (obj-cells Tile-File)))))
			  (cairo-rectangle tr (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))) tsx tsy)
			  (cairo-clip tr)
			  (cairo-rectangle cr (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy) tsx tsy)
			  (cairo-fill cr)
			  (cairo-destroy cr)
			  (cairo-destroy tr)
			  (gtk-widget-queue-draw widget)
			  (edit-canvas x y)
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
				 (tr (cairo-create ts))
				 (cr (cairo-create ms))
				 (x (gdk-event-button-x event))
				 (y (gdk-event-button-y event)))
			    #|
			    Jesus fucking christ this was a pain in the ass.
			    Basically, you have to create a rectangle from the tile-sheet surface at point tile-n-x tile-n-y (will include my tile-sheet as reference, so the grass tile is tile-1, and it's points are (tile-n-x 32) (tile-n-y 0)
			    Set it as a pattern
			    Then switch back to the source-surface as the tile-canvas/map whatever you wanna call it.
			    ^
			    | Didn't work
			    Initialize 2 contexts, with the rectangle of of ts being the fill for the rectangle at / x tsx & / y tsy
			    |#
			  ;;;;  (cairo-set-source-surface cr ts (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))))
			  ;;;;  (cairo-rectangle cr (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy) tsx tsy)
			  ;;;;  (cairo-set-source-surface cr ts (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy))
    			  ;;;;  (cairo-rectangle cr 0 0 tsx tsy)
			  ;;;;  (cairo-set-source-surface cr ts (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy))
			  ;;;;  (cairo-set-source-surface cr ts 0 0)
			    (cairo-set-source-surface cr ts (- (* (floor (/ x tsx)) tsx) (car (nth current-tile (obj-cells Tile-File)))) (- (* (floor (/ y tsy)) tsy) (cadr (nth current-tile (obj-cells Tile-File)))))
			    (cairo-rectangle tr (car (nth current-tile (obj-cells Tile-File))) (cadr (nth current-tile (obj-cells Tile-File))) tsx tsy)
			    (cairo-clip tr)
			    (cairo-rectangle cr (* (floor (/ x tsx)) tsx) (* (floor (/ y tsy)) tsy) tsx tsy)
			    (cairo-fill cr)
			    (cairo-reset-clip tr)
			    (cairo-destroy cr)
			    (cairo-destroy tr)
			    (gtk-widget-queue-draw widget)
			    (edit-canvas x y)
			    )
			    ;;;Pop-up menu
			  )
		      )
		    )
  (gtk-widget-add-events canvas '(:button-press-mask :pointer-motion-mask))
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
  (cairo-set-source-surface cr (obj-map-surface Tile-File) 0 0)
  (cairo-paint cr)
  )
