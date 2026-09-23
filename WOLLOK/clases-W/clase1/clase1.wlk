/*
 * ============================================================================
 * CONCEPTOS FUNDAMENTALES (POO EN WOLLOK)
 * ============================================================================
 *
 * 1. OBJETO:
 *    - Es una entidad computacional que encapsula ESTADO (datos/atributos) 
 *      y COMPORTAMIENTO (métodos).
 *    - Representa un concepto o actor del dominio del problema.
 *    - Tiene identidad: cada objeto es único, independientemente de su estado.
 *
 * 2. MENSAJE vs MÉTODO:
 *    - Mensaje (el QUÉ): La orden/solicitud enviada al objeto (ej: estudiante.tomarMates()).
 *    - Método (el CÓMO): El bloque de código dentro del objeto que resuelve ese mensaje (hace que el objeto entienda un mensaje). muestra ó hace algo.
 *
 * 3. GETTER:
 *    Método de consulta que solo devuelve el valor de un atributo (variable de instancia).
 *
 * 4. EFECTO (Efecto colateral):
 *    Ocurre cuando un método MODIFICA el estado del objeto (muta una variable).
 *
 * 5. INTERFAZ:
 *    Es el conjunto de todos los MENSAJES que un objeto entiende (sabe responder).
 *    En 'estudiante', su interfaz son: energia(), saludar(alguien) y tomarMates().
 * 
 * 6. POLIMORFISMO:
 *    - Ocurre cuando un objeto puede tratar indistintamente a distintos objetos.
 *    - Para que dos o más objetos sean polimórficos respecto a un tercero, deben 
 *      compartir una interfaz común (responder a los mismos mensajes).
 *    - Ejemplo: 'estudiante' trata polimórficamente a 'termoLumilagro' y 'termoCEIT',
 *      ya que ambos entienden el mensaje 'servirAgua(unaCantidad)'.
 * ============================================================================
 */

// EJEMPLO EN WOLLOK:

object estudiante {
    // ESTADO (Atributo privado)
    var energia = 50
    var termo = termoLumilagro
    
    // GETTER: expone el valor del atributo 'energia' (sin efecto)
    method energia() {
        return energia
    } 

    method energia(unaEnergia) {
      energia = unaEnergia
    }
    
    // Método de CONSULTA (devuelve un valor, sin efecto)
    method saludar(alguien) {
        return "Hola " + alguien
    }

    // Método de ORDEN con EFECTO (modifica la variable de estado 'energia')
    method tomarMates() {
        termo.servirAgua(50)
        energia = energia + 10
    }

    method pedirTermoCEIT() {
      self.termo(termoCEIT) // setter de termo con self porque tenes que acceder a tus propios metodos, es decur auto enviarte un mensaje
    }
    
    //SETTER: modifica el valor de una variable. se llama igual al getter pero con parametros
    method termo(unTermo) { 
      termo = unTermo
    }
}

object termoLumilagro {
    var aguaDisponible = 1000

    method aguaDisponible() = aguaDisponible // Getter: se puede escribir asi tambien

    method servirAgua(unaCantidad) {
        aguaDisponible -= unaCantidad
    }
    
    method restarAgua(agua) { // para no repetir logica
      if(aguaDisponible - agua <0 ){
        aguaDisponible = 0
      } else {
        aguaDisponible -= agua
      }
    }
    
    method volcarse() {
      self.restarAgua(200) // se usa self para referirse a si mismo desde el punto de vista del objeto
    }
}

object profe {
  var termo = termoLumilagro // comparte el mate con el estudiante

  method tomarMates() {
        termo.servirAgua(50)
    }
}

object termoCEIT {
    var aguaDisponible = 1000

    method aguaDisponible() = aguaDisponible // Getter: se puede escribir asi tambien

    method servirAgua(unaCantidad) {
        aguaDisponible -= unaCantidad
    }
    
    method restarAgua(agua) { // para no repetir logica
      if(aguaDisponible - agua <0 ){
        aguaDisponible = 0
      } else {
        aguaDisponible -= agua
      }
    }
    
    method volcarse() {
      self.restarAgua(200) // se usa self para referirse a si mismo desde el punto de vista del objeto
    }
}