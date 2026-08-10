/* ============================================================================
 * Apunte de Clase 2 - Paradigmas de Programación (Paradigma Lógico)
 * ============================================================================
 * ¡Hola estudiantes! Hoy tuvimos la segunda clase de Lógico.
 * Temas vistos:
 * 1. Repaso de hechos y reglas (Pensando en el árbol genealógico de los Simpson)
 * 2. Negación con not/1 (Y por qué (no) le cantamos el feliz cumple a Messi)
 * 3. Inversibilidad (Total y Parcial)
 * 4. Aritmética en Prolog con is/2
 * ============================================================================
 */

% ============================================================================
% 1. BASE DE CONOCIMIENTO (Hechos)
% ============================================================================

% materia/2
% materia(NombreMateria, Anio).
materia(paradigmas, 2).
materia(fisica, 1).
materia(operativos, 2).
materia(desarrolloSW, 3).
materia(legislacion, 4).
materia(analisis2, 2).
materia(analisis1, 1).

% profesor/3
% profesor(Profe, Materia, Curso).
profesor(vinokur, fisica, z1004).
profesor(alf, paradigmas, k2024).
profesor(lucas, paradigmas, k2014).
profesor(esquivel, operativos, k2006).
profesor(alf, desarrolloSW, k2022).
profesor(fede, desarrolloSW, k3023).
profesor(fede, desarrolloSW, k3024).
profesor(corsini, legislacion, k4055).

% correlativas/2
% correlativas(MateriaSegunda, MateriaPrimera).
correlativas(analisis2, analisis1).
correlativas(desarrolloSW, paradigmas).
correlativas(paradigmas, algoritmos).
correlativas(adr, desarrolloSW).

% cursada/4
% cursada(Alumno, Curso, NotaPrimerParcial, NotaSegundoParcial)
cursada(fede, k2103, 6, 6).
cursada(vicky, k1051, 8, 10).


% ============================================================================
% 2. REGLAS BÁSICAS
% ============================================================================

% esFacil/1
% Una materia es fácil si está después de 3ro, o si es ingeniería y sociedad,
% o si la da fede.
esFacil(Materia) :-
	materia(Materia, Anio),
	Anio > 3.

esFacil(ingenieriaYSociedad).

esFacil(Materia) :-
	profesor(fede, Materia, _).

% sonCorrelativas/2
% Se cumple si se da una correlatividad directa o indirecta.
% (Queda como ejercicio estudiar cómo hacer para que soporte N niveles)
sonCorrelativas(MateriaSegunda, MateriaPrimera) :-
	correlativas(MateriaSegunda, MateriaPrimera).

sonCorrelativas(Materia2, Materia1) :-
	correlativas(MateriaIntermedia, Materia1),
	correlativas(Materia2, MateriaIntermedia).


% ============================================================================
% 3. INVERSIBILIDAD DE LOS PREDICADOS
% ============================================================================
/*
 * Concepto: Inversibilidad
 * Se refiere a la capacidad de un predicado de responder a consultas con 
 * variables (incógnitas) para sus parámetros.
 * 
 * - Inversibilidad Total: Podemos hacer consultas con variables para TODOS 
 *   sus parámetros.
 * - Inversibilidad Parcial: Alguno de sus parámetros no puede ser consultado
 *   con una variable (requiere un valor concreto al momento de evaluarse).
 *
 * ¡Regla de oro! Por defecto, todos los predicados que definimos son 
 * inversibles, a menos que usen internamente algún otro predicado con 
 * problemas de inversibilidad (como not/1 o is/2, que veremos abajo).
 */

% expertoEnElTema/1
% Profe que da materias correlativas.
% Es totalmente inversible porque todos los predicados que usa lo son.
expertoEnElTema(Profesor) :-
	profesor(Profesor, Materia2, _),
	profesor(Profesor, Materia1, _),
	sonCorrelativas(Materia1, Materia2).

% masDeUnCursoDe/2
% Se cumple si algún profesor tiene más de un curso de una materia.
masDeUnCursoDe(Profesor, Materia) :-
	profesor(Profesor, Materia, Curso2),
	profesor(Profesor, Materia, Curso1),
	Curso1 \= Curso2.


% ============================================================================
% 4. NEGACIÓN CON not/1
% ============================================================================
/*
 * Concepto: Negación (not/1)
 * Permite verificar que un predicado NO se cumpla en nuestra base.
 * 
 * ¡Cuidado con la inversibilidad!
 * El not/1 NO es inversible para su único parámetro. Si le pasamos variables
 * sueltas, no podrá generar respuestas. Es por esto que SIEMPRE debemos 
 * "ligar" (generar, darle valor) a las variables ANTES de que entren al not/1.
 * Si no sabemos a quién le cantamos el feliz cumple, no podemos saber a quién 
 * NO se lo cantamos (como el ejemplo de Messi).
 */

% daUnSoloCurso/1
% Queremos saber qué profesores dan un solo curso para cada materia.
% Solución: Ligamos 'Profesor' en la primera línea para que el not/1 funcione.
daUnSoloCurso(Profesor) :-
	profesor(Profesor, _, _),
	not(masDeUnCursoDe(Profesor, _)).

% independientes/2
% Relaciona dos materias que no son correlativas.
independientes(UnaMateria, OtraMateria) :-
	materia(UnaMateria, _),
	materia(OtraMateria, _),
	not(sonCorrelativas(UnaMateria, OtraMateria)),
	UnaMateria \= OtraMateria.

% jodido/1
% Se cumple para un profesor que da una materia que no es fácil y
% no es experto en el tema.
jodido(Profesor) :-
	profesor(Profesor, Materia, _),
	not((esFacil(Materia), expertoEnElTema(Profesor))).


% ============================================================================
% 5. ARITMÉTICA EN PROLOG CON is/2
% ============================================================================
/*
 * Concepto: Aritmética (is/2)
 * Prolog NO es un motor de ecuaciones. No sabe "despejar" una X.
 * Para realizar cuentas matemáticas y obtener el resultado usamos is/2.
 * 
 * Inversibilidad del is/2:
 * Tiene inversibilidad PARCIAL. Es inversible para el primer parámetro 
 * (el resultado), pero NO para el segundo parámetro (la cuenta en sí). 
 * Todos los valores a la derecha del "is" deben estar ligados.
 */

% promedio/3
promedio(Alumno, Cursada, Promedio) :-
	cursada(Alumno, Cursada, Nota1, Nota2),
	Total is Nota1 + Nota2,
	Promedio is Total / 2.

% Nota sobre asignación:
% No se usa el 'is' para asignación directa, solo para cuentas.
% Por ejemplo, en lugar de hacer esto:
% numeroFavorito(ale, Numero) :- Numero is 42.
% Lo hacemos directamente por pattern matching en los hechos:
numeroFavorito(ale, 42).