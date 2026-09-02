%1
departamento(kyle, ventas).
departamento(trisha, ventas).
departamento(joshua, ventas).
departamento(ian, logistica).
departamento(sherri, logistica).

registro(kyle, asalariado(6), 50).
registro(sherri, asalariado(7), 60).
registro(gus, asalariado(8), 60).
registro(ian, jefe([kyle, rob, ginger]), 40).
registro(trisha, jefe([ian, gus]), 90).
registro(joshua, independiente(arquitecto), 55).

%2
paganini(Depto):-
    departamento(_, Depto),
    forall(departamento(Persona, Depto), ganaBien(Persona)).

ganaBien(Persona):-
    registro(Persona, Puesto, Sueldo),
    sueldo(Puesto, Sueldo).

sueldo(asalariado(Horas), Sueldo):-
    sueldoPromedio(Horas, Promedio),
    Sueldo > Promedio.

sueldo(jefe(Empleados), Sueldo):-
    length(Empleados, Cant),
    Sueldo > 20 * Cant.

sueldo(independiente(arquitecto), _).
sueldo(independiente(_), Sueldo):-
    Sueldo > 70.

sueldoPromedio(6, 45).
sueldoPromedio(7, 60).
sueldoPromedio(8, 80).

%3
leGusta(kyle, ventas).
leGusta(kyle, logistica).
leGusta(trisha, ventas).
leGusta(joshua, ventas).
leGusta(sherri, contabilidad).
leGusta(sherri, facturacion).
leGusta(sherri, cobranzas).

estaEnProblemas(Depto):-
    departamento(_, Depto),
    not((departamento(P, Depto), leGusta(P, Depto))).
    %no existe ningun empleado que trabaja en el departamento que le guste el departamento

    %forall(departamento(Persona, Depto), not(leGusta(Persona, Depto))).
    %esto se me ocurrio a mi, pero es mejor directo el not. en mi logica: "para toda persona que trabaje en el departamento entonces no le gusta el departamento"

%4
reorganizar(Presupuesto, Equipo, Sobrante):-
    findall(Persona, departamento(Persona, _), ListaTrabajadores),
    subconjunto(ListaTrabajadores, Equipo),
    length(Equipo, Cant),
    Cant >= 2,
    sueldoTotal(Equipo, Total),
    Total =< Presupuesto,
    Sobrante is Presupuesto - Total.


subconjunto([], []).
subconjunto([X | Resto], [X | Subresto]):-
    subconjunto(Resto, Subresto).
subconjunto([_| Resto], Subresto):-
    subconjunto(Resto, Subresto).
%subconjunto ver la explicacion en el gem: 3 casos, caso base, caso primera persona entra al equipo, caso primera persona NO entra al equipo

sueldoTotal(Equipo, Total):-
    findall(Sueldo, (member(Persona, Equipo), registro(Persona,_, Sueldo)), ListaSueldos),
    sumlist(ListaSueldos, Total).