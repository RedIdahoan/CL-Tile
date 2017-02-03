;;;;TOOLBOX
(in-package #:CL-Tile)

(defvar toolbox (make-instance 'gtk-grid
			       :width-request 240
			       :height-request 1260))
(gtk-container-add toolbox paint-button)
(gtk-grid-attach toolbox eraser-button 1 0 1 1)
;;;;(gtk-grid-attach-next-to toolbox fill-button paint-button 3 1 1)
