# Mullu

## En proceso

| (NAV)  | (PSC) | (BCO) | (RCRS) |
| --- | --- | --- | --- |
| Sistema de navegación | Mecánicas de Pesca | Mecánicas de Buceo | Recursos recolectados |

| (OCN) | (UPG) | (TOWN) | (ENC) | (MISC) |
| --- | --- | --- | --- | --- |
|  Mecánicas de Océano |  Sistema de mejoras | Sistema de la ciudad | Enciclopedia | Micelaneo |

### Prioridad Alta
- (NAV) Barra de energia y costos claros
- (PSC) Empezar escena
- (BCO) Empezar escena

### Prioridad Media
- (NAV) Cambio de "horas" al hacer acciones
- (NAV) Mostrar acciones posibles
- (NAV) Crear reloj ciclico

### Prioridad Baja
- (NAV) Generación automática de nuevos mapas
- (NAV) Animación y fluidez al mover barco (empezar un movimiento cuando se acabe el anterior)
- (NAV) Mostrar linea hacia tile elegida. Verde para posible, rojo para invalida
- (NAV) Resolver visión hacia casillas inexplorables. Priorizar rocas tal vez, y una función separada
- (OCN) Rastro de barco en el agua al moverse (animación, partículas)
- (OCN) Oscurecer tiles fuera del rango de vision, o re-esconder en humo
- (MISC) Hallar optimizaciones y ajustar funciones para mejor velocidad

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
