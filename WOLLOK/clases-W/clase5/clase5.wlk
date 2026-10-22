
// ============================================================
//  CLASE 5 - Conceptos de Wollok
// ============================================================


// ============================================================
// 1. WKO: Well Known Objects (Objetos bien conocidos)
// ============================================================
// Son objetos únicos (singleton) que se definen con la palabra
// clave "object". No son instancias de ninguna clase; son un
// solo objeto que vive en todo el programa.
// Se llaman "well known" porque son conocidos globalmente.
//
// Ejemplo:
//
//   object pepita {
//     var energia = 100
//     method volar() { energia = energia - 10 }
//     method energia() = energia
//   }
//
// Se accede directamente por nombre: pepita.volar()
// No se instancian con "new".


// ============================================================
// 2. var property / const property
// ============================================================
// Al definir un atributo en un objeto o clase, se puede usar
// la palabra "property" para que Wollok genere automáticamente
// el GETTER y el SETTER del atributo.
//
//  - "var property"  → genera getter Y setter (el valor puede cambiar)
//  - "const property" → genera SOLO getter     (el valor no puede cambiar)
//
// Ejemplo:
//
//   object persona {
//     var property nombre = "Juan"    // getter: nombre()  setter: nombre(unNombre)
//     const property dni   = 12345678 // getter: dni()     (sin setter)
//   }
//
// Sin "property" tendrías que escribir los métodos getter/setter a mano.


// ============================================================
// 3. Excepciones: throw new Exception(mensaje)
// ============================================================
// Las excepciones son objetos que representan situaciones de error.
//
//  - "throw"    → lanza (dispara) la excepción, interrumpe la ejecución.
//  - "new"      → crea una instancia de la clase de excepción.
//  - Exception  → clase base de todas las excepciones en Wollok.
//
// Sintaxis básica:
//   throw new Exception(message = "Algo salió mal")
//
// ── Jerarquía de excepciones ──────────────────────────────
//
//   Exception                    ← clase raíz
//   └── DomainException          ← para errores del dominio del problema
//       └── (podés crear las tuyas)
//
// Ejemplo de excepción propia del dominio:
//
//   class SaldoInsuficienteException inherits DomainException {
//     // hereda el atributo "message" de DomainException
//   }
//
// Cómo lanzarla:
//
//   method extraer(monto) {
//     if (monto > saldo)
//       throw new SaldoInsuficienteException(message = "Saldo insuficiente")
//     saldo = saldo - monto
//   }
//
// ── Manejo de excepciones (try/catch) ────────────────────
//
//   try {
//     cuenta.extraer(9999)
//   } catch e : SaldoInsuficienteException {
//     console.println("Error: " + e.message())
//   }
//
// Si no se captura la excepción, el programa termina con error.