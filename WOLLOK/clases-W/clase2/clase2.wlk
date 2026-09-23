/*
 * ============================================================================
 * CLASE 2: PRINCIPIOS DE DISEÑO Y TESTING UNITARIO EN WOLLOK
 * ============================================================================
 * 
 * 1. PRINCIPIO KISS (Keep It Simple, Stupid):
 *    - Mantener el diseño lo más simple posible.
 *    - Preguntas clave para la asignación de responsabilidades:
 *      1. ¿De quién es la RESPONSABILIDAD de hacer algo?
 *      2. ¿Quién tiene la INFORMACIÓN MÍNIMA e indispensable?
 *
 * 2. EL TRIÁNGULO DE POO: RESPONSABILIDAD - ENCAPSULAMIENTO - POLIMORFISMO
 *    Estos tres conceptos están íntimamente conectados y forman el pilar del diseño orientado a objetos:
 *
 *    A. ENCAPSULAMIENTO (Proteger el estado y ocultar la implementación):
 *       - El estado (atributos) es privado. Ningún objeto externo puede modificar 
 *         directamente las variables de otro.
 *       - La única forma de comunicarse es mediante la interfaz de MENSAJES.
 *
 *    B. ASIGNACIÓN DE RESPONSABILIDADES (Tell, Don't Ask):
 *       - Quien posee la información tiene la responsabilidad de operar sobre ella.
 *       - En lugar de pedir la información a un objeto para modificarla afuera, se le 
 *         envía una orden al objeto para que él mismo haga el cambio.
 *
 *    C. POLIMORFISMO (Intercambiabilidad por Interfaz):
 *       - Como los objetos clientes interactúan mediante mensajes sin conocer los detalles 
 *         internos (Encapsulamiento) y cada objeto sabe responder su parte (Responsabilidad), 
 *         el cliente puede tratar de manera indistinta a cualquier objeto que comparta esa interfaz.
 *
 *    EJEMPLO PRÁCTICO EN EL CÓDIGO (utnTech y empleado):
 *      utnTech.cumplirAnio(empleado) --> ejecuta 'empleado.cumplirAnio()'
 *      - Encapsulamiento: utnTech no hace 'empleado.aniosAntiguedad = aniosAntiguedad + 1'.
 *      - Responsabilidad: Se la delega al empleado, que es el dueño de la variable 'aniosAntiguedad'.
 *      - Polimorfismo: utnTech puede hacer cumplir años a Pepe o a cualquier otro empleado que entienda 'cumplirAnio()'.
 *
 * 3. TESTS UNITARIOS (Pruebas Automatizadas):
 *    - Sirven para probar distintos flujos (camino feliz) y casos borde (límites/errores).
 *
 *    ESTRUCTURA TRIPLE A (Dado / Cuando / Espero):
 *      1. DADO (Arrange / Given): Se prepara el escenario inicial (estado de los objetos).
 *      2. CUANDO (Act / When): Se ejecuta la acción o mensaje a evaluar.
 *      3. ESPERO (Assert / Then): Se verifica que el resultado sea el esperado con 'assert'.
 *
 *    ASERCIONES PRINCIPALES (assert):
 *      - assert.equals(esperado, obtenido): Compara que el valor obtenido sea exactamente el esperado.
 *      - assert.that(condicion): Verifica que una condición booleana sea true.
 *      - assert.notThat(condicion): Verifica que una condición booleana sea false.
 *      - assert.throwsException({ ... }): Verifica que un bloque lance una excepción/error.
 * ============================================================================
 */ 

 object utnTech {
    method cumplirAnio (empleado) {
        empleado.cumplirAnio()
   }
 }