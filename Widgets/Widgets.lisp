#|
THE WIDGETS

TILE SHEET
TOOLBOX
PREVIEW
CURRENT TILE + NO.
DRAWING AREA - THE MAP

FUTURE: NODES - AKA AREAS

|#
(in-package #:CL-Tile)

(defun pack-widgets ()
  (let* ((widget-separator-v (make-instance 'gtk-separator
					    :height-request 1360
					    :width-request 8
					    :orientation :vertical
					    :vexpand t
					    ))
	 
	 (widget-separator-h (make-instance 'gtk-separator
					    :height-request 8
					    :width-request 64
					    :orientation :horizontal
					    :hexpand t
					    ))
	 (window-grid (make-instance 'gtk-layout
				     :height 720
				     :width  1360
				     ))
	 (ww (gtk-layout-width window-grid))
	 (wh (gtk-layout-height window-grid))
	 )
    (gtk-layout-put window-grid map-widget 96 72)
    (gtk-layout-put window-grid toolbox 0 72)
    (gtk-layout-put window-grid menu-box 0 0)
    (gtk-layout-put window-grid toolbar 0 16)
    (gtk-layout-put window-grid preview-widget (- ww 64) 64)
    (gtk-layout-put window-grid tile-sheet-widget (- ww 270) (+ (/ wh 3) 64))
;;;;    (gtk-layout-put window-grid tile-widget (- ww 64) (+ (/ wh 2) 64))
    (gtk-layout-put window-grid widget-separator-h (- ww 64) (/ wh 4))    
    (gtk-layout-put window-grid widget-separator-h (- ww 64) (/ wh 2))
    (gtk-layout-put window-grid widget-separator-v 48 72)
    (gtk-layout-put window-grid widget-separator-v (- ww 64) 64)
    (gtk-widget-show-all window-grid)
    (gtk-container-add Tile-Window window-grid)
    )
  )
