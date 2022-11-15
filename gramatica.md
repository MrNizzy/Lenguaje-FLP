# Gramática

## Especificación léxica

```BNF
<espacio-blanco>    ::= whitespace
<comentario>        ::= "#" {}* not #\newline
<identificador>     ::= letter {letter | digit | "?" | "$"}*
<numero>            ::= digit {digit}*
                    ::= "-" digit {digit}*
                    ::= digit {digit}* "." digit {digit}*
                    ::= "-" digit {digit}* "." digit {digit}*
                    ::= "0x" digit | "a" | "b" | "c" | "d" | "e" | "f"  {digit | "a" | "b" | "c" | "d" | "e" | "f" }*
                    ::= "0o" digit not "8" "9" {digit not "8" "9"}*
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
            ::= "while" <expresion> ":" <expresion>
            ::= "for" <expresion> "in" <expresion> ":" <expresion>

<primitiva> ::= "+" | "-" | "*" | "%" | "/" | "add1" | "sub1"
            ::= "<" | ">" | "<=" | ">=" | "==" | "!=" | "and" | "or" | "not"
            ::= "length" | "concat"
```

## Ejemplos

### Comentarios

```pyscheme
# Hola, soy un comentario
```

```pyscheme
# Hello, World
```

### Numeros

```pyscheme
-3743
```

```pyscheme
-20.22
```

### Booleanos

```pyscheme
true
```

```pyscheme
false
```

### Condicional

```pyscheme
if math (5 > 0) : 5 else 0
```

```pyscheme
if math (let i = 5 in math(5+i) >= 9) : true else false
```

### Expresión infija

```pyscheme
math (let a = 5 in let j = 4 in math(5 + j * a) <= 25)
```

```pyscheme
math(8%2)
```

### Locales

```pyscheme
let a = math(28%2) in math(a+1)
```

```pyscheme
let a = 8 in math(5 * let c = 2 in math(c * c))
```

### Procedimientos

```pyscheme
let
    f = proc (y , z) math(y + math(z - 5 ))
    in
        (f 2 2 8)
        let
            f = proc (z) math(z * 2)
            g = proc(x,y) math(x + y)
        in
            (g (f 3) (f 4))
```

```pyscheme
let x = 5
    in
        let f = proc(y, z) math(y + math(z - x))
        x = 28
in (f 2 x)
```

### Asignación

```pyscheme
let m = 0
    in
        modify
            set m = math(m+1);
            set m = math(m*2);
            m
        end

let x = 100
    in
        let p = proc ( x )
            modify
                set x = math(x+1) ;
                x
            end
        in
            math((px) + (p x))
```

```pyscheme
let z = 0
    in
        let
            f = proc(x)
            z
        in
            modify
                set z = 1;
                (f 2)
            end
```

### While

```pyscheme
while let i = 0 in math (i > 0) : true
```

### For

```pyscheme
for let i = 0 in math (i + 1) in 5 : true
```
