{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
{-# HLINT ignore "Use foldr1" #-}
{-# HLINT ignore "Use all" #-}
{-# HLINT ignore "Redundant ==" #-}

module Clase_06_05 where

-- Importamos este módulo para que Haskell sepa cómo "mostrar" (show) funciones.
-- Por defecto, Haskell no puede imprimir funciones por consola. Al importar esto,
-- las funciones se imprimen simplemente como "<function>". Esto es súper útil
-- cuando tenemos estructuras de datos que contienen funciones dentro (como la Casa con reguladores).
import Text.Show.Functions

-- ============================================================================
-- TEMA 1: FOLD / REDUCCIÓN Y FOLD1
-- ============================================================================

-- | foldr1' es una variante de foldr.
-- La diferencia clave es que foldr1 no necesita una "semilla" (valor inicial) explícita.
-- En su lugar, toma el primer elemento de la lista (en este caso 'x', al desestructurar 'x:xs')
-- como la semilla inicial, y luego aplica foldr sobre el resto de la lista ('xs').
-- Nota: Lanza un error si la lista está vacía.
foldr1' :: (a -> a -> a) -> [a] -> a
foldr1' f (x : xs) = foldr f x xs
foldr1' _ []       = error "foldr1': lista vacia"


-- ============================================================================
-- TEMA 2: LISTAS Y RANGOS (INFINITOS Y DEFINIDOS)
-- ============================================================================

-- | Definición recursiva manual de una lista desde 'n' hasta 'm'.
-- NOTA IMPORTANTE: Esta implementación asume que vamos de menor a mayor (n <= m).
-- Si pasamos 'm < n' (por ejemplo, 'lista 5 1'), la condición de parada 'n == m' nunca
-- se cumplirá porque 'n' se incrementa infinitamente ('n + 1'). Esto produce un bucle infinito
-- y el programa nunca terminará (se cuelga por recursión infinita).
lista :: (Ord a, Num a) => a -> a -> [a]
lista n m
    | n == m    = [n]
    | otherwise = n : lista (n + 1) m

-- --- USO DE RANGOS NATIVOS DE HASKELL (..) ---
-- Haskell provee azúcar sintáctico muy potente para crear listas con elementos enumerables:

-- | Lista del 1 al 10: [1,2,3,4,5,6,7,8,9,10]
rangoSimple :: [Integer]
rangoSimple = [1 .. 10]

-- | Lista con un "paso" (step) de 2. Va del 2 al 10 saltando de a 2: [2,4,6,8,10]
rangoConPaso :: [Integer]
rangoConPaso = [2, 4 .. 10]

-- | Lista infinita que empieza en 1: [1,2,3,4,5,...] (gracias a Lazy Evaluation)
rangoInfinito :: [Integer]
rangoInfinito = [1 ..]


-- ============================================================================
-- TEMA 3: EVALUACIÓN DIFERIDA (LAZY EVALUATION) Y LISTAS INFINITAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3.1 TRABAJO CON LISTAS INFINITAS
-- ----------------------------------------------------------------------------

-- | Genera una lista infinita que contiene únicamente el elemento 'n'.
-- Como la recursividad no tiene caso base, la lista generada es infinitamente larga.
muchosDe :: a -> [a]
muchosDe n = n : muchosDe n

-- Si consultamos directamente en el intérprete:
-- λ muchosDe 5
-- Esta expresión no terminaría nunca de imprimir, ya que no hay un punto de corte.
-- Sin embargo, gracias a la Evaluación Diferida, podemos usarla en contextos que acotan la ejecución:

-- | Devuelve el primer elemento de la lista infinita.
-- Evaluación diferida permite que esto termine inmediatamente con valor 5 sin evaluar el resto de la lista.
-- λ (head . muchosDe) 5 -> devuelve 5
ejemploHeadMuchosDe :: Integer
ejemploHeadMuchosDe = (head . muchosDe) 5

-- | Toma los primeros 10 elementos de la lista infinita (generando [5,5,5,5,5,5,5,5,5,5]) y los suma.
-- Retorna 50.
-- λ (sum . take 10 . muchosDe) 5 -> devuelve 50
ejemploSumTake10MuchosDe :: Integer
ejemploSumTake10MuchosDe = (sum . take 10 . muchosDe) 5

-- | Si el algoritmo diverge (no se acota la necesidad de elementos), Haskell no puede evitar el bucle:
-- λ (sum . muchosDe) 5 -- ¡ATENCIÓN! Si se ejecuta, no termina nunca porque intenta sumar infinitos 5.


-- ----------------------------------------------------------------------------
-- 3.2 ¿QUÉ ES LA EVALUACIÓN DIFERIDA / PEREZOSA (LAZY EVALUATION)?
-- ----------------------------------------------------------------------------

{-
   Como estamos acostumbrados a trabajar en lenguajes con evaluación ansiosa (eager evaluation),
   nos resulta sumamente extraño pensar que una expresión sobre algo infinito pueda converger
   a un valor final sin entrar en un bucle sin fin.

   La EVALUACIÓN DIFERIDA consiste en evaluar los argumentos de las funciones únicamente a medida
   que son necesarios para el cálculo final, postergando su cálculo al máximo.

   --- LA ANALOGÍA DEL FERRETERO Y EL CABLE ---
   Imaginemos que vamos a una ferretería a comprar 10 cm de cable de un rollo que mide 100 metros:
   
   - El Ferretero Ansioso (Eager Evaluation):
     Primero desenrolla y mide los 100 metros completos de cable a lo largo de todo el local,
     y recién entonces realiza el corte de los 10 cm que le pedimos. Hace un esfuerzo inmenso, 
     innecesario, y si el rollo fuera infinito se quedaría desenrollando cable por siempre sin 
     entregarnos nada.
     
   - El Ferretero Diferido (Lazy Evaluation):
     Toma el rollo, saca únicamente los 10 cm solicitados, los corta y nos los entrega. El resto
     del cable (los 99.9 metros sobrantes) sigue enrollado e intacto. No le importa si el rollo tiene 
     100 metros o es infinito, él solo trabaja con lo requerido. Nosotros preferimos este ferretero.
-}


-- ----------------------------------------------------------------------------
-- 3.3 VENTAJAS Y LIMITACIONES DE LA EVALUACIÓN DIFERIDA
-- ----------------------------------------------------------------------------

{-
   En los lenguajes imperativos estamos acostumbrados a que las cosas funcionen de forma ansiosa,
   pero en el paradigma funcional se nos abre una nueva puerta:

   1. Evaluación minimalista: Con la evaluación diferida sólo se evalúa aquello que realmente se necesita.
   2. Estructuras infinitas: Como corolario, se puede trabajar de forma natural con estructuras
      potencialmente infinitas (como listas), mientras se asegure que el algoritmo final converge.
   3. Garantía de funcionamiento ("Si puede andar, anda"): Si una expresión puede ejecutarse de alguna
      manera sin fallar, con evaluación diferida seguro que andará. Si el programa se rompe o entra
      en un loop, es porque estrictamente necesitamos evaluar algo que divergía o fallaba.

   --- ¿POR QUÉ NO TENEMOS EVALUACIÓN DIFERIDA EN LENGUAJES COMO C? ---
   La respuesta fundamental es: EL EFECTO COLATERAL (Side Effects).
   En C o Java, evaluar una expresión suele tener efectos secundarios (modificar variables en memoria,
   escribir un archivo, imprimir texto). Si modificáramos el orden o decidiéramos no evaluar ciertos
   argumentos de forma diferizada, el estado global de la aplicación se volvería impredecible.
   
   Funcional es un paradigma atemporal: al ser un paradigma puro sin efectos secundarios, se relaja
   por completo la idea de secuencia estricta. No hay un "antes" ni un "después" en la evaluación 
   de una función matemática. Esto habilita que Haskell pueda evaluar libremente sólo lo que necesite,
   cuando lo necesite, sin alterar el resultado del resto del mundo.
-}


-- ----------------------------------------------------------------------------
-- 3.4 FUNCIONES COMUNES PARA GENERAR LISTAS INFINITAS NATIVAS
-- ----------------------------------------------------------------------------

-- | repeat: Repite un valor infinitamente.
-- repeat 5 -> [5, 5, 5, 5, ...]
ejemploRepeat :: [Integer]
ejemploRepeat = repeat 5

-- | replicate: Repite algo una cantidad finita de veces.
-- replicate 3 5 -> [5, 5, 5]
ejemploReplicate :: [Integer]
ejemploReplicate = replicate 3 5

-- | cycle: Toma una lista y la concatena infinitamente.
-- cycle [1, 2] -> [1, 2, 1, 2, 1, 2, ...]
ejemploCycle :: [Integer]
ejemploCycle = cycle [1, 2]

-- | iterate: Itera una función con un valor de partida infinitamente.
-- iterate (+1) 0 -> [0, 1, 2, 3, 4, ...]
ejemploIterate :: [Integer]
ejemploIterate = iterate (+1) 0


-- ----------------------------------------------------------------------------
-- 3.5 UN CASO ESPECIAL DE EVALUACIÓN DIFERIDA CON FILTER
-- ----------------------------------------------------------------------------

-- | EJEMPLO DE BUCLE INFINITO INESPERADO CON FILTER:
-- ¿Por qué esta expresión se queda colgada y nunca termina?
-- expresionColgada = take 4 $ filter (< 0) [-3 ..]
--
-- EXPLICACIÓN:
-- 1. `[-3 ..]` genera una lista infinita: `[-3, -2, -1, 0, 1, 2, 3, 4, ...]`.
-- 2. `filter (< 0)` evalúa secuencialmente los elementos para ver si son menores a 0:
--    - Evalúa -3: -3 < 0 es True. Se queda con [-3]
--    - Evalúa -2: -2 < 0 es True. Se queda con [-3, -2]
--    - Evalúa -1: -1 < 0 es True. Se queda con [-3, -2, -1]
--    - Evalúa 0: 0 < 0 es False. Lo descarta.
--    - Evalúa 1: 1 < 0 es False. Lo descarta.
--    - Y así sucesivamente con todos los números positivos infinitos.
-- 3. `take 4` necesita tomar exactamente 4 elementos del resultado del filter.
-- 4. Como ya obtuvo 3 elementos (`[-3, -2, -1]`), se queda esperando por un cuarto.
-- 5. Dado que todos los números siguientes en `[-3 ..]` son mayores o iguales a 0,
--    el `filter` seguirá buscando eternamente en la lista infinita sin encontrar jamás otro elemento < 0.
--    Por lo tanto, la ejecución entra en un bucle infinito buscando ese cuarto elemento.
ejemploFiltroInfinito :: [Integer]
ejemploFiltroInfinito = take 3 $ filter (< 0) [-3 ..] -- Esta versión con take 3 SÍ termina y devuelve [-3, -2, -1]


-- ============================================================================
-- TEMA 4: TRANSPARENCIA REFERENCIAL
-- ============================================================================

doble :: Num a => a -> a
doble x = x + x

{-
   ¿Cómo evalúa Haskell la expresión `doble (2 + 3)`?
   
   Gracias a la EVALUACIÓN DIFERIDA (Lazy Evaluation), los argumentos no se evalúan antes de
   entrar a la función, sino sólo cuando hacen falta para el cómputo final:
   
   1. doble (2 + 3)
   2. (2 + 3) + (2 + 3)   -- Reemplaza la definición de 'doble'
   3. 5 + 5               -- Evalúa las expresiones cuando el operador (+) lo requiere
   4. 10
   
   La TRANSPARENCIA REFERENCIAL significa que el valor de una expresión depende únicamente de
   sus subexpresiones y no de ningún estado externo o efecto colateral. Por ende, una llamada a
   una función siempre puede ser reemplazada por su resultado (o su definición equivalente) sin
   alterar el comportamiento del programa.
   
   ¿Cuál es la relación entre ambas?
   - Gracias a que tenemos Transparencia Referencial (pureza matemática, sin efectos secundarios),
     es completamente seguro evaluar las expresiones de forma diferida (cuando queramos, o incluso
     nunca si no se necesitan).
   - En un lenguaje imperativo con efectos secundarios (ej. que imprima en pantalla o cambie una
     variable global), el orden de evaluación importa muchísimo. En Haskell, al ser puro, el orden
     no cambia el resultado, habilitando la evaluación diferida de forma segura.
-}


-- ============================================================================
-- TEMA 5: CÓDIGO DISFUNCIONAL VS. CÓDIGO DECLARATIVO (SMELLS & REFACTORS)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CASO 1: Comparaciones redundantes con booleanos
-- ----------------------------------------------------------------------------

-- MALA PRÁCTICA:
tieneNombreLargo :: (String, a) -> Bool
tieneNombreLargo mascota = (length (fst mascota) > 9) == True
-- OLOR DE CÓDIGO (Smell): Comparar una condición booleana con '== True' es totalmente
-- redundante, ya que la condición por sí misma ya evalúa a True o False.

-- CÓDIGO DECLARATIVO (Mejorado con Composición y Point-Free):
tieneNombreLargo' :: (String, a) -> Bool
tieneNombreLargo' = (> 9) . length . fst
-- Explicación:
-- 1. 'fst' extrae la primera componente (el nombre de la mascota).
-- 2. 'length' calcula su tamaño.
-- 3. '(> 9)' verifica si es mayor que 9.
-- Todo esto está compuesto con el operador punto (.) de derecha a izquierda.

-- ----------------------------------------------------------------------------
-- CASO 2: Funciones parciales (Incompletas)
-- ----------------------------------------------------------------------------

-- MALA PRÁCTICA:
poderDeEspada :: (Ord a, Num a, Num b) => a -> b
poderDeEspada largoDeHoja
  | largoDeHoja > 20 = 100
  | largoDeHoja > 10 = 50
-- OLOR DE CÓDIGO: ¿Qué pasa si la hoja mide 5? Al no haber un caso por defecto (guardia 'otherwise'),
-- Haskell lanzará una excepción en tiempo de ejecución: "Non-exhaustive patterns".
-- Corrección: Siempre debemos garantizar que nuestras funciones sean "totales" agregando
-- un caso por defecto o manejando todos los escenarios posibles.

poderDeEspadaSeguro :: (Ord a, Num a, Num b) => a -> b
poderDeEspadaSeguro largoDeHoja
  | largoDeHoja > 20 = 100
  | largoDeHoja > 10 = 50
  | otherwise        = 0  -- Guardia por defecto para evitar caídas catastróficas

-- ----------------------------------------------------------------------------
-- CASO 3: Modelado de Datos y Modificaciones Manuales (Uso de Records)
-- ----------------------------------------------------------------------------

-- Modelo inicial utilizando tipos posicionales (tuplas con nombre):
data Persona = Persona String Int Int String deriving (Show)

-- MALA PRÁCTICA (Actualizar campos posicionales manualmente):
sumarEnergia :: Persona -> Persona
sumarEnergia (Persona nombre energia edad apodo) =
    Persona nombre (energia + 5) edad apodo
-- OLOR DE CÓDIGO: Si en el futuro agregamos un nuevo campo a Persona (por ejemplo, email),
-- esta función se romperá y tendremos que reescribir tanto la desestructuración de la izquierda
-- como la reconstrucción de la derecha. Es poco mantenible.

-- Auxiliar para extraer edad de Persona posicional (antes estaba como undefined)
edad :: Persona -> Int
edad (Persona _ _ e _) = e

-- ----------------------------------------------------------------------------
-- CASO 4: Composición y Simplificación Point-Free
-- ----------------------------------------------------------------------------

-- CÓDIGO COMÚN (con parámetro explícito):
triplicarLosPares :: Integral a => [a] -> [a]
triplicarLosPares numeros = (map (* 3) . filter even) numeros

-- CÓDIGO POINT-FREE (Más elegante y declarativo, sin mencionar la lista 'numeros'):
triplicarLosPares' :: Integral a => [a] -> [a]
triplicarLosPares' = map (* 3) . filter even

-- ----------------------------------------------------------------------------
-- CASO 5: Errores comunes con Higher-Order Functions (all vs map)
-- ----------------------------------------------------------------------------

esMamifero :: a -> Bool
esMamifero = const True

-- ERROR DE COMPILACIÓN (Originalmente comentado):
-- sonTodosMamiferos animales = all (map esMamifero animales) animales
--
-- ¿Por qué NO TIPABA?
-- La firma de 'all' es: all :: (a -> Bool) -> [a] -> Bool
-- Espera un predicado (una función `a -> Bool`) como primer argumento.
-- Sin embargo, `map esMamifero animales` evalúa a una lista de booleanos `[Bool]`.
-- Pasar un `[Bool]` en lugar de una función `(a -> Bool)` causa el error de tipos.

-- SOLUCIÓN 1 (Poco declarativa, usa composición para evaluar todo y aplicar 'and'):
sonTodosMamiferos' :: [a] -> Bool
sonTodosMamiferos' animales = (and . map esMamifero) animales

-- SOLUCIÓN 2 (La más declarativa e idiomática, delegando en 'all'):
sonTodosMamiferos'' :: [a] -> Bool
sonTodosMamiferos'' animales = all esMamifero animales

-- SOLUCIÓN 3 (Point-free de la solución anterior):
sonTodosMamiferos''' :: [a] -> Bool
sonTodosMamiferos''' = all esMamifero


-- ============================================================================
-- TEMA 6: RECORD SYNTAX (SINTAXIS DE REGISTROS)
-- ============================================================================

{-
   En vez de definir estructuras posicionales como:
   data Casa' = Casa' String Int [Casa' -> Casa']
   
   Haskell nos permite usar Record Syntax (Sintaxis de Registros).
   Esto nos da:
   1. Mayor claridad visual sobre qué significa cada campo.
   2. Creación automática de funciones "getter" para cada campo.
      Por ejemplo: `direccion :: Casa -> String` ya está definida automáticamente.
-}

data Casa = Casa {
    direccion :: String,
    temperatura :: Int,
    reguladores :: [Casa -> Casa]  -- Lista de funciones modificadoras
} deriving (Show)

-- --- EFECTO DE REGULADORES DE LA CASA ---

abrirVentanas :: Casa -> Casa
abrirVentanas casa = casa { temperatura = temperatura casa - 2 }

prenderEstufa :: Casa -> Casa
prenderEstufa casa = casa { temperatura = temperatura casa + 3 }

encenderElAireA :: Int -> Casa -> Casa
encenderElAireA tempObjetivo casa = casa { temperatura = tempObjetivo }

mudarseA :: String -> Casa -> Casa
mudarseA nuevaDireccion casa = casa { direccion = nuevaDireccion }

-- Ejemplo de Casa Inteligente.
-- Observación: La lista de reguladores contiene funciones.
-- Algunas son aplicadas parcialmente, como `mudarseA "calle falsa 123"` (que espera una Casa)
-- y `encenderElAireA 24` (que espera una Casa). Gracias al currying y aplicación parcial,
-- todas estas funciones terminan teniendo la firma unificada `Casa -> Casa`.
miCasaInteligente :: Casa
miCasaInteligente = Casa {
    direccion = "Medrano 951",
    temperatura = 26,
    reguladores = [
            abrirVentanas,
            prenderEstufa,
            mudarseA "calle falsa 123",
            encenderElAireA 24
        ]
   }

-- --- FORMAS DE ACTUALIZAR CAMPOS DE UN RECORD ---

-- MALA PRÁCTICA 1: Reescribir todos los campos explícitamente.
-- Esto anula la gracia de usar records, ya que tenemos que volver a setear todo.
abrirVentanasOriginal :: Casa -> Casa
abrirVentanasOriginal casa =
  casa { direccion = direccion casa,
         temperatura = temperatura casa - 2,
         reguladores = reguladores casa }

-- MALA PRÁCTICA 2: Desestructuración posicional en el patrón.
-- Si cambiamos la estructura de la Casa agregando un campo, esto se rompe.
abrirVentanasPosicional :: Casa -> Casa
abrirVentanasPosicional (Casa dir temp reg) = Casa dir (temp - 2) reg

-- BUENA PRÁCTICA: Record Update Syntax (Sintaxis de actualización de registros).
-- Solo especificamos los campos que cambian. Los demás se mantienen intactos automáticamente.
-- Es mucho más declarativo y robusto ante cambios en el tipo de dato.
abrirVentanasModerna :: Casa -> Casa
abrirVentanasModerna casa = casa { temperatura = temperatura casa - 2 }


-- ============================================================================
-- TEMA 7: DECLARATIVIDAD VS. RECURSIÓN MANUAL
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Ejemplo A: Pattern Matching Declarativo básico
-- ----------------------------------------------------------------------------
esBeatle :: String -> Bool
esBeatle "Ringo"  = True
esBeatle "John"   = True
esBeatle "George" = True
esBeatle "Paul"   = True
esBeatle _        = False

-- ----------------------------------------------------------------------------
-- Ejemplo B: Recorrer listas y operar sobre ellas
-- ----------------------------------------------------------------------------

-- ENFOQUE IMPERATIVO / RECURSIVO SUCIO (Evitar en Haskell):
-- Usa funciones parciales como 'head' y 'drop 1' para recorrer la lista como si fuera un array.
-- Es poco declarativo y propenso a fallar si no se cuidan los casos vacíos.
sumaDeLasEdades :: [Persona] -> Int
sumaDeLasEdades [] = 0
sumaDeLasEdades lista = edad (head lista) + sumaDeLasEdades (drop 1 lista)

-- ENFOQUE RECURSIVO LIMPIO (Con Pattern Matching):
-- Usa la desestructuración de listas '(e:es)'. Es el estándar para recursión manual.
sumaDeLasEdades' :: [Persona] -> Int
sumaDeLasEdades' []       = 0
sumaDeLasEdades' (e : es) = edad e + sumaDeLasEdades' es

-- ENFOQUE MÁS DECLARATIVO Y EXPRESIVO (Abstracciones de Alto Nivel):
-- Evitamos la recursión manual por completo delegando en map y sum.
-- Mucho más fácil de leer, mantener y libre de errores recursivos.
sumaDeLasEdades'' :: [Persona] -> Int
sumaDeLasEdades'' edades = (sum . map edad) edades

-- Versión Point-Free de la anterior:
sumaDeLasEdades''' :: [Persona] -> Int
sumaDeLasEdades''' = sum . map edad


-- ============================================================================
-- TEMA 8: EXPRESIVIDAD EN EL CÓDIGO (CÓDIGO LEGIBLE)
-- ============================================================================

-- CÓDIGO DIFICIL DE LEER (Poco expresivo):
-- Nombres de variables crípticos y exceso de paréntesis que dificultan entender la intención.
j :: Integral a => [a] -> Bool
j r = sum (map (*3) (filter even r)) < 100

-- CÓDIGO EXPRESIVO (Declarativo, autoexplicativo):
-- El nombre de la función expresa la intención del negocio.
-- El uso de composición y aplicación parcial ($) aclara el flujo de los datos.
esMenorA100LaSumaDelTripleDeLosPares :: Integral a => [a] -> Bool
esMenorA100LaSumaDelTripleDeLosPares numeros =
    (< 100) . sum . map (* 3) . filter even $ numeros

-- Versión puramente Point-Free:
esMenorA100LaSumaDelTripleDeLosPares' :: Integral a => [a] -> Bool
esMenorA100LaSumaDelTripleDeLosPares' = (< 100) . sum . map (* 3) . filter even
