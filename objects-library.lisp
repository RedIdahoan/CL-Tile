(in-package #:CL-Tile)

(defstruct obj
  (name nil)
  (file nil)
  (surface nil)
  (size-x nil)
  (size-y nil)
  (tsx nil)
  (tsy nil)
  (columns 0)
  (rows 0)
  (array nil)
  (cells nil)
  (sheet nil)
  (ts-surface nil)
  (map-surface nil))
  
(defvar object-list nil)
