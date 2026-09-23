class Persona {
  var temperatura 
  const enfermedades = #{}
  var celulas

  method temperatura() = temperatura
  method celulas() = celulas
  method viviUnDia() {
    enfermedades.forEach({enfermedad => 
      enfermedad.afectarA(self)
    })
  }
  method aumentarTemperatura(unaCantidad) {
    temperatura = (temperatura + unaCantidad).min(45)
  }

  method estaEnfermoDe(enfermedad) = enfermedades.contains(enfermedad)

  method contrae(enfermedad) {
    enfermedades.add(enfermedad)
  }

  method disminuirCelulas(unaCantidad) {
    celulas = (celulas - unaCantidad).max(0)
  }
  method celulasAfectadasPorCelulasAgresivas() = 
  enfermedades.filter({enfermedad => enfermedad.esAgresiva(self)})
  .map({enfermedad => enfermedad.celulasAmenazadas()})
  .sum()

  method enfermedadMasAfectante() = enfermedades.max({enfermedad => enfermedad.celulasAmenazadas()})
  method quedaEnComa() = temperatura == 45 || celulas < 1000000 
  method vivirNDias(n) = { n =>
  n.times {y => logan.viviUnDia()}
  }
}

const logan = new Persona(temperatura = 36, celulas = 3000000)

const frank = new Persona(temperatura = 36, celulas = 3500000)

class EnfermedadInfecciosa {
  var celulasAmenazadas = 500
  method celulasAmenazadas() = celulasAmenazadas 
  method reproducite() {
    celulasAmenazadas = celulasAmenazadas * 2
  }
  method afectarA(persona) {
    persona.aumentarTemperatura(celulasAmenazadas/1000)
  }
  method esAgresiva(persona) = celulasAmenazadas > persona.celulas()*0.1
}

const malaria500 = new EnfermedadInfecciosa(celulasAmenazadas = 500)
const malaria800 = new EnfermedadInfecciosa(celulasAmenazadas = 800)
const otitis100 = new EnfermedadInfecciosa(celulasAmenazadas = 100)
class EnfermedadesAutoInmune {
  var celulasAmenazadas
  var diasAfectados = 0

  method celulasAmenazadas() = celulasAmenazadas

  method afectarA(persona) {
    persona.disminuirCelulas(celulasAmenazadas)
    diasAfectados += 1
  }
  method esAgresiva(persona) = diasAfectados >= 30
} 
const lupus10000 = new EnfermedadesAutoInmune(celulasAmenazadas = 10000)

