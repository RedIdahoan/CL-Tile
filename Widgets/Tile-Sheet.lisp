#|
TILE SHEET

_________________________
|                         |
|    SHEET AREA           |
|                         |
|                         |
|-------------------------|
|Button___________________|

|#
(in-package #:CL-Tile)

(defvar i 0)
(defvar tile-sheet-layout (make-instance 'gtk-layout
					 :width-request 120
					 :height-request 300))
(defvar tile-sheet-widget (gtk-scrolled-window-new))
(defvar tile-sheet-viewport (make-instance 'gtk-viewport
					   :width-request 120
					   :height-request 280))
(defvar ts-button (make-instance 'gtk-button
				 :label "New"
				 :height-request 20
				 :width-request 20)) ;new file icon
(gtk-layout-put tile-sheet-layout tile-sheet-viewport 0 0)
(gtk-layout-put tile-sheet-layout ts-button 12 280)
(gtk-container-add tile-sheet-widget tile-sheet-layout)
(g-signal-connect ts-button "clicked"
		  (lambda (widget)
		    (declare (ignore widget))
		    (sheet-dialog)))

(defun sheet-dialog ()
  (let ((dialog-box (gtk-dialog-new-with-buttons "New Sheet"
						 nil
						 '(:modal)
						 "gtk-ok"
						 :ok
						 "gtk-cancel"
						 :cancel))
	(spinner-tsx (make-instance 'gtk-spin-button
				    :adjustment
				    (make-instance 'gtk-adjustment
						   :value 32.0
						   :lower 1.0
						   :upper 1280.0
						   :step-increment 8.0
						   :page-increment 32.0
						   :page-size 0.0)
				    :climb-rate 1.0
				    :digits 0
				    :wrap t))
	(spinner-tsy (make-instance 'gtk-spin-button
				    :adjustment
				    (make-instance 'gtk-adjustment
						   :value 32.0
						   :lower 1.0
						   :upper 1280.0
						   :step-increment 8.0
						   :page-increment 32.0
						   :page-size 0.0)
				    :climb-rate 1.0
				    :digits 0
				    :wrap t))
	(vbox (make-instance 'gtk-vbox))
	(fc-button (make-instance 'gtk-file-chooser-button
				  :action :open))
	)
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Tile-Size X:"
				       :xalign 0
				       :yalign 0.5)
			:expand nil)
    (gtk-box-pack-start vbox spinner-tsx :expand nil)
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Tile-Size Y:"
				       :xalign 0
				       :yalign 0.5)
			:expand nil)
    (gtk-box-pack-start vbox spinner-tsy :expand nil)
    (gtk-box-pack-start vbox fc-button :expand nil)
    (gtk-box-pack-start (gtk-dialog-get-content-area dialog-box) vbox :padding 6)
    (g-signal-connect fc-button "file-set"
		      (lambda (widget)
			(declare (ignore widget))
			(format t "File: ~A~%"
				(gtk-file-chooser-get-filename fc-button))
			)
		      )
    (g-signal-connect dialog-box "response"
		      (lambda (dialog-box response-id)
			(if (eq response-id -5)
			    (let ((file (gtk-file-chooser-get-filename fc-button))
				  (t-s-x (gtk-spin-button-get-value-as-int spinner-tsx))
				  (t-s-y (gtk-spin-button-get-value-as-int spinner-tsy)))
			      (open-sheet file t-s-x t-s-y)
			      )
			    )
			(gtk-widget-destroy dialog-box)
			)
		      )
    (gtk-widget-show-all dialog-box)
    )
  )

(defclass t-s-canvas (gtk-drawing-area)
  ()
  (:metaclass gobject-class))

(defmethod initialize-instance :after
    ((canvas t-s-canvas) &key &allow-other-keys)
  (g-timeout-add 100 (lambda ()
		       (gtk-widget-queue-draw canvas)
		       +g-source-continue+))
  (g-signal-connect canvas "draw"
		    (lambda (widget cr)
		      (declare (ignore widget))
		      (let ((cr (pointer cr)))
			(draw-tile-sheet cr)
			(cairo-destroy cr)
			)
		      )
		    )
  (g-signal-connect canvas "button-press-event"
		    (lambda (widget event)
		      (declare (ignore widget))
		      (let ((x (gdk-event-button-x event))
			    (y (gdk-event-button-y event)))
			(select-tile x y)
			)
		      )
		    )
  (gtk-widget-add-events canvas '(:button-press-mask))
  )


(defun add-tile-sheet-canvas ()
  (defvar tile-sheet-canvas (make-instance 't-s-canvas))
  (gtk-widget-add-events tile-sheet-canvas '(:button-press-mask))
  (gtk-container-add tile-sheet-viewport tile-sheet-canvas)
  (gtk-widget-show-all tile-sheet-viewport)
  )

(defun draw-tile-sheet (cr)
  (cairo-set-source-surface cr (obj-surface tile-sheet) 0 0)
  (cairo-paint cr)
  )

(defun select-tile (x y)
  (let ((tile (+ (mod x (obj-tsx tile-sheet)) (* (mod y (obj-tsy tile-sheet)) (obj-columns tile-sheet))))
	)
    (setf current-tile tile)    
    )
  )