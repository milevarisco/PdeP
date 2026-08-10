/* ============================================================================
 * Apunte de Clase - Paradigmas de Programación (Paradigma Lógico)
 * Ejercicio: El árbol genealógico de Los Simpson
 * ============================================================================
 * Temas repasados en este ejercicio:
 * 1. Base de conocimiento (Hechos y Reglas)
 * 2. Cuantificador Existencial implícito (Variable anónima _)
 * 3. Conjunciones (Y) y Disyunciones (O)
 * 4. Negación con not/1 e Inversibilidad
 * 5. Recursividad
 * ============================================================================
 */

% ============================================================================
% 1. BASE DE CONOCIMIENTO (Hechos)
% ============================================================================

% padreDe/2: padreDe(Padre, Hijo).
padreDe(sven, abe).
padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

% madreDe/2: madreDe(Madre, Hijo).
madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge, maggie).
madreDe(selma, ling).


% ============================================================================
% 2. REGLAS Y VARIABLE ANÓNIMA
% ============================================================================
/*
 * Concepto: Variable anónima (_)
 * Se utiliza cuando necesitamos un argumento para cumplir con la aridad de un 
 * predicado, pero no nos interesa conocer su valor ni unificarlo con otra 
 * variable en el resto de la regla. Funciona como un "alguien" o "algo".
 */

% tieneHijo/1: Nos dice si un personaje tiene un hijo o hija.
% Concepto: Disyunción (O). Se logra haciendo múltiples definiciones (cláusulas)
% para el mismo predicado. 
% "Alguien tiene un hijo si es padre de alguien (_) O si es madre de alguien (_)"
tieneHijo(Personaje):-
	padreDe(Personaje, _).

tieneHijo(Personaje):-
	madreDe(Personaje, _).


% ============================================================================
% 3. CONJUNCIONES Y AUXILIARES
% ============================================================================
/*
 * Concepto: Conjunción (Y)
 * Se logra separando las condiciones con una coma (,). Todas las condiciones 
 * deben cumplirse a la vez para que la regla sea verdadera.
 */

% hermanos/2: Relaciona a dos personajes cuando estos comparten madre Y padre.
hermanos(Personaje1, Personaje2):-
	compartenMadre(Personaje1, Personaje2),
	compartenPadre(Personaje1, Personaje2).


% Concepto: Predicados auxiliares (delegación)
% Es una excelente práctica delegar lógica para hacer el código más declarativo, 
% expresivo y evitar repetir código.

compartenMadre(Personaje1, Personaje2):-
	madreDe(Madre, Personaje1),
	madreDe(Madre, Personaje2),
	Personaje1 \= Personaje2. % Distinto: ¡Evitamos que alguien sea hermano de sí mismo!

compartenPadre(Personaje1, Personaje2):-
	padreDe(Padre, Personaje1),
	padreDe(Padre, Personaje2),
	Personaje1 \= Personaje2. 


% ============================================================================
% 4. NEGACIÓN E INVERSIBILIDAD
% ============================================================================
/*
 * Recordatorio sobre not/1:
 * El not/1 exige que las variables que utilicemos dentro de él ya estén 
 * "ligadas" (tengan un valor) previamente. De lo contrario, tendremos problemas
 * de inversibilidad (parcialidad).
 */

% medioHermanos/2: Relaciona a dos personajes cuando estos comparten madre o padre,
% pero NO ambos.
% Fíjate cómo primero ligamos las variables con compartenMadre o compartenPadre
% antes de pasarlas por el not/1.
medioHermanos(Personaje1, Personaje2):-
	compartenMadre(Personaje1, Personaje2),
	not(compartenPadre(Personaje1, Personaje2)).

medioHermanos(Personaje1, Personaje2):-
	compartenPadre(Personaje1, Personaje2),
	not(compartenMadre(Personaje1, Personaje2)).


% ============================================================================
% 5. MÁS REGLAS CON CONJUNCIONES Y DISYUNCIONES
% ============================================================================

% hijoDe/2: Inversa de padreDe y madreDe.
% "Alguien es hijo de un Padre si ese Padre es su padreDe, O..."
hijoDe(Hijo, Padre):-
	padreDe(Padre, Hijo).

hijoDe(Hijo, Madre):-
	madreDe(Madre, Hijo).

% tioDe/2: Relaciona a un personaje con su sobrino. 
tioDe(Tio, Sobrino):-
	hijoDe(Sobrino, Padre),
	hermanos(Padre, Tio).

% abueloMultiple/1: Nos dice si alguien es abuelo de al menos dos nietos distintos.
abueloMultiple(Abuelo):-
	abueloDe(Abuelo, Nieto1),
	abueloDe(Abuelo, Nieto2),
	Nieto1 \= Nieto2.

% abueloDe/2: Relaciona a un abuelo con su nieto.
abueloDe(Abuelo, Nieto):-
	hijoDe(Padre, Abuelo),
	hijoDe(Nieto, Padre).


% ============================================================================
% 6. RECURSIVIDAD
% ============================================================================
/*
 * Concepto: Recursividad
 * Se da cuando un predicado se llama a sí mismo en su definición.
 * Todo predicado recursivo necesita de un CASO BASE (condición de corte) y un 
 * CASO RECURSIVO para no iterar infinitamente.
 */

% descendiente/2: Relaciona a dos personajes, en donde uno desciende del otro 
% a través de una cantidad no predeterminada de generaciones. 
% Por ejemplo, bart es descendiente de homero, de abe y también de sven simpson.

% CASO BASE: Si es hijo directo, ya es descendiente. (Condición de corte)
descendiente(Descendiente, Ancestro):-
	hijoDe(Descendiente, Ancestro).

% CASO RECURSIVO: Si es hijo de un "Padre", y a su vez ese "Padre" es 
% descendiente del ancestro que buscamos, entonces también somos descendientes.
descendiente(Descendiente, Ancestro):-
	hijoDe(Descendiente, Padre),
	descendiente(Padre, Ancestro).