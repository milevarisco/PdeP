const logan = new Persona(temperatura = 36, celulas = 3000000)

const frank = new Persona(temperatura = 36, celulas = 3500000)

class Persona {
    var temperatura
    var celulas
    const enfermedades = #{}

    method temperatura() = temperatura

    method celulas() = celulas

    method enfermedades() = enfermedades

    method aumentarTemperatura(unaCantidad) {
        temperatura = (temperatura + unaCantidad).min(45)
    }

    method vivirUnDia() {
        enfermedades.forEach { enfermedad =>
            enfermedad.afectarA(self)
        }
    }

    method vivir(dias) {
        dias.times { i => self.vivirUnDia() }
    }

    method contraer(enfermedad) {
        enfermedades.add(enfermedad)
    }

    method estaEnfermoDe(unaEnfermedad) =
        enfermedades.contains(unaEnfermedad)

    method disminuirCelulas(unaCantidad) {
        celulas = (celulas - unaCantidad).max(0)
    }

    // bloques o closures
    method celulasAfectadasPorEnfermedadesAgresivas()
        = enfermedades
            .filter { enfermedad => enfermedad.esAgresivaPara(self) }
            .sum { enfermedad => enfermedad.celulasAmenazadas() }

    method enfermedadMasAfectante() = enfermedades
        .max { enfermedad => enfermedad.celulasAmenazadas() }

    method estaEnComa() = temperatura == 45 || celulas <= 1000000

    method recibirDosis(unaDosis) {
        enfermedades.forEach( { enfermedad =>
          enfermedad.atenuar(unaDosis * 15) })

        enfermedades.removeAllSuchThat({
            enfermedad => enfermedad.estaCurada()
        })
    }
}