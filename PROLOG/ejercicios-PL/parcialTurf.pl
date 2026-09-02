%1
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

caballo(botafogo).
caballo(oldMan).
caballo(matBoy).
caballo(yatasto).
caballo(energica)

leGusta(botafogo, baratucci).
leGusta(botafogo, Jockey):-
    jockey(Jockey, _, Peso),
    Peso < 52.
leGusta(oldMan, Jockey):-
    jockey(Jockey, _, _),
    atom_length(Jockey, Nombre),
    Nombre > 7.
leGusta(energica, Jockey):-
    jockey(Jockey, _, _),
    not(leGusta(botafogo, Jockey)).
leGusta(matBoy, Jockey):-
    jockey(Jockey, Altura, _),
    Altura > 170.

stud(valdivieso, elTute).
stud(falero, elTute).
stud(lezcano, lasHormigas).
stud(baratucci, elCharabon).
stud(leguisamo, elCharabon).

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(oldMan, granPremioRepublica).
gano(oldMan, campeonatoPalermoDeOro).
gano(matBoy, granPremioCriadores).

%2
prefiereMasDeUno(Caballo):-
    leGusta(Caballo, Jockey1),
    leGusta(Caballo, Jockey2),
    Jockey1 \= Jockey2.

%3
noPrefiereAlStud(Caballo, Stud):-
    stud(_, Stud),
    caballo(Caballo),
    not((stud(Jockey, Stud), leGusta(Caballo, Jockey))).
    %forall(stud(Jockey, Stud), not(leGusta(Caballo, Jockey))).

%4
piolin(Jockey):-
    jockey(Jockey, _, _),
    forall(ganoPremioImportante(Caballo), leGusta(Caballo, Jockey)).
    % not((ganoPremioImportante(Caballo), not(leGusta(Caballo, Jockey)))).

ganoPremioImportante(Caballo):-
    caballo(Caballo)
    gano(Caballo, Premio), 
    premioImportante(Premio).

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

%5
ganoApuesta(ganador(Caballo), [Caballo | _]).
ganoApuesta(segundo(Caballo), [Caballo | _]).
ganoApuesta(segundo(Caballo), [_, Caballo | _]).
ganoApuesta(exacta(Caballo1, Caballo2), [Caballo1, Caballo2 | _]).
ganoApuesta(imperfecta(Caballo1, Caballo2), [Caballo1, Caballo2 | _]).
ganoApuesta(imperfecta(Caballo1, Caballo2), [Caballo2, Caballo1 | _]).

%6


colorCrin(botafogo, tordo).
colorCrin(oldMan, alazan).
colorCrin(energica, ratonero).
colorCrin(matBoy, palomino).
colorCrin(yatasto, pinto).

crin(pinto, [blanco, marron]).
crin(palomino, [marron, blanco]).
crin(ratonero, [gris, negro]).
crin(alazan, [marron]).
crin(tordo, [negro]).

color(Color):-
    crin(_, Colores),
    member(Color, Colores).

caballosAComprar(Color, PosiblesCompras):-
    color(Color),
    findall(Caballo, podriaComprar(Color, Caballo), ListaCaballos),
    subconjunto(ListaCaballos, PosiblesCompras),
    length(PosiblesCompras, Cant),
    Cant >= 1.

subconjunto([], []).
subconjunto([X | Resto], [X | Subresto]):-
    subconjunto(Resto, Subresto).
subconjunto([_ | Resto], Subresto):-
    subconjunto(Resto, Subresto).

podriaComprar(Color, Caballo):-
    caballo(Caballo),
    colorCrin(Caballo, Crin),
    crin(Crin, Basicos),
    member(Color, Basicos).



