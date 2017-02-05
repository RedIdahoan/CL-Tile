# CL-Tile
A game-tile editor built in Common LISP using the cl-cffi-gtk package(s).

Currently, I'm using this repo as a backup. The code as it is right now, February 3rd 2017, will not run correctly. If you want to use this project, I have no problems with it, just realize that there's a crap ton of errors right now.

How To Run this Program:

I'll eventually compile and make an executable of this program when it's "finished", that is, when it can run without an error springing up.

1. Install a LISP Implementation - I use sbcl
2. Install quicklisp with the implementation
3. After installing and getting quicklisp setup do `(ql:quickload :cl-cffi-gtk)` to get and install a set of GTK+ bindings for LISP.
4. After loading sbcl in the directory where "Main.lisp" is, (i.e. cd'ing into ~/Path/to/CL-Tile-folder) do `(load "Main.lisp")` then `(in-package :CL-Tile)` finally `(Tile-App)`. It should load up after that.
