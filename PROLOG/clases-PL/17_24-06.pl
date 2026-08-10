/*PARADIGMA LOGICO*/
%No hay funciones,solo hay predicados
%make. (para recargar)
%= (pasa, no pasa, como pasa)

%CLAUSULAS DEL PREDICADO materia/2

materia(ficia, 1).
materia(paradigma, 2).
materia(operativos, 2).
materia(desarrolloSW, 3).
materia(analisis1, 1).
materia(analisis2, 2).

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

%queremos saber que profesores dan un solo curso para c/materia
% queremos saber qué profesores dan un solo curso para cada materia.
%
% Explicación de la variable anónima '_' dentro del 'not':
% - El '_' representa una variable cuyo valor o nombre no nos interesa.
% - Dentro de un 'not', se interpreta de manera existencial: "no existe ninguna
%   materia '_' para la cual el Profesor dé más de un curso".
%
% Explicación de la inversibilidad:
% - Si no ponemos 'profesor(Profesor, _, _)' al principio, la variable Profesor
%   entraría libre al 'not'. Prolog intentaría buscar si algún profesor da más
%   de un curso de alguna materia, y al encontrar a uno, el 'not' fallaría
%   de inmediato, respondiendo 'false' en lugar de generar a los profesores correctos.
% - Por eso, usamos 'profesor(Profesor, _, _)' como GENERADOR.
daUnSoloCurso(Profesor):-
  profesor(Profesor, _, _),
  not(masDeUnCursoDe(Profesor, _)).

%independiente/2: relaciona dos materias uqe no son correlativas
independientes(Materia1, Materia2):-
  materia(Materia1, _),
  materia(Materia2, _),
  not(sonCorrelativas(Materia1, Materia2)),
  not(sonCorrelativas(Materia2, Materia1)),
  Materia1 \= Materia2.
 

%cursada (Alumno, Curso, NotaPrimerP, NotaSegundoP)
cursada(fede, k2103, 6, 6).
cursada(vicky, k1051, 7, 6).

% promedio/3: Calcula el promedio de notas de un alumno en una cursada.
promedio(Alumno, Cursada, Promedio) :-
  cursada(Alumno, Cursada, N1, N2),
  Total is (N1+N2),
  Promedio is Total/2.

% ¿Cómo se evalúa paso a paso al consultar promedio(fede, k2103, 6)?
% 1. Unifica Alumno = fede, Cursada = k2103, Promedio = 6.
% 2. Evalúa cursada(fede, k2103, N1, N2). Encuentra cursada(fede, k2103, 6, 6),
%    ligando temporalmente N1 = 6 y N2 = 6.
% 3. Evalúa Total is (N1+N2):
%    - El operador 'is' evalúa aritméticamente el lado derecho: (6 + 6) = 12.
%    - Liga la variable Total con el número 12.
% 4. Evalúa Promedio is Total/2:
%    - El operador 'is' evalúa aritméticamente el lado derecho: 12/2 = 6.
%    - Compara el resultado con el valor de Promedio (6). Como 6 = 6, da True.
%-------------------------------------------------------------------------------------
% ¿Cómo se evalúa una consulta mixta/abierta como promedio(Quien, Cursada, 8)?
% 1. Prolog unifica Alumno = Quien (variable libre), Cursada = Cursada (variable libre),
%    y Promedio = 8 (valor concreto).
% 2. Entra a cursada(Quien, Cursada, N1, N2). Como Quien y Cursada están libres,
%    Prolog usará cursada como GENERADOR y tomará la primera cursada:
%    - Liga Quien = fede, Cursada = k2103, N1 = 6, N2 = 6.
% 3. Evalúa Total is 6 + 6 -> Total = 12.
% 4. Evalúa 8 is 12 / 2 -> Compara si 8 es igual a 6. Como da FALSO, esta rama falla.
% 5. Hace BACKTRACKING: vuelve al generador cursada/4 a buscar otra cursada disponible.
% 6. Toma la siguiente cursada:
%    - Liga Quien = vicky, Cursada = k1051, N1 = 7, N2 = 6.
% 7. Evalúa Total is 7 + 6 -> Total = 13.
% 8. Evalúa 8 is 13 / 2 -> Compara si 8 es igual a 6.5. Da FALSO y esta rama falla.
% 9. Como no hay más cursadas en la base de datos, Prolog termina devolviendo 'false'.
%    (Si existiera un alumno con notas 8 y 8, el generador eventualmente lo ligaría,
%    el promedio daría 8, y la consulta tendría éxito devolviendo sus datos).
% ------------------------------------------------------------------------------------
% ¿QUÉ PASARÍA SI SE CAMBIA EL ORDEN (por ejemplo, poner 'Total is (N1+N2)' antes de 'cursada')?
% Si escribiéramos la regla así:
%   promedio(Alumno, Cursada, Promedio) :-
%     Total is (N1+N2),                  % <-- Falla acá con Instantiation Error
%     cursada(Alumno, Cursada, N1, N2),
%     Promedio is Total/2.
%
% Explicación del fallo:
% Prolog evalúa las condiciones en orden secuencial (de arriba a abajo). Si el 'is'
% se ejecuta primero, las variables N1 y N2 todavía están libres (sin instanciar),
% porque el generador 'cursada/4' (que les asigna las notas numéricas) no se ejecutó.
% Como el operador 'is' exige que todo su lado derecho tenga valores numéricos definidos,
% Prolog rompe inmediatamente con un error de instanciación ("Arguments are not sufficiently instantiated").


