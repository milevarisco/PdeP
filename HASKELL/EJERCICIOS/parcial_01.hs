type Artefacto = (String, Int)

xiphos, rayo :: Artefacto
xiphos = ("Xiphos", 50)
rayo = ("Rayo de Zeus", 500)

pasarALaHistoria :: Heroe -> Heroe
pasarALaHistoria unHeroe
    | reconocimiento unHeroe > 1000 = cambiarEpiteto "El mítico" unHeroe
    | reconocimiento unHeroe > 500 = (cambiarEpiteto "El magnífico" . agregarArtefacto rayo) unHeroe
    | reconocimiento unHeroe > 100 = (cambiarEpiteto "Hoplita" . agregarArtefacto xiphos) unHeroe
    | otherwise = unHeroe

-- 1)
data Heroe = Heroe {
    epiteto :: String,
    reconocimiento :: Int,
    artefactos :: [Artefacto],
    tareas :: [Tarea]
}

cambiarEpiteto :: String -> Heroe -> Heroe
cambiarEpiteto unEpiteto unHeroe =
    unHeroe { epiteto = unEpiteto}

mapArtefacto :: ([Artefacto]->[Artefacto]) -> Heroe -> Heroe
mapArtefacto funcion unHeroe = unHeroe{
    artefactos = funcion (artefactos unHeroe)
}

agregarArtefacto :: Artefacto -> Heroe -> Heroe
agregarArtefacto unArtefacto unHeroe =
    mapArtefacto (unArtefacto :) unHeroe


-- 2)
-- CONCEPTOS USADOS: Guardas, tuplas, composicion y expresividad
-- CAMBIOS:
-- cambiar h por heroe
-- sacar id
-- usar (.) para compones las funciones de la sefunda y tercer guarda

-- 3)
type Tarea = Heroe -> Heroe


rareza :: Artefacto -> Int
rareza = snd

encontrarUnArtefacto :: Artefacto -> Tarea
encontrarUnArtefacto unArtefacto unHeroe = ganarReconocimiento (rareza unArtefacto) (agregarArtefacto unArtefacto unHeroe)

ganarReconocimiento :: Int -> Heroe -> Heroe
ganarReconocimiento unReconocimiento unHeroe = unHeroe {
    reconocimiento = reconocimiento unHeroe + unReconocimiento
}

escalarElOlimpo :: Tarea
escalarElOlimpo = mapArtefacto triplicarRarezaDeRaros . ganarReconocimiento 500

triplicarRarezaDeRaros :: ([Artefacto] -> [Artefacto])
triplicarRarezaDeRaros unosArtefactos = filter (esRaro . triplicarRareza) unosArtefactos

triplicarRareza :: Artefacto -> Artefacto
triplicarRareza = \(a, b) -> (a, 3 * b) 

esRaro :: Artefacto -> Bool
esRaro = (> 1000) . rareza

{- REPETICION DE CODIGO ENTRE LAS FUNCIONES
encontrarUnArtefacto unArtefacto unHeroe = unHeroe {
    reconocimiento = reconocimiento unHeroe + rareza unArtefacto,
    artefactos = unArtefacto : artefactos unHeroe
}

escalarElOlimpo unHeroe = unHeroe {
    reconocimiento = reconocimiento unHeroe + 500,
    artefactos = rayo : filter ((> 100) . rareza) (triplicarRarezas unHeroe) 
}
-- OPCIONES DE TRIPLICAR:
triplicarRareza' :: Artefacto -> Artefacto
triplicarRareza' (nobre, rareza) = (nombre, 3 * rareza)-}

ayudarACruzarLaCalle :: Int -> Tarea
ayudarACruzarLaCalle 0 unHeroe = unHeroe
ayudarACruzarLaCalle unaCuadras unHeroe = cambiarEpiteto ("Gros" ++ replicate unaCuadras 'o') unHeroe

matarUnaBestia :: Bestia -> Tarea
matarUnaBestia unaBestia unHeroe
    | (debilidad unaBestia) unHeroe = cambiarEpiteto ("El asesino de " ++ nombre unaBestia) unHeroe
    | otherwise = (cambiarEpiteto "El cobarde" .  mapArtefacto (drop 1)) unHeroe

data Bestia = Bestia {
    nombre :: String,
    debilidad :: Debilidad
}

type Debilidad = Heroe -> Bool

-- 4)
esMejor :: Heroe -> Heroe -> Bool
esMejor unHeroe otroHeroe = reconocimiento unHeroe > reconocimiento otroHeroe || (reconocimiento unHeroe == reconocimiento otroHeroe && sumaRarezas (artefactos unHeroe) > sumaRarezas (artefactos otroHeroe))

sumaRarezas :: [Artefacto] -> Int
sumaRarezas [] = 0
sumaRarezas (artefacto : artefactos) = rareza artefacto + sumaRarezas unosArtefactos

-- otra opcion de sumaRarezas

sumaRarezas' :: [Artefacto] -> Int
sumaRarezas' = sum (map rareza)