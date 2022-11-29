#lang eopl

;****************************************ESPECIFICACION LEXICA****************************************
(define especificacion-lexica
  '(
    (espacio-blanco (whitespace) skip)
    (comentario ("#" (arbno (not #\newline))) skip)
    (identificador (letter (arbno (or letter digit "?" "$"))) symbol)
    (texto ("\"" (arbno (or letter digit "?" "$" "-" "#" "." whitespace)) "\"") string)
    (numero (digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit) "." digit (arbno digit)) number)
    (numero-hexa ("0x" (or digit "a" "b" "c" "d" "e" "f")
                       (arbno (or digit "a" "b" "c" "d" "e" "f"))) string)
    (numero-octal ("0o" (or "0" "1" "2" "3" "4" "5" "6" "7")
                        (arbno (or "0" "1" "2" "3" "4" "5" "6" "7"))) string)
    )
  )

;**************************************ESPECIFICACION GRAMATICAL**************************************
(define especificacion-gramatical
  '(
    ;-------------------------------------------EXPRESIONES-------------------------------------------
    (programa (expresion) a-program)
    (expresion (numero) num-exp)
    (expresion (numero-hexa) numHexa-exp)
    (expresion (numero-octal) numOctal-exp)
    (expresion (identificador) var-exp)
    (expresion (texto) texto-exp)
    
    ;......................................EXPRESIONES BOOLEANAS......................................
    (expresion ("true") true-exp)
    (expresion ("false") false-exp)

    ;..........................................CONDICIONALES..........................................
    (expresion ("if" expresion ":" expresion "else" expresion) if-exp)

    ;........................................EXPRESION INFIJA.........................................
    (expresion ("(" expresion primitiva expresion ")") prim-exp)

    ;.......................................EXPRESIONES LOCALES.......................................
    (expresion ("let" (arbno identificador "=" expresion) "in" expresion) let-exp)

    ;.........................................PROCEDIMIENTOS..........................................
    (expresion ("proc" "(" (separated-list identificador ",") ")" expresion) proc-exp)
    (expresion ("[" expresion (arbno expresion) "]") app-exp)

    ;...........................................ASIGNACION............................................
    (expresion ("modify" expresion (arbno ";" expresion) "end") modify-exp)
    (expresion ("set" identificador "=" expresion) set-exp)
    
    ;.............................................UNARIAS.............................................
    (expresion (primitiva-unaria "(" expresion ")") unaria-exp)
    (expresion (primitiva-unariaStrings "(" expresion "+" expresion ")") unariaStrings-exp)

    ;...........................................WHILE & FOR...........................................
    (expresion ("while" expresion ":" expresion) while-exp)
    (expresion ("for" expresion "in" expresion ":" expresion) for-exp)

    ;...........................................ESTRUCTURA............................................
    (expresion ("struct" identificador "=" "{" identificador ":" expresion
                         (arbno "," identificador ":" expresion) "}") struct-exp)
    (expresion ("get" identificador "." identificador) getStruct-exp)
    (expresion ("send" identificador "." identificador "=" expresion) sendStruct-exp)

    ;--------------------------------------------PRIMITIVAS-------------------------------------------
    
    ;.....................................PRIMITIVAS ARITMETICAS......................................
    (primitiva ("+") sum-prim)
    (primitiva ("-") minus-prim)
    (primitiva ("*") mult-prim)
    (primitiva ("%") mod-prim)
    (primitiva ("/") div-prim)
    ;......................................PRIMITIVAS BOOLEANAS.......................................
    (primitiva ("<") menor-prim)
    (primitiva (">") mayor-prim)
    (primitiva ("<=") menorIgual-prim)
    (primitiva (">=") mayorIgual-prim)
    (primitiva ("==") igual-prim)
    (primitiva ("!=") diferente-prim)
    (primitiva ("and") and-prim)
    (primitiva ("or") or-prim)
    ;.......................................PRIMITIVAS UNARIAS........................................
    (primitiva-unaria ("add1") add-prim)
    (primitiva-unaria ("sub1") sub-prim)
    ;......................................PRIMITIVAS DE CADENAS......................................
    (primitiva-unaria ("length") length-prim)
    (primitiva-unaria ("not") not-prim)
    (primitiva-unariaStrings ("concat") concat-prim)
    )
  )

;---------------------------------------GENERACION DE DATATYPES---------------------------------------
(sllgen:make-define-datatypes especificacion-lexica especificacion-gramatical)
(define datatypes (sllgen:list-define-datatypes especificacion-lexica especificacion-gramatical))

;.............................................SCANNER.............................................
(define escanner
  (lambda (exp)
    ( (sllgen:make-string-scanner
     especificacion-lexica
     especificacion-gramatical) exp)))

;.............................................PARSER..............................................
(define parser
  (lambda (exp)
    (
     (sllgen:make-string-parser
     especificacion-lexica
     especificacion-gramatical)
    exp)
    ))

;--------------------------------------------EVAL PROGRAM---------------------------------------------
(define eval-program
  (lambda (pgm)
    (cases programa pgm
      (a-program (exp) (eval-expresion exp ambiente-inicial)))))

(define eval-expresion
  (lambda (exp amb)
    (cases expresion exp
      ;Numericos
      (num-exp (number) number)
      (numHexa-exp (hexa) hexa)
      (numOctal-exp (octal) octal)
      (var-exp (id) (apply-env amb id))
      (texto-exp (texto) texto)
      (prim-exp (exp1 prim exp2) (eval-prim (eval-expresion exp1 amb ) prim (eval-expresion exp2 amb)))
      (unaria-exp (prim args) (evalUnaria-prim prim (eval-expresion args amb)))
      (unariaStrings-exp (prim exp1 exp2) (evalUnariaString-prim prim (eval-expresion exp1 amb) (eval-expresion exp2 amb)))
      ;Booleanos
      (true-exp () #true)
      (false-exp () #false)
      ;Condicion
      (if-exp (condicion hace-verdadero hace-falso)
              (if
               (eval-expresion condicion amb) ;Evaluamos la condición
               (eval-expresion hace-verdadero amb) ;En caso de que sea verdadero
               (eval-expresion hace-falso amb) ;En caso de que sea falso
               )
              )
      (else "tupu")
      )
    )
  )

(define evalUnariaString-prim
  (lambda (prim exp exp1)
    (cases primitiva-unariaStrings prim
      (concat-prim () (string-append exp exp1))
      )
    )
  )

(define evalUnaria-prim
  (lambda (exp lval)
    (cases primitiva-unaria exp
      (add-prim () (+ lval 1))
      (sub-prim () (- lval 1))
      (length-prim () (- (string-length lval) 2))
      (not-prim () (not lval))
      )
    )
  )


(define eval-prim
  (lambda (val1 prim val2 )
    (cases primitiva prim
      ;; primitivas numericas
      (sum-prim () (+ val1 val2)) 
      (minus-prim () (- val1 val2) )
      (mult-prim () (* val1 val2))
      (div-prim () (/ val1 val2))
      (mod-prim () (remainder val1 val2))
      ;; primitivas booleanas
      (mayor-prim () (> val1 val2))
      (mayorIgual-prim () (>= val1 val2))
      (menor-prim () (< val1 val2))
      (menorIgual-prim () (<= val1 val2))
      (igual-prim () (= val1 val2))
      (diferente-prim () (not(equal? val1 val2)))
      (and-prim () (and val1 val2))
      (or-prim () (or val1 val2))
      )
    )
  )

(define operacion-prim
  (lambda (lval op term)
    (cond
      [(null? lval) term]
      [else
       (op
        (car lval)
        (operacion-prim (cdr lval) op term))
       ]
      )
    )
  )

;--------------------------------------------INTERPRETADOR--------------------------------------------
(define interpretador
  (sllgen:make-rep-loop
   "> "
   (lambda (exp) (eval-program exp))
   (sllgen:make-stream-parser
    especificacion-lexica
    especificacion-gramatical)))

;______________________________________________AMBIENTES______________________________________________

;------------------------------------------------VALOR------------------------------------------------
(define scheme-value?
  (lambda (x)
    #t
    )
  )

;---------------------------------------ESTRUCTURA DEL AMBIENTE---------------------------------------
(define-datatype ambiente ambiente?
  (ambiente-vacio)
  (ambiente-extendido
   (lids (list-of symbol?))
   (lvalue (list-of scheme-value?))
   (old-env ambiente?))
  )

;------------------------------------------AMBIENTE INICIAL-------------------------------------------
(define ambiente-inicial
  (ambiente-extendido '(x y z) '(4 2 5)
                      (ambiente-extendido '(a b c) '(4 5 6)
                                          (ambiente-vacio))))

;----------------------------------------------APPLY ENV----------------------------------------------
(define apply-env
  (lambda (env sym)
    (cases ambiente env
      (ambiente-vacio () (eopl:error "No se encuentre la variable:" sym))
      (ambiente-extendido (lid lval env-old)
                          (letrec
                              (
                               (buscar-sim
                                (lambda (lid lval sym)
                                  (cond
                                    [(null? lid) (apply-env env-old sym)]
                                    [(equal? (car lid) sym) (car lval)]
                                    [else (buscar-sim (cdr lid) (cdr lval) sym)]))
                                )
                               )
                            (buscar-sim lid lval sym))
                          )
      )
    )
  )


(interpretador)