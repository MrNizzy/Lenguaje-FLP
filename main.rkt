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
    (expresion ("(" expresion (arbno primitiva expresion) ")") prim-exp)

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
    (expresion (primitiva-unariaStrings "(" expresion (arbno "+" expresion) ")") unariaStrings-exp)

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
    (primitiva ("not") not-prim)
    ;.......................................PRIMITIVAS UNARIAS........................................
    (primitiva-unaria ("add1") add-prim)
    (primitiva-unaria ("sub1") sub-prim)
    ;......................................PRIMITIVAS DE CADENAS......................................
    (primitiva-unaria ("length") length-prim)
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