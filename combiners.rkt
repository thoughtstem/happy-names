#lang racket

(require memoize)

(require "nouns.rkt")
(require "adjectives.rkt")

(provide number->pair
         pair->number)

;This is slow the first time you run it. 
;  There's probably some clever math trick to make it
;  much faster.  But I wanted to prioritize correctness
;  first.  It's really bad if we get duplicate random
;  sentences.
(define (number->pair n)
  (list-ref (pairs-of-the-day) n))

(define (pair->number p)
  (index-of (pairs-of-the-day)
            p
            (λ(x y)
              (and (eq? (first x) (first y))
                   (eq? (second x) (second y))))))

(define (pick-random l seed)
  (define my-rand (make-pseudo-random-generator))
           
  (parameterize ((current-pseudo-random-generator my-rand))
    (random-seed (remainder seed
                            (length l)))
    (list-ref l (random (length l)))))

(define (random-noun seed)
  (pick-random nouns seed))

(define (random-adjective seed)
  (pick-random adjectives seed))

(define/memo (pairs-of-the-day)
  (random-seed (current-day))
  (shuffle
     (cartesian-product adjectives
                        nouns)))

(define (current-day)
  (floor
   (/ (current-seconds)
     60
     60
     24)))


