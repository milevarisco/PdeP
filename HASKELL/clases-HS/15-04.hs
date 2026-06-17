palabraPar :: String -> Bool
palabraPar cadena = ( even . length ) cadena

multiploDe :: Int -> Int -> Bool
multiploDe n1 n2 = mod n1 n2 == 0

palabraQuintuplo :: String -> Bool
palabraQuintuplo  = flip multiploDe 5 . length

lista1 :: [Int]
lista1 = [1,2,3,4]

-- ==========================================
-- RELACIÓN ENTRE [Char] Y String EN HASKELL
-- ==========================================
-- En Haskell, la palabra `String` es simplemente un "sinónimo" de `[Char]`.
-- Esto significa que un texto escrito entre comillas dobles es en realidad
-- una lista donde cada elemento es un caracter individual (entre comillas simples).

listaCaracteres :: [Char]
listaCaracteres = ['h', 'o', 'l', 'a']

-- Lo anterior es internamente IDÉNTICO a esto:
textoString :: String
textoString = "hola"

-- Al ser listas, ¡las funciones de listas como `length`, `head`, o `reverse` 
-- funcionan perfectamente en cualquier texto (String)!

listaTextos :: [String]
listaTextos = ["hola", "mundo", "haskell"]

listaBooleanos :: [Bool]
listaBooleanos = [True, False, True, False]

-- Las listas también pueden contener otras listas
listaDeListas :: [[Int]]
listaDeListas = [[1,2], [3,4,5], [6]]

-- ==========================================
-- TUPLAS Y LISTAS DE TUPLAS
-- ==========================================
-- Una tupla es una estructura que te permite agrupar varios valores en uno
-- solo, encerrándolos entre paréntesis `( )` y separando con comas.
--
-- DIFERENCIAS CLAVE CON LAS LISTAS:
-- 1. Tipos de datos: A diferencia de la lista (donde TODO debe ser del mismo tipo),
--    la tupla te permite mezclar tipos. Ej: Puedes tener un Int y un String juntos.
-- 2. Tamaño fijo: Cada tupla tiene un número fijo de elementos (dos, tres, cuatro...).
--    No cambian de tamaño.

-- Ejemplo de una tupla suelta:
unaTuplaSimple :: (Int, String)
unaTuplaSimple = (1, "uno")

tuplaDeTres :: (String, Bool, Int)
tuplaDeTres = ("Aprobado", True, 10)

-- ==========================================
-- LISTA DE TUPLAS
-- ==========================================
-- Es muy útil para hacer "diccionarios" o listas donde cada elemento asocia dos cosas
-- (como el número de alumno y su nombre). Es como una pequeña "tabla".
-- NOTA IMPORTANTE: Siguiendo la regla de oro de las listas (todos sus elementos deben ser del mismo tipo),
-- ¡todas las tuplas dentro de una lista deben respetar exactamente la misma estructura de tipos!

listaTuplas :: [(Int, String)]
listaTuplas = [(1, "uno"), (2, "dos"), (3, "tres"), (15, "quince")]

-- ==========================================
-- FUNCIONES !!, ++ y : (OPERADORES DE LISTAS)
-- ==========================================
-- 1. EL OPERADOR !! (ÍNDICE)
-- Sirve para sacar un elemento específico indicando su posición (empezando desde 0).
-- Ejemplo: lista1 !! 2   => Devuelve el '3' (posiciones: [0, 1, 2, 3])

ejemploIndice :: Int
ejemploIndice = lista1 !! 2

-- 2. EL OPERADOR ++ (CONCATENACIÓN)
-- Sirve para "pegar" o unir dos listas del mismo tipo, formando una sola más grande.
-- Ejemplo: [1, 2] ++ [3, 4] => Devuelve [1, 2, 3, 4]
-- ¡Recuerda que los textos son listas! Así que "Hola " ++ "mundo" funciona perfecto.

ejemploConcatenacion :: [Int]
ejemploConcatenacion = lista1 ++ [5, 6, 7]

-- 3. EL OPERADOR : (CONS, "Construct")
-- Sirve para agregar UN SOLO ELEMENTO al PRINCIPIO de una lista.
-- A la izquierda va el elemento suelto, y a la derecha la lista.
-- Ejemplo: 0 : [1, 2, 3] => Devuelve [0, 1, 2, 3]
-- También sirve para textos: 'A' : "nita" => Devuelve "Anita"

ejemploCons :: [Int]
ejemploCons = 0 : lista1

-- ==========================================
-- DICCIONARIO RÁPIDO DE FUNCIONES DE LISTAS
-- ==========================================

-- head :: [a] -> a
-- Devuelve el PRIMER elemento de la lista.
-- Ejemplo: head [1, 2, 3] => 1

-- tail :: [a] -> [a]
-- Devuelve toda la lista SIN el primer elemento ("la cola").
-- Ejemplo: tail [1, 2, 3] => [2, 3]

-- length :: Foldable t => t a -> Int   (Simplificado: [a] -> Int)
-- Devuelve la cantidad total de elementos.
-- Ejemplo: length [1, 2, 3] => 3

-- reverse :: [a] -> [a]
-- Da vuelta la lista completa de atrás para adelante.
-- Ejemplo: reverse [1, 2, 3] => [3, 2, 1]

