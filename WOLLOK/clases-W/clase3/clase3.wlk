/*
====================================================================
  CLASE 3: CONCEPTOS CLAVE
====================================================================

1. TEST DRIVEN DEVELOPMENT (TDD)
--------------------------------------------------------------------
  Es una metodología de desarrollo basada en un ciclo de 3 pasos:

  - 🔴 RED (Rojo): Escribir primero un test (.wtest) que falle antes 
    de escribir la solución. Define el comportamiento esperado.
  - 🟢 GREEN (Verde): Escribir el código mínimo necesario en el 
    objeto/programa (.wlk) para que el test pase.
  - 🔵 REFACTOR (Refactorizar): Mejorar el diseño del código sin 
    alterar su comportamiento (los tests siguen pasando).

  Beneficios:
  - Garantiza que el código cumpla los requerimientos desde el inicio.
  - Sirve como documentación viva.
  - Evita regresiones (romper cosas existentes al meter cambios).


2. COLECCIONES EN WOLLOK: LISTAS VS SETS
--------------------------------------------------------------------
  Las colecciones agrupan objetos. Las dos estructuras básicas son:

  A) LISTAS: [ elemento1, elemento2, ... ]
     - TIENEN ORDEN: Los elementos mantienen la posición en la que 
       fueron agregados.
     - PERMITEN REPETIDOS: El mismo objeto puede estar más de una vez.
     - Permite acceso por posición (.first(), .last(), .get(i)).
     - Ejemplo: var compras = ["manzana", "pan", "manzana"]

  B) SETS / CONJUNTOS: #{ elemento1, elemento2, ... }
     - SIN ORDEN: No existe un índice ni posición fija garantizada.
     - SIN REPETIDOS: Si se agrega un objeto que ya está en el set, 
       no se duplica.
     - Ejemplo: var enfermedades = #{"malaria", "gripe"}


3. POLIMORFISMO Y MENSAJES EN COLECCIONES
--------------------------------------------------------------------
  Tanto Listas como Sets son polimórficas (entienden los mismos mensajes 
  básicos de colecciones):

  • Modificación:
      coleccion.add(elemento)       // Agrega un elemento
      coleccion.remove(elemento)    // Elimina un elemento

  • Consultas:
      coleccion.contains(elemento)  // ¿Está el elemento? (true/false)
      coleccion.size()              // Cantidad de elementos
      coleccion.isEmpty()           // ¿Está vacía?

  • Orden superior (bloques):
      coleccion.filter({ elem => condición })  // Filtra los que cumplen
      coleccion.map({ elem => transformación })// Transforma cada elemento
      coleccion.find({ elem => condición })    // Busca el primero que cumple
      coleccion.any({ elem => condición })     // ¿Al menos uno cumple?
      coleccion.all({ elem => condición })     // ¿Todos cumplen?
      coleccion.sum({ elem => valor })         // Suma un valor numérico
      coleccion.forEach({ elem => accion })    // Aplica efecto a cada uno


4. CLASES (class) E INSTANCIAS (new)
--------------------------------------------------------------------
  ¿Por qué usamos Clases?
  Hasta ahora creábamos objetos individuales usando "object":
      object frank { var temperatura = 36 ... }
      object logan { var temperatura = 36 ... }

  Si necesitamos muchos objetos con la misma estructura y comportamiento 
  (ej. muchas personas o muchas enfermedades), duplicar "object" genera 
  código repetido.

  Una CLASE (class) actúa como un MOLDE o PLANTILLA:
  - Define qué atributos (estado) y métodos (comportamiento) tendrán 
    los objetos creados a partir de ella.
  - No es un objeto ejecutable en sí, sino la definición para crear objetos.

  INSTANCIACIÓN (new):
  - Para crear un objeto concreto a partir de una clase usamos la 
    palabra clave "new".
  - Cada objeto creado se llama INSTANCIA de esa clase.
  - Cada instancia tiene su propio estado (valores independientes en sus 
    atributos) pero comparte los mismos métodos.

  Sintaxis en Wollok:
      class Persona {
          var temperatura = 36
          var enfermedades = #{}

          method contrae(enfermedad) {
              enfermedades.add(enfermedad)
          }
          method estaEnfermoDe(enfermedad) = enfermedades.contains(enfermedad)
      }

  Uso / Instanciación:
      const frank = new Persona(temperatura = 36.5)
      const logan = new Persona(temperatura = 37)

  ¿Cuándo usar "object" vs "class"?
  - "object" (WKO - Well Known Object): Cuando hay UN SOLO objeto único 
    en todo el problema con esa identidad.
  - "class": Cuando van a existir MÚLTIPLES objetos parecidos creados 
    dinámicamente.


5. INICIALIZACIÓN DE ATRIBUTOS Y ENCAPSULAMIENTO
--------------------------------------------------------------------
  • Objetos únicos (object / WKO):
      Los atributos SIEMPRE deben estar inicializados con un valor inicial:
      object frank { var temperatura = 36 ... }

  • Clases (class):
      NO es obligatorio inicializar atributos en la definición de la clase:
      class Persona { var temperatura; var celulas }
      Se pueden pasar los valores al instanciar con "new":
      const logan = new Persona(temperatura = 36, celulas = 3000000)

  • Encapsulamiento:
      Los atributos son PRIVADOS. No se puede acceder ni modificar un 
      atributo desde fuera del objeto directamente (ej. no existe 
      logan.temperatura como propiedad pública).
      Para acceder a un atributo se debe definir un método explícito (getter):
      method temperatura() = temperatura


6. BLOQUES (LAMBDAS) Y EJECUCIÓN DIFERIDA
--------------------------------------------------------------------
  ¿Qué es un Bloque?
  Un bloque { parametro => expresión/acción } es un código de 
  EJECUCIÓN DIFERIDA. En Wollok, los bloques son OBJETOS.

  Sintaxis de un bloque:
      { p1, p2 => p1 + p2 }

  Ejecución diferida (.apply):
      El código dentro del bloque no se ejecuta cuando se declara, sino 
      cuando se le manda el mensaje .apply(...):
      const sumar = { a, b => a + b }
      sumar.apply(3, 4)  // Devuelve 7

7. DETALLE EN PROFUNDIDAD DE ITERADORES: forEach Y fold
--------------------------------------------------------------------

  A) .forEach({ elemento => accion })
  ----------------------------------
  • ¿Qué hace?
    Itera (recorre) la colección elemento por elemento y ejecuta una 
    ACCIÓN CON EFECTO DE LADO para cada uno de ellos.

  • ¿Qué recibe?
    Un bloque de 1 parámetro: { elemento => accion }

  • ¿Qué devuelve?
    NADA (void / null). No genera una nueva colección ni devuelve un resultado.

  • ¿Cuándo usarlo?
    ÚNICAMENTE cuando querés cambiar el estado de los objetos o producir un 
    efecto (ej: modificar atributos, llamar a métodos que cambian valores).
    NO lo uses para consultar o transformar datos sin efecto.

  • Ejemplo:
    enfermedades.forEach({ enfermedad => enfermedad.afectarA(self) })
    // Recorre cada enfermedad y le envía el mensaje afectarA(self), 
    // lo que hace que aumente la temperatura o disminuyan las células de la persona.


  B) .fold(semilla, { acumulador, elemento => expresion })
  --------------------------------------------------------
  • ¿Qué hace?
    REDUCE / ACUMULA toda una colección a un ÚNICO valor final (un número, 
    un booleano, un string, u otro objeto), usando un valor inicial 
    llamado SEMILLA (seed).

  • ¿Qué recibe?
    1) La semilla (valor inicial del acumulador).
    2) Un bloque de 2 parámetros: { acumulador, elemento => expresion }
       - acumulador: Mantiene el resultado acumulado de los pasos anteriores. 
         En la 1er iteración toma el valor de la semilla.
       - elemento: Es el elemento actual de la colección que se procesa.

  • ¿Qué devuelve?
    El valor final del acumulador al terminar de recorrer la colección.

  • ¿Cómo funciona paso a paso?
    Supongamos la lista [500, 100, 10000] y la semilla 0:
    numeros.fold(0, { acum, n => acum + n })

    - Iteración 1: acum = 0     | n = 500   => nuevo acum = 0 + 500 = 500
    - Iteración 2: acum = 500   | n = 100   => nuevo acum = 500 + 100 = 600
    - Iteración 3: acum = 600   | n = 10000 => nuevo acum = 600 + 10000 = 10600
    - Resultado final: 10600

  • Otro ejemplo con objetos:
    // Calcular el total de células amenazadas por todas las enfermedades:
    enfermedades.fold(0, { total, enf => total + enf.celulasAmenazadas() })


8. RESUMEN DE ITERADORES Y MÉTODOS DE ORDEN SUPERIOR
--------------------------------------------------------------------
  - .forEach( { elem => ... } )  -> Con EFECTO DE LADO. Devuelve nada.
  - .map( { elem => ... } )      -> TRANSFORMA cada elem. Devuelve NUEVA colección.
  - .filter( { elem => ... } )   -> FILTRA según condición boolean. Devuelve NUEVA colección.
  - .find( { elem => ... } )     -> BUSCA el primer objeto que cumple condición.
  - .any( { elem => ... } )      -> ¿AL MENOS UNO cumple? Devuelve true/false.
  - .all( { elem => ... } )      -> ¿TODOS cumplen? Devuelve true/false.
  - .sum( { elem => ... } )      -> Mapea a números y los SUMA.
  - .fold(semilla, { acum, elem => ... }) -> REDUCE la colección a un único valor.
====================================================================

9. DIAGRAMA DE CLASES
--------------------------------------------------------------------
  ¿Qué es un Diagrama de Clases?
  Es una herramienta gráfica (UML) utilizada para diseñar y comunicar la 
  arquitectura estática de un sistema orientado a objetos.

  Principios clave:
  - NO busca volcar absolutamente todo el código (no es una copia 1 a 1).
  - Su objetivo principal es COMUNICAR la estructura del dominio, las clases 
    principales, sus responsabilidades y cómo se relacionan entre sí.

  Estructura de la Caja de una Clase:
  Se dibuja como un rectángulo dividido en secciones:
  +-----------------------------------+
  |           NombreDeClase           |  <- Sección superior: Nombre de la clase
  +-----------------------------------+
  | temperatura                       |  <- Sección media: Atributos principales
  | celulas                           |
  +-----------------------------------+
  | viviUnDia()                       |  <- Sección inferior: Métodos relevantes
  | contrae(enfermedad)               |
  | quedaEnComa()                     |
  +-----------------------------------+

  Relaciones y Flechas de Referencia (Asociación):
  Las referencias de un objeto a otro se representan mediante FLECHAS:

  • Flecha simple (A -> B): 
    "A conoce a B" o "A tiene un B". Una referencia a un único objeto.
    Ejemplo: Persona -> Medico

  • Flecha con multiplicidad/cardinalidad (A ->* B):
    "A conoce a muchos B". Representa una colección de referencias.
    Ejemplo: Persona -> * Enfermedad (la persona tiene una lista/set de enfermedades)

  Polimorfismo en el Diagrama e INTERFACES:
  - Una INTERFAZ es el conjunto de mensajes (contrato) que un objeto entiende.
  - Sacar múltiples flechas desde un atributo (ej. Persona -> EnfermedadInfecciosa 
    y Persona -> EnfermedadesAutoInmune) ensucia el diagrama.
  - Para simplificarlo y comunicar el POLIMORFISMO, dibujamos una caja general 
    arriba llamada INTERFAZ (ej: «interface» Enfermedad o IEnfermedad).
  - La Persona apunta con UNA SOLA flecha a la Interfaz (Persona -> * Enfermedad).
  - Las clases concretas (EnfermedadInfecciosa y EnfermedadesAutoInmune) apuntan 
    hacia la Interfaz indicando que ambas implementan ese contrato de mensajes.
====================================================================
*/