-- ==========================================
-- Definiciones de Tipos y Data
-- ==========================================

type Desgaste = (Float, Float)
type Tramo = Auto -> Auto

data Auto = Auto {
    marca        :: String,
    modelo       :: String,
    desgaste     :: Desgaste,
    maxVelocidad :: Float,
    uso          :: Float
} deriving (Show, Eq)

data Pista = Pista {
    tramos :: [Tramo]
}

-- ==========================================
-- Setters y Funciones Auxiliares
-- ==========================================

setDesgaste :: (Float -> Float) -> (Float -> Float) -> Auto -> Auto
setDesgaste f1 f2 auto = auto { desgaste = (setChasis f1 auto, setRuedas f2 auto) }

setChasis :: (Float -> Float) -> Auto -> Float
setChasis f unAuto = f (chasis unAuto)

setRuedas :: (Float -> Float) -> Auto -> Float
setRuedas f unAuto = f (ruedas unAuto)

setUso :: (Float -> Float) -> Auto -> Auto
setUso f unAuto = unAuto { uso = f (uso unAuto) }

-- Proyecciones para trabajar con la tupla de desgaste
chasis :: Auto -> Float
chasis = fst . desgaste

ruedas :: Auto -> Float
ruedas = snd . desgaste


-- ==========================================
-- Punto 1) Instancias de Autos
-- ==========================================

ferrari :: Auto
ferrari = Auto "Ferrari" "F50" (0, 0) 65 0

lambo :: Auto
lambo = Auto "Lamborghini" "Diablo" (7, 4) 73 0

fiat :: Auto
fiat = Auto "Fiat" "600" (33, 27) 44 0


-- ==========================================
-- Punto 2) Funciones de Estado
-- ==========================================

buenEstado :: Auto -> Bool
buenEstado unAuto = chasis unAuto < 40 && ruedas unAuto < 60

noDaMas :: Auto -> Bool
noDaMas unAuto = chasis unAuto > 80 || ruedas unAuto > 80


-- ==========================================
-- Punto 3) Reparación de Autos
-- ==========================================

repararAuto :: Auto -> Auto
repararAuto = setDesgaste reparasChasis ruedasNuevas auto

ruedasNuevas :: Float -> Float
ruedasNuevas viejas = 0

reparasChasis :: Float -> Float
reparasChasis = (*) 0.25

-- ==========================================
-- Punto 4) Reparación de Autos
-- ==========================================

type Curva = Float -> Float -> Tramo

pasarCurva :: Curva 
pasarCurva longitud angulo = setUso (+ longitud / (maxVelocidad auto / 2)) . setDesgaste id (+ 3*longitud/angulo)

curvaPeligrosa :: Tramo
curvaPeligrosa = pasarCurva 300 60

curvaTranca :: Tramo
curvaTranca = pasarCurva 550 110

type Recta = Float -> Tramo

pasarRecta :: Recta
pasarRecta longitud = setUso (+ longitud / maxVelocidad) . setDesgaste (*0.1) id

tramoRectoClassic :: Tramo
tramoRectoClassic = pasarRecta 750

tramito :: Tramo
tramito = pasarRecta 280

type Boxes = Tramo

pasarABoxes :: Boxes
pasarABoxes auto 
    | buenEstado auto = auto
    | otherwise = setUso (+10) . repararAuto . tramo $ auto

tramoMojado :: Tramo -> Tramo
tramoMojado tramo = setUso (*1.5) . tramo 

tramoConRipio :: Tramo -> Tramo
tramoConRipio tramo = tramo . tramo 

tramoConObstruccion :: Int -> Tramo -> Tramo
tramoConObstruccion obstrucciones tramo = setDesgaste id (+ 2*obstrucciones) . tramo