-- take :: Int -> [a] -> [a]
-- "Toma" y te devuelve los primeros N elementos.
-- Ejemplo: take 2 [1, 2, 3, 4] => [1, 2]

-- drop :: Int -> [a] -> [a]
-- "Tira" o saltea los primeros N elementos y te devuelve el resto.
-- Ejemplo: drop 2 [1, 2, 3, 4] => [3, 4]

-- sum :: Num a => [a] -> a
-- Suma matemáticamente todos los números de la lista.
-- Ejemplo: sum [1, 2, 3] => 6

-- elem :: Eq a => a -> [a] -> Bool
-- Pregunta si un elemento existe dentro de la lista (True o False).
-- Ejemplo: elem 2 [1, 2, 3] => True

-- last :: [a] -> a 
-- Devuelve el ultimo elemento de la lista.
-- Ejemplo: last [1, 2, 3] => 3

-- init :: [a] -> [a]
-- Devuelve toda la lista menos el ultimo elemento.
-- Ejemplo: init [1, 2, 3] => [1, 2]

-- ==========================================
-- FUNCIONES DE ORDEN SUPERIOR CON LISTAS
-- ==========================================
-- 1. map :: (a -> b) -> [a] -> [b]
-- Aplica una transformación (función) a TODOS los elementos de la lista.
-- Ejemplo: map (*2) [1, 2, 3] => [2, 4, 6]

-- 2. filter :: (a -> Bool) -> [a] -> [a]
-- Se queda solamente con los elementos que cumplan una condición.
-- Ejemplo: filter even [1, 2, 3, 4] => [2, 4] (solo guarda los pares)

-- 3. all :: (a -> Bool) -> [a] -> Bool
-- Devuelve True si TODOS los elementos de la lista cumplen la condición.
-- Ejemplo: all even [2, 4, 6] => True

-- 4. any :: (a -> Bool) -> [a] -> Bool
-- Devuelve True si AL MENOS UN elemento de la lista cumple la condición.
-- Ejemplo: any even [1, 3, 5] => False (ninguno es par)

-- ==========================================
-- FUNCIONES ANÓNIMAS (LAMBDAS)
-- ==========================================
-- EXPRESIONES LAMBDA: sirven para crear funciones "al vuelo" o descartables.
-- ¿Por qué usarlas? Porque a veces necesitas una función muy simple para una sola cosa
-- y no vale la pena escribirla y ponerle nombre en otra parte del archivo.

-- ¿CÓMO SE ESCRIBEN? 
-- 1. Barra invertida `\` (representa la letra griega lambda λ).
-- 2. El parámetro o parámetros (`x`).
-- 3. Una flechita `->`.
-- 4. El cuerpo (lo que hace con ese parámetro).
-- Función tradicional: sumarTres x y z = x + y + z   
-- En forma Lambda:  (\x y z -> x + y + z)

-- ==========================================
-- EJEMPLOS EN EL MUNDO REAL (Con Orden Superior)
-- ==========================================

-- EJEMPLO 1 (con map): Queremos sumarle 10 a una lista de números.
-- Podríamos crear `sumarDiez n = n + 10` y hacer `map sumarDiez lista`.
-- O podemos hacerlo en una sola línea ahorrando espacio:
ejemploMapLambda :: [Int]
ejemploMapLambda = map (\numero -> numero + 10) [1, 2, 3]  -- => Devuelve [11, 12, 13]

-- EJEMPLO 2 (con filter): Queremos filtrar palabras largas (más de 4 letras).
ejemploFilterLambda :: [String]
ejemploFilterLambda = filter (\pal-> length pal > 4) ["sol", "haskell", "pdep"]  -- => Devuelve ["haskell"]

-- EJEMPLO 3 (con any): Saber si en la lista hay autos que arranquen con la letra 'F'.
ejemploAnyLambda :: Bool
ejemploAnyLambda = any (\auto -> head auto == 'F') ["Fiat", "Ford", "Audi"]  -- => Devuelve True


-- ==========================================
-- CURRIFICACIÓN Y APLICACIÓN PARCIAL
-- ==========================================

-- Tu intuición es 100% correcta: En Haskell, TODAS las funciones reciben 
-- ESTRICTAMENTE UN SOLO PARÁMETRO a la vez.

-- Si una función parece recibir 3 parámetros, internamente se ve así:
-- \x -> (\y -> (\z -> x + y + z))
-- (Una función que recibe un parámetro y devuelve OTRA función esperando al siguiente).

-- ¿PARA QUÉ SIRVE ESTO? -> Para hacer "Aplicación Parcial".
-- Si una función pide 2 cosas pero tú le pasas 1 sola, Haskell no te tira error...
-- Simplemente te "devuelve una nueva función" pre-cargada con el parámetro que ya le diste.

multiplicarNormal :: Int -> Int -> Int
multiplicarNormal a b = a * b

-- Si al map le pasáramos `multiplicarNormal 2`, estaríamos haciendo aplicación parcial.
-- El número `2` queda guardado en la `a`, y toda la expresión se transforma
-- mágicamente en una función que solo recibe un `b`.

ejemploCurrificar :: [Int]
ejemploCurrificar = map (multiplicarNormal 2) [10, 20, 30]  -- => Devuelve [20, 40, 60]

