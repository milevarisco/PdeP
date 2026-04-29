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

cOxigeno = Componente "Oxigeno" 3
cHidrogeno = Componente "Hidrogeno" 4
--PUNTO 2

-- Ahora la función puede recibir una Sustancia (que podrá ser Elemento o Compuesto)
conduceBien :: String -> Sustancia -> Bool
conduceBien _ (Elemento _ _ "metal") = True
conduceBien _ (Compuesto _ "metal" _) = True
conduceBien "calor" (Compuesto _ "halogeno" _) = True
conduceBien "electricidad" (Elemento _ _ "gas noble") = True
conduceBien _ _ = False

--PUNTO 3

esVocal :: Char -> Bool
esVocal 'a' = True  
esVocal 'e' = True
esVocal 'i' = True
esVocal 'o' = True
esVocal 'u' = True
esVocal _ = False 

nombreUnion :: String -> String
nombreUnion nombre
    | esVocal (last nombre) == False = nombre ++ "uro"
    | otherwise = reverse (dropWhile esVocal (reverse nombre)) ++ "uro"
    
-- PUNTO 4
combinar :: String -> String -> String
combinar nombre1 nombre2 = nombreUnion nombre1 ++ " de " ++ nombre2

--PUNTO 5
mezclar :: [Componente] -> [Componente] -> Sustancia
mezclar c1 c2 = Compuesto (foldl1 combinar $ nombresLista (c1 ++ c2)) "no metal" (c1 ++ c2)

nombreComponente :: Componente -> String
nombreComponente (Componente nombre _) = nombre

nombresLista :: [Componente] -> [String]
nombresLista lista = map nombreComponente lista

