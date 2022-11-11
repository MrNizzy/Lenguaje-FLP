#lang eopl

(define especificacion-lexica
  '(
    (espacio-blanco (whitespace) skip)
    (comentario ("%" (arbno (not #\newline))) skip)
    (identificador (letter (arbno (or letter digit "?" "$"))) symbol)
    (numero (digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)"." digit (arbno digit)) number)
    (hexadecimal ("0x" (arbno (or digit "a" "b" "c" "d" "e" "f"))) symbol)
    (octal ("0o" (arbno (or "0" "1" "2" "3" "4" "5" "6" "7"))) symbol)
    )
  )
