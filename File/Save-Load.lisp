#|
FILE OUTPUT:
(defvar Tile-File (make-LTF :name "PlaceHolder" 
			    :array (eval `(make-array '((car (array-dimensions (LTF-array Tile-File))) (cadr (array-dimensions (LTF-array Tile-File)))) :initial-contents '(loop-de-loop))) 
			    :tile-size ((car (LTF-tile-size)) (cadr (LTF-tile-size)))))
WHAT NEEDS TO BE SAVED:
LTF STRUCTURE - NOT DONE



|#
(:use #:cl #:gtk #:gdk #:gdk-pixbuf #:gobject
      #:glib #:gio #:pango #:cairo)


(defun save (file-name)
  (with-open-file (fn file-name :direction :output :if-exists :supersede)
    (let ((t-s-x (car (LTF-tile-size Tile-File)))
	  (t-s-y (cadr (LTF-tile-size Tile-File)))
	  (size-x (cadr (array-dimensions (LTF-array Tile-File))))
	  (size-y (car (array-dimensions (LTF-array Tile-File))))
	  (name (LTF-name Tile-File))
	  (map (LTF-array Tile-File))
	  )
      (princ "(defvar Tile-File (make-LTF :name " fn)
      (princ name fn)
      (princ " :array (make-array '(" fn)
      (princ size-y fn)
      (princ " " fn)
      (princ size-x fn)
      (princ ") :initial-contents '(" fn)
      (loop for y below size-y
	 do (progn (princ "(" fn)
		   (loop for x below size-x
		      do (progn (princ (aref file-array x y) fn)
				(princ " " fn)))
		   (princ ")" fn)
		   (fresh-line fn))
	   )
      (princ ")) :tile-size (" fn)
      (princ t-s-x fn)
      (princ " " fn)
      (princ t-s-y fn)
      (princ ")))" fn)
      )
    )
  )

(defun load-ltf (file-name)
  (load file-name))


#|
(defun load-ltf (file-name)
  (let ((stream (open file-name)))
    (let ((pos (read stream)))
      (eval `(setf map (make-array '(,(car pos) ,(cadr pos)))))
      (loop for l = (read stream)
	 do (loop for y below (cadr pos)
	       do (loop for x below (car pos)
		     for d in l
		     do (setf (aref map x y) d)
		       ))
	   ))))
|#
