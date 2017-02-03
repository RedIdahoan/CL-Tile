;;;;CURRENT TILE
(in-package #:CL-Tile)

(defclass ct-draw (gtk-drawing-area)
  ()
  (:metaclass gobject-class))

(defmethod initialize-instance :after
    ((canvas ct-draw) &key &allow-other-keys)
  (g-timeout-add 100 (lambda ()
		       (gtk-widget-queue-draw canvas)
		       +g-source-continue+))
  (g-signal-connect canvas "draw"
		    (lambda (widget cr)
		      (declare (ignore widget))
		      (let ((cr (pointer cr)))
			(draw-current-tile cr)
			(cairo-destroy cr)
			)
		      )
		    )
  )

(defvar tile-widget (make-instance 'gtk-grid
				   :width-request 120
				   :height-request 300))

(defun make-tile-widget ()
  (defvar ct-drawing-area (make-instance 'ct-draw))
  (defvar disp-ct-num (make-instance 'gtk-vbox))
  (defvar ct-num (make-instance 'gtk-label
				:label "current tile"))
  (gtk-box-pack-start disp-ct-num ct-num
		      :expand t
		      :padding 6)
  (gtk-container-add tile-widget ct-drawing-area)
  (gtk-container-add tile-widget disp-ct-num)
  )

(defun draw-current-tile (cr)
  (cairo-set-source-surface cr (render-cell current-tile) 10 10)
  (cairo-paint cr)
  )


#|

(defmacro render-cell (n)
`(cairo-surface-create-for-rectangle (sheet-surface tile-sheet) (car (nth n (sheet-cells tile-sheet))) (cadr (nth n (sheet-cells tile-sheet))) (sheet-tsx tile-sheet) (sheet-tsy tile-sheet))
)
(render-cell [arrayy, arrayx])

loop
 loop
(cairo-set-source-surface cr (render-cell (aref [map] y x)) (* x t-s-x) (* y t-s-y))
(cairo-paint cr)
end loop
|#
