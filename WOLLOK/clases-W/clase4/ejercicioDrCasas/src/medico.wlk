class Medico inherits Persona {
    const dosis = 5

    method atender(unaPersona) {
        unaPersona.recibirDosis(dosis)
    }

    override method contraer(unaEnfermedad) {
        super.contraer(unaEnfermedad)
        self.atender(self)
    }

    // TODO: definir la lógica real de compatibilidad
    override method soyCompatibleCon(unaPersona) = true
}

const cameron = new Medico(dosis = 10, temperatura = 35.9, celulas = 2000)
const bilardo = new Medico(dosis = 33.33, temperatura = 36, celulas = 1000)