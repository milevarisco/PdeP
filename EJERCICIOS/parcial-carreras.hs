import Data.List
data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving (Show)

type Carrera = [Auto]

----------------------------
--       punto 1 a
----------------------------
estanCerca :: Auto -> Auto -> Bool
estanCerca unAuto otroAuto = distanciaEntre unAuto otroAuto < 10 &&  not (mismoAuto unAuto otroAuto)

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre unAuto otroAuto = abs . subtract (distancia unAuto) $ (distancia otroAuto)

mismoAuto :: Auto -> Auto -> Bool
mismoAuto unAuto otroAuto = color unAuto == color otroAuto
----------------------------
--       punto 1 b
----------------------------

ningunoCerca :: Auto -> Carrera -> Bool
ningunoCerca unAuto otrosAutos = not . any (estanCerca unAuto) $ otrosAutos

vaGanando :: Auto -> Carrera -> Bool
vaGanando unAuto otrosAutos = all (mayorDistancia unAuto) otrosAutos

mayorDistancia :: Auto -> Auto -> Bool
mayorDistancia unAuto otroAuto = distancia unAuto > distancia otroAuto && (not . mismoAuto unAuto $ otroAuto)

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo unAuto otrosAutos = all ($ rivales unAuto otrosAutos) [vaGanando unAuto, ningunoCerca unAuto]

rivales :: Auto -> Carrera -> Carrera
rivales unAuto otrosAutos = filter (not . mismoAuto unAuto) otrosAutos
----------------------------
--       punto 1 c
----------------------------

puesto :: Carrera -> Auto -> Posicion
puesto otrosAutos unAuto = ((+) 1 (length . filter ( flip mayorDistancia unAuto ) $ otrosAutos), color unAuto)  

----------------------------
--       punto 2 a
----------------------------
setDistancia :: (Int -> Int) -> Auto -> Auto
setDistancia funcion unAuto = unAuto{
    distancia = funcion . distancia $ unAuto
}

correr :: Int -> Auto -> Auto
correr tiempo unAuto = setDistancia (formulaDistancia tiempo (velocidad unAuto)) unAuto

formulaDistancia :: Int -> Int -> Int -> Int
formulaDistancia tiempo velocidad distanciaInicial = distanciaInicial + tiempo * velocidad 

----------------------------
--       punto 2 b
----------------------------

type Aceleracion = (Int -> Int)

setVelocidad:: Aceleracion -> Auto -> Auto
setVelocidad funcion unAuto = unAuto{
    velocidad = funcion . velocidad $ unAuto
}

bajarVelocidad ::  Int -> Auto -> Auto
bajarVelocidad disminuir = setVelocidad (max 0 . subtract disminuir) 

----------------------------
--       punto 3 
----------------------------

type PowerUp = (Auto -> Carrera -> Carrera)

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista =
    (map efecto . filter criterio) lista ++ filter (not.criterio) lista

terremoto :: PowerUp
terremoto unAuto = afectarALosQueCumplen (estanCerca unAuto) (bajarVelocidad 50) 

miguelitos :: Int -> PowerUp
miguelitos cantidad unAuto = afectarALosQueCumplen (mayorDistancia unAuto) (bajarVelocidad cantidad)

jetPack :: Int -> PowerUp
jetPack tiempo unAuto carrera = restablecerVelocidad unAuto $ correnTodos tiempo (duplicarVelocidad unAuto carrera)

duplicarVelocidad :: PowerUp
duplicarVelocidad unAuto = afectarALosQueCumplen (mismoAuto unAuto) (setVelocidad (*2) ) 

restablecerVelocidad :: PowerUp
restablecerVelocidad unAuto = afectarALosQueCumplen (mismoAuto unAuto) (setVelocidad (const (velocidad unAuto)))

----------------------------
--       punto 4a 
----------------------------

type Evento = (Carrera -> Carrera)
type TablaDePosiciones = [Posicion]
type Posicion = (Int, String)

tablaDePosiciones ::  Carrera -> TablaDePosiciones 
tablaDePosiciones carreraFinalizada = map (puesto carreraFinalizada) carreraFinalizada

simularCarerra :: Carrera -> [Evento] -> Carrera
simularCarerra carrera eventos = foldl (flip ($)) carrera eventos

----------------------------
--       punto 4b
----------------------------

correnTodos :: Int -> Evento
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: PowerUp -> String -> Evento
usaPowerUp powerup unColor carrera = 
    afectarAlQueCumple (\auto -> unColor == color auto) (powerup) carrera

afectarAlQueCumple :: (Auto -> Bool) -> (PowerUp) -> Carrera -> Carrera
afectarAlQueCumple criterio powerup lista =
    powerup (head . filter criterio $ lista) lista 

----------------------------
--       punto 4c
----------------------------

auto1 = Auto "rojo" 120 0
auto2 = Auto "blanco" 120 0
auto3 = Auto "azul" 120 0
auto4 = Auto "negro" 120 0

listaAutos = [auto1, auto2, auto3, auto4]

eventos = [
    correnTodos 30 , 
    usaPowerUp (jetPack 3) "azul",
    usaPowerUp terremoto "blanco",
    correnTodos 40,
    usaPowerUp (miguelitos 20) "blanco",
    usaPowerUp (jetPack 6) "negro",
    correnTodos 10
    ]