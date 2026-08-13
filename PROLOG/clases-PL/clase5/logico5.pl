% INDIVIDUOS COMPUESTOS 

%==========================================================================
% LISTAS
%==========================================================================
% En Prolog, las listas son colecciones ordenadas de elementos.
% Se representan entre corchetes y se separan por comas.
%
% Estructuras Básicas:
% []             -> Lista vacía.
% [X]            -> Lista con un solo elemento (X).
% [X, Y]         -> Lista con exactamente dos elementos (X e Y).
% [Cabeza | Cola]-> Sintaxis del "Cons" (o constructor de listas / pipe |).
%                   * Cabeza (Head): Es el PRIMER elemento de la lista (un individuo, átomo, número, etc.).
%                   * Cola (Tail): Es una LISTA que contiene el RESTO de los elementos (siempre es una lista, incluso si está vacía).
%
% Ejemplos de unificación (cómo empareja Prolog):
% 1) [1, 2, 3] = [Cabeza | Cola]  --> Cabeza = 1, Cola = [2, 3]
% 2) [1] = [Cabeza | Cola]        --> Cabeza = 1, Cola = []
% 3) [] = [Cabeza | Cola]         --> Falla (la lista vacía no tiene cabeza ni cola).
% 4) [1, 2, 3] = [X, Y | Xs]      --> X = 1, Y = 2, Xs = [3] (Xs es la cola/resto de la lista).
%
% Predicados Comunes de Listas (incorporados en Prolog):
% ====================================================
% 1. member/2 (Pertenencia y Generación):
%    - Relaciona un elemento con una lista si el elemento pertenece a ella.
%    - ¡Funciona como GENERADOR si la variable del elemento está libre!
%    - Ej: member(x, [a, b, x, y]) -> true.
%    - Ej: member(X, [1, 2, 3]) -> Genera X = 1; X = 2; X = 3.
%
% 2. length/2 (Longitud):
%    - Relaciona una lista con su cantidad de elementos.
%    - Ej: length([a, b, c], N) -> N = 3.
%
% 3. sum_list/2 (Suma):
%    - Suma todos los elementos numéricos de una lista.
%    - Ej: sum_list([10, 20, 5], Total) -> Total = 35.
%
% 4. append/3 (Concatenación y División):
%    - Relaciona tres listas: append(Lista1, Lista2, ListaResultado).
%    - Sirve tanto para unir: append([1, 2], [3], X) -> X = [1, 2, 3].
%    - Como para dividir/desarmar: append(Izquierda, Derecha, [1, 2, 3]) -> Genera todas las particiones posibles.
%
% Recursividad con Listas:
% Cuando definimos predicados recursivos propios sobre listas, solemos seguir esta estructura:
% 1. Caso Base: Define qué pasa cuando la lista está vacía (`[]`) o tiene un solo elemento (`[_]`).
% 2. Caso Recursivo: Trabaja con la `Cabeza` y hace la llamada recursiva pasándole la `Cola`.
%
% Ejemplo: contarElementos/2 (Equivalente manual de length/2)
% contarElementos([], 0).  % Caso base: la lista vacía tiene 0 elementos.
% contarElementos([_ | Cola], Cantidad) :-
%   contarElementos(Cola, CantidadCola),
%   Cantidad is CantidadCola + 1.  % Caso recursivo: sumamos 1 por cada cabeza que sacamos.

