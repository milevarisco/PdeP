/*PARADIGMA LOGICO*/
%No hay funciones,solo hay predicados
%make. (para recargar)
%= (pasa, no pasa, como pasa)

%CLAUSULAS DEL PREDICADO materia/2

materia(ficia, 1).
materia(paradigma, 2).
materia(operativos, 2).
materia(desarrolloSW, 3).

/* Predicado    -> nombre  (todo en minuscula)
                -> aridad (numero de argumentos)
*/

/* CONSULTAS ---sobre---> BASE DE CONOCIMIENTOS ---conjunto de----> PREDICADOS  |-> PROPIEDADES de un INDIVIDUO*
        |                                                                |      |-> PROPIEDADES de un INDIVIDUO*
        |                                                                |      |    aridad = 1
        |                                                                |      |-> RELACIONES entre INDIVIDUO*
        |                                                                |           aridad > 1
        |                                                                |-> compuesto por CLAUSULAS
        |                                                                        |-> AXIOMAS (Hechos) => verdaderos
        |                                                                        |-> REGLAS => Solo se deducen de los hechos                                                               
        |-> INDIVODUALES     (Empiezan con minuscula) -> verdadero o falso
        |-> VARIABLES        (comienza con mayuscula) -> 
        |-> EXISTENCIALES    (comienza con guion bajo)-> Existe al menos un X que cumple con la condicion
    
    *INDIVIDUOS => Son constantes
        |-> SIMPLES (numeros o atomos(txt pero sin comillas))
        |-> COMPUESTOS (listas [1,2,3] o functores)
*/

%profesor/3
%profesor(Profe, Materia, Curso)
profesor(vinokur, fisica, z1004).
profesor(alf, paradigmas, k2024).
profesor(esquivel, operativos, k2022).

% esFacil (Materia)
% si esta despues de tercero
esFacil(Materia) :-
    materia(Materia, Anio),
    Anio > 3.
esFacil(ingYSociedad).

% correlativas(MateriaSegunda, MateriaPrimera).
correlativas(analisis2, analisis1).
correlativas(desarrolloSW, paradigmas).
correlativas(paradigmas, algoritmos).
correlativas(adr, desarrolloSW).

% sonCorrelativas(Materia1, Materia2).
% si se da una correlatividad directa o indirecta.
% (estudiar cómo hacer para que soporte N niveles).
sonCorrelativas(MateriaSegunda, MateriaPrimera) :-
  correlativas(MateriaSegunda, MateriaPrimera).

sonCorrelativas(Materia2, Materia1) :-
  correlativas(MateriaIntermedia, Materia1),
  correlativas(Materia2, MateriaIntermedia).


% expertoEnElTema/1: profe que da materias correlativas
expertoEnElTema(Profesor) :-
  profesor(Profesor, Materia2, _),
  profesor(Profesor, Materia1, _),
  sonCorrelativas(Materia1, Materia2).

%% masDeUnCursoDe/2:
%% algún profesor tenga más de un curso de una materia
masDeUnCursoDe(Profesor, Materia) :-
  profesor(Profesor, Materia, Curso2),
  profesor(Profesor, Materia, Curso1),
  Curso1 \= Curso2.
