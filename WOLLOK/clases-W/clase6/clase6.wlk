/* ============================================================
   COMPOSICIÓN DE OBJETOS
   ============================================================
   - El comportamiento de un objeto está dado por los comportamientos
     de los objetos que él conoce (sus colaboradores).
   - El tipo de un objeto no solo está ligado a su propia interfaz,
     sino también a la interfaz de los objetos que conoce.
   - Es una relación DINÁMICA: puede cambiar en tiempo de ejecución.
     Por eso se representa con ->* en diagramas (la referencia puede mutar).
   - Relación del tipo "tiene un" / "conoce a".

   Ejemplo:
     object pepita {
         var dieta = alimentacionNormal  // pepita "conoce" a dieta (composición)
         method comer() = dieta.alimentar(self)  // delega comportamiento
     }
     // Se puede cambiar la dieta en tiempo de ejecución -> relación dinámica

   ============================================================
   PATRONES DE DISEÑO
   ============================================================
   Son soluciones ya probadas a problemas recurrentes en el diseño
   orientado a objetos. En lugar de inventar desde cero, se aplica
   un patrón conocido que ya resuelve el problema de forma elegante.

   - COMPOSITE:
       Un objeto puede estar compuesto por muchos objetos del mismo tipo,
       y compartir su interfaz con ellos. Así, el cliente trata a un objeto
       individual y a un grupo de objetos de la misma manera.
       Ej: una figura puede ser un círculo simple o un grupo de figuras.

   - STATE:
       El comportamiento de un objeto cambia según su estado interno.
       En lugar de usar if/else, cada estado es un objeto distinto que
       sabe cómo comportarse. El objeto delega en su estado actual.
       Ej: una canilla puede estar "abierta" o "cerrada" y cada una
       tiene su propio comportamiento para "fluir".

   - STRATEGY:
       Permite definir una familia de algoritmos intercambiables.
       El objeto delega la lógica variable a un colaborador (la estrategia),
       que puede cambiarse en tiempo de ejecución.
       Ej: pepita puede tener distintas "dietas" (estrategias de alimentación).

   - TEMPLATE METHOD:
       Define el esqueleto de un algoritmo en una superclase, dejando
       que las subclases completen los pasos específicos.
       Lo común va en la superclase; lo variable, en cada subclase.
       Ej: un método "rutinaDiaria" que llama a "desayunar" y "trabajar",
       donde cada subclase implementa esos pasos a su manera.

   - SINGLETON:
       Garantiza que una clase tenga una única instancia en todo el sistema
       y provee un punto de acceso global a ella.
       En Wollok esto se logra naturalmente con los `object` (WKO).
       Ej: `object dios { }` — existe uno solo en todo el programa.

   NOTA: Un objeto compuesto por muchos objetos puede compartir su interfaz
   con sus partes → esto es la base del patrón COMPOSITE.
   ============================================================
   HERENCIA SIMPLE
   ============================================================
   - Permite que una clase herede atributos y comportamiento de otra (superclase).
   - Se llama "simple" porque cada clase solo puede heredar de UNA superclase.
   - La relación es ESTÁTICA: se define en tiempo de compilación y no cambia.
   - Relación del tipo "es un".

   Diferencia clave:
     Composición  -> "tiene un"  | dinámica  | más flexible
     Herencia     -> "es un"     | estática  | menos flexible

   Regla general: preferir COMPOSICIÓN sobre HERENCIA cuando
   la relación puede cambiar o se necesita mayor flexibilidad.

   la herencia es mas simple
   ============================================================
*/