%==========================================================================
% FUNCTORES
%==========================================================================
% Un functor es un INDIVIDUO COMPUESTO. Sirve para agrupar un conjunto de datos
% relacionados bajo una misma etiqueta/nombre. Son de aridad como los predicados.
%
% Sintaxis:
%   nombreDelFunctor(Dato1, Dato2, ..., DatoN)
%
% DIFERENCIA CRUCIAL ENTRE PREDICADO Y FUNCTOR:
% ---------------------------------------------
% - PREDICADO: Es una relación o regla que se puede consultar en la terminal.
%   Prolog intentará resolverlo y devolverá True, False o asignará variables.
%   Ej: materia(paradigma, 2).
%
% - FUNCTOR: Es puramente DATO estructurado. No se puede consultar directamente en la
%   terminal (tirará error de "Procedure not found"). Solo existe como argumento
%   dentro de un predicado.
%   Ej: cursada(fede, k2103, notas(6, 8)). -> Aquí "notas(6, 8)" es un functor.
%
% POLIMORFISMO CON FUNCTORES (Caso de uso principal):
% ---------------------------------------------------
% Permiten que un mismo predicado se comporte de formas distintas dependiendo del
% "tipo" de individuo compuesto que reciba, haciendo Pattern Matching.
%
% Ejemplo práctico: Calcular el área de distintas figuras geométricas.
%
% Representamos las figuras como functores:
% - circulo(Radio)
% - rectangulo(Base, Altura)
% - cuadrado(Lado)
%
% Definimos el predicado area/2 de forma polimórfica:
%
% area(circulo(Radio), Area) :-
%   Area is 3.14159 * Radio * Radio.
%
% area(rectangulo(Base, Altura), Area) :-
%   Area is Base * Altura.
%
% area(cuadrado(Lado), Area) :-
%   Area is Lado * Lado.
%
% Al consultar `area(circulo(5), A).`, Prolog unifica la estructura de forma directa y
% ejecuta la regla correspondiente. Si agregamos una nueva figura (ej. triangulo),
% simplemente agregamos una cláusula más para `area/2` sin romper las anteriores.

% Dentro de los functores podemos guardar listas y otros functores, y dentro de las listas podemos guardar functores y otras listas.

% Ejemplo: 
% persona(nombre(juan, perez), edad(25), idiomas([es, en, fr])). 
% persona(nombre(ana, martinez), edad(30), idiomas([es, pt])). 

%==========================================================================
% POLIMORFISMO EN PREDICADOS
%==========================================================================
% En Prolog, el polimorfismo consiste en definir un mismo predicado con múltiples
% cláusulas independientes que hacen Pattern Matching sobre distintos tipos de
% estructuras (generalmente functores).
%
% Esto nos permite tratar a diferentes individuos de forma genérica, sin tener que
% preguntar con un "if" de qué tipo son. Quien consuma el predicado sólo llama a una
% regla y Prolog se encarga de derivar la ejecución a la cláusula adecuada.
%
% Ejemplo práctico: "Personas y sus trabajos"
% Modelamos a las personas y sus ocupaciones usando los siguientes functores:
% - desarrollador(LenguajeFavorito, ExperienciaAnios)
% - docente(Materia, ListaDeCursos)
% - estudiante(Universidad)
%
% Hechos de la base de conocimientos:
% trabajaDe(juan, desarrollador(prolog, 6)).
% trabajaDe(ana, docente(paradigmas, [k2024, k2022])).
% trabajaDe(fede, estudiante(utn)).
% trabajaDe(vicky, desarrollador(javascript, 2)).
%
% Queremos saber quién es "groso". Pero la definición de ser groso depende de su ocupación:
% - Un desarrollador es groso si tiene más de 5 años de experiencia.
% - Un docente es groso si da más de un curso.
% - Un estudiante es groso por el simple hecho de estudiar (siempre).
%
% Definimos el predicado principal:
%
% groso(Persona) :-
%   trabajaDe(Persona, Ocupacion),  % GENERADOR para Persona y Ocupacion
%   esGroso(Ocupacion).            % Predicado polimórfico
%
% Cláusulas polimórficas de esGroso/1:
%
% esGroso(desarrollador(_, Experiencia)) :-
%   Experiencia > 5.
%
% esGroso(docente(_, Cursos)) :-
%   length(Cursos, Cantidad),
%   Cantidad > 1.
%
% esGroso(estudiante(_)).
%
% Al consultar `groso(Persona).`, Prolog unificará la ocupación de cada persona
% y resolverá de forma transparente con la cláusula que coincida con el functor.
