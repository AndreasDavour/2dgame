(asdf:load-system "lispbuilder-sdl")

(defpackage :2d-game
  (:use :lispbuilder-sdl :cl)
  (:export :main-loop))

(in-package :2d-game)

(defparameter *tile-size* 32)
(defparameter *width* 1024)
(defparameter *height* 768)
(defparameter *row-width* (/ *width* *tile-size*))

(defun main-loop ()
"MAIN-LOOP init SDL, open the window and runs the main event loop."
  ;; init SDL, open window, and set up background gfx
  (sdl:with-init () 
    (sdl:window *width* *height* :title-caption "2d Game test" )
    (setf (sdl:frame-rate) 25)

    ;; This LET should probably be its own function returning a
    ;; alist with all the loaded assets.
    ;; Add to that a utility function that grabs out the tile/snd needed
    (let ((img1 (sdl:load-image "/home/ante/src/2dgame/tubes-tile.bmp" ))
	  (tile-array (make-array *row-width*)))

      (loop :for i :from 0 :to (1- *row-width*)
	    :do (setf (aref tile-array i) img1))

      (loop :for i :from 0 :to (1- *row-width*)
	    :for range :from 0 :to (1- *row-width*)
	    :for p = (* range *tile-size*)
	    :for position = (sdl:point :x p :y 0)
    	    :do (sdl:draw-surface-at (aref tile-array i) position)))
    
    (sdl:update-display)

    ;; the event loop after setup
    (sdl:with-events ()
      (:key-down-event ()
		       (when (sdl:key-down-p :sdl-key-escape)
			 (sdl:push-quit-event)))
      
      (:video-expose-event () (sdl:update-display))
;      (:idle () (sdl:clear-display sdl:*black*))
      (:quit-event () t))))
