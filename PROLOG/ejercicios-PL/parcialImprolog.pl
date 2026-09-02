integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

%1
tienenBuenaBase(Grupo):-
    integrante(Grupo, Persona1, Instrumento1),
    integrante(Grupo, Persona2, Instrumento2),
    instrumento(Instrumento1, ritmico),
    instrumento(Instrumento2, armonico),
    Persona1 \= Persona2.

%2
seDestaca(Grupo, Persona):-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    not((
        integrante(Grupo, OtraPersona, OtroInstrumento),
        Persona \= OtraPersona,
        nivelQueTiene(OtraPersona, OtroInstrumento, OtroNivel),
        Nivel < 2 + OtroNivel
    )).

%3
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

%4
hayCupo(Grupo, Instrumento):-
    instrumento(Instrumento, melodico(viento)),
    grupo(Grupo, bigBand).

hayCupo(Grupo, Instrumento):-
    grupo(Grupo, TipoGrupo),
    sirve(TipoGrupo, Instrumento),
    not(integrante(Grupo, _, Instrumento)).

sirve(formacion(InstrumentosNecesitados), Instrumento):-
    member(Instrumento, InstrumentosNecesitados).

sirve(bigBand, piano).
sirve(bigBand, bajo).
sirve(bigBand, bateria).

%5
puedeIncorporarse(Persona, Grupo, Instrumento):-
    nivelQueTiene(Persona, Instrumento, Nivel),
    not(integrante(Grupo, Persona, _)),
    hayCupo(Grupo, Instrumento),
    grupo(Grupo, TipoGrupo),
    nivelMin(TipoGrupo, Min),
    Nivel >= Min.


nivelMin(bigBand, 1).
nivelMin(formacion(InstrumentosNecesitados), Min):-
    length(InstrumentosNecesitados, Cant)
    Min is 7 - Cant.

%6
seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona, _, _),
    not(integrante(_, Persona, _)), 
    not(puedeIncorporarse(Persona, _, _)).

%7
puedeTocar(Grupo):-
    grupo(Grupo, TipoGrupo),
    cubrenNecesidades(Grupo, TipoGrupo).

cubrenNecesidades(Grupo, bigBand):-
    tienenBuenaBase(Grupo),
    findall(Persona, (integrante(Grupo, Persona, Instrumento), instrumento(Instrumento, melodico(viento))), TocanInstrumentoVientoRepetidos),
    list_to_set(TocanInstrumentoVientoRepetidos, TocanInstrumentoViento),
    length(TocanInstrumentoViento, Cant),
    Cant >= 5.

cubrenNecesidades(Grupo, formacion(InstrumentosNecesitados)):-
    forall((member(Instrumento, InstrumentosNecesitados)), integrante(Grupo, _, Instrumento)).



%8
grupo(estudio1, ensambles(3))

cubrenNecesidades(Grupo, ensables(_)):-
    tienenBuenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).
    
sirve(ensables(_), Instrumento):-
    instrumento(Instrumento, _).
    
nivelMin(ensables(Minimo), Minimo).