/* ============================================================================
 * Apunte de Clase 3 - Paradigmas de Programación (Paradigma Lógico)
 * ============================================================================
 * ¡Hola estudiantes! Hoy tuvimos la tercera clase de Lógico.
 * Temas vistos:
 * 1. Repaso de predicados generadores y negación.
 * 2. Cuantificador Universal: forall/2
 * 3. Antecedente, consecuente y variables libres.
 * 4. Manejo de inversibilidad en el forall.
 * (Nota: También practicamos con el ejercicio de TEG, pero aquí dejamos 
 * documentado el dominio de los partidos de fútbol).
 * ============================================================================
 */

% ============================================================================
% 1. BASE DE CONOCIMIENTO (Hechos)
% ============================================================================
% partido(Pais, OtroPais, GolesPais, GolesOtroPais).
partido(argentina, argelia, 3, 0).
partido(argentina, austria, 2, 2).
partido(argentina, jordania, 3, 1).

partido(mexico, sudafrica, 2, 0).
partido(mexico, corea, 1, 0).
partido(mexico, chequia, 3, 0).

partido(uruguay, arabiaSaudita, 1, 1).
partido(uruguay, caboVerde, 2, 2).
partido(uruguay, espania, 0, 1).


% ============================================================================
% 2. REGLAS BÁSICAS Y PREDICADOS GENERADORES
% ============================================================================

% pais/1
% Predicado generador: nos sirve para "ligar" la variable Pais extrayéndola
% de los hechos, evitando problemas de inversibilidad más adelante.
pais(Pais) :-
  partido(Pais, _, _, _).

% gano/2, perdio/2, empato/2
gano(Pais, OtroPais) :-
  partido(Pais, OtroPais, GolesPais, GolesOtroPais),
  GolesPais > GolesOtroPais.

perdio(Pais, OtroPais) :- 
  partido(Pais, OtroPais, GolesPais, GolesOtroPais),
  GolesPais < GolesOtroPais.

empato(Pais, OtroPais) :-
  partido(Pais, OtroPais, Goles, Goles).

% resultado/3
% Alternativa agrupando lógicas similares con Pattern Matching
resultado(Pais, OtroPais, perdio) :-
    partido(Pais, OtroPais, GolesPais, GolesOtroPais),
    GolesPais < GolesOtroPais.

resultado(Pais, OtroPais, gano) :-
    partido(Pais, OtroPais, GolesPais, GolesOtroPais),
    GolesPais > GolesOtroPais.


% ============================================================================
% 3. REPASO DE NEGACIÓN (not/1)
% ============================================================================

% invicto/1
% Un país está invicto si NO perdió ningún partido.
% Fíjense que usamos pais(Pais) como generador ANTES del not/1.
invicto(Pais) :-
  pais(Pais), % <-- Generar el Pais
  not(perdio(Pais, _)).

% recibioGoles/1
recibioGoles(Pais) :-
  partido(Pais, _, _, GolesRecibidos),
  GolesRecibidos > 0.

% vallaInvicta/1
% Un país tiene la valla invicta si NO recibió goles.
vallaInvicta(Pais) :-
  pais(Pais),
  not(recibioGoles(Pais)).


% ============================================================================
% 4. CUANTIFICADOR UNIVERSAL (forall/2)
% ============================================================================
/*
 * Concepto: forall(Antecedente, Consecuente)
 * A diferencia de consultar por simple existencia (al menos uno cumple),
 * forall nos permite verificar si TODOS los elementos cumplen una condición.
 * 
 * - Antecedente: Genera el conjunto de elementos a evaluar. 
 *   (Ej: "Para TODOS los partidos que jugó este país...")
 * - Consecuente: La condición que DEBEN cumplir todos esos elementos.
 *   (Ej: "...debe haberlos ganado")
 * 
 * ¡Ojo con las Variables Libres!
 * Si hay variables en el forall que queremos consultar desde afuera (como Pais),
 * DEBEMOS generarlas (ligarlas) ANTES del forall. Si no lo hacemos, el forall
 * las va a tratar internamente y perderemos la inversibilidad parcial/total.
 */

% ganoTodo/1 (Versión 1 - Negando lo contrario)
ganoTodo(Pais) :-
  pais(Pais),
  not(empato(Pais, _)),
  not(perdio(Pais, _)).

% ganoTodo2/1 (Versión 2 - Doble negación)
% Fue ganador en todo si NO existe un partido que NO haya ganado.
ganoTodo2(Pais) :-
  pais(Pais),
  not( (partido(Pais, OtroPais, _, _), not(gano(Pais, OtroPais))) ).

% ganoTodo3/1 (Versión 3 - Usando forall/2)
% ¡La forma más declarativa! Para TODOS sus partidos, los ganó.
ganoTodo3(Pais) :-
  pais(Pais), % <-- Genero para evitar problemas de inversibilidad de la variable libre
  forall(partido(Pais, OtroPais, _, _), gano(Pais, OtroPais)).


% ============================================================================
% 5. FORALL CON DIFERENTES ALCANCES (Contextos)
% ============================================================================

% masGolesEnUnPartidoPorPais/2 
% Para cada país particular, cuál fue la vez que más goles metió.
% (Nota: Renombrado respecto al original para evitar conflictos).
% El forall verifica que "MuchosGoles" sea mayor o igual a los goles de TODOS
% los partidos que jugó ESE 'Pais' en particular.
masGolesEnUnPartidoPorPais(Pais, MuchosGoles) :-
  partido(Pais, _, MuchosGoles, _),
  forall(partido(Pais, _, Goles, _), MuchosGoles >= Goles).
  
% masGolesEnUnPartidoDelMundial/2
% En TODO el mundial, qué país metió más goles en un partido.
% (Nota: Renombrado respecto al original para evitar conflictos).
% Fíjense la diferencia en el antecedente del forall: usamos variable anónima '_' 
% en el país para comparar contra TODOS los partidos de CUALQUIER país.
masGolesEnUnPartidoDelMundial(Pais, MuchosGoles) :-
  partido(Pais, _, MuchosGoles, _),
  forall(partido(_, _, Goles, _), MuchosGoles >= Goles).