# Mullu

## En proceso

| (NAV)  | (PSC) | (BCO) | (RCRS) |
| --- | --- | --- | --- |
| Sistema de navegación | Mecánicas de Pesca | Mecánicas de Buceo | Recursos recolectados |

| (OCN) | (UPG) | (TOWN) | (ENC) | (MISC) |
| --- | --- | --- | --- | --- |
|  Mecánicas de Océano |  Sistema de mejoras | Sistema de la ciudad | Enciclopedia | Micelaneo |

### Prioridad Alta
- (BCO) Empezar escena
- (NAV) Mostrar acciones posibles (Agregar pesca, conectar)
- (PSC) Dar "vidas" (usos de anzuelos). Probar una cantidad de "vida", un success consume 1, un failure consume 2

### Prioridad Media
- (PSC) Mostrar silhueta de pescado encontrado antes de atrapar
- (NAV) Cambio de hora (4 horarios, reloj ciclico)
- (NAV) Hacer que el barco mire ligeramente hacia donde se esta moviendo


### Prioridad Baja
- (NAV) Animación y fluidez al mover barco (empezar un movimiento cuando se acabe el anterior)
- (NAV) Mostrar linea hacia tile elegida. Verde para posible, rojo para invalida
- (OCN) Rastro de barco en el agua al moverse (animación, partículas)
- (OCN) Oscurecer tiles fuera del rango de vision, o re-esconder en humo
- (PSC) Diferentes tipos de anzuelos, durabilidad
_____________________

## Martes 22 de Setiembre

**Diego**
- (PSC) Escena creada
- (PSC) Anzuelo que se mueve con WASD
- (PSC) Linea de pesca que sigue al anzuelo
- (PSC) Area limitada para anzuelo y peces
- (PSC) Mini juego de barra que mide el tiempo completo
- (PSC) Ventana de mini juego para pescar invocada

**Sergio**
- (NAV) Barra de energia completa

_____________________

## Lunes 21 de Setiembre

**Completo**
- (OCN) Fog of War (mar bloqueado por rocas, pero bloques inalcanzables si se ven. Dificil)
- (OCN) Resaltado de casillas seleccionables e invalidas
- (NAV) Mensajes con costo de movimiento y tipo de casilla
- (NAV) Cálculo de distancia basada en movimiento necesario, no distancia pura

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
