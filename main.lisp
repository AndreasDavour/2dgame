(asdf:load-system "lispbuilder-sdl")

(defpackage :2d-game
  (:use :lispbuilder-sdl :lispbuilder-sdl-gfx :cl)
  (:export :main-loop))

(in-package :2d-game)

(defun main-loop ()
  ;; init SDL, open window, and set up background gfx
  (sdl:with-init () 
    (sdl:window 800 600 :title-caption "2d Game test" )
    (setf (sdl:frame-rate) 25)
    (let ((img1 (sdl:load-image "/home/ante/2dgame/tubes-tile.bmp" ))
	  (tile-array (make-array 15)))
      (loop for i from 0 to 15
	    do (setf (aref tile-array i) img1))
      (loop for i from 0 to 15
	    do (sdl:draw-surface-at img1 #(i 0))))
    (sdl:update-display)
    ;; the event loop after setup
    (sdl:with-events ()
      (:key-down-event ()
		       (when (sdl:key-down-p :sdl-key-escape)
			 (sdl:push-quit-event)))
      
      (:video-expose-event () (sdl:update-display))
;      (:idle () (sdl:clear-display sdl:*black*))
      (:quit-event () t))))
