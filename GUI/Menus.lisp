(in-package #:CL-Tile)

(defmacro def-menu-item (name txt)
  `(defvar ,name (gtk-menu-item-new-with-label ,txt)))
(defmacro append-item (var menu)
  `(gtk-menu-shell-append ,menu ,var))
(defmacro add-menu (item menu)
  `(progn (defvar ,menu (gtk-menu-new))
	  (setf (gtk-menu-item-submenu ,item) ,menu)))

(defvar menu-box (gtk-box-new :vertical 0))
(defvar menu-bar (make-instance 'gtk-menu-bar
				:width-request 1360
				:height-request 16))
(gtk-container-add menu-box menu-bar)

(def-menu-item file-item "File")
(def-menu-item edit-item "Edit")
(def-menu-item view-item "View")
(def-menu-item help-item "Help")

(append-item file-item menu-bar)
(append-item edit-item menu-bar)
(append-item view-item menu-bar)
(append-item help-item menu-bar)

(add-menu file-item file-menu)
(add-menu edit-item edit-menu)
(add-menu view-item view-menu)
(add-menu help-item help-menu)

(def-menu-item new-item "New")
(def-menu-item open-item "Open")
(def-menu-item save-item "Save")
(def-menu-item close-item "Close")
(def-menu-item export-item "Export")
(def-menu-item exit-item "Exit")
(append-item new-item file-menu)
(append-item open-item file-menu)
(append-item save-item file-menu)
(append-item close-item file-menu)
(append-item (gtk-separator-menu-item-new) file-menu)
(append-item export-item file-menu)
(append-item exit-item file-menu)

(g-signal-connect new-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (New-File-Dialog)
		    ))

(g-signal-connect save-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (save-to-ltf (obj-file Tile-File))
		    ))

(g-signal-connect close-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    ))

(g-signal-connect export-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (export-dialog)
		    ))

(g-signal-connect exit-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (gtk-widget-destroy Tile-Window)
		    ))


(def-menu-item undo-item "Undo")
(def-menu-item redo-item "Redo")
(append-item undo-item edit-menu)
(append-item redo-item edit-menu)

(g-signal-connect undo-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (Undo (obj-array Tile-File))
		    ))

(g-signal-connect redo-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (Redo (obj-array Tile-File))
		    ))

(def-menu-item zoom-in-item "Zoom +")
(def-menu-item zoom-out-item "Zoom -")
(append-item zoom-in-item view-menu)
(append-item zoom-out-item view-menu)
#|
(g-signal-connect zoom-in-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (zoom-in-canvas)
		    ))
		  

(g-signal-connect zoom-out-item "activate"
		  (lambda (widget)
		    (declare (ignore widget))
		    (zoom-out-canvas)
		    ))
		  
|#
(def-menu-item about-item "About this Program")
(def-menu-item directions-item "How do I...")
(append-item about-item help-menu)
(append-item directions-item help-menu)
