# Gramatica

## Especificación léxica

```BNF
<espacio-blanco>    ::= whitespace
<comentario>        ::= "#" {}* not #\newline
<identificador>     ::= letter {letter | digit | "?" | "$"}*
<numero>            ::= digit {digit}*
                    ::= "-" digit {digit}*
                    ::= digit {digit}* "." digit {digit}*
                    ::= "-" digit {digit}* "." digit {digit}*
                    ::= "0x" {digit | "a" | "b" | "c" | "d" | "e" | "f" }*
                    ::= "0o" {digit not "8" "9"}*
```

## Especificación gramatical

```BNF
<programa> ::= <expresion>

<expresion> ::= <numero>
            ::= <identificador>
            ::= "true"
            ::= "false"
            ::= "if" <expresion> ":" <expresion> "else" <expresion>
            ::= "math" "(" <expresion> {<primitiva> <expresion>}* ")"
            ::= "let" <identificador> "=" <expresion> {<identificador "=" <expresion>}* "in" <expresion>
            ::= "proc" "(" <identificador> {"," <identificador>}* ")" <expresion>
            ::= "(" <expresion> {"," <expresion>}* ")"
            ::= "set" <identificador> "=" <expresion>
            ::= "begin" <expresion> {";" <expresion>}* "end"

<primitiva> ::= "+" | "-" | "*" | "%" | "/" | "add1" | "sub1"
            ::= "<" | ">" | "<=" | ">=" | "==" | "!=" | "and" | "or" | "not"
            ::= "length" | "concat"
```
