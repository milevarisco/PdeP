object tom {
  var energia = 0
  
  method velocidad() = 5 + energia/10

  method getEnergia() = energia
  method setEnergia(otraEnergia) {
    energia = otraEnergia
  }

//   method sumarEnergia(agregado) {
//     self.setEnergia(energia + agregado)
//   }

  method energiaGanadaAlComer(unRaton) = 12 + unRaton.peso()
  method enegiaGastadaAlCorrer(unaDistancia) = 0.5*unaDistancia

  method comerRaton(unRaton) {
    energia += self.energiaGanadaAlComer(unRaton)
    // self.sumarEnergia(self.energiaGanadaAlComer(unRaton))
  }

  method correr(segundos){
    energia -= self.enegiaGastadaAlCorrer(segundos * self.velocidad())
    // self.sumarEnergia(self.enegiaGastadaAlCorrer(-(segundos * self.velocidad())))
  }  
  
  method meConvieneComerRatonA(unRaton, unaDistancia) {
    return (self.energiaGanadaAlComer(unRaton) >  self.enegiaGastadaAlCorrer(unaDistancia))
  }
}

object raton {
    const peso = 2

    method peso() = peso
}
