import clases-W.clase4.ejercicioDrCasas.src.persona.logan
import clases-W.clase4.ejercicioDrCasas.src.persona.frank
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.malaria800
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.malaria500
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.otitis800
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.otitis100
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.lupus200
import clases-W.clase4.ejercicioDrCasas.src.enfermedades.lupus10000
import clases-W.clase4.ejercicioDrCasas.src.medico.cameron
import clases-W.clase4.ejercicioDrCasas.src.medico.bilardo

describe "Dr Casa - Temporada 1" {
    test "frank contraer una malaria de 800 células" {
        frank.contraer(malaria800)
        assert.that(frank.estaEnfermoDe(malaria800))
    }

    test "la malaria de 500 se reproduce" {
        assert.equals(500, malaria500.celulasAmenazadas())
        malaria500.reproducite()
        assert.equals(1000, malaria500.celulasAmenazadas())
    }

    test "logan vive un dia y su temperatura aumenta" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivirUnDia()
        assert.equals(36.6, logan.temperatura())
    }

    test "logan vive un dia y no tiene celulas afectadas por enfermedades agresivas" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivirUnDia()

        assert.equals(0, logan.celulasAfectadasPorEnfermedadesAgresivas())
    }

    test "logan vive un dia y la enfermedad que más lo afecta es el lupus" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivirUnDia()

        assert.equals(lupus10000, logan.enfermedadMasAfectante())
    }

    test "logan vive un dia y no queda en coma" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivirUnDia()

        assert.notThat(logan.estaEnComa())
    }

    test "logan vive 31 días y queda en coma" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivir(31)
        assert.that(logan.estaEnComa())
    }

    test "logan vive 31 días y la enfermedad que más lo afecta es la malaria" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivir(31)
        assert.equals(lupus10000, logan.enfermedadMasAfectante())
    }

    test "logan vive 31 días y tiene 10000 celulas amenazadas por enfermedades agresivas" {
        logan.contraer(malaria500)
        logan.contraer(otitis100)
        logan.contraer(lupus10000)

        logan.vivir(31)

        assert.equals(10000, logan.celulasAfectadasPorEnfermedadesAgresivas())
    }
}

describe "Dr Casa - Temporada 2" {
    test "1.A La malaria se atenúa en 150 células" {
        logan.contraer(malaria500)
        cameron.atender(logan)

        assert.equals(350, malaria500.celulasAmenazadas())
    }

    test "1.B El lupus se atenúa en 500 células" {
        logan.contraer(lupus200)
        bilardo.atender(logan)

        assert.equals(-299.95, lupus200.celulasAmenazadas())
    }

    test "1.C Logan se cura de lupus" {
        logan.contraer(lupus200)
        logan.contraer(malaria800)
        bilardo.atender(logan)

        assert.equals(#{malaria800}, logan.enfermedades())
    }
}