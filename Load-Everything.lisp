(in-package #:CL-Tile)

(load "objects-library.lisp")

(load "GUI/Window.lisp")
(load "GUI/Menus.lisp")
(load "GUI/Toolbar.lisp")
(load "GUI/Buttons.lisp")

(load "Tools/Bucket.lisp")
(load "Tools/Erase.lisp")
(load "Tools/Paint.lisp")
(load "Tools/Undo-Redo.lisp")

(load "Widgets/Canvas.lisp")
;;;;(load "Widgets/Current-Tile.lisp")
(load "Widgets/Preview.lisp")
(load "Widgets/Tile-Sheet.lisp")
(load "Widgets/Toolbox.lisp")
(load "Widgets/Widgets.lisp")

(pack-widgets)

(load "File/Export.lisp")
(load "File/New-File.lisp")
(load "File/Open-Tile-Sheet.lisp")
(load "File/Lisp-Tile-File-Parse.lisp")