% =========================================================================
% CONCEPTOS CLAVE DE PDEP: INVERSIBILIDAD Y GENERADORES
% =========================================================================
% ¿Qué es la Inversibilidad?
% Es la capacidad que tiene un predicado para responder consultas tanto de forma
% CERRADA (ej: promedio(fede, k2103, 6)) como de forma ABIERTA con variables libres
% (ej: promedio(Quien, Curso, Nota)), siendo capaz de GENERAR todas las respuestas
% válidas de la base de conocimientos sin romperse ni tirar error.
%
% ¿Qué cosas "rompen" la inversibilidad si entran variables libres?
% 1. El operador 'is' y las comparaciones matemáticas (>, <, >=, =:=, etc.):
%    No saben calcular al revés ni adivinar números. Exigen que las variables
%    involucradas ya tengan un valor concreto asignado.
% 2. La Negación (not o \+):
%    Funciona por "Negación por Falla". No genera datos, solo sirve como filtro.
%    Si entra una variable libre, el not fallará o dará resultados incorrectos.
% 3. forall y findall:
%    - forall/2 (Para todo):
%      * Sintaxis: forall(Antecedente/Generador, Consecuente/Condicion)
%      * Significa: "Para todos los elementos que cumplen la primera parte, se tiene que cumplir la segunda".
%      * Recibe dos consultas. Al menos un parametro debe pasarse libre para que funcione.
%      * Al igual que el 'not', NO es inversible para variables que no estén ligadas antes del forall. Por eso requiere un generador previo.
%      * Ejemplo: Queremos saber si todas las materias que da un profesor son fáciles.
%        daSoloMateriasFaciles(Profesor) :-
%          profesor(Profesor, _, _), % GENERADOR para Profesor
%          forall(profesor(Profesor, Materia, _), esFacil(Materia)).
%
%    - findall/3 (Encontrar todos):
%      * Sintaxis: findall(QuéQueremosGuardar, Condición, ListaDestino)
%      * Significa: "Busca todas las soluciones que cumplen la Condición, extrae el valor indicado en QuéQueremosGuardar, y ponelos en ListaDestino".
%      * OJO: findall SIEMPRE da verdadero (True). Si nadie cumple la condición, te va a devolver la lista vacía [].
%      * Ejemplo: Queremos saber qué materias da un profesor en una lista.
%        materiasQueDa(Profesor, Materias) :-
%          profesor(Profesor, _, _), % GENERADOR para Profesor
%          findall(Materia, profesor(Profesor, Materia, _), Materias).
%
% ¿Cómo se soluciona el problema de inversibilidad? (Uso de GENERADORES):
% Un GENERADOR es un predicado simple (hecho de la base de datos o relación simple
% como 'cursada/4', 'materia/2', 'profesor/3') que asocia variables libres a
% individuos existentes del universo.
% Siempre se debe colocar el predicado generador ANTES de usar un 'is', una
% comparación matemática o un 'not'.

% =========================================================================
% DIFERENCIA CLAVE ENTRE 'is' e '=' EN PROLOG:
% =========================================================================
% 1. '=' (Unificación/Igualdad Estructural):
%    - NO evalúa ni calcula matemáticamente nada.
%    - Solo intenta emparejar estructuras o asignar valores a variables.
%    - Ej: X = 5 + 3. -> Da como resultado X = 5 + 3 (la estructura literal).
%    - Ej: 5 + 3 = 8. -> Da 'false' porque la estructura "5 + 3" no es igual al número "8".
%
% 2. 'is' (Evaluación Aritmética):
%    - Fuerza a Prolog a calcular el RESULTADO MATEMÁTICO del término derecho.
%    - Ej: X is 5 + 3. -> Da como resultado X = 8 (resuelve la operación).
%    - Ej: 8 is 5 + 3. -> Da 'true'.
%    - No lo usamos para asignar lo usamos para hacer CUENTAS
%    - REGLA DE ORO DEL 'is': Toda variable que esté a la derecha del 'is' debe
%      estar previamente instanciada (tener un valor numérico asignado). 
%      Si no, Prolog arroja un error de instanciación (Instantiation error).
%    - Es un predicado entonces puedo poner X is ... o is(X, ...) pero no puedo poner is(..., X) -> EJEMPLO: is(2, 1+1) da True pero is(1+1, 2) da False. Yo no puedo poner N1 + N2 is Total o Total/2 is Promedio porque si no instancio las variables, Prolog no va a poder resolverlo.


jodido(Profesor):-
  profesor(Profesor, Materia, _),
  not((esFacil(Materia), expertoEnElTema(Profesor))).

% jodido/1: Un profesor es jodido si la materia que da no es fácil, o bien si él no es un experto.

%====================================================================================
% EXPLICACIÓN DE MÚLTIPLES CONDICIONES DENTRO DE UN 'not':
%====================================================================================
% - El 'not' en Prolog recibe un ÚNICO argumento (un solo objetivo).
% - Sin embargo, podemos agrupar varias condiciones usando un par extra de PARÉNTESIS '(( ... ))'
%   y separando las condiciones por comas ',' (que actúan como un AND lógico).
% - ¡Ojo con la sintaxis! Es obligatorio usar DOBLE PARÉNTESIS:
%   - El paréntesis de afuera es del 'not(...)'.
%   - El paréntesis de adentro '(Condición1, Condición2)' agrupa las condiciones en un solo bloque. Si pusiéramos 'not(Condición1, Condición2)' sin el doble paréntesis, Prolog tiraría error porque pensaría que le estamos pasando dos argumentos al 'not' (y el not solo acepta uno).
% - Lógica de De Morgan: not((A, B)) es equivalente a decir "No (A y B)", lo cual significa que la regla se cumple si falla A, o si falla B, o si fallan ambos.
