const malaria800 = new EnfermedadInfecciosa(
    celulasAmenazadas = 800
)

const malaria500 = new EnfermedadInfecciosa(
    celulasAmenazadas = 500
)

const otitis800 = new EnfermedadInfecciosa(
    celulasAmenazadas = 800
)

const otitis100 = new EnfermedadInfecciosa(
    celulasAmenazadas = 100
)

const lupus200 = new EnfermedadAutoinmune(
    celulasAmenazadas = 200
)

const lupus10000 = new EnfermedadAutoinmune(
    celulasAmenazadas = 10000
)

class Enfermedad {
    var celulasAmenazadas

    method celulasAmenazadas() = celulasAmenazadas

    method atenuar(cantidad) {
        celulasAmenazadas -= cantidad
    }

    method estaCurada() = celulasAmenazadas <= 0
}

class EnfermedadAutoinmune inherits Enfermedad {
    var diasQueAfecto = 0

    method afectarA(persona) {
        persona.disminuirCelulas(celulasAmenazadas)
        diasQueAfecto += 1
    }

    method esAgresivaPara(unaPersona) = diasQueAfecto >= 30
}

class EnfermedadInfecciosa inherits Enfermedad {
    

    method reproducite() {
        celulasAmenazadas *= 2
    }

    method afectarA(persona) {
        persona.aumentarTemperatura(celulasAmenazadas / 1000)
    }

    method esAgresivaPara(unaPersona) = celulasAmenazadas > unaPersona.celulas() * 0.1
}