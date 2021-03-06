#|(defmacro New-File (name size-x size-y t-s-x t-s-y)
`(progn 
)
)
|#
#|
gtk-spin-button-get-value-as-int (spin-button)
|#
(in-package :CL-Tile)


(defun New-File-Dialog ()
  (let ((dialog-box (gtk-dialog-new-with-buttons "New File"
						 nil
						 '(:modal)
						 "gtk-ok"
						 :ok
						 "gtk-cancel"
						 :cancel))
	(vbox (make-instance 'gtk-vbox))
	(canvas-size-x (make-instance 'gtk-spin-button
				      :adjustment
				      (make-instance 'gtk-adjustment
						     :value 1.0
						     :lower 1.0
						     :upper 100000.0
						     :step-increment 1.0
						     :page-increment 10.0
						     :page-size 0.0)
				      :climb-rate 0.5
				      :digits 0
				      :wrap t))
	(canvas-size-y (make-instance 'gtk-spin-button
				      :adjustment
				      (make-instance 'gtk-adjustment
						     :value 1.0
						     :lower 1.0
						     :upper 100000.0
						     :step-increment 1.0
						     :page-increment 10.0
						     :page-size 0.0)
				      :climb-rate 0.5
				      :digits 0
				      :wrap t))
	(tile-size-x (make-instance 'gtk-spin-button
				    :adjustment
				    (make-instance 'gtk-adjustment
						   :value 32.0
						   :lower 1.0
						   :upper 1280.0
						   :step-increment 32.0
						   :page-increment 64.0
						   :page-size 0.0)
				    :climb-rate 0
				    :digits 0
				    :wrap t))
	(tile-size-y (make-instance 'gtk-spin-button
				    :adjustment
				    (make-instance 'gtk-adjustment
						   :value 32.0
						   :lower 1.0
						   :upper 1280.0
						   :step-increment 32.0
						   :page-increment 64.0
						   :page-size 0.0)
				    :climb-rate 0
				    :digits 0
				    :wrap t)))
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Map Size X:"
				       :xalign 0
				       :yalign 0.5)
			:expand nil)
    (gtk-box-pack-start vbox canvas-size-x :expand nil)
;;;;	(gtk-box-pack-start (gtk-dialog-get-content-area dialog-box) vbox :padding 6)
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Map Size Y:"
				       :xalign 0
				       :yalign 0.5)
			:expand nil)
    (gtk-box-pack-start vbox canvas-size-y :expand nil)
;;;;	(gtk-box-pack-start (gtk-dialog-get-content-area dialog-box) vbox :padding 6)
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Tile Size X:"
				       :xalign 0
				       :yalign 1)
			:expand nil)
    (gtk-box-pack-start vbox tile-size-x :expand nil)
;;;;	(gtk-box-pack-start (gtk-dialog-get-content-area dialog-box) vbox :padding 6)
    (gtk-box-pack-start vbox
			(make-instance 'gtk-label
				       :label "Tile Size Y:"
				       :xalign 0
				       :yalign 1)
			:expand nil)
    (gtk-box-pack-start vbox tile-size-y :expand nil)
    (gtk-box-pack-start (gtk-dialog-get-content-area dialog-box) vbox :padding 6)
    (g-signal-connect dialog-box "response"
		      (lambda (dialog-box response-id)
			(if (eq response-id -5)
			    (let* ((size-x (gtk-spin-button-get-value-as-int canvas-size-x))
				  (size-y (gtk-spin-button-get-value-as-int canvas-size-y))
				  (t-s-x (gtk-spin-button-get-value-as-int tile-size-x))
				  (t-s-y (gtk-spin-button-get-value-as-int tile-size-y))
				  (cr (cairo-image-surface-create :argb32 (* size-x t-s-x) (* size-y t-s-y)))
				  )
			      ;;;;(eval `(defvar map-array (make-array '(,size-x ,size-y))))
			      (setf Tile-File (make-obj :name "PlaceHolder" :size-x size-x :size-y size-y :tsx t-s-x :tsy t-s-y :array (eval `(make-array '(,size-y ,size-x))) :map-surface cr))
			      ;;;;(setf object-list (append object-list Tile-File))
			      )
			    )
			(gtk-widget-destroy dialog-box)
			(sheet-dialog)
			)
		      )
    (gtk-widget-show-all dialog-box)
    ))
