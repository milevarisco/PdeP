class Jugador {
    var skill
    var peso
    var escoba
    var reflejos
    var punteria
    var fuerza
    var vision
    var equipo

    method nivelManejo() = skill / peso 
    method velocidad() = escoba.velocidad() * self.nivelManejo()
    method habilidad() = self.velocidad() + skill
    method lePasaElTrapo(otroJugador) = self.habilidad() >= 2 * otroJugador.habilidad()
    method esGroso() = self.habilidad() > equipo.promedioHabilidad() && self.velocidad() > mercado.valor()

}


class Nimbus {
    var añoFabricacion
    var porcentajeSalud

    method antiguedad() = new Date().year() - añoFabricacion
    method velocidad() = (80 - self.antiguedad()) * self.porcentajeSalud()
    method porcentajeSalud() = porcentajeSalud / 100
}

class SaetaDeFuego {
    method velocidad() = 100
}

class Cazador inherits Jugador {

    override method habilidad() = super() + punteria * fuerza
}

class Guardian inherits Jugador {

    override method habilidad() = super() + reflejos + fuerza
}

class Golpeador inherits Jugador {

    override method habilidad() = super() + punteria + fuerza
}

class Buscador inherits Jugador {

    override method habilidad() = super() + reflejos * vision
}

object mercado {
    method valor() =  5
}

class Equipo {
    var jugadores
    method sumaHabilidades() = jugadores.sum{j => j.habilidad()}
    method promedioHabilidad() = self.sumaHabilidades() / jugadores.size()
    method tieneJugadorEstrellaContra(otroEquipo) =  jugadores.any{j => otroEquipo.nosPasaElTrapo(j)}
    method nosPasaElTrapo(jugador) = jugadores.all{j => jugador.lePasaElTrapo(j)}
}