animal(ginger, gallina(4, 7)).
animal(babs, gallina(4, 6)).
animal(bunty, gallina(4, 6)).
animal(mac, gallina(4, 7)).
animal(turuleca, gallina(15, 6)).

animal(rocky, gallo(animalDeCirco)).
animal(fowler, gallo(piloto)).
animal(oro, gallo(arrocero)).
animal(nick, rata).
animal(fetcher, rata).

granja(tweedys, [ginger, babs, bunty, mac]).
granja(delSol, [turuleca, oro, nick, fetcher]).

puedeCederle(Gallina1, Gallina2) :-
    animal(Gallina1, gallina(_, Huevos1)),
    animal(Gallina2, gallina(_, Huevos2)),
    not(between(0, 6, Huevos1)),
    between(0, 6, Huevos2).

animalLibre(Animal) :-
    animal(Animal, _),
    forall(granja(Granja, _), not(viveEn(Animal, Granja))).

viveEn(Animal, Granja) :-
    granja(Granja, ListaGranja),
    member(Animal, ListaGranja).

% 3. Valoración de Granja y auxiliares

valoracionDeGranja(Granja, Valoracion) :-
    granja(Granja, _),
    findall(Val, (viveEn(Animal, Granja), valAnimal(Animal, Val)), ListaValores),
    sumlist(ListaValores, Valoracion).

valAnimal(Animal, Val) :-
    animal(Animal, Tipo),
    valoracion(Tipo, Val).
valoracion(rata, 0).
valoracion(gallina(P, H), Val) :-
    Val is P * H.

valoracion(gallo(P), 50) :-
    sabeVolar(P).

valoracion(gallo(P), 25) :-
    not(sabeVolar(P)).

sabeVolar(piloto).
sabeVolar(animalDeCirco).

% 4. Granja Deluxe

granjaDeluxe(Granja) :-
    granja(Granja, ListaGranja),
    libreDe(Granja),
    length(ListaGranja, CantAnimales),
    CantAnimales > 50,
    valoracionDeGranja(Granja, 1000).

libreDe(Granja):-
   forall(viveEn(Animal, Granja), not(animal(Animal, rata))).

% 5)
buenaPareja(Animal1, Animal2):-
    compartenGranja(Animal1, Animal2),
    Animal1 \= Animal2,
    pareja(Animal1, Animal2).

compartenGranja(Animal1, Animal2):-
    viveEn(Animal1, Granja),
    viveEn(Animal2, Granja).

parejaGallo(G1, G2):-
    animal(G1, gallo(Profesion1)), 
    animal(G2, gallo(Profesion2)),
    sabeVolar(Profesion1),
    not(sabeVolar(Profesion2)).

pareja(Gallina1, Gallina2):-
    puedeCederle(Gallina1, Gallina2),
    pesanIgual(Gallina1, Gallina2).

pareja(Gallina1, Gallina2):-
    puedeCederle(Gallina2, Gallina1),
    pesanIgual(Gallina1, Gallina2).



pareja(Gallo1, Gallo2):-
    parejaGallo(Gallo1, Gallo2).

pareja(Gallo1, Gallo2):-
    parejaGallo(Gallo2, Gallo1).

pareja(Rata1, Rata2):-
    animal(Rata1, rata),
    animal(Rata2, rata).

pesanIgual(G1, G2):-
    animal(G1, gallina(P, _)),
    animal(G2, gallina(P, _)).
% 6)
escapePerfecto(Granja):-
    granja(Granja, _),
    tienenHuevos(Granja),
    buenisimasParejas(Granja).

buenisimasParejas(Granja):-
    forall(viveEn(Animal1, Granja), (viveEn(Animal2, Granja), buenaPareja(Animal1, Animal2))).

tienenHuevos(Granja):-
    forall((viveEn(Animal, Granja), animal(Animal, gallina(_, Huevos))), Huevos > 5).