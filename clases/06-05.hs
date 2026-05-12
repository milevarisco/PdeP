-- ==============================
-- LISTAS
-- ==============================

--[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

lista n m  -- lista de n a m
    | n == m = [n]
    | otherwise = n : lista (n + 1) m -- asi va de menor a mayor => si m < n el se hace un loop y nunca terminaria la lista

-- (..) hace listas de un num a otro, con cosas enumerable: [1 .. 10] -> lista del 1 al 10
--                                                          [2, 4 .. 10] -> lista de valores pares del 2 al 10
--                                                          [1 ..] -> lista infinita

-- LISTAS INFINITAS
repeat :: a -> [a] -- repite un valor infinitamente
repicate :: Int -> a -> [a] -- repite algo (a) una cantidad finita (Int) de veces
cycle :: [a] -> [a] -- agarra una lista y la concatena infinitamente
iterate :: (a -> a) -> a -> [a] -- itera una funcion con un valor infinitamente: (+1) 0 -> [0 1 2 3 ...]

take 4 $ filter (< 0) [-3 ..] -- no corta se quedaria en [_3, -2, -1





