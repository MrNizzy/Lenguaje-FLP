# Lenguaje-FLP
Lenguaje de programación interpretado en Scheme Racket.

## Características del Lenguaje BÁSICO-I

* <b>Identificadores</b>: Son secuencias de caracteres alfanuméricos que comienzan con una letra.
* <b>Definiciones</b>: Permiten crear (o ligar) variables a valores.
* <b>Expresiones</b>: las estructuras sintácticas son una expresión y todas las expresiones producen un valor.
* <b>Primitivas booleanas</b>: <, >, <=, >=, ==, ! =, ==, and, or, not. Estas primitivas son binarias y permiten evaluar expresiones para generar un valore booleano
* <b>Primitivas aritméticas</b>: +, −, ∗, %, /, add1, sub1.
* <b>Primitivas sobre cadenas</b>: length, concat.
 *Condicionales: Son estructuras para controlar el flujo de un programa. Estos condicionales son sencillos del tipo if-else.
* <b>Locales</b>: Estos se utilizan para definir nuevas ligaduras.
* <b>Definición/invocación de procedimientos</b>: el lenguaje debe permitir la creación/invocación de procedimientos que retornan un valor al ser invocados. Estos procedimientos no son recursivos.
* <b>Asignación</b>: Los valores de las variables pueden mutar sus valores durante la ejecución de un programa.
* <b>Secuenciación</b>: El lenguaje deber permitir expresiones para la creación de bloques de instrucciones.

## BÁSICO-II

* <b>Ciclos <i>for</i></b>: el lenguaje debe permitir la definición de una estrutura de repetición tipo <i>for</i>
* <b>Ciclos <i>while</i></b>: el lenguaje debe permitir la definición de una estrutura de repetición tipo <i>while</i>
* <b>Estructuras</b>: Las estructuras de datos son datos que contienen un número no determinado dentro de tipos de datos básicos. Un buen ejemplo son las estructuras en C.

```C
// Este ejemplo ignora los tipos
struct Book {
    title;
    author;
    age;
};
strcbook = Book (
    "El ultimo guerrero",
    "Mario Castañeda",
    2003
);

// acceder a parametros
strctbook.title;

// cambiar parametros
strucbook.title = "El nuevo emperador";
```

## BÁSICO-II → EXTRAS

* Ciclos <i>for</i>
* Ciclos <i>while</i>

Estructuras de datos.

* Creación.
* Acceso a los campos.
* Modificación de los campos.

Proyecto realizado utilizando la librería [SLLGEN](https://docs.racket-lang.org/eopl/index.html) de [Dr. Racket](https://download.racket-lang.org/)
