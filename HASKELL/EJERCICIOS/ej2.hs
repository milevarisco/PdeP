--Datos de ejemplo
--Nombres
harry, ron, hermione, draco :: Persona
harry = ("Harry", (11, 5, 4))
ron = ("Ron", (6, 4, 6))
hermione = ("Hermione", (8, 12, 2))
draco = ("Draco", (7, 9, 6))

--Pociones
felixFelices = Pocion "Felix Felices" [escarabajosMachacados, ojoDeTigreSucio]
multijugos = Pocion "Multijugos" [cuernoDeBicornioEnPolvo, sanguijuelaHormonal]
floresDeBach = Pocion "Flores de Bach" [orquideaSalvaje, rosita]

--Ingredientes
escarabajosMachacados = Ingrediente "Escarabajos Machacados" 52 [f1, f2]
ojoDeTigreSucio = Ingrediente "Ojo de Tigre Sucio" 2 [f3]
cuernoDeBicornioEnPolvo = Ingrediente "Cuerno de Bicornio en Polvo" 10
   [invertir3, (\(a, b, c) -> (a, a, c))]
sanguijuelaHormonal = Ingrediente "Sanguijuela Hormonal" 54 [aplicar3 (*2),
   (\(a, b, c) -> (a, a, c))]
orquideaSalvaje = Ingrediente "Orquídea Salvaje" 8 [f3]
rosita = Ingrediente "Rosita" 1 [f1]

--Efectos (funciones)
f1 (ns, nc, nf) = (ns+1, nc+2, nf+3)
f2 = aplicar3 (max 7)
f3 (ns, nc, nf)
  | ns >= 8 = (ns, nc, nf+5)
  | otherwise = (ns, nc, nf-3)


-- Funciones previas
aplicar3 f (a, b, c) = (f a, f b, f c)

invertir3 (a, b, c) = (c, b, a)

sinRepetidos [] = []
sinRepetidos (x:xs)
  | elem x xs = sinRepetidos xs
  | otherwise = x : sinRepetidos xs

suerte (s, _, _) = s
convencimiento (_, c, _) = c
fuerzaFisica (_, _, ff) = ff

maximoF _ [ x ] = x
maximoF f ( x : y : xs)
  | f x > f y = maximoF f (x:xs)
  | otherwise = maximoF f (y:xs)

-- Datas y Tipos
type Persona = (String , Niveles)
type Niveles = (Int, Int, Int)
type Efectos = ( Niveles -> Niveles )

data Pocion = Pocion String [Ingrediente]
data Ingrediente = Ingrediente String Int [Efectos]
listaIngredientes (Pocion _ ingredientes) = ingredientes
nombrePocion (Pocion nombre _) = nombre

nombreIngrediente (Ingrediente nombre _ _) = nombre
gramosIngrediente (Ingrediente _ gramos _) = gramos
listaEfectos (Ingrediente _ _ efectos) = efectos 

getNiveles (_, niveles) = niveles
nombrePersona (nombre, _) = nombre

-- Funciones punto 2 

sumaNiveles:: Niveles -> Int
sumaNiveles (n1 ,n2, n3) = n1 + n2 + n3


diferenciaNiveles:: Niveles -> Int
diferenciaNiveles (n1, n2, n3) = max n3 (max n1 n2)  - min n3 (min n2 n1)

-- funciones punto 3
sumaNivelesPersona :: Persona -> Int
sumaNivelesPersona persona = sumaNiveles (snd persona) 

diferenciaNivelesPersona :: Persona -> Int
diferenciaNivelesPersona persona = diferenciaNiveles (snd persona)

-- funcion punto 4
efectosDePocion :: Pocion -> [Efectos]
efectosDePocion pocion = concat (map listaEfectos (listaIngredientes pocion))

--funcon punto 5
pocionesHeavies :: [Pocion] -> [String]
pocionesHeavies pociones = map nombrePocion (filter ((>= 4) . (length . efectosDePocion)) pociones)
{- [pocion1, pocion 2]                                         (.) :: 
[ ...[ingredientes1], ...[ingredientes2]]
[... ...[efectos1], ... ... [efectos2]]
[ [efecto11, efecto12, efecto21]] -}

-- funcion punto 6.a
incluyeA :: Eq a => [a] -> [a] -> Bool
incluyeA [] lista2 = True
incluyeA (x:xs) lista2
    | any (== x) lista2 = incluyeA xs lista2
    | otherwise = False

-- funcion punto 6.b
vocales = "aeiou"
contieneVocales :: Pocion -> Bool
contieneVocales pocion = incluyeA vocales $ concat (map nombreIngrediente (listaIngredientes pocion))

gramosPares :: Pocion -> Bool
gramosPares pocion = all even $ (map gramosIngrediente (listaIngredientes pocion))

esPocionMagica :: Pocion -> Bool
esPocionMagica pocion = contieneVocales pocion && gramosPares pocion
    
-- funcion punto 7

aplicarEfectos :: [Efectos] -> Persona -> Persona
aplicarEfectos [] persona = persona
aplicarEfectos (efecto:cola) persona = aplicarEfectos cola (nombrePersona persona, (efecto $ getNiveles persona))

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion persona = aplicarEfectos (efectosDePocion pocion) persona

-- funcion punto 8
esAntidoto :: Persona -> Pocion -> Pocion -> Bool
esAntidoto persona poc1 poc2 = (tomarPocion poc2 . tomarPocion poc1 $ persona) == persona

-- funcion punto 9
todosTomanPocion :: [Persona] -> Pocion -> [Persona]
todosTomanPocion listaPersonas pocion = map (tomarPocion pocion) $ listaPersonas

personaMasAfecatada :: Pocion -> (Niveles -> Int) -> [Persona] -> Persona
personaMasAfecatada pocion ponderacion listaPersonas = maximoF (ponderacion . getNiveles )(todosTomanPocion listaPersonas pocion)


-- funcion punto 10 

promedioNiveles :: Niveles -> Int
promedioNiveles (n1 ,n2, n3) = sumaNiveles (n1, n2, n3) `div` 3
