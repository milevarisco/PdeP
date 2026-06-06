data Perro = Perro {
    nombre :: String,
    estamina :: Int,
    juguete :: Juguete,
    juego :: Juego
}

type Juego = Perro -> Bool

data Juguete = Juguete {
    color :: String,
    rechina :: Bool
}


sultan = Perro "Sultan" 25 (Juguete "Azul" False) (rechina . juguete)

sultanJuego perro = (rechina . juguete) perro

--1a) el type Juguete es mejor ponerlo como un data ya que el enunciado nos avisa que proximamente van a aparecer otra caracteristicas en el futuro por ende si lo usamos como type, si algo cambia, vamos a tener que cambiar todas las estructuras en las que lo hayamos escrito para agregar esa info nueva

-- juego deberia ser una funcion de Perro -> Bool ya que queremos saber si nuestro puerro quiere jugar con otro perro en especifico

-- al no usar tuplas, rechina no deberia estar declarado como scd fuera de la estructura del juguete y tampoco funcionaria al utilizarlo en sultan, por ende hacemos una funcion que reciba otroperro y se fije si su juguete rechina, eso lo hacemos mediante composicion de funciones

--b) 
jugueteNuevo perro nuevo = perro {juguete = nuevo} 
cambiarEstamina x perro = perro {estamina = x (estamina perro)}

recibirJuguete :: Juguete -> Perro -> Perro
recibirJuguete juguete perro = cambiarEstamina (+3) (jugueteNuevo perro juguete) 

--c)
puedeJugarJuntos :: Perro -> Perro -> Bool
puedeJugarJuntos perro1 perro2 = (juego perro1) perro2 && (juego perro2) perro1

--d)
setJuego :: (Juego -> Juego) -> Perro -> Perro
setJuego funcion perro = perro {juego = funcion (juego perro)}

aumentarExigencia :: Juego -> Perro -> Perro
aumentarExigencia juegoNuevo perro = setJuego (agregarJuego juegoNuevo) perro

agregarJuego :: Juego -> Juego -> Perro -> Bool
agregarJuego juegoNuevo juegoOriginal perro = juegoOriginal perro && juegoNuevo perro

estaminaMayorA :: Int -> Perro -> Bool
estaminaMayorA n perro = estamina perro > n

--2) 
type Tarea = Perro -> Perro
type Tiempo = Float

comer :: Tarea
correr :: Tiempo -> Tarea 
saltar :: Tarea 

ralizarTarea :: Perro -> Tarea -> Perro
realizarTarea perro tarea = tarea perro

realizarRutina :: [Tarea] -> Perro -> Perro
realizarRutina rutina perro = foldl rutina perro listaTareas

--e)
esExigente :: Perro -> [Tarea] -> Bool
esExigente perro rutina = estamina (realizarRutina rutina perro) < (estamina perro) * 0.5

--g)
{- esExigente sultan [comer, correr 10, saltar] -}

--3)
elegirNuevoJuguete [Juguete]-> (Juguete -> Juguete -> Bool) -> Juguete
elegirNuevoJuguete [x] _ = x
elegirNuevoJuguete (j1:j2:juegos) criterioJuguetes 
    | criterioJuguetes j1 j2 = elegirNuevoJuguete (j2: juegos) criterioJuguetes 
    | otherwise = elegirNuevoJuguete (j1 : juegos) criterioJuguetes 

jugueteElegido :: [Juguete] -> Perro -> Perro
jugueteElegido juguetes perro = 

--4) 