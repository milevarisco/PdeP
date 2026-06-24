padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(sven, abe).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).
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

tieneHijo(Personaje) :-
    padreDe(Personaje, _).
tieneHijo(Personaje) :-
    madreDe(Personaje, _).

% Hermanos/2: relaciona a dos personajes si comparten el mismo padre y la misma madre,
% y además no son la misma persona.
%
% ¿Cómo funciona la evaluación en Prolog?
% 1. Prolog recibe una consulta, por ejemplo: ?- hermanos(bart, lisa).
% 2. Intenta unificar (emparejar) los argumentos: Personaje1 = bart, Personaje2 = lisa.
% 3. Evalúa la primera condición: padreDe(Padre, bart). Busca en los hechos
%    y encuentra padreDe(homero, bart), asignando la variable Padre = homero.
% 4. Evalúa la segunda condición con el valor ya asignado: padreDe(homero, lisa).
%    Como esto existe en los hechos (padreDe(homero, lisa) es verdadero), continúa.
% 5. Evalúa la tercera condición: madreDe(Madre, bart). Encuentra madreDe(marge, bart),
%    asignando la variable Madre = marge.
% 6. Evalúa la cuarta condición con el valor ya asignado: madreDe(marge, lisa).
%    Como existe en los hechos, continúa.
% 7. Evalúa la última condición de diferencia: bart \= lisa.
%    Como son distintos (verdadero), toda la consulta resulta en true.
%
% Si en algún punto una condición fallara, Prolog volvería atrás (Backtracking)
% buscando otras combinaciones posibles de variables.
hermanos(Personaje1, Personaje2) :-
    padreDe(Padre, Personaje1),
    padreDe(Padre, Personaje2),
    madreDe(Madre, Personaje1),
    madreDe(Madre, Personaje2),
    Personaje1 \= Personaje2.

% compartenMadre/2: Verifica si ambos personajes tienen la misma madre.
compartenMadre(Personaje1, Personaje2) :-
    madreDe(Madre, Personaje1),
    madreDe(Madre, Personaje2),
    Personaje1 \= Personaje2.

% compartenPadre/2: Verifica si ambos personajes tienen el mismo padre.
compartenPadre(Personaje1, Personaje2) :-
    padreDe(Padre, Personaje1),
    padreDe(Padre, Personaje2),
    Personaje1 \= Personaje2.

% medioHermanos/2: relaciona a los personajes cuando estos comparten padre o madre, pero no ambos.
medioHermanos(Personaje1, Personaje2) :-
    compartenMadre(Personaje1, Personaje2),
    not(compartenPadre(Personaje1, Personaje2)),
    Personaje1 \= Personaje2.
    
medioHermanos(Personaje1, Personaje2) :-
    compartenPadre(Personaje1, Personaje2),
    not(compartenMadre(Personaje1, Personaje2)),
    Personaje1 \= Personaje2.
%medioHermanos(Quien, Otro) prolog me va a decir quienes son medio hermanos de Quien (genera a los personajes y va probando todas las convinaciones posibles)
%Quien y Otro no pueden ser la misma persona (y en caso de serlo el predicado no se cumple) 
%medioHermanos(maggie, X). me va decir los medio hermanos de maggie => X = lisa ; X = bart

%si doy vuelta los predicados (1. not y 2. comparten..) => problema de INVERSIVILIDAD del predicado ua que deja de funcionar para preguntas con variables Quien y Otro. Queremos que al not entren las VARIABLES LIGADAS que se van a encontrar en el primer predicado. con el not en primer lugar no se ligan realmente las variables ya que puede dar not(false) y lo va a hacer true.

% tioDe/2: relaciona a los personajes cuando estos son hermanos de uno de los padres/madres
tioDe(Tio, Sobrino) :-
    hijoDe(Sobrino, Padre),
    hermanos(Tio, Padre).

% hijoDe/2: Relaciona a un Hijo con su Padre o Madre.
% El punto y coma (;) actúa como un "OR" u "O" lógico en Prolog.
hijoDe(Hijo, PadreOrMadre) :- 
    padreDe(PadreOrMadre, Hijo); 
    madreDe(PadreOrMadre, Hijo).

% abueloMultiple/2: si alguien es abuelo de al menos dos nietos distintos.
abueloMultiple(Abuelo) :- 
    abueloDe(Abuelo, Nieto1),
    abueloDe(Abuelo, Nieto2),
    Nieto1 \= Nieto2.

% abueloDe/2: relaciona a un Abuelo con su Nieto
abueloDe(Abuelo, Nieto) :-
    hijoDe(Padre, Abuelo),
    hijoDe(Nieto, Padre).
    
% descendientes/2: relaciona a dos personajes cuando uno desciende del otro a traves de una csnt no predeterminada de generaciones
descendientes(Descendiente, Ancestro):-
    hijoDe(Descendiente, Ancestro).

descendientes(Descendiente, Ancestro):-
    hijoDe(Descendiente, Padre),
    descendientes(Padre, Ancestro).
%se hace una recursividad

%si pongo en la terminal descendientes(bart, A) me va a responder todos los ancestros de bart
%si pongo en la terminal descendientes(A, abe) me va a responder todos los descendientes de abe

