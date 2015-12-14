;;;;
;;;; A very basic POF for a 2d platform game, in the old C64 style.
;;;;

;;; set up the system
(asdf:load-system "lispbuilder-sdl")

(defpackage :2d-game
  (:use :lispbuilder-sdl :cl)
  (:export :main-loop))

(in-package :2d-game)

;;;
;;; some static global data
;;; maybe some of this should migrate to a config file later on.
;;;
(defparameter *tile-size* 32)
(defparameter *width* 800)
(defparameter *height* 600)
(defparameter *row-width* (/ *width* *tile-size*))
(defparameter *row-height* (round (coerce (/ *height* *tile-size*) 'float)))
;;(defparameter *row-height* (/ *height* *tile-size*))
(defparameter *tile-array* (make-array (list *row-height* *row-width*)))

;;;
;;; defining classes needed
;;;
;;; TODO:
;;;      break this out into its own file
(defclass tile ()
  ((name :initarg :name
	 :accessor tile-name
	 :documentation "The name for the tile")
   (surface :initarg :surface
	    :accessor tile-surface
	    :documentation "The SDL Surface we will map to screen")))

;;;
;;; helper functions for MAIN-LOOP
;;;
;;; TODO:
;;;      break this out into its own file
(defun load-screen-map ()
  "Load specified graphics tiles into a map array for the screen."
  (let ((img1 (make-instance
	       'tile :name "tubes-tile"
		     :surface (sdl:load-image "/home/ante/src/2dgame/assets/tubes-tile.bmp" )))
	(img2 (make-instance
	       'tile :name "tubes-with-bar-end-right-tile"
		     :surface (sdl:load-image "/home/ante/src/2dgame/assets/tubes-with-bar-end-right-tile.bmp")))
	(img3 (make-instance
	       'tile :name "tubes-with-bar-tile"
		     :surface (sdl:load-image "/home/ante/src/2dgame/assets/tubes-with-bar-tile.bmp"))))
    
    ;; fill the screen map array with tiles
    ;; a bit boring, since it's all one tile
    (loop :for i :from 0 :to (1- *row-height*)
	  :do (setf (aref *tile-array* i 0) img1)
	      ;; then the rows
	      (loop :for p :from 0 :to (1- *row-width*)
		    :do (setf (aref *tile-array* i p) img1)))))

(defun verify-screen-array ()
  "Verify the screen array by printing it out."
  (loop :for i :from 0 :to (1- *row-height*)
	:do (format t "pos: ~A X: ~A~%" i (aref *tile-array* i 0))
	    (loop :for p :from 0 :to (1- *row-width*)
		  :do (format t "X: ~A Y: ~A::~A~%" i p (aref *tile-array* i p)))))

;;;
;;; MAIN LOOP
;;;
(defun main-loop ()
"MAIN-LOOP init SDL, open the window and runs the main event loop."
  ;; init SDL, open window, and set up background gfx
  (sdl:with-init () 
    (sdl:window *width* *height* :title-caption "2d Game test" )
    (setf (sdl:frame-rate) 25)
    (load-screen-map)
    
       ;; map the screen map array to the window
       (loop :for lines :from 0 :to (1- *row-height*)
 	    ;; draw each horizontal line
 	    :do (loop :for width-range :from 0 :to (1- *row-width*)
 		      :for x = (* width-range *tile-size*)
 		      :for position = (sdl:point :x x :y (* *tile-size* lines))
 		      :for image = (tile-surface (aref *tile-array* lines width-range))
 		      :do (sdl:draw-surface-at image position)))

    (sdl:update-display)

    ;; the event loop after setup
    (sdl:with-events ()
      (:key-down-event ()
		       (when (sdl:key-down-p :sdl-key-escape)
			 (sdl:push-quit-event)))
      
      (:video-expose-event () (sdl:update-display))
;      (:idle () (sdl:clear-display sdl:*black*))
      (:quit-event () t)))))
