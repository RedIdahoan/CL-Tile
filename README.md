# CL-Tile
## Information
A game-tile editor built in Common LISP using the cl-cffi-gtk package(s).

# Status

Currently, I'm using this repo as a backup. The Code will run (somewhat) correctly now. Undo and redo functions don't work right now, will push with next update.
If you want to use or make a fork of this project, I have no problems with it, just realize that there's a number of errors right now. Undo & Redo don't work properly (I think. array may be 'fixed', but surface won't be.), additional tools still need to be implemented, like Fill.

---

# How to:
## Run

How To Run this Program:

I'll eventually compile and make an executable of this program when it's "finished", that is, when it can run without an error springing up.
I will not be providing support on a windows setup (unless I get a patreon setup or something to that effect).

1. Install a LISP Implementation - I use sbcl (sbcl is available through `apt-get` and probably everything else.)
2. Install quicklisp with the implementation
3. After installing and getting quicklisp setup do `(ql:quickload :cl-cffi-gtk)` to get and install a set of GTK+ bindings for LISP.
4. After loading sbcl in the directory where "Main.lisp" is, (i.e. cd'ing into ~/Path/to/CL-Tile-folder) do `(load "Main.lisp")` then `(in-package :CL-Tile)` finally `(Tile-App)`. It should load up after that.
