(asdf:load-system "lispbuilder-sdl")

(defpackage :2d-game
  (:use :lispbuilder-sdl :cl)
  (:export :main-loop))

(in-package :2d-game)

(defparameter *tile-size* 32)
(defparameter *width* 800)
(defparameter *height* 600)
(defparameter *row-width* (/ *width* *tile-size*))
(defparameter *tile-array* (make-array *row-width*))

(defclass tile ()
  ((name :initarg :name
	 :accessor tile-name
	 :documentation "The name for the tile")
   (surface :initarg :surface
	    :accessor tile-surface
	    :documentation "The SDL Surface we will map to screen")))
   
(defun main-loop ()
"MAIN-LOOP init SDL, open the window and runs the main event loop."
  ;; init SDL, open window, and set up background gfx
  (sdl:with-init () 
    (sdl:window *width* *height* :title-caption "2d Game test" )
    (setf (sdl:frame-rate) 25)

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
      (loop :for i :from 0 :to (1- *row-width*)
	    :do (setf (aref *tile-array* i) img1))
      
       ;; map the screen map array to the window
      (loop :for range :from 0 :to (1- *row-width*)
 	    :for p = (* range *tile-size*)
	    :for position = (sdl:point :x p :y 0)
	    :for image = (tile-surface (aref *tile-array* range))
     	    :do (sdl:draw-surface-at image position)))

    (sdl:update-display)

    ;; the event loop after setup
    (sdl:with-events ()
      (:key-down-event ()
		       (when (sdl:key-down-p :sdl-key-escape)
			 (sdl:push-quit-event)))
      
      (:video-expose-event () (sdl:update-display))
;      (:idle () (sdl:clear-display sdl:*black*))
      (:quit-event () t))))
