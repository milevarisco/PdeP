factorial :: Int -> Int 
factorial n
    | n== 0 = 1
    | otherwise = n * factorial(n-1)

factorial' :: Int -> Int
factorial' 0 = 1 -- Caso Base
factorial' n = n * n factorial'(n-1) -- Caso Recursivo

-- Ahora que vimos data podemos ver la definicion de lista

data [a] = [] | a : [a]

-- definicion de head y tail

cabeza (x : xs) = x
cola (x : xs) = xs

-- definicion de funciones de listas con pattern matching y recursividad

tamaño [] = 0                --length
tamaño (x:xs) = 1 +  tamaño xs

revertir [] = []                   --reverse
revertir (x:xs) = revertir xs ++ [x]

concatenar [] lista2 = lista2               -- (++)
concatenar (x:xs) lista2 = x : (xs ++ lista2)

sumarLista [] = 0                    -- sum
sumarLista (x:xs) = x + sumarLista xs

productoLista [] = 1                       --product
productoLista (x:xs) = x * productoLista xs

y [] = True         --and
y (x:xs) = x && y xs

o [] = False        --or
o (x:xs) = x || o xs

concatenarListar [] = []                                 --concat
concatenarListar (xs : xss) = xs concatenar concatenarListar xss


-- funcion generica para estos casos

sumarListas' lista = plegar (+) 0 lista
productoLista' lista = plegar (*) 1 lista
y' lista = plegar (&&) True lista
o' lista = plegar (||) False lista
concatenarListar' lista = plegar (++) [] lista

plegar operador casoBase [] = casoBase  --foldr
plegar operador casoBase (x:xs) = operador x (plegar operador casoBase xs)

-- tipado de foldr
foldr :: ( b -> a -> a ) -> a -> [b] -> a
foldl :: ( a -> b -> a ) -> a -> [b] -> a

-- length con foldr
tamaño' lista = foldr (\x r -> 1 + r) 0 lista 



mapear f [] = []               -- map
mapear f (x:xs) = f x : map f xs

filtrar condicion [] = []                  -- filter
filtrar condicion (x:xs)
    | condicion x = x : filtrar condicion xs
    | otherwise = filtrar condicion xs