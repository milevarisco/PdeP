/*
====================================================================
  CLASE 4: CONCEPTOS CLAVE
====================================================================

1. HERENCIA (extends)
--------------------------------------------------------------------
  ¿Para qué sirve?
  La herencia nos permite crear una clase NUEVA a partir de otra ya
  existente, REUTILIZANDO su estado y comportamiento sin repetir código.

  Relación "ES UN":
  - Si la clase B extiende a la clase A, decimos que B "ES UN TIPO DE" A.
  - Ejemplo: Perro ES UN Animal. Gato ES UN Animal.
  - En el diagrama de clases se representa con una flecha ——|> apuntando
    hacia la clase padre (superclase).

  Terminología:
  - SUPERCLASE / CLASE PADRE: La clase de la que se hereda (Animal).
  - SUBCLASE / CLASE HIJA:    La clase que hereda (Perro, Gato).

  Sintaxis en Wollok:
      class Subclase extends Superclase { ... }

  ¿Qué hereda la subclase?
  - Todos los ATRIBUTOS definidos en la superclase.
  - Todos los MÉTODOS definidos en la superclase.
  - La subclase puede además agregar sus propios atributos y métodos extra.

  Ejemplo concreto:

  // ── Superclase ─────────────────────────────────────────────────
  class Animal {
      var nombre          // atributo compartido por todas las subclases
      var energia = 100

      method nombre()  = nombre
      method energia() = energia

      method comer(calorias) {
          energia = energia + calorias
      }

      method sonido() = "..."   // comportamiento genérico

      method presentarse() = "Soy " + nombre + " y digo: " + self.sonido()
  }

  // ── Subclases ──────────────────────────────────────────────────
  class Perro extends Animal {
      // Hereda: nombre, energia, comer(), sonido(), presentarse()
      // Agrega su propio atributo:
      var raza
      method raza() = raza
  }

  class Gato extends Animal {
      // También hereda todo de Animal
      // Agrega su propio comportamiento:
      method ronronear() = nombre + " hace purrrr..."
  }

  Uso:
      const fido = new Perro(nombre = "Fido", raza = "Labrador")
      fido.comer(50)          // <- método heredado de Animal
      fido.energia()          // -> 150
      fido.presentarse()      // -> "Soy Fido y digo: ..."


====================================================================
2. CLASES ABSTRACTAS Y MÉTODOS ABSTRACTOS
====================================================================

  ¿Qué es una clase abstracta?
  Una clase ABSTRACTA es una clase que NO puede instanciarse directamente
  (no se puede hacer new ClaseAbstracta(...)). Existe para ser extendida.

  ¿Por qué existe?
  - Agrupa comportamiento COMÚN a un conjunto de clases.
  - Define el CONTRATO de lo que las subclases DEBEN implementar.
  - Evita crear objetos incompletos o sin sentido.

  ¿Qué es un método abstracto?
  Un método ABSTRACTO declara el nombre y parámetros del mensaje, pero
  NO tiene cuerpo/implementación. Es una PROMESA: "toda subclase concreta
  DEBE redefinir este método con su propia implementación".

  En Wollok: basta con que una clase tenga al menos un método abstracto
  (sin cuerpo) para que sea considerada abstracta por el compilador.

  Sintaxis en Wollok:
      method miMetodo()    // Sin cuerpo = método abstracto

  Regla importante:
  - Si una subclase NO implementa todos los métodos abstractos que hereda,
    TAMBIÉN se vuelve abstracta (tampoco se puede instanciar).

  Ejemplo:

  // ── Clase abstracta ────────────────────────────────────────────
  class Figura {
      // Método abstracto: no tiene cuerpo → cada subclase lo implementa
      method area()

      // Método concreto: usa area(), que será proveída por la subclase
      method descripcion() = "Soy una figura de área " + self.area()
  }

  // ── Subclases concretas ────────────────────────────────────────
  class Rectangulo extends Figura {
      var base
      var altura
      method area() = base * altura        // Implementación concreta de area()
  }

  class Circulo extends Figura {
      var radio
      method area() = 3.14159 * radio * radio   // Otra implementación concreta
  }

  Uso:
      const r = new Rectangulo(base = 4, altura = 5)
      r.area()           // -> 20
      r.descripcion()    // -> "Soy una figura de área 20"

      const c = new Circulo(radio = 3)
      c.area()           // -> 28.27...

      // ❌ Esto falla: Figura es abstracta, no se puede instanciar
      // const f = new Figura()


====================================================================
3. REDEFINICIÓN DE MÉTODOS CON OVERRIDE
====================================================================

  ¿Qué es override?
  Cuando una subclase quiere CAMBIAR o ESPECIALIZAR el comportamiento
  de un método que ya existe en la superclase, usa la palabra clave
  override para redefinir ese método.

  ¿Cuándo usar override?
  - El método YA EXISTE en la superclase (es concreto, tiene implementación).
  - La subclase necesita una versión DIFERENTE de ese comportamiento.

  Diferencia con los métodos abstractos:
  - Abstracto: la superclase declara el método pero NO lo implementa.
    La subclase lo implementa desde cero (sin override).
  - override: la superclase tiene una implementación. La subclase la PISA
    con una nueva. Debe usar la palabra override explícitamente.

  Sintaxis en Wollok:
      override method miMetodo() = nuevaImplementacion

  Ejemplo (retomando Animal):

  class Perro2 extends Animal {
      var raza

      // override indica explícitamente que estamos redefiniendo sonido()
      // que en Animal devuelve "..."
      override method sonido() = "¡Guau!"
  }

  class Gato2 extends Animal {
      override method sonido() = "¡Miau!"
  }

  Uso:
      const fido  = new Perro2(nombre = "Fido", raza = "Labrador")
      const michi = new Gato2(nombre = "Michi")

      fido.sonido()           // -> "¡Guau!"    (versión de Perro2)
      michi.sonido()          // -> "¡Miau!"    (versión de Gato2)

      fido.presentarse()      // -> "Soy Fido y digo: ¡Guau!"
        ^
        Nota: presentarse() está en Animal y llama a self.sonido()
        self apunta al objeto concreto (fido = Perro2), así que
        se usa el sonido() redefinido.  ← Esto tiene que ver con
        el Method Lookup (próxima sección).


====================================================================
4. METHOD LOOKUP (BÚSQUEDA DE MÉTODOS)
====================================================================

  ¿Qué es el Method Lookup?
  Cuando se le envía un mensaje a un objeto (ej: fido.sonido()), Wollok
  necesita encontrar QUÉ método ejecutar. El proceso de búsqueda se
  llama METHOD LOOKUP (búsqueda del método).

  Orden de búsqueda:
  ┌─────────────────────────────────────────────────────────────┐
  │  Objeto receptor del mensaje                                │
  │                                                             │
  │  1. Se busca el método en la CLASE DEL OBJETO.             │
  │     Si está definido ahí → se ejecuta. FIN.                │
  │                                                             │
  │  2. Si NO está, se busca en la SUPERCLASE.                 │
  │     Si está definido ahí → se ejecuta. FIN.                │
  │                                                             │
  │  3. Si NO está, se sigue subiendo en la cadena de          │
  │     herencia hasta llegar a Object (clase raíz de todo).   │
  │                                                             │
  │  4. Si no se encuentra en ningún lado → ERROR en runtime.  │
  └─────────────────────────────────────────────────────────────┘

  Ejemplo paso a paso:
      const fido = new Perro2(nombre = "Fido", raza = "Labrador")
      fido.presentarse()

  Búsqueda de presentarse():
    → ¿Está en Perro2?  NO
    → ¿Está en Animal?  SÍ → se ejecuta Animal.presentarse()

  Dentro de presentarse() se llama a self.sonido():
    → self = fido (siempre es el objeto que recibió el mensaje original)
    → Búsqueda de sonido() empieza de nuevo desde Perro2:
    → ¿Está en Perro2?  SÍ → se ejecuta Perro2.sonido() → "¡Guau!"
    → Resultado: "Soy Fido y digo: ¡Guau!"

  ⚠️ Punto clave sobre "self":
  Dentro de cualquier método, self siempre refiere al OBJETO CONCRETO
  que recibió el mensaje, NO a la clase donde está escrito el método.
  Esto garantiza que el polimorfismo y el override funcionen
  correctamente a través de la herencia.


====================================================================
5. super: ALTERANDO EL ORDEN DEL METHOD LOOKUP
====================================================================

  ¿Qué es super?
  super es una palabra clave que, dentro de un método, permite llamar
  explícitamente a la versión del método de la SUPERCLASE, en lugar de
  la versión del objeto actual.

  ¿Cuándo se usa?
  Cuando hacemos override pero queremos EXTENDER el comportamiento
  de la superclase en lugar de reemplazarlo completamente.
  Es decir: "hacé lo que ya hace la superclase, y además..."

  Diferencia entre self y super:
  ┌────────┬──────────────────────────────────────────────────────┐
  │ self   │ Busca el método desde la CLASE DEL OBJETO (arranca   │
  │        │ desde abajo en la jerarquía). Puede ejecutar métodos │
  │        │ redefinidos en la subclase actual.                   │
  ├────────┼──────────────────────────────────────────────────────┤
  │ super  │ Salta DIRECTAMENTE a la SUPERCLASE y busca desde     │
  │        │ ahí hacia arriba. Ignora la versión de la subclase.  │
  └────────┴──────────────────────────────────────────────────────┘

  Sintaxis:
      override method miMetodo() {
          super.miMetodo()   // llama a la versión de la superclase
          // ... lógica extra de la subclase
      }

  Ejemplo concreto:

  class AnimalDomestico extends Animal {
      var duenio

      // Extendemos comer(): primero hace lo de Animal, luego agrega
      // el comportamiento extra de AnimalDomestico.
      override method comer(calorias) {
          super.comer(calorias)   // <- llama a Animal.comer(calorias)
                                  //    que hace: energia = energia + calorias
          // Además del efecto de comer, el animal doméstico se pone contento:
          super.comer(10)         // bonus de felicidad (reutilizamos el método padre)
      }

      method duenio() = duenio
  }

  class PerroDomestico extends AnimalDomestico {
      var raza

      override method sonido() = "¡Guau guau!"

      // Extendemos presentarse() para agregar la raza
      override method presentarse() =
          super.presentarse() + " (raza: " + raza + ")"
          //   ^
          //   Llama a Animal.presentarse() que devuelve
          //   "Soy [nombre] y digo: ¡Guau guau!"
          //   Y luego le agrega " (raza: Poodle)"
  }

  Uso:
      const rex = new PerroDomestico(nombre = "Rex", raza = "Poodle", duenio = "Ana")

      rex.comer(50)
        // Busca comer() → no está en PerroDomestico
        // Sube → está en AnimalDomestico.comer(50):
        //   super.comer(50) → llama a Animal.comer(50): energia += 50
        //   super.comer(10) → llama a Animal.comer(10): energia += 10 (bonus)
        // energia final = 100 + 50 + 10 = 160

      rex.presentarse()
        // Busca presentarse() → está en PerroDomestico:
        //   super.presentarse() → llama a Animal.presentarse():
        //     self.sonido() → busca sonido() desde PerroDomestico:
        //       → está en PerroDomestico: "¡Guau guau!"
        //     → retorna "Soy Rex y digo: ¡Guau guau!"
        //   + " (raza: Poodle)"
        // Resultado: "Soy Rex y digo: ¡Guau guau! (raza: Poodle)"


====================================================================
  RESUMEN GENERAL DE CLASE 4
====================================================================

  ┌───────────────────┬─────────────────────────────────────────────┐
  │ Concepto          │ Descripción corta                           │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ extends           │ La subclase hereda atributos y métodos de   │
  │ (Herencia)        │ la superclase. Relación "ES UN TIPO DE".    │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ Clase abstracta   │ No se puede instanciar. Sirve como base     │
  │                   │ común para subclases concretas.             │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ Método abstracto  │ Sin cuerpo. Obliga a las subclases a        │
  │                   │ implementarlo con su propia lógica.         │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ override          │ Redefine en la subclase un método que ya    │
  │                   │ existía (concreto) en la superclase.        │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ Method Lookup     │ Al recibir un mensaje, Wollok busca el      │
  │                   │ método de abajo hacia arriba en la          │
  │                   │ jerarquía de herencia.                      │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ self              │ Siempre apunta al objeto concreto receptor. │
  │                   │ El lookup arranca desde su clase.           │
  ├───────────────────┼─────────────────────────────────────────────┤
  │ super             │ Dentro de un override, salta directamente   │
  │                   │ a la superclase para reutilizar su          │
  │                   │ implementación y extenderla.                │
  └───────────────────┴─────────────────────────────────────────────┘

====================================================================
*/
