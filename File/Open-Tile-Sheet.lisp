(in-package :CL-Tile)

#|(defvar tile-sheets nil)
(append object-list tile-sheets)|#

(defun open-sheet (file tile-size-x tile-size-y)
  (let ((t-s-x tile-size-x)
	(t-s-y tile-size-y)
	(surface (cairo-image-surface-create-from-png file)))
    (let* (;;;;(cr surface)
	   (size-x (cairo-image-surface-get-width surface))
	   (size-y (cairo-image-surface-get-height surface))
	   (cells (loop for y from 0 to (- size-y t-s-y) by t-s-y
		     append (loop for x from 0 to (- size-x t-s-x) by t-s-x
			       collect (list x y)
				 )
		       )))
      (setf (obj-ts-surface Tile-File) surface)
      (setf (obj-cells Tile-File) cells)
      (setf (obj-sheet Tile-File) file)
      (setf (obj-rows Tile-File) (round (/ size-y t-s-y)))
      (setf (obj-columns Tile-File) (round (/ size-x t-s-x)))
      #|(defvar tile-sheet (make-obj "Tile-Sheet" file cr size-x size-y t-s-x t-s-y (mod size-x t-s-x) (mod size-y t-s-y) nil cells))
      (append (make-obj "Tile-Sheet" file cr size-x size-y t-s-x t-s-y (mod size-x t-s-x) (mod size-y t-s-y) nil cells) tile-sheets)|#
      (add-tile-sheet-canvas size-x size-y)
;;;;      (make-tile-widget)
      (make-canvas-widget)
      (make-preview-widget)
      )
    )
  )



#|
DEPRECATED CODE AND NOTES

(defvar tile-sheet nil)

(defstruct sheet (image nil)
	   (surface nil)
	   (t-s-x 0)
	   (t-s-y 0)
	   (tiles (make-hash-table))
	   )

(defun open-sheet (file tile-size-x tile-size-y)
  (let ((t-s-x tile-size-x)
	(t-s-y tile-size-y)
	#|(surface (cairo-image-surface-create :argb32 (* t-s-x surf-x) (* t-s-y surf-y))))|#
	(surface (cairo-image-surface-create-from-png file))
	(cr (cairo-create surface))
	(size-x (cairo-get-width surface))
	(size-y (cairo-get-height surface)))
    #|
    (let ((cells (loop for y below size-y by t-s-y
    append (loop for x below size-x by t-s-x
    collect (list x y t-s-x t-s-y)))))|#
    (setf tile-sheet (make-sheet :image file :surface cr :t-s-x t-s-x :t-s-y t-s-y))
    (add-tile-sheet-canvas cr t-s-x t-s-y size-x size-y)
    )
  )

#|NOTES: Make a hashtable. Hashtable is part of tile-sheet. Hashtable is accessed by index no.s, like (gethash 0 HASHTABLE).|#
;;;;Cairo clip region of file aref the map (x = (car (nth (aref map row column) (tile-sheet-index *sheet*)))) (y = (cadr (nth (aref map row column) (tile-sheet-index *sheet*))))
      ;;;;show complete image, but mod mouse-x, mouse-y by 32 (on click in tile-sheet widget) = current index of tile-sheet-array
      ;;;;As in (nth (mod mouse-x t-s-x + (mod mouse-y t-s-y * cells-x) ) (tile-sheet-index *sheet*))

#|
(defmacro draw-cell (cr x y t-s-x t-s-y)
  `(progn (cairo-rectangle ,cr ,x ,y ,t-s-x ,t-s-y)
	  (cairo-clip ,cr)
	  ))

(defun draw-map ()
  (let* ((t-s-x (tile-sheet-t-s-x *sheet*))
	 (t-s-y (tile-sheet-t-s-y *sheet*))
	 (surf-x (car (array-dimensions map-array)))
	 (surf-y (cadr (array-dimensions map-array)))
	 )
    (loop for y below surf-y
       do (loop loop for x below surf-x
	     do (draw-cell cr x y t-s-x t-s-y)
	       )
	 )
    ))
|#

#|
(defun show-sheet (size tile-size)
  (let ((size-x (car size))
	(size-y (cadr size))
	(t-s-x (car tile-size))
	(t-s-y (cadr tile-size))
	(num-tiles 0))
    (loop for y below size-y by t-s-y
       do (loop for x below size-x by t-s-x
	     do (setf num-tiles (+1 num-tiles))
	       ))
    (loop for cell below num-tiles
       do ()
	 )))
|#




|#
