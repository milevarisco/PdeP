% Recorridos en GBA:
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido (152, gba(norte), olivos).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

%1
puedeCombinarse(Linea1, Linea2):-
    recorrido(Linea1, Zona, Calle),
    recorrido(Linea2, Zona ,Calle),
    Linea1 \= Linea2.

%2
cruzaGeneralPaz(Linea):-
    recorrido(Linea, gba(_), _),
    recorrido(Linea, caba, _).

jurisdiccion(Linea, nacional):-
    cruzaGeneralPaz(Linea).

jurisdiccion(Linea, provincial(caba)):-
    recorrido(Linea, caba , _),
    not(cruzaGeneralPaz(Linea)).

jurisdiccion(Linea, provincial(buenosAires)):-
    recorrido(Linea, gba(_) , _),
    not(cruzaGeneralPaz).

%3


lineasPorCalle(Calle, Zona, ListaLineas):-
    findall(Linea, recorrido(Linea, Zona, Calle), ListaLineas).

cantidadLineasPorCalle(Calle, Zona, Cantidad):-
    lineasPorCalle(Calle, Zona, ListaLineas),
    length(ListaLineas, Cantidad).

calleMasTransitada(Zona, Calle):-
    recorrido(_, Zona, Calle),
    cantidadLineasPorCalle(Calle, Zona, Cantidad),
    not((cantidadLineasPorCalle(OtraCalle, Zona, OtraCantidad), Cantidad < OtraCantidad )).
    
%4
calleDeTransbordo(Calle, Zona):-
    recorrido(_, Zona, Calle),
    cantidadLineasPorCalle(Calle, Zona, Cantidad),
    Cantidad >= 3,
    forall(recorrido(Linea, Zona, Calle), jurisdiccion(nacional, Linea)).

%5a
beneficiario(pepito, personalCasasPart(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(marta, jubilado).
beneficiario(marta, personalCasasPart(caba)).
beneficiario(marta, personalCasasPart(gba(sur))).

%b
boleto(Linea, 500):-
    jurisdiccion(Linea, nacional).
boleto(Linea, 350):-
    jurisdiccion(Linea, provincial(caba)).
boleto(Linea, Valor):-
    jurisdiccion(Linea, provincial(buenosAires)),
    callesPorLinea(Linea, CantCalles),
    plus50(Linea, Plus)
    Valor is ((25 * CantCalles) + Plus).

callesPorLinea(Linea, CantCalles):-
    recorrido(Linea, _, _),
    findall(Calle, recorrido(Linea, _, Calle), ListaCalles),
    length(ListaCalles, CantCalles)

plus50(Linea, 50):-
    pasaPorDistintasZonas(Linea).

plus50(Linea, 0):-
    recorrido(Linea, _, _),
    not(pasaPorDistintasZonas(Linea)).

pasaPorDistintasZonas(Linea):-
    recorrido(Linea, gba(Zona1), _),
    recorrido(Linea, gba(Zona2), _),
    Zona1 \= Zona2.

