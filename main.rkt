#lang eopl

;****************************************ESPECIFICACION LEXICA****************************************
(define especificacion-lexica
  '(
    (espacio-blanco (whitespace) skip)
    (comentario ("#" (arbno (not #\newline))) skip)
    (identificador (letter (arbno (or letter digit "?" "$"))) symbol)
    (numero (digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)"." digit (arbno digit)) number)
    (hexadecimal ("0x" (arbno (or digit "a" "b" "c" "d" "e" "f"))) symbol)
    (octal ("0o" (arbno (or "0" "1" "2" "3" "4" "5" "6" "7"))) symbol)
    )
  )

;**************************************ESPECIFICACION GRAMATICAL**************************************
(define especificacion-gramatical
  '(
    ;-------------------------------------------EXPRESIONES-------------------------------------------
    (programa (expresion) a-program)
    (expresion (numero) num-exp)
    (expresion (identificador) var-exp)

    ;......................................EXPRESIONES BOOLEANAS......................................
    (expresion ("true") true-exp)
    (expresion ("false") false-exp)

    ;..........................................CONDICIONALES..........................................
    (expresion ("if" expresion ":" expresion "else" expresion) if-exp)

    ;........................................EXPRESION INFIJA.........................................
    (expresion ("math" "(" expresion (arbno primitiva expresion) ")") prim-exp)

    ;.......................................EXPRESIONES LOCALES.......................................
    (expresion ("let" (arbno identificador "=" expresion) "in" expresion) let-exp)

    ;.........................................PROCEDIMIENTOS..........................................
    (expresion ("proc" "(" (separated-list identificador ",") ")" expresion) proc-exp)
    (expresion ("(" expresion (arbno expresion) ")") app-exp)

    ;...........................................ASIGNACION............................................
    (expresion ("begin" expresion (arbno ";" expresion) "end") begin-exp)
    (expresion ("set" identificador "=" expresion) set-exp)

    ;--------------------------------------------PRIMITIVAS-------------------------------------------
    
    ;.....................................PRIMITIVAS ARITMETICAS......................................
    (primitiva ("+") sum-prim)
    (primitiva ("-") minus-prim)
    (primitiva ("*") mult-prim)
    (primitiva ("%") mod-prim)
    (primitiva ("/") div-prim)
    (primitiva ("add1") add-prim)
    (primitiva ("sub1") sub-prim)
    ;......................................PRIMITIVAS BOOLEANAS.......................................
    (primitiva ("<") menor-prim)
    (primitiva (">") mayor-prim)
    (primitiva ("<=") menorigual-prim)
    (primitiva (">=") mayorigual-prim)
    (primitiva ("==") igual-prim)
    (primitiva ("!=") diferente-prim)
    (primitiva ("and") and-prim)
    (primitiva ("or") or-prim)
    (primitiva ("not") not-prim)
    ;......................................PRIMITIVAS DE CADENAS......................................
    (primitiva ("length") length-prim)
    (primitiva ("concat") concat-prim)
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
      (a-program (exp) exp))))

;--------------------------------------------INTERPRETADOR--------------------------------------------
(define interpretador
  (sllgen:make-rep-loop
   "> "
   (lambda (exp) (eval-program exp))
   (sllgen:make-stream-parser
    especificacion-lexica
    especificacion-gramatical)))

(interpretador)
