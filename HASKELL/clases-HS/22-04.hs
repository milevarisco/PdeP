-- ==========================================
-- =        CLASE: 22 de Abril              =
-- ==========================================

-- ==========================================
-- 1. TIPOS DE DATOS Y CONSTRUCTORES
-- ==========================================
-- 'data' nos permite crear nuestras propias estructuras de datos.

-- A la izquierda de la igualdad está el Tipo de Dato.
-- A la derecha está el Constructor (la función/etiqueta para crear los valores).

-- Ejemplo: Constructor Simple
data Elemento = Elemento String Int
   deriving (Show, Eq)

hidrogeno :: Elemento
hidrogeno = Elemento "Hidrogeno" 1

oxigeno :: Elemento
oxigeno = Elemento "Oxigeno" 8


-- ==========================================
-- 2. ALIAS DE TIPO (type)
-- ==========================================
-- A diferencia de 'data' que crea un tipo NUEVO, 'type' solo le da un 
-- nombre amigable (un alias) a un tipo que ya existe, como una matemática Tupla.

type ElementoTupla = (String, Int, String)

helio :: ElementoTupla
helio = ("helio", 2, "He") -- TUPLA


-- ==========================================
-- 3. CONSTRUCTORES COMPLEJOS (Composición)
-- ==========================================
-- Un constructor puede recibir adentro otras estructuras que hayamos inventado,
-- o variables complejas como listas [ ]. ¡Esto es clave para anidar información!

data Componente = Componente String Int
    deriving (Show, Eq)

-- Compuesto recibe: Nombre (String), Grupo (String), y Componentes (Una Lista).
data Compuesto = Compuesto String String [Componente]
    deriving (Show, Eq)

agua :: Compuesto
agua = Compuesto "Agua" "no metal" [Componente "Hidrogeno" 2, Componente "Oxigeno" 1]

-- ==========================================
-- 3.B DATOS CON MÚLTIPLES CONSTRUCTORES
-- ==========================================
-- Además de todo lo anterior, podemos tener un mismo Tipo de Dato general que 
-- englobe a distintos constructores. Para separarlos usamos una barra vertical ( | ).

-- (Lo comento abajo para que no de error al compilar chocando con los que ya
-- creaste arriba, pero la estructura en tu código quedaría así):

-- data Sustancia = Elemento String Int String            -- nombre, num, grupo
--                | Compuesto String String [Componente]  -- nombre, grupo, componentes
--                deriving (Show, Eq)

-- De esa forma, una función que en sus parámetros pida una "Sustancia",
-- va a aceptar tranquilamente tanto a un Elemento como a un Compuesto.


-- ==========================================
-- 4. PATTERN MATCHING (Encaje de Patrones)
-- ==========================================
-- Sirve para definir qué hace una función buscando "coincidencias" entre el 
-- dato que recibe y un "patrón" esperado. Siempre evalúa de ARRIBA hacia ABAJO.

-- A) Pattern Matching con valores exactos (literales)
esVocal :: Char -> Bool
esVocal 'a' = True  
esVocal 'e' = True
esVocal 'i' = True
esVocal 'o' = True
esVocal 'u' = True
-- Variable atrapalotodo: Atrapa a cualquier otra cosa que no encajó con los literales.
esVocal letra = False 
-- (Si la variable 'letra' no la vamos a usar a la derecha del '=', solemos usar el comodín "_")


-- B) Pattern Matching para "desarmar" Constructores
-- Sirve para sacar "lo de adentro" de un data sin necesitar crear una función 'getter'.
numeroAtomico :: Elemento -> Int
numeroAtomico (Elemento valor _) = valor
-- (Solo nos importa la primer parte. Usamos el comodín `_` para ignorar el nombre)


-- ==========================================
-- 5. PATTERN MATCHING EN LISTAS (Cabeza : Cola)
-- ==========================================
-- Las listas se pueden separar en (cabeza : cola). 
-- 'cabeza' es SIEMPRE el 1er elemento entero. 'cola' es SIEMPRE el resto de la lista.

-- Ejemplos rápidos de cómo atajar una lista por parámetro en tu función:
-- funcion (cabeza : _) = cabeza       -- Me quedo solo con primero
-- funcion ( _ : cola) = cola          -- Me quedo con todo excepto el primero
-- funcion (c1 : c2 : cola) = c2       -- Me quedo solo con EL SEGUNDO
-- funcion [] = ...                    -- Atajo cuando la lista está vacía


-- ==========================================
-- 6. GUARDAS (|)
-- ==========================================
-- A diferencia del Pattern Matching (que compara estructuras o valores exactos),
-- las Guardas evalúan CONDICIONES lógicas (ej: > 0, == 2).
-- Entra siempre a la primera de arriba hacia abajo que dé True.

valorAbsoluto :: Int -> Int
valorAbsoluto num 
    | num >= 0  = num    -- "Si num es mayor o igual a 0, devolvelo tal cual"
    | num < 0   = -num   -- "Si num es menor a 0, devolvelo negativo para positivar"
-- OJO: No va NUNCA un '=' al definir la función antes de las guardas. El '=' va en cada guarda.

-- 'otherwise' significa "en cualquier otro caso" (equivale a decir 'True').
clasificarNumero :: Int -> String
clasificarNumero x
    | x > 0     = "Es positivo"
    | x < 0     = "Es negativo"
    | otherwise = "Es cero"   -- Atrapa si todo lo anterior dio Falso
