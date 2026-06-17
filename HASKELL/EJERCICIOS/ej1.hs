--ej1
esMultiploDeTres :: Int -> Bool
esMultiploDeTres num = (mod num 3) == 0

--ej2
multiplo :: Int -> Int -> Bool
multiplo n1 n2 = (mod n1 n2) == 0

--ej3
cubo :: Int -> Int 
cubo n1 = n1 * n1 * n1

--ej4
area :: Float -> Float -> Float
area b h = b * h

--ej5
esBisiesto :: Int -> Bool
esBisiesto anio = (multiplo anio 400) || (multiplo anio 4) && not (multiplo anio 100)

--ej6
cToF :: Float -> Float
cToF grado = grado * (9 / 5) + 32

--ej7
fToC :: Float -> Float
fToC grado = (grado - 32) * (5/9)

--ej8
haceFrio :: Float -> Bool
haceFrio grado = (fToC grado) < 8

--ej9
mcm :: Int -> Int -> Int
mcm num1 num2 = (num1 * num2) `div` (gcd num1 num2)

--ej 10 a
max3 :: Int -> Int -> Int -> Int
max3 d1 d2 d3 = (max d3 . max d1) d2
--max3 d1 d2 d3 = max (max d1 d2) d3

min3 :: Int -> Int -> Int -> Int
min3 d1 d2 d3 = (min d3 . min d1) d2
--min3 d1 d2 d3 = min (min d1 d2) d3

dispersion :: Int -> Int -> Int -> Int
dispersion d1 d2 d3 =  max3 d1 d2 d3 - min3 d1 d2 d3

-- ej10 b
dParejos :: Int -> Int -> Int -> Bool
dParejos d1 d2 d3 = dispersion d1 d2 d3 < 30

dLocos :: Int -> Int -> Int -> Bool
dLocos d1 d2 d3 = dispersion d1 d2 d3 > 100

dNormales :: Int -> Int -> Int -> Bool
dNormales d1 d2 d3 = not (dParejos d1 d2 d3 || dLocos d1 d2 d3)

--ej11
pesoPino :: Float -> Float 
pesoPino cm = 
