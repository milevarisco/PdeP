import clases-W.clase4.ejercicioDrCasas.src.persona.Persona

const cameron = new Medico(dosis = 10, temperatura = 35.9, celulas = 2000)
const bilardo = new Medico(dosis = 33.33, temperatura = 36, celulas = 1000)

class Medico inherits Persona {
    const dosis = 5

    method atender(unaPersona) {
        unaPersona.recibirDosis(dosis)
    }

    override method contraer(unaEnfermedad) {
        super.contraer(unaEnfermedad)
        self.atender(self)
    }
}