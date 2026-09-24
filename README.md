# Mullu

## En proceso

| (NAV)  | (PSC) | (BCO) | (RCRS) |
| --- | --- | --- | --- |
| Sistema de navegación | Mecánicas de Pesca | Mecánicas de Buceo | Recursos recolectados |

| (OCN) | (UPG) | (TOWN) | (ENC) | (MISC) |
| --- | --- | --- | --- | --- |
|  Mecánicas de Océano |  Sistema de mejoras | Sistema de la ciudad | Enciclopedia | Micelaneo |

### Prioridad Alta
- (BCO) Usar los moluscos para iniciar minijuego
- (NAV) Cambio de hora (4 horarios, reloj ciclico)
- (PSC) Dar "vidas" (usos de anzuelos). Probar una cantidad de "vida", un success consume 1, un failure consume 2
- (MISC) Conectar de regreso a "navegacion" al terminar mini juegos

### Prioridad Media
- (PSC) Mostrar silhueta de pescado encontrado antes de atrapar
- (PSC) Cambiar tamaño de señales en base al tipo de pescado (usa un diccionario)
- (BCO) Moluscos que aparezcan de manera aleatoria al generar el map
- (NAV) Hacer que el barco mire horizontalmente hacia donde se esta moviendo
- (PSC/BCO) Condicion de "fin" para minijuego

### Prioridad Baja
- (NAV) Actualizar mapa fijo (cuando Game Design termine su borrador)
- (NAV) Animación y fluidez al mover barco (empezar un movimiento cuando se acabe el anterior)
- (OCN) Rastro de barco en el agua al moverse (animación, partículas)
- (PSC) Diferentes tipos de anzuelos, durabilidad
- (PSC) Diferentes tipos de peces
- (BCO) Texturas de piedras con parallax
- (BCO) Distintos tipos de moluscos (gracias Gomita)

_____________________

## Miércoles 23 de Setiembre

**Diego**
- (BCO) Mini juego de corte creado (huge)
- (BCO) Estilización de juego de recorte y apoyos visuales
- (BCO) Corte invocado con una tecla dentro de la escena de buceo
- (BCO) Profundidad mayor y libertad de movimiento en todas direcciones
- (OCN) Casillas de pesca vs buceo con particulas (aleatorio, conecta a mini juegos)
- (MISC) Menu de acciones creado. Puede mejorarse para tener otras opciones

_____________________

## Martes 22 de Setiembre

**Diego**
- (PSC) Escena creada
- (PSC) Anzuelo que se mueve con WASD
- (PSC) Linea de pesca que sigue al anzuelo
- (PSC) Area limitada para anzuelo y peces
- (PSC) Mini juego de barra que mide el tiempo completo
- (PSC) Ventana de mini juego para pescar invocada
- (BCO) Escena iniciada
- (BCO) Iluminación dinámica debajo del agua
- (BCO) Separación de movimiento horizontal (barco) y vertical (buzo)
- (NAV) Barra de energia estilizada
- (NAV) Linea para mostrar caminos validos/invalidos

**Sergio**
- (NAV) Barra de energia completa

_____________________

## Lunes 21 de Setiembre

**Completo**
- (OCN) Fog of War (mar bloqueado por rocas, pero bloques inalcanzables si se ven. Dificil)
- (OCN) Resaltado de casillas seleccionables e invalidas
- (NAV) Mensajes con costo de movimiento y tipo de casilla
- (NAV) Cálculo de distancia basada en movimiento necesario, no distancia pura
- (NAV) Barra de energia y costos (https://www.youtube.com/watch?v=5poF352bDsQ)

_____________________

## Domingo 20 de Setiembre

**Completo**
- (MISC) Github creado
- (NAV) Borrador de escena de navegación
- (NAV) Estilo de Hex Grid inicial escogido
- (NAV) Barco placeholder con movimiento básico
- (NAV) Click en casillas detectado
- (NAV) Movimiento fluido con camino hallado por breadth first search
- (NAV) 5 tipos de casillas distinguibles
- (OCN) Resaltar casillas validas donde esta el mouse
