(defvar number-of-discs)
(defvar size-of-discs)
(defvar zfs-raidz-number)
(defvar disc-size-unit)
(defvar slop-space-allocation)
(defvar size-entry)
(defvar binary-units '(("MB" 0)
		       ("GB" 10)
		       ("TB" 20)))
(defvar decimal-units '(("MiB" 0)
			("GiB" 3)
			("TiB" 6)))

(setq all-units (mapcar #'car (concatenate 'list binary-units decimal-units)))
(defun concat-to-string (list)
  (if (listp list)
      (with-output-to-string (s)
	(dolist (item list)
	  (if (stringp item)
	      (format s "~a " item))))))
(concat-to-string all-units)
(defun raidz-calc ()
  (princ "Enter disc count: ")
  (setq number-of-discs (read))
  (princ "Enter size of discs: ")
  (setq size-of-discs (read))
  (princ "Enter raidz number: ")
  (setq zfs-raidz-number (read))
  (princ "Enter unit of disc size: ")
  (setq disc-size-unit (read))
  (cond ((> (/ (* size-of-discs number-of-discs) 32) (/ (* size-of-discs number-of-discs) 2)) (setq slop-space-allocation (/ (* size-of-discs number-of-discs) 2)))
	(t (setq slop-space-allocation (/ (* size-of-discs number-of-discs) 32))))
  (if (or (assoc disc-size-unit binary-units :test #'string-equal) (assoc disc-size-unit decimal-units :test #'string-equal))
      (format t "The usable size of the ZFS array: ~F~A" (- (* number-of-discs size-of-discs (- 1 (/ zfs-raidz-number number-of-discs))) slop-space-allocation) disc-size-unit)
  (format t "Please use one of the following unints: ~s" (concat-to-string all-units)))
  (setq number-of-discs nil
	size-of-discs nil
	zfs-raidz-number nil
	disc-size-unit nil))
