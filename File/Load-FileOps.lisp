(load "objects-library.lisp")

(load "GUI/Window.lisp")
(load "GUI/Menus.lisp")
(load "GUI/Toolbar.lisp")
(load "GUI/Buttons.lisp")

(load "Tools/Erase.lisp")
(load "Tools/Paint.lisp")
(load "Tools/Undo-Redo.lisp")
(load "Tools/Objects.lisp")

(defmacro render-cell (n)
  `(cairo-surface-create-for-rectangle (obj-surface tile-sheet) (car (nth n (obj-cells tile-sheet))) (cadr (nth n (obj-cells tile-sheet))) (obj-tsx tile-sheet) (obj-tsy tile-sheet))
  )

(load "Widgets/Canvas.lisp")
(load "Widgets/Current-Tile.lisp")
(load "Widgets/Preview.lisp")
(load "Widgets/Tile-Sheet.lisp")
(load "Widgets/Toolbox.lisp")
(load "Widgets/Widgets.lisp")

(pack-widgets)

(load "File/New-File.lisp")
(load "File/Open-Tile-Sheet.lisp")
(load "File/Lisp-Tile-File-Parse.lisp")