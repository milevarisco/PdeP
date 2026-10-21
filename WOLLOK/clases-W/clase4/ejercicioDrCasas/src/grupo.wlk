object grupoA{
    method esCompatibleCon(grupo){
        return #{self, grupoAB}.contains(grupo)
    }
}

object grupoB {
  method esCompatibleCon(grupo){
        return #{self, grupoAB}.contains(grupo)
    }
}

object grupoAB {
  method esCompatibleCon(grupo){
        return grupo == self
    }
}

object grupo0 {
  method esCompatibleCon(grupo) = true
}