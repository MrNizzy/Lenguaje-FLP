# Gramática

## Especificación léxica

```BNF
<espacio-blanco>    ::= whitespace
<comentario>        ::= "//" {}* not #\newline
<identificador>     ::= letter {letter | digit | "?" | "$"}*
<texto>             ::= "\"" {letter | digit | "?" | "$" "-" "#" "." whitespace}* "\""
<numero>            ::= digit {digit}*
                    ::= "-" digit {digit}*
                    ::= digit {digit}* "." digit {digit}*
                    ::= "-" digit {digit}* "." digit {digit}*
                    ::= "#x" digit | "a" | "b" | "c" | "d" | "e" | "f"  {digit | "a" | "b" | "c" | "d" | "e" | "f" }*
                    ::= "#o" digit not "8" "9" {digit not "8" "9"}*
```

## Especificación gramatical

```BNF
<programa> ::= <expresion>

<expresion> ::= <numero>
            ::= <identificador>
            ::= "true"
            ::= "false"
            ::= "if" <expresion> ":" <expresion> "else" <expresion>
            ::= "(" <expresion> <primitiva> <expresion> ")"
            ::= "let" <identificador> "=" <expresion> {<identificador "=" <expresion>}* "in" <expresion>
            ::= "proc" "(" <identificador> {"," <identificador>}* ")" <expresion>
            ::= "[" <expresion> {"," <expresion>}* "]"
            ::= "set" <identificador> "=" <expresion>
            ::= "modify" <expresion> {";" <expresion>}* "end"
            ::= "while" <expresion> ":" <expresion>
            ::= "for" <expresion> "in" <expresion> ":" <expresion>
            ::= "struct" <identificador> "=" "{" <identificador> ":" <expresion> {"," <identificador> ":" <expresion>}* "}"
            ::= "get" <identificador> "." <identificador>
            ::= "send" <identificador> "." <identificador>

<primitiva> ::= "+" | "-" | "*" | "%" | "/"
            ::= "<" | ">" | "<=" | ">=" | "==" | "!=" | "and" | "or" | "not"

<primitiva-unaria>  ::= "add1" | "sub1"
                    ::= "length"

<primitiva-unaria-strings> ::= "concat" 
```

## Ejemplos

### Comentarios

```pyscheme
// Hola, soy un comentario
```

`// Hola, soy un comentario`

```pyscheme
// Hello, World
```

`// Hello, World`

### Numeros

```pyscheme
-3743
```

`-3743`

```pyscheme
-20.22
```

`-20.22`

### Booleanos

```pyscheme
true
```

`#t`

```pyscheme
false
```

`#f`

### Condicional

```pyscheme
if  (5 > 0) : 5 else 0
```

`5`

```pyscheme
if  (let i = 5 in (5+i) >= 9) : true else false
```

`#t`

### Expresión infija

```pyscheme
(let a = 5 in let j = 4 in ((5 + j) * a) <= 25)
```

`#f`

```pyscheme
(8%2)
```

`0`

```pyscheme
((8%2)+(20/2))
```

`10`

### Locales

```pyscheme
let a = (28%2) in (a+1)
```

`1`

```pyscheme
let a = 8 in (5 * let c = 2 in (c * c))
```

`20`

### Procedimientos

```pyscheme
let
    f = proc (y , z) (y + (z - 5 ))
    in
        let
            f = proc (z) (z * 2)
            g = proc(x,y) (x + y)
        in
            [g [f 3] [f 4]]
```

`14`

```pyscheme
let x = 5
    in
        let f = proc(y, z) (y + (z - x))
        x = 28
in [f 2 x]
```

`25`

### Asignación

```pyscheme
let m = -13.5
    in
        modify
            set m = (m+1);
            set m = (m*2);
            m
        end
```

`-25.0`

```pyscheme
let x = 100
    in
        let p = proc ( x )
            modify
                set x = (x+1) ;
                x
            end
        in
            ([p x] + [p x])
```

`202`

```pyscheme
let z = 0
    in
        let
            f = proc(x)
            z
        in
            modify
                set z = 1;
                [f 2]
            end
```

`1`

### While

```pyscheme
while let i = 0 in  (i > 0) : true
```

```pyscheme
while let i = 0 in  (i <= 9) : let j = 5 in (i+j)
```

> Infinito

### For

```pyscheme
for let i = 0 in  (i + 1) in 5 : true
```

```pyscheme
for let i = 0 in  (i + 5) in 20 : let a = 0 in (a+i)
```

### Estructuras

```pyscheme
struct persona = {
    edad: 20,
    ciudad: "Colombia",
    salario: "$2.500.000 COP"
}
```

```pyscheme
struct pyscheme = {
    version: "1.0.0",
    curso: "Fundamentos de Lenguajes de Programación",
    hagstag: "#NoMasScheme"
}
```

### Obtener atributo

```pyscheme
get pyscheme.version
```

```pyscheme
get pyscheme.hastag
```

### Modificar atributo

```pyscheme
send pyscheme.hastag = "#Cancelar"
```

```pyscheme
send strucbook.title = "El nuevo emperador"
```
