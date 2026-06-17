--1)
data GuerreroZ = GuerreroZ {
    nombre :: String,
    nivelKi :: Float,
    raza :: Raza,
    ejercicios :: [Ejercicio],
    cansancio :: Float,
    personalidad :: Personalidad
}

data Raza = Humano | Namekiano | Saiyajin
data Personalidad = Sacado | Perezoso | Tramposo
type Ejercicio = (GuerreroZ -> GuerreroZ)

--ejemplo
gohan :: GuerreroZ
gohan = GuerreroZ "Gohan" 10000 Saiyajin [] 0 Perezoso

--Setters
setNombre :: (String -> String) -> GuerreroZ -> GuerreroZ
setNombre funcion guerrero = guerrero {
    nombre = funcion (nombre guerrero)
}

setNivelKi :: (Float -> Float) -> GuerreroZ -> GuerreroZ
setNivelKi funcion guerrero = guerrero {
    nivelKi = funcion (nivelKi guerrero)
}

setRaza :: (Raza -> Raza) -> GuerreroZ -> GuerreroZ
setRaza funcion guerrero = guerrero {
    raza = funcion (raza guerrero)
}

setEjercicios :: ([Ejercicio] -> [Ejercicio]) -> GuerreroZ -> GuerreroZ
setEjercicios funcion guerrero = guerrero {
    ejercicios = funcion (ejercicios guerrero)
}

setCansancio :: (Float -> Float) -> GuerreroZ -> GuerreroZ
setCansancio funcion guerrero = guerrero {
    cansancio = funcion (cansancio guerrero)
}

--2) 
esRaza :: GuerreroZ -> Raza -> Bool
esRaza guerrero razag = (raza guerrero) == razag

kiMayorA :: GuerreroZ -> Float -> Bool
kiMayorA guerrero num = (nivelKi guerrero) > num

esPoderoso :: GuerreroZ -> Bool 
esPoderoso guerrero = esRaza guerrero Saiyajin || kiMayorA guerrero 8000

aumentarCaracteristicas :: GuerreroZ -> (Float -> Float) -> (Float -> Float) -> GuerreroZ
aumentarCaracteristicas guerrero fun1 fun2 = setCansancio (fun1) . setNivelKi (fun2) $ guerrero

pressBanca :: Ejercicio
pressBanca guerrero = aumentarCaracteristicas guerrero (+ 100) (+ 90)

flexionesDeBrazo :: Ejercicio
flexionesDeBrazo guerrero = aumentarCaracteristicas guerrero (+50) id

saltosAlCajon :: Float -> Ejercicio
saltosAlCajon cmCajon guerrero = aumentarCaracteristicas guerrero (+ cmCajon/5) (+ cmCajon/10)

snatch :: Ejercicio
snatch guerrero 
    | esExperimentado guerrero = aumentarCaracteristicas guerrero (* 1.05) (* 1.1)
    | otherwise = aumentarCaracteristicas guerrero (+100) (id)

esExperimentado :: GuerreroZ -> Bool
esExperimentado guerrero = kiMayorA guerrero 22000

--3)
realizarEjercicio :: GuerreroZ -> Ejercicio -> GuerreroZ
realizarEjercicio guerrero ejercicio
    | estaExausto guerrero = aumentarCaracteristicas guerrero (id) (subtract (nivelKi guerrero)*0.02)
    | estaCansado guerrero = aumentarCaracteristicas (ejercicio guerrero) (*4) (*2)
    | otherwise = ejercicio guerrero

estaFresco, estaCansado, estaExausto :: GuerreroZ -> Bool
estaCansado guerrero = (cansancio guerrero) > 0.44 * (nivelKi guerrero)
estaExausto guerrero = (cansancio guerrero) > 0.72 * (nivelKi guerrero)
estaFresco guerrero = not (estaCansado guerrero || estaExausto guerrero)


--4)
rutinaSegunPersonalidad :: Personalidad -> [Ejercicio] -> [Ejercicio]
rutinaSegunPersonalidad Tramposo listaEjercicios = []
rutinaSegunPersonalidad Sacado listaEjercicios = listaEjercicios
rutinaSegunPersonalidad Perezoso listaEjercicios = agregarDescansos 5 listaEjercicios

agregarDescansos :: Float -> [Ejercicio] -> [Ejercicio]
agregarDescansos _ [] = []
agregarDescansos _ [x] = [x]
agregarDescansos minutos (x:xs) = x : (descanso minutos) : (agregarDescansos minutos xs)

cambiarRutina :: [Ejercicio] -> [Ejercicio] -> [Ejercicio]
cambiarRutina nueva vieja = nueva

armarRutina :: GuerreroZ -> [Ejercicio] -> GuerreroZ
armarRutina guerrero listaEjercicios = setEjercicios (cambiarRutina (rutinaSegunPersonalidad (personalidad guerrero) listaEjercicios)) guerrero

-- si es Tramposo: Devolveria un alista vacia por ende se conoce la rutina resultante
-- si es Sacado: Devolveria la misma rutina infinita por ende la lista se podria ejecutar y evaluar en una cantidad finita de elementos necesitados (evaluacion diferida), pero no podriamos saber su total
-- si es Perezoso: devolveria una lista infinita la cual se va a poder igualar por la evaluacion diferida no necesita evaluar cada elemento para hacerlo

--5 y 6 )
descanso :: Float -> Ejercicio
descanso minutos guerrero = setCansancio (subtract descansar minutos) guerrero

descansar :: Float -> Float
descansar 0 = 0
descansar num = (num + descansar (num-1))

realizarRutina :: GuerreroZ -> GuerreroZ
realizarRutina guerrero = foldl (realizarEjercicio) guerrero (ejercicios guerrero)

--7)
optimoDescanso :: GuerreroZ -> Int
optimoDescanso guerrero = head . reverse . takeWhile (noEstaCansado guerrero) $ [0 ..]

noEstaCansado :: GuerreroZ -> Float -> Bool 
noEstaCansado guerrero minutos = cansancio (descanso minutos guerrero) /= 0