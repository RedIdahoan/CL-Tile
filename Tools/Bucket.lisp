(defvar dir nil)
(defvar changed-coords nil)
(defvar passes 0)
(defvar testing nil)
(defvar cur-test-tile nil)

(defmacro test-node (array x y sx sy test-tile &body body)
  `(progn (if (and (and (not (< ,x 0)) (not (< ,y 0))) (and (< ,x ,sx) (< ,y ,sy)))
	      (if (eq (aref ,array ,y ,x) ,test-tile)
		  (progn (fill-array ,array ,x ,y)
			 ,@body)
		  )
	      )
	  (flood-test ,array ,x ,y ,test-tile ,sx ,sy)
	  )
  )

(defun bucket (x y ts cr &optional old-tile)
  (setf dir 'right)
  (let* ((array (obj-array Tile-File))
	 (size-x (cadr (array-dimensions array)))
	 (size-y (car (array-dimensions array)))
	 (tsx (obj-tsx Tile-File))
	 (tsy (obj-tsy Tile-File))
	 (origin-x (floor (/ x tsx)))
	 (origin-y (floor (/ y tsy)))
	 (test-tile (aref (obj-array Tile-File) origin-y origin-x))
	 (cur-x origin-x)
	 (cur-y origin-y)
	 )
    (if (not (eq old-tile nil))
	(setf test-tile old-tile))
    (setf cur-test-tile test-tile)
    (when (and (and (> cur-x -1) (> cur-y -1)) (and (< cur-x size-x) (< cur-y size-y)))
      (loop while (not (eq dir nil))
	 do (progn (case dir
		     (right (test-node array (1+ cur-x) cur-y size-x size-y test-tile
				       (setf cur-x (1+ cur-x))
				       ))
		     (up (test-node array cur-x (1- cur-y) size-x size-y test-tile
				    (setf cur-y (1- cur-y))
				    ))
		     (left (test-node array (1- cur-x) cur-y size-x size-y test-tile
				      (setf cur-x (1- cur-x))
				      ))
		     (down (test-node array cur-x (1+ cur-y) size-x size-y test-tile
				      (setf cur-y (1+ cur-y))
				      ))
		     )
		   (flood-test array cur-x cur-y test-tile size-x size-y)
		   )
	   )
      (setf passes (1+ passes))
      (if (< passes 4) 
	  (bucket (* origin-x tsx) (* origin-y tsy) ts cr test-tile))
      )
    )
  (paint-fill cr ts)
  )

(defun fill-array (array x y)
  (setf (aref array y x) current-tile)
  (setf changed-coords (push (list x y) changed-coords))
  )

(defun flood-test (array x y test-tile size-x size-y)
  (if (and (and (> (1- x) -1) (> (1- y) -1)) (and (< (1+ x) size-x) (< (1+ y) size-y)))
      (cond ((eq (aref array y (1+ x)) test-tile)
	     (setf dir 'right))
	    ((eq (aref array (1- y) x) test-tile)
	     (setf dir 'up))
	    ((eq (aref array y (1- x)) test-tile)
	     (setf dir 'left))
	    ((eq (aref array (1+ y) x) test-tile)
	     (setf dir 'down))
	    ((and (not (eq (aref array y (1+ x)) test-tile))
		  (not (eq (aref array (1- y) x) test-tile))
		  (not (eq (aref array y (1- x)) test-tile))
		  (not (eq (aref array (1+ y) x) test-tile)))
	     (setf dir nil))
	    )
      (cond ((> (1+ x) size-x)
	     (setf dir 'up))
	    ((< (1- y) 0)
	     (setf dir 'left))
	    ((< (1- x) 0)
	     (setf dir 'down))
	    ((> (1+ y) size-y)
	     (setf dir 'right)))
      )
  )


(defun paint-fill (cr ts)
  (if (not (eq changed-coords nil))
      (let ((tsx (obj-tsx Tile-File))
	    (tsy (obj-tsy Tile-File))
	    )
	(loop for co-ord in changed-coords
	   do (let ((x (car co-ord))
		    (y (cadr co-ord))
		    )
		(cairo-set-source-surface cr ts
					  (- (* x tsx) (car (nth current-tile (obj-cells Tile-File))))
					  (- (* y tsy) (cadr (nth current-tile (obj-cells Tile-File)))))
		(cairo-rectangle cr (* x tsx) (* y tsy) tsx tsy)
		(cairo-fill cr)
		)
	     )
	))
  (setf changed-coords nil)
  (setf passes 0)
  )
