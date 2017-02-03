#|(defmacro delimiter (pos sym &body body)
  `(if (eq ,pos ,sym)
       ,@body
       ))
|#
(defvar tmp-list nil)
(defvar column 0)

(defun read-csv (file-name wide high)
  (with-open-file (file file-name :direction :input)
    (loop for y below high
       do (loop for x = (read-char file)
	     do (progn (if (not (eq x #\,))
			   (#|do stuff|#);;;;Append x into tmp-list
			   (#|process stuff|#));;;set an array? add 1 to column. Purge tmp-list
		       ))
	 )
    )
  )
