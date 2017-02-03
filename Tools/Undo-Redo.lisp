(in-package #:CL-Tile)

(defvar undo-stack '()) ;;;;On mouse-release, push current array to undo stack
(defvar redo-stack '()) ;;;;On Undo, Push current array onto redo stack, set nth 0 of undo stack to current array

(defun push-to-stack (array stack)
  (push (loop for y below (car (array-dimensions array))
	   append (loop for x below (cadr (array-dimensions array))
		     collect (list (aref array y x))
		       )) stack)
  )

(defun Undo (array)
  (push-to-stack array redo-stack)
  (loop for y below (car (array-dimensions array))
     do (loop for x below (cadr (array-dimensions array))
	   do (setf (aref array y x) (nth (+ x (* y (car (array-dimensions array)))) (car undo-stack)))
	     ))
  (setf undo-stack (remove (nth 0 undo-stack) undo-stack))
  )

(defun Redo (array)
  (push-to-stack array undo-stack)
  (loop for y below (car (array-dimensions array))
     do (loop for x below (cadr (array-dimensions array))
	   do (setf (aref array y x) (nth (+ x (* y (car (array-dimensions array)))) (car redo-stack)))
	     ))
  (setf redo-stack (remove (nth 0 redo-stack) redo-stack))
  )
