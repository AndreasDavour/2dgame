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
  
(defun main-loop ()
"MAIN-LOOP init SDL, open the window and runs the main event loop."
  ;; init SDL, open window, and set up background gfx
  (sdl:with-init () 
    (sdl:window *width* *height* :title-caption "2d Game test" )
    (setf (sdl:frame-rate) 25)

    ;; This LET should probably be its own function returning a
    ;; alist with all the loaded assets.
    ;; Add to that a utility function that grabs out the tile/snd needed

    ;; load all tiles into symbols
    ;; make alist to lookup the tile symbols
    ;; make a util function to get the surface pointed to by the symbols, to map on screen
    (let ((img1 (sdl:load-image "/home/ante/src/2dgame/assets/tubes-tile.bmp" ))
	  (img2 (sdl:load-image "/home/ante/src/2dgame/assets/tubes-with-bar-end-right-tile.bmp"))
	  (img3 (sdl:load-image "/home/ante/src/2dgame/assets/tubes-with-bar-tile.bmp")))

;;; had an issue with getting out the SURFACE if I just injected the
;;; symbol into the screenmap array. I realized I had to use some
;;; macro magic to evalute the symbol after extracting it from the
;;; array. This snippet works as I want. Can it be done some other
;;; way?
;;;
;;;       (defmacro apa ()
;;; 	`(let ((tst ,(aref testarray 2)))
;;; 	   tst))
;;;       APA
;;;       CL-USER> (apa)
;;;       23
;;;       CL-USER> 

      ;; fill the screen map array with tiles
      (loop :for i :from 0 :to (1- *row-width*)
;;	    :do (setf (aref tile-array i) img1))
      	    :do (setf (aref *tile-array* i) 'img1))
      
       ;; map the screen map array to the window
      (loop :for i :from 0 :to (1- *row-width*)
 	    :for range :from 0 :to (1- *row-width*)
 	    :for p = (* range *tile-size*)
	    :for position = (sdl:point :x p :y 0)
	    :for image = `(let ((tile ,(aref *tile-array* `,i))) `,tile)
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
