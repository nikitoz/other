
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file


;(print "hello world")
;; put your code below

(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

(define (string-append-map xs suffix)
  (map (lambda(x) (string-append (if (symbol? x) (symbol->string x) x) (if (symbol? suffix) (symbol->string suffix) suffix))) xs))

;(string-append-map (quote (hear wel ac)) "t")

(define (list-nth-mod xs n)
  (if (< n 0)
      (error "list-nth-mod: negative number")
      [if (= 0 (length xs))
          (error "list-nth-mod: empty list")
          (car (list-tail xs (remainder n (length xs))))]))

(define (stream-for-n-steps s n)
  [if (= 0 n)
      null
      [let ([pr (s)])
        (cons (car pr) 
              (stream-for-n-steps (cdr pr) (- n 1)))]])

(define (make-thunk gen next param)
  (cons (gen param)
  (lambda () (make-thunk gen next (next param)))))

(define (funny-number-stream)
  (make-thunk
   (lambda (n) (if [= 0 (remainder n 5)] (* -1 n) n))
   (lambda (n) (+ 1 n))
   1))

(define (dan-then-dog)
  (make-thunk
   (lambda (n) [if (= 0 (remainder n 2)) "dan.jpg" "dog.jpg"])
   (lambda (n) (+ 1 n))
   0))

(define (stream-add-zero s)
  (lambda ()
    (let [(pr (s))]
    (cons (cons 0 (car pr))
          (stream-add-zero (cdr pr))))))

(define (nth xs i)
  (if (= 0 i) (car xs) (nth (cdr xs) (- i 1))))

(define (cycle-lists xs ys)
  (lambda ()
    (make-thunk
   	  (lambda (n) (cons (nth xs (remainder n (length xs))) (nth ys (remainder n (length ys)))))
      (lambda (n) (+ 1 n))
   0)))

(define (vector-assoc v vec)
  (define (vector-assoc-internal v vec current)
    (if (= current (vector-length vec))
        #f
        [if (pair? (vector-ref vec current))
            (if (equal? (car (vector-ref vec current)) v) (vector-ref vec current) (vector-assoc-internal v vec (+ 1 current)))
            (vector-assoc-internal v vec (+ 1 current))]))
  (vector-assoc-internal v vec 0))

(define (cached-assoc xs n)
  (letrec (
    [vec (make-vector n #f)]
    [pos 0]
    [f (lambda (v)
      (let ([r (vector-assoc v vec)])
        (if (equal? #f r) 
          (let ([res (assoc v xs)])
            [
              begin 
              (vector-set! vec (remainder pos n) res)
              (set! pos (+ 1 pos))
              res
            ])
            r)))])
     f))
