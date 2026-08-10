/* ============================================================================
 * Apunte de Clase 4 - Paradigmas de Programación (Paradigma Lógico)
 * ============================================================================
 * ¡Hola estudiantes! Hoy tuvimos la cuarta clase de Lógico.
 * Temas vistos:
 * 1. Listas en Prolog (Sintaxis y división en Cabeza y Cola).
 * 2. Predicados útiles para listas: length/2, member/2, sumlist/2, nth0/3, nth1/3.
 * 3. Encontrar y agrupar soluciones: findall/3
 * ============================================================================
 */

% ============================================================================
% 1. BASE DE CONOCIMIENTO (Hechos y Reglas Básicas)
% ============================================================================

% partido(Pais, OtroPais, GolesPais, GolesOtroPais).
partido(argentina, argelia, 3, 0).
partido(argentina, austria, 2, 0).
partido(argentina, jordania, 3, 1).

partido(mexico, sudafrica, 2, 0).
partido(mexico, corea, 1, 0).
partido(mexico, chequia, 3, 0).

partido(uruguay, arabiaSaudita, 1, 1).
partido(uruguay, caboVerde, 2, 2).
partido(uruguay, espania, 0, 1).

partido(belgica, egipto, 1, 1).


% gano/2, empato/2
gano(Pais, OtroPais) :-
  partido(Pais, OtroPais, GolesPais, GolesOtroPais),
  GolesPais > GolesOtroPais.

empato(Pais, OtroPais) :-
  partido(Pais, OtroPais, Goles, Goles).


% ============================================================================
% 2. LISTAS EN PROLOG
% ============================================================================
/*
 * Concepto: Listas
 * Una lista es una colección ordenada de elementos. Se encierran entre corchetes 
 * y sus elementos se separan por comas.
 * Ejemplos: 
 *   [1, 2, 3, 4, 5]
 *   [argentina, austria, jordania, argelia]
 *   [argentina78, 4, austria, marcador] (Prolog permite listas con tipos mixtos).
 *
 * Cabeza y Cola (Head|Tail):
 * Toda lista no vacía se puede dividir internamente en su primer elemento (Cabeza) 
 * y el resto de la lista (Cola), separados por un pipe (|).
 * Ejemplo: [5, 2, 1] se puede expresar como 5 | [2, 1] o 5 | 2 | 1 | []
 *
 * Predicados útiles para trabajar con listas que vimos hoy:
 * - length(Lista, Cantidad): Relaciona una lista con su cantidad de elementos.
 * - member(Elemento, Lista): Verifica si un Elemento pertenece a la Lista 
 *   (¡O es capaz de generar/devolver sus elementos uno por uno si pasamos una variable!).
 * - sumlist(Lista, Total): Suma todos los números dentro de una lista numérica.
 * - nth0(Indice, Lista, Elemento): Relaciona una lista con el elemento en esa posición (Arranca en 0).
 * - nth1(Indice, Lista, Elemento): Igual que nth0 pero el índice arranca en 1.
 */


% ============================================================================
% 3. AGRUPANDO RESULTADOS CON FINDALL/3
% ============================================================================
/*
 * Concepto: findall/3
 * Estructura: findall(VariableDeInteres, Consulta, ListaResultante).
 * 
 * Nos ayuda a encontrar TODOS los posibles valores que hacen verdadera a una 
 * consulta, y los agrupa devolviéndolos como un solo conjunto dentro de una Lista.
 * Es muy útil cuando queremos contar ocurrencias (combinado con length) o 
 * sumar valores (combinado con sumlist) que están dispersos en múltiples hechos.
 */

% completoGrupo/1
% Queremos saber si un país completó su grupo. 
% Se cumple cuando jugó todos sus partidos (asumimos al menos 3).
completoGrupo(Pais) :-
  partido(Pais, _, _, _), % Generador (ligamos 'Pais' antes del findall)
  % Agrupamos todos los 'Rival' de sus partidos en la lista 'Rivales'
  findall(Rival, partido(Pais, Rival, _, _), Rivales),
  length(Rivales, Cuantos),
  Cuantos >= 3.

/*
 * Nota: Una forma de hacer lo mismo SIN findall ni listas sería mucho más incómoda:
 * 
 * completoGrupo(Pais) :-
 *   partido(Pais, Rival1, _, _),
 *   partido(Pais, Rival2, _, _),
 *   Rival1 \= Rival2,
 *   partido(Pais, Rival3, _, _),
 *   Rival3 \= Rival1,
 *   Rival3 \= Rival2.
 * 
 * ¡Imagínense si fueran 10 partidos! Por eso usamos listas.
 */


% cuantosGolesMetio/2
% ¿Cuántos goles metió un país en total a lo largo del mundial?
cuantosGolesMetio(Pais, CuantosGoles) :-
  partido(Pais, _, _, _),
  % Agrupamos todos los Goles que hizo en cada partido
  findall(Goles, partido(Pais, _, Goles, _), ListaGoles),
  % Sumamos todos los elementos de la lista usando sumlist/2
  sumlist(ListaGoles, CuantosGoles).


% puntosTotales/2
% ¿Cuántos puntos sumó un país en sus partidos? (3 por ganar, 1 por empatar).
puntosTotales(Pais, PuntosTotales) :-
  partido(Pais, _, _, _),
  puntosPorGanar(Pais, PuntosPorGanar),
  puntosPorEmpatar(Pais, PuntosPorEmpatar),
  PuntosTotales is PuntosPorGanar + PuntosPorEmpatar.

% puntosPorGanar/2
puntosPorGanar(Pais, Puntos) :-
  % Buscamos todos los rivales a los que les ganó y armamos una lista
  findall(Rival, gano(Pais, Rival), Lista),
  length(Lista, Cantidad), % Vemos cuántos elementos tiene la lista
  Puntos is Cantidad * 3.

% puntosPorEmpatar/2
puntosPorEmpatar(Pais, Puntos) :-
  % Buscamos todos los rivales con los que empató
  findall(Rival, empato(Pais, Rival), Lista),
  % Como cada empate vale 1 punto, la cantidad de elementos es directamente el puntaje.
  length(Lista, Puntos).