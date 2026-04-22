-- ===========================EJERCICIO===============================

--PUNTO 1
-- Para unir Elemento y Compuesto en uno solo, creamos un único Tipo de Dato 
-- llamado Sustancia que tiene DOS constructores distintos:
data Sustancia = Elemento String Int String            -- nombre, num, grupo
               | Compuesto String String [Componente]  -- nombre, grupo, componentes
               deriving (Show, Eq)

-- Componente sigue siendo su propio tipo de dato porque es una parte de Compuesto
--                           nombre Cant.mol
data Componente = Componente String Int
    deriving (Show, Eq)

-- Ejemplos (Agregué los parámetros que faltaban para que no tire error en consola):
hidrogeno :: Sustancia
hidrogeno = Elemento "Hidrogeno" 1 "no metal"

oxigeno :: Sustancia
oxigeno = Elemento "Oxigeno" 8 "no metal"

agua :: Sustancia
agua = Compuesto "Agua" "no metal" [Componente "Hidrogeno" 2, Componente "Oxigeno" 1]

--PUNTO 2

-- Ahora la función puede recibir una Sustancia (que podrá ser Elemento o Compuesto)
conduceBien :: String -> Sustancia -> Bool
conduceBien _ (Elemento _ _ "metal") = True
conduceBien _ (Compuesto _ "metal" _) = True
conduceBien "calor" (Compuesto _ "halogeno" _) = True
conduceBien "electricidad" (Elemento _ _ "gas noble") = True
conduceBien _ _ = False

--PUNTO 3

nombreUnion :: String -> String
nombreUnion nombre
    | esVocal (last nombre) == False = nombre ++ "uro"
    | otherwise = reverse (dropWhile esVocal (reverse nombre)) ++ "uro"
    
-- PUNTO 4
combinar :: String -> String -> String
combinar nombre1 nombre2 = nombreUnion nombre1 ++ " de " ++ nombre2