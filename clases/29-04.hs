--------------------------------------------------------------------------------
-- CLASE 29-04: Recursividad, Listas, Pattern Matching y Funciones de Orden Superior
--------------------------------------------------------------------------------

-- =============================================================================
-- 1. RECURSIVIDAD
-- =============================================================================
-- Una función recursiva es aquella que se llama a sí misma para resolver 
-- un problema dividiéndolo en subproblemas más pequeños. Siempre necesita un
-- "caso base" para cortar la recursividad.

-- Usando guardas:
factorial :: Int -> Int 
factorial n
    | n == 0    = 1                               -- Caso Base
    | otherwise = n * factorial (n - 1)           -- Caso Recursivo

-- Usando Pattern Matching (más idiomático y claro):
factorial' :: Int -> Int
factorial' 0 = 1                                  -- Caso Base
factorial' n = n * factorial' (n - 1)             -- Caso Recursivo


-- =============================================================================
-- 2. DEFINICIÓN DE LISTAS
-- =============================================================================
-- Ahora que vimos 'data', podemos entender cómo se definen las listas.
-- Internamente, una lista se define de forma recursiva como:
--
--    data [a] = [] | a : [a]
--
-- Es decir, una lista de tipo 'a' puede ser:
--   1. []       -> Una lista vacía.
--   2. a : [a]  -> Un elemento de tipo 'a' pegado (cons) a una lista de tipo 'a'.

-- Obtener el primer elemento (head):
cabeza :: [a] -> a
cabeza (x : xs) = x

-- Obtener el resto de la lista (tail):
cola :: [a] -> [a]
cola (x : xs) = xs


-- =============================================================================
-- 3. FUNCIONES DE LISTAS (Usando Pattern Matching y Recursividad)
-- =============================================================================
-- Al trabajar con listas, el caso base suele ser la lista vacía ([]), 
-- y el caso recursivo divide la lista en cabeza (x) y cola (xs).

tamaño :: [a] -> Int                -- Equivalente a 'length'
tamaño []     = 0                   
tamaño (x:xs) = 1 + tamaño xs

revertir :: [a] -> [a]              -- Equivalente a 'reverse'
revertir []     = []                
revertir (x:xs) = revertir xs ++ [x]

concatenar :: [a] -> [a] -> [a]     -- Equivalente a '(++)'
concatenar []     lista2 = lista2   
concatenar (x:xs) lista2 = x : concatenar xs lista2

sumarLista :: Num a => [a] -> a     -- Equivalente a 'sum'
sumarLista []     = 0               
sumarLista (x:xs) = x + sumarLista xs

productoLista :: Num a => [a] -> a  -- Equivalente a 'product'
productoLista []     = 1            
productoLista (x:xs) = x * productoLista xs

y :: [Bool] -> Bool                 -- Equivalente a 'and'
y []     = True                     
y (x:xs) = x && y xs

o :: [Bool] -> Bool                 -- Equivalente a 'or'
o []     = False                    
o (x:xs) = x || o xs

concatenarListas :: [[a]] -> [a]    -- Equivalente a 'concat'
concatenarListas []         = []    
concatenarListas (xs : xss) = xs `concatenar` concatenarListas xss


-- =============================================================================
-- 4. FUNCIONES DE ORDEN SUPERIOR (Plegado, Mapeo y Filtrado)
-- =============================================================================

-- A) PLEGADO (foldr / foldl)
-- Notamos que todas las funciones anteriores siguen el mismo patrón:
-- toman un caso base y aplican una operación entre 'x' y la recursión en 'xs'.
-- Podemos abstraer ese patrón en una función de orden superior: 'plegar' (foldr).

plegar :: (a -> b -> b) -> b -> [a] -> b  -- Equivalente a 'foldr'
plegar operador casoBase []     = casoBase  
plegar operador casoBase (x:xs) = operador x (plegar operador casoBase xs)

-- ¡Ahora podemos redefinir todas las funciones anteriores en una sola línea!
sumarListas'      = plegar (+) 0
productoLista'    = plegar (*) 1
y'                = plegar (&&) True
o'                = plegar (||) False
concatenarListas' = plegar (++) []

-- Implementación de 'length' con foldr:
-- En cada paso, descartamos el elemento (\_ ...) y sumamos 1 al resultado recursivo ('r').
tamaño' :: [a] -> Int
tamaño' = plegar (\_ r -> 1 + r) 0 

-- Tipos de las funciones fold de la biblioteca estándar de Haskell:
-- foldr :: (a -> b -> b) -> b -> [a] -> b  (Asocia por derecha / Fold Right)
-- foldl :: (b -> a -> b) -> b -> [a] -> b  (Asocia por izquierda / Fold Left)

{- 
=============================================================================
DIFERENCIAS DETALLADAS ENTRE foldr Y foldl (Para PdeP)
=============================================================================

1. DIRECCIÓN DE ASOCIACIÓN (Agrupación de paréntesis)
   - foldr (Right): Empieza a operar desde el último elemento (derecha) hacia el primero.
     Ejemplo: foldr (-) 0 [1, 2, 3] 
              => 1 - (2 - (3 - 0)) 
              => 1 - (2 - 3) 
              => 1 - (-1) 
              => 2

   - foldl (Left): Empieza a operar desde el primer elemento (izquierda) usando la semilla.
     Ejemplo: foldl (-) 0 [1, 2, 3] 
              => ((0 - 1) - 2) - 3 
              => (-1 - 2) - 3 
              => -3 - 3 
              => -6

2. FIRMA DE LA FUNCIÓN DE COMBINACIÓN
   - foldr: El operador/función toma el ELEMENTO de la lista primero, y el ACUMULADOR después:
            f :: (Elemento -> Acumulador -> Acumulador)
   - foldl: El operador/función toma el ACUMULADOR primero, y el ELEMENTO de la lista después:
            f :: (Acumulador -> Elemento -> Acumulador)

3. COMPORTAMIENTO CON LISTAS INFINITAS (Lazy Evaluation)
   - foldr puede trabajar con listas infinitas si el operador es "perezoso" (lazy) en su segundo
     argumento (el acumulador). Esto se debe a que puede "cortar" la evaluación sin mirar el resto.
     Ejemplo: foldr (||) False (True : repetidosTrue) => True || (foldr (||) False repetidosTrue)
              Como (True || _) es siempre True, Haskell no evalúa el resto de la lista infinita.
   - foldl NO puede trabajar con listas infinitas. Al asociar por izquierda, necesita llegar al final
     de la lista para poder empezar a resolver el paréntesis más externo. Con listas infinitas,
     entra en un bucle infinito (o Stack Overflow).

4. VARIANTES ÚTILES:
   - foldr1 / foldl1: Variantes para cuando NO tenemos un caso base (semilla) lógico.
     Toman el primer elemento de la lista (o el último, según corresponda) como semilla inicial.
     *¡Ojo!* Explotan con listas vacías (error: Empty list).
     Ejemplo: foldl1 max [3, 5, 2] => 5

-}


-- B) MAPEO (map)
-- Aplica una función 'f' a cada elemento de la lista.
mapear :: (a -> b) -> [a] -> [b]    -- Equivalente a 'map'
mapear f []     = []               
mapear f (x:xs) = f x : mapear f xs


-- C) FILTRADO (filter)
-- Retorna una nueva lista sólo con los elementos que cumplen la 'condicion'.
filtrar :: (a -> Bool) -> [a] -> [a] -- Equivalente a 'filter'
filtrar condicion [] = []                  
filtrar condicion (x:xs)
    | condicion x = x : filtrar condicion xs
    | otherwise   = filtrar condicion xs