object pepe {

    var categoria = desarrollador
    var bonoResultado = nulo
    var bonoPresentismo = sinOferta
    var aniosAntiguedad =  0 
    var cantidadFaltas = 0

    //getters
    method aniosAntiguedad() = aniosAntiguedad 
    method cantidadFaltas() = cantidadFaltas 

    //setters
    method categoria(unaCategoria) {
      categoria = unaCategoria
    }
    method bonoResultado(unBonoEmpresarial) {
      bonoResultado = unBonoEmpresarial
    }
    method bonoPresentismo(unBonoPorPresentismo) {
      bonoPresentismo = unBonoPorPresentismo
    }
    method aniosAntiguedad(unosAnios) {
      aniosAntiguedad = unosAnios
    }
    method cantidadFaltas(unasFaltas) {
      cantidadFaltas = unasFaltas
    }

    method sueldo() = self.sueldoNeto() + self.bonoPresentismo() + self.bonoResultado()
    method sueldoNeto() = categoria.sueldo(aniosAntiguedad)
    method bonoPresentismo() = bonoPresentismo.sueldo(self)
    method bonoResultado() = bonoResultado.sueldo(self)
    method cumplirAnio() {
        aniosAntiguedad += 1
    }
}

object desarrollador {
    method sueldo(aniosAntiguedad) = 1000 + 25 * aniosAntiguedad
}

object manager {
    method sueldo(aniosAntiguedad) = 1500 + 50 * aniosAntiguedad
}

object gerente {
    method sueldo(aniosAntiguedad) = 2500 +100 * aniosAntiguedad
}

object administrativo {
    method sueldo(aniosAntiguedad) = 500
}

object gnocci {
    method sueldo(empleado) = 2 ** empleado.cantidadFaltas()
}

object porFaltas {
    method sueldo(empleado) {
        const cantidadFaltas = empleado.cantidadFaltas()
        if (cantidadFaltas == 0) {
            100
        } else if(cantidadFaltas == 1){
            50
        } else {
            0
        }
    }
}

object nulo {
    method sueldo(empleado) = 0 
}

object sti {
    method suledo(empleado) = empleado.sueldoNeto() * 0.20
}

object fijo {
    method sueldo(empleado) = 15 + empleado.aniosAntiguedad()
}

object sinOferta {
    method sueldo(empleado) = 0 
}
