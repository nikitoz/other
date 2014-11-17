;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

(define (mcons a b) (apair a b))
(define (mcar a) (apair-e1 a))
(define (mcdr a) (apair-e2 a))

(define (l3 a b c)
  (mcons a (mcons b (mcons c (aunit)))))
;;
(define (matom->atom ma)
  (cond [(int? ma) (int-num ma)]
        [(var? ma) (var-string ma)]
        [#t (raise "matom->atom oops")]))

(define (mupllist->racketlist lst)
  (if (apair? lst)
    (cons (mcar lst) (mupllist->racketlist (mcdr lst)))
    '()))

(define (racketlist->mupllist lst)
  (if (pair? lst)
      [mcons (car lst) (racketlist->mupllist (cdr lst))]
      [aunit]))
    

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(int? e) e]
        [(add? e) (int (+ (int-num (eval-under-env (add-e1 e) env)) (int-num (eval-under-env (add-e2 e) env))))]
        [(fun? e) (closure env e)]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (if (> (int-num v1) (int-num v2))
                 (eval-under-env (ifgreater-e3 e) env)
                 (eval-under-env (ifgreater-e4 e) env))
               (raise "ifgreater works only with ints")))]
        [(mlet? e)
          (eval-under-env (mlet-body e) (cons (cons (mlet-var e) (eval-under-env (mlet-e e) env)) env))]
        [(apair? e) (mcons (eval-under-env (mcar e) env) (eval-under-env (mcdr e) env))]
        [(fst? e) (let ([v (eval-under-env (fst-e e) env)]) (if (apair? v) (mcar v) (raise "pls pass pair to fst")))]
        [(snd? e) (let ([v (eval-under-env (snd-e e) env)]) (if (apair? v) (mcdr v) (raise "pls pass pair to snd")))]
        [(isaunit? e) (if (aunit? (eval-under-env (isaunit-e e) env)) (int 1) (int 0))]
        [(aunit? e) (aunit)]
        [(call? e)
          (let ([v1 (eval-under-env (call-funexp e) env)]
                [v2 (eval-under-env (call-actual  e) env)])
            (if (closure? v1)
                (let* ([function (closure-fun v1)]
                       [function-name  (fun-nameopt function)]
                       [function-param (fun-formal function)]
                       [function-body  (fun-body function)])
                  (eval-under-env function-body (cons (cons function-name function) (cons (cons function-param v2) env))))
                (raise "wrong call syntax")))]
        [(closure? e) e]
        ;; CHANGE add more cases here
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3) (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet-helper lst env)
  (cond
   [(null? lst) env]
   [#t (mlet-helper (cdr lst) (cons (cons (caar lst) (eval-under-env (cdar lst) env)) env))]))

(define (mlet* lst e2)
  (cond
   [(null? lst) e2]
   [#t (mlet (caar lst) (cdar lst) (mlet* (cdr lst) e2) )]))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2)) (ifgreater (var "_x") (var "_y") e4 (ifgreater (var "_y") (var "_x") e4 e3))))

;; Problem 4
(define (mupl-map lamb in)
   (cond
   [(aunit? in) (aunit)]
   [(apair? in) (apair (lamb (mcar in)) (mupl-map (mcdr in)))]
   [else (raise "ololo map failed")]))

(define (mupl-map lamb lst)
  (fun "map" param (mcons (call lamb (mcar lst)) (call "map" (mcdr lst))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        "CHANGE (notice map is now in MUPL scope)"))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
