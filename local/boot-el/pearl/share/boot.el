;; -*- lexical-binding: t; -*-

(require 'widget)

(defun menu-choice (prompt info handler broken)
  (let ((beg (point-marker))
	end o)
    (widget-insert (if broken "*" " "))
    (widget-create 'link
		   :notify handler
		   prompt)
    (widget-insert " " info)
    (setq end (point-marker))
    (widget-insert "\n")
    (setq o (make-overlay beg end))
    (overlay-put o 'before-string " ")
    (overlay-put o 'after-string " ")
    (overlay-put o 'cursor-sensor-functions
		 (list (lambda (win prevpos entered-or-left)
			 (overlay-put o 'face `(:background ,(if (eq entered-or-left 'entered) "#fee" "#eef")))
			 (overlay-put o 'before-string (if (eq entered-or-left 'entered) ">" " "))
			 (overlay-put o 'after-string (if (eq entered-or-left 'entered) "<" " "))
			 )))))

(defun menu (choices)
  (let ((prompt-width 0)
	(info-width 0))
    (dolist (choice choices)
      (when (eq (car choice) 'option)
	(setq prompt-width (max prompt-width
				(length (plist-get (cdr choice) :prompt))))
	(setq info-width (max info-width
			      (length (plist-get (cdr choice) :info))))))
    (dolist (choice choices)
      (when (eq (car choice) 'option)
	(while (< (length (plist-get (cdr choice) :prompt))
		  prompt-width)
	  (plist-put (cdr choice) :prompt
		     (concat (plist-get (cdr choice) :prompt) " ")))
	(while (<= (length (plist-get (cdr choice) :info))
		   info-width)
	  (plist-put (cdr choice) :info
		     (concat (plist-get (cdr choice) :info) " ")))))
    (dolist (choice choices)
      (pcase choice
	(`(option . ,plist) (menu-choice (plist-get plist :prompt)
					 (plist-get plist :info)
					 (plist-get plist :handler)
					 (plist-get plist :broken)))))))

(defun menu-to-dom (choices)
  (let ((prompt-width 0)
	(info-width 0)
	trs)
    (dolist (choice choices)
      (pcase choice
	(`(option . ,plist)
	 (let ((prompt (plist-get plist :prompt))
	       (broken (plist-get plist :broken)))
	   (when broken
	     (setq prompt (concat "*" prompt)))
	   (push `(tr ()
		      (td () (a ((href . "fake-url")) ,(propertize
							prompt
							'boot-action
							(plist-get
							 plist :action))))
		      (td () ,(plist-get plist :info)))
		 trs)))
	(`(heading . ,plist)
	 (push `(tr ()
		    (td ((colspan . "1")) (b () ,(plist-get plist :info))))
	       trs))))
    (let ((ret `(table () . ,(reverse trs))))
      (setq ret (copy-tree ret)) ;; shr relies on different xml
				 ;; attribute lists not being `eq'
      ret)))

(when nil
  (require 'shr)

  (defun parsexml (str)
    (with-temp-buffer
      (insert str)
      (libxml-parse-html-region (point-min) (point-max)))))

(defun overlay-replace-with (o &rest args)
  (save-excursion
    (with-current-buffer (overlay-buffer o)
      (let (beg1)
	(goto-char (overlay-end o))
	(setq beg1 (point-marker))
	(apply #'insert args)
	(move-overlay o (overlay-start o) (point-marker))
	(delete-region (overlay-start o) beg1)))))

(defun backtick (cmd)
  (let ((str (shell-command-to-string cmd)))
    (when (eq (aref str (1- (length str)))
	      ?\n)
      (setq str (substring str 0 (1- (length str)))))
    str))

(defun update-widget (f &optional interval)
  (let ((beg (point-marker))
	end o timer)
    (insert (funcall f))
    (setq end (point-marker))
    (setq o (make-overlay beg (marker-position end)))
    (setq timer
	  (run-with-timer 1.0 (or interval 1.0)
			  (lambda ()
			    (let ((inhibit-read-only t))
			      (if (equal (overlay-start o)
					 (overlay-end o))
				  (cancel-timer timer)
				(overlay-replace-with o (funcall f)))))))))

(defun uptime-widget ()
  (update-widget (lambda () (backtick "cat /proc/uptime"))))

(defvar shr-use-fonts)

(defun make-shell-action-with-pager (cmd)
  (lambda ()
    (shell-command cmd)))

(defun make-shell-action (cmd)
  (lambda ()
    (shell-command cmd)))

(defun boot-action-action ()
  (interactive)
  (let ((action (get-char-property (point) 'boot-action)))
    (funcall action)))

(defvar boot-action-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map " " #'boot-action-action)
    (define-key map "\r" #'boot-action-action)
    map))

(defun boot-property-change-points (name)
  (save-excursion
    (let (points)
      (goto-char (point-min))
      (while (when-let ((next-pt (next-single-property-change (point) name)))
	       (goto-char next-pt)
	       (when-let ((prop (get-char-property (point) name)))
		 (push (cons (cons (point)
				   (next-single-property-change (point) name))
			     prop)
		       points))
	       next-pt))
      (message "%S" points)
      (nreverse points))))

(defun boot-install-actions ()
  (save-excursion
    (dolist (pt (boot-property-change-points 'boot-action))
      (goto-char (caar pt))
      (let* ((action (cdr pt))
	     (end (next-single-property-change (point) 'boot-action))
	     (o (make-overlay (point) end)))
	(overlay-put o 'keymap
		     boot-action-keymap)))))

(defun boot-install-dynamic ()
  (save-excursion
    (dolist (pt (boot-property-change-points 'boot-dynamic))
      (goto-char (caar pt))
      (let* ((dynamic (cdr pt))
	     (end (next-single-property-change (point) 'boot-dynamic))
	     (o (make-overlay (point) end))
	     timer)
	(setq timer
	      (run-with-timer 1.0 1.0
			      (lambda ()
				(let ((inhibit-read-only t))
				  (if (equal (overlay-start o)
					     (overlay-end o))
				      (cancel-timer timer)
				    (overlay-replace-with
				     o
				     (funcall dynamic)))))))))))

(defvar cursor-type)

(defun dirfiles (path)
  (directory-files path nil "...\\|[^.]"))

(defun boot-menu ()
  "Create and display a boot menu"
  (interactive)
  (let ((cursor-type 'box)
	start-out-point l o shr-use-fonts)
    (switch-to-buffer "*Pearl Boot Menu*")
    (kill-all-local-variables)
    (let ((inhibit-read-only t))
      (erase-buffer))
    (remove-overlays)
    (widget-insert "User-Friendly Menu ("
		   (propertize "*" 'face '(:weight bold))
		   " marks broken options)\n\n")
    ;;(uptime-widget)
    (setq start-out-point (point-marker))
    (let* ((choices))
      (letf (((symbol-function 'option)
	      (lambda (&rest args) (push (cons 'option args) choices)))
	     ((symbol-function 'heading)
	      (lambda (&rest args) (push (cons 'heading args) choices))))
	(option :prompt "shell"
		:info "Shell prompt")
	(option :prompt "linux"
		:info "Boot Linux"
		:action (make-shell-action "linux"))
	(heading :prompt "booting"
		 :info "Booting")
	(option :prompt "stage3"
		:info "(re)enter stage3"
		:action (make-shell-action "stage3"))
	(option :prompt "stage2"
		:info "(re)enter stage2"
		:action (make-shell-action "stage2"))
	(option :prompt "m1n1"
		:info "launch m1n1"
		:action (make-shell-action "m1n1"))
	(option :prompt "barebox"
		:info "launch barebox"
		:action (make-shell-action "barebox"))
	(option :prompt "u-boot"
		:info "launch U-Boot"
		:action (make-shell-action "u-boot"))
	(option :prompt "grub"
		:info "launch GRUB"
		:action (make-shell-action "grub")
		:broken t)
	(option :prompt "macos"
		:info "boot macOS"
		:action (make-shell-action "macos")
		:broken t)
	(heading :prompt "hardware"
		 :info "Hardware")
	(option :prompt "gadget"
		:info "(re)start USB gadget"
		:action (make-shell-action "gadget"))
	(option :prompt "wifi"
		:info "(re)start WiFi"
		:action (make-shell-action "wifi")
		:broken t)
	(option :prompt "x8r8g8b8"
		:info "fix framebuffer colors"
		:action (make-shell-action "x8r8g8b8"))
	(option :prompt "x2r10g10b10"
		:info "break framebuffer colors"
		:action (make-shell-action "x2r10g10b10"))
	(option :prompt "dwc3"
		:info "re-initialize USB"
		:action (make-shell-action "dwc3"))
	(option :prompt "nvme"
		:info "initialize NVMe"
		:action (make-shell-action "nvme")
		:broken t)
	(option :prompt "enable-wdt"
		:info "enable Watchdog Timer (will reboot)"
		:action (make-shell-action "enable-wdt"))
	(option :prompt "reboot"
		:info "reboot immediately"
		:action (make-shell-action "reboot")
		:broken t)
	(option :prompt "reboot-wdt"
		:info "reboot immediately using WDT"
		:action (make-shell-action "reboot-wdt"))
	(option :prompt "reboot-recovery"
		:info "reboot to Recovery Mode using WDT"
		:action (make-shell-action "reboot-recovery"))
	(heading :prompt "info"
		 :info "Information")
	(option :prompt "uname"
		:info (backtick "uname -a"))
	(option :prompt "dmesg"
		:info "Kernel Messages"
		:action (make-shell-action-with-pager "dmesg"))
	(option :prompt "uptime"
		:info (propertize
			"uptime"
			'boot-dynamic (lambda () (backtick "cat /proc/uptime"))))
	(option :prompt "battery"
		:info (propertize
			"SBAS"
			'boot-dynamic (lambda () (backtick "cat /sys/kernel/debug/SBAS")))
		:broken t)
	(let (headingp)
	  (dolist (blkdev (dirfiles "/sys/class/block"))
	    (unless headingp
	      (heading :prompt "dev"
		       :info "Block devices")
	      (setq headingp t))
	    (option :prompt blkdev
		    :info
		    (cond
		     ((file-readable-p (format "/sys/class/block/%s/dm/name"
					       blkdev))
		      (slurp (format "/sys/class/block/%s/dm/name" blkdev)))
		     ((format "unknown block device"))))))
	(dolist (bus (dirfiles "/sys/class/pci_bus/"))
	  (option :prompt (format "pci_bus/%s" bus)
		  :info (format "PCI bus %s (%S devices)" bus 1.0e+INF))))
      (let ((dom (menu-to-dom (nreverse choices))))
	(shr-insert-document dom)))
    (boot-install-actions)
    (boot-install-dynamic)
    (goto-char (1+ start-out-point))))

(boot-menu)
(menu-bar-mode 0)
(blink-cursor-mode 0)
(cursor-sensor-mode)
