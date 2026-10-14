import clases-W.clase4.ejercicioDrCasas.src.medico.Medico

class JefeDeDepartamento inherits Medico {
    const subordinados = #{}

    override method atender(unaPersona) {
        self.unoDeSusSubordinados().atender(unaPersona)
    }

    method unoDeSusSubordinados() = subordinados.anyOne()
}